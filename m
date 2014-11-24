Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53770 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaKXSez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 13:34:55 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so6663457wid.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 10:34:54 -0800 (PST)
From: Andreas Ruprecht <rupran@einserver.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH 1/2] net: wireless: rtlwifi: Do not always include drivers in obj-m
Date: Mon, 24 Nov 2014 19:34:31 +0100
Message-Id: <1416854072-14794-2-git-send-email-rupran@einserver.de> (sfid-20141124_193702_051466_83C14FF5)
In-Reply-To: <1416854072-14794-1-git-send-email-rupran@einserver.de>
References: <1416854072-14794-1-git-send-email-rupran@einserver.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In four of the rtlwifi drivers, the Makefile contains superfluous
statements indicating the compilation of the driver as an LKM
regardless of the corresponding Kconfig option.

If the corresponding option is set to 'y', the build system will then
see the object file in obj-m and obj-y, which leads to a compilation
as a built-in only. Even though this leads to the desired behavior,
the unconditional appearance in obj-m is confusing for someone reading
the Makefile.

This patch removes the superfluous Makefile statements.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile | 3 ---
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile | 3 ---
 drivers/net/wireless/rtlwifi/rtl8723be/Makefile | 3 ---
 drivers/net/wireless/rtlwifi/rtl8821ae/Makefile | 3 ---
 4 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
index 11952b9..6bd46a9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
@@ -1,6 +1,3 @@
-obj-m := rtl8192ee.o
-
-
 rtl8192ee-objs :=		\
 		dm.o		\
 		fw.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile b/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
index 9c34a85..6220672 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
@@ -1,6 +1,3 @@
-obj-m := rtl8723ae.o
-
-
 rtl8723ae-objs :=		\
 		dm.o		\
 		fw.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/Makefile b/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
index 59e416a..a77c341 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
@@ -1,6 +1,3 @@
-obj-m := rtl8723be.o
-
-
 rtl8723be-objs :=		\
 		dm.o		\
 		fw.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/Makefile b/drivers/net/wireless/rtlwifi/rtl8821ae/Makefile
index 87ad604..f7a26f7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/Makefile
@@ -1,6 +1,3 @@
-obj-m := rtl8821ae.o
-
-
 rtl8821ae-objs :=		\
 		dm.o		\
 		fw.o		\
-- 
1.9.1

