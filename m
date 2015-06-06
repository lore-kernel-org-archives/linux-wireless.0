Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36702 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbbFFLCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 07:02:33 -0400
Received: by pabqy3 with SMTP id qy3so65063442pab.3
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 04:02:33 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
Date: Sat,  6 Jun 2015 20:02:17 +0900
Message-Id: <1433588537-27853-1-git-send-email-ap420073@gmail.com> (sfid-20150606_130240_879710_7AAEE1CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable "fw_version" is used in the _ResetDigitalProcedure1().
but It is not initialized. so I add init codes for "fw_version" and
"fw_subversion".

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 29983bc..9b5ce28 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -233,6 +233,8 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *)rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
+	rtlhal->fw_version = pfwheader->version;
+	rtlhal->fw_subversion = pfwheader->subversion;
 
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
-- 
2.1.4

