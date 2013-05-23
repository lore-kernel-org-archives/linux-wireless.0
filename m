Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41486 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab3EWKVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 06:21:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.10 3/3] ath9k_hw: improve performance for AR934x v1.3+
Date: Thu, 23 May 2013 12:20:56 +0200
Message-Id: <1369304456-74526-3-git-send-email-nbd@openwrt.org> (sfid-20130523_122111_230244_325D11E5)
In-Reply-To: <1369304456-74526-1-git-send-email-nbd@openwrt.org>
References: <1369304456-74526-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR934x v1.3 no longer needs the DCU backoff reduction workaround for
preventing rx overruns, but in turn needs the number of usable Tx
buffers to be reduced slightly.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 15 ++++++++++-----
 drivers/net/wireless/ath/ath9k/mac.c |  2 +-
 drivers/net/wireless/ath/ath9k/reg.h |  9 +++++++++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 40331f4..2caf7de 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1172,6 +1172,7 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	int txbuf_size;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -1225,13 +1226,17 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 		 * So set the usable tx buf size also to half to
 		 * avoid data/delimiter underruns
 		 */
-		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
-			  AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE);
-	} else if (!AR_SREV_9271(ah)) {
-		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
-			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
+		txbuf_size = AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE;
+	} else if (AR_SREV_9340_13_OR_LATER(ah)) {
+		/* Uses fewer entries for AR934x v1.3+ to prevent rx overruns */
+		txbuf_size = AR_9340_PCU_TXBUF_CTRL_USABLE_SIZE;
+	} else {
+		txbuf_size = AR_PCU_TXBUF_CTRL_USABLE_SIZE;
 	}
 
+	if (!AR_SREV_9271(ah))
+		REG_WRITE(ah, AR_PCU_TXBUF_CTRL, txbuf_size);
+
 	REGWRITE_BUFFER_FLUSH(ah);
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 498fee0..566109a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -410,7 +410,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 
 	REG_WRITE(ah, AR_QMISC(q), AR_Q_MISC_DCU_EARLY_TERM_REQ);
 
-	if (AR_SREV_9340(ah))
+	if (AR_SREV_9340(ah) && !AR_SREV_9340_13_OR_LATER(ah))
 		REG_WRITE(ah, AR_DMISC(q),
 			  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x1);
 	else
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 9c056a8..f7c90cc 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -798,6 +798,10 @@
 #define AR_SREV_REVISION_9485_10	0
 #define AR_SREV_REVISION_9485_11        1
 #define AR_SREV_VERSION_9340		0x300
+#define AR_SREV_REVISION_9340_10	0
+#define AR_SREV_REVISION_9340_11	1
+#define AR_SREV_REVISION_9340_12	2
+#define AR_SREV_REVISION_9340_13	3
 #define AR_SREV_VERSION_9580		0x1C0
 #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
 #define AR_SREV_VERSION_9462		0x280
@@ -897,6 +901,10 @@
 #define AR_SREV_9340(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9340))
 
+#define AR_SREV_9340_13_OR_LATER(_ah) \
+	(AR_SREV_9340((_ah)) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9340_13))
+
 #define AR_SREV_9285E_20(_ah) \
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
@@ -1883,6 +1891,7 @@ enum {
 #define AR_PCU_TXBUF_CTRL_SIZE_MASK     0x7FF
 #define AR_PCU_TXBUF_CTRL_USABLE_SIZE   0x700
 #define AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE   0x380
+#define AR_9340_PCU_TXBUF_CTRL_USABLE_SIZE   0x500
 
 #define AR_PCU_MISC_MODE2               0x8344
 #define AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE           0x00000002
-- 
1.8.0.2

