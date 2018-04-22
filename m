Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751234AbeDVI2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:28:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:38 +0300
Message-Id: <20180422082745.9743-6-luca@coelho.fi> (sfid-20180422_102821_520094_86745BB1)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 05/12] iwlwifi: support new csr addresses for hw address
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

In future devices we use different csr addresses for hw addresses.
Update csr addresses to support new and legacy devices.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-config.h   | 20 +++++++++++++++++--
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 14 +++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7752794d0437..cfd14e5ea59c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -313,6 +313,10 @@ struct iwl_pwr_tx_backoff {
  * @flag_master_dis: disable master
  * @flag_stop_master: stop master
  * @addr_sw_reset: address for resetting the device
+ * @mac_addr0_otp: first part of MAC address from OTP
+ * @mac_addr1_otp: second part of MAC address from OTP
+ * @mac_addr0_strap: first part of MAC address from strap
+ * @mac_addr1_strap: second part of MAC address from strap
  */
 struct iwl_csr_params {
 	u8 flag_sw_reset;
@@ -323,6 +327,10 @@ struct iwl_csr_params {
 	u8 flag_master_dis;
 	u8 flag_stop_master;
 	u8 addr_sw_reset;
+	u32 mac_addr0_otp;
+	u32 mac_addr1_otp;
+	u32 mac_addr0_strap;
+	u32 mac_addr1_strap;
 };
 
 /**
@@ -451,7 +459,11 @@ static const struct iwl_csr_params iwl_csr_v1 = {
 	.flag_sw_reset = 7,
 	.flag_master_dis = 8,
 	.flag_stop_master = 9,
-	.addr_sw_reset = (CSR_BASE + 0x020)
+	.addr_sw_reset = (CSR_BASE + 0x020),
+	.mac_addr0_otp = 0x380,
+	.mac_addr1_otp = 0x384,
+	.mac_addr0_strap = 0x388,
+	.mac_addr1_strap = 0x38C
 };
 
 static const struct iwl_csr_params iwl_csr_v2 = {
@@ -462,7 +474,11 @@ static const struct iwl_csr_params iwl_csr_v2 = {
 	.flag_master_dis = 28,
 	.flag_stop_master = 29,
 	.flag_sw_reset = 31,
-	.addr_sw_reset = (CSR_BASE + 0x024)
+	.addr_sw_reset = (CSR_BASE + 0x024),
+	.mac_addr0_otp = 0x30,
+	.mac_addr1_otp = 0x34,
+	.mac_addr0_strap = 0x38,
+	.mac_addr1_strap = 0x3C
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 6d33c14579d9..aa83db5744df 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -579,8 +579,12 @@ static void iwl_flip_hw_address(__le32 mac_addr0, __le32 mac_addr1, u8 *dest)
 static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 					struct iwl_nvm_data *data)
 {
-	__le32 mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_STRAP));
-	__le32 mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_STRAP));
+	__le32 mac_addr0 =
+		cpu_to_le32(iwl_read32(trans,
+				       trans->cfg->csr->mac_addr0_strap));
+	__le32 mac_addr1 =
+		cpu_to_le32(iwl_read32(trans,
+				       trans->cfg->csr->mac_addr1_strap));
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 	/*
@@ -590,8 +594,10 @@ static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 	if (is_valid_ether_addr(data->hw_addr))
 		return;
 
-	mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_OTP));
-	mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_OTP));
+	mac_addr0 = cpu_to_le32(iwl_read32(trans,
+					   trans->cfg->csr->mac_addr0_otp));
+	mac_addr1 = cpu_to_le32(iwl_read32(trans,
+					   trans->cfg->csr->mac_addr1_otp));
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 }
-- 
2.17.0
