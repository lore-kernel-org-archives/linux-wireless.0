Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56831 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:42 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so17672637wgh.6
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:41 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/26] iwlwifi: don't load on 7265D with old NVM
Date: Tue,  2 Dec 2014 20:11:04 +0200
Message-Id: <1417543877-24193-13-git-send-email-egrumbach@gmail.com> (sfid-20141202_191149_159489_23E789ED)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

7265D are new devices that should always have a new NVM
(at least 0x0c11). The firmware has issues with older
versions of the NVM which are not and will not be available
to the common mortals.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 8155988..e5be2d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -89,6 +89,8 @@
 #define IWL3165_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265_NVM_VERSION		0x0a1d
 #define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
+#define IWL7265D_NVM_VERSION		0x0c11
+#define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 
 #define IWL7260_FW_PRE "iwlwifi-7260-"
 #define IWL7260_MODULE_FIRMWARE(api) IWL7260_FW_PRE __stringify(api) ".ucode"
@@ -275,7 +277,7 @@ const struct iwl_cfg iwl7265d_2ac_cfg = {
 	.fw_name_pre = IWL7265D_FW_PRE,
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7265_ht_params,
-	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
@@ -285,7 +287,7 @@ const struct iwl_cfg iwl7265d_2n_cfg = {
 	.fw_name_pre = IWL7265D_FW_PRE,
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7265_ht_params,
-	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
@@ -295,7 +297,7 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 	.fw_name_pre = IWL7265D_FW_PRE,
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7265_ht_params,
-	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_ver = IWL7265D_NVM_VERSION,
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
-- 
1.9.1

