Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52445 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/7] ath9k: add an interface for overriding the value of specific GPIO pins
Date: Sat, 19 Mar 2011 13:55:38 +0100
Message-Id: <1300539343-75509-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices control antenna settings or other things through GPIO pins
of the wireless interface. Add a debugfs interface for changing those
and keeping them set across card resets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.c    |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |    2 ++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9fe8693..a762cad 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1119,6 +1119,12 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
 
+	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
+			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
+
+	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
+			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
+
 	sc->debug.regidx = 0;
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 338b075..b170c45 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1212,6 +1212,20 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	return true;
 }
 
+static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
+{
+	u32 gpio_mask = ah->gpio_mask;
+	int i;
+
+	for (i = 0; gpio_mask; i++, gpio_mask >>= 1) {
+		if (!(gpio_mask & 1))
+			continue;
+
+		ath9k_hw_cfg_output(ah, i, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
+	}
+}
+
 bool ath9k_hw_check_alive(struct ath_hw *ah)
 {
 	int count = 50;
@@ -1500,6 +1514,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ar9003_hw_bb_watchdog_config(ah);
 
+	ath9k_hw_apply_gpio_override(ah);
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_reset);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6650fd4..91010e3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -795,6 +795,8 @@ struct ath_hw {
 	int initPDADC;
 	int PDADCdelta;
 	u8 led_pin;
+	u32 gpio_mask;
+	u32 gpio_val;
 
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
-- 
1.7.3.2

