Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:39508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZAaOwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 09:52:51 -0500
From: Danny Kukawka <dkukawka@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] iwlwifi: another led naming fix
Date: Sat, 31 Jan 2009 15:52:40 +0100
Cc: Helmut Schaa <hschaa@suse.de>,
	reinette chatre <reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901311552.41484.dkukawka@suse.de> (sfid-20090131_155307_973654_D5BE028B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Danny Kukawka <dkukawka@suse.de>
Subject: iwlwifi: another led naming fix

Fixed led device naming for the iwlwifi (iwl-3945) driver. Due 
to the documentation of the led subsystem/class the naming should 
be "devicename:colour:function" while not applying sections
should be left blank.
    
This should lead to e.g. "iwl-%s::RX" instead of "iwl-%s:RX".

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 iwl-led.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 4c63890..09f9350 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -317,7 +317,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
+		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
 		 wiphy_name(priv->hw->wiphy));
 
 	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
@@ -333,7 +333,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
+		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
@@ -350,7 +350,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s:RX",
+		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s::RX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
@@ -366,7 +366,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
 	snprintf(priv->led[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s:TX",
+		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s::TX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,

-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
