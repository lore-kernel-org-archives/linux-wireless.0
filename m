Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51494 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1EQCNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 22:13:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: CPU mips optimization with NO_PKT_PRIO_TID
Date: Mon, 16 May 2011 19:17:52 -0700
Message-Id: <1305598673-26606-5-git-send-email-bzhao@marvell.com> (sfid-20110517_041321_387880_1CC676E2)
In-Reply-To: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
References: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

If we go through the entire for loop in
mwifiex_wmm_get_highest_priolist_ptr() and don't find any packets,
set highest_queued_prio to NO_PKT_PRIO_TID (< LOW_PRIO_TID).

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |    1 +
 drivers/net/wireless/mwifiex/wmm.c  |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ea3184d..3154b0a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -202,6 +202,7 @@ struct mwifiex_tid_tbl {
 #define WMM_HIGHEST_PRIORITY		7
 #define HIGH_PRIO_TID				7
 #define LOW_PRIO_TID				0
+#define NO_PKT_PRIO_TID				(-1)
 
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 784ad4c..91634da 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -946,6 +946,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				} while (ptr != head);
 			}
 
+			/* No packet at any TID for this priv. Mark as such
+			 * to skip checking TIDs for this priv (until pkt is
+			 * added).
+			 */
+			atomic_set(hqp, NO_PKT_PRIO_TID);
+
 			/* Get next bss priority node */
 			bssprio_node = list_first_entry(&bssprio_node->list,
 						struct mwifiex_bss_prio_node,
-- 
1.7.0.2

