Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:25420 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753625Ab0JTPMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 11:12:46 -0400
Message-ID: <649275.57677.qm@web56803.mail.re3.yahoo.com>
Date: Wed, 20 Oct 2010 08:12:45 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 3/4] compat-wireless: update unloading scripts for bt
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- update unloading scripts for bt

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -27,14 +27,16 @@ MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb at76_usb"
 MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
-MODULES="$MODULES atl1 atl2 atl1e atl1c"
 # eeprom_93cx6 is used by rt2x00 (rt61pci, rt2500pci, rt2400pci) 
 # and Realtek drivers ( rtl8187, rtl8180)
 MODULES="$MODULES eeprom_93cx6"
 MODULES="$MODULES lib80211_crypt_ccmp lib80211_crypt_tkip lib80211_crypt_wep"
 MODULES="$MODULES mac80211 cfg80211 lib80211"
-MODULES="$MODULES hidp rfcomm bnep l2cap sco btusb bluetooth"
 MODULES="$MODULES compat"
+# Bluetooth modules
+MODULES="$MODULES ath3k bcm203x bluecard_cs bnep bpa10x bt3c_cs btmrvl btmrvl_sdio btsdio"
+MODULES="$MODULES btusb btuart_cs cmtp dtl1_cs hidp hci_vhci hci_uart rfcomm sco bluetooth l2cap"
+MODULES="$MODULES atl1 atl2 atl1e atl1c"
 echo Stoping bluetooth service..
 /etc/init.d/bluetooth stop
 /etc/init.d/bluetooth status
--- a/scripts/btunload.sh
+++ b/scripts/btunload.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
-MODULES="hidp rfcomm bnep l2cap sco btusb bluetooth"
+MODULES="$MODULES ath3k bcm203x bluecard_cs bnep bpa10x bt3c_cs btmrvl btmrvl_sdio btsdio"
+MODULES="$MODULES btusb btuart_cs cmtp dtl1_cs hidp hci_vhci hci_uart rfcomm sco bluetooth l2cap"
 echo Stoping bluetooth service..
 /etc/init.d/bluetooth stop
 /etc/init.d/bluetooth status







      
