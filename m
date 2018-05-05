Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:40722 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeEEPKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 May 2018 11:10:46 -0400
Received: by mail-pg0-f66.google.com with SMTP id l2-v6so17345492pgc.7
        for <linux-wireless@vger.kernel.org>; Sat, 05 May 2018 08:10:45 -0700 (PDT)
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
From: Hao Wei Tee <angelsl@in04.sg>
Subject: [PATCH] iwlwifi: limit MSI-X IRQs to IWL_MAX_RX_HW_QUEUES - 1 to
 avoid num_rx_queues > IWL_MAX_RX_HW_QUEUES
Message-ID: <b14032bd-5843-9e0f-aa5b-af5289a7ff5f@in04.sg> (sfid-20180505_171052_073126_71152DAA)
Date: Sat, 5 May 2018 23:10:41 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there are 16 or more logical CPUs, we request for `IWL_MAX_RX_HW_QUEUES` (16)
IRQs only, but later on create `num_irqs+1` RX queues, which could end up more
than `IWL_MAX_RX_HW_QUEUES` if the OS does return us 16 IRQs. This wreaks lots
of havoc elsewhere later on due to code that uses `num_rx_queues` to calculate
array sizes.

Limit to IWL_MAX_RX_HW_QUEUES - 1 IRQs so num_rx_queues is never more than
IWL_MAX_RX_HW_QUEUES.
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6e9a9ecfb11c..f5c12924c836 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1607,7 +1607,7 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 		goto enable_msi;
 
 	nr_online_cpus = num_online_cpus();
-	max_irqs = min_t(u32, nr_online_cpus + 2, IWL_MAX_RX_HW_QUEUES);
+	max_irqs = min_t(u32, nr_online_cpus + 2, IWL_MAX_RX_HW_QUEUES - 1);
 	for (i = 0; i < max_irqs; i++)
 		trans_pcie->msix_entries[i].entry = i;
 
-- 
2.17.0
