Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46116 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab3HMFzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:55:06 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/4] ath10k: use sizeof(*var) in kmalloc
Date: Tue, 13 Aug 2013 07:54:55 +0200
Message-ID: <1376373297-32369-3-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075521_236566_A2B28760)
In-Reply-To: <1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
 <1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
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
index e2f9ef5..98edb31 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -805,8 +805,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
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

