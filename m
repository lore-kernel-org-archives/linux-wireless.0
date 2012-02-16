Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2BPSOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 13:14:50 -0500
Received: by ghrr11 with SMTP id r11so1432346ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 10:14:49 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH] rtlwifi: Fix breakage in debug functions when built as a module
Date: Thu, 16 Feb 2012 12:14:36 -0600
Message-Id: <1329416076-12706-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120216_191454_820408_7A0B3963)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 481b9606, it has not been possible to invoke debugging
with any rtlwifi driver built as a module.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>
---

John,

The bad commit is not in mainline..

Larry
---
---
 drivers/net/wireless/rtlwifi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index 44b9c0a..cefac6a 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -50,7 +50,7 @@ config RTLWIFI
 	default m
 
 config RTLWIFI_DEBUG
-	tristate "Additional debugging output"
+	bool "Additional debugging output"
 	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
 	default y
 
-- 
1.7.7

