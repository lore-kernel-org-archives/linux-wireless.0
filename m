Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51496 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1EQCNO (ORCPT
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
Subject: [PATCH 5/5] mwifiex: adjust high/low water marks for tx_pending queue
Date: Mon, 16 May 2011 19:17:53 -0700
Message-Id: <1305598673-26606-6-git-send-email-bzhao@marvell.com> (sfid-20110517_041320_799665_1ED20F87)
In-Reply-To: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
References: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

This is to fix an issue that the throughput of the higher priority
stream gets dropped when a lower priority stream is present.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |    3 ++-
 drivers/net/wireless/mwifiex/txrx.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3154b0a..8316b3c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -69,7 +69,8 @@ struct mwifiex_drv_mode {
 #define MWIFIEX_TIMER_10S			10000
 #define MWIFIEX_TIMER_1S			1000
 
-#define MAX_TX_PENDING      60
+#define MAX_TX_PENDING      100
+#define LOW_TX_PENDING      80
 
 #define MWIFIEX_UPLD_SIZE               (2312)
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 2101208..aaa50c0 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -140,7 +140,9 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	} else {
 		priv->stats.tx_errors++;
 	}
-	atomic_dec(&adapter->tx_pending);
+
+	if (atomic_dec_return(&adapter->tx_pending) >= LOW_TX_PENDING)
+		goto done;
 
 	for (i = 0; i < adapter->priv_num; i++) {
 
-- 
1.7.0.2

