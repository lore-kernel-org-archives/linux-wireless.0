Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34181 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169AbaH1IfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 04:35:25 -0400
Received: by mail-lb0-f173.google.com with SMTP id c11so496119lbj.4
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 01:35:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: kill tasklets after free_irq
Date: Thu, 28 Aug 2014 10:24:40 +0200
Message-Id: <1409214280-6492-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_103553_707337_90ECC587)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 5c771e7454d148af35e8b4297d00f880de79ea49
introduced a regression. On some systems spurious
interrupts could schedule a tasklet while tearing
down leading to, e.g.:

 BUG: unable to handle kernel paging request at fe589030
 IP: [<c1316fb0>] ioread32+0x30/0x40
 ...
 Call Trace:
  [<fe576c1b>] ath10k_pci_tasklet+0x1b/0x60 [ath10k_pci]
  [<c1053fbe>] tasklet_action+0x9e/0xb0
  [<c10534f1>] __do_softirq+0xf1/0x3f0
  [<c1053400>] ? ftrace_raw_event_irq_handler_entry+0xa0/0xa0
  [<c1004999>] do_softirq_own_stack+0x29/0x40
  <IRQ>
  [<c1053a76>] irq_exit+0x86/0xb0
 ...
  [<c132d522>] do_pci_disable_device+0x52/0x60
  [<c132d57f>] pci_disable_device+0x4f/0xb0
  [<c132a961>] ? __pci_set_master+0x51/0x80
  [<fe5740b3>] ath10k_pci_release+0x33/0x40 [ath10k_pci]
  [<fe575d4b>] ath10k_pci_remove+0x7b/0x90 [ath10k_pci]

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1ff2f34..b299205 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2554,6 +2554,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 err_free_irq:
 	ath10k_pci_free_irq(ar);
+	ath10k_pci_kill_tasklet(ar);
 
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
@@ -2590,6 +2591,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_irq(ar);
+	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_free_ce(ar);
-- 
1.8.5.3

