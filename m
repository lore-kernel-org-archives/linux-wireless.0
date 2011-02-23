Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1BWQO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:14:28 -0500
Date: Wed, 23 Feb 2011 10:14:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 2/5] rtlwifi: rtl8192cu: Fix build error for missing
 vmalloc header
Message-ID: <4d653265.IJvenqE1BIoid1bp%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Willy Tarreau <w@1wt.eu>
Date: Sun, 20 Feb 2011 11:35:48 +0100
Subject: rtl8192cu: fix build error (vmalloc/vfree undefined)

On the ARM system, a build fails due to missing include.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -40,7 +40,7 @@
 #include "trx.h"
 #include "led.h"
 #include "hw.h"
-
+#include <linux/vmalloc.h>
 
 MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
 MODULE_AUTHOR("Ziv Huang	<ziv_huang@realtek.com>");
