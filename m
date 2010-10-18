Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56804.mail.re3.yahoo.com ([66.196.97.78]:22885 "HELO
	web56804.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755791Ab0JRNoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 09:44:08 -0400
Message-ID: <507036.8029.qm@web56804.mail.re3.yahoo.com>
Date: Mon, 18 Oct 2010 06:44:06 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: enable uninstall for staging & atlxx
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- enable 'make uninstall' for staging - brcm80211, ath6kl and ethernet atlxx 
- add atlxx to 'modprobe -l' list

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/Makefile
+++ b/Makefile
@@ -255,6 +255,13 @@ install-scripts:
 	@$(MODPROBE) -l wl1271
 	@$(MODPROBE) -l zd1211rw
 	@echo
+	@echo "Currently detected ethernet subsystem modules:"
+	@echo
+	@$(MODPROBE) -l atl1
+	@$(MODPROBE) -l atl2
+	@$(MODPROBE) -l atl1e
+	@$(MODPROBE) -l atl1c
+	@echo
 	@echo "Currently detected bluetooth subsystem modules:"
 	@echo
 	@$(MODPROBE) -l sco
@@ -284,6 +291,8 @@ uninstall:
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/ssb/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/net/usb/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/net/wireless/
+	@rm -rf $(KLIB)/$(KMODDIR)/drivers/staging/
+	@rm -rf $(KLIB)/$(KMODDIR)/drivers/net/atl*
 	@# Lets only remove the stuff we are sure we are providing
 	@# on the misc directory.
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/misc/eeprom/eeprom_93cx6.ko*
@@ -362,6 +371,13 @@ uninstall:
 	@$(MODPROBE) -l wl1271
 	@$(MODPROBE) -l zd1211rw
 	@echo
+	@echo "Your old ethernet subsystem modules are left intact:"
+	@echo
+	@$(MODPROBE) -l atl1
+	@$(MODPROBE) -l atl2
+	@$(MODPROBE) -l atl1e
+	@$(MODPROBE) -l atl1c
+	@echo
 	@echo "Your old bluetooth subsystem modules were left intact:"
 	@echo
 	@$(MODPROBE) -l sco



      
