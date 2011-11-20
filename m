Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KTH5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:42 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:41 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 06/13] ath5k: Use usleep_range where possible
Date: Sun, 20 Nov 2011 09:56:21 +0200
Message-Id: <1321775788-12520-7-git-send-email-mickflemm@gmail.com> (sfid-20111120_085746_071923_9CB4C1E1)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use usleep_range where possible to reduce busy waits

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/pci.c    |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c    |   22 +++++++++++-----------
 drivers/net/wireless/ath/ath5k/reset.c  |   14 +++++++-------
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 91627dd..49fdc93 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -298,7 +298,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 
 		/* Reset SERDES to load new settings */
 		ath5k_hw_reg_write(ah, 0x00000000, AR5K_PCIE_SERDES_RESET);
-		mdelay(1);
+		usleep_range(1000, 1500);
 	}
 
 	/* Get misc capabilities */
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index c1dff2c..7fdae9b 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -97,7 +97,7 @@ ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
 					0xffff);
 			return true;
 		}
-		udelay(15);
+		usleep_range(15, 20);
 	}
 
 	return false;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index addf775..25fc268 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -58,7 +58,7 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 		return 0;
 	}
 
-	mdelay(2);
+	usleep_range(2000, 2500);
 
 	/* ...wait until PHY is ready and read the selected radio revision */
 	ath5k_hw_reg_write(ah, 0x00001c16, AR5K_PHY(0x34));
@@ -308,9 +308,9 @@ static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
 			delay = delay << 2;
 		/* XXX: /2 on turbo ? Let's be safe
 		 * for now */
-		udelay(100 + delay);
+		usleep_range(100 + delay, 100 + (2 * delay));
 	} else {
-		mdelay(1);
+		usleep_range(1000, 1500);
 	}
 }
 
@@ -1083,7 +1083,7 @@ static int ath5k_hw_rf5110_channel(struct ath5k_hw *ah,
 	data = ath5k_hw_rf5110_chan2athchan(channel);
 	ath5k_hw_reg_write(ah, data, AR5K_RF_BUFFER);
 	ath5k_hw_reg_write(ah, 0, AR5K_RF_BUFFER_CONTROL_0);
-	mdelay(1);
+	usleep_range(1000, 1500);
 
 	return 0;
 }
@@ -1454,7 +1454,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
 	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
-	mdelay(2);
+	usleep_range(2000, 2500);
 
 	/*
 	 * Set the channel (with AGC turned off)
@@ -1467,7 +1467,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	 * Activate PHY and wait
 	 */
 	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
-	mdelay(1);
+	usleep_range(1000, 1500);
 
 	AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
@@ -1504,7 +1504,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	ath5k_hw_reg_write(ah, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
 	AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
-	mdelay(1);
+	usleep_range(1000, 1500);
 
 	/*
 	 * Enable calibration and wait until completion
@@ -3396,7 +3396,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		if (ret)
 			return ret;
 
-		mdelay(1);
+		usleep_range(1000, 1500);
 
 		/*
 		 * Write RF buffer
@@ -3417,10 +3417,10 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		}
 
 	} else if (ah->ah_version == AR5K_AR5210) {
-		mdelay(1);
+		usleep_range(1000, 1500);
 		/* Disable phy and wait */
 		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
-		mdelay(1);
+		usleep_range(1000, 1500);
 	}
 
 	/* Set channel on PHY */
@@ -3446,7 +3446,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	for (i = 0; i <= 20; i++) {
 		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
 			break;
-		udelay(200);
+		usleep_range(200, 250);
 	}
 	ath5k_hw_reg_write(ah, phy_tst1, AR5K_PHY_TST1);
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 2abac25..de28be4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -357,7 +357,7 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 	ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
 
 	/* Wait at least 128 PCI clocks */
-	udelay(15);
+	usleep_range(15, 20);
 
 	if (ah->ah_version == AR5K_AR5210) {
 		val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA
@@ -422,7 +422,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 	regval = __raw_readl(reg);
 	__raw_writel(regval | val, reg);
 	regval = __raw_readl(reg);
-	udelay(100);
+	usleep_range(100, 150);
 
 	/* Bring BB/MAC out of reset */
 	__raw_writel(regval & ~val, reg);
@@ -493,7 +493,7 @@ static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 
 		ath5k_hw_reg_write(ah, data | AR5K_SLEEP_CTL_SLE_WAKE,
 							AR5K_SLEEP_CTL);
-		udelay(15);
+		usleep_range(15, 20);
 
 		for (i = 200; i > 0; i--) {
 			/* Check if the chip did wake up */
@@ -502,7 +502,7 @@ static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 				break;
 
 			/* Wait a bit and retry */
-			udelay(50);
+			usleep_range(50, 75);
 			ath5k_hw_reg_write(ah, data | AR5K_SLEEP_CTL_SLE_WAKE,
 							AR5K_SLEEP_CTL);
 		}
@@ -563,7 +563,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			mdelay(2);
+			usleep_range(2000, 2500);
 	} else {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_BASEBAND | bus_flags);
@@ -621,7 +621,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			mdelay(2);
+			usleep_range(2000, 2500);
 	} else {
 		if (ath5k_get_bus_type(ah) == ATH_AHB)
 			ret = ath5k_hw_wisoc_reset(ah, AR5K_RESET_CTL_PCU |
@@ -739,7 +739,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 		/* ...update PLL if needed */
 		if (ath5k_hw_reg_read(ah, AR5K_PHY_PLL) != clock) {
 			ath5k_hw_reg_write(ah, clock, AR5K_PHY_PLL);
-			udelay(300);
+			usleep_range(300, 350);
 		}
 
 		/* ...set the PHY operating mode */
-- 
1.7.8.rc1

