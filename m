Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:49051 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395Ab3DWXwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 19:52:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10 4/4] mwifiex: Correct pci_unmap_single's size
Date: Tue, 23 Apr 2013 16:49:50 -0700
Message-ID: <1366760990-15748-5-git-send-email-bzhao@marvell.com> (sfid-20130424_015240_315442_EC876AE4)
In-Reply-To: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
References: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

There exist mismatch between the size used for pci_map and
pci_unmap on command skb. Correcting it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index eaf93f5..20c9c4c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -861,7 +861,7 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 
 	if (card && card->cmd_buf) {
 		MWIFIEX_SKB_PACB(card->cmd_buf, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_SIZE_OF_CMD_BUFFER,
+		pci_unmap_single(card->dev, buf_pa, card->cmd_buf->len,
 				 PCI_DMA_TODEVICE);
 	}
 	return 0;
@@ -1572,7 +1572,7 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 	skb_tmp = card->cmd_buf;
 	if (skb_tmp) {
 		MWIFIEX_SKB_PACB(skb_tmp, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+		pci_unmap_single(card->dev, buf_pa, skb_tmp->len,
 				 PCI_DMA_FROMDEVICE);
 		card->cmd_buf = NULL;
 	}
-- 
1.7.0.2

