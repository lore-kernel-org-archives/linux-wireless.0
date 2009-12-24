Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47634 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZLXLYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 06:24:34 -0500
Date: Thu, 24 Dec 2009 16:54:28 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<mcgrof@bombadil.infradead.org>
CC: Jothikumar Mothilal <Jothikumar.Mothilal@Atheros.com>,
	<linux-bluetooth@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-2.6: New targets to compile bluetooth alone
Message-ID: <20091224112428.GA30483@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compiling compat-pacakage consumes more time
as both wireless and bluetooth modules are compiled.

For someone who wants to use bluetooth alone
compiling and installing wireless modules is unnecessary
and is time consuming.

New targets are declared to compile, install, uninstall, load
and unload bluetooth modules seperately.

Usage is updated in README.
Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
---
 Makefile |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 README   |   28 +++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index d197202..f575f5b 100644
--- a/Makefile
+++ b/Makefile
@@ -21,16 +21,19 @@ obj-y := compat/
 
 obj-$(CONFIG_COMPAT_RFKILL) += net/rfkill/
 
+ifeq ($(BT),)
 obj-$(CONFIG_COMPAT_WIRELESS) += net/wireless/ net/mac80211/
 obj-$(CONFIG_COMPAT_WIRELESS_MODULES) += drivers/net/wireless/
 
 obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
+obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
+obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/misc/eeprom/
+endif
+
 obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
 obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 
-obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
-obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/misc/eeprom/
 # Sorry ssb requires pcmica backport for 2.6.33 which is not done yet
 #					drivers/ssb/
 
@@ -56,6 +59,11 @@ modules: $(CREL_CHECK)
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
 	@touch $@
 
+bt: $(CREL_CHECK)
+	@./scripts/check_config.sh
+	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) BT=TRUE modules
+	@touch $@
+
 # With the above and this we make sure we generate a new compat autoconf per
 # new relase of compat-wireless-2.6 OR when the user updates the 
 # $(COMPAT_CONFIG) file
@@ -66,6 +74,60 @@ $(CREL_CHECK):
 	@touch $@
 	@md5sum $(COMPAT_CONFIG) > $(CONFIG_CHECK)
 
+btinstall: btuninstall bt-install-modules bt-install-scripts
+
+bt-install-modules: bt
+	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) BT=TRUE \
+		modules_install
+
+bt-install-scripts:
+	@# All the scripts we can use
+	@# Mandrake doesn't have a depmod.d/ conf file to prefer
+	@# the updates/ dir which is what we use so we add one for it
+	@# (or any other distribution that doens't have this).
+	@/sbin/depmod -ae
+	@echo
+	@echo "Currently detected bluetooth subsystem modules:"
+	@echo
+	@$(MODPROBE) -l sco
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l btusb
+	@$(MODPROBE) -l bluetooth
+	@echo
+	@echo Now run:
+	@echo
+	@echo sudo make btunload:
+	@echo
+	@echo And the load the needed bluetooth modules. If unsure reboot.
+	@echo
+
+btuninstall:
+	@# New location, matches upstream
+	@rm -rf $(KLIB)/$(KMODDIR)/net/bluetooth/
+	@rm -rf $(KLIB)/$(KMODDIR)/drivers/bluetooth/
+	@# Lets only remove the stuff we are sure we are providing
+	@# on the misc directory.
+	@/sbin/depmod -ae
+	@echo
+	@echo "Your old bluetooth subsystem modules were left intact:"
+	@echo
+	@$(MODPROBE) -l sco
+	@$(MODPROBE) -l l2cap
+	@$(MODPROBE) -l hidp
+	@$(MODPROBE) -l rfcomm
+	@$(MODPROBE) -l bnep
+	@$(MODPROBE) -l btusb
+	@$(MODPROBE) -l bluetooth
+	@
+	@echo
+
+btclean:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
+	@rm -f $(CREL_PRE)*
+
 install: uninstall install-modules install-scripts
 
 install-modules: modules
@@ -293,7 +355,7 @@ wlunload:
 wlload: wlunload
 	@./scripts/wlload.sh
 
-.PHONY: all clean install uninstall unload load btunload btload wlunload wlload modules
+.PHONY: all clean install uninstall unload load btunload btload wlunload wlload modules bt
 
 endif
 
diff --git a/README b/README
index 380fc5a..88b16b4 100644
--- a/README
+++ b/README
@@ -6,6 +6,7 @@ This is a Linux wireless compatibility package which provides the latest
 Linux wireless subsystem enhancements for kernels 2.6.25 and above.
 It is technically possible to support kernels < 2.6.25 but more
 work is required for that.
+It also provides Linux bluetooth subsystem enhancements for kernels 2.6.27 and above.
 
 If you'd like to keep the wireless-testing git repository local as well,
 please read out git-guide which explains how to achieve this:
@@ -70,6 +71,24 @@ Load:
 
 Reboot unless you know what you are doing.
 
+
+Bluetooth modules can be seperately compiled and installed using below commands
+
+Build:
+	make bt
+
+Install:
+	sudo make btinstall
+
+Uninstall:
+	sudo make btuninstall
+
+Load:
+	sudo make btload
+
+Unload:
+	sudo make btunload
+
 Drivers
 -------
 
@@ -115,6 +134,15 @@ we provide b44 (the ethernet driverl).
 
 The new rfkill drivers also provided and backported.
 
+Bluetooth drivers:
+bluetooth
+btusb
+hci_uart
+btsdio
+btuart_cs
+bluecard_cs
+bfusb
+
 Firmware:
 ---------
 
-- 
1.6.0.4

