Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45600 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3KHHEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:47 -0500
Received: by mail-ee0-f54.google.com with SMTP id c50so792971eek.27
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:46 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 02/13] ath10k: don't forget to kill fw error tasklet
Date: Fri,  8 Nov 2013 08:01:24 +0100
Message-Id: <1383894095-27998-3-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080456_436121_360A3B96)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible for FW error tasklet to be
executed during teardown. This could lead to
system crashes and/or memory corruption.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f054d4c..31cdde0 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -888,6 +888,7 @@ static void ath10k_pci_stop_ce(struct ath10k *ar)
 
 	/* Cancel the pending tasklet */
 	tasklet_kill(&ar_pci->intr_tq);
+	tasklet_kill(&ar_pci->msi_fw_err);
 
 	for (i = 0; i < CE_COUNT; i++)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
-- 
1.8.4.rc3

