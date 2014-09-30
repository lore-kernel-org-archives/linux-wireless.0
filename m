Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61574 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaI3QSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 12:18:33 -0400
Received: by mail-ob0-f171.google.com with SMTP id wp4so2690146obc.2
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2014 09:18:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, troy_tan@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] rtlwifi: Fix randconfig build error with next-20140930
Date: Tue, 30 Sep 2014 11:18:21 -0500
Message-Id: <1412093901-11220-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140930_181837_334877_170179F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configuration randconfig-1412075201 gets an error because driver rtl8821ae
depends on driver btcoexist, but Kconfig does not select it.

Reported-by: Jim Davis <jim.epost@gmail.com>
Cc: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Driver rtl8192ee will get a similar error. I will send the patch for it shortly.

Larry
---
 drivers/net/wireless/rtlwifi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index 08fde95..552742e 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -97,6 +97,7 @@ config RTL8821AE
 	depends on PCI
 	select RTLWIFI
 	select RTLWIFI_PCI
+	select RTLBTCOEXIST
 	---help---
 	This is the driver for Realtek RTL8i821AE/RTL8812AE 802.11av PCIe
 	wireless network adapters.
@@ -146,7 +147,7 @@ config RTL8723_COMMON
 
 config RTLBTCOEXIST
 	tristate
-	depends on RTL8723AE || RTL8723BE
+	depends on RTL8723AE || RTL8723BE || RTL8821AE
 	default y
 
 endif
-- 
1.8.4.5

