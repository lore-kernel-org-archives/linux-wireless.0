Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38524 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEVOTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:19:47 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so2672303eek.17
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:19:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: make core registering async
Date: Thu, 22 May 2014 16:12:35 +0200
Message-Id: <1400767955-16313-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161951_842720_A62CA123)
In-Reply-To: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ath10k was built into the kernel it could stall
booting for 120 seconds by default (60 seconds for
each firmware API variant) waiting for firmware
files before userspace was ready or filesystems
mounted.

Fix this by making the core registering
asynchronous.

This also shoves off about 1 second from boot time
on most systems since the driver is now mostly
initialized in a worker and modprobe takes very
little time to complete.

As a side effect there's no way to propagate
registering errors to the pci subsystem but this
probably isn't really necessary.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 42 ++++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c  |  2 --
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bd4d1cc..d20ac66 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -941,22 +941,15 @@ static int ath10k_core_check_chip_id(struct ath10k *ar)
 	return 0;
 }
 
-int ath10k_core_register(struct ath10k *ar, u32 chip_id)
+void ath10k_core_register_work(struct work_struct *work)
 {
+	struct ath10k *ar = container_of(work, struct ath10k, register_work);
 	int status;
 
-	ar->chip_id = chip_id;
-
-	status = ath10k_core_check_chip_id(ar);
-	if (status) {
-		ath10k_err("Unsupported chip id 0x%08x\n", ar->chip_id);
-		return status;
-	}
-
 	status = ath10k_core_probe_fw(ar);
 	if (status) {
 		ath10k_err("could not probe fw (%d)\n", status);
-		return status;
+		goto err;
 	}
 
 	status = ath10k_mac_register(ar);
@@ -971,18 +964,42 @@ int ath10k_core_register(struct ath10k *ar, u32 chip_id)
 		goto err_unregister_mac;
 	}
 
-	return 0;
+	set_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags);
+	return;
 
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
 err_release_fw:
 	ath10k_core_free_firmware_files(ar);
-	return status;
+err:
+	return;
+}
+
+int ath10k_core_register(struct ath10k *ar, u32 chip_id)
+{
+	int status;
+
+	ar->chip_id = chip_id;
+
+	status = ath10k_core_check_chip_id(ar);
+	if (status) {
+		ath10k_err("Unsupported chip id 0x%08x\n", ar->chip_id);
+		return status;
+	}
+
+	queue_work(ar->workqueue, &ar->register_work);
+
+	return 0;
 }
 EXPORT_SYMBOL(ath10k_core_register);
 
 void ath10k_core_unregister(struct ath10k *ar)
 {
+	cancel_work_sync(&ar->register_work);
+
+	if (!test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags))
+		return;
+
 	/* We must unregister from mac80211 before we stop HTC and HIF.
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
@@ -1039,6 +1056,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	INIT_WORK(&ar->wmi_mgmt_tx_work, ath10k_mgmt_over_wmi_tx_work);
 	skb_queue_head_init(&ar->wmi_mgmt_tx_queue);
 
+	INIT_WORK(&ar->register_work, ath10k_core_register_work);
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
 
 	return ar;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2c1dfd7..7e33005 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -335,6 +335,7 @@ enum ath10k_dev_flags {
 	/* Indicates that ath10k device is during CAC phase of DFS */
 	ATH10K_CAC_RUNNING,
 	ATH10K_FLAG_FIRST_BOOT_DONE,
+	ATH10K_FLAG_CORE_REGISTERED,
 };
 
 struct ath10k {
@@ -470,6 +471,7 @@ struct ath10k {
 
 	enum ath10k_state state;
 
+	struct work_struct register_work;
 	struct work_struct restart_work;
 
 	/* cycle count is reported twice for each visited channel during scan.
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7d72b9c..dadf4ce 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2758,8 +2758,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	if (!ar_pci)
 		return;
 
-	tasklet_kill(&ar_pci->msi_fw_err);
-
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_ce(ar);
 
-- 
1.8.5.3

