Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33284 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3KXLwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 06:52:01 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so925330wgh.17
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 03:52:00 -0800 (PST)
Message-ID: <1385293909.4165.3.camel@canaries32-MCP7A> (sfid-20131124_125224_200804_1A39265A)
Subject: [PATCH] staging: vt6656: Remove always 0 variable dwDiagRefCount
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 24 Nov 2013 11:51:49 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove > 0 code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/channel.c |  3 +--
 drivers/staging/vt6656/device.h  |  1 -
 drivers/staging/vt6656/rf.c      |  3 ---
 drivers/staging/vt6656/rxtx.c    | 56 ++++++++++++++--------------------------
 drivers/staging/vt6656/wcmd.c    |  2 --
 5 files changed, 21 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index e430b35..5a4fa0e 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -423,8 +423,7 @@ void CHvInitChannelTable(struct vnt_private *pDevice)
             break;
     }
 
-    if ((pDevice->dwDiagRefCount != 0) ||
-        (pDevice->b11hEable == true)) {
+    if (pDevice->b11hEable == true) {
         if (bMultiBand == true) {
 		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
 			sChannelTbl[ii+1].bValid = true;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index b7a6e14..ec8acbd 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -697,7 +697,6 @@ struct vnt_private {
 	u8 byBBPreEDIndex;
 
 	int bRadioCmd;
-	u32 dwDiagRefCount;
 
 	/* For FOE Tuning */
 	u8  byFOETuning;
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index e545232..1e8f64b 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -740,9 +740,6 @@ int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
 	int ret = true;
 	u8 power = priv->byCCKPwr;
 
-	if (priv->dwDiagRefCount)
-		return true;
-
 	if (channel == 0)
 		return -EINVAL;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5601331..a95575f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -978,28 +978,19 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			bSoftWEP = true; /* WEP 256 */
 	}
 
-    // Get pkt type
-    if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
-        if (pDevice->dwDiagRefCount == 0) {
-            cb802_1_H_len = 8;
-        } else {
-            cb802_1_H_len = 2;
-        }
-    } else {
-        cb802_1_H_len = 0;
-    }
+	/* Get pkt type */
+	if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN)
+		cb802_1_H_len = 8;
+	else
+		cb802_1_H_len = 0;
 
     cbFrameBodySize = uSkbPacketLen - ETH_HLEN + cb802_1_H_len;
 
     //Set packet type
     pTxBufHead->wFIFOCtl |= (u16)(byPktType<<8);
 
-    if (pDevice->dwDiagRefCount != 0) {
-        bNeedACK = false;
-        pTxBufHead->wFIFOCtl = pTxBufHead->wFIFOCtl & (~FIFOCTL_NEEDACK);
-    } else { //if (pDevice->dwDiagRefCount != 0) {
 	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
+			(pDevice->eOPMode == OP_MODE_AP)) {
 		if (is_multicast_ether_addr(psEthHeader->h_dest)) {
 			bNeedACK = false;
 			pTxBufHead->wFIFOCtl =
@@ -1008,13 +999,11 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			bNeedACK = true;
 			pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
 		}
-        }
-        else {
-            // MSDUs in Infra mode always need ACK
-            bNeedACK = true;
-            pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
-        }
-    } //if (pDevice->dwDiagRefCount != 0) {
+	} else {
+		/* MSDUs in Infra mode always need ACK */
+		bNeedACK = true;
+		pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
+	}
 
     pTxBufHead->wTimeStamp = DEFAULT_MSDU_LIFETIME_RES_64us;
 
@@ -1183,24 +1172,19 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         }
     }
 
-    // 802.1H
-    if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
-	if (pDevice->dwDiagRefCount == 0) {
+	/* 802.1H */
+	if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
 		if ((psEthHeader->h_proto == cpu_to_be16(ETH_P_IPX)) ||
-		    (psEthHeader->h_proto == cpu_to_le16(0xF380))) {
+			(psEthHeader->h_proto == cpu_to_le16(0xF380)))
 			memcpy((u8 *) (pbyPayloadHead),
-			       abySNAP_Bridgetunnel, 6);
-            } else {
-                memcpy((u8 *) (pbyPayloadHead), &abySNAP_RFC1042[0], 6);
-            }
-            pbyType = (u8 *) (pbyPayloadHead + 6);
-            memcpy(pbyType, &(psEthHeader->h_proto), sizeof(u16));
-        } else {
-            memcpy((u8 *) (pbyPayloadHead), &(psEthHeader->h_proto), sizeof(u16));
+					abySNAP_Bridgetunnel, 6);
+		else
+			memcpy((u8 *) (pbyPayloadHead), &abySNAP_RFC1042[0], 6);
 
-        }
+		pbyType = (u8 *) (pbyPayloadHead + 6);
 
-    }
+		memcpy(pbyType, &(psEthHeader->h_proto), sizeof(u16));
+	}
 
     if (pPacket != NULL) {
         // Copy the Packet into a tx Buffer
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 2d05ccb..6b95229 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -283,8 +283,6 @@ void vRunCommand(struct work_struct *work)
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
 
-	if (pDevice->dwDiagRefCount != 0)
-		return;
 	if (pDevice->bCmdRunning != true)
 		return;
 
-- 
1.8.4.4

