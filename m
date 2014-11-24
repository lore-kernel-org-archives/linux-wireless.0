Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35430 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaKXN1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 08:27:42 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so12152432wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 05:27:41 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: clean up num_peers locking
Date: Mon, 24 Nov 2014 14:15:08 +0100
Message-Id: <1416834909-7130-2-git-send-email-michal.kazior@tieto.com> (sfid-20141124_142751_225462_18850394)
In-Reply-To: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
References: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The var was supposed to be protected by data_lock
but it wasn't so in all instances. It's actually
not necessary to have a spinlock protected
num_peers so drop it.

All instances of num_peers are already within
conf_mutex sections so use that.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..be7e50b6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -560,7 +560,7 @@ struct ath10k {
 	struct list_head peers;
 	wait_queue_head_t peer_mapping_wq;
 
-	/* number of created peers; protected by data_lock */
+	/* protected by conf_mutex */
 	int num_peers;
 
 	struct work_struct offchan_tx_work;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7b5a888..3312e75 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -339,9 +339,8 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 			    addr, vdev_id, ret);
 		return ret;
 	}
-	spin_lock_bh(&ar->data_lock);
+
 	ar->num_peers++;
-	spin_unlock_bh(&ar->data_lock);
 
 	return 0;
 }
@@ -432,9 +431,7 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 	if (ret)
 		return ret;
 
-	spin_lock_bh(&ar->data_lock);
 	ar->num_peers--;
-	spin_unlock_bh(&ar->data_lock);
 
 	return 0;
 }
@@ -471,8 +468,9 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 		list_del(&peer->list);
 		kfree(peer);
 	}
-	ar->num_peers = 0;
 	spin_unlock_bh(&ar->data_lock);
+
+	ar->num_peers = 0;
 }
 
 /************************/
-- 
1.8.5.3

