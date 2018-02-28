Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57952 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932367AbeB1TMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 14:12:23 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Attempt to work around napi_synchronize hang.
Date: Wed, 28 Feb 2018 11:12:17 -0800
Message-Id: <1519845137-15365-1-git-send-email-greearb@candelatech.com> (sfid-20180228_201232_293570_57EF3A2C)
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
* since RFC:  Added similar code to ahb
  This seems needed back to at least 4.9 kernels.

 drivers/net/wireless/ath/ath10k/ahb.c  |  9 +++++++--
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  | 25 +++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index da770af..f826c59 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -641,6 +641,8 @@ static int ath10k_ahb_hif_start(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot ahb hif start\n");
 
 	napi_enable(&ar->napi);
+	ar->napi_enabled = true;
+
 	ath10k_ce_enable_interrupts(ar);
 	ath10k_pci_enable_legacy_irq(ar);
 
@@ -660,8 +662,11 @@ static void ath10k_ahb_hif_stop(struct ath10k *ar)
 
 	ath10k_pci_flush(ar);
 
-	napi_synchronize(&ar->napi);
-	napi_disable(&ar->napi);
+	if (ar->napi_enabled) {
+		napi_synchronize(&ar->napi);
+		napi_disable(&ar->napi);
+		ar->napi_enabled = false;
+	}
 }
 
 static int ath10k_ahb_hif_power_up(struct ath10k *ar)
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
