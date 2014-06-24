Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:33719 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaFXTwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:51 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so946066wes.7
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:50 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/27] iwlwifi: update trans->hw_rev 8000 hw family format
Date: Tue, 24 Jun 2014 22:52:09 +0300
Message-Id: <1403639541-4621-15-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_537878_B0529D29)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The format of the CSR_HW_REV register has changed in 8000
HW family. To keep backwards compatibility, we store the
value of this register as usual in trans->hw_rev, only we
store it in the old format in this variable.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0480857..5703a3d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1993,6 +1993,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	}
 
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
+	/*
+	 * In the 8000 HW family the format of the 4 bytes of CSR_HW_REV have
+	 * changed, and now the revision step also includes bit 0-1 (no more
+	 * "dash" value). To keep hw_rev backwards compatible - we'll store it
+	 * in the old format.
+	 */
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		trans->hw_rev = (trans->hw_rev & 0xfff0) |
+				((trans->hw_rev << 2) & 0xc);
+
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
 		 "PCI ID: 0x%04X:0x%04X", pdev->device, pdev->subsystem_device);
-- 
1.8.3.2

