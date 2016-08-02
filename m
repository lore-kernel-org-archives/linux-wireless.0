Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16778 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934496AbcHBMWX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:23 -0400
From: Baole Ni <baolex.ni@intel.com>
To: kvalo@qca.qualcomm.com, linux-wimax@intel.com,
	bkenward@solarflare.com, linux-driver@qlogic.com,
	computersforpeace@gmail.com, m.chehab@samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com,
	daniel@iogearbox.net, pabeni@redhat.com
Subject: [PATCH 0764/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:44:02 +0800
Message-Id: <20160802114402.595-1-baolex.ni@intel.com> (sfid-20160802_175201_270635_9DC24606)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8133d7b..0961a4e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -41,10 +41,10 @@ enum ath10k_pci_reset_mode {
 static unsigned int ath10k_pci_irq_mode = ATH10K_PCI_IRQ_AUTO;
 static unsigned int ath10k_pci_reset_mode = ATH10K_PCI_RESET_AUTO;
 
-module_param_named(irq_mode, ath10k_pci_irq_mode, uint, 0644);
+module_param_named(irq_mode, ath10k_pci_irq_mode, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi (default: 0)");
 
-module_param_named(reset_mode, ath10k_pci_reset_mode, uint, 0644);
+module_param_named(reset_mode, ath10k_pci_reset_mode, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 
 /* how long wait to wait for target to initialise, in ms */
-- 
2.9.2

