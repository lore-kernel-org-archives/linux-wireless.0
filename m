Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56345 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1H0Gmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 02:42:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix eifs/usec timeout for AR9287 v1.3+
Date: Sat, 27 Aug 2011 12:13:21 +0530
Message-ID: <1314427401-2983-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110827_084257_182352_8ABB808E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AR9287 v1.3+ chips, MAC runs at 117MHz. But the initvals
IFS parameters are loaded based on 44/88MHz clockrate. So
eifs/usec from ini should not be used for AR9287 v1.3+.
The mentioned values are tested on 2 chain HT40 mode.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/reg.h |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 05472c5..284d2a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1000,8 +1000,14 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		slottime = 21;
 		sifstime = 64;
 	} else {
-		eifs = REG_READ(ah, AR_D_GBL_IFS_EIFS)/common->clockrate;
-		reg = REG_READ(ah, AR_USEC);
+		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
+			eifs = AR_D_GBL_IFS_EIFS_ASYNC_FIFO;
+			reg = AR_USEC_ASYNC_FIFO;
+		} else {
+			eifs = REG_READ(ah, AR_D_GBL_IFS_EIFS)/
+				common->clockrate;
+			reg = REG_READ(ah, AR_USEC);
+		}
 		rx_lat = MS(reg, AR_USEC_RX_LAT);
 		tx_lat = MS(reg, AR_USEC_TX_LAT);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a3b8bbc..17a272f 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -619,6 +619,7 @@
 #define AR_D_GBL_IFS_EIFS         0x10b0
 #define AR_D_GBL_IFS_EIFS_M       0x0000FFFF
 #define AR_D_GBL_IFS_EIFS_RESV0   0xFFFF0000
+#define AR_D_GBL_IFS_EIFS_ASYNC_FIFO 363
 
 #define AR_D_GBL_IFS_MISC        0x10f0
 #define AR_D_GBL_IFS_MISC_LFSR_SLICE_SEL        0x00000007
@@ -1503,6 +1504,7 @@ enum {
 #define AR_USEC_TX_LAT_S     14
 #define AR_USEC_RX_LAT       0x1F800000
 #define AR_USEC_RX_LAT_S     23
+#define AR_USEC_ASYNC_FIFO   0x12E00074
 
 #define AR_RESET_TSF        0x8020
 #define AR_RESET_TSF_ONCE   0x01000000
-- 
1.7.6.1

