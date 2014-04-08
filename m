Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34425 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbaDHSZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 14:25:46 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so998658eei.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 11:25:45 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@adurom.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com, Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH v2 1/4] rtl8180: change module name in rtl818x_pci
Date: Tue,  8 Apr 2014 20:25:25 +0200
Message-Id: <1396981525-28078-1-git-send-email-andrea.merello@gmail.com> (sfid-20140408_202553_802995_D20D5C67)
In-Reply-To: <877g74i8jv.fsf@purkki.adurom.net>
References: <877g74i8jv.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net> [ original patch ]

rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
however in userspace tools (network manager) it still appares
as "rtl8180".
This might lead the user to think the wrong driver is in use.

This patch changes module name to "rtl818x_pci" that should be
more explanatory.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net> [ original patch ]
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/rtl818x/rtl8180/Makefile
index 08b056d..21005bd 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
+++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
@@ -1,5 +1,5 @@
-rtl8180-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
+rtl818x_pci-objs	:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
 
-obj-$(CONFIG_RTL8180)	+= rtl8180.o
+obj-$(CONFIG_RTL8180)	+= rtl818x_pci.o
 
 ccflags-y += -Idrivers/net/wireless/rtl818x
-- 
1.8.3.2

