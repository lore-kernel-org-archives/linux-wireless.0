Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50533 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaIUTWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:44 -0400
Received: by mail-wi0-f170.google.com with SMTP id fb4so1790946wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/17] iwlwifi: pcie: fix HW_REV saving for 8000 series
Date: Sun, 21 Sep 2014 22:22:13 +0300
Message-Id: <1411327338-23099-12-git-send-email-egrumbach@gmail.com> (sfid-20140921_212304_185065_31EAC563)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Align the trans->hw_rev variable format with previous series
format.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ae99240..1393bac 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2190,7 +2190,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	 */
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
 		trans->hw_rev = (trans->hw_rev & 0xfff0) |
-				(CSR_HW_REV_STEP(trans->hw_rev << 2));
+				(CSR_HW_REV_STEP(trans->hw_rev << 2) << 2);
 
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
-- 
1.9.1

