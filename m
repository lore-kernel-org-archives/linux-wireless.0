Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37850 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2HISBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:01:51 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so457945wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:01:51 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 03/13] compat-wireless: List everything vertically without concatenating
Date: Thu,  9 Aug 2012 21:01:22 +0300
Message-Id: <1344535292-4451-4-git-send-email-ozancag@gmail.com> (sfid-20120809_200156_849467_076A09B0)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

List everything vertically as it is much more readable. Also don't
concat strings but list them sequentially in one variable.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 116 ++++++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 49 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index df82ea3..6d7ca54 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -266,14 +266,32 @@ else
 fi
 
 # Now define what files to copy from $GIT_URL
-INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h a2mp.h"
-NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
-
-INCLUDE_LINUX="ieee80211.h nl80211.h"
-INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
-INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
-INCLUDE_LINUX="$INCLUDE_LINUX wl12xx.h"
-INCLUDE_LINUX="$INCLUDE_LINUX rndis.h"
+INCLUDE_NET_BT="hci_core.h
+		l2cap.h
+		bluetooth.h
+		rfcomm.h
+		hci.h
+		hci_mon.h
+		mgmt.h
+		sco.h
+		smp.h
+		a2mp.h"
+
+# Bluetooth related directories
+NET_BT_DIRS="bluetooth
+	     bluetooth/bnep
+	     bluetooth/cmtp
+	     bluetooth/rfcomm
+	     bluetooth/hidp"
+
+# Required headers from include/linux
+INCLUDE_LINUX="ieee80211.h
+	       nl80211.h
+	       pci_ids.h
+	       eeprom_93cx6.h
+	       ath9k_platform.h
+	       wl12xx.h
+	       rndis.h"
 
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
@@ -291,47 +309,47 @@ INCLUDE_NET="cfg80211.h
 NET_DIRS="wireless mac80211 rfkill"
 
 # WLAN drivers that have their own directory
-DRIVERS_WLAN="drivers/bcma"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ath"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ath/carl9170"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ath/ath5k"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ath/ath6kl"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ath/ath9k"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/b43"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/b43legacy"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211/brcmfmac"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211/brcmsmac"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211/brcmsmac/phy"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211/brcmutil"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/brcm80211/include"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/iwlegacy"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/iwlwifi"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/iwlwifi/pcie"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/iwlwifi/dvm"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rt2x00"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/zd1211rw"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/libertas"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/p54"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtl818x"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtl818x/rtl8180"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtl818x/rtl8187"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi/rtl8192c"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi/rtl8192ce"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi/rtl8192cu"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi/rtl8192se"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/rtlwifi/rtl8192de"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/libertas_tf"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ipw2x00"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ti"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ti/wl12xx"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ti/wl1251"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ti/wlcore"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/ti/wl18xx"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/orinoco"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/net/wireless/mwifiex"
-DRIVERS_WLAN="$DRIVERS_WLAN drivers/ssb"
+DRIVERS_WLAN="drivers/bcma
+	      drivers/net/wireless/ath
+	      drivers/net/wireless/ath/carl9170
+	      drivers/net/wireless/ath/ath5k
+	      drivers/net/wireless/ath/ath6kl
+	      drivers/net/wireless/ath/ath9k
+	      drivers/net/wireless/b43
+	      drivers/net/wireless/b43legacy
+	      drivers/net/wireless/brcm80211
+	      drivers/net/wireless/brcm80211/brcmfmac
+	      drivers/net/wireless/brcm80211/brcmsmac
+	      drivers/net/wireless/brcm80211/brcmsmac/phy
+	      drivers/net/wireless/brcm80211/brcmutil
+	      drivers/net/wireless/brcm80211/include
+	      drivers/net/wireless/iwlegacy
+	      drivers/net/wireless/iwlwifi
+	      drivers/net/wireless/iwlwifi/pcie
+	      drivers/net/wireless/iwlwifi/dvm
+	      drivers/net/wireless/rt2x00
+	      drivers/net/wireless/zd1211rw
+	      drivers/net/wireless/libertas
+	      drivers/net/wireless/p54
+	      drivers/net/wireless/rtl818x
+	      drivers/net/wireless/rtl818x/rtl8180
+	      drivers/net/wireless/rtl818x/rtl8187
+	      drivers/net/wireless/rtlwifi
+	      drivers/net/wireless/rtlwifi/rtl8192c
+	      drivers/net/wireless/rtlwifi/rtl8192ce
+	      drivers/net/wireless/rtlwifi/rtl8192cu
+	      drivers/net/wireless/rtlwifi/rtl8192se
+	      drivers/net/wireless/rtlwifi/rtl8192de
+	      drivers/net/wireless/libertas_tf
+	      drivers/net/wireless/ipw2x00
+	      drivers/net/wireless/ti
+	      drivers/net/wireless/ti/wl12xx
+	      drivers/net/wireless/ti/wl1251
+	      drivers/net/wireless/ti/wlcore
+	      drivers/net/wireless/ti/wl18xx
+	      drivers/net/wireless/orinoco
+	      drivers/net/wireless/mwifiex
+	      drivers/ssb"
 
 # WLAN drivers not having dedicated directories
 DRIVERS_WLAN_FILES="adm8211.c
-- 
1.7.11.2

