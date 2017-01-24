Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35823 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750903AbdAXNgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 08:36:24 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: use pci_dma_sync_single* APIs
Date: Tue, 24 Jan 2017 19:05:45 +0530
Message-ID: <1485264945-1248-2-git-send-email-akarwar@marvell.com> (sfid-20170124_143626_617942_520D3D91)
In-Reply-To: <1485264945-1248-1-git-send-email-akarwar@marvell.com>
References: <1485264945-1248-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms, driver is unable read sleep cookie signature even
if firmware has written it through DMA. The problem is fixed by using
pci_dma_sync_single* APIs while reading DMA buffer shared with firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3f4ca28..a0d9180 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -439,9 +439,14 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 	struct pcie_service_card *card = adapter->card;
 	u8 *buffer;
 	u32 sleep_cookie, count;
+	struct sk_buff *cmdrsp = card->cmdrsp_buf;
 
 	for (count = 0; count < max_delay_loop_cnt; count++) {
-		buffer = card->cmdrsp_buf->data;
+		pci_dma_sync_single_for_cpu(card->dev,
+					    MWIFIEX_SKB_DMA_ADDR(cmdrsp),
+					    sizeof(sleep_cookie),
+					    PCI_DMA_FROMDEVICE);
+		buffer = cmdrsp->data;
 		sleep_cookie = READ_ONCE(*(u32 *)buffer);
 
 		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
@@ -449,6 +454,10 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 				    "sleep cookie found at count %d\n", count);
 			break;
 		}
+		pci_dma_sync_single_for_device(card->dev,
+					       MWIFIEX_SKB_DMA_ADDR(cmdrsp),
+					       sizeof(sleep_cookie),
+					       PCI_DMA_FROMDEVICE);
 		usleep_range(20, 30);
 	}
 
-- 
1.9.1
