Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57333 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaKXSe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 13:34:57 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so13107003wgg.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 10:34:56 -0800 (PST)
From: Andreas Ruprecht <rupran@einserver.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH 2/2] net: wireless: rtlwifi: rtl8192ee: Fix compilation of the driver
Date: Mon, 24 Nov 2014 19:34:32 +0100
Message-Id: <1416854072-14794-3-git-send-email-rupran@einserver.de> (sfid-20141124_193519_651298_9417F76F)
In-Reply-To: <1416854072-14794-1-git-send-email-rupran@einserver.de>
References: <1416854072-14794-1-git-send-email-rupran@einserver.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the Makefile for this driver, the wrong Kconfig option is used
to trigger the compilation of the object file. This leads to the
driver only being included into the kernel when both CONFIG_RTL8821AE
and CONFIG_RTL8192AE are set to "y".

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
index 6bd46a9..0315eed 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
@@ -11,6 +11,6 @@ rtl8192ee-objs :=		\
 		trx.o		\
 
 
-obj-$(CONFIG_RTL8821AE) += rtl8192ee.o
+obj-$(CONFIG_RTL8192EE) += rtl8192ee.o
 
 ccflags-y += -D__CHECK_ENDIAN__
-- 
1.9.1

