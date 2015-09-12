Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33520 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbILSLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:07 -0400
Received: by wiclk2 with SMTP id lk2so96487273wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/11] staging: vt6655: Remove typedef struct __chip_info_tbl
Date: Sat, 12 Sep 2015 19:10:30 +0100
Message-Id: <1442081438-3485-3-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201141_009430_61AE2804)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only two values that are assigned from this table.

DEVICE_FLAGS_TX_ALIGN and the value of io_size which is used
as the size of ioremap which is 256.

Remove all variables, DEVICE_FLAGS_TX_ALIGN check, apply io_size value
and chip_info_table.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 12 -----------
 drivers/staging/vt6655/device_main.c | 40 ++++++++++--------------------------
 2 files changed, 11 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index d1917d0..be42e44 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -157,14 +157,6 @@
 #define PK_TYPE_11GB    2
 #define PK_TYPE_11GA    3
 
-typedef struct __chip_info_tbl {
-	CHIP_TYPE   chip_id;
-	char *name;
-	int         io_size;
-	int         nTxQueue;
-	u32         flags;
-} CHIP_INFO, *PCHIP_INFO;
-
 typedef enum {
 	OWNED_BY_HOST = 0,
 	OWNED_BY_NIC = 1
@@ -235,12 +227,9 @@ struct vnt_private {
 	unsigned char *tx1_bufs;
 	unsigned char *tx_beacon_bufs;
 
-	CHIP_TYPE                   chip_id;
-
 	void __iomem                *PortOffset;
 	u32                         memaddr;
 	u32                         ioaddr;
-	u32                         io_size;
 
 	unsigned char byRevId;
 	unsigned char byRxMode;
@@ -249,7 +238,6 @@ struct vnt_private {
 
 	spinlock_t                  lock;
 
-	int                         nTxQueues;
 	volatile int                iTDUsed[TYPE_MAXTD];
 
 	struct vnt_tx_desc *apCurrTD[TYPE_MAXTD];
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 99191d9..4bc9ba0 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -128,14 +128,8 @@ DEVICE_PARAM(BasebandType, "baseband type");
 /*
  * Static vars definitions
  */
-static CHIP_INFO chip_info_table[] = {
-	{ VT3253,       "VIA Networking Solomon-A/B/G Wireless LAN Adapter ",
-	  256, 1,     DEVICE_FLAGS_IP_ALIGN|DEVICE_FLAGS_TX_ALIGN },
-	{0, NULL}
-};
-
 static const struct pci_device_id vt6655_pci_id_table[] = {
-	{ PCI_VDEVICE(VIA, 0x3253), (kernel_ulong_t)chip_info_table},
+	{ PCI_VDEVICE(VIA, 0x3253) },
 	{ 0, }
 };
 
@@ -143,7 +137,7 @@ static const struct pci_device_id vt6655_pci_id_table[] = {
 
 static int  vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent);
 static void vt6655_init_info(struct pci_dev *pcid,
-			     struct vnt_private **ppDevice, PCHIP_INFO);
+			     struct vnt_private **ppDevice);
 static void device_free_info(struct vnt_private *pDevice);
 static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
@@ -443,15 +437,11 @@ static void device_print_info(struct vnt_private *pDevice)
 }
 
 static void vt6655_init_info(struct pci_dev *pcid,
-			     struct vnt_private **ppDevice,
-			     PCHIP_INFO pChip_info)
+			     struct vnt_private **ppDevice)
 {
 	memset(*ppDevice, 0, sizeof(**ppDevice));
 
 	(*ppDevice)->pcid = pcid;
-	(*ppDevice)->chip_id = pChip_info->chip_id;
-	(*ppDevice)->io_size = pChip_info->io_size;
-	(*ppDevice)->nTxQueues = pChip_info->nTxQueue;
 	(*ppDevice)->multicast_limit = 32;
 
 	spin_lock_init(&((*ppDevice)->lock));
@@ -695,10 +685,9 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 		pDesc = &(pDevice->apTD0Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
-		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
-			pDesc->td_info->buf = pDevice->tx0_bufs + (i)*PKT_BUF_SZ;
-			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
-		}
+		pDesc->td_info->buf = pDevice->tx0_bufs + i * PKT_BUF_SZ;
+		pDesc->td_info->buf_dma = pDevice->tx_bufs_dma0 + i * PKT_BUF_SZ;
+
 		pDesc->next = &(pDevice->apTD0Rings[(i+1) % pDevice->sOpts.nTxDescs[0]]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
@@ -721,10 +710,9 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 		pDesc = &(pDevice->apTD1Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
-		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
-			pDesc->td_info->buf = pDevice->tx1_bufs + (i) * PKT_BUF_SZ;
-			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
-		}
+		pDesc->td_info->buf = pDevice->tx1_bufs + i * PKT_BUF_SZ;
+		pDesc->td_info->buf_dma = pDevice->tx_bufs_dma1 + i * PKT_BUF_SZ;
+
 		pDesc->next = &(pDevice->apTD1Rings[(i + 1) % pDevice->sOpts.nTxDescs[1]]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
@@ -1640,7 +1628,6 @@ static int vnt_init(struct vnt_private *priv)
 static int
 vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 {
-	PCHIP_INFO  pChip_info = (PCHIP_INFO)ent->driver_data;
 	struct vnt_private *priv;
 	struct ieee80211_hw *hw;
 	struct wiphy *wiphy;
@@ -1660,7 +1647,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	priv = hw->priv;
 
-	vt6655_init_info(pcid, &priv, pChip_info);
+	vt6655_init_info(pcid, &priv);
 
 	priv->hw = hw;
 
@@ -1681,7 +1668,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	}
 
 	priv->PortOffset = ioremap(priv->memaddr & PCI_BASE_ADDRESS_MEM_MASK,
-				   priv->io_size);
+				   256);
 	if (!priv->PortOffset) {
 		dev_err(&pcid->dev, ": Failed to IO remapping ..\n");
 		device_free_info(priv);
@@ -1721,11 +1708,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	device_get_options(priv);
 	device_set_options(priv);
-	/* Mask out the options cannot be set to the chip */
-	priv->sOpts.flags &= pChip_info->flags;
-
-	/* Enable the chip specified capabilities */
-	priv->flags = priv->sOpts.flags | (pChip_info->flags & 0xff000000UL);
 
 	wiphy = priv->hw->wiphy;
 
-- 
2.5.0

