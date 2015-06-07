Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33394 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbFGNdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:33:50 -0400
Received: by padev16 with SMTP id ev16so20298981pad.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 06:33:50 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
Date: Sun,  7 Jun 2015 22:33:36 +0900
Message-Id: <1433684016-24340-1-git-send-email-ap420073@gmail.com> (sfid-20150607_153415_948191_D38C197F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable "fw_version" is used in the _ResetDigitalProcedure1().
but It is not initialized. so I add init codes for "fw_version" and
"fw_subversion".

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 29983bc..14b819e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -233,13 +233,14 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *)rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
-
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 "Firmware Version(%d), Signature(%#x),Size(%d)\n",
 			  pfwheader->version, pfwheader->signature,
 			  (int)sizeof(struct rtl92c_firmware_header));
 
+		rtlhal->fw_version = pfwheader->version;
+		rtlhal->fw_subversion = pfwheader->subversion;
 		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
 		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
 	}
-- 
2.1.4

