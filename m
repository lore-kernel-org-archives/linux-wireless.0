Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34274 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbJFEct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 00:32:49 -0400
Received: by qkbi190 with SMTP id i190so58061118qkb.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 21:32:49 -0700 (PDT)
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
Subject: [PATCH v2] staging: rtl8723au: Fix sparse errors in rtl8723a_cmd.c
Date: Tue,  6 Oct 2015 00:32:28 -0400
Message-Id: <1444105958-32087-1-git-send-email-jtk54@cornell.edu> (sfid-20151006_063341_255029_324DA9C0)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jacob Kiefer <jtk54@cornell.edu>

This patch fixes the following sparse errors:
  CHECK   drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
...
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:  \
  got restricted __le32 [usertype] <noident>
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  expected unsigned int [unsigned] [usertype] mask
drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: \
  got restricted __le32 [usertype] <noident>
...

Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
---
Took a fresh look at the code. In v2, verified that the converted
buffer logic is the same as previous: i.e. an 8-bit pointer to
what really is a 32-bit little endian buffer is passed to
FillH2CCmd and used in a memcpy within. Likewise, a 32-bit little endian
mask is used in memcpy. This patch makes the code cleaner with
no confusing reuse of buffers for both little- and (possibly)
big-endian data and clears the sparse errors.
As for __le32 typing, le32 is not available in this scope,
since it is defined under fs/ntfs/types.h.
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 9733aa6..cceda59 100644
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
+	memcpy(buf, &lemask, 4);
 	buf[4]  = arg;

 	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
--
1.8.3.2

