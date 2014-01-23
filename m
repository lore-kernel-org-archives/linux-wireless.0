Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaAWP21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:28:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add length check in ieee80211_is_robust_mgmt_frame()
Date: Thu, 23 Jan 2014 16:28:21 +0100
Message-Id: <1390490901-31868-1-git-send-email-johannes@sipsolutions.net> (sfid-20140123_162842_786595_3E619620)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A few places weren't checking that the frame passed to the
function actually has enough data even though the function
clearly documents it must have a payload byte. Make this
safer by changing the function to take an skb and checking
the length inside. The old version is preserved for now as
the rtl* drivers use it and don't have a correct skb.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |  2 +-
 include/linux/ieee80211.h                    | 15 +++++++++++++--
 net/mac80211/rx.c                            | 13 ++++++-------
 net/mac80211/tx.c                            |  9 ++++-----
 net/mac80211/wpa.c                           |  2 +-
 8 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index aece6c9..27ace30 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -452,7 +452,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 			/* During testing, hdr was NULL */
 			return false;
 		}
-		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
 		    (ieee80211_has_protected(hdr->frame_control)))
 			rx_status->flag &= ~RX_FLAG_DECRYPTED;
 		else
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 52abf0a..114858d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -393,7 +393,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 			/* In testing, hdr was NULL here */
 			return false;
 		}
-		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
 		    (ieee80211_has_protected(hdr->frame_control)))
 			rx_status->flag &= ~RX_FLAG_DECRYPTED;
 		else
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 27efbcd..163a681 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -310,7 +310,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 			/* during testing, hdr was NULL here */
 			return false;
 		}
-		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
 			(ieee80211_has_protected(hdr->frame_control)))
 			rx_status->flag &= ~RX_FLAG_DECRYPTED;
 		else
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index 50b7be3..721162c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -334,7 +334,7 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 			/* during testing, hdr could be NULL here */
 			return false;
 		}
-		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
 			(ieee80211_has_protected(hdr->frame_control)))
 			rx_status->flag &= ~RX_FLAG_DECRYPTED;
 		else
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 65eba86..fdd5bff 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2194,10 +2194,10 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 }
 
 /**
- * ieee80211_is_robust_mgmt_frame - check if frame is a robust management frame
+ * _ieee80211_is_robust_mgmt_frame - check if frame is a robust management frame
  * @hdr: the frame (buffer must include at least the first octet of payload)
  */
-static inline bool ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
+static inline bool _ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
 {
 	if (ieee80211_is_disassoc(hdr->frame_control) ||
 	    ieee80211_is_deauth(hdr->frame_control))
@@ -2226,6 +2226,17 @@ static inline bool ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
 }
 
 /**
+ * ieee80211_is_robust_mgmt_frame - check if skb contains a robust mgmt frame
+ * @skb: the skb containing the frame, length will be checked
+ */
+static inline bool ieee80211_is_robust_mgmt_frame(struct sk_buff *skb)
+{
+	if (skb->len < 25)
+		return false;
+	return _ieee80211_is_robust_mgmt_frame((void *)skb->data);
+}
+
+/**
  * ieee80211_is_public_action - check if frame is a public action frame
  * @hdr: the frame
  * @len: length of the frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8a6274a..6f76da6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -601,10 +601,10 @@ static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (skb->len < 24 || is_multicast_ether_addr(hdr->addr1))
+	if (is_multicast_ether_addr(hdr->addr1))
 		return 0;
 
-	return ieee80211_is_robust_mgmt_frame(hdr);
+	return ieee80211_is_robust_mgmt_frame(skb);
 }
 
 
@@ -612,10 +612,10 @@ static int ieee80211_is_multicast_robust_mgmt_frame(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (skb->len < 24 || !is_multicast_ether_addr(hdr->addr1))
+	if (!is_multicast_ether_addr(hdr->addr1))
 		return 0;
 
-	return ieee80211_is_robust_mgmt_frame(hdr);
+	return ieee80211_is_robust_mgmt_frame(skb);
 }
 
 
@@ -628,7 +628,7 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	if (skb->len < 24 + sizeof(*mmie) || !is_multicast_ether_addr(hdr->da))
 		return -1;
 
-	if (!ieee80211_is_robust_mgmt_frame((struct ieee80211_hdr *) hdr))
+	if (!ieee80211_is_robust_mgmt_frame(skb))
 		return -1; /* not a robust management frame */
 
 	mmie = (struct ieee80211_mmie *)
@@ -1854,8 +1854,7 @@ static int ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 		 * having configured keys.
 		 */
 		if (unlikely(ieee80211_is_action(fc) && !rx->key &&
-			     ieee80211_is_robust_mgmt_frame(
-				     (struct ieee80211_hdr *) rx->skb->data)))
+			     ieee80211_is_robust_mgmt_frame(rx->skb)))
 			return -EACCES;
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6259bc5..a33ab2d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -452,8 +452,7 @@ static int ieee80211_use_mfp(__le16 fc, struct sta_info *sta,
 	if (sta == NULL || !test_sta_flag(sta, WLAN_STA_MFP))
 		return 0;
 
-	if (!ieee80211_is_robust_mgmt_frame((struct ieee80211_hdr *)
-					    skb->data))
+	if (!ieee80211_is_robust_mgmt_frame(skb))
 		return 0;
 
 	return 1;
@@ -564,7 +563,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
-		 ieee80211_is_robust_mgmt_frame(hdr) &&
+		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
 		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
 		tx->key = key;
 	else if (is_multicast_ether_addr(hdr->addr1) &&
@@ -579,12 +578,12 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		tx->key = NULL;
 	else if (tx->skb->protocol == tx->sdata->control_port_protocol)
 		tx->key = NULL;
-	else if (ieee80211_is_robust_mgmt_frame(hdr) &&
+	else if (ieee80211_is_robust_mgmt_frame(tx->skb) &&
 		 !(ieee80211_is_action(hdr->frame_control) &&
 		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))
 		tx->key = NULL;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
-		 !ieee80211_is_robust_mgmt_frame(hdr))
+		 !ieee80211_is_robust_mgmt_frame(tx->skb))
 		tx->key = NULL;
 	else {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 4aed45c..b8600e3 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -494,7 +494,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (!ieee80211_is_data(hdr->frame_control) &&
-	    !ieee80211_is_robust_mgmt_frame(hdr))
+	    !ieee80211_is_robust_mgmt_frame(skb))
 		return RX_CONTINUE;
 
 	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN -
-- 
1.8.5.2

