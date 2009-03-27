Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54738 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbZC0UAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 16:00:08 -0400
Date: Fri, 27 Mar 2009 21:59:49 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Add Michael MIC failure event
Message-ID: <20090327195949.GA23671@jm.kir.nu> (sfid-20090327_210014_274907_A8A22A5A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define a new nl80211 event, NL80211_CMD_MICHAEL_MIC_FAILURE, to be
used to notify user space about locally detected Michael MIC failures.
This matches with the MLME-MICHAELMICFAILURE.indication() primitive.

Since we do not actually have TSC in the skb anymore when
mac80211_ev_michael_mic_failure() is called, that function is changed
to take in the TSC as an optional parameter instead of as a
requirement to include the TSC after the hdr field (which we did not
really follow). For now, TSC is not included in the events from
mac80211, but it could be added at some point.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h    |   28 ++++++++++++++++++++++++++++
 include/net/cfg80211.h     |   16 ++++++++++++++++
 net/mac80211/event.c       |   17 +++++++++--------
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/rx.c          |    2 +-
 net/mac80211/wpa.c         |    2 +-
 net/wireless/mlme.c        |   10 ++++++++++
 net/wireless/nl80211.c     |   40 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h     |    5 +++++
 9 files changed, 111 insertions(+), 11 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-03-27 20:57:04.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-03-27 21:05:02.000000000 +0200
@@ -199,6 +199,14 @@
  *	NL80211_CMD_AUTHENTICATE but for Disassociation frames (similar to
  *	MLME-DISASSOCIATE.request and MLME-DISASSOCIATE.indication primitives).
  *
+ * @NL80211_CMD_MICHAEL_MIC_FAILURE: notification of a locally detected Michael
+ *	MIC (part of TKIP) failure; sent on the "mlme" multicast group; the
+ *	event includes %NL80211_ATTR_MAC to describe the source MAC address of
+ *	the frame with invalid MIC, %NL80211_ATTR_KEY_TYPE to show the key
+ *	type, %NL80211_ATTR_KEY_IDX to indicate the key identifier, and
+ *	%NL80211_ATTR_KEY_SEQ to indicate the TSC value of the frame; this
+ *	event matches with MLME-MICHAELMICFAILURE.indication() primitive
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -260,6 +268,8 @@ enum nl80211_commands {
 	NL80211_CMD_DEAUTHENTICATE,
 	NL80211_CMD_DISASSOCIATE,
 
+	NL80211_CMD_MICHAEL_MIC_FAILURE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -410,6 +420,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_REASON_CODE: ReasonCode for %NL80211_CMD_DEAUTHENTICATE and
  *	%NL80211_CMD_DISASSOCIATE, u16
  *
+ * @NL80211_ATTR_KEY_TYPE: Key Type, see &enum nl80211_key_type, represented as
+ *	a u32
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -496,6 +509,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_SCAN_IE_LEN,
 
+	NL80211_ATTR_KEY_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1066,4 +1081,17 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
 };
+
+/**
+ * enum nl80211_key_type - Key Type
+ * @NL80211_KEYTYPE_GROUP: Group (broadcast/multicast) key
+ * @NL80211_KEYTYPE_PAIRWISE: Pairwise (unicast/individual) key
+ * @NL80211_KEYTYPE_PEERKEY: PeerKey (DLS)
+ */
+enum nl80211_key_type {
+	NL80211_KEYTYPE_GROUP,
+	NL80211_KEYTYPE_PAIRWISE,
+	NL80211_KEYTYPE_PEERKEY,
+};
+
 #endif /* __LINUX_NL80211_H */
--- uml.orig/include/net/cfg80211.h	2009-03-27 21:05:31.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-03-27 21:09:57.000000000 +0200
@@ -958,4 +958,20 @@ void cfg80211_hold_bss(struct cfg80211_b
  */
 void cfg80211_unhold_bss(struct cfg80211_bss *bss);
 
+/**
+ * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
+ * @dev: network device
+ * @addr: The source MAC address of the frame
+ * @key_type: The key type that the received frame used
+ * @key_id: Key identifier (0..3)
+ * @tsc: The TSC value of the frame that generated the MIC failure (6 octets)
+ *
+ * This function is called whenever the local MAC detects a MIC failure in a
+ * received frame. This matches with MLME-MICHAELMICFAILURE.indication()
+ * primitive.
+ */
+void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
+				  enum nl80211_key_type key_type, int key_id,
+				  const u8 *tsc);
+
 #endif /* __NET_CFG80211_H */
--- uml.orig/net/mac80211/event.c	2009-03-27 21:21:38.000000000 +0200
+++ uml/net/mac80211/event.c	2009-03-27 21:29:35.000000000 +0200
@@ -12,12 +12,12 @@
 #include "ieee80211_i.h"
 
 /*
- * indicate a failed Michael MIC to userspace; the passed packet
- * (in the variable hdr) must be long enough to extract the TKIP
- * fields like TSC
+ * Indicate a failed Michael MIC to userspace. If the caller knows the TSC of
+ * the frame that generated the MIC failure (i.e., if it was provided by the
+ * driver or is still in the frame), it should provide that information.
  */
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr)
+				     struct ieee80211_hdr *hdr, const u8 *tsc)
 {
 	union iwreq_data wrqu;
 	char *buf = kmalloc(128, GFP_ATOMIC);
@@ -34,8 +34,9 @@ void mac80211_ev_michael_mic_failure(str
 		kfree(buf);
 	}
 
-	/*
-	 * TODO: re-add support for sending MIC failure indication
-	 * with all info via nl80211
-	 */
+	cfg80211_michael_mic_failure(sdata->dev, hdr->addr2,
+				     (hdr->addr1[0] & 0x01) ?
+				     NL80211_KEYTYPE_GROUP :
+				     NL80211_KEYTYPE_PAIRWISE,
+				     keyidx, tsc);
 }
--- uml.orig/net/mac80211/ieee80211_i.h	2009-03-27 21:26:23.000000000 +0200
+++ uml/net/mac80211/ieee80211_i.h	2009-03-27 21:27:01.000000000 +0200
@@ -1067,7 +1067,7 @@ u8 *ieee80211_get_bssid(struct ieee80211
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr);
+				     struct ieee80211_hdr *hdr, const u8 *tsc);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt);
--- uml.orig/net/mac80211/rx.c	2009-03-27 21:26:20.000000000 +0200
+++ uml/net/mac80211/rx.c	2009-03-27 21:26:49.000000000 +0200
@@ -1928,7 +1928,7 @@ static void ieee80211_rx_michael_mic_rep
 	    !ieee80211_is_auth(hdr->frame_control))
 		goto ignore;
 
-	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr);
+	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr, NULL);
  ignore:
 	dev_kfree_skb(rx->skb);
 	rx->skb = NULL;
--- uml.orig/net/mac80211/wpa.c	2009-03-27 21:26:18.000000000 +0200
+++ uml/net/mac80211/wpa.c	2009-03-27 21:54:26.000000000 +0200
@@ -122,7 +122,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 			return RX_DROP_UNUSABLE;
 
 		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
-						(void *) skb->data);
+						(void *) skb->data, NULL);
 		return RX_DROP_UNUSABLE;
 	}
 
--- uml.orig/net/wireless/mlme.c	2009-03-27 21:10:47.000000000 +0200
+++ uml/net/wireless/mlme.c	2009-03-27 21:11:30.000000000 +0200
@@ -43,3 +43,13 @@ void cfg80211_send_disassoc(struct net_d
 	nl80211_send_disassoc(rdev, dev, buf, len);
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
+
+void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
+				  enum nl80211_key_type key_type, int key_id,
+				  const u8 *tsc)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc);
+}
+EXPORT_SYMBOL(cfg80211_michael_mic_failure);
--- uml.orig/net/wireless/nl80211.c	2009-03-27 21:11:37.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-27 21:19:41.000000000 +0200
@@ -3438,6 +3438,46 @@ void nl80211_send_disassoc(struct cfg802
 				NL80211_CMD_DISASSOCIATE);
 }
 
+void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev, const u8 *addr,
+				 enum nl80211_key_type key_type, int key_id,
+				 const u8 *tsc)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_MICHAEL_MIC_FAILURE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	if (addr)
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
+	NLA_PUT_U32(msg, NL80211_ATTR_KEY_TYPE, key_type);
+	NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, key_id);
+	if (tsc)
+		NLA_PUT(msg, NL80211_ATTR_KEY_SEQ, 6, tsc);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
--- uml.orig/net/wireless/nl80211.h	2009-03-27 21:11:37.000000000 +0200
+++ uml/net/wireless/nl80211.h	2009-03-27 21:19:37.000000000 +0200
@@ -23,5 +23,10 @@ extern void nl80211_send_deauth(struct c
 extern void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 				  struct net_device *netdev,
 				  const u8 *buf, size_t len);
+extern void
+nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *addr,
+			    enum nl80211_key_type key_type,
+			    int key_id, const u8 *tsc);
 
 #endif /* __NET_WIRELESS_NL80211_H */

-- 
Jouni Malinen                                            PGP id EFC895FA
