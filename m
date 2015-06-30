Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34619 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbF3VzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 17:55:03 -0400
Received: by wgqq4 with SMTP id q4so20986248wgq.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 14:55:01 -0700 (PDT)
Date: Tue, 30 Jun 2015 23:54:59 +0200
From: Michel von Czettritz <michel.von.czettritz@gmail.com>
To: gregkh@linux.com
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] staging: rtl8723au: function no longer discards return
 value
Message-ID: <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com> (sfid-20150630_235506_771870_23BAE255)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1435700714.git.michel.von.czettritz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of FillH2CCmd in rtl8723a_set_rssi_cmd and
rtl8723a_set_raid_cmd is never checked. Both functions always return
_SUCCESS.

Both functions now return the return value of FillH2CCmd.

Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index a5e6726..72924a78 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -118,9 +118,7 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
 	__le32 param_le;
 	param_le = cpu_to_le32(*(param));
 
-	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&param_le);
-
-	return _SUCCESS;
+	return FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&param_le);
 }
 
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
@@ -133,9 +131,7 @@ int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
 	memcpy(buf, &mask_le, 4);
 	buf[4]  = arg;
 
-	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
-
-	return _SUCCESS;
+	return FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
 }
 
 /* bitmap[0:27] = tx_rate_bitmap */
-- 
2.4.5

