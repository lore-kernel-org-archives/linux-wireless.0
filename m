Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38069 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbJQKdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:24 -0400
Received: by wicll6 with SMTP id ll6so41469226wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/9] staging: vt6655: replace typedef struct __device_opt
Date: Sat, 17 Oct 2015 11:32:58 +0100
Message-Id: <1445077982-17832-5-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123331_962984_308E8EED)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_options and members
rx_descs0 for nRxDescs0
rx_descs1 for nRxDescs1
tx_descs for nTxDescs
int_works
short_retry
long_retry
bbp_type
flags

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  8 ++--
 drivers/staging/vt6655/device.h      | 24 +++++-----
 drivers/staging/vt6655/device_main.c | 92 ++++++++++++++++++------------------
 3 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 5c7f07e..71c9b97 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -523,12 +523,12 @@ CARDvSafeResetTx(
 	for (uu = 0; uu < TYPE_MAXTD; uu++)
 		pDevice->iTDUsed[uu] = 0;
 
-	for (uu = 0; uu < pDevice->sOpts.nTxDescs[0]; uu++) {
+	for (uu = 0; uu < pDevice->sOpts.tx_descs[0]; uu++) {
 		pCurrTD = &(pDevice->apTD0Rings[uu]);
 		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
 	}
-	for (uu = 0; uu < pDevice->sOpts.nTxDescs[1]; uu++) {
+	for (uu = 0; uu < pDevice->sOpts.tx_descs[1]; uu++) {
 		pCurrTD = &(pDevice->apTD1Rings[uu]);
 		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
@@ -571,7 +571,7 @@ CARDvSafeResetRx(
 	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
 
 	/* init state, all RD is chip's */
-	for (uu = 0; uu < pDevice->sOpts.nRxDescs0; uu++) {
+	for (uu = 0; uu < pDevice->sOpts.rx_descs0; uu++) {
 		pDesc = &(pDevice->aRD0Ring[uu]);
 		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
@@ -579,7 +579,7 @@ CARDvSafeResetRx(
 	}
 
 	/* init state, all RD is chip's */
-	for (uu = 0; uu < pDevice->sOpts.nRxDescs1; uu++) {
+	for (uu = 0; uu < pDevice->sOpts.rx_descs1; uu++) {
 		pDesc = &(pDevice->aRD1Ring[uu]);
 		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 83bb68b..aca6e00 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -85,7 +85,7 @@
 
 /* BUILD OBJ mode */
 
-#define	AVAIL_TD(p, q)	((p)->sOpts.nTxDescs[(q)] - ((p)->iTDUsed[(q)]))
+#define	AVAIL_TD(p, q)	((p)->sOpts.tx_descs[(q)] - ((p)->iTDUsed[(q)]))
 
 /* 0:11A 1:11B 2:11G */
 #define BB_TYPE_11A    0
@@ -101,16 +101,16 @@
 #define OWNED_BY_HOST	0
 #define	OWNED_BY_NIC	1
 
-typedef struct __device_opt {
-	int         nRxDescs0;		/* Number of RX descriptors0 */
-	int         nRxDescs1;		/* Number of RX descriptors1 */
-	int         nTxDescs[2];	/* Number of TX descriptors 0, 1 */
-	int         int_works;		/* interrupt limits */
-	int         short_retry;
-	int         long_retry;
-	int         bbp_type;
-	u32         flags;
-} OPTIONS, *POPTIONS;
+struct vnt_options {
+	int rx_descs0;		/* Number of RX descriptors0 */
+	int rx_descs1;		/* Number of RX descriptors1 */
+	int tx_descs[2];	/* Number of TX descriptors 0, 1 */
+	int int_works;		/* interrupt limits */
+	int short_retry;
+	int long_retry;
+	int bbp_type;
+	u32 flags;
+};
 
 struct vnt_private {
 	struct pci_dev *pcid;
@@ -159,7 +159,7 @@ struct vnt_private {
 	struct vnt_rx_desc *aRD1Ring;
 	struct vnt_rx_desc *pCurrRD[TYPE_MAXRD];
 
-	OPTIONS                     sOpts;
+	struct vnt_options sOpts;
 
 	u32                         flags;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0ed82a64..8bca3fc 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -168,12 +168,12 @@ static void vt6655_remove(struct pci_dev *pcid)
 
 static void device_get_options(struct vnt_private *priv)
 {
-	POPTIONS pOpts = &priv->sOpts;
+	struct vnt_options *pOpts = &priv->sOpts;
 
-	pOpts->nRxDescs0 = RX_DESC_DEF0;
-	pOpts->nRxDescs1 = RX_DESC_DEF1;
-	pOpts->nTxDescs[0] = TX_DESC_DEF0;
-	pOpts->nTxDescs[1] = TX_DESC_DEF1;
+	pOpts->rx_descs0 = RX_DESC_DEF0;
+	pOpts->rx_descs1 = RX_DESC_DEF1;
+	pOpts->tx_descs[0] = TX_DESC_DEF0;
+	pOpts->tx_descs[1] = TX_DESC_DEF1;
 	pOpts->int_works = INT_WORKS_DEF;
 
 	pOpts->short_retry = SHORT_RETRY_DEF;
@@ -452,10 +452,10 @@ static bool device_init_rings(struct vnt_private *priv)
 
 	/*allocate all RD/TD rings a single pool*/
 	vir_pool = dma_zalloc_coherent(&priv->pcid->dev,
-				       priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-				       priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-				       priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-				       priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+				       priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc) +
+				       priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc) +
+				       priv->sOpts.tx_descs[0] * sizeof(struct vnt_tx_desc) +
+				       priv->sOpts.tx_descs[1] * sizeof(struct vnt_tx_desc),
 				       &priv->pool_dma, GFP_ATOMIC);
 	if (vir_pool == NULL) {
 		dev_err(&priv->pcid->dev, "allocate desc dma memory failed\n");
@@ -464,15 +464,15 @@ static bool device_init_rings(struct vnt_private *priv)
 
 	priv->aRD0Ring = vir_pool;
 	priv->aRD1Ring = vir_pool +
-		priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
+		priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc);
 
 	priv->rd0_pool_dma = priv->pool_dma;
 	priv->rd1_pool_dma = priv->rd0_pool_dma +
-		priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
+		priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc);
 
 	priv->tx0_bufs = dma_zalloc_coherent(&priv->pcid->dev,
-					     priv->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-					     priv->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+					     priv->sOpts.tx_descs[0] * PKT_BUF_SZ +
+					     priv->sOpts.tx_descs[1] * PKT_BUF_SZ +
 					     CB_BEACON_BUF_SIZE +
 					     CB_MAX_BUF_SIZE,
 					     &priv->tx_bufs_dma0,
@@ -481,44 +481,44 @@ static bool device_init_rings(struct vnt_private *priv)
 		dev_err(&priv->pcid->dev, "allocate buf dma memory failed\n");
 
 		dma_free_coherent(&priv->pcid->dev,
-				  priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-				  priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-				  priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-				  priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+				  priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc) +
+				  priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc) +
+				  priv->sOpts.tx_descs[0] * sizeof(struct vnt_tx_desc) +
+				  priv->sOpts.tx_descs[1] * sizeof(struct vnt_tx_desc),
 				  vir_pool, priv->pool_dma);
 		return false;
 	}
 
 	priv->td0_pool_dma = priv->rd1_pool_dma +
-		priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
+		priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc);
 
 	priv->td1_pool_dma = priv->td0_pool_dma +
-		priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
+		priv->sOpts.tx_descs[0] * sizeof(struct vnt_tx_desc);
 
 	/* vir_pool: pvoid type */
 	priv->apTD0Rings = vir_pool
-		+ priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
-		+ priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
+		+ priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc);
 
 	priv->apTD1Rings = vir_pool
-		+ priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
-		+ priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc)
-		+ priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
+		+ priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.tx_descs[0] * sizeof(struct vnt_tx_desc);
 
 	priv->tx1_bufs = priv->tx0_bufs +
-		priv->sOpts.nTxDescs[0] * PKT_BUF_SZ;
+		priv->sOpts.tx_descs[0] * PKT_BUF_SZ;
 
 	priv->tx_beacon_bufs = priv->tx1_bufs +
-		priv->sOpts.nTxDescs[1] * PKT_BUF_SZ;
+		priv->sOpts.tx_descs[1] * PKT_BUF_SZ;
 
 	priv->pbyTmpBuff = priv->tx_beacon_bufs +
 		CB_BEACON_BUF_SIZE;
 
 	priv->tx_bufs_dma1 = priv->tx_bufs_dma0 +
-		priv->sOpts.nTxDescs[0] * PKT_BUF_SZ;
+		priv->sOpts.tx_descs[0] * PKT_BUF_SZ;
 
 	priv->tx_beacon_dma = priv->tx_bufs_dma1 +
-		priv->sOpts.nTxDescs[1] * PKT_BUF_SZ;
+		priv->sOpts.tx_descs[1] * PKT_BUF_SZ;
 
 	return true;
 }
@@ -526,16 +526,16 @@ static bool device_init_rings(struct vnt_private *priv)
 static void device_free_rings(struct vnt_private *priv)
 {
 	dma_free_coherent(&priv->pcid->dev,
-			  priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-			  priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-			  priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-			  priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+			  priv->sOpts.rx_descs0 * sizeof(struct vnt_rx_desc) +
+			  priv->sOpts.rx_descs1 * sizeof(struct vnt_rx_desc) +
+			  priv->sOpts.tx_descs[0] * sizeof(struct vnt_tx_desc) +
+			  priv->sOpts.tx_descs[1] * sizeof(struct vnt_tx_desc),
 			  priv->aRD0Ring, priv->pool_dma);
 
 	if (priv->tx0_bufs)
 		dma_free_coherent(&priv->pcid->dev,
-				  priv->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-				  priv->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+				  priv->sOpts.tx_descs[0] * PKT_BUF_SZ +
+				  priv->sOpts.tx_descs[1] * PKT_BUF_SZ +
 				  CB_BEACON_BUF_SIZE +
 				  CB_MAX_BUF_SIZE,
 				  priv->tx0_bufs, priv->tx_bufs_dma0);
@@ -548,7 +548,7 @@ static void device_init_rd0_ring(struct vnt_private *priv)
 	struct vnt_rx_desc *desc;
 
 	/* Init the RD0 ring entries */
-	for (i = 0; i < priv->sOpts.nRxDescs0;
+	for (i = 0; i < priv->sOpts.rx_descs0;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		desc = &priv->aRD0Ring[i];
 		desc->rd_info = alloc_rd_info();
@@ -556,7 +556,7 @@ static void device_init_rd0_ring(struct vnt_private *priv)
 		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		desc->next = &(priv->aRD0Ring[(i+1) % priv->sOpts.nRxDescs0]);
+		desc->next = &(priv->aRD0Ring[(i+1) % priv->sOpts.rx_descs0]);
 		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
@@ -572,7 +572,7 @@ static void device_init_rd1_ring(struct vnt_private *priv)
 	struct vnt_rx_desc *desc;
 
 	/* Init the RD1 ring entries */
-	for (i = 0; i < priv->sOpts.nRxDescs1;
+	for (i = 0; i < priv->sOpts.rx_descs1;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		desc = &priv->aRD1Ring[i];
 		desc->rd_info = alloc_rd_info();
@@ -580,7 +580,7 @@ static void device_init_rd1_ring(struct vnt_private *priv)
 		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		desc->next = &(priv->aRD1Ring[(i+1) % priv->sOpts.nRxDescs1]);
+		desc->next = &(priv->aRD1Ring[(i+1) % priv->sOpts.rx_descs1]);
 		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
@@ -593,7 +593,7 @@ static void device_free_rd0_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < priv->sOpts.nRxDescs0; i++) {
+	for (i = 0; i < priv->sOpts.rx_descs0; i++) {
 		struct vnt_rx_desc *desc = &(priv->aRD0Ring[i]);
 		struct vnt_rd_info *rd_info = desc->rd_info;
 
@@ -610,7 +610,7 @@ static void device_free_rd1_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < priv->sOpts.nRxDescs1; i++) {
+	for (i = 0; i < priv->sOpts.rx_descs1; i++) {
 		struct vnt_rx_desc *desc = &priv->aRD1Ring[i];
 		struct vnt_rd_info *rd_info = desc->rd_info;
 
@@ -630,7 +630,7 @@ static void device_init_td0_ring(struct vnt_private *priv)
 	struct vnt_tx_desc *desc;
 
 	curr = priv->td0_pool_dma;
-	for (i = 0; i < priv->sOpts.nTxDescs[0];
+	for (i = 0; i < priv->sOpts.tx_descs[0];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		desc = &priv->apTD0Rings[i];
 		desc->td_info = alloc_td_info();
@@ -638,7 +638,7 @@ static void device_init_td0_ring(struct vnt_private *priv)
 		desc->td_info->buf = priv->tx0_bufs + i * PKT_BUF_SZ;
 		desc->td_info->buf_dma = priv->tx_bufs_dma0 + i * PKT_BUF_SZ;
 
-		desc->next = &(priv->apTD0Rings[(i+1) % priv->sOpts.nTxDescs[0]]);
+		desc->next = &(priv->apTD0Rings[(i+1) % priv->sOpts.tx_descs[0]]);
 		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
@@ -655,7 +655,7 @@ static void device_init_td1_ring(struct vnt_private *priv)
 
 	/* Init the TD ring entries */
 	curr = priv->td1_pool_dma;
-	for (i = 0; i < priv->sOpts.nTxDescs[1];
+	for (i = 0; i < priv->sOpts.tx_descs[1];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		desc = &priv->apTD1Rings[i];
 		desc->td_info = alloc_td_info();
@@ -663,7 +663,7 @@ static void device_init_td1_ring(struct vnt_private *priv)
 		desc->td_info->buf = priv->tx1_bufs + i * PKT_BUF_SZ;
 		desc->td_info->buf_dma = priv->tx_bufs_dma1 + i * PKT_BUF_SZ;
 
-		desc->next = &(priv->apTD1Rings[(i + 1) % priv->sOpts.nTxDescs[1]]);
+		desc->next = &(priv->apTD1Rings[(i + 1) % priv->sOpts.tx_descs[1]]);
 		desc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
@@ -676,7 +676,7 @@ static void device_free_td0_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < priv->sOpts.nTxDescs[0]; i++) {
+	for (i = 0; i < priv->sOpts.tx_descs[0]; i++) {
 		struct vnt_tx_desc *desc = &priv->apTD0Rings[i];
 		struct vnt_td_info *td_info = desc->td_info;
 
@@ -689,7 +689,7 @@ static void device_free_td1_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < priv->sOpts.nTxDescs[1]; i++) {
+	for (i = 0; i < priv->sOpts.tx_descs[1]; i++) {
 		struct vnt_tx_desc *desc = &priv->apTD1Rings[i];
 		struct vnt_td_info *td_info = desc->td_info;
 
-- 
2.5.0

