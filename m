Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48381 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGFJhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:24 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so3148156wes.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/40] iwlwifi: mvm: remove 8000 HW family setting of adc sampling on nic config
Date: Sun,  6 Jul 2014 12:36:15 +0300
Message-Id: <1404639376-3792-39-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_785052_D5AE5B8D)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

This patch removes the setting of the ADC sampling bits in
the mvm nic configuration. This setting is not required by
the firmware, and furthermore - it interferes with the DBGC
when it is running in DRAM mode on PCIe.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 89a0956..7d7b2fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -166,8 +166,15 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	WARN_ON((radio_cfg_type << CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE) &
 		 ~CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE);
 
-	/* silicon bits */
-	reg_val |= CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI;
+	/*
+	 * TODO: Bits 7-8 of CSR in 8000 HW family set the ADC sampling, and
+	 * shouldn't be set to any non-zero value. The same is supposed to be
+	 * true of the other HW, but unsetting them (such as the 7260) causes
+	 * automatic tests to fail on seemingly unrelated errors. Need to
+	 * further investigate this, but for now we'll separate cases.
+	 */
+	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		reg_val |= CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI;
 
 	iwl_trans_set_bits_mask(mvm->trans, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
-- 
1.8.3.2

