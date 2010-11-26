Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36874 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0KZOKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 09:10:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 06:09:56 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Reintroduce modparam to enable btcoex
Date: Fri, 26 Nov 2010 06:10:06 -0800
Message-ID: <1290780607-2582-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not ideal to enable btcoex based on subsys id as it is
not unique, they are so random. It is also a pain keeping
all of them in a table to enable btcoex for a particular
hw. Going back to the old idea.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath.h        |    2 ++
 drivers/net/wireless/ath/ath9k/hw.c   |    3 +--
 drivers/net/wireless/ath/ath9k/init.c |    5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 501050c..3743e3b 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -162,6 +162,8 @@ struct ath_common {
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
+
+	bool btcoex_enabled;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ce9e59f..883f6cc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1925,8 +1925,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->num_antcfg_2ghz =
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
-	if (AR_SREV_9280_20_OR_LATER(ah) &&
-	    ath9k_hw_btcoex_supported(ah)) {
+	if (AR_SREV_9280_20_OR_LATER(ah) && common->btcoex_enabled) {
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7eef1fa..d11e6da 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -38,6 +38,10 @@ int led_blink;
 module_param_named(blink, led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
+static int ath9k_btcoex_enable;
+module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
+MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -543,6 +547,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->hw = sc->hw;
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
+	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->wiphy_lock);
-- 
1.7.0.4

