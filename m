Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40191 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaEOG4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 02:56:02 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so291746eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 23:56:01 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] ath10k: prevent hif_stop being called twice
Date: Thu, 15 May 2014 08:48:41 +0200
Message-Id: <1400136521-11184-3-git-send-email-michal.kazior@tieto.com> (sfid-20140515_085610_348840_657DF598)
In-Reply-To: <1400136521-11184-1-git-send-email-michal.kazior@tieto.com>
References: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
 <1400136521-11184-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently there was a bug discovered that involved
hif_stop() being called twice that ended up with a
double free_irq() call but it only manifested with
multiple MSI interrupts mapping.

Catch this kind of a problem early in driver
regardless of interrupt mapping.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3d0cd75..70e91ac 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1272,6 +1272,9 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
+	if (WARN_ON(!ar_pci->started))
+		return;
+
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
 		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
-- 
1.8.5.3

