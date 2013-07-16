Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62223 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3GPHUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:20:13 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infraread.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 05/10] ath10k: decouple suspend code
Date: Tue, 16 Jul 2013 09:19:48 +0200
Message-ID: <1373959193-5164-6-git-send-email-michal.kazior@tieto.com> (sfid-20130716_092024_720303_150ACE1F)
In-Reply-To: <1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split up fw-related and hw-related suspension code.

Although we don't advertise WoW support to
mac80211 yet it's useful to keep the code in
suspend/resume hooks.

At this point there's no need to keep pci pm ops.
In case of WoW mac80211 calls ath10k_suspend()
which should take care of entering low-power mode.
In case WoW is not available mac80211 will go
through regular interface teradown and use start/stop.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   28 -----
 drivers/net/wireless/ath/ath10k/core.h |    3 -
 drivers/net/wireless/ath/ath10k/hif.h  |   19 ++++
 drivers/net/wireless/ath/ath10k/mac.c  |   66 ++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c  |  176 ++++++++++----------------------
 5 files changed, 138 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3d75c6a..01c1d82 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -648,34 +648,6 @@ void ath10k_core_unregister(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
-int ath10k_core_target_suspend(struct ath10k *ar)
-{
-	int ret;
-
-	ath10k_dbg(ATH10K_DBG_CORE, "%s: called", __func__);
-
-	ret = ath10k_wmi_pdev_suspend_target(ar);
-	if (ret)
-		ath10k_warn("could not suspend target (%d)\n", ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(ath10k_core_target_suspend);
-
-int ath10k_core_target_resume(struct ath10k *ar)
-{
-	int ret;
-
-	ath10k_dbg(ATH10K_DBG_CORE, "%s: called", __func__);
-
-	ret = ath10k_wmi_pdev_resume_target(ar);
-	if (ret)
-		ath10k_warn("could not resume target (%d)\n", ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(ath10k_core_target_resume);
-
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Core module for QCA988X PCIe devices.");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d5b2533..5c94ea0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -365,7 +365,4 @@ void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar);
 void ath10k_core_unregister(struct ath10k *ar);
 
-int ath10k_core_target_suspend(struct ath10k *ar);
-int ath10k_core_target_resume(struct ath10k *ar);
-
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 00d2940..dcdea68 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -80,6 +80,9 @@ struct ath10k_hif_ops {
 	/* Power down the device and free up resources. stop() must be called
 	 * before this if start() was called earlier */
 	void (*power_down)(struct ath10k *ar);
+
+	int (*suspend)(struct ath10k *ar);
+	int (*resume)(struct ath10k *ar);
 };
 
 
@@ -154,4 +157,20 @@ static inline void ath10k_hif_power_down(struct ath10k *ar)
 	ar->hif.ops->power_down(ar);
 }
 
+static inline int ath10k_hif_suspend(struct ath10k *ar)
+{
+	if (!ar->hif.ops->suspend)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->suspend(ar);
+}
+
+static inline int ath10k_hif_resume(struct ath10k *ar)
+{
+	if (!ar->hif.ops->resume)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->resume(ar);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4627c16..febba7d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -20,6 +20,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 
+#include "hif.h"
 #include "core.h"
 #include "debug.h"
 #include "wmi.h"
@@ -2749,6 +2750,67 @@ static int ath10k_tx_last_beacon(struct ieee80211_hw *hw)
 	return 1;
 }
 
+#ifdef CONFIG_PM
+static int ath10k_suspend(struct ieee80211_hw *hw,
+			  struct cfg80211_wowlan *wowlan)
+{
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	ar->is_target_paused = false;
+
+	ret = ath10k_wmi_pdev_suspend_target(ar);
+	if (ret) {
+		ath10k_warn("could not suspend target (%d)\n", ret);
+		return 1;
+	}
+
+	ret = wait_event_interruptible_timeout(ar->event_queue,
+					       ar->is_target_paused == true,
+					       1 * HZ);
+	if (ret < 0) {
+		ath10k_warn("suspend interrupted (%d)\n", ret);
+		goto resume;
+	} else if (ret == 0) {
+		ath10k_warn("suspend timed out - target pause event never came\n");
+		goto resume;
+	}
+
+	ret = ath10k_hif_suspend(ar);
+	if (ret) {
+		ath10k_warn("could not suspend hif (%d)\n", ret);
+		goto resume;
+	}
+
+	return 0;
+resume:
+	ret = ath10k_wmi_pdev_resume_target(ar);
+	if (ret)
+		ath10k_warn("could not resume target (%d)\n", ret);
+	return 1;
+}
+
+static int ath10k_resume(struct ieee80211_hw *hw)
+{
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	ret = ath10k_hif_resume(ar);
+	if (ret) {
+		ath10k_warn("could not resume hif (%d)\n", ret);
+		return 1;
+	}
+
+	ret = ath10k_wmi_pdev_resume_target(ar);
+	if (ret) {
+		ath10k_warn("could not resume target (%d)\n", ret);
+		return 1;
+	}
+
+	return 0;
+}
+#endif
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -2769,6 +2831,10 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_frag_threshold		= ath10k_set_frag_threshold,
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
+#ifdef CONFIG_PM
+	.suspend			= ath10k_suspend,
+	.resume				= ath10k_resume,
+#endif
 };
 
 #define RATETAB_ENT(_rate, _rateid, _flags) { \
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c15b0c5..75f5427 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1796,6 +1796,55 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 		ath10k_do_pci_sleep(ar);
 }
 
+#ifdef CONFIG_PM
+
+#define ATH10K_PCI_PM_CONTROL 0x44
+
+static int ath10k_pci_hif_suspend(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct pci_dev *pdev = ar_pci->pdev;
+	u32 val;
+
+	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
+
+	if ((val & 0x000000ff) != 0x3) {
+		pci_save_state(pdev);
+		pci_disable_device(pdev);
+		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
+				       (val & 0xffffff00) | 0x03);
+	}
+
+	return 0;
+}
+
+static int ath10k_pci_hif_resume(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct pci_dev *pdev = ar_pci->pdev;
+	u32 val;
+
+	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
+
+	if ((val & 0x000000ff) != 0) {
+		pci_restore_state(pdev);
+		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
+				       val & 0xffffff00);
+		/*
+		 * Suspend/Resume resets the PCI configuration space,
+		 * so we have to re-disable the RETRY_TIMEOUT register (0x41)
+		 * to keep PCI Tx retries from interfering with C3 CPU state
+		 */
+		pci_read_config_dword(pdev, 0x40, &val);
+
+		if ((val & 0x0000ff00) != 0)
+			pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+	}
+
+	return 0;
+}
+#endif
+
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.send_head		= ath10k_pci_hif_send_head,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
@@ -1808,6 +1857,10 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 	.power_up		= ath10k_pci_hif_power_up,
 	.power_down		= ath10k_pci_hif_power_down,
+#ifdef CONFIG_PM
+	.suspend		= ath10k_pci_hif_suspend,
+	.resume			= ath10k_pci_hif_resume,
+#endif
 };
 
 static void ath10k_pci_ce_tasklet(unsigned long ptr)
@@ -2376,128 +2429,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	kfree(ar_pci);
 }
 
-#if defined(CONFIG_PM_SLEEP)
-
-#define ATH10K_PCI_PM_CONTROL 0x44
-
-static int ath10k_pci_suspend(struct device *device)
-{
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct ath10k *ar = pci_get_drvdata(pdev);
-	struct ath10k_pci *ar_pci;
-	u32 val;
-	int ret, retval;
-
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
-
-	if (!ar)
-		return -ENODEV;
-
-	ar_pci = ath10k_pci_priv(ar);
-	if (!ar_pci)
-		return -ENODEV;
-
-	if (ath10k_core_target_suspend(ar))
-		return -EBUSY;
-
-	ret = wait_event_interruptible_timeout(ar->event_queue,
-						ar->is_target_paused == true,
-						1 * HZ);
-	if (ret < 0) {
-		ath10k_warn("suspend interrupted (%d)\n", ret);
-		retval = ret;
-		goto resume;
-	} else if (ret == 0) {
-		ath10k_warn("suspend timed out - target pause event never came\n");
-		retval = EIO;
-		goto resume;
-	}
-
-	/*
-	 * reset is_target_paused and host can check that in next time,
-	 * or it will always be TRUE and host just skip the waiting
-	 * condition, it causes target assert due to host already
-	 * suspend
-	 */
-	ar->is_target_paused = false;
-
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
-
-	if ((val & 0x000000ff) != 0x3) {
-		pci_save_state(pdev);
-		pci_disable_device(pdev);
-		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
-				       (val & 0xffffff00) | 0x03);
-	}
-
-	return 0;
-resume:
-	ret = ath10k_core_target_resume(ar);
-	if (ret)
-		ath10k_warn("could not resume (%d)\n", ret);
-
-	return retval;
-}
-
-static int ath10k_pci_resume(struct device *device)
-{
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct ath10k *ar = pci_get_drvdata(pdev);
-	struct ath10k_pci *ar_pci;
-	int ret;
-	u32 val;
-
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
-
-	if (!ar)
-		return -ENODEV;
-	ar_pci = ath10k_pci_priv(ar);
-
-	if (!ar_pci)
-		return -ENODEV;
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		ath10k_warn("cannot enable PCI device: %d\n", ret);
-		return ret;
-	}
-
-	pci_read_config_dword(pdev, ATH10K_PCI_PM_CONTROL, &val);
-
-	if ((val & 0x000000ff) != 0) {
-		pci_restore_state(pdev);
-		pci_write_config_dword(pdev, ATH10K_PCI_PM_CONTROL,
-				       val & 0xffffff00);
-		/*
-		 * Suspend/Resume resets the PCI configuration space,
-		 * so we have to re-disable the RETRY_TIMEOUT register (0x41)
-		 * to keep PCI Tx retries from interfering with C3 CPU state
-		 */
-		pci_read_config_dword(pdev, 0x40, &val);
-
-		if ((val & 0x0000ff00) != 0)
-			pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
-	}
-
-	ret = ath10k_core_target_resume(ar);
-	if (ret)
-		ath10k_warn("target resume failed: %d\n", ret);
-
-	return ret;
-}
-
-static SIMPLE_DEV_PM_OPS(ath10k_dev_pm_ops,
-			 ath10k_pci_suspend,
-			 ath10k_pci_resume);
-
-#define ATH10K_PCI_PM_OPS (&ath10k_dev_pm_ops)
-
-#else
-
-#define ATH10K_PCI_PM_OPS NULL
-
-#endif /* CONFIG_PM_SLEEP */
-
 MODULE_DEVICE_TABLE(pci, ath10k_pci_id_table);
 
 static struct pci_driver ath10k_pci_driver = {
@@ -2505,7 +2436,6 @@ static struct pci_driver ath10k_pci_driver = {
 	.id_table = ath10k_pci_id_table,
 	.probe = ath10k_pci_probe,
 	.remove = ath10k_pci_remove,
-	.driver.pm = ATH10K_PCI_PM_OPS,
 };
 
 static int __init ath10k_pci_init(void)
-- 
1.7.9.5

