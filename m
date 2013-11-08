Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55568 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3KHHEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:55 -0500
Received: by mail-ee0-f43.google.com with SMTP id b47so792974eek.30
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:53 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 13/13] ath10k: reset device upon stopping/power down
Date: Fri,  8 Nov 2013 08:01:35 +0100
Message-Id: <1383894095-27998-14-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080508_540107_17932EA0)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should make sure the device won't issue any
interrupts nor access any memory after the driver
is stopped/freed thus avoid memory corruption in
some cases.

Reported-By: Ben Greear <greearb@candelatech.com>
Reported-By: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index eaa9956..46c94ce 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1353,6 +1353,13 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_cleanup_ce(ar);
 	ath10k_pci_buffer_cleanup(ar);
 
+	/* Make the sure the device won't access any structures on the host by
+	 * resetting it. The device was fed with PCI CE ringbuffer
+	 * configuration during init. If ringbuffers are freed and the device
+	 * were to access them this could lead to memory corruption on the
+	 * host. */
+	ath10k_pci_device_reset(ar);
+
 	ar_pci->started = 0;
 }
 
@@ -1915,6 +1922,7 @@ err_irq:
 	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_stop_intr(ar);
 	ath10k_pci_kill_tasklet(ar);
+	ath10k_pci_device_reset(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 err_ps:
@@ -1929,6 +1937,7 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	ath10k_pci_stop_intr(ar);
+	ath10k_pci_device_reset(ar);
 
 	ath10k_pci_ce_deinit(ar);
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-- 
1.8.4.rc3

