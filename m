Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36711 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbbF3VyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 17:54:06 -0400
Received: by wguu7 with SMTP id u7so20924674wgu.3
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 14:54:04 -0700 (PDT)
Date: Tue, 30 Jun 2015 23:54:02 +0200
From: Michel von Czettritz <michel.von.czettritz@gmail.com>
To: gregkh@linux.com
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] staging: rtl8723au: fix "incorrect type in assignment"
Message-ID: <d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com> (sfid-20150630_235409_848753_B88E91A1)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1435700714.git.michel.von.czettritz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writing the output of cpu_to_le32 to an u32 or *(u32*) is an implicit
cast and results in an sparse warning.

Since param and mask won't be changed, the implicit cast can be avoided
by creating local variables.

Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 1003365..a5e6726 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -115,9 +115,10 @@ exit:
 
 int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*(param));
+	__le32 param_le;
+	param_le = cpu_to_le32(*(param));
 
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)param);
+	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&param_le);
 
 	return _SUCCESS;
 }
@@ -125,10 +126,11 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
 {
 	u8 buf[5];
+	__le32 mask_le;
 
 	memset(buf, 0, 5);
-	mask = cpu_to_le32(mask);
-	memcpy(buf, &mask, 4);
+	mask_le = cpu_to_le32(mask);
+	memcpy(buf, &mask_le, 4);
 	buf[4]  = arg;
 
 	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
-- 
2.4.5

