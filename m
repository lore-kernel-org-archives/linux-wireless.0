Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34997 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbbLNXlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 18:41:21 -0500
Received: by lbpu9 with SMTP id u9so110097026lbp.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 15:41:20 -0800 (PST)
From: Anatoly Stepanov <drivengroove@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Anatoly Stepanov <drivengroove@gmail.com>
Subject: [PATCH] staging: rtl8723au: use proper typecast in assignment
Date: Tue, 15 Dec 2015 02:40:58 +0300
Message-Id: <1450136458-2386-1-git-send-email-drivengroove@gmail.com> (sfid-20151215_004130_942169_4B617A24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This resolves the following Sparse warning:
"incorrect type in assignment (different base types)"

Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 1662c03c..fdd9cf1 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -115,7 +115,7 @@ exit:
 
 int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
+	*((__le32 *)param) = cpu_to_le32(*((u32 *)param));
 
 	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
 
-- 
1.9.1

