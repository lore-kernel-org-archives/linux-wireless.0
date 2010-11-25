Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52950 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab0KYOsp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:48:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] compat-wireless: make BRCMFMAC compile
Date: Thu, 25 Nov 2010 15:48:33 +0100
Message-Id: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes some compile problems when Broadcom IEEE802.11n
embedded FullMAC WLAN driver is selected.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch         |   18 ++++++++++++++++--
 patches/35-backport-brcm80211-Makefile.patch |   15 +++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index cd70bf3..48daec4 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -600,9 +600,23 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
  
  	return hash.low | ((u64)hash.high << 32);
+--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
++++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+@@ -726,7 +726,11 @@ static void _dhd_set_multicast_list(dhd_
+ 	netdev_for_each_mc_addr(ha, dev) {
+ 		if (!cnt)
+ 			break;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 		memcpy(bufp, ha->addr, ETHER_ADDR_LEN);
++#else
++		memcpy(bufp, ha->dmi_addr, ETHER_ADDR_LEN);
++#endif
+ 		bufp += ETHER_ADDR_LEN;
+ 		cnt--;
+ 	}
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1763,7 +1763,11 @@ struct ieee80211_ops {
+@@ -1770,7 +1770,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
@@ -663,7 +677,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -724,7 +724,12 @@ struct ieee80211_local {
+@@ -725,7 +725,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
diff --git a/patches/35-backport-brcm80211-Makefile.patch b/patches/35-backport-brcm80211-Makefile.patch
index ee15121..bc57367 100644
--- a/patches/35-backport-brcm80211-Makefile.patch
+++ b/patches/35-backport-brcm80211-Makefile.patch
@@ -15,3 +15,18 @@
  
  PCI_CFLAGS := -DWLC_LOW
  
+--- a/drivers/staging/brcm80211/brcmfmac/Makefile
++++ b/drivers/staging/brcm80211/brcmfmac/Makefile
+@@ -33,9 +33,9 @@ ccflags-y :=			\
+ 	-DPKT_FILTER_SUPPORT	\
+ 	-DSHOW_EVENTS		\
+ 	-DTOE			\
+-	-Idrivers/staging/brcm80211/brcmfmac		\
+-	-Idrivers/staging/brcm80211/include		\
+-	-Idrivers/staging/brcm80211/util
++	-I$(obj)		\
++	-I$(obj)/../include		\
++	-I$(obj)/../util
+ 
+ DHDOFILES = dhd_linux.o ../util/linux_osl.o ../util/bcmutils.o dhd_common.o dhd_custom_gpio.o	\
+ 	wl_iw.o wl_cfg80211.o ../util/siutils.o ../util/sbutils.o ../util/aiutils.o ../util/hndpmu.o ../util/bcmwifi.o dhd_sdio.o	\
-- 
1.7.1

