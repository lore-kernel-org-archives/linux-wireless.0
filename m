Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63941 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbaHGJNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:54 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so3866790wgg.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: unmask ce irqs after posting rx buffers
Date: Thu,  7 Aug 2014 11:04:20 +0200
Message-Id: <1407402260-29854-6-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111400_548155_E92E7FFB)
In-Reply-To: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to enable the
interrupts before posting rx buffers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c195a11..c157717 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1039,24 +1039,18 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
 
-	ath10k_ce_enable_interrupts(ar);
-
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
-		goto err_stop;
+		return ret;
 	}
 
+	ath10k_ce_enable_interrupts(ar);
 	ar_pci->started = 1;
-	return 0;
 
-err_stop:
-	ath10k_ce_disable_interrupts(ar);
-	ath10k_pci_kill_tasklet(ar);
-
-	return ret;
+	return 0;
 }
 
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
-- 
1.8.5.3

