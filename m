Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:39421 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965218Ab3DTAvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 20:51:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: make use of msecs_to_jiffies()
Date: Fri, 19 Apr 2013 17:44:44 -0700
Message-ID: <1366418684-6148-4-git-send-email-bzhao@marvell.com> (sfid-20130420_025120_288270_A4ECF9FB)
In-Reply-To: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
References: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use msecs_to_jiffies() wherever possible.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 5e796f8..ada809f 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -447,7 +447,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
 	del_timer(&tbl->timer_context.timer);
 	mod_timer(&tbl->timer_context.timer,
-		  jiffies + (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
+		  jiffies + msecs_to_jiffies(MIN_FLUSH_TIMER_MS * win_size));
 
 	/*
 	 * If seq_num is less then starting win then ignore and drop the
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index da469c3..74db0d2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -250,7 +250,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	/* Setup the timer after transmit command */
 	mod_timer(&adapter->cmd_timer,
-		  jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
+		  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
 
 	return 0;
 }
-- 
1.7.0.2

