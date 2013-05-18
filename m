Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:45806 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab3ERAzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:55:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 14/17] mwifiex: define a macro for MPA base address
Date: Fri, 17 May 2013 17:54:34 -0700
Message-ID: <1368838474-307-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025511_974565_D55AD729)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As Multiple-Port Aggregation base address value is fixed, we can
have a macro for it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 drivers/net/wireless/mwifiex/sdio.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 99a508b..1892e88 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1100,7 +1100,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
 			card->mpa_rx.pkt_cnt);
 
-		mport = (adapter->ioport | 0x1000 |
+		mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
 			 (card->mpa_rx.ports << 4)) + card->mpa_rx.start_port;
 
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
@@ -1419,7 +1419,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
 			__func__,
 				card->mpa_tx.start_port, card->mpa_tx.ports);
-		mport = (adapter->ioport | 0x1000 |
+		mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
 			 (card->mpa_tx.ports << 4)) + card->mpa_tx.start_port;
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len, mport);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 0d931f7..e4016d2 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -42,6 +42,7 @@
 
 #define MWIFIEX_SDIO_BYTE_MODE_MASK	0x80000000
 
+#define SDIO_MPA_ADDR_BASE		0x1000
 #define CTRL_PORT			0
 #define CTRL_PORT_MASK			0x0001
 
-- 
1.8.2.3

