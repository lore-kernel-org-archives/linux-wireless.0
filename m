Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33688 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbbFQO4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 10:56:47 -0400
Received: by padev16 with SMTP id ev16so37839387pad.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 07:56:47 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V3] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
Date: Wed, 17 Jun 2015 23:56:37 +0900
Message-Id: <1434552997-3562-1-git-send-email-ap420073@gmail.com> (sfid-20150617_165651_318319_FBBB20DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable "fw_version" is used in the _ResetDigitalProcedure1().
but It is not initialized. so I add init codes for "fw_version" and
"fw_subversion".

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
V3 - Fix sparse warning.
V2 - Moved new statements into location where header is known to exist.

 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 29983bc..0142070 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -240,6 +240,8 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 			  pfwheader->version, pfwheader->signature,
 			  (int)sizeof(struct rtl92c_firmware_header));
 
+		rtlhal->fw_version = le16_to_cpu(pfwheader->version);
+		rtlhal->fw_subversion = pfwheader->subversion;
 		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
 		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
 	}
-- 
2.1.4

