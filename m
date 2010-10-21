Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56808.mail.re3.yahoo.com ([66.196.97.82]:37662 "HELO
	web56808.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755878Ab0JUGdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 02:33:12 -0400
Message-ID: <481433.72209.qm@web56808.mail.re3.yahoo.com>
Date: Wed, 20 Oct 2010 23:33:11 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 1/4 v2] compat-wireless: update bluetooth in Makefile
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update bluetooth in Makefile

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/Makefile
+++ b/Makefile
@@ -93,19 +93,32 @@ bt-install-modules: bt
 	@echo
 	@echo "Currently detected bluetooth subsystem modules:"
 	@echo
-	@$(MODPROBE) -l sco
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l ath3k       
+	@$(MODPROBE) -l bcm203x
+	@$(MODPROBE) -l bluecard_cs
+	@$(MODPROBE) -l bluetooth
 	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l bpa10x
+	@$(MODPROBE) -l bt3c_cs
+	@$(MODPROBE) -l btmrvl
+	@$(MODPROBE) -l btmrvl_sdio
+	@$(MODPROBE) -l btsdio
 	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l bluetooth
+	@$(MODPROBE) -l btuart_cs
+	@$(MODPROBE) -l	cmtp
+	@$(MODPROBE) -l	dtl1_cs
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l	hci_vhci
+	@$(MODPROBE) -l	hci_uart
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l sco
 	@echo
 	@echo Now run:
 	@echo
 	@echo sudo make btunload:
 	@echo
-	@echo And the load the needed bluetooth modules. If unsure reboot.
+	@echo And then load the needed bluetooth modules. If unsure reboot.
 	@echo
 
 btuninstall:
@@ -118,14 +131,26 @@ btuninstall:
 	@echo
 	@echo "Your old bluetooth subsystem modules were left intact:"
 	@echo
-	@$(MODPROBE) -l sco
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l ath3k       
+	@$(MODPROBE) -l bcm203x
+	@$(MODPROBE) -l bluecard_cs
+	@$(MODPROBE) -l bluetooth
 	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l bpa10x
+	@$(MODPROBE) -l bt3c_cs
+	@$(MODPROBE) -l btmrvl
+	@$(MODPROBE) -l btmrvl_sdio
+	@$(MODPROBE) -l btsdio
 	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l bluetooth
-	@
+	@$(MODPROBE) -l btuart_cs
+	@$(MODPROBE) -l	cmtp
+	@$(MODPROBE) -l	dtl1_cs
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l	hci_vhci
+	@$(MODPROBE) -l	hci_uart
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l sco
 	@echo
 
 btclean:
@@ -263,22 +288,35 @@ install-scripts:
 	@echo
 	@echo "Currently detected bluetooth subsystem modules:"
 	@echo
-	@$(MODPROBE) -l sco
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l ath3k           
+	@$(MODPROBE) -l bcm203x
+	@$(MODPROBE) -l bluecard_cs
+	@$(MODPROBE) -l bluetooth
 	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l bpa10x
+	@$(MODPROBE) -l bt3c_cs
+	@$(MODPROBE) -l btmrvl
+	@$(MODPROBE) -l btmrvl_sdio
+	@$(MODPROBE) -l btsdio
 	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l bluetooth
+	@$(MODPROBE) -l btuart_cs
+	@$(MODPROBE) -l	cmtp
+	@$(MODPROBE) -l	dtl1_cs
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l	hci_vhci
+	@$(MODPROBE) -l	hci_uart
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l sco
 	@echo 
 	@echo Now run:
 	@echo 
-	@echo sudo make unload to unload both wireless and bluetooth modules
+	@echo sudo make unload to unload all: wireless, bluetooth and ethernet modules
 	@echo sudo make wlunload to unload wireless modules
 	@echo sudo make btunload to unload bluetooth modules
 	@echo
-	@echo And then load the wireless or bluetooth module you need. If unsure reboot.
-	@echo Alternatively use "sudo make load/wlload/btload" to load modules
+	@echo Run sudo modprobe 'driver-name' to load your desired driver. 
+	@echo If unsure reboot.
 	@echo
 
 uninstall:
@@ -379,13 +417,26 @@ uninstall:
 	@echo
 	@echo "Your old bluetooth subsystem modules were left intact:"
 	@echo
-	@$(MODPROBE) -l sco
-	@$(MODPROBE) -l l2cap
-	@$(MODPROBE) -l hidp
-	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l ath3k           
+	@$(MODPROBE) -l bcm203x
+	@$(MODPROBE) -l bluecard_cs
+	@$(MODPROBE) -l bluetooth
 	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l bpa10x
+	@$(MODPROBE) -l bt3c_cs
+	@$(MODPROBE) -l btmrvl
+	@$(MODPROBE) -l btmrvl_sdio
+	@$(MODPROBE) -l btsdio
 	@$(MODPROBE) -l btusb
-	@$(MODPROBE) -l bluetooth
+	@$(MODPROBE) -l btuart_cs
+	@$(MODPROBE) -l	cmtp
+	@$(MODPROBE) -l	dtl1_cs
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l	hci_vhci
+	@$(MODPROBE) -l	hci_uart
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l sco
 	@
 	@echo 
 
@@ -397,22 +448,14 @@ clean:
 unload:
 	@./scripts/unload.sh
 
-load: unload
-	@./scripts/load.sh
-
 btunload:
 	@./scripts/btunload.sh
 
-btload: btunload
-	@./scripts/btload.sh
-
 wlunload:
 	@./scripts/wlunload.sh
 
-wlload: wlunload
-	@./scripts/wlload.sh
 
-.PHONY: all clean install uninstall unload load btunload btload wlunload wlload modules bt
+.PHONY: all clean install uninstall unload btunload wlunload modules bt
 
 endif



      
