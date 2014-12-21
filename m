Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34443 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaLULoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:02 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/10] brcmfmac: Fix incorrect casting of 64 bit physical address.
Date: Sun, 21 Dec 2014 12:43:44 +0100
Message-ID: <1419162233-19492-2-git-send-email-arend@broadcom.com> (sfid-20141221_124412_424434_35399811)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The physical addresses being used by pcie and msgbuf were using
a cast to long, which incorrectly caused it to limit the address
to 32bit. Now explicit u64 is used where needed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 22 +++++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c   | 10 +++++-----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 456944a..3ff6acf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -583,7 +583,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	u32 flowid;
 	void *dma_buf;
 	u32 dma_sz;
-	long long address;
+	u64 address;
 	int err;
 
 	flowid = work->flowid;
@@ -620,7 +620,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 					   BRCMF_NROF_H2D_COMMON_MSGRINGS);
 	memcpy(create->sa, work->sa, ETH_ALEN);
 	memcpy(create->da, work->da, ETH_ALEN);
-	address = (long long)(long)msgbuf->flowring_dma_handle[flowid];
+	address = (u64)msgbuf->flowring_dma_handle[flowid];
 	create->flow_ring_addr.high_addr = cpu_to_le32(address >> 32);
 	create->flow_ring_addr.low_addr = cpu_to_le32(address & 0xffffffff);
 	create->max_items = cpu_to_le16(BRCMF_H2D_TXFLOWRING_MAX_ITEM);
@@ -698,7 +698,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
 	dma_addr_t physaddr;
 	u32 pktid;
 	struct msgbuf_tx_msghdr *tx_msghdr;
-	long long address;
+	u64 address;
 
 	commonring = msgbuf->flowrings[flowid];
 	if (!brcmf_commonring_write_available(commonring))
@@ -742,7 +742,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
 		tx_msghdr->seg_cnt = 1;
 		memcpy(tx_msghdr->txhdr, skb->data, ETH_HLEN);
 		tx_msghdr->data_len = cpu_to_le16(skb->len - ETH_HLEN);
-		address = (long long)(long)physaddr;
+		address = (u64)physaddr;
 		tx_msghdr->data_buf_addr.high_addr = cpu_to_le32(address >> 32);
 		tx_msghdr->data_buf_addr.low_addr =
 			cpu_to_le32(address & 0xffffffff);
@@ -885,7 +885,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 	u32 pktlen;
 	dma_addr_t physaddr;
 	struct msgbuf_rx_bufpost *rx_bufpost;
-	long long address;
+	u64 address;
 	u32 pktid;
 	u32 i;
 
@@ -921,7 +921,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 		}
 
 		if (msgbuf->rx_metadata_offset) {
-			address = (long long)(long)physaddr;
+			address = (u64)physaddr;
 			rx_bufpost->metadata_buf_len =
 				cpu_to_le16(msgbuf->rx_metadata_offset);
 			rx_bufpost->metadata_buf_addr.high_addr =
@@ -936,7 +936,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 		rx_bufpost->msg.msgtype = MSGBUF_TYPE_RXBUF_POST;
 		rx_bufpost->msg.request_id = cpu_to_le32(pktid);
 
-		address = (long long)(long)physaddr;
+		address = (u64)physaddr;
 		rx_bufpost->data_buf_len = cpu_to_le16((u16)pktlen);
 		rx_bufpost->data_buf_addr.high_addr =
 			cpu_to_le32(address >> 32);
@@ -992,7 +992,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 	u32 pktlen;
 	dma_addr_t physaddr;
 	struct msgbuf_rx_ioctl_resp_or_event *rx_bufpost;
-	long long address;
+	u64 address;
 	u32 pktid;
 	u32 i;
 
@@ -1035,7 +1035,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 				MSGBUF_TYPE_IOCTLRESP_BUF_POST;
 		rx_bufpost->msg.request_id = cpu_to_le32(pktid);
 
-		address = (long long)(long)physaddr;
+		address = (u64)physaddr;
 		rx_bufpost->host_buf_len = cpu_to_le16((u16)pktlen);
 		rx_bufpost->host_buf_addr.high_addr =
 			cpu_to_le32(address >> 32);
@@ -1348,7 +1348,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus_msgbuf *if_msgbuf;
 	struct brcmf_msgbuf *msgbuf;
-	long long address;
+	u64 address;
 	u32 count;
 
 	if_msgbuf = drvr->bus_if->msgbuf;
@@ -1379,7 +1379,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 					     GFP_KERNEL);
 	if (!msgbuf->ioctbuf)
 		goto fail;
-	address = (long long)(long)msgbuf->ioctbuf_handle;
+	address = (u64)msgbuf->ioctbuf_handle;
 	msgbuf->ioctbuf_phys_hi = address >> 32;
 	msgbuf->ioctbuf_phys_lo = address & 0xffffffff;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 905991f..e91fa9a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -959,14 +959,14 @@ brcmf_pcie_init_dmabuffer_for_device(struct brcmf_pciedev_info *devinfo,
 				     dma_addr_t *dma_handle)
 {
 	void *ring;
-	long long address;
+	u64 address;
 
 	ring = dma_alloc_coherent(&devinfo->pdev->dev, size, dma_handle,
 				  GFP_KERNEL);
 	if (!ring)
 		return NULL;
 
-	address = (long long)(long)*dma_handle;
+	address = (u64)*dma_handle;
 	brcmf_pcie_write_tcm32(devinfo, tcm_dma_phys_addr,
 			       address & 0xffffffff);
 	brcmf_pcie_write_tcm32(devinfo, tcm_dma_phys_addr + 4, address >> 32);
@@ -1166,7 +1166,7 @@ brcmf_pcie_release_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 {
-	long long address;
+	u64 address;
 	u32 addr;
 
 	devinfo->shared.scratch = dma_alloc_coherent(&devinfo->pdev->dev,
@@ -1180,7 +1180,7 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_SCRATCH_ADDR_OFFSET;
-	address = (long long)(long)devinfo->shared.scratch_dmahandle;
+	address = (u64)devinfo->shared.scratch_dmahandle;
 	brcmf_pcie_write_tcm32(devinfo, addr, address & 0xffffffff);
 	brcmf_pcie_write_tcm32(devinfo, addr + 4, address >> 32);
 	addr = devinfo->shared.tcm_base_address +
@@ -1198,7 +1198,7 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_RINGUPD_ADDR_OFFSET;
-	address = (long long)(long)devinfo->shared.ringupd_dmahandle;
+	address = (u64)devinfo->shared.ringupd_dmahandle;
 	brcmf_pcie_write_tcm32(devinfo, addr, address & 0xffffffff);
 	brcmf_pcie_write_tcm32(devinfo, addr + 4, address >> 32);
 	addr = devinfo->shared.tcm_base_address +
-- 
1.9.1

