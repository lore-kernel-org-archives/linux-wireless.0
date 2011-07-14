Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:53360 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1GNDq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 23:46:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: check SDIO multi-port aggregation buffer room correctly
Date: Wed, 13 Jul 2011 20:51:58 -0700
Message-Id: <1310615519-32112-2-git-send-email-bzhao@marvell.com> (sfid-20110714_054631_276662_B9647D98)
In-Reply-To: <1310615519-32112-1-git-send-email-bzhao@marvell.com>
References: <1310615519-32112-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We should consider current packet length also while checking
Tx aggregation buffer room.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 711fa68..f7105a9 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1319,7 +1319,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				if (!(card->mp_wr_bitmap &
 						(1 << card->curr_wr_port))
 						|| !MP_TX_AGGR_BUF_HAS_ROOM(
-							card, next_pkt_len))
+						card, pkt_len + next_pkt_len))
 					f_send_aggr_buf = 1;
 			} else {
 				/* No room in Aggr buf, send it */
-- 
1.7.0.2

