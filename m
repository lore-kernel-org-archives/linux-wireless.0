Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0LPEzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 23:55:37 -0500
Date: Wed, 15 Dec 2010 22:55:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192ce: Fix build on powerpc
Message-ID: <4d099bc6.A/mmZxu+nz0FW6tP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After merge of the rtl8192ce driver, a powerpc build fails with:

drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c: In function 'rtl92c_init_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:76: error: implicit declaration of function 'vmalloc'
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:76: warning: cast to pointer from integer of different size
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c: In function 'rtl92c_deinit_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:91: error: implicit declaration of function 'vfree'

The problem is fixed by explicitly including the appropriate header.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Sorry about this. Too bad the implicit headers are not the same on all platforms.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/vmalloc.h>
+
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
