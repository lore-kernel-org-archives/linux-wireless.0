Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18974
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756682Ab0DPKwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:44 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 3/6] ath9k: do not mark frames with RX_DECRYPT_BUSY as decrypted
Date: Fri, 16 Apr 2010 12:52:12 +0200
Message-Id: <1271415135-18317-3-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames tagged by hardware with ATH9K_RX_DECRYPT_BUSY should not
incorrectly be marked decrypted.

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---

Some corrupt frames such as the one below have DecryptBusyErr flag set even
though frame is marked ok and without DecryptCRCErr set.

00000000: 88 41 30 00 00 80 48 68 08 0f 00 21 6a 56 2c 36
00000010: 00 22 02 00 0b 63 e0 2b 00 00 e0 00 bd 42 00 20
00000020: ef 44 5c a5 45 62 c2 2d af c3 cc ef ec cb d0 83
00000030: a7 7f fd bc 7d f1 c4 5e 72 82 81 fc ff 1a 9d 85
00000040: 63 cd 36 ae a4 12 6e fb b7 6a 77 71 4a 06 e6 ae
00000050: a6 40 ad b1 76 b7 de ff 7c bd cf b1 ef 3d 93 bf
00000060: 68 a0 af c1 a2 14 84 a4 4c 9e 5e 3e
rxstatus8 = de461103

    set: AR_RxFrameOK | AR_RxKeyIdxValid | AR_DecryptBusyErr | Ar_KeyMiss
cleared: AR_CRCErr | AR_DecryptCRCErr | AR_PHYErr | AR_MichaelErr


 drivers/net/wireless/ath/ath9k/common.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index af22e7a..dd4be54 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -255,7 +255,8 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 
 	keyix = rx_stats->rs_keyix;
 
-	if (ieee80211_has_protected(fc) && !decrypt_error) {
+	if (ieee80211_has_protected(fc) && !decrypt_error &&
+		!(rx_stats->rs_flags & ATH9K_RX_DECRYPT_BUSY)) {
 		if (keyix != ATH9K_RXKEYIX_INVALID)
 			rxs->flag |= RX_FLAG_DECRYPTED;
 	}
-- 
1.7.0.3

