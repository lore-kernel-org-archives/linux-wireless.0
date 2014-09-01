Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56588 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbaIAHbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:20 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/17] mwifiex: fix a bug in Tx multiport aggregation
Date: Mon, 1 Sep 2014 18:28:54 +0530
Message-ID: <1409576345-13717-7-git-send-email-patila@marvell.com> (sfid-20140901_093123_123197_FFAC7C52)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When aggregation port limit is reached, we stop aggregation and
the data is sent to firmware. It is observed that one less packet
than the port limit is aggregated in this case. ex. 15 instead of
16.
The reason is we have redundant port limit checks before current
packet is added to aggregation buffer.

The issue is fixed by removing these checks. We already have
necessary check in precopy current buffer handling.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 1770fa3..993841e 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1527,8 +1527,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 			__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
-			if (!mp_tx_aggr_port_limit_reached(card) &&
-			    MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
 				f_precopy_cur_buf = 1;
 
 				if (!(card->mp_wr_bitmap &
@@ -1540,8 +1539,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				/* No room in Aggr buf, send it */
 				f_send_aggr_buf = 1;
 
-				if (mp_tx_aggr_port_limit_reached(card) ||
-				    !(card->mp_wr_bitmap &
+				if (!(card->mp_wr_bitmap &
 				      (1 << card->curr_wr_port)))
 					f_send_cur_buf = 1;
 				else
-- 
1.8.1.4

