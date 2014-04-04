Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40030 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaDDQQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 12:16:10 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so1605525wiv.15
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 09:16:09 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 1/4] rtl8180: change module name in rtl818Xpci
Date: Fri,  4 Apr 2014 18:15:42 +0200
Message-Id: <1396628142-14351-1-git-send-email-andrea.merello@gmail.com> (sfid-20140404_181615_172347_9B09D73B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
however in userspace tools (network manager) it still appares
as "rtl8180".
This might lead the user to think the wrong driver is in use.

This patch changes module name to "rtl818Xpci" that should be
more explanatory.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/rtl818x/rtl8180/Makefile
index 08b056d..c74849d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
+++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
@@ -1,5 +1,5 @@
-rtl8180-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
+rtl818Xpci-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
 
-obj-$(CONFIG_RTL8180)	+= rtl8180.o
+obj-$(CONFIG_RTL8180)	+= rtl818Xpci.o
 
 ccflags-y += -Idrivers/net/wireless/rtl818x
-- 
1.8.3.2

