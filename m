Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbbLAKAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/41] iwlwifi: remove IWL_DL_LED
Date: Tue,  1 Dec 2015 11:59:07 +0200
Message-Id: <1448963947-24302-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_112252_524994_8CD8255A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

no need to have a separate debug level for a single
debug print (which is pretty much useless anyway).
remove them both.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/led.c   | 2 --
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index 178806f..1aabb5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -134,8 +134,6 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 		on = IWL_LED_SOLID;
 	}
 
-	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
-			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_blink_compensation(priv, on,
 				priv->cfg->base_params->led_compensation);
 	led_cmd.off = iwl_blink_compensation(priv, off,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
index 9bb36d7..e8dbb24 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
@@ -163,7 +163,6 @@ do {                                            			\
 #define IWL_DL_FW		0x00010000
 #define IWL_DL_RF_KILL		0x00020000
 #define IWL_DL_FW_ERRORS	0x00040000
-#define IWL_DL_LED		0x00080000
 /* 0x00F00000 - 0x00100000 */
 #define IWL_DL_RATE		0x00100000
 #define IWL_DL_CALIB		0x00200000
@@ -189,7 +188,6 @@ do {                                            			\
 #define IWL_DEBUG_RX(p, f, a...)	IWL_DEBUG(p, IWL_DL_RX, f, ## a)
 #define IWL_DEBUG_TX(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX, f, ## a)
 #define IWL_DEBUG_ISR(p, f, a...)	IWL_DEBUG(p, IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(p, f, a...)	IWL_DEBUG(p, IWL_DL_LED, f, ## a)
 #define IWL_DEBUG_WEP(p, f, a...)	IWL_DEBUG(p, IWL_DL_WEP, f, ## a)
 #define IWL_DEBUG_HC(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD, f, ## a)
 #define IWL_DEBUG_QUOTA(p, f, a...)	IWL_DEBUG(p, IWL_DL_QUOTA, f, ## a)
-- 
2.5.0

