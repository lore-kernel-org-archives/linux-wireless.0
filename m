Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Enis Akay <Enis.Akay@atheros.com>
Subject: [PATCH v3 17/97] ath9k_hw: disable ANI for AR9003
Date: Thu, 15 Apr 2010 17:38:22 -0400
Message-Id: <1271367582-992-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI is still being debugged on AR9003 by our systems team
so it should not yet be enabled yet. When ANI will be
enabled all ANI functionality is expected to be enabled
so fill the ANI functionality to all for AR9003 for now
as well.

Cc: Enis Akay <Enis.Akay@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0e78e35..e54c76e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -364,7 +364,13 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.ofdm_trig_high = 500;
 	ah->config.cck_trig_high = 200;
 	ah->config.cck_trig_low = 100;
-	ah->config.enable_ani = 1;
+
+	/*
+	 * For now ANI is disabled for AR9003, it is still
+	 * being tested.
+	 */
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ah->config.enable_ani = 1;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		ah->config.spurchans[i][0] = AR_NO_SPUR;
@@ -942,7 +948,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 
 	ath9k_hw_init_mode_regs(ah);
-- 
1.6.3.3

