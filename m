Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42904 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0K3OtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 09:49:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 06:49:08 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable <stable@kernel.org>
Subject: [PATCH 2/2] ath9k: Fix STA disconnect issue due to received MIC failed bcast frames
Date: Tue, 30 Nov 2010 20:19:20 +0530
Message-ID: <1291128560-2741-1-git-send-email-senthilkumar@atheros.com>
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
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    3 +--
 drivers/net/wireless/ath/ath9k/recv.c |    4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

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
index 262c815..429fa81 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1037,9 +1037,11 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
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
@@ -1060,7 +1062,7 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 
 	keyix = rx_stats->rs_keyix;
 
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
+	if ((is_mc || !(keyix == ATH9K_RXKEYIX_INVALID)) && !decrypt_error &&
 	    ieee80211_has_protected(fc)) {
 		rxs->flag |= RX_FLAG_DECRYPTED;
 	} else if (ieee80211_has_protected(fc)
-- 
1.7.2.1

