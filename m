Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60275 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab3DWXvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 19:51:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10 3/4] mwifiex: Do not kfree cmd buf while unregistering PCIe
Date: Tue, 23 Apr 2013 16:49:49 -0700
Message-ID: <1366760990-15748-4-git-send-email-bzhao@marvell.com> (sfid-20130424_015152_393403_D58801EB)
In-Reply-To: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
References: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

All the command buffers are freed in mwifiex_free_cmd_buffer()
and hence there is no need to kfree the current command buffer
again. This might ends up freeing memory allocated by some other
kernel code.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index b924e1d..eaf93f5 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -863,7 +863,6 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 		MWIFIEX_SKB_PACB(card->cmd_buf, &buf_pa);
 		pci_unmap_single(card->dev, buf_pa, MWIFIEX_SIZE_OF_CMD_BUFFER,
 				 PCI_DMA_TODEVICE);
-		dev_kfree_skb_any(card->cmd_buf);
 	}
 	return 0;
 }
-- 
1.7.0.2

