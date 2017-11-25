Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47502 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751869AbdKYQe6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:58 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:42 +0200
Message-Id: <20171125163444.24258-10-luca@coelho.fi> (sfid-20171125_173509_028994_A2121377)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 09/11] iwlwifi: fix the ALIVE notification layout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The ucode_major and ucode_minor were swapped. This has
no practical consequences since those fields are not used.
Same goes for umac_major and umac_minor which were only
printed under certain debug flags.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
index 3684a3e180e5..007bfe7656a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
@@ -95,8 +95,8 @@ enum {
 #define IWL_ALIVE_FLG_RFKILL	BIT(0)
 
 struct iwl_lmac_alive {
-	__le32 ucode_minor;
 	__le32 ucode_major;
+	__le32 ucode_minor;
 	u8 ver_subtype;
 	u8 ver_type;
 	u8 mac;
@@ -113,8 +113,8 @@ struct iwl_lmac_alive {
 } __packed; /* UCODE_ALIVE_NTFY_API_S_VER_3 */
 
 struct iwl_umac_alive {
-	__le32 umac_minor;		/* UMAC version: minor */
 	__le32 umac_major;		/* UMAC version: major */
+	__le32 umac_minor;		/* UMAC version: minor */
 	__le32 error_info_addr;		/* SRAM address for UMAC error log */
 	__le32 dbg_print_buff_addr;
 } __packed; /* UMAC_ALIVE_DATA_API_S_VER_2 */
-- 
2.15.0
