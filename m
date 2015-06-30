Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:32857 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbF3VxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 17:53:18 -0400
Received: by wiwl6 with SMTP id l6so146107177wiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 14:53:16 -0700 (PDT)
Date: Tue, 30 Jun 2015 23:53:13 +0200
From: Michel von Czettritz <michel.von.czettritz@gmail.com>
To: gregkh@linux.com
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] staging: rtl8723au: adjust function param, u8* to u32*
Message-ID: <236a04514b84d62cdb60189766601c4dd2621b69.1435700714.git.michel.von.czettritz@gmail.com> (sfid-20150630_235322_632674_54ADDC63)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1435700714.git.michel.von.czettritz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If u8 *param, in the function rtl8723a_set_rssi_cmd, is only 3 Byte long
the 4th Byte of cpu_to_le32 will be written in unallocated memory.

Change the function variable to u32*, so the problem can not
occur.

rtl8723a_set_rssi_cmd currently is only called in hal/odm.c and is
called with u32* as param. rtl8723a_set_rssi_cmd is never used as a
function pointer, nor does it seem to conform to any API.

Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm.c              | 2 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 6 +++---
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index f354f5e..5cbf8b6 100644
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
index 9733aa6..1003365 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -113,11 +113,11 @@ exit:
 	return ret;
 }
 
-int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
+int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
+	*((u32 *)param) = cpu_to_le32(*(param));
 
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
+	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)param);
 
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
2.4.5

