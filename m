Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40697 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaBCU60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:26 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3854391eek.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:25 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/62] iwlwifi: pcie: Disable L0S exit timer for 8000 HW family
Date: Mon,  3 Feb 2014 22:57:12 +0200
Message-Id: <1391461088-8082-6-git-send-email-egrumbach@gmail.com> (sfid-20140203_215832_444977_2EC4B704)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

This configuration is invalid for this family.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 53a3457..ff7d70d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -132,8 +132,9 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	 */
 
 	/* Disable L0S exit timer (platform NMI Work/Around) */
-	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+			    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	/*
 	 * Disable L0s without affecting L1;
-- 
1.7.9.5

