Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63701 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbaGESZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:25:03 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4976037wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:25:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] stagingL vt6656: implement fall back rates reporting.
Date: Sat,  5 Jul 2014 19:24:27 +0100
Message-Id: <1404584667-3582-8-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202511_425079_087AC86E)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver reports the rate tried in struct vnt_interrupt_data tsr* variables
which is available in INTnsProcessData via interrupt urb context.

Instead of closing apTD tx context in s_nsBulkOutIoCompleteWrite by setting
in_use to false. Keep the context open and allow vnt_int_report_rate to
close it.

If the tx_retry value is correct it will report back the sucessful RATE tried.

struct vnt_usb_send_context add pkt_no which is index of apTD

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |   2 +
 drivers/staging/vt6656/int.c      | 104 +++++++++++++++++++++++++++++---------
 drivers/staging/vt6656/main_usb.c |   1 +
 drivers/staging/vt6656/rxtx.c     |   8 +--
 drivers/staging/vt6656/usbpipe.c  |  23 +++------
 5 files changed, 93 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 4d1eb22..789c55d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -246,6 +246,8 @@ struct vnt_usb_send_context {
 	unsigned int buf_len;
 	u16 tx_hdr_size;
 	u8 type;
+	u8 pkt_no;
+	u8 fb_option;
 	bool in_use;
 	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 };
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 1913b73..1cc9364 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -39,6 +39,22 @@
 
 static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
 
+static const u8 fallback_rate0[5][5] = {
+	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
+	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
+	{RATE_36M, RATE_36M, RATE_24M, RATE_18M, RATE_18M},
+	{RATE_48M, RATE_48M, RATE_36M, RATE_24M, RATE_24M},
+	{RATE_54M, RATE_54M, RATE_48M, RATE_36M, RATE_36M}
+};
+
+static const u8 fallback_rate1[5][5] = {
+	{RATE_18M, RATE_18M, RATE_12M, RATE_6M, RATE_6M},
+	{RATE_24M, RATE_24M, RATE_18M, RATE_6M, RATE_6M},
+	{RATE_36M, RATE_36M, RATE_24M, RATE_12M, RATE_12M},
+	{RATE_48M, RATE_48M, RATE_24M, RATE_12M, RATE_12M},
+	{RATE_54M, RATE_54M, RATE_36M, RATE_18M, RATE_18M}
+};
+
 /*+
  *
  *  Function:   InterruptPollingThread
@@ -75,6 +91,62 @@ void INTvWorkItem(struct vnt_private *pDevice)
 	spin_unlock_irqrestore(&pDevice->lock, flags);
 }
 
+static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
+{
+	struct vnt_usb_send_context *context;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_rate *rate;
+	u8 tx_retry = (tsr & 0xf0) >> 4;
+	s8 idx;
+
+	if (pkt_no >= priv->cbTD)
+		return -EINVAL;
+
+	context = priv->apTD[pkt_no];
+
+	if (!context->skb)
+		return -EINVAL;
+
+	info = IEEE80211_SKB_CB(context->skb);
+	idx = info->control.rates[0].idx;
+
+	if (context->fb_option && !(tsr & (TSR_TMO | TSR_RETRYTMO))) {
+		u8 tx_rate;
+		u8 retry = tx_retry;
+
+		rate = ieee80211_get_tx_rate(priv->hw, info);
+		tx_rate = rate->hw_value - RATE_18M;
+
+		if (retry > 4)
+			retry = 4;
+
+		if (context->fb_option == AUTO_FB_0)
+			tx_rate = fallback_rate0[tx_rate][retry];
+		else if (context->fb_option == AUTO_FB_1)
+			tx_rate = fallback_rate1[tx_rate][retry];
+
+		if (info->band == IEEE80211_BAND_5GHZ)
+			idx = tx_rate - RATE_6M;
+		else
+			idx = tx_rate;
+	}
+
+	ieee80211_tx_info_clear_status(info);
+
+	info->status.rates[0].count = tx_retry;
+
+	if (!(tsr & (TSR_TMO | TSR_RETRYTMO))) {
+		info->status.rates[0].idx = idx;
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	ieee80211_tx_status_irqsafe(priv->hw, context->skb);
+
+	context->in_use = false;
+
+	return 0;
+}
+
 void INTnsProcessData(struct vnt_private *priv)
 {
 	struct vnt_interrupt_data *int_data;
@@ -85,33 +157,17 @@ void INTnsProcessData(struct vnt_private *priv)
 
 	int_data = (struct vnt_interrupt_data *)priv->int_buf.data_buf;
 
-	if (int_data->tsr0 & TSR_VALID) {
-		if (int_data->tsr0 & (TSR_TMO | TSR_RETRYTMO))
-			priv->wstats.discard.retries++;
-		else
-			stats->tx_packets++;
-	}
+	if (int_data->tsr0 & TSR_VALID)
+		vnt_int_report_rate(priv, int_data->pkt0, int_data->tsr0);
 
-	if (int_data->tsr1 & TSR_VALID) {
-		if (int_data->tsr1 & (TSR_TMO | TSR_RETRYTMO))
-			priv->wstats.discard.retries++;
-		else
-			stats->tx_packets++;
-	}
+	if (int_data->tsr1 & TSR_VALID)
+		vnt_int_report_rate(priv, int_data->pkt1, int_data->tsr1);
 
-	if (int_data->tsr2 & TSR_VALID) {
-		if (int_data->tsr2 & (TSR_TMO | TSR_RETRYTMO))
-			priv->wstats.discard.retries++;
-		else
-			stats->tx_packets++;
-	}
+	if (int_data->tsr2 & TSR_VALID)
+		vnt_int_report_rate(priv, int_data->pkt2, int_data->tsr2);
 
-	if (int_data->tsr3 & TSR_VALID) {
-		if (int_data->tsr3 & (TSR_TMO | TSR_RETRYTMO))
-			priv->wstats.discard.retries++;
-		else
-			stats->tx_packets++;
-	}
+	if (int_data->tsr3 & TSR_VALID)
+		vnt_int_report_rate(priv, int_data->pkt3, int_data->tsr3);
 
 	if (int_data->isr0 != 0) {
 		if (int_data->isr0 & ISR_BNTX &&
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9d0441f..4cdf29e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -557,6 +557,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 
 		priv->apTD[ii] = tx_context;
 		tx_context->priv = priv;
+		tx_context->pkt_no = ii;
 
 		/* allocate URBs */
 		tx_context->urb = usb_alloc_urb(0, GFP_ATOMIC);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 95b6cf3..264e3c9 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1021,6 +1021,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		}
 	}
 
+	tx_context->fb_option = fb_option;
+
 	duration_id = s_vGenerateTxParameter(tx_context, pkt_type, current_rate,
 				tx_buffer, &mic_hdr, need_mic, frame_size,
 						need_ack, NULL, need_rts);
@@ -1050,8 +1052,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 						IEEE80211_SCTL_SEQ) >> 4;
 
 	tx_buffer->tx_byte_count = cpu_to_le16(tx_bytes);
-	tx_buffer->byPKTNO = (u8)(((current_rate << 4) & 0xf0) |
-		(priv->wSeqCounter & 0xf));
+	tx_buffer->byPKTNO = tx_context->pkt_no;
 	tx_buffer->byType = 0x00;
 
 	tx_bytes += 4;
@@ -1147,8 +1148,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 	count = sizeof(struct vnt_tx_short_buf_head) + skb->len;
 
 	beacon_buffer->tx_byte_count = cpu_to_le16(count);
-	beacon_buffer->byPKTNO = (u8)(((current_rate << 4) & 0xf0) |
-				((priv->wSeqCounter - 1) & 0x000f));
+	beacon_buffer->byPKTNO = context->pkt_no;
 	beacon_buffer->byType = 0x01;
 
 	context->type = CONTEXT_BEACON_PACKET;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a7af4f58..c8b0ed5 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -398,7 +398,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->priv;
-	struct ieee80211_tx_info *info;
 
 	switch (urb->status) {
 	case 0:
@@ -415,25 +414,15 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		break;
 	}
 
-	if (context->skb) {
-		s8 idx;
-
-		info = IEEE80211_SKB_CB(context->skb);
-
-		idx = info->control.rates[0].idx;
-
-		ieee80211_tx_info_clear_status(info);
-		info->status.rates[0].idx = idx;
-		info->status.rates[0].count = 0;
-		if (!urb->status)
-			info->flags |= IEEE80211_TX_STAT_ACK;
-		ieee80211_tx_status_irqsafe(priv->hw, context->skb);
-	}
-
 	if (context->type == CONTEXT_DATA_PACKET)
 		ieee80211_wake_queues(priv->hw);
 
-	context->in_use = false;
+	if (urb->status || context->type == CONTEXT_BEACON_PACKET) {
+		if (context->skb)
+			ieee80211_free_txskb(priv->hw, context->skb);
+
+		context->in_use = false;
+	}
 
 	return;
 }
-- 
1.9.1

