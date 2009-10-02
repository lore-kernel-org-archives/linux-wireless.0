Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbZJBUtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/13] iwlwifi: replace iwl_poll_direct_bit with iwl_poll_bit for CSR access
Date: Fri,  2 Oct 2009 13:44:05 -0700
Message-Id: <1254516247-4085-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Replace iwl_poll_direct_bit with iwl_poll_bit when accessing CSR registers.
There is no need to power up the mac to access CSR registers.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Ben M Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c   |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   12 ++++++++----
 5 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index bb045a0..4115672 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -999,8 +999,9 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 	* D0U* --> D0A* state */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
 		goto out;
@@ -1177,8 +1178,9 @@ static int iwl3945_apm_reset(struct iwl_priv *priv)
 
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
-			 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
 	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 				APMG_CLK_VAL_BSM_CLK_RQT);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index dd10c42..f8eed9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -335,7 +335,8 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
@@ -411,7 +412,8 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d8dadbf..98baf8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -98,7 +98,8 @@ int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
@@ -138,7 +139,8 @@ int iwl5000_apm_reset(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7c0ef8e..dc7fd87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1338,7 +1338,7 @@ int iwl_apm_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	iwl_poll_direct_bit(priv, CSR_RESET,
+	iwl_poll_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index e14c995..6e83312 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -283,7 +283,8 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_direct_bit(priv, CSR_HW_IF_CONFIG_REG,
+		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
@@ -322,7 +323,8 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 		     CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
-	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				  25000);
 	if (ret < 0)
@@ -345,7 +347,8 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, u16 *eeprom_data)
 
 	_iwl_write32(priv, CSR_EEPROM_REG,
 		     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+	ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
+				  CSR_EEPROM_REG_READ_VALID_MSK,
 				  CSR_EEPROM_REG_READ_VALID_MSK,
 				  IWL_EEPROM_ACCESS_TIMEOUT);
 	if (ret < 0) {
@@ -537,7 +540,8 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 			_iwl_write32(priv, CSR_EEPROM_REG,
 				     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+			ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
+						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
 			if (ret < 0) {
-- 
1.5.6.3

