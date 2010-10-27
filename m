Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:40113 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751737Ab0J0Lk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 07:40:29 -0400
Message-ID: <96256.84364.qm@web56803.mail.re3.yahoo.com>
Date: Wed, 27 Oct 2010 04:40:27 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: update README file
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/README
+++ b/README
@@ -3,8 +3,8 @@ Linux Wireless compatibility package
 =====================================
 
 This is a Linux wireless compatibility package which provides the latest
-Linux wireless subsystem enhancements for kernels 2.6.25 and above.
-It is technically possible to support kernels < 2.6.25 but more
+Linux wireless subsystem enhancements for kernels 2.6.24 and above.
+It is technically possible to support kernels < 2.6.24 but more
 work is required for that.
 It also provides Linux bluetooth subsystem enhancements for kernels 2.6.27 and above.
 
@@ -26,7 +26,7 @@ Where to get the latest
 -----------------------
 
 This package lets you build your own 'latest', all you need is a local git
-repository. This way is documented in the Developers section of this document.
+repository. The process is documented in the Developers section of this document.
 However since not many users are expected to keep a local git repository we 
 provide daily snapshots of this package + the wireless and bluetooth subsystem
 code. You can find the latest snapshot at:
@@ -44,7 +44,7 @@ There are two different versions of this
  * Version based on latest linux-next.git tree named compat-wireless-YYYY-MM-DD.tar.bz2
  * Version based on linux-2.6-stable.git tree named compat-wireless-2.6.CC.DD.tar.bz2
 
-Both versions should work for every kernel > 2.6.25. The differences are the
+Both versions should work for every kernel > 2.6.24. The differences are the
 code they are containing. The version based on linux-next.git contains the
 wireless and bluetooth subsystem out of linux-next.git and the stable version
 the wireless subsystem out of the corresponding linux stable version.
@@ -57,12 +57,13 @@ helper script:
 
 ./scripts/driver-select
 
-Run that script to see more information.
+Run that script to see more information. 
+Not all drivers are currently enabled via driver-select.
 
 Building, and installing
 ------------------------
 
-Build: build the latest linux wireless subsystem
+Build: compile the latest linux wireless subsystem
 
 	make
 
@@ -82,10 +83,12 @@ distribution's supported drivers.
 Load:
 
 Reboot unless you know what you are doing.
+(Usually modprobe 'driver-name' is the way to go)
 
 
 Bluetooth modules can be separately compiled and installed using below commands
-
+Bluetooth drivers are also available via ./scripts/driver-select
+ 
 Build:
 	make bt
 
@@ -95,41 +98,71 @@ Install:
 Uninstall:
 	sudo make btuninstall
 
-Load:
-	sudo make btload
-
 Unload:
 	sudo make btunload
 
+Load:
+	modprobe driver-name. If unsure, reboot.
+
 Drivers
 -------
 
-This is the list of drivers this package provides. It adds
+This is the list of drivers the package currently provides. It adds
 all new drivers or drivers which keep being updated which you might
 be interested in.
 
-Driver
+Drivers list:
+
 adm8211
+ar9170usb
+at76c50x-usb
 ath5k
-ath9h
-ar9170
+ath6kl
+ath9k
+ath9k_htc
 b43
 b43legacy
-iwl3945
-iwlagn
+b44
+carl9170
+brcm80211
 ipw2100
 ipw2200
-libertas_cs (Libertas)
-ub8xxx      (Libertas)
+iwl3945
+iwlagn
+iwlcore
+iwmc3200wifi
+libertas
+libertas_cs
+libertas_sdio
+libertas_spi
+libertas_tf
+libertas_tf_usb
+libipw
+mwl8k
+orinoco_cs
+orinoco_nortel
+orinoco_pci
+orinoco_plx
+orinoco_tld
+orinoco_usb
+orinoco
+p54common
 p54pci
+p54spi
 p54usb
-rt2400pci (rt2x00)
-rt2500pci (rt2x00)
-rt2500usb (rt2x00)
-rt61pci	  (rt2x00)
-rt73usb	  (rt2x00)
-rtl8180	(Realtek)
-rtl8187	(Realtek)
+rt2400pci
+rt2500pci
+rt2500usb
+rt2800pci
+rt2800usb
+rt61pci
+rt73usb
+rtl8180
+rtl8187
+spectrum_cs
+ssb
+wl1251
+wl1271
 zd1211rw
 
 This package also provides more drivers which may be documented here
@@ -141,19 +174,40 @@ http://wireless.kernel.org/en/users/Down
 Non-wireless drivers
 --------------------
 
+Atheros Ethernet drivers:
+
+atl1
+atl1c
+atl1e
+atl2
+
 To support b43 ssb is also provided, and since ssb is also provided
 we provide b44 (the ethernet driver).
 
 The new rfkill drivers also provided and backported.
 
 Bluetooth drivers:
+
+ath3k           
+bcm203x
+bluecard_cs
 bluetooth
-btusb
-hci_uart
+bnep
+bpa10x
+bt3c_cs
+btmrvl
+btmrvl_sdio
 btsdio
+btusb
 btuart_cs
-bluecard_cs
-bfusb
+cmtp
+dtl1_cs
+hidp
+hci_vhci
+hci_uart
+l2cap
+rfcomm
+sco
 
 Firmware:
 ---------
@@ -198,7 +252,7 @@ If you've found a bug please report it t
 
 linux-wireless@vger.kernel.org
 
-Report the bug because you are working with the latest and greatest.
+Report the bug if you are working with the latest and greatest.
 If your bug is compatibility-related then we should still try to fix
 it within the compat.[ch] work.
 
@@ -357,5 +411,5 @@ http://wireless.kernel.org/en/developers
 TODO
 -----
  * Dialog (make menuconfig) option for this package
- * Compatibility work for 2.6.18 --> 2.6.25
+ * Compatibility work for 2.6.18 --> 2.6.24
 


      
