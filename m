Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42890 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732128AbeG3STn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 14:19:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Protect against buggy firmware.
Date: Mon, 30 Jul 2018 09:43:49 -0700
Message-Id: <1532969029-12926-1-git-send-email-greearb@candelatech.com> (sfid-20180730_184418_924170_978EA408)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

While testing some buggy wave-2 firmware, I was seeing full
kernel crashes.  Adding this additional check keeps
the kernel from crashing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 478cc67..8ab949d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2644,9 +2644,9 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 	rcu_read_lock();
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer) {
-		ath10k_warn(ar, "Invalid peer id %d peer stats buffer\n",
-			    peer_id);
+	if (!peer || !peer->sta) {
+		ath10k_warn(ar, "Invalid peer id %d or peer stats buffer, peer: %p  sta: %p\n",
+			    peer_id, peer, peer ? peer->sta : NULL);
 		goto out;
 	}
 
-- 
2.4.11
