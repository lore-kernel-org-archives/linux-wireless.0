Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33965 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933485AbdEKR6E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 13:58:04 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 4/4] staging: rtl8192e: GetTs Fix invalid TID 7 warning.
Date: Thu, 11 May 2017 18:57:46 +0100
Message-Id: <20170511175746.12378-4-tvboxspy@gmail.com> (sfid-20170511_195815_800455_A7F98B01)
In-Reply-To: <20170511175746.12378-1-tvboxspy@gmail.com>
References: <20170511175746.12378-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TID 7 is a valid value for QoS IEEE 802.11e.

The switch statement that follows states 7 is valid.

Remove function IsACValid and use the default case to filter
invalid TIDs.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/staging/rtl8192e/rtl819x_TSProc.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
index 48bbd9e8a52f..dcc4eb691889 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -306,11 +306,6 @@ static void MakeTSEntry(struct ts_common_info *pTsCommonInfo, u8 *Addr,
 	pTsCommonInfo->TClasNum = TCLAS_Num;
 }
 
-static bool IsACValid(unsigned int tid)
-{
-	return tid < 7;
-}
-
 bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
 	   u8 *Addr, u8 TID, enum tr_select TxRxSelect, bool bAddNewTs)
 {
@@ -328,12 +323,6 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
 	if (ieee->current_network.qos_data.supported == 0) {
 		UP = 0;
 	} else {
-		if (!IsACValid(TID)) {
-			netdev_warn(ieee->dev, "%s(): TID(%d) is not valid\n",
-				    __func__, TID);
-			return false;
-		}
-
 		switch (TID) {
 		case 0:
 		case 3:
@@ -351,6 +340,10 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
 		case 7:
 			UP = 7;
 			break;
+		default:
+			netdev_warn(ieee->dev, "%s(): TID(%d) is not valid\n",
+				    __func__, TID);
+			return false;
 		}
 	}
 
-- 
2.11.0
