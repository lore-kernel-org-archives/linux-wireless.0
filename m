Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/21] iwlwifi-5000: add apm_init handler for 5000 HW family
Date: Thu, 24 Apr 2008 11:55:25 -0700
Message-Id: <1209063338-6572-9-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205621_954319_14FD2272)
In-Reply-To: <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds apm_init handler for 5000 HW family

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   43 +++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3dd0b12..32c591c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,46 @@
 
 #define IWL5000_UCODE_API  "-1"
 
+static int iwl5000_apm_init(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
+
+	/* set "initialization complete" bit to move adapter
+	 * D0U* --> D0A* state */
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/* wait for clock stabilization */
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
+		return ret;
+	}
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
+	/* enable DMA */
+	iwl_write_prph(priv, APMG_CLK_EN_REG,
+			APMG_CLK_VAL_DMA_CLK_RQT);
+
+	udelay(20);
+
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
+	iwl_release_nic_access(priv);
+
+	return ret;
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -53,6 +93,9 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
+	.apm_ops = {
+		.init =	iwl5000_apm_init,
+	},
 	.eeprom_ops = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-- 
1.5.3.4

