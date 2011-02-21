Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36267 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BUWbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] compat-wireless: rename some config options
Date: Mon, 21 Feb 2011 23:31:18 +0100
Message-Id: <1298327484-16938-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
References: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some config options have to be renamed to deactivate then, when they are
activated in the kernel config or for changing them from m to y.

* The zd1211rw works only with kernel > 2.6.27
* CONFIG_BT_L2CAP and CONFIG_BT_SCO are boolean now, but often set to m
in the kernel config.
* CONFIG_BT_HIDP does not build with older kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |   12 ++--
 patches/08-rename-config-options.patch |  132 ++++++++++++++++++++++++++++++++
 patches/08-rename-iwl4965-config.patch |   63 ---------------
 patches/99-change-makefiles.patch      |    2 +-
 scripts/driver-select                  |    4 +-
 5 files changed, 141 insertions(+), 72 deletions(-)
 create mode 100644 patches/08-rename-config-options.patch
 delete mode 100644 patches/08-rename-iwl4965-config.patch

diff --git a/config.mk b/config.mk
index e7f04ea..2485336 100644
--- a/config.mk
+++ b/config.mk
@@ -159,8 +159,8 @@ CONFIG_LIB80211_CRYPT_TKIP=m
 # CONFIG_LIB80211_DEBUG=y
 
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_COMPAT_BT_L2CAP=y
+CONFIG_COMPAT_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
@@ -170,7 +170,9 @@ CONFIG_BT_BNEP_PROTO_FILTER=y
 ifdef CONFIG_ISDN_CAPI
 CONFIG_BT_CMTP=m
 endif #CONFIG_ISDN_CAPI
-CONFIG_BT_HIDP=m
+ifndef CONFIG_COMPAT_KERNEL_28
+CONFIG_COMPAT_BT_HIDP=m
+endif #CONFIG_COMPAT_KERNEL_28
 
 CONFIG_BT_HCIUART=M
 CONFIG_BT_HCIUART_H4=y
@@ -388,10 +390,8 @@ CONFIG_EEPROM_93CX6=m
 # USB Drivers
 ifdef CONFIG_USB
 ifndef CONFIG_COMPAT_KERNEL_29
-CONFIG_ZD1211RW=m
+CONFIG_COMPAT_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG=y
-else
-CONFIG_ZD1211RW=n
 endif #CONFIG_COMPAT_KERNEL_29
 
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
new file mode 100644
index 0000000..a81e0bf
--- /dev/null
+++ b/patches/08-rename-config-options.patch
@@ -0,0 +1,132 @@
+In kernel 2.6.26 and older CONFIG_IWL4965 was build as an extra
+module, but now it is directly included in the iwlagn.
+
+CONFIG_IWL4965 has to be set to y, to build correctly.
+
+zd1211rw does not build with kernel < 2.6.28, but it is often activated 
+in the kernel config of older kernels. We rename the option to 
+deactivate it on older kernels.
+CONFIG_BT_L2CAP and CONFIG_BT_SCO are boolean now, but often set to m 
+in the kernel config.
+
+CONFIG_BT_HIDP does not build with older kernel versions.
+
+--- a/drivers/net/wireless/Makefile
++++ b/drivers/net/wireless/Makefile
+@@ -21,7 +21,7 @@ obj-$(CONFIG_PRISM54)		+= prism54/
+ obj-$(CONFIG_HOSTAP)		+= hostap/
+ obj-$(CONFIG_B43)		+= b43/
+ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
+-obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
++obj-$(CONFIG_COMPAT_ZD1211RW)		+= zd1211rw/
+ obj-$(CONFIG_RTL8180)		+= rtl818x/
+ obj-$(CONFIG_RTL8187)		+= rtl818x/
+ obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
+@@ -41,7 +41,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
+ 
+ obj-$(CONFIG_MWL8K)	+= mwl8k.o
+ 
+-obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
++obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlwifi/
+ obj-$(CONFIG_RT2X00)	+= rt2x00/
+ 
+ obj-$(CONFIG_P54_COMMON)	+= p54/
+--- a/drivers/net/wireless/iwlwifi/Makefile
++++ b/drivers/net/wireless/iwlwifi/Makefile
+@@ -1,9 +1,9 @@
+-obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
++obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlcore.o
+ iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+ iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
+ iwlcore-objs 		+= iwl-scan.o iwl-led.o
+ iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
+-iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
++iwlcore-$(CONFIG_COMPAT_IWL4965) += iwl-legacy.o
+ iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
+ iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
+ 
+@@ -21,7 +21,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
+ iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
+ iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
+ 
+-iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
++iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
+--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
++++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
+@@ -4121,7 +4121,7 @@ static int iwl_pci_probe(struct pci_dev
+ #ifdef CONFIG_IWL5000
+ 		iwlagn_hw_ops.hw_scan = NULL;
+ #endif
+-#ifdef CONFIG_IWL4965
++#ifdef CONFIG_COMPAT_IWL4965
+ 		iwl4965_hw_ops.hw_scan = NULL;
+ #endif
+ 	}
+@@ -4502,10 +4502,10 @@ static void __devexit iwl_pci_remove(str
+ 
+ /* Hardware specific file defines the PCI IDs table for that hardware module */
+ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
+-#ifdef CONFIG_IWL4965
++#ifdef CONFIG_COMPAT_IWL4965
+ 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
+ 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+-#endif /* CONFIG_IWL4965 */
++#endif /* CONFIG_COMPAT_IWL4965 */
+ #ifdef CONFIG_IWL5000
+ /* 5100 Series WiFi */
+ 	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
+--- a/drivers/net/wireless/zd1211rw/Makefile
++++ b/drivers/net/wireless/zd1211rw/Makefile
+@@ -1,4 +1,4 @@
+-obj-$(CONFIG_ZD1211RW) += zd1211rw.o
++obj-$(CONFIG_COMPAT_ZD1211RW) += zd1211rw.o
+ 
+ zd1211rw-objs := zd_chip.o zd_mac.o \
+ 		zd_rf_al2230.o zd_rf_rf2959.o \
+--- a/include/net/bluetooth/bluetooth.h
++++ b/include/net/bluetooth/bluetooth.h
+@@ -205,7 +205,7 @@ extern void bt_sysfs_cleanup(void);
+ 
+ extern struct dentry *bt_debugfs;
+ 
+-#ifdef CONFIG_BT_L2CAP
++#ifdef CONFIG_COMPAT_BT_L2CAP
+ int l2cap_init(void);
+ void l2cap_exit(void);
+ #else
+@@ -219,7 +219,7 @@ static inline void l2cap_exit(void)
+ }
+ #endif
+ 
+-#ifdef CONFIG_BT_SCO
++#ifdef CONFIG_COMPAT_BT_SCO
+ int sco_init(void);
+ void sco_exit(void);
+ #else
+--- a/net/bluetooth/Makefile
++++ b/net/bluetooth/Makefile
+@@ -6,8 +6,8 @@ obj-$(CONFIG_BT)	+= bluetooth.o
+ obj-$(CONFIG_BT_RFCOMM)	+= rfcomm/
+ obj-$(CONFIG_BT_BNEP)	+= bnep/
+ obj-$(CONFIG_BT_CMTP)	+= cmtp/
+-obj-$(CONFIG_BT_HIDP)	+= hidp/
++obj-$(CONFIG_COMPAT_BT_HIDP)	+= hidp/
+ 
+ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o hci_sock.o hci_sysfs.o lib.o
+-bluetooth-$(CONFIG_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o
+-bluetooth-$(CONFIG_BT_SCO)	+= sco.o
++bluetooth-$(CONFIG_COMPAT_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o
++bluetooth-$(CONFIG_COMPAT_BT_SCO)	+= sco.o
+--- a/net/bluetooth/hidp/Makefile
++++ b/net/bluetooth/hidp/Makefile
+@@ -2,6 +2,6 @@
+ # Makefile for the Linux Bluetooth HIDP layer
+ #
+ 
+-obj-$(CONFIG_BT_HIDP) += hidp.o
++obj-$(CONFIG_COMPAT_BT_HIDP) += hidp.o
+ 
+ hidp-objs := core.o sock.o
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
deleted file mode 100644
index 61a0f1e..0000000
--- a/patches/08-rename-iwl4965-config.patch
+++ /dev/null
@@ -1,63 +0,0 @@
-In kernel 2.6.26 and older CONFIG_IWL4965 was build as an extra
-module, but now it is directly included in the iwlagn.
-
-CONFIG_IWL4965 has to be set to y, to build correctly.
-
---- a/drivers/net/wireless/Makefile
-+++ b/drivers/net/wireless/Makefile
-@@ -41,7 +41,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
- 
- obj-$(CONFIG_MWL8K)	+= mwl8k.o
- 
--obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
-+obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlwifi/
- obj-$(CONFIG_RT2X00)	+= rt2x00/
- 
- obj-$(CONFIG_P54_COMMON)	+= p54/
---- a/drivers/net/wireless/iwlwifi/Makefile
-+++ b/drivers/net/wireless/iwlwifi/Makefile
-@@ -1,9 +1,9 @@
--obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
-+obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlcore.o
- iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
- iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
- iwlcore-objs 		+= iwl-scan.o iwl-led.o
- iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
--iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
-+iwlcore-$(CONFIG_COMPAT_IWL4965) += iwl-legacy.o
- iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
- iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
- 
-@@ -21,7 +21,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
- iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
- iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
- 
--iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
-+iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
- iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
- iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
- iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
---- a/drivers/net/wireless/iwlwifi/iwl-agn.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4080,7 +4080,7 @@ static int iwl_pci_probe(struct pci_dev
- #ifdef CONFIG_IWL5000
- 		iwlagn_hw_ops.hw_scan = NULL;
- #endif
--#ifdef CONFIG_IWL4965
-+#ifdef CONFIG_COMPAT_IWL4965
- 		iwl4965_hw_ops.hw_scan = NULL;
- #endif
- 	}
-@@ -4461,10 +4461,10 @@ static void __devexit iwl_pci_remove(str
- 
- /* Hardware specific file defines the PCI IDs table for that hardware module */
- static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
--#ifdef CONFIG_IWL4965
-+#ifdef CONFIG_COMPAT_IWL4965
- 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
- 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
--#endif /* CONFIG_IWL4965 */
-+#endif /* CONFIG_COMPAT_IWL4965 */
- #ifdef CONFIG_IWL5000
- /* 5100 Series WiFi */
- 	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 585ff03..187c110 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -63,7 +63,7 @@ only the wireless stuff.
 -obj-$(CONFIG_HOSTAP)		+= hostap/
  obj-$(CONFIG_B43)		+= b43/
  obj-$(CONFIG_B43LEGACY)		+= b43legacy/
- obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
+ obj-$(CONFIG_COMPAT_ZD1211RW)		+= zd1211rw/
 @@ -26,13 +16,8 @@ obj-$(CONFIG_RTL8180)		+= rtl818x/
  obj-$(CONFIG_RTL8187)		+= rtl818x/
  obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
diff --git a/scripts/driver-select b/scripts/driver-select
index 0d5a38b..b18869e 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -306,7 +306,7 @@ case $1 in
 # Group drivers
 	atheros)
 		select_drivers		CONFIG_ATH_COMMON \
-					CONFIG_ZD1211RW
+					CONFIG_COMPAT_ZD1211RW
 		disable_staging
 		disable_var_01
 		;;
@@ -383,7 +383,7 @@ case $1 in
 		select_driver		CONFIG_NOTHING
 		;;
 	zd1211rw)
-		select_driver		CONFIG_ZD1211RW
+		select_driver		CONFIG_COMPAT_ZD1211RW
 		disable_staging
 		disable_var_01
 		;;
-- 
1.7.1

