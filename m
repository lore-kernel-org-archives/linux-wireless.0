Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56968 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1BWQOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:14:24 -0500
Date: Wed, 23 Feb 2011 10:14:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 1/5] rtlwifi: Fix build when RTL8192CU is selected, but RTL8192CE is not
Message-ID: <4d653260.FQ995fSRTBGWdIFh%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Willy Tarreau <w@1wt.eu>
Date: Sun, 20 Feb 2011 11:35:26 +0100
Subject: rtlwifi: Fix build when RTL8192CU is selected, but RTL8192CE is not

The wireless Makefile does not build rtlwifi for rtl8192cu unless
rtl8192ce is selected.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.39 material.

Larry
---

 drivers/net/wireless/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: wireless-testing/drivers/net/wireless/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Makefile
+++ wireless-testing/drivers/net/wireless/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
 obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
-obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
+obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
