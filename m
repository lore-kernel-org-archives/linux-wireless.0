Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61259 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3GPHjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:11 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 08/10] ath10k: defer hw setup to start/stop mac80211 hooks
Date: Tue, 16 Jul 2013 09:38:57 +0200
Message-ID: <1373960339-8525-9-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093921_762042_B3A13ABB)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes suspend-to-disk. The hardware is now
re-initialized upon freeze/thaw properly.

This also makes suspend/resume re-initialize the
hardware as WoWLAN support is not done yet.

With some little work it should be possible to
support hw reconfiguration for hw/fw recovery.

HW must be initialized once before registering to
mac80211 because FW determinates what hw
capabilities can be advertised.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   46 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.c  |   56 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/pci.c  |   11 +------
 3 files changed, 81 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0e4a704..1d4c245 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -601,6 +601,7 @@ err_wmi_detach:
 err:
 	return status;
 }
+EXPORT_SYMBOL(ath10k_core_start);
 
 void ath10k_core_stop(struct ath10k *ar)
 {
@@ -608,18 +609,49 @@ void ath10k_core_stop(struct ath10k *ar)
 	ath10k_htt_detach(&ar->htt);
 	ath10k_wmi_detach(ar);
 }
+EXPORT_SYMBOL(ath10k_core_stop);
+
+/* mac80211 manages fw/hw initialization through start/stop hooks. However in
+ * order to know what hw capabilities should be advertised to mac80211 it is
+ * necessary to load the firmware (and tear it down immediately since start
+ * hook will try to init it again) before registering */
+static int ath10k_core_probe_fw(struct ath10k *ar)
+{
+	int ret;
+
+	ret = ath10k_hif_power_up(ar);
+	if (ret) {
+		ath10k_err("could not start pci hif (%d)\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_core_start(ar);
+	if (ret) {
+		ath10k_err("could not init core (%d)\n", ret);
+		ath10k_hif_power_down(ar);
+		return ret;
+	}
+
+	ath10k_core_stop(ar);
+	ath10k_hif_power_down(ar);
+	return 0;
+}
 
 int ath10k_core_register(struct ath10k *ar)
 {
 	int status;
 
-	status = ath10k_core_start(ar);
-	if (status)
-		goto err;
+	status = ath10k_core_probe_fw(ar);
+	if (status) {
+		ath10k_err("could not probe fw (%d)\n", status);
+		return status;
+	}
 
 	status = ath10k_mac_register(ar);
-	if (status)
-		goto err_core_stop;
+	if (status) {
+		ath10k_err("could not register to mac80211 (%d)\n", status);
+		return status;
+	}
 
 	status = ath10k_debug_create(ar);
 	if (status) {
@@ -631,9 +663,6 @@ int ath10k_core_register(struct ath10k *ar)
 
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
-err_core_stop:
-	ath10k_core_stop(ar);
-err:
 	return status;
 }
 EXPORT_SYMBOL(ath10k_core_register);
@@ -644,7 +673,6 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
-	ath10k_core_stop(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b9663e9..2dfd446 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1738,13 +1738,52 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 /*
  * Initialize various parameters with default vaules.
  */
+static void ath10k_halt(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->conf_mutex);
+
+	del_timer_sync(&ar->scan.timeout);
+	ath10k_offchan_tx_purge(ar);
+	ath10k_peer_cleanup_all(ar);
+	ath10k_core_stop(ar);
+	ath10k_hif_power_down(ar);
+
+	spin_lock_bh(&ar->data_lock);
+	if (ar->scan.in_progress) {
+		del_timer(&ar->scan.timeout);
+		ar->scan.in_progress = false;
+		ieee80211_scan_completed(ar->hw, true);
+	}
+	spin_unlock_bh(&ar->data_lock);
+}
+
 static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (ar->state != ATH10K_STATE_OFF) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = ath10k_hif_power_up(ar);
+	if (ret) {
+		ath10k_err("could not init hif (%d)\n", ret);
+		ar->state = ATH10K_STATE_OFF;
+		goto exit;
+	}
+
+	ret = ath10k_core_start(ar);
+	if (ret) {
+		ath10k_err("could not init core (%d)\n", ret);
+		ath10k_hif_power_down(ar);
+		ar->state = ATH10K_STATE_OFF;
+		goto exit;
+	}
+
 	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS, 1);
 	if (ret)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
@@ -1755,9 +1794,9 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
 
-	ar->state = ATH10K_STATE_ON;
 	ath10k_regd_update(ar);
 
+exit:
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 }
@@ -1767,17 +1806,8 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	del_timer_sync(&ar->scan.timeout);
-	ath10k_offchan_tx_purge(ar);
-	ath10k_peer_cleanup_all(ar);
-
-	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		del_timer(&ar->scan.timeout);
-		ar->scan.in_progress = false;
-		ieee80211_scan_completed(ar->hw, true);
-	}
-	spin_unlock_bh(&ar->data_lock);
+	if (ar->state == ATH10K_STATE_ON)
+		ath10k_halt(ar);
 
 	ar->state = ATH10K_STATE_OFF;
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 75f5427..bfe8561 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2362,22 +2362,14 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_iomap;
 	}
 
-	ret = ath10k_pci_hif_power_up(ar);
-	if (ret) {
-		ath10k_err("could not start pci hif (%d)\n", ret);
-		goto err_intr;
-	}
-
 	ret = ath10k_core_register(ar);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);
-		goto err_hif;
+		goto err_intr;
 	}
 
 	return 0;
 
-err_hif:
-	ath10k_pci_hif_power_down(ar);
 err_intr:
 	ath10k_pci_stop_intr(ar);
 err_iomap:
@@ -2416,7 +2408,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
-	ath10k_pci_hif_power_down(ar);
 	ath10k_pci_stop_intr(ar);
 
 	pci_set_drvdata(pdev, NULL);
-- 
1.7.9.5

