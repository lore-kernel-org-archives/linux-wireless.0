Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60238 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431Ab3DBAI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 20:08:58 -0400
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MhgAH-1U0dEA1Xil-00Mtdi for
 <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 02:08:57 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Date: Tue,  2 Apr 2013 02:08:40 +0200
Message-Id: <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130402_020902_139108_C885231A)
In-Reply-To: <20130402000511.GA31921@blumentopf>
References: <20130402000511.GA31921@blumentopf>
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
main loop checks the wmm lists for not empty via tx_pkts_queued, but when
dequeing uses max_prio to see if it can skip a list. This will never end,
unless a new packet is added which will restore max prio to the level of
the trapped packet.
The solution here is to rely on tx_pkts_queued solely for checking wmm
queue to be empty, and drop the NO_PKT define. It does not address the
locking issue.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/main.h |    1 -
 drivers/net/wireless/mwifiex/wmm.c  |   12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 553adfb..3de4cc7 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -218,7 +218,6 @@ struct mwifiex_tid_tbl {
 #define WMM_HIGHEST_PRIORITY		7
 #define HIGH_PRIO_TID				7
 #define LOW_PRIO_TID				0
-#define NO_PKT_PRIO_TID				(-1)
 
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 32adc87..91dee27 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -919,8 +919,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 		do {
 			priv_tmp = bssprio_node->priv;
-			hqp = &priv_tmp->wmm.highest_queued_prio;
 
+			if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
+				continue;
+
+			/* iterate over the WMM queues of the BSS */
+			hqp = &priv_tmp->wmm.highest_queued_prio;
 			for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
 
 				tid_ptr = &(priv_tmp)->wmm.
@@ -980,12 +984,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				} while (ptr != head);
 			}
 
-			/* No packet at any TID for this priv. Mark as such
-			 * to skip checking TIDs for this priv (until pkt is
-			 * added).
-			 */
-			atomic_set(hqp, NO_PKT_PRIO_TID);
-
 			/* Get next bss priority node */
 			bssprio_node = list_first_entry(&bssprio_node->list,
 						struct mwifiex_bss_prio_node,
-- 
1.7.10.4

