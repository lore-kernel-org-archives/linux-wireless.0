Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48017 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523AbZFJUBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:01:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] [compat-2.6] Add iwmc3200wifi driver.
Date: Wed, 10 Jun 2009 22:01:46 +0200
Message-Id: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It only supports kernel >= 2.6.29, because it uses new netdev_ops api.
If you need support for older kernel please backport it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff      |    6 ------
 config.mk               |    7 +++++++
 scripts/admin-update.sh |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 846e8f5..dec8e91 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -181,12 +181,6 @@
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
-@@ -60,5 +34,3 @@
- obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
- 
- obj-$(CONFIG_WL12XX)	+= wl12xx/
--
--obj-$(CONFIG_IWM)	+= iwmc3200wifi/
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
diff --git a/config.mk b/config.mk
index 0a2cbb3..7de159b 100644
--- a/config.mk
+++ b/config.mk
@@ -305,6 +305,13 @@ ifneq ($(CONFIG_MMC),)
 CONFIG_LIBERTAS_SDIO=m
 NEED_LIBERTAS=y
 
+# Activate iwmc3200wifi support only on kernel >= 2.6.29.
+# iwmc3200wifi uses new netdev_ops api no supported by old kernel.
+ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 29 && echo yes),yes)
+CONFIG_IWM=m
+# CONFIG_IWM_DEBUG=y
+endif
+
 endif # end of SDIO driver list
 
 # Common rt2x00 requirements
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index ae42894..07f7d85 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -64,6 +64,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
+DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
-- 
1.6.2.1

