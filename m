Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:24977 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754715Ab0LTLdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 06:33:43 -0500
Message-ID: <521330.82102.qm@web56807.mail.re3.yahoo.com>
Date: Mon, 20 Dec 2010 03:33:42 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 1/2] compat-wireless: complete rtlwifi/RTL8192CE support
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292625768-17318-3-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

enable driver-select for rtlwifi/rtl8192ce
complete renaming rtlwifi entries for compat-wireless

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -60,6 +60,7 @@ function usage {
 	echo -e "\t${CYAN}intel${NORMAL} < ${PURPLE} iwl3945 iwlagn ipw2100 ipw2200 ${NORMAL}>"
 	echo -e "\t${CYAN}iwlwifi${NORMAL} < ${PURPLE} iwl3945 iwlagn ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
+	echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
 	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
 	
 	echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
@@ -332,6 +333,11 @@ case $1 in
 		disable_staging
 		disable_var_02
 		;;
+	rtlwifi)
+		select_drivers		CONFIG_RTL8192CE CONFIG_RTLWIFI
+		disable_staging
+		disable_bt_usb_ethernet_var
+		;;
 	wl12xx)
 		select_drivers		CONFIG_WL1251 \
 					CONFIG_WL12XX

--- a/Makefile
+++ b/Makefile
@@ -271,6 +271,8 @@ install-scripts:
 	@$(MODPROBE) -l rt73usb
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l rtlwifi
+	@$(MODPROBE) -l rtl8192ce
 	@$(MODPROBE) -l spectrum_cs
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l usb8xxx
@@ -400,6 +402,8 @@ uninstall:
 	@$(MODPROBE) -l rt73usb
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l rtlwifi
+	@$(MODPROBE) -l rtl8192ce
 	@$(MODPROBE) -l spectrum_cs
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l usb8xxx
--- a/README
+++ b/README
@@ -159,6 +159,8 @@ rt61pci
 rt73usb
 rtl8180
 rtl8187
+rtlwifi
+rtl8192ce
 spectrum_cs
 ssb
 wl1251
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -23,7 +23,7 @@ MODULES="$MODULES rt2400pci rt2500pci rt
 MODULES="$MODULES rt2500usb rt73usb"
 MODULES="$MODULES rt2800usb rt2800lib"
 MODULES="$MODULES rt2x00usb rt2x00lib"
-MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES rtl8180 rtl8187 rtl8192ce rtlwifi"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb at76_usb"
 MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -23,7 +23,7 @@ MODULES="$MODULES rt2400pci rt2500pci rt
 MODULES="$MODULES rt2500usb rt73usb"
 MODULES="$MODULES rt2800usb rt2800lib"
 MODULES="$MODULES rt2x00usb rt2x00lib"
-MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES rtl8180 rtl8187 rtl8192ce rtlwifi"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb at76_usb"
 MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"



      
