Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60743 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3J3LpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:12 -0400
Received: by mail-ee0-f45.google.com with SMTP id e50so573721eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 03/12] ath10k: split tasklet killing function
Date: Wed, 30 Oct 2013 12:42:17 +0100
Message-Id: <1383133346-8135-4-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124518_066841_8758D945)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function will soon be called from more than 1
place.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index aa43466..d9467e5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -877,21 +877,26 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_stop_ce(struct ath10k *ar)
+static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_compl *compl;
-	struct sk_buff *skb;
 	int i;
 
-	ath10k_ce_disable_interrupts(ar);
-
-	/* Cancel the pending tasklet */
 	tasklet_kill(&ar_pci->intr_tq);
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	for (i = 0; i < CE_COUNT; i++)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
+}
+
+static void ath10k_pci_stop_ce(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_pci_compl *compl;
+	struct sk_buff *skb;
+
+	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_kill_tasklet(ar);
 
 	/* Mark pending completions as aborted, so that upper layers free up
 	 * their associated resources */
-- 
1.8.4.rc3

