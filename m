Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:32977 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbcCQJtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:49:01 -0400
Received: by mail-lf0-f41.google.com with SMTP id h198so38194592lfh.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 02:49:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix tx hang
Date: Thu, 17 Mar 2016 10:51:04 +0100
Message-Id: <1458208265-16715-2-git-send-email-michal.kazior@tieto.com> (sfid-20160317_104909_474776_0EE4A6E5)
In-Reply-To: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
References: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wake_tx_queue/push_pending logic had a bug
which could stop queues indefinitely effectivelly
breaking traffic.

Fixes: 299468782d94 ("ath10k: implement wake_tx_queue")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebff9c0a0784..74dd010a9188 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3779,13 +3779,13 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 		}
 
 		list_del_init(&artxq->list);
+		if (ret != -ENOENT)
+			list_add_tail(&artxq->list, &ar->txqs);
+
 		ath10k_htt_tx_txq_update(hw, txq);
 
-		if (artxq == last || (ret < 0 && ret != -ENOENT)) {
-			if (ret != -ENOENT)
-				list_add_tail(&artxq->list, &ar->txqs);
+		if (artxq == last || (ret < 0 && ret != -ENOENT))
 			break;
-		}
 	}
 
 	rcu_read_unlock();
-- 
2.1.4

