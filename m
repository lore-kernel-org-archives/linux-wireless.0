Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46842 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbbFQI42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:56:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/14] mac80211: support device/driver PN check for CCMP/GCMP
Date: Wed, 17 Jun 2015 10:41:11 +0200
Message-Id: <1434530475-3553-11-git-send-email-johannes@sipsolutions.net> (sfid-20150617_105633_362235_53E2F69B)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When there are multiple RX queues, the PN checks in mac80211 cannot be
used since packets might be processed out of order on different CPUs.

Allow the driver to report that the PN has been checked, drivers that
will use multi-queue RX will have to set this flag.

For now, the flag is only valid when the frame has been decrypted, in
theory that restriction doesn't have to be there, but in practice the
hardware will have decrypted the frame already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  7 ++++-
 net/mac80211/wpa.c     | 83 +++++++++++++++++++++++++++-----------------------
 2 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1fe761613d29..b767129aed19 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -973,6 +973,10 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_IV_STRIPPED: The IV/ICV are stripped from this frame.
  *	If this flag is set, the stack cannot do any replay detection
  *	hence the driver or hardware will have to do that.
+ * @RX_FLAG_PN_VALIDATED: Currently only valid for CCMP/GCMP frames, this
+ *	flag indicates that the PN was verified for replay protection.
+ *	Note that this flag is also currently only supported when a frame
+ *	is also decrypted (ie. @RX_FLAG_DECRYPTED must be set)
  * @RX_FLAG_FAILED_FCS_CRC: Set this flag if the FCS check failed on
  *	the frame.
  * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
@@ -1036,7 +1040,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_NO_SIGNAL_VAL		= BIT(12),
 	RX_FLAG_HT_GF			= BIT(13),
 	RX_FLAG_AMPDU_DETAILS		= BIT(14),
-	/* bits 15/16 free */
+	RX_FLAG_PN_VALIDATED		= BIT(15),
+	/* bit 16 free */
 	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(17),
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 943f7606527e..feb547dc8643 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -516,31 +516,34 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 			return RX_DROP_UNUSABLE;
 	}
 
-	ccmp_hdr2pn(pn, skb->data + hdrlen);
+	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
+		ccmp_hdr2pn(pn, skb->data + hdrlen);
 
-	queue = rx->security_idx;
+		queue = rx->security_idx;
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN) <= 0) {
-		key->u.ccmp.replays++;
-		return RX_DROP_UNUSABLE;
-	}
+		if (memcmp(pn, key->u.ccmp.rx_pn[queue],
+			   IEEE80211_CCMP_PN_LEN) <= 0) {
+			key->u.ccmp.replays++;
+			return RX_DROP_UNUSABLE;
+		}
 
-	if (!(status->flag & RX_FLAG_DECRYPTED)) {
-		u8 aad[2 * AES_BLOCK_SIZE];
-		u8 b_0[AES_BLOCK_SIZE];
-		/* hardware didn't decrypt/verify MIC */
-		ccmp_special_blocks(skb, pn, b_0, aad);
+		if (!(status->flag & RX_FLAG_DECRYPTED)) {
+			u8 aad[2 * AES_BLOCK_SIZE];
+			u8 b_0[AES_BLOCK_SIZE];
+			/* hardware didn't decrypt/verify MIC */
+			ccmp_special_blocks(skb, pn, b_0, aad);
+
+			if (ieee80211_aes_ccm_decrypt(
+				    key->u.ccmp.tfm, b_0, aad,
+				    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
+				    data_len,
+				    skb->data + skb->len - mic_len, mic_len))
+				return RX_DROP_UNUSABLE;
+		}
 
-		if (ieee80211_aes_ccm_decrypt(
-			    key->u.ccmp.tfm, b_0, aad,
-			    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
-			    data_len,
-			    skb->data + skb->len - mic_len, mic_len))
-			return RX_DROP_UNUSABLE;
+		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
 	}
 
-	memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
-
 	/* Remove CCMP header and MIC */
 	if (pskb_trim(skb, skb->len - mic_len))
 		return RX_DROP_UNUSABLE;
@@ -739,31 +742,35 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 	}
 
-	gcmp_hdr2pn(pn, skb->data + hdrlen);
+	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
+		gcmp_hdr2pn(pn, skb->data + hdrlen);
 
-	queue = rx->security_idx;
+		queue = rx->security_idx;
 
-	if (memcmp(pn, key->u.gcmp.rx_pn[queue], IEEE80211_GCMP_PN_LEN) <= 0) {
-		key->u.gcmp.replays++;
-		return RX_DROP_UNUSABLE;
-	}
+		if (memcmp(pn, key->u.gcmp.rx_pn[queue],
+			   IEEE80211_GCMP_PN_LEN) <= 0) {
+			key->u.gcmp.replays++;
+			return RX_DROP_UNUSABLE;
+		}
 
-	if (!(status->flag & RX_FLAG_DECRYPTED)) {
-		u8 aad[2 * AES_BLOCK_SIZE];
-		u8 j_0[AES_BLOCK_SIZE];
-		/* hardware didn't decrypt/verify MIC */
-		gcmp_special_blocks(skb, pn, j_0, aad);
+		if (!(status->flag & RX_FLAG_DECRYPTED)) {
+			u8 aad[2 * AES_BLOCK_SIZE];
+			u8 j_0[AES_BLOCK_SIZE];
+			/* hardware didn't decrypt/verify MIC */
+			gcmp_special_blocks(skb, pn, j_0, aad);
+
+			if (ieee80211_aes_gcm_decrypt(
+				    key->u.gcmp.tfm, j_0, aad,
+				    skb->data + hdrlen + IEEE80211_GCMP_HDR_LEN,
+				    data_len,
+				    skb->data + skb->len -
+				    IEEE80211_GCMP_MIC_LEN))
+				return RX_DROP_UNUSABLE;
+		}
 
-		if (ieee80211_aes_gcm_decrypt(
-			    key->u.gcmp.tfm, j_0, aad,
-			    skb->data + hdrlen + IEEE80211_GCMP_HDR_LEN,
-			    data_len,
-			    skb->data + skb->len - IEEE80211_GCMP_MIC_LEN))
-			return RX_DROP_UNUSABLE;
+		memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
 	}
 
-	memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
-
 	/* Remove GCMP header and MIC */
 	if (pskb_trim(skb, skb->len - IEEE80211_GCMP_MIC_LEN))
 		return RX_DROP_UNUSABLE;
-- 
2.1.4

