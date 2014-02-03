Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34919 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBCU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:11 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so3349900ead.10
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:10 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/62] iwlwifi: 7265: add power limit/tx backoff translation table
Date: Mon,  3 Feb 2014 22:57:40 +0200
Message-Id: <1391461088-8082-34-git-send-email-egrumbach@gmail.com> (sfid-20140203_223007_309870_741CB8A7)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index a43e4d1..fbd262f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -197,6 +197,17 @@ const struct iwl_cfg iwl3160_n_cfg = {
 	.host_interrupt_operation_mode = true,
 };
 
+static const struct iwl_pwr_tx_backoff iwl7265_pwr_tx_backoffs[] = {
+	{.pwr = 1600, .backoff = 0},
+	{.pwr = 1300, .backoff = 467},
+	{.pwr = 900,  .backoff = 1900},
+	{.pwr = 800, .backoff = 2630},
+	{.pwr = 700, .backoff = 3720},
+	{.pwr = 600, .backoff = 5550},
+	{.pwr = 500, .backoff = 9350},
+	{0},
+};
+
 const struct iwl_cfg iwl7265_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
@@ -204,6 +215,7 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
 
 const struct iwl_cfg iwl7265_2n_cfg = {
@@ -213,6 +225,7 @@ const struct iwl_cfg iwl7265_2n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
 
 const struct iwl_cfg iwl7265_n_cfg = {
@@ -222,6 +235,7 @@ const struct iwl_cfg iwl7265_n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
1.7.9.5

