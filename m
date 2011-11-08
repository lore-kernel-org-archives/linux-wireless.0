Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34473 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689Ab1KHDcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 22:32:23 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH RESEND 3/4] mwifiex: enable SDIO multiport aggregation
Date: Mon,  7 Nov 2011 19:31:46 -0800
Message-Id: <1320723107-24202-4-git-send-email-bzhao@marvell.com> (sfid-20111108_043225_189813_731F28A1)
In-Reply-To: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
References: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

By default SDIO multiport aggregation is disabled. It's useful to
get good throughput results. This patch enables it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 283171b..ffaf3f3 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1630,14 +1630,14 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mpa_tx.pkt_cnt = 0;
 	card->mpa_tx.start_port = 0;
 
-	card->mpa_tx.enabled = 0;
+	card->mpa_tx.enabled = 1;
 	card->mpa_tx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
 
 	card->mpa_rx.buf_len = 0;
 	card->mpa_rx.pkt_cnt = 0;
 	card->mpa_rx.start_port = 0;
 
-	card->mpa_rx.enabled = 0;
+	card->mpa_rx.enabled = 1;
 	card->mpa_rx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
 
 	/* Allocate buffers for SDIO MP-A */
-- 
1.7.0.2

