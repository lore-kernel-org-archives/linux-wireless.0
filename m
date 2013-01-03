Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3ACOtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:49:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Subject: [PATCH 11/12] iwlwifi: fix spelling and value in LED registers.
Date: Thu,  3 Jan 2013 15:46:15 +0100
Message-Id: <1357224376-27803-11-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154939_385849_60F7A1A1)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

Fix typo in the macro name and the wrong value.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/led.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/led.c b/drivers/net/wireless/iwlwifi/dvm/led.c
index bf479f7..844a17f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -69,7 +69,7 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 /* Set led register off */
 void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	iwl_write32(priv->trans, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	iwl_write32(priv->trans, CSR_LED_REG, CSR_LED_REG_TURN_ON);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 34a5287..b419a1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -381,8 +381,8 @@
 
 /* LED */
 #define CSR_LED_BSM_CTRL_MSK (0xFFFFFFDF)
-#define CSR_LED_REG_TRUN_ON (0x78)
-#define CSR_LED_REG_TRUN_OFF (0x38)
+#define CSR_LED_REG_TURN_ON (0x60)
+#define CSR_LED_REG_TURN_OFF (0x20)
 
 /* ANA_PLL */
 #define CSR50_ANA_PLL_CFG_VAL        (0x00880300)
-- 
1.8.0

