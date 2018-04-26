Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44258 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754932AbeDZKRO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:17:14 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: coarse support for PCIe shared structure rev7
Date: Thu, 26 Apr 2018 12:16:51 +0200
Message-Id: <1524737811-1965-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_121724_131814_7672F66F)
In-Reply-To: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Revision 7 of PCIe dongle interface increases the item size of tx and rx
complete rings to accommodate extra payload for new feature. This patch
simply bump up the size of these two rings without adding the support
for utilizing the new space. This makes brcmfmac compatible with rev7
firmware.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  6 ++++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 23 ++++++++++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
index f93ba6b..692235d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
@@ -27,8 +27,10 @@
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_ITEMSIZE	40
 #define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_ITEMSIZE	32
 #define BRCMF_D2H_MSGRING_CONTROL_COMPLETE_ITEMSIZE	24
-#define BRCMF_D2H_MSGRING_TX_COMPLETE_ITEMSIZE		16
-#define BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE		32
+#define BRCMF_D2H_MSGRING_TX_COMPLETE_ITEMSIZE_PRE_V7	16
+#define BRCMF_D2H_MSGRING_TX_COMPLETE_ITEMSIZE		24
+#define BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE_PRE_V7	32
+#define BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE		40
 #define BRCMF_H2D_TXFLOWRING_ITEMSIZE			48
 
 struct msgbuf_buf_addr {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 71b69af..f0797ae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -136,8 +136,9 @@ enum brcmf_pcie_state {
 						 BRCMF_PCIE_MB_INT_D2H3_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H3_DB1)
 
+#define BRCMF_PCIE_SHARED_VERSION_7		7
 #define BRCMF_PCIE_MIN_SHARED_VERSION		5
-#define BRCMF_PCIE_MAX_SHARED_VERSION		6
+#define BRCMF_PCIE_MAX_SHARED_VERSION		BRCMF_PCIE_SHARED_VERSION_7
 #define BRCMF_PCIE_SHARED_VERSION_MASK		0x00FF
 #define BRCMF_PCIE_SHARED_DMA_INDEX		0x10000
 #define BRCMF_PCIE_SHARED_DMA_2B_IDX		0x100000
@@ -318,6 +319,14 @@ struct brcmf_pcie_dhi_ringinfo {
 	BRCMF_D2H_MSGRING_RX_COMPLETE_MAX_ITEM
 };
 
+static const u32 brcmf_ring_itemsize_pre_v7[BRCMF_NROF_COMMON_MSGRINGS] = {
+	BRCMF_H2D_MSGRING_CONTROL_SUBMIT_ITEMSIZE,
+	BRCMF_H2D_MSGRING_RXPOST_SUBMIT_ITEMSIZE,
+	BRCMF_D2H_MSGRING_CONTROL_COMPLETE_ITEMSIZE,
+	BRCMF_D2H_MSGRING_TX_COMPLETE_ITEMSIZE_PRE_V7,
+	BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE_PRE_V7
+};
+
 static const u32 brcmf_ring_itemsize[BRCMF_NROF_COMMON_MSGRINGS] = {
 	BRCMF_H2D_MSGRING_CONTROL_SUBMIT_ITEMSIZE,
 	BRCMF_H2D_MSGRING_RXPOST_SUBMIT_ITEMSIZE,
@@ -1007,8 +1016,14 @@ static int brcmf_pcie_ring_mb_update_wptr(void *ctx)
 	struct brcmf_pcie_ringbuf *ring;
 	u32 size;
 	u32 addr;
+	const u32 *ring_itemsize_array;
+
+	if (devinfo->shared.version < BRCMF_PCIE_SHARED_VERSION_7)
+		ring_itemsize_array = brcmf_ring_itemsize_pre_v7;
+	else
+		ring_itemsize_array = brcmf_ring_itemsize;
 
-	size = brcmf_ring_max_item[ring_id] * brcmf_ring_itemsize[ring_id];
+	size = brcmf_ring_max_item[ring_id] * ring_itemsize_array[ring_id];
 	dma_buf = brcmf_pcie_init_dmabuffer_for_device(devinfo, size,
 			tcm_ring_phys_addr + BRCMF_RING_MEM_BASE_ADDR_OFFSET,
 			&dma_handle);
@@ -1018,7 +1033,7 @@ static int brcmf_pcie_ring_mb_update_wptr(void *ctx)
 	addr = tcm_ring_phys_addr + BRCMF_RING_MAX_ITEM_OFFSET;
 	brcmf_pcie_write_tcm16(devinfo, addr, brcmf_ring_max_item[ring_id]);
 	addr = tcm_ring_phys_addr + BRCMF_RING_LEN_ITEMS_OFFSET;
-	brcmf_pcie_write_tcm16(devinfo, addr, brcmf_ring_itemsize[ring_id]);
+	brcmf_pcie_write_tcm16(devinfo, addr, ring_itemsize_array[ring_id]);
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring) {
@@ -1027,7 +1042,7 @@ static int brcmf_pcie_ring_mb_update_wptr(void *ctx)
 		return NULL;
 	}
 	brcmf_commonring_config(&ring->commonring, brcmf_ring_max_item[ring_id],
-				brcmf_ring_itemsize[ring_id], dma_buf);
+				ring_itemsize_array[ring_id], dma_buf);
 	ring->dma_handle = dma_handle;
 	ring->devinfo = devinfo;
 	brcmf_commonring_register_cb(&ring->commonring,
-- 
1.9.1
