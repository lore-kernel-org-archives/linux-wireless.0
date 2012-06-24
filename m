Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2FXToj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 15:44:39 -0400
Date: Sun, 24 Jun 2012 14:44:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Fix double inclusion of header pci.h
Message-ID: <4fe76e24.dx8iOM/sDC8goV8Q%Larry.Finger@lwfinger.net> (sfid-20120624_214526_372060_42C9A0F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command "make includecheck" yields the following for the rtlwifi tree:

/home/finger/linux-2.6/drivers/net/wireless/rtlwifi/rtl8192se/sw.c: ../pci.h is included more than once.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch has low priority.

Larry
---

Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -29,7 +29,6 @@
 
 #include "../wifi.h"
 #include "../core.h"
-#include "../pci.h"
 #include "../base.h"
 #include "../pci.h"
 #include "reg.h"
