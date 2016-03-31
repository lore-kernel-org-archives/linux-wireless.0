Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49416 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbcCaU7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 16:59:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] ath10k:  Ensure peer_map references are cleaned up.
Date: Thu, 31 Mar 2016 13:59:45 -0700
Message-Id: <1459457986-29222-2-git-send-email-greearb@candelatech.com> (sfid-20160331_230003_518885_D9261912)
In-Reply-To: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

While debugging OS crashes due to firmware crashes, I enabled
kasan, and it noticed that peer objects were being used-after-freed.

Looks like there are two places we could be leaving stale references
in the peer-map, so clean that up.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a81ca2..07b155d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -794,6 +794,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 {
 	struct ath10k_peer *peer, *tmp;
 	int peer_id;
+	int i;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -812,6 +813,15 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 			ar->peer_map[peer_id] = NULL;
 		}
 
+		/* Double check that peer is properly un-referenced from the peer_map */
+		for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
+			if (ar->peer_map[i] == peer) {
+				ath10k_warn(ar, "ERROR:  Faile to properly clean up peer: %p %pM, idx: %d, will fix.\n",
+					    peer, peer->addr, i);
+				ar->peer_map[i] = NULL;
+			}
+		}
+
 		list_del(&peer->list);
 		kfree(peer);
 		ar->num_peers--;
@@ -840,6 +850,7 @@ void ath10k_dump_peer_info(struct ath10k *ar)
 static void ath10k_peer_cleanup_all(struct ath10k *ar)
 {
 	struct ath10k_peer *peer, *tmp;
+	int i;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -850,6 +861,11 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 		list_del(&peer->list);
 		kfree(peer);
 	}
+
+	/* Clean up peer-map */
+	for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++)
+		ar->peer_map[i] = NULL;
+
 	spin_unlock_bh(&ar->data_lock);
 
 	ar->num_peers = 0;
-- 
2.4.3

