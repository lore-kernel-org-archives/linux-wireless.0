Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33868 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbbLaMhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 07:37:33 -0500
From: meleodr@gmail.com
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Daniil Leshchev <meleodr@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>
Subject: [PATCH] staging: rtl8723au: use %pM and %ph formatting
Date: Thu, 31 Dec 2015 15:36:42 +0300
Message-Id: <1451565407-15039-1-git-send-email-meleodr@gmail.com> (sfid-20151231_133740_125479_30B06ACA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniil Leshchev <meleodr@gmail.com>

use %pM and %ph specifiers instead of placing each byte on stack.
(staging/rtl8723au/TODO)

Signed-off-by: Daniil Leshchev <meleodr@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c          | 32 +++++-----------------
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    | 24 ++++------------
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  6 ++--
 3 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 404b618..81abe50 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -361,33 +361,19 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 				int i;
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 "*(pframemic-8)-*(pframemic-1) =0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-					 *(pframemic - 8), *(pframemic - 7),
-					 *(pframemic - 6), *(pframemic - 5),
-					 *(pframemic - 4), *(pframemic - 3),
-					 *(pframemic - 2), *(pframemic - 1));
+					 "*(pframemic-8)-*(pframemic-1) =%*phC\n",
+					 8, pframemic - 8);
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
-					 "*(pframemic-16)-*(pframemic-9) =0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-					 *(pframemic - 16), *(pframemic - 15),
-					 *(pframemic - 14), *(pframemic - 13),
-					 *(pframemic - 12), *(pframemic - 11),
-					 *(pframemic - 10), *(pframemic - 9));
+					 "*(pframemic-16)-*(pframemic-9) =%*phC\n",
+					 8, pframemic - 16);
 
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
 					 "====== demp packet (len =%d) ======\n",
 					 precvframe->pkt->len);
 				for (i = 0; i < precvframe->pkt->len; i = i + 8) {
 					RT_TRACE(_module_rtl871x_recv_c_,
-						 _drv_err_,
-						 "0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-						 *(precvframe->pkt->data+i),
-						 *(precvframe->pkt->data+i+1),
-						 *(precvframe->pkt->data+i+2),
-						 *(precvframe->pkt->data+i+3),
-						 *(precvframe->pkt->data+i+4),
-						 *(precvframe->pkt->data+i+5),
-						 *(precvframe->pkt->data+i+6),
-						 *(precvframe->pkt->data+i+7));
+						 _drv_err_, "%*phC\n",
+						 8, precvframe->pkt->data + i);
 				}
 				RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
 					 "====== demp packet end [len =%d]======\n",
@@ -1402,11 +1388,7 @@ static void dump_rx_pkt(struct sk_buff *skb, u16 type, int level)
 		DBG_8723A("#############################\n");
 
 		for (i = 0; i < 64; i = i + 8)
-			DBG_8723A("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X:\n",
-				  *(ptr + i), *(ptr + i + 1), *(ptr + i + 2),
-				  *(ptr + i + 3), *(ptr + i + 4),
-				  *(ptr + i + 5), *(ptr + i + 6),
-				  *(ptr + i + 7));
+			DBG_8723A("%*phC:\n", 8, ptr + i);
 		DBG_8723A("#############################\n");
 	}
 }
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index d5c48a5..d46d1c7 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -1454,21 +1454,11 @@ bthci_StartBeaconAndConnect(
 	}
 
 	if (pBTInfo->BtAsocEntry[CurrentAssocNum].AMPRole == AMP_BTAP_CREATOR) {
-		snprintf((char *)pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsidBuf, 32, "AMP-%02x-%02x-%02x-%02x-%02x-%02x",
-		padapter->eeprompriv.mac_addr[0],
-		padapter->eeprompriv.mac_addr[1],
-		padapter->eeprompriv.mac_addr[2],
-		padapter->eeprompriv.mac_addr[3],
-		padapter->eeprompriv.mac_addr[4],
-		padapter->eeprompriv.mac_addr[5]);
+		snprintf((char *)pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsidBuf, 32,
+			 "AMP-%pMF", padapter->eeprompriv.mac_addr);
 	} else if (pBTInfo->BtAsocEntry[CurrentAssocNum].AMPRole == AMP_BTAP_JOINER) {
-		snprintf((char *)pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsidBuf, 32, "AMP-%02x-%02x-%02x-%02x-%02x-%02x",
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[0],
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[1],
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[2],
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[3],
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[4],
-		pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr[5]);
+		snprintf((char *)pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsidBuf, 32,
+			 "AMP-%pMF", pBTInfo->BtAsocEntry[CurrentAssocNum].BTRemoteMACAddr);
 	}
 
 	FillOctetString(pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsid, pBTInfo->BtAsocEntry[CurrentAssocNum].BTSsidBuf, 21);
@@ -9475,10 +9465,8 @@ static void BTDM_Display8723ABtCoexInfo(struct rtw_adapter *padapter)
 			psTdmaCase = pHalData->bt_coexist.halCoex8723.btdm1Ant.curPsTdma;
 		else
 			psTdmaCase = pHalData->bt_coexist.halCoex8723.btdm2Ant.curPsTdma;
-		snprintf(btCoexDbgBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %02x %02x %02x %02x %02x case-%d", "PS TDMA(0x3a)", \
-			pHalData->bt_coexist.fw3aVal[0], pHalData->bt_coexist.fw3aVal[1],
-			pHalData->bt_coexist.fw3aVal[2], pHalData->bt_coexist.fw3aVal[3],
-			pHalData->bt_coexist.fw3aVal[4], psTdmaCase);
+		snprintf(btCoexDbgBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %*ph case-%d",
+			 "PS TDMA(0x3a)", 5, pHalData->bt_coexist.fw3aVal, psTdmaCase);
 		DCMD_Printf(btCoexDbgBuf);
 
 		snprintf(btCoexDbgBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d ", "Decrease Bt Power", \
diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
index 9926b07..3c2d03e 100644
--- a/drivers/staging/rtl8723au/hal/usb_halinit.c
+++ b/drivers/staging/rtl8723au/hal/usb_halinit.c
@@ -1021,10 +1021,8 @@ static void Hal_EfuseParseMACAddr_8723AU(struct rtw_adapter *padapter,
 	}
 
 	RT_TRACE(_module_hci_hal_init_c_, _drv_notice_,
-		 "Hal_EfuseParseMACAddr_8723AU: Permanent Address =%02x:%02x:%02x:%02x:%02x:%02x\n",
-		 pEEPROM->mac_addr[0], pEEPROM->mac_addr[1],
-		 pEEPROM->mac_addr[2], pEEPROM->mac_addr[3],
-		 pEEPROM->mac_addr[4], pEEPROM->mac_addr[5]);
+		 "Hal_EfuseParseMACAddr_8723AU: Permanent Address =%pM\n",
+		 pEEPROM->mac_addr);
 }
 
 static void readAdapterInfo(struct rtw_adapter *padapter)
-- 
1.9.1

