Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54448 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922Ab3HHIOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:14:18 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: use sizeof(*var) in kmalloc
Date: Thu, 8 Aug 2013 10:14:08 +0200
Message-ID: <1375949650-9699-3-git-send-email-michal.kazior@tieto.com> (sfid-20130808_101433_504777_28CE9C51)
In-Reply-To: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes checkpatch warning from the latest
3.11-rc kernel tree.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d95439b..1814af1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -803,8 +803,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 			continue;
 
 		for (i = 0; i < completions; i++) {
-			compl = kmalloc(sizeof(struct ath10k_pci_compl),
-					GFP_KERNEL);
+			compl = kmalloc(sizeof(*compl), GFP_KERNEL);
 			if (!compl) {
 				ath10k_warn("No memory for completion state\n");
 				ath10k_pci_stop_ce(ar);
-- 
1.7.9.5

