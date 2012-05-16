Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab2EPUyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 9/9] iwlwifi: add debugging to shadow registers and fix typo
Date: Wed, 16 May 2012 22:54:30 +0200
Message-Id: <1337201670-21604-10-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225446_488270_BF7C233F)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Add a debugging log when using shadow
registers. Also fix a minor typo in this
connection.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 67b28aa..a52818b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -143,7 +143,7 @@ enum iwl_led_mode {
  * @chain_noise_scale: default chain noise scale used for gain computation
  * @wd_timeout: TX queues watchdog timeout
  * @max_event_log_size: size of event log buffer size for ucode event logging
- * @shadow_reg_enable: HW shadhow register bit
+ * @shadow_reg_enable: HW shadow register support
  * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
  * @no_idle_support: do not support idle mode
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 02ef48c..1e50401 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -829,6 +829,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	if (trans->cfg->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
 		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
+		IWL_DEBUG_INFO(trans, "Enabling shadow registers in device\n");
 	}
 
 	return 0;
-- 
1.7.10

