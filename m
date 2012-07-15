Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40168 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 03/12] ath9k_hw: enable ANI on AR934x
Date: Sun, 15 Jul 2012 19:53:31 +0200
Message-Id: <1342374820-92409-3-git-send-email-nbd@openwrt.org> (sfid-20120715_195402_788304_2A3016E8)
In-Reply-To: <1342374820-92409-2-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
 <1342374820-92409-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has been tested and works properly

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9c8e0d8..ddb24bf 100644
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
1.7.7.5 (Apple Git-26)

