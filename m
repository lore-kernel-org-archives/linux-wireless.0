Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33180 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161499Ab3DEDEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 23:04:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	<daniel@zonque.org>, Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 1/4] mwifiex: correct wrong list in list_empty check
Date: Thu, 4 Apr 2013 20:03:50 -0700
Message-ID: <1365131033-7417-2-git-send-email-bzhao@marvell.com> (sfid-20130405_050430_009019_D36AC629)
In-Reply-To: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
References: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

adapter->bss_prio_tbl list has already been checked in outer loop.
The inner loop works with priv_tmp->wmm.tid_tbl_ptr list. Also the
lock taken, gives hint that this is likely a copy-paste error.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 3ddae52..1b039ba 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -930,8 +930,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
 						  flags);
 				is_list_empty =
-					list_empty(&adapter->bss_prio_tbl[j]
-						   .bss_prio_head);
+					list_empty(&tid_ptr->ra_list);
 				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
 						       flags);
 				if (is_list_empty)
-- 
1.7.0.2

