Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from limerock02.mail.cornell.edu ([128.84.13.242]:45954 "EHLO
	limerock02.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbbJJSvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 14:51:06 -0400
Date: Sat, 10 Oct 2015 14:50:44 -0400
From: Jacob Kiefer <jtk54@cornell.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: rtl8723au: Fix sparse errors in
 rtl8723a_cmd.c
Message-ID: <20151010185043.GA20030@jtk54-Q550LF> (sfid-20151010_205110_588641_FFC0A199)
References: <1444105958-32087-1-git-send-email-jtk54@cornell.edu>
 <20151006231134.GV22011@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
In-Reply-To: <20151006231134.GV22011@ZenIV.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

This patch set fixes the same sparse errors as v2, taking Al's
advice into consideration and changing the interfaces to little-endian.

Jake

--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-rtl8723au-Changed-rssi_cmd-to-little-endian-param.patch"

>From 8c66f23a08417c59400a60c2dcf5a519795e401f Mon Sep 17 00:00:00 2001
From: Jacob Kiefer <jtk54@cornell.edu>
Date: Sat, 10 Oct 2015 14:33:02 -0400
Subject: [PATCH 1/2 v3] drivers: staging: rtl8723au: Changed rssi_cmd to little-endian param

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


--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-rtl8723au-Changed-raid_cmd-to-little-endian-mask.patch"

>From 27441199cc7c0a22c7eeebf74000571b1bcde26c Mon Sep 17 00:00:00 2001
From: Jacob Kiefer <jtk54@cornell.edu>
Date: Sat, 10 Oct 2015 14:34:29 -0400
Subject: [PATCH 2/2 v3] drivers: staging: rtl8723au: Changed raid_cmd to little-endian mask

Changed raid_cmd interface to accept le32 mask instead of
u32 and converting internally. Updated existing calls to raid_cmd.
This patch pushes responsibility to the caller to convert
the mask to le32 and opts for a temp local struct instead of
memset/memcpy. This cleans up the code considerably.
Also removed magic numbers.

This patch fixes the following sparse error:
  CHECK   drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
...
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  expected unsigned int [unsigned] [usertype] mask
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  got restricted __le32 [usertype] <noident>
...

Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
---
In v3, opted to change the interface rather than just the internal
code, and removed ugly memcpy/memset. This clears sparse errors
and makes the code more sane.
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c |  2 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c        | 17 ++++++++---------
 drivers/staging/rtl8723au/hal/usb_halinit.c         |  2 +-
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h    |  2 +-
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index cf15f80..2b369b6 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -5870,7 +5870,7 @@ btdm_1AntUpdateHalRAMask(struct rtw_adapter *padapter, u32 mac_id, u32 filter)
 		("[BTCoex], Update FW RAID entry, MASK = 0x%08x, "
 		 "arg = 0x%02x\n", mask, arg));
 
-	rtl8723a_set_raid_cmd(padapter, mask, arg);
+	rtl8723a_set_raid_cmd(padapter, cpu_to_le32(mask), arg);
 
 	psta->init_rate = init_rate;
 	pdmpriv->INIDATA_RATE[mac_id] = init_rate;
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 97d23c3..0e0d3f1 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -26,6 +26,7 @@
 #define MESSAGE_BOX_SIZE		4
 #define EX_MESSAGE_BOX_SIZE		2
 #define RSSI_CMD_LEN			3
+#define RAID_CMD_LEN			5
 
 static u8 _is_fw_read_cmd_down(struct rtw_adapter *padapter, u8 msgbox_num)
 {
@@ -121,16 +122,14 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, __le32 param)
 	return _SUCCESS;
 }
 
-int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
+int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, __le32 mask, u8 arg)
 {
-	u8 buf[5];
+	struct macid_config_eid {__le32 mask; u8 arg; } buf = {
+		.mask = mask,
+		.arg = arg
+	};
 
-	memset(buf, 0, 5);
-	mask = cpu_to_le32(mask);
-	memcpy(buf, &mask, 4);
-	buf[4]  = arg;
-
-	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
+	FillH2CCmd(padapter, MACID_CONFIG_EID, RAID_CMD_LEN, (u8 *)&buf);
 
 	return _SUCCESS;
 }
@@ -152,7 +151,7 @@ void rtl8723a_add_rateatid(struct rtw_adapter *pAdapter, u32 bitmap, u8 arg, u8
 
 	bitmap |= raid;
 
-	rtl8723a_set_raid_cmd(pAdapter, bitmap, arg);
+	rtl8723a_set_raid_cmd(pAdapter, cpu_to_le32(bitmap), arg);
 }
 
 void rtl8723a_set_FwPwrMode_cmd(struct rtw_adapter *padapter, u8 Mode)
diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
index 68156a1..fb6f900 100644
--- a/drivers/staging/rtl8723au/hal/usb_halinit.c
+++ b/drivers/staging/rtl8723au/hal/usb_halinit.c
@@ -1262,7 +1262,7 @@ void rtl8723a_update_ramask(struct rtw_adapter *padapter,
 
 	DBG_8723A("update raid entry, mask = 0x%x, arg = 0x%x\n", mask, arg);
 
-	rtl8723a_set_raid_cmd(padapter, mask, arg);
+	rtl8723a_set_raid_cmd(padapter, cpu_to_le32(mask), arg);
 
 	/* set ra_id */
 	psta->raid = raid;
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
index e281543..a7f7921 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
@@ -150,7 +150,7 @@ void rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(struct rtw_adapter *padapter);
 #define rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(padapter) do {} while(0)
 #endif
 int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, __le32 param);
-int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg);
+int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, __le32 mask, u8 arg);
 void rtl8723a_add_rateatid(struct rtw_adapter *padapter, u32 bitmap, u8 arg, u8 rssi_level);
 
 int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen, u8 *pCmdBuffer);
-- 
1.8.3.2


--17pEHd4RhPHOinZp--
