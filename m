Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41762 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbeB1BWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 20:22:53 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath10k:  Attempt to work around napi_synchronize hang.
Date: Tue, 27 Feb 2018 17:22:45 -0800
Message-Id: <1519780965-15292-1-git-send-email-greearb@candelatech.com> (sfid-20180228_022301_944916_DBD22DE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Calling napi_disable twice in a row (w/out starting it and/or without
having NAPI active leads to deadlock because napi_disable sets
NAPI_STATE_SCHED and NAPI_STATE_NPSVC when it returns, as far as I
can tell.  So, guard this call to napi_disable.  I believe the
failure case is something like this:
 rmmod ath10k_pci ath10k_core
   Firmware crashes before hif_stop is called by the rmmod path
   The crash handling logic calls hif_stop
   Then rmmod gets around to calling hif_stop, but spins endlessly
   in napi_synchronize.

I think one way this could happen is that ath10k_stop checks
for state != ATH10K_STATE_OFF, but STATE_RESTARTING is also
a possibility.  That might be how we can have hif_stop called twice
without a hif_start in between. --Ben

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  | 25 +++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 72b4495..c7ba49f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1205,6 +1205,7 @@ struct ath10k {
 	/* NAPI */
 	struct net_device napi_dev;
 	struct napi_struct napi;
+	bool napi_enabled;
 
 	struct work_struct stop_scan_work;
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 398e413..9131e15 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1956,6 +1956,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	napi_enable(&ar->napi);
+	ar->napi_enabled = true;
 
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
@@ -2086,8 +2087,28 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_irq_disable(ar);
 	ath10k_pci_irq_sync(ar);
 	ath10k_pci_flush(ar);
-	napi_synchronize(&ar->napi);
-	napi_disable(&ar->napi);
+
+	/* Calling napi_disable twice in a row (w/out starting it and/or without
+	 * having NAPI active leads to deadlock because napi_disable sets
+	 * NAPI_STATE_SCHED and NAPI_STATE_NPSVC when it returns, as far as I
+	 * can tell.  So, guard this call to napi_disable.  I believe the
+	 * failure case is something like this:
+	 * rmmod ath10k_pci ath10k_core
+	 *   Firmware crashes before hif_stop is called by the rmmod path
+	 *   The crash handling logic calls hif_stop
+         *   Then rmmod gets around to calling hif_stop, but spins endlessly
+	 *   in napi_synchronize.
+	 *
+	 *  I think one way this could happen is that ath10k_stop checks
+	 *  for state != ATH10K_STATE_OFF, but STATE_RESTARTING is also
+	 *  a possibility.  That might be how we can have hif_stop called twice
+	 *  without a hif_start in between. --Ben
+	 */
+	if (ar->napi_enabled) {
+		napi_synchronize(&ar->napi);
+		napi_disable(&ar->napi);
+		ar->napi_enabled = false;
+	}
 
 	spin_lock_irqsave(&ar_pci->ps_lock, flags);
 	WARN_ON(ar_pci->ps_wake_refcount > 0);
-- 
2.4.11
