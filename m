Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35970 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbJJT2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 15:28:51 -0400
Received: by qgx61 with SMTP id 61so94315586qgx.3
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2015 12:28:50 -0700 (PDT)
From: Jacob Kiefer <jtk54@cornell.edu>
Cc: Jacob Kiefer <jtk54@cornell.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	linux-wireless@vger.kernel.org (open list:STAGING - REALTEK RTL8723U
	WIRELESS DRIVER),
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2 v3] drivers: staging: rtl8723au: Changed rssi_cmd to little-endian param
Date: Sat, 10 Oct 2015 15:28:16 -0400
Message-Id: <1444505324-2924-1-git-send-email-jtk54@cornell.edu> (sfid-20151010_212948_295083_BF950626)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jacob Kiefer <jtk54@cornell.edu>

Changed rssi_cmd interface to accept le32 param instead of
unnecessary u8 * conversion. Updated existing calls to rssi_cmd.
This patch pushes responsibility to caller to convert to
le32. This cleans up the code quite a bit.
Also removed magic numbers.

This patch fixes the following sparse error:

  CHECK   drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
...
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:  \
  got restricted __le32 [usertype] <noident>
...

Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
---
In v3, opted to change the interface rather than just the internal
code to clear the sparse errors and make the code more sane.
---
 drivers/staging/rtl8723au/hal/odm.c              | 3 ++-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 7 +++----
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index 6b9dbef..c7f45c7 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -1274,7 +1274,8 @@ static void odm_RSSIMonitorCheck(struct dm_odm_t *pDM_Odm)

 	for (i = 0; i < sta_cnt; i++) {
 		if (PWDB_rssi[i] != (0))
-			rtl8723a_set_rssi_cmd(Adapter, (u8 *)&PWDB_rssi[i]);
+			rtl8723a_set_rssi_cmd(Adapter,
+					cpu_to_le32(PWDB_rssi[i]));
 	}

 	pdmpriv->EntryMaxUndecoratedSmoothedPWDB = MaxDB;
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 9733aa6..97d23c3 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -25,6 +25,7 @@
 #define RTL92C_MAX_CMD_LEN		5
 #define MESSAGE_BOX_SIZE		4
 #define EX_MESSAGE_BOX_SIZE		2
+#define RSSI_CMD_LEN			3

 static u8 _is_fw_read_cmd_down(struct rtw_adapter *padapter, u8 msgbox_num)
 {
@@ -113,11 +114,9 @@ exit:
 	return ret;
 }

-int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
+int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, __le32 param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
-
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
+	FillH2CCmd(padapter, RSSI_SETTING_EID, RSSI_CMD_LEN, (u8 *)&param);

 	return _SUCCESS;
 }
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
index 014c02e..e281543 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
@@ -149,7 +149,7 @@ void rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(struct rtw_adapter *padapter);
 #else
 #define rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(padapter) do {} while(0)
 #endif
-int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param);
+int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, __le32 param);
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg);
 void rtl8723a_add_rateatid(struct rtw_adapter *padapter, u32 bitmap, u8 arg, u8 rssi_level);

--
1.8.3.2

