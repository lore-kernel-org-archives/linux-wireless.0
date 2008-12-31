Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46671 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756746AbYLaPmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:12 -0500
Message-Id: <20081231154203.845811912@w1.fi> (sfid-20081231_164220_866308_493A6ED7)
References: <20081231153834.840526845@w1.fi>
Date: Wed, 31 Dec 2008 17:38:36 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [RFC 02/11] mac80211: 802.11w - CCMP for management frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend CCMP to support encryption and decryption of unicast management
frames.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/ieee80211.h |   23 +++++++++++++++++++++++
 net/mac80211/tx.c         |   23 ++++++++++++++++++++++-
 net/mac80211/wpa.c        |   18 ++++++++++++------
 3 files changed, 57 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2008-12-31 16:46:11.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2008-12-31 16:54:08.000000000 +0200
@@ -331,6 +331,22 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	return TX_CONTINUE;
 }
 
+static int ieee80211_use_mfp(__le16 fc, struct sta_info *sta,
+			     struct sk_buff *skb)
+{
+	if (!ieee80211_is_mgmt(fc))
+		return 0;
+
+	if (sta == NULL || !test_sta_flags(sta, WLAN_STA_MFP))
+		return 0;
+
+	if (!ieee80211_is_robust_mgmt_frame((struct ieee80211_hdr *)
+					    skb->data))
+		return 0;
+
+	return 1;
+}
+
 static ieee80211_tx_result
 ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
@@ -430,10 +446,15 @@ ieee80211_tx_h_select_key(struct ieee802
 			if (ieee80211_is_auth(hdr->frame_control))
 				break;
 		case ALG_TKIP:
-		case ALG_CCMP:
 			if (!ieee80211_is_data_present(hdr->frame_control))
 				tx->key = NULL;
 			break;
+		case ALG_CCMP:
+			if (!ieee80211_is_data_present(hdr->frame_control) &&
+			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
+					       tx->skb))
+				tx->key = NULL;
+			break;
 		}
 	}
 
--- wireless-testing.orig/net/mac80211/wpa.c	2008-12-31 16:46:11.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2008-12-31 16:54:27.000000000 +0200
@@ -268,7 +268,7 @@ static void ccmp_special_blocks(struct s
 				int encrypted)
 {
 	__le16 mask_fc;
-	int a4_included;
+	int a4_included, mgmt;
 	u8 qos_tid;
 	u8 *b_0, *aad;
 	u16 data_len, len_a;
@@ -279,12 +279,15 @@ static void ccmp_special_blocks(struct s
 	aad = scratch + 4 * AES_BLOCK_LEN;
 
 	/*
-	 * Mask FC: zero subtype b4 b5 b6
+	 * Mask FC: zero subtype b4 b5 b6 (if not mgmt)
 	 * Retry, PwrMgt, MoreData; set Protected
 	 */
+	mgmt = ieee80211_is_mgmt(hdr->frame_control);
 	mask_fc = hdr->frame_control;
-	mask_fc &= ~cpu_to_le16(0x0070 | IEEE80211_FCTL_RETRY |
+	mask_fc &= ~cpu_to_le16(IEEE80211_FCTL_RETRY |
 				IEEE80211_FCTL_PM | IEEE80211_FCTL_MOREDATA);
+	if (!mgmt)
+		mask_fc &= ~cpu_to_le16(0x0070);
 	mask_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -302,8 +305,10 @@ static void ccmp_special_blocks(struct s
 
 	/* First block, b_0 */
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
-	/* Nonce: QoS Priority | A2 | PN */
-	b_0[1] = qos_tid;
+	/* Nonce: Nonce Flags | A2 | PN
+	 * Nonce Flags: Priority (b0..b3) | Management (b4) | Reserved (b5..b7)
+	 */
+	b_0[1] = qos_tid | (mgmt << 4);
 	memcpy(&b_0[2], hdr->addr2, ETH_ALEN);
 	memcpy(&b_0[8], pn, CCMP_PN_LEN);
 	/* l(m) */
@@ -449,7 +454,8 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) &&
+	    !ieee80211_is_robust_mgmt_frame(hdr))
 		return RX_CONTINUE;
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
--- wireless-testing.orig/include/linux/ieee80211.h	2008-12-31 16:46:11.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2008-12-31 17:00:34.000000000 +0200
@@ -1030,6 +1030,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_QOS = 1,
 	WLAN_CATEGORY_DLS = 2,
 	WLAN_CATEGORY_BACK = 3,
+	WLAN_CATEGORY_PUBLIC = 4,
 	WLAN_CATEGORY_WMM = 17,
 };
 
@@ -1186,6 +1187,28 @@ static inline u8 *ieee80211_get_DA(struc
 }
 
 /**
+ * ieee80211_is_robust_mgmt_frame - check if frame is a robust management frame
+ * @hdr: the frame (buffer must include at least the first octet of payload)
+ */
+static inline bool ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_is_disassoc(hdr->frame_control) ||
+	    ieee80211_is_deauth(hdr->frame_control))
+		return true;
+
+	if (ieee80211_is_action(hdr->frame_control)) {
+		/*
+		 * Action frames, excluding Public Action frames, are Robust
+		 * Management Frames.
+		 */
+		u8 *category = ((u8 *) hdr) + 24;
+		return *category != WLAN_CATEGORY_PUBLIC;
+	}
+
+	return false;
+}
+
+/**
  * ieee80211_fhss_chan_to_freq - get channel frequency
  * @channel: the FHSS channel
  *

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
