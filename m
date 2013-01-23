Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:47861 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752162Ab3AWA3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 19:29:46 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix invalid access of PCIe RxBD ring buffer descriptor
Date: Tue, 22 Jan 2013 16:29:03 -0800
Message-Id: <1358900943-5221-1-git-send-email-bzhao@marvell.com> (sfid-20130123_012951_039078_DFB1D695)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes invalid access of RxBD ring buffer descriptor's
length and flag inside PCIe send_data_complete() routine. We are
supposed to modify TxBD buffer descriptor's length and flag here.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 237949c..7415ac8 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -846,8 +846,8 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 
 		card->tx_buf_list[wrdoneidx] = NULL;
 		card->txbd_ring[wrdoneidx]->paddr = 0;
-		card->rxbd_ring[wrdoneidx]->len = 0;
-		card->rxbd_ring[wrdoneidx]->flags = 0;
+		card->txbd_ring[wrdoneidx]->len = 0;
+		card->txbd_ring[wrdoneidx]->flags = 0;
 		card->txbd_rdptr++;
 
 		if ((card->txbd_rdptr & MWIFIEX_TXBD_MASK) == num_tx_buffs)
-- 
1.7.0.2

