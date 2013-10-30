Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56652 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3J3LpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:14 -0400
Received: by mail-ee0-f49.google.com with SMTP id e52so569347eek.22
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:12 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 04/12] ath10k: rename function to match it's role
Date: Wed, 30 Oct 2013 12:42:18 +0100
Message-Id: <1383133346-8135-5-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124606_286054_2CB52435)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What the function does is to actually wait for the
firmware indication bit to be set. Prerequisite
for this is having interrupts registered.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d9467e5..1e430d0 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -53,7 +53,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
 static void ath10k_pci_device_reset(struct ath10k *ar);
-static int ath10k_pci_reset_target(struct ath10k *ar);
+static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
 static int ath10k_pci_start_intr(struct ath10k *ar);
 static void ath10k_pci_stop_intr(struct ath10k *ar);
 
@@ -1857,7 +1857,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 */
 	ath10k_pci_device_reset(ar);
 
-	ret = ath10k_pci_reset_target(ar);
+	ret = ath10k_pci_wait_for_target_init(ar);
 	if (ret)
 		goto err_irq;
 
@@ -2257,7 +2257,7 @@ static void ath10k_pci_stop_intr(struct ath10k *ar)
 		pci_disable_msi(ar_pci->pdev);
 }
 
-static int ath10k_pci_reset_target(struct ath10k *ar)
+static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int wait_limit = 300; /* 3 sec */
-- 
1.8.4.rc3

