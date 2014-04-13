Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35959 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbaDMTVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:19 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so7390302wgh.35
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 47/47] iwlwifi: don't disable SCD chain extension on newer devices
Date: Sun, 13 Apr 2014 22:20:02 +0300
Message-Id: <1397416802-32403-47-git-send-email-egrumbach@gmail.com> (sfid-20140413_213516_215630_042C8B68)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

7000 device series have a fix for this hardware feature.
Stop disabling it, and get an improvement in Tx throughput.
This feature allows the scheduler to fetch more frames on
the fly while an A-MPDU is being built - which means that
we can get larger A-MPDU. This, of course, give an
improvement in the Tx throughput.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   | 1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c   | 2 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c   | 1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c   | 3 +++
 drivers/net/wireless/iwlwifi/iwl-config.h | 2 ++
 drivers/net/wireless/iwlwifi/pcie/tx.c    | 3 ++-
 6 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 854ba84..c3817fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -62,6 +62,7 @@ static const struct iwl_base_params iwl1000_base_params = {
 	.led_compensation = 51,
 	.wd_timeout = IWL_WATCHDOG_DISABLED,
 	.max_event_log_size = 128,
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_ht_params iwl1000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3e63323..21e5d08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -75,6 +75,7 @@ static const struct iwl_base_params iwl2000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+	.scd_chain_ext_wa = true,
 };
 
 
@@ -88,6 +89,7 @@ static const struct iwl_base_params iwl2030_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_ht_params iwl2000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6674f2c..332bbede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -61,6 +61,7 @@ static const struct iwl_base_params iwl5000_base_params = {
 	.led_compensation = 51,
 	.wd_timeout = IWL_WATCHDOG_DISABLED,
 	.max_event_log_size = 512,
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_ht_params iwl5000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8048de9..8f2c3c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -85,6 +85,7 @@ static const struct iwl_base_params iwl6000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_base_params iwl6050_base_params = {
@@ -97,6 +98,7 @@ static const struct iwl_base_params iwl6050_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
 	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_base_params iwl6000_g2_base_params = {
@@ -109,6 +111,7 @@ static const struct iwl_base_params iwl6000_g2_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+	.scd_chain_ext_wa = true,
 };
 
 static const struct iwl_ht_params iwl6000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 8c16730..7ce82d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -148,6 +148,7 @@ static inline u8 num_of_ant(u8 mask)
  * @shadow_reg_enable: HW shadow register support
  * @apmg_wake_up_wa: should the MAC access REQ be asserted when a command
  *	is in flight. This is due to a HW bug in 7260, 3160 and 7265.
+ * @scd_chain_ext_wa: should the chain extension feature in SCD be disabled.
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -163,6 +164,7 @@ struct iwl_base_params {
 	const bool shadow_reg_enable;
 	const bool pcie_l1_allowed;
 	const bool apmg_wake_up_wa;
+	const bool scd_chain_ext_wa;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 78a6ff2..dde6031 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -696,7 +696,8 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 	/* The chain extension of the SCD doesn't work well. This feature is
 	 * enabled by default by the HW, so we need to disable it manually.
 	 */
-	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
+	if (trans->cfg->base_params->scd_chain_ext_wa)
+		iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
 
 	iwl_trans_ac_txq_enable(trans, trans_pcie->cmd_queue,
 				trans_pcie->cmd_fifo);
-- 
1.8.3.2

