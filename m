Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54096 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3KHHEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:48 -0500
Received: by mail-ea0-f173.google.com with SMTP id g10so847973eak.32
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:47 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 03/13] ath10k: split tasklet killing function
Date: Fri,  8 Nov 2013 08:01:25 +0100
Message-Id: <1383894095-27998-4-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080452_710266_98E3B679)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function will soon be called from more than 1
place.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 31cdde0..a001ff2 100644
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

