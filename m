Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39217 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaEWRB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:29 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so5114058wgg.22
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/20] staging: vt6656: camel case clean up CARDvCalculateOFDMRParameter
Date: Fri, 23 May 2014 18:00:15 +0100
Message-Id: <1400864419-8327-16-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_388398_933BE9C5)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
wRate -> rate
byBBType -> bb_type
pbyTxRate -> tx_rate
pbyRsvTime -> rsv_time

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 185 +++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index b8f35e7..1674a6f 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -190,114 +190,95 @@ static u16 swGetOFDMControlRate(struct vnt_private *pDevice, u16 wRateIdx)
  * Description: Calculate TxRate and RsvTime fields for RSPINF in OFDM mode.
  *
  * Parameters:
- *  In:
- *      wRate           - Tx Rate
- *      byPktType       - Tx Packet type
- *  Out:
- *      pbyTxRate       - pointer to RSPINF TxRate field
- *      pbyRsvTime      - pointer to RSPINF RsvTime field
+ * In:
+ *	rate	- Tx Rate
+ *	bb_type	- Tx Packet type
+ * Out:
+ *	tx_rate	- pointer to RSPINF TxRate field
+ *	rsv_time- pointer to RSPINF RsvTime field
  *
  * Return Value: none
  *
  */
-static void
-CARDvCalculateOFDMRParameter (
-      u16 wRate,
-      u8 byBBType,
-     u8 * pbyTxRate,
-     u8 * pbyRsvTime
-    )
+void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
+					u8 *tx_rate, u8 *rsv_time)
 {
-    switch (wRate) {
-    case RATE_6M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9B;
-            *pbyRsvTime = 24;
-        }
-        else {
-            *pbyTxRate = 0x8B;
-            *pbyRsvTime = 30;
-        }
-        break;
-
-    case RATE_9M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9F;
-            *pbyRsvTime = 16;
-        }
-        else {
-            *pbyTxRate = 0x8F;
-            *pbyRsvTime = 22;
-        }
-        break;
-
-   case RATE_12M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9A;
-            *pbyRsvTime = 12;
-        }
-        else {
-            *pbyTxRate = 0x8A;
-            *pbyRsvTime = 18;
-        }
-        break;
-
-   case RATE_18M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9E;
-            *pbyRsvTime = 8;
-        }
-        else {
-            *pbyTxRate = 0x8E;
-            *pbyRsvTime = 14;
-        }
-        break;
-
-    case RATE_36M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9D;
-            *pbyRsvTime = 4;
-        }
-        else {
-            *pbyTxRate = 0x8D;
-            *pbyRsvTime = 10;
-        }
-        break;
-
-    case RATE_48M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x98;
-            *pbyRsvTime = 4;
-        }
-        else {
-            *pbyTxRate = 0x88;
-            *pbyRsvTime = 10;
-        }
-        break;
-
-    case RATE_54M :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x9C;
-            *pbyRsvTime = 4;
-        }
-        else {
-            *pbyTxRate = 0x8C;
-            *pbyRsvTime = 10;
-        }
-        break;
 
-    case RATE_24M :
-    default :
-        if (byBBType == BB_TYPE_11A) {//5GHZ
-            *pbyTxRate = 0x99;
-            *pbyRsvTime = 8;
-        }
-        else {
-            *pbyTxRate = 0x89;
-            *pbyRsvTime = 14;
-        }
-        break;
-    }
+	switch (rate) {
+	case RATE_6M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9b;
+			*rsv_time = 24;
+		} else {
+			*tx_rate = 0x8b;
+			*rsv_time = 30;
+		}
+			break;
+	case RATE_9M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9f;
+			*rsv_time = 16;
+		} else {
+			*tx_rate = 0x8f;
+			*rsv_time = 22;
+		}
+		break;
+	case RATE_12M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9a;
+			*rsv_time = 12;
+		} else {
+			*tx_rate = 0x8a;
+			*rsv_time = 18;
+		}
+		break;
+	case RATE_18M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9e;
+			*rsv_time = 8;
+		} else {
+			*tx_rate = 0x8e;
+			*rsv_time = 14;
+		}
+		break;
+	case RATE_36M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9d;
+			*rsv_time = 4;
+		} else {
+			*tx_rate = 0x8d;
+			*rsv_time = 10;
+		}
+		break;
+	case RATE_48M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x98;
+			*rsv_time = 4;
+		} else {
+			*tx_rate = 0x88;
+		*rsv_time = 10;
+		}
+		break;
+	case RATE_54M:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x9c;
+			*rsv_time = 4;
+		} else {
+			*tx_rate = 0x8c;
+			*rsv_time = 10;
+		}
+		break;
+	case RATE_24M:
+	default:
+		if (bb_type == BB_TYPE_11A) {
+			*tx_rate = 0x99;
+			*rsv_time = 8;
+		} else {
+			*tx_rate = 0x89;
+			*rsv_time = 14;
+		}
+		break;
+	}
 }
 
 /*
-- 
1.9.1

