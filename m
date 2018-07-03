Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36152 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGCUF7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 16:05:59 -0400
Received: by mail-oi0-f51.google.com with SMTP id r16-v6so6326350oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2018 13:05:59 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        arend.vanspriel@broadcom.com
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v2] nl80211/mac80211: allow non-linear skb in rx_control_port
Date: Tue,  3 Jul 2018 15:05:48 -0500
Message-Id: <20180703200548.3057-1-denkenz@gmail.com> (sfid-20180703_220757_164318_15C8CCFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current implementation of cfg80211_rx_control_port assumed that the
caller could provide a contiguous region of memory for the control port
frame to be sent up to userspace.  Unfortunately, many drivers produce
non-linear skbs, especially for data frames.  This resulted in userspace
getting notified of control port frames with correct metadata (from
address, port, etc) yet garbage / nonsense contents, resulting in bad
handshakes, disconnections, etc.

mac80211 linearizes skbs containing management frames.  But it didn't
seem worthwhile to do this for control port frames.  Thus the signature
of cfg80211_rx_control_port was changed to take the skb directly.
nl80211 then takes care of obtaining control port frame data directly
from the (linear | non-linear) skb.

The caller is still responsible for freeing the skb,
cfg80211_rx_control_port does not take ownership of it.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---

v2 changes:
- Reword commit header
- Rework tracing slightly per Arend's feedback
- Added blurb about skb->protocol in include/net/cfg80211.h

 include/net/cfg80211.h | 12 ++++++------
 net/mac80211/rx.c      |  5 +----
 net/wireless/nl80211.c | 24 +++++++++++++++---------
 net/wireless/trace.h   | 18 ++++++++++--------
 4 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9ba1f289c439..beed5b2a3933 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5937,10 +5937,11 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 /**
  * cfg80211_rx_control_port - notification about a received control port frame
  * @dev: The device the frame matched to
- * @buf: control port frame
- * @len: length of the frame data
- * @addr: The peer from which the frame was received
- * @proto: frame protocol, typically PAE or Pre-authentication
+ * @skb: The skbuf with the control port frame.  It is assumed that the skbuf
+ * is 802.3 formatted (with 802.3 header).  The skb can be non-linear.  This
+ * function does not take ownership of the skb, so the caller is responsible
+ * for any cleanup.  The caller must also ensure that skb->protocol is set
+ * appropriately.
  * @unencrypted: Whether the frame was received unencrypted
  *
  * This function is used to inform userspace about a received control port
@@ -5953,8 +5954,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
  * Return: %true if the frame was passed to userspace
  */
 bool cfg80211_rx_control_port(struct net_device *dev,
-			      const u8 *buf, size_t len,
-			      const u8 *addr, u16 proto, bool unencrypted);
+			      struct sk_buff *skb, bool unencrypted);
 
 /**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a16ba568e2a3..64742f2765c4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2370,11 +2370,8 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 		     sdata->control_port_over_nl80211)) {
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 		bool noencrypt = status->flag & RX_FLAG_DECRYPTED;
-		struct ethhdr *ehdr = eth_hdr(skb);
 
-		cfg80211_rx_control_port(dev, skb->data, skb->len,
-					 ehdr->h_source,
-					 be16_to_cpu(skb->protocol), noencrypt);
+		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
 	} else {
 		/* deliver to local stack */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8db59129c095..b75a0144c0a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15036,20 +15036,24 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
 static int __nl80211_rx_control_port(struct net_device *dev,
-				     const u8 *buf, size_t len,
-				     const u8 *addr, u16 proto,
+				     struct sk_buff *skb,
 				     bool unencrypted, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct ethhdr *ehdr = eth_hdr(skb);
+	const u8 *addr = ehdr->h_source;
+	u16 proto = be16_to_cpu(skb->protocol);
 	struct sk_buff *msg;
 	void *hdr;
+	struct nlattr *frame;
+
 	u32 nlportid = READ_ONCE(wdev->conn_owner_nlportid);
 
 	if (!nlportid)
 		return -ENOENT;
 
-	msg = nlmsg_new(100 + len, gfp);
+	msg = nlmsg_new(100 + skb->len, gfp);
 	if (!msg)
 		return -ENOMEM;
 
@@ -15063,13 +15067,17 @@ static int __nl80211_rx_control_port(struct net_device *dev,
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
 			      NL80211_ATTR_PAD) ||
-	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
 	    nla_put_u16(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE, proto) ||
 	    (unencrypted && nla_put_flag(msg,
 					 NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT)))
 		goto nla_put_failure;
 
+	frame = nla_reserve(msg, NL80211_ATTR_FRAME, skb->len);
+	if (!frame)
+		goto nla_put_failure;
+
+	skb_copy_bits(skb, 0, nla_data(frame), skb->len);
 	genlmsg_end(msg, hdr);
 
 	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
@@ -15080,14 +15088,12 @@ static int __nl80211_rx_control_port(struct net_device *dev,
 }
 
 bool cfg80211_rx_control_port(struct net_device *dev,
-			      const u8 *buf, size_t len,
-			      const u8 *addr, u16 proto, bool unencrypted)
+			      struct sk_buff *skb, bool unencrypted)
 {
 	int ret;
 
-	trace_cfg80211_rx_control_port(dev, buf, len, addr, proto, unencrypted);
-	ret = __nl80211_rx_control_port(dev, buf, len, addr, proto,
-					unencrypted, GFP_ATOMIC);
+	trace_cfg80211_rx_control_port(dev, skb, unencrypted);
+	ret = __nl80211_rx_control_port(dev, skb, unencrypted, GFP_ATOMIC);
 	trace_cfg80211_return_bool(ret == 0);
 	return ret == 0;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b417a2fe63f..7c73510b161f 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2627,23 +2627,25 @@ TRACE_EVENT(cfg80211_mgmt_tx_status,
 );
 
 TRACE_EVENT(cfg80211_rx_control_port,
-	TP_PROTO(struct net_device *netdev, const u8 *buf, size_t len,
-		 const u8 *addr, u16 proto, bool unencrypted),
-	TP_ARGS(netdev, buf, len, addr, proto, unencrypted),
+	TP_PROTO(struct net_device *netdev, struct sk_buff *skb,
+		 bool unencrypted),
+	TP_ARGS(netdev, skb, unencrypted),
 	TP_STRUCT__entry(
 		NETDEV_ENTRY
-		MAC_ENTRY(addr)
+		__field(int, len)
+		MAC_ENTRY(from)
 		__field(u16, proto)
 		__field(bool, unencrypted)
 	),
 	TP_fast_assign(
 		NETDEV_ASSIGN;
-		MAC_ASSIGN(addr, addr);
-		__entry->proto = proto;
+		__entry->len = skb->len;
+		MAC_ASSIGN(from, eth_hdr(skb)->h_source);
+		__entry->proto = be16_to_cpu(skb->protocol);
 		__entry->unencrypted = unencrypted;
 	),
-	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT " proto: 0x%x, unencrypted: %s",
-		  NETDEV_PR_ARG, MAC_PR_ARG(addr),
+	TP_printk(NETDEV_PR_FMT ", len=%d, " MAC_PR_FMT ", proto: 0x%x, unencrypted: %s",
+		  NETDEV_PR_ARG, __entry->len, MAC_PR_ARG(from),
 		  __entry->proto, BOOL_TO_STR(__entry->unencrypted))
 );
 
-- 
2.13.5
