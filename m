Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60509 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGJS4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:50 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so188743wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/16] staging: vt6656: move current_rate setting out of s_vGenerateTxParameter
Date: Thu, 10 Jul 2014 19:56:05 +0100
Message-Id: <1405018577-6832-4-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205654_723103_D3E455C0)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing unneeded pointers

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 57e1dff..2ed045d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -657,11 +657,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	int bNeedACK, bool need_rts)
 {
 	struct vnt_private *pDevice = tx_context->priv;
-	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
 
-	pFifoHead->current_rate = cpu_to_le16(wCurrentRate);
-
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
 			struct vnt_rrv_time_rts *pBuf =
@@ -982,6 +979,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		frame_size += tx_key->icv_len;
 	}
 
+	tx_buffer_head->current_rate = cpu_to_le16(current_rate);
+
 	/* legacy rates TODO use ieee80211_tx_rate */
 	if (current_rate >= RATE_18M && ieee80211_is_data(hdr->frame_control)) {
 		if (priv->byAutoFBCtrl == AUTO_FB_0) {
-- 
1.9.1

