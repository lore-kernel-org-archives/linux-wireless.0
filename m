Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:62448 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZHNGDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 02:03:51 -0400
Received: by rv-out-0506.google.com with SMTP id f6so389721rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 23:03:53 -0700 (PDT)
Date: Fri, 14 Aug 2009 11:33:36 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Updates for AR9287_12 version of chipset.
Message-ID: <20090814060336.GE3541@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AsyncFIFO and AGGWEP for AR9287_12 and later revisions only.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    6 +++---
 drivers/net/wireless/ath/ath9k/reg.h |    9 ++++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4f58112..9259f71 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2392,7 +2392,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
-	if (AR_SREV_9287_10_OR_LATER(ah)) {
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
 		/* Enable ASYNC FIFO */
 		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
 				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
@@ -2478,7 +2478,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_user_settings(ah);
 
-	if (AR_SREV_9287_10_OR_LATER(ah)) {
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
 			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
@@ -2494,7 +2494,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
 			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
 	}
-	if (AR_SREV_9287_10_OR_LATER(ah)) {
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
 		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
 				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 13fd658..c9e1ac9 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -744,6 +744,7 @@
 #define AR_SREV_VERSION_9287                  0x180
 #define AR_SREV_REVISION_9287_10              0
 #define AR_SREV_REVISION_9287_11              1
+#define AR_SREV_REVISION_9287_12              2
 #define AR_SREV_VERSION_9271			0x140
 #define AR_SREV_REVISION_9271_10		0
 #define AR_SREV_REVISION_9271_11		1
@@ -817,7 +818,13 @@
 	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
 	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
-
+#define AR_SREV_9287_12(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_12))
+#define AR_SREV_9287_12_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_12)))
 #define AR_SREV_9271(_ah) \
     (((_ah))->hw_version.macVersion == AR_SREV_VERSION_9271)
 #define AR_SREV_9271_10(_ah) \
-- 
1.6.0.1

