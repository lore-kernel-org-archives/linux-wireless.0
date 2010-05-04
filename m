Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56808.mail.re3.yahoo.com ([66.196.97.82]:37046 "HELO
	web56808.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932345Ab0EDOaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 10:30:11 -0400
Message-ID: <829828.92087.qm@web56808.mail.re3.yahoo.com>
Date: Tue, 4 May 2010 07:30:10 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless, unload rt2800usb 
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Walter Goldens <goldenstranger@yahoo,com>
---

If rt2800usb is already loaded, calling scripts 'unload' and 'wlunload' from compat-wireless will complain of "FATAL: Module rt2xXXXX is in use." This patch will solve the unloading issue.

--- a/scripts/wlunload.sh	2010-05-04 16:51:50.000000000 +0300
+++ b/scripts/wlunload.sh	2010-05-04 16:51:40.000000000 +0300
@@ -17,6 +17,7 @@ MODULES="$MODULES ath9k ath5k ar9170usb 
 MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
+MODULES="$MODULES rt2800usb rt2800lib"
 MODULES="$MODULES rt2x00usb rt2x00lib"
 MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES mwl8k mac80211_hwsim"
--- a/scripts/unload.sh	2010-05-04 16:56:43.000000000 +0300
+++ b/scripts/unload.sh	2010-05-04 16:56:44.000000000 +0300
@@ -17,6 +17,7 @@ MODULES="$MODULES ath9k ath5k ar9170usb 
 MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
+MODULES="$MODULES rt2800usb rt2800lib"
 MODULES="$MODULES rt2x00usb rt2x00lib"
 MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES mwl8k mac80211_hwsim"



      
