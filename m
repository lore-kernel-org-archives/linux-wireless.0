Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:34887 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbeCMV7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 17:59:54 -0400
Received: by mail-pl0-f66.google.com with SMTP id w22-v6so603244pll.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2018 14:59:53 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v5 1/9] nl80211: Add CMD_CONTROL_PORT_FRAME API
Date: Tue, 13 Mar 2018 16:59:34 -0500
Message-Id: <20180313215942.29176-2-denkenz@gmail.com> (sfid-20180313_230003_779075_2C010BE3)
In-Reply-To: <20180313215942.29176-1-denkenz@gmail.com>
References: <20180313215942.29176-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit also adds cfg80211_rx_control_port function.  This is used
to generate a CMD_CONTROL_PORT_FRAME event out to userspace.  The
conn_owner_nlportid is used as the unicast destination.  This means that
userspace must specify NL80211_ATTR_SOCKET_OWNER flag if control port
over nl80211 routing is requested in NL80211_CMD_CONNECT,
NL80211_CMD_ASSOCIATE or NL80211_CMD_START_AP

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       | 22 +++++++++++++++++
 include/uapi/linux/nl80211.h | 13 ++++++++++
 net/wireless/nl80211.c       | 58 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 21 ++++++++++++++++
 4 files changed, 114 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc40843baed3..6dee630ee66d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5694,6 +5694,28 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 
 
 /**
+ * cfg80211_rx_control_port - notification about a received control port frame
+ * @dev: The device the frame matched to
+ * @buf: control port frame
+ * @len: length of the frame data
+ * @addr: The peer from which the frame was received
+ * @proto: frame protocol, typically PAE or Pre-authentication
+ * @unencrypted: Whether the frame was received unencrypted
+ *
+ * This function is used to inform userspace about a received control port
+ * frame.  It should only be used if userspace indicated it wants to receive
+ * control port frames over NL80211.
+ *
+ * The frame is the data portion of the 802.3 or 802.11 data frame with all
+ * network layer headers removed (e.g. the raw EAPoL frame).
+ *
+ * Return: %true if the frame was passed to userspace
+ */
+bool cfg80211_rx_control_port(struct net_device *dev,
+			      const u8 *buf, size_t len,
+			      const u8 *addr, u16 proto, bool unencrypted);
+
+/**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
  * @dev: network device
  * @rssi_event: the triggered RSSI event
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c13c84304be3..1334f810f7b4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -990,6 +990,17 @@
  *	&NL80211_CMD_CONNECT or &NL80211_CMD_ROAM. If the 4 way handshake failed
  *	&NL80211_CMD_DISCONNECT should be indicated instead.
  *
+ * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
+ *	and RX notification.  This command is used both as a request to transmit
+ *	a control port frame and as a notification that a control port frame
+ *	has been received. %NL80211_ATTR_FRAME is used to specify the
+ *	frame contents.  The frame is the raw EAPoL data, without ethernet or
+ *	802.11 headers.
+ *	When used as an event indication %NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT and %NL80211_ATTR_MAC are added
+ *	indicating the protocol type of the received frame; whether the frame
+ *	was received unencrypted and the MAC address of the peer respectively.
+ *
  * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
  *
  * @NL80211_CMD_EXTERNAL_AUTH: This interface is exclusively defined for host
@@ -1228,6 +1239,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_STA_OPMODE_CHANGED,
 
+	NL80211_CMD_CONTROL_PORT_FRAME,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a910150f8169..d7dcc2d05025 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14535,6 +14535,64 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 }
 EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
+static int __nl80211_rx_control_port(struct net_device *dev,
+				     const u8 *buf, size_t len,
+				     const u8 *addr, u16 proto,
+				     bool unencrypted, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	u32 nlportid = READ_ONCE(wdev->conn_owner_nlportid);
+
+	if (!nlportid)
+		return -ENOENT;
+
+	msg = nlmsg_new(100 + len, gfp);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CONTROL_PORT_FRAME);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return -ENOMEM;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD) ||
+	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
+	    nla_put_u16(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE, proto) ||
+	    (unencrypted && nla_put_flag(msg,
+					 NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT)))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
+
+ nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+bool cfg80211_rx_control_port(struct net_device *dev,
+			      const u8 *buf, size_t len,
+			      const u8 *addr, u16 proto, bool unencrypted)
+{
+	int ret;
+
+	trace_cfg80211_rx_control_port(dev, buf, len, addr, proto, unencrypted);
+	ret = __nl80211_rx_control_port(dev, buf, len, addr, proto,
+					unencrypted, GFP_ATOMIC);
+	trace_cfg80211_return_bool(ret == 0);
+	return ret;
+}
+EXPORT_SYMBOL(cfg80211_rx_control_port);
+
 static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 					    const char *mac, gfp_t gfp)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938b358d..24e84dfe54fd 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2600,6 +2600,27 @@ TRACE_EVENT(cfg80211_mgmt_tx_status,
 		  WDEV_PR_ARG, __entry->cookie, BOOL_TO_STR(__entry->ack))
 );
 
+TRACE_EVENT(cfg80211_rx_control_port,
+	TP_PROTO(struct net_device *netdev, const u8 *buf, size_t len,
+		 const u8 *addr, u16 proto, bool unencrypted),
+	TP_ARGS(netdev, buf, len, addr, proto, unencrypted),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+		__field(u16, proto)
+		__field(bool, unencrypted)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+		__entry->proto = proto;
+		__entry->unencrypted = unencrypted;
+	),
+	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT " proto: %x, unencrypted: %s",
+		  NETDEV_PR_ARG, MAC_PR_ARG(addr),
+		  __entry->proto, BOOL_TO_STR(__entry->unencrypted))
+);
+
 TRACE_EVENT(cfg80211_cqm_rssi_notify,
 	TP_PROTO(struct net_device *netdev,
 		 enum nl80211_cqm_rssi_threshold_event rssi_event,
-- 
2.13.5
