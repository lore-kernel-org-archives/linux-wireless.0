Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43056 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVJCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:33 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so2223582wes.12
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/10] staging : vt6656: rxtx struct vnt_beacon_buffer Replace wTxByteCount
Date: Sat, 22 Mar 2014 09:01:29 +0000
Message-Id: <1395478892-3419-7-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100237_646352_3793F2A9)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with tx_byte_count with base type __le16

Provide endian correction in csBeacon_xmit of cbReqCount

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c17c3da..4bb13a7 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1697,7 +1697,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
     cbReqCount = cbHeaderSize + WLAN_HDR_ADDR3_LEN + cbFrameBodySize;
 
-    pTX_Buffer->wTxByteCount = (u16)cbReqCount;
+    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)cbReqCount);
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x01;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 0233761..779c672 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -241,7 +241,7 @@ struct vnt_tx_short_buf_head {
 struct vnt_beacon_buffer {
 	u8 byType;
 	u8 byPKTNO;
-	u16 wTxByteCount;
+	__le16 tx_byte_count;
 	struct vnt_tx_short_buf_head short_head;
 	struct ieee80211_hdr hdr;
 } __packed;
-- 
1.9.0

