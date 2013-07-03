Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab3GCSzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 14:55:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ath9k: make rfkill configurable
Date: Wed,  3 Jul 2013 20:55:38 +0200
Message-Id: <1372877738-10037-1-git-send-email-johannes@sipsolutions.net> (sfid-20130703_205552_017395_FF2A37E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the platform doesn't have rfkill support, i.e. nothing
is connected to the rfkill GPIO, there's little value in
polling the GPIO. Add a Kconfig option to allow disabling
the polling in ath9k.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 10 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.c    |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 760ab3f..6372626 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -96,6 +96,16 @@ config ATH9K_LEGACY_RATE_CONTROL
 	  has to be passed to mac80211 using the module parameter,
 	  ieee80211_default_rc_algo.
 
+config ATH9K_RFKILL
+	bool "Atheros ath9k rfkill support" if EXPERT
+	depends on ATH9K
+	depends on RFKILL=y || RFKILL=ATH9K
+	default y
+	help
+	  Say Y to have ath9k poll the RF-Kill GPIO every couple of
+	  seconds. Turn off to save power, but enable it if you have
+	  a platform that can toggle the RF-Kill GPIO.
+
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ca0cb0..e420c6b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2504,7 +2504,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->rts_aggr_limit = (8 * 1024);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+#ifdef CONFIG_ATH9K_RFKILL
 	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
 	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
 		ah->rfkill_gpio =
-- 
1.8.0

