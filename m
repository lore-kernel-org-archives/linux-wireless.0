Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43920 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1K3Q6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 11:58:17 -0500
Date: Wed, 30 Nov 2011 10:58:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192c: Do not log firmware load message unless
 actually done
Message-ID: <4ed660a6.+gxelIqK7GtmnQBK%Larry.Finger@lwfinger.net> (sfid-20111130_175821_049041_9C6CD70D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A previous commit fixed a problem whereby the rtl8192c driver loaded the
firmware from disk many times; however, the log message was not moved.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 3.3 material.

Larry
---
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -262,10 +262,10 @@ int rtl92c_download_fw(struct ieee80211_
 	u32 fwsize;
 	enum version_8192c version = rtlhal->version;
 
-	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	if (!rtlhal->pfirmware)
 		return 1;
 
+	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *) rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
