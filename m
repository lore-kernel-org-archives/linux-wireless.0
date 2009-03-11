Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZCKSNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwl3945: use iwl_led structure
Date: Wed, 11 Mar 2009 11:17:55 -0700
Message-Id: <1236795481-12757-3-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191314_667512_1B719430)
In-Reply-To: <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_led's structure from iwlwifi.
Patch also removes CONFIG_IWL3945_LEDS flag from Kconfig as 3945's led
support will now be enabled if user selects CONFIG_IWLWIFI_LEDS.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   10 +----
 drivers/net/wireless/iwlwifi/Makefile       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   66 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   18 +-------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 +---
 drivers/net/wireless/iwlwifi/iwl-led.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 8 files changed, 43 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index a894deb..8304f64 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,11 +6,9 @@ config IWLWIFI
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select MAC80211_LEDS if IWL3945_LEDS
-	select LEDS_CLASS if IWL3945_LEDS
 
 config IWLWIFI_LEDS
-	bool "Enable LED support in iwlagn driver"
+	bool "Enable LED support in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
 
 config IWLWIFI_RFKILL
@@ -122,9 +120,3 @@ config IWL3945_SPECTRUM_MEASUREMENT
 	depends on IWL3945
 	---help---
 	  This option will enable spectrum measurement for the iwl3945 driver.
-
-config IWL3945_LEDS
-	bool "Enable LEDS features in iwl3945 driver"
-	depends on IWL3945
-	---help---
-	  This option enables LEDS for the iwl3945 driver.
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index d5f8009..d79d97a 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -16,7 +16,6 @@ iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
-iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
-iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
+iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index a973ac1..ac22f59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -24,6 +24,7 @@
  *
  *****************************************************************************/
 
+#ifdef CONFIG_IWLWIFI_LEDS
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -163,8 +164,8 @@ static int iwl3945_led_associated(struct iwl_priv *priv, int led_id)
 static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
 {
-	struct iwl3945_led *led = container_of(led_cdev,
-					       struct iwl3945_led, led_dev);
+	struct iwl_led *led = container_of(led_cdev,
+					       struct iwl_led, led_dev);
 	struct iwl_priv *priv = led->priv;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -202,7 +203,7 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
  * Register led class with the system
  */
 static int iwl3945_led_register_led(struct iwl_priv *priv,
-				   struct iwl3945_led *led,
+				   struct iwl_led *led,
 				   enum led_type type, u8 set_led,
 				   char *trigger)
 {
@@ -315,66 +316,66 @@ int iwl3945_led_register(struct iwl_priv *priv)
 	priv->allow_blinking = 0;
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(priv->led39[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led39[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
+	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
+		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
 		 wiphy_name(priv->hw->wiphy));
 
-	priv->led39[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
-	priv->led39[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
-	priv->led39[IWL_LED_TRG_RADIO].led_pattern = NULL;
+	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
+	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led39[IWL_LED_TRG_RADIO],
+				   &priv->led[IWL_LED_TRG_RADIO],
 				   IWL_LED_TRG_RADIO, 1, trigger);
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(priv->led39[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led39[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
+	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
+		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led39[IWL_LED_TRG_ASSOC],
+				   &priv->led[IWL_LED_TRG_ASSOC],
 				   IWL_LED_TRG_ASSOC, 0, trigger);
 
 	/* for assoc always turn led on */
-	priv->led39[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
-	priv->led39[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
-	priv->led39[IWL_LED_TRG_ASSOC].led_pattern = NULL;
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(priv->led39[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led39[IWL_LED_TRG_RX].name), "iwl-%s::RX",
+	snprintf(priv->led[IWL_LED_TRG_RX].name,
+		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s::RX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led39[IWL_LED_TRG_RX],
+				   &priv->led[IWL_LED_TRG_RX],
 				   IWL_LED_TRG_RX, 0, trigger);
 
-	priv->led39[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
-	priv->led39[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
-	priv->led39[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
+	priv->led[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(priv->led39[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led39[IWL_LED_TRG_TX].name), "iwl-%s::TX",
+	snprintf(priv->led[IWL_LED_TRG_TX].name,
+		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s::TX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led39[IWL_LED_TRG_TX],
+				   &priv->led[IWL_LED_TRG_TX],
 				   IWL_LED_TRG_TX, 0, trigger);
 
-	priv->led39[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
-	priv->led39[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
-	priv->led39[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
+	priv->led[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
 
 	if (ret)
 		goto exit_fail;
@@ -388,7 +389,7 @@ exit_fail:
 
 
 /* unregister led class */
-static void iwl3945_led_unregister_led(struct iwl3945_led *led, u8 set_led)
+static void iwl3945_led_unregister_led(struct iwl_led *led, u8 set_led)
 {
 	if (!led->registered)
 		return;
@@ -403,9 +404,10 @@ static void iwl3945_led_unregister_led(struct iwl3945_led *led, u8 set_led)
 /* Unregister all led handlers */
 void iwl3945_led_unregister(struct iwl_priv *priv)
 {
-	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_ASSOC], 0);
-	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RX], 0);
-	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_TX], 0);
-	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RADIO], 1);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
 }
 
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 88185a6..3b65642 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -29,24 +29,10 @@
 
 struct iwl_priv;
 
-#ifdef CONFIG_IWL3945_LEDS
+#ifdef CONFIG_IWLWIFI_LEDS
 
 #include "iwl-led.h"
 
-struct iwl3945_led {
-	struct iwl_priv *priv;
-	struct led_classdev led_dev;
-	char name[32];
-
-	int (*led_on) (struct iwl_priv *priv, int led_id);
-	int (*led_off) (struct iwl_priv *priv, int led_id);
-	int (*led_pattern) (struct iwl_priv *priv, int led_id,
-			    unsigned int idx);
-
-	enum led_type type;
-	unsigned int registered;
-};
-
 extern int iwl3945_led_register(struct iwl_priv *priv);
 extern void iwl3945_led_unregister(struct iwl_priv *priv);
 extern void iwl3945_led_background(struct iwl_priv *priv);
@@ -55,6 +41,6 @@ extern void iwl3945_led_background(struct iwl_priv *priv);
 static inline int iwl3945_led_register(struct iwl_priv *priv) { return 0; }
 static inline void iwl3945_led_unregister(struct iwl_priv *priv) {}
 static inline void iwl3945_led_background(struct iwl_priv *priv) {}
-#endif /* CONFIG_IWL3945_LEDS */
 
+#endif /* IWLWIFI_LEDS*/
 #endif /* IWL3945_LEDS_H */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0a75053..9e6f9ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -554,7 +554,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				   struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-#ifdef CONFIG_IWL3945_LEDS
+#ifdef CONFIG_IWLWIFI_LEDS
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 #endif
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
@@ -583,7 +583,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				       (struct ieee80211_hdr *)rxb->skb->data,
 				       le32_to_cpu(rx_end->status), stats);
 
-#ifdef CONFIG_IWL3945_LEDS
+#ifdef CONFIG_IWLWIFI_LEDS
 	if (ieee80211_is_data(hdr->frame_control))
 		priv->rxtxpackets += len;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2176494..0baae80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -926,19 +926,12 @@ struct iwl_priv {
 	struct rfkill *rfkill;
 #endif
 
-#if defined(CONFIG_IWLWIFI_LEDS) || defined(CONFIG_IWL3945_LEDS)
+#ifdef CONFIG_IWLWIFI_LEDS
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
 	u64 led_tpt;
-#endif
-
-#ifdef CONFIG_IWLWIFI_LEDS
 	struct iwl_led led[IWL_LED_TRG_MAX];
-#endif
-
-#ifdef CONFIG_IWL3945_LEDS
-	struct iwl3945_led led39[IWL_LED_TRG_MAX];
 	unsigned int rxtxpackets;
 #endif
 	u16 active_rate;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 140fd8f..ef9b174 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -30,7 +30,7 @@
 
 struct iwl_priv;
 
-#if defined(CONFIG_IWLWIFI_LEDS) || defined(CONFIG_IWL3945_LEDS)
+#ifdef CONFIG_IWLWIFI_LEDS
 #include <linux/leds.h>
 
 #define IWL_LED_SOLID 11
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7ce32c9..fd3a529 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -890,7 +890,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
 		tx->timeout.pm_frame_timeout = 0;
-#ifdef CONFIG_IWL3945_LEDS
+#ifdef CONFIG_IWLWIFI_LEDS
 		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
 #endif
 	}
-- 
1.5.6.3

