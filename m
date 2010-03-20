Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:40474 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0CTPAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 11:00:07 -0400
Received: by ewy8 with SMTP id 8so257871ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 08:00:05 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 20 Mar 2010 15:59:45 +0100
Message-ID: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
Subject: Compat wireless with kernel 2.6.33
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows compat wireless to compile with a kernel >= 2.6.33

Index: compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh
===================================================================
--- compat-wireless-2010-03-19.orig/scripts/gen-compat-autoconf.sh	2010-03-20
15:26:22.604720545 +0100
+++ compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh	2010-03-20
15:27:49.212236531 +0100
@@ -145,7 +145,11 @@
 kernel_version_req $OLDEST_KERNEL_SUPPORTED

 # Handle core kernel wireless depenencies here
+echo '#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)'
+define_config_req CONFIG_CFG80211_WEXT
+echo '#else'
 define_config_req CONFIG_WIRELESS_EXT
+echo '#endif'

 # For each CONFIG_FOO=x option
 for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do


-- 
Matteo Croce
OpenWrt developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) ------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
