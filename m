Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59682 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3KYNKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 08:10:20 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so2347768ead.24
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 05:10:19 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/8] ath10k: don't consume other's shared interrupts
Date: Mon, 25 Nov 2013 14:06:20 +0100
Message-Id: <1385384787-12470-2-git-send-email-michal.kazior@tieto.com> (sfid-20131125_141043_824934_6961781F)
In-Reply-To: <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
 <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k assumed all interrupts were directed to it.
This isn't the case for legacy shared interrupts.
ath10k consumed interrupts for other devices.

Check device irq status and return IRQ_NONE when
appropriate.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * move function definition up to avoid forward
   declaration in subsequent patches
 * remove check for legacy interrupts inside the
   irq_pending() by guaranteeing it is called
   only for legacy interrupts


 drivers/net/wireless/ath/ath10k/hw.h  |  1 +
 drivers/net/wireless/ath/ath10k/pci.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 8aeb46d..9535eaa 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -269,6 +269,7 @@ enum ath10k_mcast2ucast_mode {
 #define CORE_CTRL_CPU_INTR_MASK			0x00002000
 #define CORE_CTRL_ADDRESS			0x0000
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
+#define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			0x0014
 #define SCRATCH_3_ADDRESS			0x0030
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2457c8b..12fb12e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -201,6 +201,19 @@ static const struct ce_pipe_config target_ce_config_wlan[] = {
 	/* CE7 used only by Host */
 };
 
+static bool ath10k_pci_irq_pending(struct ath10k *ar)
+{
+	u32 cause;
+
+	/* Check if the shared legacy irq is for us */
+	cause = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				  PCIE_INTR_CAUSE_ADDRESS);
+	if (cause & (PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL))
+		return true;
+
+	return false;
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -2086,6 +2099,9 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	if (ar_pci->num_msi_intrs == 0) {
+		if (!ath10k_pci_irq_pending(ar))
+			return IRQ_NONE;
+
 		/*
 		 * IMPORTANT: INTR_CLR regiser has to be set after
 		 * INTR_ENABLE is set to 0, otherwise interrupt can not be
-- 
1.8.4.rc3

