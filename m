Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36025 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbHGDLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 23:11:16 -0400
Received: by pacrr5 with SMTP id rr5so41743046pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 20:11:16 -0700 (PDT)
From: AceLan Kao <acelan.kao@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8723be: disable FW control power save
Date: Fri,  7 Aug 2015 11:11:13 +0800
Message-Id: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com> (sfid-20150807_051120_214367_BEC43593)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are many rtl8723be wifi unstable issues that wifi lost connection
after working for a while. The wifi signal and status it's show connected
also ifconfig have IP but can not connect to internet and filed to ping 8.8.8.8
The problem should result from the power saving controlled by firmware.
I'd suggest to disable it by default and re-enable it after firmware fixes
this issue.

BTW. the firmware I tested from linux-firmware git tree is
rtlwifi/rtl8723befw.bin
be225d6 Update firmware for rtl8723be

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
index 1017f02..02fe2cc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
@@ -266,7 +266,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.sw_crypto = false,
 	.inactiveps = true,
 	.swctrl_lps = false,
-	.fwctrl_lps = true,
+	.fwctrl_lps = false,
 };
 
 static struct rtl_hal_cfg rtl8723be_hal_cfg = {
-- 
2.1.4

