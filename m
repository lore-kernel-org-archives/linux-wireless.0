Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33331 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbaBRXmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:42:07 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"Frank Huang" <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3.14 2/3] mwifiex: add NULL check for PCIe Rx skb
Date: Tue, 18 Feb 2014 15:41:55 -0800
Message-ID: <1392766916-10734-2-git-send-email-bzhao@marvell.com> (sfid-20140219_004213_599454_064C56AE)
In-Reply-To: <1392766916-10734-1-git-send-email-bzhao@marvell.com>
References: <1392766916-10734-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We may get a NULL pointer here if skb allocation for Rx packet
was failed earlier.

Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index d11d4ac..7936dfa 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1217,6 +1217,12 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		rd_index = card->rxbd_rdptr & reg->rx_mask;
 		skb_data = card->rx_buf_list[rd_index];
 
+		/* If skb allocation was failed earlier for Rx packet,
+		 * rx_buf_list[rd_index] would have been left with a NULL.
+		 */
+		if (!skb_data)
+			return -ENOMEM;
+
 		mwifiex_unmap_pci_memory(adapter, skb_data, PCI_DMA_FROMDEVICE);
 		card->rx_buf_list[rd_index] = NULL;
 
-- 
1.8.2.3

