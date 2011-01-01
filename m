Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39379 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1AAO0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:26:40 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat-wireless: rtl8187 and rtl8180 moved
Date: Sat,  1 Jan 2011 15:26:20 +0100
Message-Id: <1293891981-22151-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
References: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8187 and rtl8180 modules moved to an other subdirectory and the
filenames were changed. The makefile includes some header, where the
path has to be changed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch         |   22 +++++-----
 patches/35-backport-brcm80211-Makefile.patch |   32 ----------------
 patches/35-fix-makefile-includes.patch       |   52 ++++++++++++++++++++++++++
 scripts/admin-update.sh                      |    2 +
 4 files changed, 65 insertions(+), 43 deletions(-)
 delete mode 100644 patches/35-backport-brcm80211-Makefile.patch
 create mode 100644 patches/35-fix-makefile-includes.patch

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 8ad8391..3d8632e 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -162,7 +162,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -3131,20 +3131,42 @@ unlock:
+@@ -3135,20 +3135,42 @@ unlock:
  }
  
  static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -205,7 +205,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3153,6 +3175,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -3157,6 +3179,9 @@ static u64 ath5k_prepare_multicast(struc
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -445,7 +445,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  			      size_t fw_name_len, u32 *hw_ver);
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -1609,7 +1609,11 @@ static void set_multicast_list(struct us
+@@ -1629,7 +1629,11 @@ static void set_multicast_list(struct us
  
  		netdev_for_each_mc_addr(ha, usbdev->net)
  			memcpy(mc_addrs + i++ * ETH_ALEN,
@@ -457,8 +457,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
  	netif_addr_unlock_bh(usbdev->net);
  
---- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
-+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
+--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
++++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
 @@ -815,10 +815,19 @@ static void rtl8180_bss_info_changed(str
  	}
  }
@@ -479,8 +479,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
  
  static void rtl8180_configure_filter(struct ieee80211_hw *dev,
---- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
-+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
+--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
++++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
 @@ -1194,9 +1194,17 @@ static void rtl8187_bss_info_changed(str
  }
  
@@ -677,7 +677,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -719,7 +719,12 @@ struct ieee80211_local {
+@@ -734,7 +734,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
@@ -692,7 +692,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -433,8 +433,13 @@ static void ieee80211_do_stop(struct iee
+@@ -435,8 +435,13 @@ static void ieee80211_do_stop(struct iee
  
  	netif_addr_lock_bh(sdata->dev);
  	spin_lock_bh(&local->filter_lock);
@@ -706,7 +706,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  	netif_addr_unlock_bh(sdata->dev);
  
-@@ -593,7 +598,12 @@ static void ieee80211_set_multicast_list
+@@ -595,7 +600,12 @@ static void ieee80211_set_multicast_list
  		sdata->flags ^= IEEE80211_SDATA_PROMISC;
  	}
  	spin_lock_bh(&local->filter_lock);
@@ -733,7 +733,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  
  	/* be a bit nasty */
-@@ -555,9 +559,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
+@@ -559,9 +563,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
  
  	INIT_LIST_HEAD(&local->interfaces);
diff --git a/patches/35-backport-brcm80211-Makefile.patch b/patches/35-backport-brcm80211-Makefile.patch
deleted file mode 100644
index bc57367..0000000
--- a/patches/35-backport-brcm80211-Makefile.patch
+++ /dev/null
@@ -1,32 +0,0 @@
---- a/drivers/staging/brcm80211/Makefile
-+++ b/drivers/staging/brcm80211/Makefile
-@@ -24,10 +24,10 @@ ccflags-y :=					\
- 	-DDBAND					\
- 	-DBCMDMA32				\
- 	-DBCMNVRAMR				\
--	-Idrivers/staging/brcm80211/sys		\
--	-Idrivers/staging/brcm80211/phy		\
--	-Idrivers/staging/brcm80211/util	\
--	-Idrivers/staging/brcm80211/include
-+	-I$(obj)/sys		\
-+	-I$(obj)/phy		\
-+	-I$(obj)/util	\
-+	-I$(obj)/include
- 
- PCI_CFLAGS := -DWLC_LOW
- 
---- a/drivers/staging/brcm80211/brcmfmac/Makefile
-+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -33,9 +33,9 @@ ccflags-y :=			\
- 	-DPKT_FILTER_SUPPORT	\
- 	-DSHOW_EVENTS		\
- 	-DTOE			\
--	-Idrivers/staging/brcm80211/brcmfmac		\
--	-Idrivers/staging/brcm80211/include		\
--	-Idrivers/staging/brcm80211/util
-+	-I$(obj)		\
-+	-I$(obj)/../include		\
-+	-I$(obj)/../util
- 
- DHDOFILES = dhd_linux.o ../util/linux_osl.o ../util/bcmutils.o dhd_common.o dhd_custom_gpio.o	\
- 	wl_iw.o wl_cfg80211.o ../util/siutils.o ../util/sbutils.o ../util/aiutils.o ../util/hndpmu.o ../util/bcmwifi.o dhd_sdio.o	\
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
new file mode 100644
index 0000000..c80e11f
--- /dev/null
+++ b/patches/35-fix-makefile-includes.patch
@@ -0,0 +1,52 @@
+When some other headers are included in some makefile it must be 
+relative to the current object file processed. When giving the full 
+path the make process will search in the kernel tree for the headers.
+
+--- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
++++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
+@@ -2,4 +2,4 @@ rtl8180-objs		:= dev.o rtl8225.o sa2400.
+ 
+ obj-$(CONFIG_RTL8180)	+= rtl8180.o
+ 
+-ccflags-y += -Idrivers/net/wireless/rtl818x
++ccflags-y += -I$(obj)/..
+--- a/drivers/net/wireless/rtl818x/rtl8187/Makefile
++++ b/drivers/net/wireless/rtl818x/rtl8187/Makefile
+@@ -2,4 +2,4 @@ rtl8187-objs		:= dev.o rtl8225.o leds.o
+ 
+ obj-$(CONFIG_RTL8187)	+= rtl8187.o
+ 
+-ccflags-y += -Idrivers/net/wireless/rtl818x
++ccflags-y += -I$(obj)/..
+--- a/drivers/staging/brcm80211/Makefile
++++ b/drivers/staging/brcm80211/Makefile
+@@ -24,10 +24,10 @@ ccflags-y :=					\
+ 	-DDBAND					\
+ 	-DBCMDMA32				\
+ 	-DBCMNVRAMR				\
+-	-Idrivers/staging/brcm80211/sys		\
+-	-Idrivers/staging/brcm80211/phy		\
+-	-Idrivers/staging/brcm80211/util	\
+-	-Idrivers/staging/brcm80211/include
++	-I$(obj)/sys		\
++	-I$(obj)/phy		\
++	-I$(obj)/util	\
++	-I$(obj)/include
+ 
+ PCI_CFLAGS := -DWLC_LOW
+ 
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
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index b93761e..f23c33c 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -229,6 +229,8 @@ DRIVERS="$DRIVERS drivers/net/wireless/zd1211rw"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas"
 DRIVERS="$DRIVERS drivers/net/wireless/p54"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
+DRIVERS="$DRIVERS drivers/net/wireless/rtl818x/rtl8180"
+DRIVERS="$DRIVERS drivers/net/wireless/rtl818x/rtl8187"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
-- 
1.7.1

