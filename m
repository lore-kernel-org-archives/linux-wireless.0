Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47575 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3IRNWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:22:24 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix num_sends_allowed replenishing
Date: Wed, 18 Sep 2013 15:22:17 +0200
Message-ID: <1379510537-8731-1-git-send-email-michal.kazior@tieto.com> (sfid-20130918_152227_651842_0DCCFB18)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent ce_sendlist removal patch has broken
num_sends_allowed incrementing. num_sends_allowed
exceeded initial values and could overflow.

This code was supposed to replenish
num_sends_allowed for partial sendlist items (i.e.
before final sendlist item from a sendlist was
completed and could be processed by completion
handlers).

Fortunately it seems it cause any major breakage,
yet.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f1faf46..dff23d9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -626,10 +626,6 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	while (ath10k_ce_completed_send_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes,
 					     &transfer_id) == 0) {
-		spin_lock_bh(&pipe_info->pipe_lock);
-		pipe_info->num_sends_allowed++;
-		spin_unlock_bh(&pipe_info->pipe_lock);
-
 		compl = get_free_compl(pipe_info);
 		if (!compl)
 			break;
-- 
1.7.9.5

