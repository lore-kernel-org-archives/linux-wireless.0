Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43310 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3J3LpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:12 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so711396eek.15
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 02/12] ath10k: don't forget to kill fw error tasklet
Date: Wed, 30 Oct 2013 12:42:16 +0100
Message-Id: <1383133346-8135-3-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124523_479923_7D20AED8)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
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
index 05cdbf0..aa43466 100644
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

