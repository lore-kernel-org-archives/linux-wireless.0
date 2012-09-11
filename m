Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:38772 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958Ab2IKBbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 05/10] mwifiex: update adapter->bss_prio_tbl[j].bss_prio_cur correctly
Date: Mon, 10 Sep 2012 18:30:44 -0700
Message-Id: <1347327049-13665-6-git-send-email-bzhao@marvell.com> (sfid-20120911_033155_630457_3A21122E)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"adapter->bss_prio_tbl[j].bss_prio_head" points to linked list of
interfaces with priority 'j'. "bss_prio_tbl[j].bss_prio_cur" is
supposed to point to next interface every time the routine for
dequeuing the packet is called. This ensures that each interface
gets fair chance.

Currently we have AP and station interfaces with priority '0'.
Therefore "adapter->bss_prio_tbl[0].bss_prio_cur" should
alternately point to AP and station nodes. Since "bss_prio_cur"
is not correctly updated, for each packet picked for AP, two
packets are picked for station interface.

This patch fixes the problem by correctly updating "bss_prio_cur".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8ccd699..766d452 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -907,17 +907,16 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 		if (adapter->bss_prio_tbl[j].bss_prio_cur ==
 		    (struct mwifiex_bss_prio_node *)
 		    &adapter->bss_prio_tbl[j].bss_prio_head) {
-			bssprio_node =
+			adapter->bss_prio_tbl[j].bss_prio_cur =
 				list_first_entry(&adapter->bss_prio_tbl[j]
 						 .bss_prio_head,
 						 struct mwifiex_bss_prio_node,
 						 list);
-			bssprio_head = bssprio_node;
-		} else {
-			bssprio_node = adapter->bss_prio_tbl[j].bss_prio_cur;
-			bssprio_head = bssprio_node;
 		}
 
+		bssprio_node = adapter->bss_prio_tbl[j].bss_prio_cur;
+		bssprio_head = bssprio_node;
+
 		do {
 			priv_tmp = bssprio_node->priv;
 			hqp = &priv_tmp->wmm.highest_queued_prio;
-- 
1.7.0.2

