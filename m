Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:40858 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbdL1R6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 12:58:39 -0500
Received: by mail-io0-f196.google.com with SMTP id v30so7264967iov.7
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 09:58:39 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC 2/4] nl80211: Add CMD_CONTROL_PORT_FRAME API
Date: Thu, 28 Dec 2017 11:58:30 -0600
Message-Id: <20171228175832.3253-3-denkenz@gmail.com> (sfid-20171228_185852_658589_34811D97)
In-Reply-To: <20171228175832.3253-1-denkenz@gmail.com>
References: <20171228175832.3253-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit also adds cfg80211_rx_control_port function.  This is used
to generate a CMD_CONTROL_PORT_FRAME event out to userspace.  The
conn_owner_nlportid is used as the unicast destination.  This means that
userspace must specify NL80211_ATTR_SOCKET_OWNER flag if control port
over nl80211 routing is requested in NL80211_CMD_CONNECT or
NL80211_CMD_ASSOCIATE

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       | 15 +++++++++++
 include/uapi/linux/nl80211.h | 15 +++++++++++
 net/wireless/nl80211.c       | 62 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 15 +++++++++++
 4 files changed, 107 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0aa1c866a73b..cc480e252367 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5626,6 +5626,21 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 
 
 /**
+ * cfg80211_rx_control_port - inform userspace about a received control port
+ * frame, e.g. EAPoL.  This is used if userspace has specified it wants to
+ * receive control port frames over NL80211.
+ * @dev: The device the frame matched to
+ * @buf: control port frame
+ * @len: length of the frame data
+ * @unencrypted: Whether the frame was received unencrypted
+ *
+ * Return: %true if the frame was passed to userspace
+ */
+bool cfg80211_rx_control_port(struct wireless_dev *wdev,
+			      const u8 *buf, size_t len,
+			      const u8 *addr, u16 proto, bool unencrypted);
+
+/**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
  * @dev: network device
  * @rssi_event: the triggered RSSI event
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8855b7eaf92c..b902614e876e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -991,6 +991,17 @@
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
  * @NL80211_CMD_MAX: highest used command number
@@ -1199,6 +1210,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_RELOAD_REGDB,
 
+	NL80211_CMD_CONTROL_PORT_FRAME,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1446,6 +1459,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT: When included along with
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE, indicates that the custom
  *	ethertype frames used for key negotiation must not be encrypted.
+ *	When included in %NL80211_CMD_CONTROL_PORT_FRAME it means that the
+ *	control port frame was received unencrypted.
  * @NL80211_ATTR_CONTROL_PORT_OVER_NL80211: A flag indicating whether control
  *	port frames (e.g. of type given in %NL80211_ATTR_CONTROL_PORT_ETHERTYPE)
  *	will be sent directly to the network interface or sent via the NL80211
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f5b4008f40da..220fe5bc57fd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14490,6 +14490,68 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 }
 EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
+static int __nl80211_control_port(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev,
+				  const u8 *buf, size_t len,
+				  const u8 *addr, u16 proto,
+				  bool unencrypted, gfp_t gfp)
+{
+	struct net_device *netdev = wdev->netdev;
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
+	    (netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					netdev->ifindex)) ||
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
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+bool cfg80211_rx_control_port(struct wireless_dev *wdev,
+			      const u8 *buf, size_t len,
+			      const u8 *addr, u16 proto, bool unencrypted)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	bool ret;
+
+	trace_cfg80211_rx_control_port(wdev, unencrypted);
+	ret = __nl80211_control_port(rdev, wdev, buf, len, addr, proto,
+				     unencrypted, GFP_ATOMIC);
+	trace_cfg80211_return_bool(ret);
+	return ret;
+}
+EXPORT_SYMBOL(cfg80211_rx_control_port);
+
 static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 					    const char *mac, gfp_t gfp)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index bcfedd39e7a3..1703a0fa315b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2577,6 +2577,21 @@ TRACE_EVENT(cfg80211_mgmt_tx_status,
 		  WDEV_PR_ARG, __entry->cookie, BOOL_TO_STR(__entry->ack))
 );
 
+TRACE_EVENT(cfg80211_rx_control_port,
+	TP_PROTO(struct wireless_dev *wdev, bool unencrypted),
+	TP_ARGS(wdev, unencrypted),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(bool, unencrypted)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->unencrypted = unencrypted;
+	),
+	TP_printk(WDEV_PR_FMT", unencrypted: %s",
+		  WDEV_PR_ARG, BOOL_TO_STR(__entry->unencrypted))
+);
+
 TRACE_EVENT(cfg80211_cqm_rssi_notify,
 	TP_PROTO(struct net_device *netdev,
 		 enum nl80211_cqm_rssi_threshold_event rssi_event,
-- 
2.13.5
