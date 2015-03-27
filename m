Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46108 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbbC0RAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 13:00:40 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: use PRI value given by spec for fixed PRI
Date: Fri, 27 Mar 2015 09:59:50 -0700
Message-ID: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150327_180047_479629_491C0C1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PRI value is used as divider when DFS detector analyzes candidate
radar pulses.
If PRI deviation is big from its origin PRI, DFS detector could miss
valid radar reports since HW often misses detecting radar pulses and
causes long interval value of pulses.

For instance from practical results, if runtime PRI is calculated as
1431 for fixed PRI value of 1428 and delta timestamp logs 15719,
the modular remainder will be 1409 and the delta between the remainder
and runtime PRI is 22 that is bigger than PRI tolerance which is 16.
As a result this radar report will be ignored even though it's valid.

By using spec defined PRI for fixed PRI, we can correct this error.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pri_detector.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
index 1b5ad19..fef459a 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -25,6 +25,8 @@ struct ath_dfs_pool_stats global_dfs_pool_stats = {};
 
 #define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
 #define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
+#define GET_PRI_TO_USE(MIN, MAX, RUNTIME) \
+	(MIN + 16 == MAX - 16 ? MIN + 16 : RUNTIME)
 
 /**
  * struct pulse_elem - elements in pulse queue
@@ -243,7 +245,8 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
 		ps.count_falses = 0;
 		ps.first_ts = p->ts;
 		ps.last_ts = ts;
-		ps.pri = ts - p->ts;
+		ps.pri = GET_PRI_TO_USE(pde->rs->pri_min,
+			pde->rs->pri_max, ts - p->ts);
 		ps.dur = ps.pri * (pde->rs->ppb - 1)
 				+ 2 * pde->rs->max_pri_tolerance;
 
-- 
1.9.1

