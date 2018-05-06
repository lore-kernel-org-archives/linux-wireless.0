Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34816 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeEFJd0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 May 2018 05:33:26 -0400
Received: by mail-pg0-f68.google.com with SMTP id j11-v6so18230087pgf.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2018 02:33:26 -0700 (PDT)
Subject: [PATCH v3] iwlwifi: compare with actual number of IRQs requested for,
 not number of CPUs
From: Hao Wei Tee <angelsl@in04.sg>
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
References: <b14032bd-5843-9e0f-aa5b-af5289a7ff5f@in04.sg>
 <0b07aa06-111b-4399-786d-056d9bba5cdd@in04.sg>
Message-ID: <a24f7893-e655-0384-c525-e4df7adb1a0c@in04.sg> (sfid-20180506_113330_541640_1A93DC4C)
Date: Sun, 6 May 2018 17:33:21 +0800
MIME-Version: 1.0
In-Reply-To: <0b07aa06-111b-4399-786d-056d9bba5cdd@in04.sg>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there are 16 or more logical CPUs, we request for `IWL_MAX_RX_HW_QUEUES` (16)
IRQs only as we limit to that number of IRQs, but later on we compare the
number of IRQs returned to nr_online_cpus+2 instead of max_irqs, the latter
being what we actually asked for. This ends up setting num_rx_queues to 17
which causes lots of out-of-bounds array accesses later on.

Compare to max_irqs instead, and also add an assertion in case num_rx_queues
> IWM_MAX_RX_HW_QUEUES.

Signed-off-by: Hao Wei Tee <angelsl@in04.sg>
---
I think this is a better fix than what I sent previously.

But you guys are probably looking into it now, so please disregard my
probably-incorrect fix.

Thanks.

 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6e9a9ecfb11c..aa469046f86c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1633,16 +1633,17 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 	 * Two interrupts less: non rx causes shared with FBQ and RSS.
 	 * More than two interrupts: we will use fewer RSS queues.
 	 */
-	if (num_irqs <= nr_online_cpus) {
+	if (num_irqs <= max_irqs - 2) {
 		trans_pcie->trans->num_rx_queues = num_irqs + 1;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
 			IWL_SHARED_IRQ_FIRST_RSS;
-	} else if (num_irqs == nr_online_cpus + 1) {
+	} else if (num_irqs == max_irqs - 1) {
 		trans_pcie->trans->num_rx_queues = num_irqs;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
 	} else {
 		trans_pcie->trans->num_rx_queues = num_irqs - 1;
 	}
+	WARN_ON(trans_pcie->trans->num_rx_queues > IWL_MAX_RX_HW_QUEUES);
 
 	trans_pcie->alloc_vecs = num_irqs;
 	trans_pcie->msix_enabled = true;
-- 
2.17.0
