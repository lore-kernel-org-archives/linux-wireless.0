Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61309 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaGKAJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:35 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so1244195wib.9
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/13] staging: vt6656: rxtx remove unneeded comments
Date: Fri, 11 Jul 2014 01:08:30 +0100
Message-Id: <1405037311-3666-12-git-send-email-tvboxspy@gmail.com> (sfid-20140711_022952_608532_3B97F6FE)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 733c86e..35edf41 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -26,18 +26,11 @@
  *
  * Functions:
  *      vnt_generate_tx_parameter - Generate tx dma required parameter.
- *      csBeacon_xmit - beacon tx function
- *      csMgmt_xmit - management tx function
  *      vnt_get_duration_le - get tx data required duration
- *      s_uFillDataHead- fulfill tx data duration header
  *      vnt_get_rtscts_duration_le- get rtx/cts required duration
  *      vnt_get_rtscts_rsvtime_le- get rts/cts reserved time
  *      vnt_get_rsvtime- get frame reserved time
  *      vnt_fill_cts_head- fulfill CTS ctl header
- *      s_vFillFragParameter- Set fragment ctl parameter.
- *      s_vFillRTSHead- fulfill RTS ctl header
- *      vDMA0_tx_80211- tx 802.11 frame via dma0
- *      vGenerateFIFOHeader- Generate tx FIFO ctl header
  *
  * Revision History:
  *
@@ -118,11 +111,6 @@ static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
 							[rate % MAX_RATE]);
 }
 
-/*byPktType : PK_TYPE_11A     0
-             PK_TYPE_11B     1
-             PK_TYPE_11GB    2
-             PK_TYPE_11GA    3
-*/
 static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 	u32 frame_length, u16 rate, int need_ack)
 {
@@ -151,7 +139,6 @@ static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 		frame_length, rate, need_ack));
 }
 
-//byFreqType: 0=>5GHZ 1=>2.4GHZ
 static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate)
 {
@@ -195,7 +182,6 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 	return cpu_to_le16((u16)rrv_time);
 }
 
-//byFreqType 0: 5GHz, 1:2.4Ghz
 static __le16 vnt_get_duration_le(struct vnt_private *piv,
 					u8 pkt_type, int need_ack)
 {
@@ -215,7 +201,6 @@ static __le16 vnt_get_duration_le(struct vnt_private *piv,
 	return 0;
 }
 
-//byFreqType: 0=>5GHZ 1=>2.4GHZ
 static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	u32 frame_length, u8 pkt_type, u16 rate, int need_ack)
 {
@@ -658,28 +643,6 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 				&head->data_head_ab, frame_size, need_ack);
 }
 
-/*+
- *
- * Description:
- *      Generate FIFO control for MAC & Baseband controller
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to adpater
- *      pTxDataHead     - Transmit Data Buffer
- *      pTxBufHead      - pTxBufHead
- *      pvRrvTime        - pvRrvTime
- *      pvRTS            - RTS Buffer
- *      pCTS            - CTS Buffer
- *      cbFrameSize     - Transmit Data Length (Hdr+Payload+FCS)
- *      bNeedACK        - If need ACK
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
-
 static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 	u8 pkt_type, u16 current_rate, struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
-- 
1.9.1

