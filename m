Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63074 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbcGSPeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 11:34:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: don't add include path for rtl8188ee
Date: Tue, 19 Jul 2016 17:33:00 +0200
Message-Id: <20160719153403.2967812-1-arnd@arndb.de> (sfid-20160719_173458_853316_8B8D851E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For rtl8188ee, we pass -Idrivers/net/wireless/rtlwifi/ to gcc,
however that directy no longer exists, so evidently this option
is no longer required here and can be removed to avoid a warning
when building with 'make W=1' or 'gcc -Wmissing-include-dirs'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile
index a85419a37651..676e7de27f27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile
@@ -12,4 +12,4 @@ rtl8188ee-objs :=		\
 
 obj-$(CONFIG_RTL8188EE) += rtl8188ee.o
 
-ccflags-y += -Idrivers/net/wireless/rtlwifi -D__CHECK_ENDIAN__
+ccflags-y += -D__CHECK_ENDIAN__
-- 
2.9.0

