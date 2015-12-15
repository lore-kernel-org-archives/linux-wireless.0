Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31516 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbbLOUf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 15:35:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NZF00D602IZ4J60@mailout4.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 15 Dec 2015 20:35:23 +0000 (GMT)
From: drivengroove@gmail.com
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Anatoly Stepanov <drivengroove@gmail.com>
Subject: [PATCH] staging: rtl8723au: change parameter type in
 rtl8723a_set_rssi_cmd declaration
Date: Tue, 15 Dec 2015 23:34:24 +0300
Message-id: <1450211664-1699-1-git-send-email-drivengroove@gmail.com> (sfid-20151215_213536_166016_3E4315E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anatoly Stepanov <drivengroove@gmail.com>

Previosly the function had the following prototype:
int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)

My suggestion here is to modify the prototype this way:
int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)

We can do this based on the following considerations:
1. rtl8723a_set_rssi_cmd is used only with 32-bit "param" values
2. There's no point in using "__u8 *param" until we pass param length

Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm.c              | 2 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 6 +++---
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index 6b9dbef..6fed13e 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -1274,7 +1274,7 @@ static void odm_RSSIMonitorCheck(struct dm_odm_t *pDM_Odm)
 
 	for (i = 0; i < sta_cnt; i++) {
 		if (PWDB_rssi[i] != (0))
-			rtl8723a_set_rssi_cmd(Adapter, (u8 *)&PWDB_rssi[i]);
+			rtl8723a_set_rssi_cmd(Adapter, &PWDB_rssi[i]);
 	}
 
 	pdmpriv->EntryMaxUndecoratedSmoothedPWDB = MaxDB;
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 1662c03c..e899d05 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -113,11 +113,11 @@ exit:
 	return ret;
 }
 
-int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
+int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
+	__le32 cmd = cpu_to_le32(*param);
 
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
+	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (void *)&cmd);
 
 	return _SUCCESS;
 }
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
index 014c02e..e39e38a 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
@@ -149,7 +149,7 @@ void rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(struct rtw_adapter *padapter);
 #else
 #define rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(padapter) do {} while(0)
 #endif
-int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param);
+int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param);
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg);
 void rtl8723a_add_rateatid(struct rtw_adapter *padapter, u32 bitmap, u8 arg, u8 rssi_level);
 
-- 
1.9.1

