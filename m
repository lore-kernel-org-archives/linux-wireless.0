Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35089 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZKHG5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 01:57:40 -0500
Received: by yxe17 with SMTP id 17so1889221yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 22:57:46 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 7 Nov 2009 22:57:45 -0800
Message-ID: <79f7ecbe0911072257o385ed65h238d2ed7261321f6@mail.gmail.com>
Subject: [PATCH 1/1] ath_hif_usb: changed 'typedef struct' to 'struct' &
	replaced UsbTxQ with 'struct sk_buff *'
From: RCore Linux <rshlinux@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replaced structure definitions from 'typedef struct' to 'struct
<struct>' ,  replaced UsbTxQ references to 'struct sk_buff *'

Signed-off-by: Ramesh R <rshlinux@gmail.com>
---
 ath/ath9k/ath_hif_usb.c |   85 +++++++++++++++++++++++------------------------
 1 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/ath/ath9k/ath_hif_usb.c b/ath/ath9k/ath_hif_usb.c
index 0a67763..82634e1 100644
--- a/ath/ath9k/ath_hif_usb.c
+++ b/ath/ath9k/ath_hif_usb.c
@@ -91,37 +91,33 @@ struct cmd_urb_context {
 	struct hif_device_usb *hif_dev;
 };

-struct UsbTxQ {
-	struct sk_buff *buf;
-};
-
-typedef struct _UsbTxUrbContext {
+struct UsbTxUrbContext {
 	u8 index;
 	u8 inUse;
 	struct hif_device_usb *hif_dev;
 	struct sk_buff *buf;
 	struct urb *urb;
-} UsbTxUrbContext;
+};

 struct hif_usb_tx_pipe {
-	u8              usb_pipe;
-	struct UsbTxQ   UsbTxBufQ[ZM_MAX_TX_BUF_NUM];
-	u16             TxBufHead;
-	u16             TxBufTail;
-	u16             TxBufCnt;
-	u16             TxUrbHead;
-	u16             TxUrbTail;
-	u16             TxUrbCnt;
-	UsbTxUrbContext TxUrbCtx[ZM_MAX_TX_URB_NUM];
-	usb_complete_t  complete;
+	u8 usb_pipe;
+	struct sk_buff *UsbTxBufQ[ZM_MAX_TX_BUF_NUM];
+	u16 TxBufHead;
+	u16 TxBufTail;
+	u16 TxBufCnt;
+	u16 TxUrbHead;
+	u16 TxUrbTail;
+	u16 TxUrbCnt;
+	struct UsbTxUrbContext TxUrbCtx[ZM_MAX_TX_URB_NUM];
+	usb_complete_t complete;
 };

-typedef struct _UsbRxUrbContext {
+struct UsbRxUrbContext{
 	u8 inUse;
 	struct hif_device_usb *hif_dev;
 	struct sk_buff *skb;
 	struct urb *urb;
-} UsbRxUrbContext;
+} ;

 struct hif_device_usb {
 	void *htc_handle;
@@ -132,7 +128,7 @@ struct hif_device_usb {
 	u16 device_id;

 	struct sk_buff *regUsbReadBuf;
-	UsbRxUrbContext RxUrbCtx[ZM_MAX_RX_URB_NUM];
+	struct UsbRxUrbContext RxUrbCtx[ZM_MAX_RX_URB_NUM];
 	struct usb_anchor rx_submitted;
 	struct hif_usb_tx_pipe tx_lp;
 	struct hif_usb_tx_pipe tx_mp;
@@ -262,12 +258,12 @@ out:
 	return r;
 }

-static UsbTxUrbContext *zfLnxGetFreeTxUrb(struct hif_device_usb *hif_dev,
+static struct UsbTxUrbContext *zfLnxGetFreeTxUrb(struct
hif_device_usb *hif_dev,
 					  struct hif_usb_tx_pipe *pipe)
 {
-	u16 idx;
-	unsigned long irqFlag;
-	UsbTxUrbContext *ctx = NULL;
+	u16                    idx;
+	unsigned long          irqFlag;
+	struct UsbTxUrbContext *ctx = NULL;

 	spin_lock_irqsave(&(hif_dev->cs_lock), irqFlag);

@@ -285,7 +281,8 @@ static UsbTxUrbContext *zfLnxGetFreeTxUrb(struct
hif_device_usb *hif_dev,
 }

 static void zfLnxPutTxUrb(struct hif_device_usb *hif_dev,
-			  struct hif_usb_tx_pipe *pipe, UsbTxUrbContext * ctx)
+			struct hif_usb_tx_pipe *pipe,
+			struct UsbTxUrbContext *ctx)
 {
 	unsigned long irqFlag;

@@ -307,11 +304,11 @@ static u16 zfLnxCheckTxBufferCnt(struct
hif_device_usb *hif_dev,
 	return TxBufCnt;
 }

-static struct UsbTxQ *zfLnxGetUsbTxBuffer(struct hif_device_usb *hif_dev,
+static struct sk_buff *zfLnxGetUsbTxBuffer(struct hif_device_usb *hif_dev,
 				     struct hif_usb_tx_pipe *pipe)
 {
 	u16 idx;
-	struct UsbTxQ *TxQ;
+	struct sk_buff *TxQ;
 	unsigned long flags;

 	spin_lock_irqsave(&hif_dev->cs_lock, flags);
@@ -319,7 +316,7 @@ static struct UsbTxQ *zfLnxGetUsbTxBuffer(struct
hif_device_usb *hif_dev,
 	idx = ((pipe->TxBufHead + 1) & (ZM_MAX_TX_BUF_NUM - 1));

 	if (pipe->TxBufCnt > 0) {
-		TxQ = (struct UsbTxQ *) &(pipe->UsbTxBufQ[pipe->TxBufHead]);
+		TxQ = (struct sk_buff *) &(pipe->UsbTxBufQ[pipe->TxBufHead]);
 		pipe->TxBufHead =
 		    ((pipe->TxBufHead + 1) & (ZM_MAX_TX_BUF_NUM - 1));
 		pipe->TxBufCnt--;
@@ -341,10 +338,10 @@ static struct UsbTxQ *zfLnxGetUsbTxBuffer(struct
hif_device_usb *hif_dev,
 static u32 zfLnxUsbSubmitTxData(struct hif_device_usb *hif_dev,
 				struct hif_usb_tx_pipe *tx_pipe)
 {
-	UsbTxUrbContext *urb_ctx;
-	struct UsbTxQ   *tx_data;
-	struct sk_buff  *skb;
-	int             r;
+	struct UsbTxUrbContext *urb_ctx;
+	struct sk_buff *tx_data;
+	struct sk_buff *skb;
+	int            r;

 	/* First check whether there is a free URB */
 	urb_ctx = zfLnxGetFreeTxUrb(hif_dev, tx_pipe);
@@ -361,7 +358,7 @@ static u32 zfLnxUsbSubmitTxData(struct
hif_device_usb *hif_dev,
 		return -ENOBUFS;
 	}

-	skb = tx_data->buf;
+	skb = tx_data;
 	urb_ctx->buf = skb;

 	/* Submit a tx urb */
@@ -386,7 +383,7 @@ static u32 zfLnxUsbSubmitTxData(struct
hif_device_usb *hif_dev,

 static void hif_tx_lp_cb(struct urb *urb)
 {
-	UsbTxUrbContext *ctx = (UsbTxUrbContext *) urb->context;
+	struct UsbTxUrbContext *ctx = (struct UsbTxUrbContext *) urb->context;
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)ctx->hif_dev;
 	struct sk_buff *buf;

@@ -616,7 +613,8 @@ static void hif_cmd_cb(struct urb *urb)
 	HTCTxCompletionHandler(hif_dev->htc_handle, buf);
 }

-static u32 zfLnxUsbIn(struct hif_device_usb *hif_dev, UsbRxUrbContext
*RxUrbCtx)
+static u32 zfLnxUsbIn(struct hif_device_usb *hif_dev,
+			struct UsbRxUrbContext *RxUrbCtx)
 {
 	struct urb *urb = RxUrbCtx->urb;
 	struct sk_buff *skb = RxUrbCtx->skb;
@@ -633,7 +631,8 @@ static u32 zfLnxUsbIn(struct hif_device_usb
*hif_dev, UsbRxUrbContext *RxUrbCtx)

 static void hif_rx_cb(struct urb *urb)
 {
-	UsbRxUrbContext *RxUrbCtx = (UsbRxUrbContext *) urb->context;
+	struct UsbRxUrbContext *RxUrbCtx =
+				(struct UsbRxUrbContext *) urb->context;
 	struct hif_device_usb *hif_dev = RxUrbCtx->hif_dev;
 	struct sk_buff *buf;
 	struct sk_buff *new_buf;
@@ -683,7 +682,7 @@ static void hif_rx_cb(struct urb *urb)

 static void hif_tx_hp_cb(struct urb *urb)
 {
-	UsbTxUrbContext *ctx = (UsbTxUrbContext *) urb->context;
+	struct UsbTxUrbContext *ctx = (struct UsbTxUrbContext *) urb->context;
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)ctx->hif_dev;
 	struct sk_buff *buf;

@@ -706,7 +705,7 @@ static void hif_tx_hp_cb(struct urb *urb)

 static void hif_tx_mp_cb(struct urb *urb)
 {
-	UsbTxUrbContext *ctx = (UsbTxUrbContext *) urb->context;
+	struct UsbTxUrbContext *ctx = (struct UsbTxUrbContext *) urb->context;
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)ctx->hif_dev;
 	struct sk_buff *buf;

@@ -730,10 +729,10 @@ static void hif_tx_mp_cb(struct urb *urb)
 static u16 zfLnxPutUsbTxBuffer(struct hif_device_usb *hif_dev, struct
sk_buff *buf,
 			       struct hif_usb_tx_pipe *tx_pipe)
 {
-	unsigned long flags;
-	u16           idx;
-	struct UsbTxQ *TxQ;
-	int           r = 0;
+	unsigned long  flags;
+	u16            idx;
+	struct sk_buff *TxQ;
+	int            r = 0;

 	spin_lock_irqsave(&(hif_dev->cs_lock), flags);

@@ -744,8 +743,8 @@ static u16 zfLnxPutUsbTxBuffer(struct
hif_device_usb *hif_dev, struct sk_buff *b
 		goto out;
 	}

-	TxQ = (struct UsbTxQ *) &(tx_pipe->UsbTxBufQ[tx_pipe->TxBufTail]);
-	TxQ->buf = buf;
+	TxQ = (struct sk_buff *) &(tx_pipe->UsbTxBufQ[tx_pipe->TxBufTail]);
+	TxQ = buf;
 	tx_pipe->TxBufTail = ((tx_pipe->TxBufTail + 1) &
 			       (ZM_MAX_TX_BUF_NUM - 1));
 	tx_pipe->TxBufCnt++;
-- 
1.5.6.5
