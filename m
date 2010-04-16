Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18975
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757825Ab0DPKwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:45 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 4/6] ath9k: do not mark frames with RX_KEY_MISS as decrypted
Date: Fri, 16 Apr 2010 12:52:13 +0200
Message-Id: <1271415135-18317-4-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames tagged by hardware with ATH9K_RX_KEY_MISS should not
incorrectly be marked decrypted.

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---

The frame below has no error flags set besides KeyMiss and would be marked
decrypted by the current code.

00000000: 88 41 30 00 00 80 48 68 08 0f 00 21 6a 56 2c 36
00000010: 00 22 02 00 0b 63 10 a4 00 00 10 00 40 0a 00 20
00000020: 81 62 6d de 46 89 96 96 97 ec cf aa e3 77 73 07
00000030: 17 e8 76 91 73 fd ea a9 29 62 e4 c3 17 46 39 0a
00000040: 52 7f 26 39 2d 4c 22 7c 0e 91 78 95 ff 1d d0 18
00000050: ef 6a af 99 42 74 70 c1 d4 8b 56 16 9b 90 f3 9a
00000060: ff 52 5d 1c 77 ee 83 34 f6 14 1c da
rxstatus8 = b9accfc3

    set: AR_RxFrameOK | AR_RxKeyIdxValid | AR_KeyMiss
cleared: AR_CRCErr | AR_DecryptCRCErr | AR_PHYErr | AR_MichaelErr | AR_DecryptBusyErr


 drivers/net/wireless/ath/ath9k/common.c |    3 ++-
 drivers/net/wireless/ath/ath9k/mac.c    |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h    |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index dd4be54..1623af1 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -256,7 +256,8 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 	keyix = rx_stats->rs_keyix;
 
 	if (ieee80211_has_protected(fc) && !decrypt_error &&
-		!(rx_stats->rs_flags & ATH9K_RX_DECRYPT_BUSY)) {
+		!(rx_stats->rs_flags & ATH9K_RX_DECRYPT_BUSY) &&
+		!(rx_stats->rs_flags & ATH9K_RX_KEY_MISS)) {
 		if (keyix != ATH9K_RXKEYIX_INVALID)
 			rxs->flag |= RX_FLAG_DECRYPTED;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 4a2060e..891a294 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -922,6 +922,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_POST;
 	if (ads.ds_rxstatus8 & AR_DecryptBusyErr)
 		rs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
+	if (ads.ds_rxstatus8 & AR_KeyMiss)
+		rs->rs_flags |= ATH9K_RX_KEY_MISS;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
 		if (ads.ds_rxstatus8 & AR_CRCErr)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 68dbd7a..ba3c98e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -189,6 +189,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RX_DELIM_CRC_PRE    0x10
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
+#define ATH9K_RX_KEY_MISS         0x80
 
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
 #define ATH9K_TXKEYIX_INVALID	((u32)-1)
-- 
1.7.0.3

