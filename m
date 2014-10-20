Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58217 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaJTM2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:36 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so3814553lbg.28
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/6] ath10k: split reset logic from power up
Date: Mon, 20 Oct 2014 14:14:41 +0200
Message-Id: <1413807282-27951-6-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142844_618463_BAD139F6)
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power up procedure was overly complex due to
warm/cold reset workarounds and issues.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * fix indentation [Kalle]

 drivers/net/wireless/ath/ath10k/pci.c | 151 ++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 54213ac..afd6056 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1782,10 +1782,86 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	return 0;
 }
 
-static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
+static int ath10k_pci_chip_reset(struct ath10k *ar)
+{
+	int i, ret;
+	u32 val;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip reset\n");
+
+	/* Some hardware revisions (e.g. CUS223v2) has issues with cold reset.
+	 * It is thus preferred to use warm reset which is safer but may not be
+	 * able to recover the device from all possible fail scenarios.
+	 *
+	 * Warm reset doesn't always work on first try so attempt it a few
+	 * times before giving up.
+	 */
+	for (i = 0; i < ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS; i++) {
+		ret = ath10k_pci_warm_reset(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to warm reset attempt %d of %d: %d\n",
+				    i + 1, ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS,
+				    ret);
+			continue;
+		}
+
+		/* FIXME: Sometimes copy engine doesn't recover after warm
+		 * reset. In most cases this needs cold reset. In some of these
+		 * cases the device is in such a state that a cold reset may
+		 * lock up the host.
+		 *
+		 * Reading any host interest register via copy engine is
+		 * sufficient to verify if device is capable of booting
+		 * firmware blob.
+		 */
+		ret = ath10k_pci_init_pipes(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to init copy engine: %d\n",
+				    ret);
+			continue;
+		}
+
+		ret = ath10k_pci_diag_read32(ar, QCA988X_HOST_INTEREST_ADDRESS,
+					     &val);
+		if (ret) {
+			ath10k_warn(ar, "failed to poke copy engine: %d\n",
+				    ret);
+			continue;
+		}
+
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip reset complete (warm)\n");
+		return 0;
+	}
+
+	if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY) {
+		ath10k_warn(ar, "refusing cold reset as requested\n");
+		return -EPERM;
+	}
+
+	ret = ath10k_pci_cold_reset(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to cold reset: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_pci_wait_for_target_init(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wait for target after cold reset: %d\n",
+			    ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip reset complete (cold)\n");
+
+	return 0;
+}
+
+static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
 
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
+
 	/*
 	 * Bring the target up cleanly.
 	 *
@@ -1796,13 +1872,9 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 	 * is in an unexpected state. We try to catch that here in order to
 	 * reset the Target and retry the probe.
 	 */
-	if (cold_reset)
-		ret = ath10k_pci_cold_reset(ar);
-	else
-		ret = ath10k_pci_warm_reset(ar);
-
+	ret = ath10k_pci_chip_reset(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to reset target: %d\n", ret);
+		ath10k_err(ar, "failed to reset chip: %d\n", ret);
 		goto err;
 	}
 
@@ -1812,12 +1884,6 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err;
 	}
 
-	ret = ath10k_pci_wait_for_target_init(ar);
-	if (ret) {
-		ath10k_err(ar, "failed to wait for target to init: %d\n", ret);
-		goto err_ce;
-	}
-
 	ret = ath10k_pci_init_config(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to setup init config: %d\n", ret);
@@ -1834,68 +1900,11 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 
 err_ce:
 	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_warm_reset(ar);
-err:
-	return ret;
-}
-
-static int ath10k_pci_hif_power_up_warm(struct ath10k *ar)
-{
-	int i, ret;
-
-	/*
-	 * Sometime warm reset succeeds after retries.
-	 *
-	 * FIXME: It might be possible to tune ath10k_pci_warm_reset() to work
-	 * at first try.
-	 */
-	for (i = 0; i < ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS; i++) {
-		ret = __ath10k_pci_hif_power_up(ar, false);
-		if (ret == 0)
-			break;
-
-		ath10k_warn(ar, "failed to warm reset (attempt %d out of %d): %d\n",
-			    i + 1, ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS, ret);
-	}
 
+err:
 	return ret;
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
-{
-	int ret;
-
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
-
-	/*
-	 * Hardware CUS232 version 2 has some issues with cold reset and the
-	 * preferred (and safer) way to perform a device reset is through a
-	 * warm reset.
-	 *
-	 * Warm reset doesn't always work though so fall back to cold reset may
-	 * be necessary.
-	 */
-	ret = ath10k_pci_hif_power_up_warm(ar);
-	if (ret) {
-		ath10k_warn(ar, "failed to power up target using warm reset: %d\n",
-			    ret);
-
-		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
-			return ret;
-
-		ath10k_warn(ar, "trying cold reset\n");
-
-		ret = __ath10k_pci_hif_power_up(ar, true);
-		if (ret) {
-			ath10k_err(ar, "failed to power up target using cold reset too (%d)\n",
-				   ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
-- 
1.8.5.3

