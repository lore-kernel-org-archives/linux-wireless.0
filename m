Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761055Ab3DDBgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 21:36:09 -0400
Date: Wed, 03 Apr 2013 20:36:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8188ee: Fix linker warnings
Message-ID: <515cd906.MrKlPKWUlskAMZEB%Larry.Finger@lwfinger.net> (sfid-20130404_033614_278049_B3B1814C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building rtl8188ee yields warnings such as the following:

x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input file unused because linking not done

The only potential cause is an extraneous space in the make file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
@@ -13,4 +13,4 @@ rtl8188ee-objs :=		\
 
 obj-$(CONFIG_RTL8188EE) += rtl8188ee.o
 
-ccflags-y += -I drivers/net/wireless/rtlwifi -D__CHECK_ENDIAN__
+ccflags-y += -Idrivers/net/wireless/rtlwifi -D__CHECK_ENDIAN__
