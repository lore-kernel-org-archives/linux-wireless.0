Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49577 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab2GLPET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:04:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 03/12] ath9k_hw: enable ANI on AR934x
Date: Thu, 12 Jul 2012 17:04:02 +0200
Message-Id: <1342105451-42297-3-git-send-email-nbd@openwrt.org> (sfid-20120712_170424_915788_B0829896)
In-Reply-To: <1342105451-42297-2-git-send-email-nbd@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
 <1342105451-42297-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has been tested and works properly

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c1659d0..69a2e03 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -671,10 +671,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
-	/* disable ANI for 9340 */
-	if (AR_SREV_9340(ah))
-		ah->config.enable_ani = false;
-
 	ath9k_hw_init_mode_regs(ah);
 
 	if (!ah->is_pciexpress)
-- 
1.7.3.2

