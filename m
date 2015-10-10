Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33949 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbbJJT3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 15:29:00 -0400
Received: by qgez77 with SMTP id z77so94741716qge.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2015 12:28:59 -0700 (PDT)
From: Jacob Kiefer <jtk54@cornell.edu>
Cc: Jacob Kiefer <jtk54@cornell.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Anjana Sasindran <anjanasasindran123@gmail.com>,
	Joe Perches <joe@perches.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	linux-wireless@vger.kernel.org (open list:STAGING - REALTEK RTL8723U
	WIRELESS DRIVER),
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2 v3] drivers: staging: rtl8723au: Changed raid_cmd to little-endian mask
Date: Sat, 10 Oct 2015 15:28:17 -0400
Message-Id: <1444505324-2924-2-git-send-email-jtk54@cornell.edu> (sfid-20151010_212929_330506_5B374A05)
In-Reply-To: <1444505324-2924-1-git-send-email-jtk54@cornell.edu>
References: <1444505324-2924-1-git-send-email-jtk54@cornell.edu>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jacob Kiefer <jtk54@cornell.edu>

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

