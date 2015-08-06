Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55725
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755135AbbHFKoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 06:44:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: fix build with CONFIG_ATH9K_STATION_STATISTICS=y
Date: Thu,  6 Aug 2015 12:44:30 +0200
Message-Id: <1438857870-18580-1-git-send-email-nbd@openwrt.org> (sfid-20150806_124439_941279_CE263918)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes: 592fa228f213 ("ath9k: remove struct ath_atx_ac")
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index ffca918..c2ca57a 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -26,12 +26,11 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 	struct ath_node *an = file->private_data;
 	struct ath_softc *sc = an->sc;
 	struct ath_atx_tid *tid;
-	struct ath_atx_ac *ac;
 	struct ath_txq *txq;
 	u32 len = 0, size = 4096;
 	char *buf;
 	size_t retval;
-	int tidno, acno;
+	int tidno;
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
@@ -49,26 +48,13 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 			 an->mpdudensity);
 
 	len += scnprintf(buf + len, size - len,
-			 "%2s%7s\n", "AC", "SCHED");
-
-	for (acno = 0, ac = &an->ac[acno];
-	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
-		txq = ac->txq;
-		ath_txq_lock(sc, txq);
-		len += scnprintf(buf + len, size - len,
-				 "%2d%7d\n",
-				 acno, ac->sched);
-		ath_txq_unlock(sc, txq);
-	}
-
-	len += scnprintf(buf + len, size - len,
 			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
 			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
 			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
 
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
-		txq = tid->ac->txq;
+		txq = tid->txq;
 		ath_txq_lock(sc, txq);
 		if (tid->active) {
 			len += scnprintf(buf + len, size - len,
@@ -80,7 +66,7 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 					 tid->baw_head,
 					 tid->baw_tail,
 					 tid->bar_index,
-					 tid->sched);
+					 !list_empty(&tid->list));
 		}
 		ath_txq_unlock(sc, txq);
 	}
-- 
2.2.2

