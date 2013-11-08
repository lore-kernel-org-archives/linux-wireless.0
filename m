Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42760 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3KHHEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:52 -0500
Received: by mail-ea0-f170.google.com with SMTP id q10so705071eaj.15
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:51 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 09/13] ath10k: propagate ath10k_ce_disable_interrupts() errors
Date: Fri,  8 Nov 2013 08:01:31 +0100
Message-Id: <1383894095-27998-10-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080504_637565_E112FBD2)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This shouldn't be silenced. This will be necessary
for PCI init code reordering.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 7 +++++--
 drivers/net/wireless/ath/ath10k/ce.h  | 2 +-
 drivers/net/wireless/ath/ath10k/pci.c | 6 +++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 657e8f2..ab22d14 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -792,13 +792,13 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 	ath10k_pci_sleep(ar);
 }
 
-void ath10k_ce_disable_interrupts(struct ath10k *ar)
+int ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
 	int ce_id, ret;
 
 	ret = ath10k_pci_wake(ar);
 	if (ret)
-		return;
+		return ret;
 
 	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
 		u32 ctrl_addr = ath10k_ce_base_address(ce_id);
@@ -807,7 +807,10 @@ void ath10k_ce_disable_interrupts(struct ath10k *ar)
 		ath10k_ce_error_intr_disable(ar, ctrl_addr);
 		ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
 	}
+
 	ath10k_pci_sleep(ar);
+
+	return 0;
 }
 
 void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 15d45b5..67dbde6 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -234,7 +234,7 @@ void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state);
 /*==================CE Interrupt Handlers====================*/
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
-void ath10k_ce_disable_interrupts(struct ath10k *ar);
+int ath10k_ce_disable_interrupts(struct ath10k *ar);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2b4f7d3..e41665f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -879,8 +879,12 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_compl *compl;
 	struct sk_buff *skb;
+	int ret;
+
+	ret = ath10k_ce_disable_interrupts(ar);
+	if (ret)
+		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
 
-	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_kill_tasklet(ar);
 
 	/* Mark pending completions as aborted, so that upper layers free up
-- 
1.8.4.rc3

