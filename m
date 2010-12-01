Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16514 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0LALAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 06:00:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 03:00:05 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable <stable@kernel.org>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Subject: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received MIC failed bcast frames
Date: Wed, 1 Dec 2010 16:30:05 +0530
Message-ID: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
this status for MIC failed frames is buggy.

Due to this, MIC failure events for broadcast frames are not sent to
supplicant resulted in AP disconnecting the STA.

Able to pass Wifi Test case 5.2.18 with this fix.

Cc: Stable <stable@kernel.org> (2.6.36+)
Cc: Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
v2 -- addressed invalid keyix overrun in tkip_keymap.

 drivers/net/wireless/ath/ath9k/mac.c  |    3 +--
 drivers/net/wireless/ath/ath9k/recv.c |   13 +++++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index b04b37b..7978b27 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -702,8 +702,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_phyerr = phyerr;
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		else if ((ads.ds_rxstatus8 & AR_MichaelErr) &&
-		         rs->rs_keyix != ATH9K_RXKEYIX_INVALID)
+		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
 		else if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 262c815..6c0c796 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -840,6 +840,10 @@ static bool ath9k_rx_accept(struct ath_common *common,
 			    struct ath_rx_status *rx_stats,
 			    bool *decrypt_error)
 {
+#define is_mc_or_valid_tkip_keyix ((is_mc ||			\
+		(rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID && \
+		test_bit(rx_stats->rs_keyix, common->tkip_keymap))))
+
 	struct ath_hw *ah = common->ah;
 	__le16 fc;
 	u8 rx_status_len = ah->caps.rx_status_len;
@@ -881,15 +885,18 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
 			*decrypt_error = true;
 		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
+			bool is_mc;
 			/*
 			 * The MIC error bit is only valid if the frame
 			 * is not a control frame or fragment, and it was
 			 * decrypted using a valid TKIP key.
 			 */
+			is_mc = !!is_multicast_ether_addr(hdr->addr1);
+
 			if (!ieee80211_is_ctl(fc) &&
 			    !ieee80211_has_morefrags(fc) &&
 			    !(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
-			    test_bit(rx_stats->rs_keyix, common->tkip_keymap))
+			    is_mc_or_valid_tkip_keyix)
 				rxs->flag |= RX_FLAG_MMIC_ERROR;
 			else
 				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
@@ -1037,9 +1044,11 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 	int hdrlen, padpos, padsize;
 	u8 keyix;
 	__le16 fc;
+	bool is_mc;
 
 	/* see if any padding is done by the hw and remove it */
 	hdr = (struct ieee80211_hdr *) skb->data;
+	is_mc = !!is_multicast_ether_addr(hdr->addr1);
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
@@ -1060,7 +1069,7 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 
 	keyix = rx_stats->rs_keyix;
 
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
+	if ((is_mc || !(keyix == ATH9K_RXKEYIX_INVALID)) && !decrypt_error &&
 	    ieee80211_has_protected(fc)) {
 		rxs->flag |= RX_FLAG_DECRYPTED;
 	} else if (ieee80211_has_protected(fc)
-- 
1.7.2.1

