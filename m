Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59832 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0H0SlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/7] compat-wireless: rename CONFIG_IWLWIFI config symbol
Date: Fri, 27 Aug 2010 20:40:51 +0200
Message-Id: <1282934453-18093-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel 2.6.24 CONFIG_IWLWIFI was a bool config symbol and not a
tristate one. In that kernel it was used for showing the menu option for
the Intel driver and not for selection the module it is used for today.
In kernel configurations for version 2.6.24 it is set so y and not to m.
As we do not overwrite some value selected in the kernel config it
will cause problems when we build some parts of the Intel driver in
compat-wireless directly into the kernel.
Now we use an other name for this config symbol to work around the
problem.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    2 +-
 patches/08-rename-iwl4965-config.patch |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 4c4a111..110291d 100644
--- a/config.mk
+++ b/config.mk
@@ -214,7 +214,7 @@ CONFIG_ATH9K_COMMON=m
 # CONFIG_ATH9K_PKTLOG=y
 
 
-CONFIG_IWLWIFI=m
+CONFIG_COMPAT_IWLWIFI=m
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 568314f..28cd39e 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -5,6 +5,12 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
 
 --- a/drivers/net/wireless/iwlwifi/Makefile
 +++ b/drivers/net/wireless/iwlwifi/Makefile
+@@ -1,4 +1,4 @@
+-obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
++obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlcore.o
+ iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+ iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
+ iwlcore-objs 		+= iwl-scan.o iwl-led.o
 @@ -15,7 +15,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
  iwlagn-objs		+= iwl-agn-tt.o
  iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
@@ -16,7 +22,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4339,10 +4339,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4450,10 +4450,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
-- 
1.7.0.4

