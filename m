Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3365 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZAAUCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 15:02:03 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, maximlevitsky@gmail.com, andi@lisas.de
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: fix off-by-one in gpio checks
Date: Thu,  1 Jan 2009 15:01:45 -0500
Message-Id: <1230840105-30960-2-git-send-email-me@bobcopeland.com> (sfid-20090101_210209_359313_331526E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sanity checks against AR5K_NUM_GPIO were all broken.  This doesn't
currently cause any problems since we only use the first four gpios.

Changes-licensed-under: ISC

Reported-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/gpio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/gpio.c b/drivers/net/wireless/ath5k/gpio.c
index b77205a..64a27e7 100644
--- a/drivers/net/wireless/ath5k/gpio.c
+++ b/drivers/net/wireless/ath5k/gpio.c
@@ -83,7 +83,7 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
+	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
 
 	ath5k_hw_reg_write(ah,
@@ -99,7 +99,7 @@ int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
+	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
 
 	ath5k_hw_reg_write(ah,
@@ -115,7 +115,7 @@ int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
+	if (gpio >= AR5K_NUM_GPIO)
 		return 0xffffffff;
 
 	/* GPIO input magic */
@@ -131,7 +131,7 @@ int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 	u32 data;
 	ATH5K_TRACE(ah->ah_sc);
 
-	if (gpio > AR5K_NUM_GPIO)
+	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
 
 	/* GPIO output magic */
@@ -154,7 +154,7 @@ void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 	u32 data;
 
 	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
+	if (gpio >= AR5K_NUM_GPIO)
 		return;
 
 	/*
-- 
1.6.0.6


