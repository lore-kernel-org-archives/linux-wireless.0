Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54469 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEGTx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:57 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so6503028wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/23] iwlwifi: make LED support optional
Date: Wed,  7 May 2014 22:52:52 +0300
Message-Id: <1399492380-12050-15-git-send-email-egrumbach@gmail.com> (sfid-20140507_215408_864979_E46B3950)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there's no LED on the system, it doesn't make a lot of sense
to include close to 4k of LED-related code (mostly in mac80211),
so instead of forcing LED support into the kernel, don't build
iwlwifi/mac80211 LED support if there's no LED class support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: EliadX Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig      | 12 ++++++++----
 drivers/net/wireless/iwlwifi/dvm/Makefile |  3 ++-
 drivers/net/wireless/iwlwifi/dvm/dev.h    |  2 ++
 drivers/net/wireless/iwlwifi/dvm/led.h    | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/Makefile |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h    | 12 ++++++++++++
 6 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 74b3b4d..b82d30c 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -2,10 +2,6 @@ config IWLWIFI
 	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi) "
 	depends on PCI && MAC80211 && HAS_IOMEM
 	select FW_LOADER
-	select NEW_LEDS
-	select LEDS_CLASS
-	select LEDS_TRIGGERS
-	select MAC80211_LEDS
 	---help---
 	  Select to build the driver supporting the:
 
@@ -43,6 +39,14 @@ config IWLWIFI
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwlwifi.
 
+config IWLWIFI_LEDS
+	bool
+	depends on IWLWIFI
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	select MAC80211_LEDS
+	default y
+
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/dvm/Makefile b/drivers/net/wireless/iwlwifi/dvm/Makefile
index dce7ab2..4d19685 100644
--- a/drivers/net/wireless/iwlwifi/dvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/dvm/Makefile
@@ -4,9 +4,10 @@ iwldvm-objs		+= main.o rs.o mac80211.o ucode.o tx.o
 iwldvm-objs		+= lib.o calib.o tt.o sta.o rx.o
 
 iwldvm-objs		+= power.o
-iwldvm-objs		+= scan.o led.o
+iwldvm-objs		+= scan.o
 iwldvm-objs		+= rxon.o devices.o
 
+iwldvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
 
 ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/../
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 3441f70..a6f22c3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -888,9 +888,11 @@ struct iwl_priv {
 
 	struct iwl_event_log event_log;
 
+#ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
 	unsigned long blink_on, blink_off;
 	bool led_registered;
+#endif
 
 	/* WoWLAN GTK rekey data */
 	u8 kck[NL80211_KCK_LEN], kek[NL80211_KEK_LEN];
diff --git a/drivers/net/wireless/iwlwifi/dvm/led.h b/drivers/net/wireless/iwlwifi/dvm/led.h
index 6a0817d..1c6b225 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.h
+++ b/drivers/net/wireless/iwlwifi/dvm/led.h
@@ -36,8 +36,20 @@ struct iwl_priv;
 #define IWL_LED_ACTIVITY       (0<<1)
 #define IWL_LED_LINK           (1<<1)
 
+#ifdef CONFIG_IWLWIFI_LEDS
 void iwlagn_led_enable(struct iwl_priv *priv);
 void iwl_leds_init(struct iwl_priv *priv);
 void iwl_leds_exit(struct iwl_priv *priv);
+#else
+static inline void iwlagn_led_enable(struct iwl_priv *priv)
+{
+}
+static inline void iwl_leds_init(struct iwl_priv *priv)
+{
+}
+static inline void iwl_leds_exit(struct iwl_priv *priv)
+{
+}
+#endif
 
 #endif /* __iwl_leds_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index ccdd3b7..c30d7f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -3,8 +3,9 @@ iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
 iwlmvm-y += power.o coex.o
-iwlmvm-y += led.o tt.o offloading.o
+iwlmvm-y += tt.o offloading.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
+iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
 
 ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/../
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b52d1c9..1575ac7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -589,7 +589,9 @@ struct iwl_mvm {
 	u32 *fw_error_rxf;
 	u32 fw_error_rxf_len;
 
+#ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
+#endif
 
 	struct ieee80211_vif *p2p_device_vif;
 
@@ -896,8 +898,18 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 					     struct iwl_rx_cmd_buffer *rxb,
 					     struct iwl_device_cmd *cmd);
 
+#ifdef CONFIG_IWLWIFI_LEDS
 int iwl_mvm_leds_init(struct iwl_mvm *mvm);
 void iwl_mvm_leds_exit(struct iwl_mvm *mvm);
+#else
+static inline int iwl_mvm_leds_init(struct iwl_mvm *mvm)
+{
+	return 0;
+}
+static inline void iwl_mvm_leds_exit(struct iwl_mvm *mvm)
+{
+}
+#endif
 
 /* D3 (WoWLAN, NetDetect) */
 int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
-- 
1.8.3.2

