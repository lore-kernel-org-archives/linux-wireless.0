Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55844 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932427AbcISHan (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:09 +0300
Message-Id: <20160919073028.22065-6-luca@coelho.fi> (sfid-20160919_093101_267219_A58D2A10)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: check for valid ethernet address provided by OEM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In 9000 family products we added an option to let the OEM fuse the
mac address via registers. If these registers are zeroed we use the OTP
address instead. Make sure that the address provided by the OEM is valid
and, if not, fall back to the OTP address as well.

Fixes: commit 17c867bfe89b ("iwlwifi: add support for getting HW address from CSR")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 43f8f7d..adba3b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -564,11 +564,16 @@ static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 	__le32 mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_STRAP));
 	__le32 mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_STRAP));
 
-	/* If OEM did not fuse address - get it from OTP */
-	if (!mac_addr0 && !mac_addr1) {
-		mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_OTP));
-		mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_OTP));
-	}
+	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
+	/*
+	 * If the OEM fused a valid address, use it instead of the one in the
+	 * OTP
+	 */
+	if (is_valid_ether_addr(data->hw_addr))
+		return;
+
+	mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_OTP));
+	mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_OTP));
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 }
-- 
2.9.3
