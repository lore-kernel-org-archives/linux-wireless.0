Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.10]:40637 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYI2OHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 10:07:41 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: jirislaby@gmail.com
Subject: [RFC, PATCH] ath5k: compilation fix for ARM
Date: Mon, 29 Sep 2008 16:07:33 +0200
Cc: mickflemm@gmail.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809291607.33690.marc.pignat@hevs.ch> (sfid-20080929_160748_630073_6547B539)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ARM linux port does not handle udleay > 2000.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Best regards

Marc

patch against 2.6.27-rc7


diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ad1a5b4..f450ef9 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -493,7 +493,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	}
 
 	if (ah->ah_version == AR5K_AR5210)
-		udelay(2300);
+		mdelay(3);
 
 	/* ...wakeup again!*/
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index fa0d47f..41f95e7 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2122,7 +2122,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
 	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
-	udelay(2300);
+	mdelay(3);
 
 	/*
 	 * Set the channel (with AGC turned off)
