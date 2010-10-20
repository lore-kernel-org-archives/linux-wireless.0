Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56801.mail.re3.yahoo.com ([66.196.97.75]:34632 "HELO
	web56801.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751129Ab0JTPOA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 11:14:00 -0400
Message-ID: <55285.71229.qm@web56801.mail.re3.yahoo.com>
Date: Wed, 20 Oct 2010 08:13:58 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 4/4] compat-wireless: remove obsolete load scripts
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- delete obsolete load scripts

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/load.sh
+++ /dev/null
@@ -1,26 +0,0 @@
-#!/bin/bash
-MODULES="ipw2100 ipw2200 libertas_cs usb8xxx"
-MODULES="$MODULES p54pci p54usb"
-MODULES="$MODULES adm8211 zd1211rw"
-MODULES="$MODULES rtl8180 rtl8187"
-MODULES="$MODULES p54pci p54usb"
-MODULES="$MODULES iwl3945 iwlagn"
-MODULES="$MODULES ath ar9170usb"
-MODULES="$MODULES rtl8180 rtl8187"
-MODULES="$MODULES rt2400pci rt2500pci rt61pci"
-MODULES="$MODULES rt2500usb rt73usb"
-MODULES="$MODULES rndis_wlan at76_usb"
-MODULES="$MODULES mwl8k mac80211_hwsim"
-MODULES="$MODULES at76c50x_usb"
-MODULES="$MODULES bluetooth btusb l2cap sco hidp rfcomm bnep"
-for i in $MODULES; do
-    echo Loading $i...
-    modprobe $i
-done
-# For ath5k we must be sure to unload MadWifi first
-athload ath5k
-# For b43 we must make sure to unload bcm43xx first
-b43load b43
-echo Starting bluetooth service..
-/etc/init.d/bluetooth start
-/etc/init.d/bluetooth status
--- a/scripts/wlload.sh
+++ /dev/null
@@ -1,22 +0,0 @@
-#!/bin/bash
-MODULES="ipw2100 ipw2200 libertas_cs usb8xxx"
-MODULES="$MODULES p54pci p54usb"
-MODULES="$MODULES adm8211 zd1211rw"
-MODULES="$MODULES rtl8180 rtl8187"
-MODULES="$MODULES p54pci p54usb"
-MODULES="$MODULES iwl3945 iwlagn"
-MODULES="$MODULES ath ar9170usb"
-MODULES="$MODULES rtl8180 rtl8187"
-MODULES="$MODULES rt2400pci rt2500pci rt61pci"
-MODULES="$MODULES rt2500usb rt73usb"
-MODULES="$MODULES rndis_wlan at76_usb"
-MODULES="$MODULES mwl8k mac80211_hwsim"
-MODULES="$MODULES at76c50x_usb"
-for i in $MODULES; do
-    echo Loading $i...
-    modprobe $i
-done
-# For ath5k we must be sure to unload MadWifi first
-athload ath5k
-# For b43 we must make sure to unload bcm43xx first
-b43load b43
--- a/scripts/btload.sh
+++ /dev/null
@@ -1,10 +0,0 @@
-#!/bin/bash
-MODULES="bluetooth btusb l2cap sco hidp rfcomm bnep"
-for i in $MODULES; do
-    echo Loading $i...
-    modprobe $i
-done
-echo Starting bluetooth service..
-/etc/init.d/bluetooth start
-/etc/init.d/bluetooth status
-




      
