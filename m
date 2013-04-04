Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55797 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762743Ab3DDVCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 17:02:16 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0Lmhpd-1UxC3205h5-00aGbG for
 <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 23:02:15 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 3/4] mwifiex: bug: remove NO_PKT_PRIO_TID.
Date: Thu,  4 Apr 2013 23:01:24 +0200
Message-Id: <1365109286-5075-3-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130404_230223_726181_778D566E)
In-Reply-To: <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <20130404205706.GA29851@blumentopf>
 <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using NO_PKT_PRIO_TID and tx_pkts_queued to check for an empty state, can
lead to a contradictory state, resulting in an infinite loop.
Currently queueing and dequeuing of packets is not synchronized, and can
happen concurrently. While tx_pkts_queued is incremented when adding a
packet, max prio is set to NO_PKT when the WMM list is empty. If a packet
is added right after the check for empty, but before setting max prio to
NO_PKT, that packet is trapped and creates an infinite loop.
Because of the new packet, tx_pkts_queued is at least 1, indicating wmm
lists are not empty. Opposing that max prio is NO_PKT, which means "skip
this wmm queue, it has no packets". The infinite loop results, because the
main loop checks the wmm lists for not empty via tx_pkts_queued, but for
dequeing it uses max_prio to see if it can skip current list. This will
never end, unless a new packet is added which will restore max prio to the
level of the trapped packet.
The solution here is to rely on tx_pkts_queued solely for checking wmm
queue to be empty, and drop the NO_PKT define. It does not address the
locking issue.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/main.h |    1 -
 drivers/net/wireless/mwifiex/wmm.c  |   13 ++++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d94406a..082a468 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -216,7 +216,6 @@ struct mwifiex_tid_tbl {
 #define WMM_HIGHEST_PRIORITY		7
 #define HIGH_PRIO_TID				7
 #define LOW_PRIO_TID				0
-#define NO_PKT_PRIO_TID				(-1)
 
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 96eed2f..62b07d3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -919,8 +919,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 		do {
 			priv_tmp = bssprio_node->priv;
-			hqp = &priv_tmp->wmm.highest_queued_prio;
 
+			if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
+				goto skip_bss;
+
+			/* iterate over the WMM queues of the BSS */
+			hqp = &priv_tmp->wmm.highest_queued_prio;
 			for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
 
 				tid_ptr = &(priv_tmp)->wmm.
@@ -979,12 +983,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				} while (ptr != head);
 			}
 
-			/* No packet at any TID for this priv. Mark as such
-			 * to skip checking TIDs for this priv (until pkt is
-			 * added).
-			 */
-			atomic_set(hqp, NO_PKT_PRIO_TID);
-
+skip_bss:
 			/* Get next bss priority node */
 			bssprio_node = list_first_entry(&bssprio_node->list,
 						struct mwifiex_bss_prio_node,
-- 
1.7.10.4

