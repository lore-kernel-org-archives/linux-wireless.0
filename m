Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35360 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaENHEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 03:04:44 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so1014403eek.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 00:04:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: retry warm reset a few times
Date: Wed, 14 May 2014 08:57:38 +0200
Message-Id: <1400050658-2763-3-git-send-email-michal.kazior@tieto.com> (sfid-20140514_090449_327847_6EA31871)
In-Reply-To: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
References: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes warm reset works upon retry. It might be
related to imperfect warm reset routine, but for
now let's just do the retries.

This should improve the reliability of some chips
that hang/crash with cold reset which is used as a
last resort if warm reset fails.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c9b14b4..c9e482e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -59,6 +59,7 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 
 /* how long wait to wait for target to initialise, in ms */
 #define ATH10K_PCI_TARGET_WAIT 3000
+#define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
 
@@ -2012,6 +2013,28 @@ err:
 	return ret;
 }
 
+static int ath10k_pci_hif_power_up_warm(struct ath10k *ar)
+{
+	int i, ret;
+
+	/*
+	 * Sometime warm reset succeeds after retries.
+	 *
+	 * FIXME: It might be possible to tune ath10k_pci_warm_reset() to work
+	 * at first try.
+	 */
+	for (i = 0; i < ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS; i++) {
+		ret = __ath10k_pci_hif_power_up(ar, false);
+		if (ret == 0)
+			break;
+
+		ath10k_warn("failed to warm reset (attempt %d out of %d): %d\n",
+			    i + 1, ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS, ret);
+	}
+
+	return ret;
+}
+
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
@@ -2023,10 +2046,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 * preferred (and safer) way to perform a device reset is through a
 	 * warm reset.
 	 *
-	 * Warm reset doesn't always work though (notably after a firmware
-	 * crash) so fall back to cold reset if necessary.
+	 * Warm reset doesn't always work though so fall back to cold reset may
+	 * be necessary.
 	 */
-	ret = __ath10k_pci_hif_power_up(ar, false);
+	ret = ath10k_pci_hif_power_up_warm(ar);
 	if (ret) {
 		ath10k_warn("failed to power up target using warm reset: %d\n",
 			    ret);
-- 
1.8.5.3

