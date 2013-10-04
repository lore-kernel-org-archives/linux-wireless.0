Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:52745 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JDKMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 06:12:19 -0400
Date: Fri, 4 Oct 2013 12:12:16 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-rt-users@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, tglx@linutronix.de
Subject: Re: Kernel panic in 3.10.10-rt7 (iwlwifi)
Message-ID: <20131004101216.GA17043@linutronix.de> (sfid-20131004_121225_553792_61B2C629)
References: <2CD18B42-2489-4DF7-98D6-4D002329DC63@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2CD18B42-2489-4DF7-98D6-4D002329DC63@m3y3r.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Thomas Meyer | 2013-09-15 23:49:29 [+0200]:

>Hi,
Hi,

>My system did lockup after short time of usage. I was only able to capture this screenshot:
>
>Any ideas?

the problem seems to be that they use sleeping locks in the primary irq
handler.

iwl_pcie_rx_replenish() takes the same lock (->irq_lock) and additionaly
->lock so I think tunrning everything into raw locks isn't very wise for
the latency.

The threaded handler takes for a very short time irq_lock lock. It also
takes the ->lock via (iwl_pcie_rxq_inc_wr_ptr()) with irqs off (that one
looks short, too) and others for instance via iwl_pcie_rx_handle().
Ideally the driver should hold one spinlock to synchronize the primary
and threaded irq handler while disabling the interrupt in the iwl
hardware. Everything else would then hold one or two mutex(es) and could
even allocate memory with GFP_KERNEL.

For now I think the simply thing would be just to let both handlers run
in the thread. Does this patch solve your problem?

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index aeb70e1..42567fc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1456,6 +1456,20 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
 };
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+static irqreturn_t iwl_rt_irq_handler(int irq, void *dev_id)
+{
+	irqreturn_t ret;
+
+	local_bh_disable();
+	ret = iwl_pcie_isr_ict(irq, dev_id);
+	local_bh_enable();
+	if (ret == IRQ_WAKE_THREAD)
+		ret = iwl_pcie_irq_handler(irq, dev_id);
+	return ret;
+}
+#endif
+
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       const struct pci_device_id *ent,
 				       const struct iwl_cfg *cfg)
@@ -1566,9 +1580,14 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+	if (request_threaded_irq(pdev->irq, NULL, iwl_rt_irq_handler,
+				 IRQF_SHARED | IRQF_ONESHOT, DRV_NAME, trans)) {
+#else
 	if (request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
 				 iwl_pcie_irq_handler,
 				 IRQF_SHARED, DRV_NAME, trans)) {
+#endif
 		IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
 		goto out_free_ict;
 	}
-- 
1.8.4.rc3


>With kind regards
>Thomas

Sebastian
