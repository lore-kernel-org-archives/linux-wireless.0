Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53358 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546Ab2JDRnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 13:43:20 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2] ath_hw: Use common REG_WRITE parameter order
Date: Thu,  4 Oct 2012 19:43:15 +0200
Message-Id: <1349372595-19966-1-git-send-email-sven@narfation.org> (sfid-20121004_194336_076559_FF3C8B09)
In-Reply-To: <1349366701-23154-1-git-send-email-sven@narfation.org>
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
"register" and "value". hw.c is the only file using the order "ah", "value" and
"register".

drivers/net/wireless/ath/ath9k/hw.h:#define REG_WRITE(_ah, _reg, _val) \
drivers/net/wireless/ath/key.c:#define REG_WRITE(_ah, _reg, _val) (common->ops->write)(_ah, _val, _reg)

This inconsistent definition can easily lead to implementation errors. The
modification doesn't change the behavior of the driver or the generated code.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changed commit message

 drivers/net/wireless/ath/hw.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index 19befb3..39e8a59 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -20,8 +20,8 @@
 #include "ath.h"
 #include "reg.h"
 
-#define REG_READ	(common->ops->read)
-#define REG_WRITE	(common->ops->write)
+#define REG_READ			(common->ops->read)
+#define REG_WRITE(_ah, _reg, _val)	(common->ops->write)(_ah, _val, _reg)
 
 /**
  * ath_hw_set_bssid_mask - filter out bssids we listen
@@ -119,8 +119,8 @@ void ath_hw_setbssidmask(struct ath_common *common)
 {
 	void *ah = common->ah;
 
-	REG_WRITE(ah, get_unaligned_le32(common->bssidmask), AR_BSSMSKL);
-	REG_WRITE(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
+	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(common->bssidmask));
+	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(common->bssidmask + 4));
 }
 EXPORT_SYMBOL(ath_hw_setbssidmask);
 
@@ -139,7 +139,7 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
 	void *ah = common->ah;
 
 	/* freeze */
-	REG_WRITE(ah, AR_MIBC_FMC, AR_MIBC);
+	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 
 	/* read */
 	cycles = REG_READ(ah, AR_CCCNT);
@@ -148,13 +148,13 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
 	tx = REG_READ(ah, AR_TFCNT);
 
 	/* clear */
-	REG_WRITE(ah, 0, AR_CCCNT);
-	REG_WRITE(ah, 0, AR_RFCNT);
-	REG_WRITE(ah, 0, AR_RCCNT);
-	REG_WRITE(ah, 0, AR_TFCNT);
+	REG_WRITE(ah, AR_CCCNT, 0);
+	REG_WRITE(ah, AR_RFCNT, 0);
+	REG_WRITE(ah, AR_RCCNT, 0);
+	REG_WRITE(ah, AR_TFCNT, 0);
 
 	/* unfreeze */
-	REG_WRITE(ah, 0, AR_MIBC);
+	REG_WRITE(ah, AR_MIBC, 0);
 
 	/* update all cycle counters here */
 	common->cc_ani.cycles += cycles;
-- 
1.7.10.4

