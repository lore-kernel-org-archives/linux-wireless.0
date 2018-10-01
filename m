Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770B7C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4202084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A4202084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbeJASrx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbeJASrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:52 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1p-0006wq-Eq; Mon, 01 Oct 2018 15:10:22 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:09:57 +0300
Message-Id: <20181001121010.29684-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/16] iwlwifi: nvm: get num of hw addresses from firmware
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

With NICs that don't read the NVM directly and instead rely on getting
the relevant data from the firmware, the number of reserved MAC
addresses was not added to the API. This caused the driver to assume
there is only one address which results in all interfaces getting the
same address. Update the API to fix this.

While at it, fix-up the comments with firmware api names to actually
match what we have in the firmware.

Fixes: e9e1ba3dbf00 ("iwlwifi: mvm: support getting nvm data from firmware")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 10 +++++++++-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 6c5338364794..d22c1eefba6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -165,7 +165,7 @@ struct iwl_nvm_access_resp {
  */
 struct iwl_nvm_get_info {
 	__le32 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_CMD_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_CMD_API_S_VER_1 */
 
 /**
  * enum iwl_nvm_info_general_flags - flags in NVM_GET_INFO resp
@@ -180,14 +180,14 @@ enum iwl_nvm_info_general_flags {
  * @flags: bit 0: 1 - empty, 0 - non-empty
  * @nvm_version: nvm version
  * @board_type: board type
- * @reserved: reserved
+ * @n_hw_addrs: number of reserved MAC addresses
  */
 struct iwl_nvm_get_info_general {
 	__le32 flags;
 	__le16 nvm_version;
 	u8 board_type;
-	u8 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_GENERAL_S_VER_1 */
+	u8 n_hw_addrs;
+} __packed; /* REGULATORY_NVM_GET_INFO_GENERAL_S_VER_2 */
 
 /**
  * enum iwl_nvm_mac_sku_flags - flags in &iwl_nvm_get_info_sku
@@ -231,7 +231,7 @@ struct iwl_nvm_get_info_sku {
 struct iwl_nvm_get_info_phy {
 	__le32 tx_chains;
 	__le32 rx_chains;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_PHY_SKU_SECTION_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_PHY_SKU_SECTION_S_VER_1 */
 
 #define IWL_NUM_CHANNELS (51)
 
@@ -245,7 +245,7 @@ struct iwl_nvm_get_info_regulatory {
 	__le32 lar_enabled;
 	__le16 channel_profile[IWL_NUM_CHANNELS];
 	__le16 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
 
 /**
  * struct iwl_nvm_get_info_rsp - response to get NVM data
@@ -259,7 +259,7 @@ struct iwl_nvm_get_info_rsp {
 	struct iwl_nvm_get_info_sku mac_sku;
 	struct iwl_nvm_get_info_phy phy_sku;
 	struct iwl_nvm_get_info_regulatory regulatory;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_CMD_RSP_S_VER_2 */
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_3 */
 
 /**
  * struct iwl_nvm_access_complete_cmd - NVM_ACCESS commands are completed
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 137dedc844ad..4ed8fb49a091 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1350,6 +1350,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	bool lar_fw_supported = !iwlwifi_mod_params.lar_disable &&
 				fw_has_capa(&fw->ucode_capa,
 					    IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+	bool empty_otp;
 	u32 mac_flags;
 	u32 sbands_flags = 0;
 
@@ -1365,7 +1366,9 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	}
 
 	rsp = (void *)hcmd.resp_pkt->data;
-	if (le32_to_cpu(rsp->general.flags) & NVM_GENERAL_FLAGS_EMPTY_OTP)
+	empty_otp = !!(le32_to_cpu(rsp->general.flags) &
+		       NVM_GENERAL_FLAGS_EMPTY_OTP);
+	if (empty_otp)
 		IWL_INFO(trans, "OTP is empty\n");
 
 	nvm = kzalloc(sizeof(*nvm) +
@@ -1389,6 +1392,11 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 
 	/* Initialize general data */
 	nvm->nvm_version = le16_to_cpu(rsp->general.nvm_version);
+	nvm->n_hw_addrs = rsp->general.n_hw_addrs;
+	if (nvm->n_hw_addrs == 0)
+		IWL_WARN(trans,
+			 "Firmware declares no reserved mac addresses. OTP is empty: %d\n",
+			 empty_otp);
 
 	/* Initialize MAC sku data */
 	mac_flags = le32_to_cpu(rsp->mac_sku.mac_sku_flags);
-- 
2.19.0

