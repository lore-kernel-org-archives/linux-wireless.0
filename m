Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35809 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750765AbdAXNgO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 08:36:14 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: mwifiex_unmap_pci_memory() handling for sleep confirm
Date: Tue, 24 Jan 2017 19:05:44 +0530
Message-ID: <1485264945-1248-1-git-send-email-akarwar@marvell.com> (sfid-20170124_143617_068915_A57568D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sleep confirm is a special command for which "adapter->cur_cmd" pointer
is not set. When it's response is received, host writes SLEEP confirm done
to a register. Firmware will perform DMA for writing sleep cookie signature
on same buffer after this.

Let's not immediately call mwifiex_unmap_pci_memory() for this special
command. Unmapping will be done when firmware completes writing sleep
cookie signature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 19 ++++++++++++++++---
 drivers/net/wireless/marvell/mwifiex/pcie.h |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ca51411..3f4ca28 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -441,7 +441,7 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 	u32 sleep_cookie, count;
 
 	for (count = 0; count < max_delay_loop_cnt; count++) {
-		buffer = card->cmdrsp_buf->data - INTF_HEADER_LEN;
+		buffer = card->cmdrsp_buf->data;
 		sleep_cookie = READ_ONCE(*(u32 *)buffer);
 
 		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
@@ -1690,7 +1690,13 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, CMD,
 		    "info: Rx CMD Response\n");
 
-	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_FROMDEVICE);
+	if (adapter->curr_cmd)
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_FROMDEVICE);
+	else
+		pci_dma_sync_single_for_cpu(card->dev,
+					    MWIFIEX_SKB_DMA_ADDR(skb),
+					    MWIFIEX_UPLD_SIZE,
+					    PCI_DMA_FROMDEVICE);
 
 	/* Unmap the command as a response has been received. */
 	if (card->cmd_buf) {
@@ -1703,10 +1709,13 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	rx_len = le16_to_cpu(pkt_len);
 	skb_put(skb, MWIFIEX_UPLD_SIZE - skb->len);
 	skb_trim(skb, rx_len);
-	skb_pull(skb, INTF_HEADER_LEN);
 
 	if (!adapter->curr_cmd) {
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
+			pci_dma_sync_single_for_device(card->dev,
+						MWIFIEX_SKB_DMA_ADDR(skb),
+						MWIFIEX_SLEEP_COOKIE_SIZE,
+						PCI_DMA_FROMDEVICE);
 			if (mwifiex_write_reg(adapter,
 					      PCIE_CPU_INT_EVENT,
 					      CPU_INTR_SLEEP_CFM_DONE)) {
@@ -1716,6 +1725,9 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 			}
 			mwifiex_delay_for_sleep_cookie(adapter,
 						       MWIFIEX_MAX_DELAY_COUNT);
+			mwifiex_unmap_pci_memory(adapter, skb,
+						 PCI_DMA_FROMDEVICE);
+			skb_pull(skb, INTF_HEADER_LEN);
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
@@ -1733,6 +1745,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 					   PCI_DMA_FROMDEVICE))
 			return -1;
 	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+		skb_pull(skb, INTF_HEADER_LEN);
 		adapter->curr_cmd->resp_skb = skb;
 		adapter->cmd_resp_received = true;
 		/* Take the pointer and set it to CMD node and will
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 21ba5e6..00e8ee5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -116,6 +116,7 @@
 /* FW awake cookie after FW ready */
 #define FW_AWAKE_COOKIE						(0xAA55AA55)
 #define MWIFIEX_DEF_SLEEP_COOKIE			0xBEEFBEEF
+#define MWIFIEX_SLEEP_COOKIE_SIZE			4
 #define MWIFIEX_MAX_DELAY_COUNT				100
 
 struct mwifiex_pcie_card_reg {
-- 
1.9.1
