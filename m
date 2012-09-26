Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50774 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZGxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 02:53:14 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20578.42520.130884.616830@gargle.gargle.HOWL> (sfid-20120926_085323_379011_417C8D93)
Date: Wed, 26 Sep 2012 12:22:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix chainmask selection for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Force chain 1 to be used for CCK rates since the target power
table stored in EEPROM is too high to transmit with both chains.
This is needed to avoid regulatory violation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 ++
 drivers/net/wireless/ath/ath9k/xmit.c  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8e27f4f..dfe6a47 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -173,6 +173,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
+#define IS_CCK_RATE(rate) ((rate >= 0x18) && (rate <= 0x1e))
+
 #define ATH_TX_COMPLETE_POLL_INT	1000
 
 enum ATH_AGGR_STATUS {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b088fa0..36618e3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1820,10 +1820,14 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_channel *curchan = ah->curchan;
+
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) &&
 	    (curchan->channelFlags & CHANNEL_5GHZ) &&
 	    (chainmask == 0x7) && (rate < 0x90))
 		return 0x3;
+	else if (AR_SREV_9462(ah) && ath9k_hw_btcoex_is_enabled(ah) &&
+		 IS_CCK_RATE(rate))
+		return 0x2;
 	else
 		return chainmask;
 }
-- 
1.7.12

