Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56654 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKEVJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:43 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so1912130wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:40 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/11] staging: vt6655: remove fragmentation from driver
Date: Wed,  5 Nov 2014 21:08:52 +0000
Message-Id: <1415221739-3045-4-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220946_493373_3864DB49)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fragmentation is now handled by mac80211.

Remove functions
device_alloc_frag_buf
device_init_defrag_cb
device_free_frag_buf

Removing
typedef struct tagSDeFragControlBlock
frag_thresh
sRxDFCB
cbDFCB;
cbFreeDFCB;
uCurrentDFCBIdx;

macros
FRAG_THRESH_MIN
FRAG_THRESH_MAX

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  3 --
 drivers/staging/vt6655/device.h      | 25 -----------------
 drivers/staging/vt6655/device_main.c | 53 ------------------------------------
 3 files changed, 81 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index bff77c8..60f051f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -583,9 +583,6 @@ CARDvSafeResetRx(
 		pDesc->m_rd1RD1.wReqCount = (unsigned short)(pDevice->rx_buf_sz);
 	}
 
-	pDevice->cbDFCB = CB_MAX_RX_FRAG;
-	pDevice->cbFreeDFCB = pDevice->cbDFCB;
-
 	/* set perPkt mode */
 	MACvRx0PerPktMode(pDevice->PortOffset);
 	MACvRx1PerPktMode(pDevice->PortOffset);
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 93d2ccb..903d782 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -177,19 +177,6 @@ typedef enum {
 	OWNED_BY_NIC = 1
 } DEVICE_OWNER_TYPE, *PDEVICE_OWNER_TYPE;
 
-#define CB_MAX_RX_FRAG                 64
-/* DeFragment Control Block, used for collecting fragments prior to reassembly */
-typedef struct tagSDeFragControlBlock {
-	unsigned short wSequence;
-	unsigned short wFragNum;
-	unsigned char abyAddr2[ETH_ALEN];
-	unsigned int uLifetime;
-	struct sk_buff *skb;
-	unsigned char *pbyRxBuffer;
-	unsigned int cbFrameLength;
-	bool bInUse;
-} SDeFragControlBlock, *PSDeFragControlBlock;
-
 /* flags for options */
 #define     DEVICE_FLAGS_IP_ALIGN        0x00000001UL
 #define     DEVICE_FLAGS_PREAMBLE_TYPE   0x00000002UL
@@ -223,7 +210,6 @@ typedef struct __device_opt {
 	int         nTxDescs[2];	/* Number of TX descriptors 0, 1 */
 	int         int_works;		/* interrupt limits */
 	int         rts_thresh;		/* rts threshold */
-	int         frag_thresh;
 	int         data_rate;
 	int         channel_num;
 	int         short_retry;
@@ -287,11 +273,6 @@ struct vnt_private {
 	volatile PSRxDesc           aRD1Ring;
 	volatile PSRxDesc           pCurrRD[TYPE_MAXRD];
 
-	SDeFragControlBlock         sRxDFCB[CB_MAX_RX_FRAG];
-	unsigned int	cbDFCB;
-	unsigned int	cbFreeDFCB;
-	unsigned int	uCurrentDFCBIdx;
-
 	OPTIONS                     sOpts;
 
 	u32                         flags;
@@ -364,7 +345,6 @@ struct vnt_private {
 
 	unsigned short wCurrentRate;
 	unsigned short wRTSThreshold;
-	unsigned short wFragmentationThreshold;
 	unsigned char byShortRetryLimit;
 	unsigned char byLongRetryLimit;
 	enum nl80211_iftype op_mode;
@@ -487,9 +467,4 @@ static inline PDEVICE_TD_INFO alloc_td_info(void)
 {
 	return kzalloc(sizeof(DEVICE_TD_INFO), GFP_ATOMIC);
 }
-
-/*---------------------  Export Functions  --------------------------*/
-
-bool device_alloc_frag_buf(struct vnt_private *pDevice,
-			   PSDeFragControlBlock pDeF);
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 35d69a9..1731ef5 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -35,16 +35,13 @@
  *   device_intr - interrupt handle function
  *   device_rx_srv - rx service function
  *   device_alloc_rx_buf - rx buffer pre-allocated function
- *   device_alloc_frag_buf - rx fragement pre-allocated function
  *   device_free_tx_buf - free tx buffer function
- *   device_free_frag_buf- free de-fragement buffer
  *   device_init_rd0_ring- initial rd dma0 ring
  *   device_init_rd1_ring- initial rd dma1 ring
  *   device_init_td0_ring- initial tx dma0 ring buffer
  *   device_init_td1_ring- initial tx dma1 ring buffer
  *   device_init_registers- initial MAC & BBP & RF internal registers.
  *   device_init_rings- initial tx/rx ring buffer
- *   device_init_defrag_cb- initial & allocate de-fragement buffer.
  *   device_free_rings- free all allocated ring buffer
  *   device_tx_srv- tx interrupt service function
  *
@@ -132,12 +129,8 @@ DEVICE_PARAM(PreambleType, "Preamble Type");
 
 DEVICE_PARAM(RTSThreshold, "RTS threshold");
 
-#define FRAG_THRESH_MIN     256
-#define FRAG_THRESH_MAX     2346
 #define FRAG_THRESH_DEF     2346
 
-DEVICE_PARAM(FragThreshold, "Fragmentation threshold");
-
 #define DATA_RATE_MIN     0
 #define DATA_RATE_MAX     13
 #define DATA_RATE_DEF     13
@@ -256,7 +249,6 @@ static struct notifier_block device_notifier = {
 
 static void device_init_rd0_ring(struct vnt_private *pDevice);
 static void device_init_rd1_ring(struct vnt_private *pDevice);
-static void device_init_defrag_cb(struct vnt_private *pDevice);
 static void device_init_td0_ring(struct vnt_private *pDevice);
 static void device_init_td1_ring(struct vnt_private *pDevice);
 
@@ -270,7 +262,6 @@ static void device_free_td1_ring(struct vnt_private *pDevice);
 static void device_free_rd0_ring(struct vnt_private *pDevice);
 static void device_free_rd1_ring(struct vnt_private *pDevice);
 static void device_free_rings(struct vnt_private *pDevice);
-static void device_free_frag_buf(struct vnt_private *pDevice);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -306,7 +297,6 @@ static void device_get_options(struct vnt_private *pDevice)
 	pOpts->flags |= DEVICE_FLAGS_IP_ALIGN;
 	pOpts->int_works = INT_WORKS_DEF;
 	pOpts->rts_thresh = RTS_THRESH_DEF;
-	pOpts->frag_thresh = FRAG_THRESH_DEF;
 	pOpts->data_rate = DATA_RATE_DEF;
 	pOpts->channel_num = CHANNEL_DEF;
 
@@ -332,7 +322,6 @@ device_set_options(struct vnt_private *pDevice)
 
 	pDevice->uChannel = pDevice->sOpts.channel_num;
 	pDevice->wRTSThreshold = pDevice->sOpts.rts_thresh;
-	pDevice->wFragmentationThreshold = pDevice->sOpts.frag_thresh;
 	pDevice->byShortRetryLimit = pDevice->sOpts.short_retry;
 	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
 	pDevice->wMaxTransmitMSDULifetime = DEFAULT_MSDU_LIFETIME;
@@ -853,21 +842,6 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
 }
 
-static void device_init_defrag_cb(struct vnt_private *pDevice)
-{
-	int i;
-	PSDeFragControlBlock pDeF;
-
-	/* Init the fragment ctl entries */
-	for (i = 0; i < CB_MAX_RX_FRAG; i++) {
-		pDeF = &(pDevice->sRxDFCB[i]);
-		if (!device_alloc_frag_buf(pDevice, pDeF))
-			dev_err(&pDevice->pcid->dev, "can not alloc frag bufs\n");
-	}
-	pDevice->cbDFCB = CB_MAX_RX_FRAG;
-	pDevice->cbFreeDFCB = pDevice->cbDFCB;
-}
-
 static void device_free_rd0_ring(struct vnt_private *pDevice)
 {
 	int i;
@@ -902,20 +876,6 @@ static void device_free_rd1_ring(struct vnt_private *pDevice)
 	}
 }
 
-static void device_free_frag_buf(struct vnt_private *pDevice)
-{
-	PSDeFragControlBlock pDeF;
-	int i;
-
-	for (i = 0; i < CB_MAX_RX_FRAG; i++) {
-		pDeF = &(pDevice->sRxDFCB[i]);
-
-		if (pDeF->skb)
-			dev_kfree_skb(pDeF->skb);
-
-	}
-}
-
 static void device_init_td0_ring(struct vnt_private *pDevice)
 {
 	int i;
@@ -1056,17 +1016,6 @@ static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 	return true;
 }
 
-bool device_alloc_frag_buf(struct vnt_private *pDevice,
-			   PSDeFragControlBlock pDeF)
-{
-	pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-	if (pDeF->skb == NULL)
-		return false;
-	ASSERT(pDeF->skb);
-
-	return true;
-}
-
 static const u8 fallback_rate0[5][5] = {
 	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
 	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
@@ -1470,7 +1419,6 @@ static int vnt_start(struct ieee80211_hw *hw)
 	dev_dbg(&priv->pcid->dev, "call device init rd0 ring\n");
 	device_init_rd0_ring(priv);
 	device_init_rd1_ring(priv);
-	device_init_defrag_cb(priv);
 	device_init_td0_ring(priv);
 	device_init_td1_ring(priv);
 
@@ -1498,7 +1446,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	device_free_td1_ring(priv);
 	device_free_rd0_ring(priv);
 	device_free_rd1_ring(priv);
-	device_free_frag_buf(priv);
 	device_free_rings(priv);
 
 	free_irq(priv->pcid->irq, priv);
-- 
2.1.0

