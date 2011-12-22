Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55530 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LVUru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/6] compat-wireless: CONFIG_BT_L2CAP and CONFIG_BT_SCO removed
Date: Thu, 22 Dec 2011 21:47:27 +0100
Message-Id: <1324586850-5212-4-git-send-email-hauke@hauke-m.de> (sfid-20111222_214753_918677_C1C697E1)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The config options CONFIG_BT_L2CAP and CONFIG_BT_SCO were removed from
the kernel and this patch removes them from compat-wireless.

commit f1e91e1640d808d332498a6b09b2bcd01462eff9
Author: Ulisses Furquim <ulisses@profusion.mobi>
Date:   Wed Dec 21 01:32:09 2011 -0200

    Bluetooth: Always compile SCO and L2CAP in Bluetooth Core

    The handling of SCO audio links and the L2CAP protocol are essential to
    any system with Bluetooth thus are always compiled in from now on.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    2 --
 patches/08-rename-config-options.patch |   29 +++--------------------------
 2 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/config.mk b/config.mk
index f09d16d..e44b814 100644
--- a/config.mk
+++ b/config.mk
@@ -211,8 +211,6 @@ CONFIG_LIB80211_CRYPT_TKIP=m
 # CONFIG_LIB80211_DEBUG=y
 
 CONFIG_BT=m
-CONFIG_COMPAT_BT_L2CAP=y
-CONFIG_COMPAT_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 2f73276..249d471 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -61,40 +61,17 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  
  zd1211rw-objs := zd_chip.o zd_mac.o \
  		zd_rf_al2230.o zd_rf_rf2959.o \
---- a/include/net/bluetooth/bluetooth.h
-+++ b/include/net/bluetooth/bluetooth.h
-@@ -250,7 +250,7 @@ extern void bt_sysfs_cleanup(void);
- 
- extern struct dentry *bt_debugfs;
- 
--#ifdef CONFIG_BT_L2CAP
-+#ifdef CONFIG_COMPAT_BT_L2CAP
- int l2cap_init(void);
- void l2cap_exit(void);
- #else
-@@ -264,7 +264,7 @@ static inline void l2cap_exit(void)
- }
- #endif
- 
--#ifdef CONFIG_BT_SCO
-+#ifdef CONFIG_COMPAT_BT_SCO
- int sco_init(void);
- void sco_exit(void);
- #else
 --- a/net/bluetooth/Makefile
 +++ b/net/bluetooth/Makefile
-@@ -6,8 +6,8 @@ obj-$(CONFIG_BT)	+= bluetooth.o
+@@ -6,7 +6,7 @@ obj-$(CONFIG_BT)	+= bluetooth.o
  obj-$(CONFIG_BT_RFCOMM)	+= rfcomm/
  obj-$(CONFIG_BT_BNEP)	+= bnep/
  obj-$(CONFIG_BT_CMTP)	+= cmtp/
 -obj-$(CONFIG_BT_HIDP)	+= hidp/
 +obj-$(CONFIG_COMPAT_BT_HIDP)	+= hidp/
  
- bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o hci_sock.o hci_sysfs.o lib.o
--bluetooth-$(CONFIG_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o smp.o
--bluetooth-$(CONFIG_BT_SCO)	+= sco.o
-+bluetooth-$(CONFIG_COMPAT_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o smp.o
-+bluetooth-$(CONFIG_COMPAT_BT_SCO)	+= sco.o
+ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
+ 	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o sco.o lib.o
 --- a/net/bluetooth/hidp/Makefile
 +++ b/net/bluetooth/hidp/Makefile
 @@ -2,6 +2,6 @@
-- 
1.7.5.4

