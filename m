Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1HBTyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 15:54:15 -0400
Date: Tue, 02 Aug 2011 14:54:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: geert@linux-m68k.org, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix build errors on sh4 architecture
Message-ID: <4e3855e4.8qPfeuR18XtAq7Vs%Larry.Finger@lwfinger.net> (sfid-20110802_215433_856310_0F2D3972)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtlwifi is built for the sh4 architecture, build errors of the following
type occur. An explicit reference to <linux/io.h> should fix these. I have not
setup the cross-build environment, thus this patch is untested on that platform.
It does not cause any problems on i386 or x86_64.

    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:290: error: implicit declaration of function 'outl': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:295: error: implicit declaration of function 'outb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:300: error: implicit declaration of function 'inb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:305: error: implicit declaration of function 'inw': 4 errors in 2 logs

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---

John,

I'm not sure where this goes. I guess that 3.2 would be OK, unless someone
actually tries to build it on sh4. The only time I have seen the errors is
in Geert's listing of errors and warnings.

Larry
---

Index: linux-2.6/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/pci.h
+++ linux-2.6/drivers/net/wireless/rtlwifi/pci.h
@@ -31,6 +31,7 @@
 #define __RTL_PCI_H__
 
 #include <linux/pci.h>
+#include <linux/io.h>
 /*
 1: MSDU packet queue,
 2: Rx Command Queue
