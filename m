Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18973
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756682Ab0DPKwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:43 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 2/6] ath9k: do not mark frames with RXKEY_IX_INVALID as decrypted
Date: Fri, 16 Apr 2010 12:52:11 +0200
Message-Id: <1271415135-18317-2-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames tagged by hardware with ATH9K_RXKEYIX_INVALID should not
incorrectly be marked decrypted (even if key index in frame is valid).

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---

The current code overrides the hardware flag indicating that the key index is
invalid and falsely mark this frame as decrypted.

00000000: 88 41 30 00 00 80 48 68 08 0f 00 21 6a 56 2c 36
00000010: 00 22 02 00 0b 63 20 0d 00 00 20 00 d1 20 00 20
00000020: b1 5b a7 c5 96 be cf a3 16 3b 35 a0 bb 59 ea d2
00000030: 17 10 28 b0 07 67 14 ff d7 6f 77 5c f1 01 f0 04
00000040: 8d 03 47 68 9d b2 bd b4 64 bb cd 58 e9 ff 82 d2
00000050: f3 d0 38 b1 75 a2 2f d2 d6 b7 70 ec 95 22 71 32
00000060: 54 c0 c4 6d 1f 0d 19 32 22 e9 c2 9c
rxstatus8 = 3bbc20a3

    set: AR_RxFrameOK | AR_MichaelErr
cleared: AR_CRCErr | AR_DecryptCRCErr | AR_PHYErr | AR_RxKeyIdxValid


 drivers/net/wireless/ath/ath9k/common.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 0cd10dc..af22e7a 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -256,14 +256,8 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 	keyix = rx_stats->rs_keyix;
 
 	if (ieee80211_has_protected(fc) && !decrypt_error) {
-		if (keyix != ATH9K_RXKEYIX_INVALID) {
+		if (keyix != ATH9K_RXKEYIX_INVALID)
 			rxs->flag |= RX_FLAG_DECRYPTED;
-		} else if (skb->len >= hdrlen + 4) {
-			keyix = skb->data[hdrlen + 3] >> 6;
-
-			if (test_bit(keyix, common->keymap))
-				rxs->flag |= RX_FLAG_DECRYPTED;
-		}
 	}
 	if (ah->sw_mgmt_crypto &&
 	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-- 
1.7.0.3

