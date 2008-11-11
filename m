Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYKKWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 17:01:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH 3/4] ipw2x00: relocate ipw2100/ipw2200 to common directory
Date: Tue, 11 Nov 2008 16:51:04 -0500
Message-Id: <1226440265-21240-3-git-send-email-linville@tuxdriver.com> (sfid-20081111_230118_411423_7B7733A3)
In-Reply-To: <1226440265-21240-2-git-send-email-linville@tuxdriver.com>
References: <>
 <1226440265-21240-1-git-send-email-linville@tuxdriver.com>
 <1226440265-21240-2-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/Kconfig                 |  147 +-------------------------
 drivers/net/wireless/Makefile                |    5 +-
 drivers/net/wireless/ipw2x00/Kconfig         |  150 ++++++++++++++++++++++++++
 drivers/net/wireless/ipw2x00/Makefile        |    6 +
 drivers/net/wireless/{ => ipw2x00}/ipw2100.c |    0 
 drivers/net/wireless/{ => ipw2x00}/ipw2100.h |    0 
 drivers/net/wireless/{ => ipw2x00}/ipw2200.c |    0 
 drivers/net/wireless/{ => ipw2x00}/ipw2200.h |    0 
 8 files changed, 159 insertions(+), 149 deletions(-)
 create mode 100644 drivers/net/wireless/ipw2x00/Kconfig
 create mode 100644 drivers/net/wireless/ipw2x00/Makefile
 rename drivers/net/wireless/{ => ipw2x00}/ipw2100.c (100%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2100.h (100%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2200.c (100%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2200.h (100%)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 35dbc89..84b49c8 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -123,152 +123,6 @@ config PCMCIA_RAYCS
 	  To compile this driver as a module, choose M here: the module will be
 	  called ray_cs.  If unsure, say N.
 
-config IPW2100
-	tristate "Intel PRO/Wireless 2100 Network Connection"
-	depends on PCI && WLAN_80211
-	select WIRELESS_EXT
-	select FW_LOADER
-	select LIB80211
-	select IEEE80211
-	---help---
-          A driver for the Intel PRO/Wireless 2100 Network 
-	  Connection 802.11b wireless network adapter.
-
-          See <file:Documentation/networking/README.ipw2100> for information on
-          the capabilities currently enabled in this driver and for tips
-          for debugging issues and problems.
-
-	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
-	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you 
-	  will need to place it in /lib/firmware.
-
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
-
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
-
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
- 
-config IPW2100_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2100
-        ---help---
-	  Enables promiscuous/monitor mode support for the ipw2100 driver.
-	  With this feature compiled into the driver, you can switch to 
-	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
-	  mode, no packets can be sent.
-
-config IPW2100_DEBUG
-	bool "Enable full debugging output in IPW2100 module."
-	depends on IPW2100
-	---help---
-	  This option will enable debug tracing output for the IPW2100.  
-
-	  This will result in the kernel module being ~60k larger.  You can 
-	  control which debug output is sent to the kernel log by setting the 
-	  value in 
-
-	  /sys/bus/pci/drivers/ipw2100/debug_level
-
-	  This entry will only exist if this option is enabled.
-
-	  If you are not trying to debug or develop the IPW2100 driver, you 
-	  most likely want to say N here.
-
-config IPW2200
-	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && WLAN_80211
-	select WIRELESS_EXT
-	select FW_LOADER
-	select LIB80211
-	select IEEE80211
-	---help---
-          A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
-	  Connection adapters. 
-
-          See <file:Documentation/networking/README.ipw2200> for 
-	  information on the capabilities currently enabled in this 
-	  driver and for tips for debugging issues and problems.
-
-	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
-	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200 
-	  for information on where to install the firmware images.
-
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
-
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
-
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
-
-config IPW2200_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2200
-        ---help---
-	  Enables promiscuous/monitor mode support for the ipw2200 driver.
-	  With this feature compiled into the driver, you can switch to 
-	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
-	  mode, no packets can be sent.
-
-config IPW2200_RADIOTAP
-	bool "Enable radiotap format 802.11 raw packet support"
-	depends on IPW2200_MONITOR
-
-config IPW2200_PROMISCUOUS
-	bool "Enable creation of a RF radiotap promiscuous interface"
-	depends on IPW2200_MONITOR
-	select IPW2200_RADIOTAP
-	---help---
-          Enables the creation of a second interface prefixed 'rtap'. 
-          This second interface will provide every received in radiotap
-	  format.
-
-          This is useful for performing wireless network analysis while
-          maintaining an active association.
-
-          Example usage:
-
-            % modprobe ipw2200 rtap_iface=1
-            % ifconfig rtap0 up
-            % tethereal -i rtap0
-
-          If you do not specify 'rtap_iface=1' as a module parameter then 
-          the rtap interface will not be created and you will need to turn 
-          it on via sysfs:
-	
-            % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
-
-config IPW2200_QOS
-        bool "Enable QoS support"
-        depends on IPW2200 && EXPERIMENTAL
-
-config IPW2200_DEBUG
-	bool "Enable full debugging output in IPW2200 module."
-	depends on IPW2200
-	---help---
-	  This option will enable low level debug tracing output for IPW2200.
-
-	  Note, normal debug code is already compiled in. This low level
-	  debug option enables debug on hot paths (e.g Tx, Rx, ISR) and
-	  will result in the kernel module being ~70 larger.  Most users
-	  will typically not need this high verbosity debug information.
-
-	  If you are not sure, say N here.
-
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
@@ -714,6 +568,7 @@ config MAC80211_HWSIM
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath5k/Kconfig"
 source "drivers/net/wireless/ath9k/Kconfig"
+source "drivers/net/wireless/ipw2x00/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index ed0023d..ac590e1 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -2,9 +2,8 @@
 # Makefile for the Linux Wireless network device drivers.
 #
 
-obj-$(CONFIG_IPW2100) += ipw2100.o
-
-obj-$(CONFIG_IPW2200) += ipw2200.o
+obj-$(CONFIG_IPW2100) += ipw2x00/
+obj-$(CONFIG_IPW2200) += ipw2x00/
 
 obj-$(CONFIG_STRIP) += strip.o
 obj-$(CONFIG_ARLAN) += arlan.o 
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
new file mode 100644
index 0000000..67c57bf
--- /dev/null
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -0,0 +1,150 @@
+#
+# Intel Centrino wireless drivers
+#
+
+config IPW2100
+	tristate "Intel PRO/Wireless 2100 Network Connection"
+	depends on PCI && WLAN_80211
+	select WIRELESS_EXT
+	select FW_LOADER
+	select LIB80211
+	select IEEE80211
+	---help---
+          A driver for the Intel PRO/Wireless 2100 Network 
+	  Connection 802.11b wireless network adapter.
+
+          See <file:Documentation/networking/README.ipw2100> for information on
+          the capabilities currently enabled in this driver and for tips
+          for debugging issues and problems.
+
+	  In order to use this driver, you will need a firmware image for it.
+          You can obtain the firmware from
+	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you 
+	  will need to place it in /lib/firmware.
+
+          You will also very likely need the Wireless Tools in order to
+          configure your card:
+
+          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+
+          It is recommended that you compile this driver as a module (M)
+          rather than built-in (Y). This driver requires firmware at device
+          initialization time, and when built-in this typically happens
+          before the filesystem is accessible (hence firmware will be
+          unavailable and initialization will fail). If you do choose to build
+          this driver into your kernel image, you can avoid this problem by
+          including the firmware and a firmware loader in an initramfs.
+ 
+config IPW2100_MONITOR
+        bool "Enable promiscuous mode"
+        depends on IPW2100
+        ---help---
+	  Enables promiscuous/monitor mode support for the ipw2100 driver.
+	  With this feature compiled into the driver, you can switch to 
+	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
+	  mode, no packets can be sent.
+
+config IPW2100_DEBUG
+	bool "Enable full debugging output in IPW2100 module."
+	depends on IPW2100
+	---help---
+	  This option will enable debug tracing output for the IPW2100.  
+
+	  This will result in the kernel module being ~60k larger.  You can 
+	  control which debug output is sent to the kernel log by setting the 
+	  value in 
+
+	  /sys/bus/pci/drivers/ipw2100/debug_level
+
+	  This entry will only exist if this option is enabled.
+
+	  If you are not trying to debug or develop the IPW2100 driver, you 
+	  most likely want to say N here.
+
+config IPW2200
+	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
+	depends on PCI && WLAN_80211
+	select WIRELESS_EXT
+	select FW_LOADER
+	select LIB80211
+	select IEEE80211
+	---help---
+          A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
+	  Connection adapters. 
+
+          See <file:Documentation/networking/README.ipw2200> for 
+	  information on the capabilities currently enabled in this 
+	  driver and for tips for debugging issues and problems.
+
+	  In order to use this driver, you will need a firmware image for it.
+          You can obtain the firmware from
+	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200 
+	  for information on where to install the firmware images.
+
+          You will also very likely need the Wireless Tools in order to
+          configure your card:
+
+          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+
+          It is recommended that you compile this driver as a module (M)
+          rather than built-in (Y). This driver requires firmware at device
+          initialization time, and when built-in this typically happens
+          before the filesystem is accessible (hence firmware will be
+          unavailable and initialization will fail). If you do choose to build
+          this driver into your kernel image, you can avoid this problem by
+          including the firmware and a firmware loader in an initramfs.
+
+config IPW2200_MONITOR
+        bool "Enable promiscuous mode"
+        depends on IPW2200
+        ---help---
+	  Enables promiscuous/monitor mode support for the ipw2200 driver.
+	  With this feature compiled into the driver, you can switch to 
+	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
+	  mode, no packets can be sent.
+
+config IPW2200_RADIOTAP
+	bool "Enable radiotap format 802.11 raw packet support"
+	depends on IPW2200_MONITOR
+
+config IPW2200_PROMISCUOUS
+	bool "Enable creation of a RF radiotap promiscuous interface"
+	depends on IPW2200_MONITOR
+	select IPW2200_RADIOTAP
+	---help---
+          Enables the creation of a second interface prefixed 'rtap'. 
+          This second interface will provide every received in radiotap
+	  format.
+
+          This is useful for performing wireless network analysis while
+          maintaining an active association.
+
+          Example usage:
+
+            % modprobe ipw2200 rtap_iface=1
+            % ifconfig rtap0 up
+            % tethereal -i rtap0
+
+          If you do not specify 'rtap_iface=1' as a module parameter then 
+          the rtap interface will not be created and you will need to turn 
+          it on via sysfs:
+	
+            % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
+
+config IPW2200_QOS
+        bool "Enable QoS support"
+        depends on IPW2200 && EXPERIMENTAL
+
+config IPW2200_DEBUG
+	bool "Enable full debugging output in IPW2200 module."
+	depends on IPW2200
+	---help---
+	  This option will enable low level debug tracing output for IPW2200.
+
+	  Note, normal debug code is already compiled in. This low level
+	  debug option enables debug on hot paths (e.g Tx, Rx, ISR) and
+	  will result in the kernel module being ~70 larger.  Most users
+	  will typically not need this high verbosity debug information.
+
+	  If you are not sure, say N here.
+
diff --git a/drivers/net/wireless/ipw2x00/Makefile b/drivers/net/wireless/ipw2x00/Makefile
new file mode 100644
index 0000000..dbc0d81
--- /dev/null
+++ b/drivers/net/wireless/ipw2x00/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the Intel Centrino wireless drivers
+#
+
+obj-$(CONFIG_IPW2100) += ipw2100.o
+obj-$(CONFIG_IPW2200) += ipw2200.o
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
similarity index 100%
rename from drivers/net/wireless/ipw2100.c
rename to drivers/net/wireless/ipw2x00/ipw2100.c
diff --git a/drivers/net/wireless/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
similarity index 100%
rename from drivers/net/wireless/ipw2100.h
rename to drivers/net/wireless/ipw2x00/ipw2100.h
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
similarity index 100%
rename from drivers/net/wireless/ipw2200.c
rename to drivers/net/wireless/ipw2x00/ipw2200.c
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
similarity index 100%
rename from drivers/net/wireless/ipw2200.h
rename to drivers/net/wireless/ipw2x00/ipw2200.h
-- 
1.5.4.3

