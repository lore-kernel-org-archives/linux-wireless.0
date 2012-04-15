Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44677 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 9/9] ath9k_hw: increase tx abort timeout for half/quarter channels
Date: Sun, 15 Apr 2012 12:15:41 +0200
Message-Id: <1334484941-27673-9-git-send-email-nbd@openwrt.org> (sfid-20120415_121606_567419_79706972)
In-Reply-To: <1334484941-27673-8-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
 <1334484941-27673-2-git-send-email-nbd@openwrt.org>
 <1334484941-27673-3-git-send-email-nbd@openwrt.org>
 <1334484941-27673-4-git-send-email-nbd@openwrt.org>
 <1334484941-27673-5-git-send-email-nbd@openwrt.org>
 <1334484941-27673-6-git-send-email-nbd@openwrt.org>
 <1334484941-27673-7-git-send-email-nbd@openwrt.org>
 <1334484941-27673-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index f7bd253..04ef775 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -133,8 +133,16 @@ EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
 
 void ath9k_hw_abort_tx_dma(struct ath_hw *ah)
 {
+	int maxdelay = 1000;
 	int i, q;
 
+	if (ah->curchan) {
+		if (IS_CHAN_HALF_RATE(ah->curchan))
+			maxdelay *= 2;
+		else if (IS_CHAN_QUARTER_RATE(ah->curchan))
+			maxdelay *= 4;
+	}
+
 	REG_WRITE(ah, AR_Q_TXD, AR_Q_TXD_M);
 
 	REG_SET_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
@@ -142,7 +150,7 @@ void ath9k_hw_abort_tx_dma(struct ath_hw *ah)
 	REG_SET_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
 
 	for (q = 0; q < AR_NUM_QCU; q++) {
-		for (i = 0; i < 1000; i++) {
+		for (i = 0; i < maxdelay; i++) {
 			if (i)
 				udelay(5);
 
-- 
1.7.3.2

