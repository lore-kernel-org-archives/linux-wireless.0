Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:36121 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853Ab3BPFiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 00:38:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix empty TX ring check for PCIe8897 while unloading driver
Date: Fri, 15 Feb 2013 21:37:54 -0800
Message-Id: <1360993074-4609-1-git-send-email-bzhao@marvell.com> (sfid-20130216_063807_719695_23B5C70D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While unloading driver, we free all pending TX packets by flushing
TX ring. There is unhandled case for PCIE8897 while checking for
ring empty condition.

This patch adds the handling by calling mwifiex_pcie_txbd_empty().

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 492655c..4b54bcf 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1023,10 +1023,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		adapter->data_sent = false;
 
 	if (card->txbd_flush) {
-		if (((card->txbd_wrptr & reg->tx_mask) ==
-		     (card->txbd_rdptr & reg->tx_mask)) &&
-		    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
-		     (card->txbd_rdptr & reg->tx_rollover_ind)))
+		if (mwifiex_pcie_txbd_empty(card, card->txbd_rdptr))
 			card->txbd_flush = 0;
 		else
 			mwifiex_clean_pcie_ring_buf(adapter);
-- 
1.7.0.2

