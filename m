Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56614 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaAMCEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/5] ath9k: Show only active TIDs in node_aggr
Date: Mon, 13 Jan 2014 07:29:28 +0530
Message-Id: <1389578371-23943-2-git-send-email-sujith@msujith.org> (sfid-20140113_030457_643455_FECD5967)
In-Reply-To: <1389578371-23943-1-git-send-email-sujith@msujith.org>
References: <1389578371-23943-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 3fe2bab2..3d11968 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -66,11 +66,19 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 		txq = tid->ac->txq;
 		ath_txq_lock(sc, txq);
-		len += scnprintf(buf + len, size - len,
-				 "%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
-				 tid->tidno, tid->seq_start, tid->seq_next,
-				 tid->baw_size, tid->baw_head, tid->baw_tail,
-				 tid->bar_index, tid->sched, tid->paused);
+		if (tid->active) {
+			len += scnprintf(buf + len, size - len,
+					 "%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
+					 tid->tidno,
+					 tid->seq_start,
+					 tid->seq_next,
+					 tid->baw_size,
+					 tid->baw_head,
+					 tid->baw_tail,
+					 tid->bar_index,
+					 tid->sched,
+					 tid->paused);
+		}
 		ath_txq_unlock(sc, txq);
 	}
 exit:
-- 
1.8.5.2

