Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:36635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZA2T3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:29:48 -0500
From: Danny Kukawka <dkukawka@suse.de>
Date: Thu, 29 Jan 2009 20:29:34 +0100
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <hschaa@suse.de>,
	reinette chatre <reinette.chatre@intel.com>
Subject: [PATCH] fix led device naming for iwl driver
Message-Id: <200901292029.34976.dkukawka@suse.de> (sfid-20090129_202953_468455_551FD454)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Danny Kukawka <dkukawka@suse.de>
Subject: fix led device naming for iwl driver
    
Fixed led device naming for the iwl driver. Due to the
documentation of the led subsystem/class the naming should be
"devicename:colour:function" while not applying sections
should be left blank.
    
This should lead to e.g. "iwl-phy0::RX" instead of "iwl-phy0:RX".

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 iwl-led.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 501cffe..249f4c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -352,7 +352,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
+		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
 		 wiphy_name(priv->hw->wiphy));
 
 	priv->led[IWL_LED_TRG_RADIO].led_on = iwl4965_led_on_reg;
@@ -366,7 +366,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
+		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_ASSOC],
@@ -382,7 +382,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s:RX",
+		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s::RX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RX],
@@ -397,7 +397,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s:TX",
+		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s::TX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_TX],

-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
