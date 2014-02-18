Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39091 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbaBRXsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:48:02 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: remove redundant del_timer
Date: Tue, 18 Feb 2014 15:47:56 -0800
Message-ID: <1392767277-10941-2-git-send-email-bzhao@marvell.com> (sfid-20140219_004814_434871_D9FBA708)
In-Reply-To: <1392767277-10941-1-git-send-email-bzhao@marvell.com>
References: <1392767277-10941-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While modifying timer, we need not delete timer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 1cfdbfe..eb17282 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -466,7 +466,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	start_win = tbl->start_win;
 	win_size = tbl->win_size;
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
-	del_timer(&tbl->timer_context.timer);
 	mod_timer(&tbl->timer_context.timer,
 		  jiffies + msecs_to_jiffies(MIN_FLUSH_TIMER_MS * win_size));
 
-- 
1.8.2.3

