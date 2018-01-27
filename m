Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38006 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbeA0BLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 20:11:23 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Add txq flags to debugfs
Date: Fri, 26 Jan 2018 17:11:19 -0800
Message-Id: <1517015479-15220-1-git-send-email-greearb@candelatech.com> (sfid-20180127_021127_493360_ABACCE8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Might help one figure out why aqm drivers may fail to transmit
frames sometimes.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/debugfs_sta.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c..570bc27 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -160,12 +160,12 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 		       sta->cparams.ecn ? "yes" : "no");
 	p += scnprintf(p,
 		       bufsz+buf-p,
-		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n");
+		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz+buf-p,
-			       "%d %d %u %u %u %u %u %u %u %u %u\n",
+			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s)\n",
 			       txqi->txq.tid,
 			       txqi->txq.ac,
 			       txqi->tin.backlog_bytes,
@@ -176,7 +176,11 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			       txqi->tin.overlimit,
 			       txqi->tin.collisions,
 			       txqi->tin.tx_bytes,
-			       txqi->tin.tx_packets);
+			       txqi->tin.tx_packets,
+			       txqi->flags,
+			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
+			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
+			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " NO-AMSDU" : "");
 	}
 
 	rcu_read_unlock();
-- 
2.4.11
