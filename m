Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:61277 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVJC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:29 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so2221669wes.31
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/10] staging: vt6656: rxtx Replace struct vnt_tx_fifo_head wTimeStamp
Date: Sat, 22 Mar 2014 09:01:27 +0000
Message-Id: <1395478892-3419-5-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100233_337415_BFF3E0FD)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with time_stamp with base type __le16

In s_bPacketToWirelessUsb endian correct DEFAULT_MSDU_LIFETIME_RES_64us

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 +++---
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9706e18..1624efb 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1008,7 +1008,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
 	}
 
-    pTxBufHead->wTimeStamp = DEFAULT_MSDU_LIFETIME_RES_64us;
+    pTxBufHead->time_stamp = cpu_to_le16(DEFAULT_MSDU_LIFETIME_RES_64us);
 
     //Set FRAGCTL_MACHDCNT
 	cbMACHdLen = WLAN_HDR_ADDR3_LEN;
@@ -1431,7 +1431,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     }
 
     pTxBufHead->wFIFOCtl |= FIFOCTL_TMOEN;
-    pTxBufHead->wTimeStamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
+    pTxBufHead->time_stamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
 
     if (is_multicast_ether_addr(pPacket->p80211Header->sA3.abyAddr1)) {
         bNeedACK = false;
@@ -1800,7 +1800,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     }
 
     pTxBufHead->wFIFOCtl |= FIFOCTL_TMOEN;
-    pTxBufHead->wTimeStamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
+    pTxBufHead->time_stamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
 
     if (is_multicast_ether_addr(p80211Header->sA3.abyAddr1)) {
         bNeedACK = false;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 6d6539d..d7e4273 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -217,7 +217,7 @@ union vnt_tx_head {
 struct vnt_tx_fifo_head {
 	u32 adwTxKey[4];
 	u16 wFIFOCtl;
-	u16 wTimeStamp;
+	__le16 time_stamp;
 	u16 wFragCtl;
 	u16 wReserved;
 } __packed;
-- 
1.9.0

