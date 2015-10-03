Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34843 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbJCAgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 20:36:44 -0400
Received: by qgt47 with SMTP id 47so108822461qgt.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 17:36:44 -0700 (PDT)
From: Jacob Kiefer <jtk54@cornell.edu>
Cc: Jacob Kiefer <jtk54@cornell.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org (open list:STAGING - REALTEK RTL8723U
	WIRELESS DRIVER),
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: rtl8723au: Fix Sparse errors in rtl8723a_cmd.c
Date: Fri,  2 Oct 2015 20:36:28 -0400
Message-Id: <1443832594-29663-1-git-send-email-jtk54@cornell.edu> (sfid-20151003_023700_869779_BC3D3379)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jacob Kiefer <jtk54@cornell.edu>

This patch fixes the following sparse errors:


  CHECK   drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
...
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:    expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:    got restricted __le32 [usertype] <noident>
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14:    expected unsigned int [unsigned] [usertype] mask
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14:    got restricted __le32 [usertype] <noident>
  CC [M]  drivers/staging/rtl8723au/hal/rtl8723a_cmd.o

Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 9733aa6..111a24d 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -115,9 +115,11 @@ exit:
 
 int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
+	__le32 leparam;
 
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
+	leparam = cpu_to_le32(*((u32 *)param));
+
+	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&leparam);
 
 	return _SUCCESS;
 }
@@ -125,10 +127,11 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
 {
 	u8 buf[5];
+	__le32 lemask;
 
 	memset(buf, 0, 5);
-	mask = cpu_to_le32(mask);
-	memcpy(buf, &mask, 4);
+	lemask = cpu_to_le32(mask);
+	memcpy(buf, (u32 *)&lemask, 4);
 	buf[4]  = arg;
 
 	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
-- 
1.8.3.2

