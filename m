Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54167 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaENMXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:23:35 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so1295255eek.22
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 05:23:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: prevent hif_stop being called twice
Date: Wed, 14 May 2014 14:16:26 +0200
Message-Id: <1400069786-9764-3-git-send-email-michal.kazior@tieto.com> (sfid-20140514_142340_570284_EC2A0426)
In-Reply-To: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
References: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
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
index 66b1f30..b58db5a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1271,6 +1271,9 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
+	if (WARN_ON(!ar_pci->started))
+		return;
+
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
 		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
-- 
1.8.5.3

