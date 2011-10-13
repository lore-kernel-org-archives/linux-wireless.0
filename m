Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53221 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab1JMOQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:16:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: adapt moving brcm80211 to main area
Date: Thu, 13 Oct 2011 16:16:34 +0200
Message-Id: <1318515394-9284-1-git-send-email-hauke@hauke-m.de> (sfid-20111013_161654_256481_BBAF9355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcm80211 is no staging driver any more and can be found in the main
area where all the other wireless drivers are now. There where some
changes needed for the move.
And BRCMFMAC does not depend on WEXT any more so remove that from
config.
BRCMFMAC does not build with kernel < 2.6.29, because
ndev->netdev_ops = NULL and ndev->netdev_ops == &brcmf_netdev_ops_pri
are not supported by the backport code for netdev_ops.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                               |    1 -
 config.mk                              |   12 +--------
 patches/25-multicast-list_head.patch   |   32 +++++++++++++-------------
 patches/29-sdio_no_suspend.patch       |   18 +++++++-------
 patches/35-fix-makefile-includes.patch |   26 ++++++++++----------
 scripts/admin-update.sh                |    8 +++++-
 scripts/driver-select                  |   39 +++++++++++++++++++++----------
 7 files changed, 73 insertions(+), 63 deletions(-)

diff --git a/Makefile b/Makefile
index 6fe77b8..d3a9d93 100644
--- a/Makefile
+++ b/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/bcma/
 obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/misc/eeprom/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
-obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
 endif
 
 endif
diff --git a/config.mk b/config.mk
index 3463f83..a71de4e 100644
--- a/config.mk
+++ b/config.mk
@@ -396,9 +396,7 @@ CONFIG_RTL8192CE=m
 CONFIG_RTL8192SE=m
 CONFIG_RTL8192DE=m
 
-ifdef CONFIG_COMPAT_STAGING
 CONFIG_BRCMSMAC=m
-endif #CONFIG_COMPAT_STAGING
 
 endif #CONFIG_PCI
 ## end of PCI
@@ -572,13 +570,9 @@ CONFIG_ATH6KL=m
 # CONFIG_ATH6KL_DEBUG=y
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 
-ifdef CONFIG_COMPAT_STAGING
-ifdef CONFIG_WIRELESS_EXT
-
+ifndef CONFIG_COMPAT_KERNEL_2_6_29
 CONFIG_BRCMFMAC=m
-
-endif #CONFIG_WIRELESS_EXT
-endif #CONFIG_COMPAT_STAGING
+endif #CONFIG_COMPAT_KERNEL_2_6_29
 
 endif #CONFIG_MMC
 
@@ -614,10 +608,8 @@ endif #CONFIG_MAC80211_LEDS
 CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
-ifdef CONFIG_COMPAT_STAGING
 CONFIG_BRCMUTIL=m
 # CONFIG_BRCMDBG=y
-endif #CONFIG_COMPAT_STAGING
 
 ifdef CONFIG_CRC7
 CONFIG_WL1251=m
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index e3e99e6..25fa450 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -83,7 +83,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/adm8211.c
 +++ b/drivers/net/wireless/adm8211.c
-@@ -1319,19 +1319,37 @@ static void adm8211_bss_info_changed(str
+@@ -1320,19 +1320,37 @@ static void adm8211_bss_info_changed(str
  }
  
  static u64 adm8211_prepare_multicast(struct ieee80211_hw *hw,
@@ -217,7 +217,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -311,18 +311,34 @@ static int lbs_add_mcast_addrs(struct cm
+@@ -313,18 +313,34 @@ static int lbs_add_mcast_addrs(struct cm
  	netif_addr_lock_bh(dev);
  	cnt = netdev_mc_count(dev);
  	netdev_for_each_mc_addr(ha, dev) {
@@ -254,7 +254,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/drivers/net/wireless/libertas_tf/main.c
 +++ b/drivers/net/wireless/libertas_tf/main.c
-@@ -418,20 +418,36 @@ static int lbtf_op_config(struct ieee802
+@@ -419,20 +419,36 @@ static int lbtf_op_config(struct ieee802
  }
  
  static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
@@ -435,7 +435,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  			      size_t fw_name_len, u32 *hw_ver);
 --- a/drivers/net/wireless/p54/main.c
 +++ b/drivers/net/wireless/p54/main.c
-@@ -359,11 +359,18 @@ out:
+@@ -360,11 +360,18 @@ out:
  	return ret;
  }
  
@@ -454,7 +454,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	int i;
  
  	BUILD_BUG_ON(ARRAY_SIZE(priv->mc_maclist) !=
-@@ -373,12 +380,23 @@ static u64 p54_prepare_multicast(struct
+@@ -374,12 +381,23 @@ static u64 p54_prepare_multicast(struct
  	 * Otherwise the firmware will drop it and ARP will no longer work.
  	 */
  	i = 1;
@@ -494,7 +494,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
 +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
-@@ -813,10 +813,19 @@ static void rtl8180_bss_info_changed(str
+@@ -814,10 +814,19 @@ static void rtl8180_bss_info_changed(str
  	}
  }
  
@@ -516,7 +516,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
 +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
-@@ -1204,9 +1204,17 @@ static void rtl8187_bss_info_changed(str
+@@ -1205,9 +1205,17 @@ static void rtl8187_bss_info_changed(str
  }
  
  static u64 rtl8187_prepare_multicast(struct ieee80211_hw *dev,
@@ -536,7 +536,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 --- a/drivers/net/wireless/wl12xx/main.c
 +++ b/drivers/net/wireless/wl12xx/main.c
-@@ -2467,11 +2467,20 @@ struct wl1271_filter_params {
+@@ -2464,11 +2464,20 @@ struct wl1271_filter_params {
  	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
  };
  
@@ -557,7 +557,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	struct wl1271 *wl = hw->priv;
  
  	if (unlikely(wl->state == WL1271_STATE_OFF))
-@@ -2484,16 +2493,40 @@ static u64 wl1271_op_prepare_multicast(s
+@@ -2481,16 +2490,40 @@ static u64 wl1271_op_prepare_multicast(s
  	}
  
  	/* update multicast filtering parameters */
@@ -635,10 +635,10 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
  
  	return hash.low | ((u64)hash.high << 32);
---- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
-+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
-@@ -213,7 +213,11 @@ static void _brcmf_set_multicast_list(st
- 	netdev_for_each_mc_addr(ha, dev) {
+--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
++++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+@@ -172,7 +172,11 @@ static void _brcmf_set_multicast_list(st
+ 	netdev_for_each_mc_addr(ha, ndev) {
  		if (!cnt)
  			break;
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
@@ -651,7 +651,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1960,7 +1960,11 @@ struct ieee80211_ops {
+@@ -2112,7 +2112,11 @@ struct ieee80211_ops {
  			       enum ieee80211_tx_sync_type type);
  
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
@@ -712,7 +712,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -776,7 +776,12 @@ struct ieee80211_local {
+@@ -780,7 +780,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
@@ -768,7 +768,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  
  	/* be a bit nasty */
-@@ -616,9 +620,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
+@@ -630,9 +634,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
  
  	INIT_LIST_HEAD(&local->interfaces);
diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 1d09d34..934eb94 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -96,7 +96,7 @@ suspend and resume that are not backported.
  /*******************************************************************/
 --- a/drivers/net/wireless/mwifiex/sdio.c
 +++ b/drivers/net/wireless/mwifiex/sdio.c
-@@ -126,8 +126,10 @@ mwifiex_sdio_remove(struct sdio_func *fu
+@@ -127,8 +127,10 @@ mwifiex_sdio_remove(struct sdio_func *fu
  		return;
  
  	if (user_rmmod) {
@@ -107,7 +107,7 @@ suspend and resume that are not backported.
  
  		for (i = 0; i < adapter->priv_num; i++)
  			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-@@ -147,6 +149,7 @@ mwifiex_sdio_remove(struct sdio_func *fu
+@@ -148,6 +150,7 @@ mwifiex_sdio_remove(struct sdio_func *fu
  	kfree(card);
  }
  
@@ -115,7 +115,7 @@ suspend and resume that are not backported.
  /*
   * SDIO suspend.
   *
-@@ -254,6 +257,7 @@ static int mwifiex_sdio_resume(struct de
+@@ -255,6 +258,7 @@ static int mwifiex_sdio_resume(struct de
  
  	return 0;
  }
@@ -123,7 +123,7 @@ suspend and resume that are not backported.
  
  /* Device ID for SD8787 */
  #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
-@@ -266,10 +270,12 @@ static const struct sdio_device_id mwifi
+@@ -267,10 +271,12 @@ static const struct sdio_device_id mwifi
  
  MODULE_DEVICE_TABLE(sdio, mwifiex_ids);
  
@@ -136,7 +136,7 @@ suspend and resume that are not backported.
  
  static struct sdio_driver mwifiex_sdio = {
  	.name = "mwifiex_sdio",
-@@ -278,7 +284,9 @@ static struct sdio_driver mwifiex_sdio =
+@@ -279,7 +285,9 @@ static struct sdio_driver mwifiex_sdio =
  	.remove = mwifiex_sdio_remove,
  	.drv = {
  		.owner = THIS_MODULE,
@@ -146,8 +146,8 @@ suspend and resume that are not backported.
  	}
  };
  
---- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
-+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
++++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 @@ -55,7 +55,7 @@ static bool
  brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
  {
@@ -166,7 +166,7 @@ suspend and resume that are not backported.
  	int retry = 0;
  	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
  		wait_event_timeout(*wq, false, HZ/100);
-@@ -564,7 +564,7 @@ static void brcmf_ops_sdio_remove(struct
+@@ -550,7 +550,7 @@ static void brcmf_ops_sdio_remove(struct
  	}
  }
  
@@ -175,7 +175,7 @@ suspend and resume that are not backported.
  static int brcmf_sdio_suspend(struct device *dev)
  {
  	mmc_pm_flag_t sdio_flags;
-@@ -617,7 +617,7 @@ static struct sdio_driver brcmf_sdmmc_dr
+@@ -603,7 +603,7 @@ static struct sdio_driver brcmf_sdmmc_dr
  	.remove = brcmf_ops_sdio_remove,
  	.name = "brcmfmac",
  	.id_table = brcmf_sdmmc_ids,
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index c9f8eb1..3207ab0 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -18,42 +18,42 @@ path the make process will search in the kernel tree for the headers.
  
 -ccflags-y += -Idrivers/net/wireless/rtl818x
 +ccflags-y += -I$(obj)/..
---- a/drivers/staging/brcm80211/brcmfmac/Makefile
-+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
+--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
++++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
 @@ -16,8 +16,8 @@
  # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  ccflags-y += \
--	-Idrivers/staging/brcm80211/brcmfmac	\
--	-Idrivers/staging/brcm80211/include
+-	-Idrivers/net/wireless/brcm80211/brcmfmac	\
+-	-Idrivers/net/wireless/brcm80211/include
 +	-I$(obj)		\
 +	-I$(obj)/../include
  
  DHDOFILES = \
  	wl_cfg80211.o \
---- a/drivers/staging/brcm80211/brcmsmac/Makefile
-+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
+--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
++++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
 @@ -17,9 +17,9 @@
  
  ccflags-y := \
  	-D__CHECK_ENDIAN__ \
--	-Idrivers/staging/brcm80211/brcmsmac \
--	-Idrivers/staging/brcm80211/brcmsmac/phy \
--	-Idrivers/staging/brcm80211/include
+-	-Idrivers/net/wireless/brcm80211/brcmsmac \
+-	-Idrivers/net/wireless/brcm80211/brcmsmac/phy \
+-	-Idrivers/net/wireless/brcm80211/include
 +	-I$(obj)				\
 +	-I$(obj)/phy				\
 +	-I$(obj)/../include
  
  BRCMSMAC_OFILES := \
  	mac80211_if.o \
---- a/drivers/staging/brcm80211/brcmutil/Makefile
-+++ b/drivers/staging/brcm80211/brcmutil/Makefile
+--- a/drivers/net/wireless/brcm80211/brcmutil/Makefile
++++ b/drivers/net/wireless/brcm80211/brcmutil/Makefile
 @@ -16,8 +16,8 @@
  # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  ccflags-y :=				\
--	-Idrivers/staging/brcm80211/brcmutil \
--	-Idrivers/staging/brcm80211/include
+-	-Idrivers/net/wireless/brcm80211/brcmutil \
+-	-Idrivers/net/wireless/brcm80211/include
 +	-I$(obj)			\
 +	-I$(obj)/../include
  
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 061748c..3e63e51 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -224,6 +224,12 @@ DRIVERS="$DRIVERS drivers/ssb"
 DRIVERS="$DRIVERS drivers/bcma"
 DRIVERS="$DRIVERS drivers/net/wireless/b43"
 DRIVERS="$DRIVERS drivers/net/wireless/b43legacy"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211/brcmfmac"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211/brcmsmac"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211/brcmsmac/phy"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211/brcmutil"
+DRIVERS="$DRIVERS drivers/net/wireless/brcm80211/include"
 DRIVERS="$DRIVERS drivers/net/wireless/iwlegacy"
 DRIVERS="$DRIVERS drivers/net/wireless/iwlwifi"
 DRIVERS="$DRIVERS drivers/net/wireless/rt2x00"
@@ -248,7 +254,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
 DRIVERS="$DRIVERS drivers/net/wireless/mwifiex"
 
 # Staging drivers
-STAGING_DRIVERS="drivers/staging/brcm80211"
+STAGING_DRIVERS=""
 
 # Ethernet drivers
 DRIVERS="$DRIVERS drivers/net/ethernet/atheros"
diff --git a/scripts/driver-select b/scripts/driver-select
index f571519..3619541 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -7,6 +7,7 @@
 DRIVERS_MAKEFILE="drivers/net/wireless/Makefile"
 ATH_MAKEFILE="drivers/net/wireless/ath/Makefile"
 ATH9K_MAKEFILE="drivers/net/wireless/ath/ath9k/Makefile"
+BRCM80211_MAKEFILE="drivers/net/wireless/brcm80211/Makefile"
 RT2X00_MAKEFILE="drivers/net/wireless/rt2x00/Makefile"
 NET_WIRELESS_MAKEFILE="net/wireless/Makefile"
 EEPROM_MAKEFILE="drivers/misc/eeprom/Makefile"
@@ -32,11 +33,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 ath6kl b43 zd1211rw rt2x00 wl1251 wl12xx"
-
-if [ -d drivers/staging/brcm80211 ]; then
-	SUPPORTED_80211_DRIVERS="$SUPPORTED_80211_DRIVERS brcm80211"
-fi
+SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 ath6kl b43 zd1211rw rt2x00 wl1251 wl12xx brcmsmac brcmfmac"
 
 # b43 needs some more work for driver-select, the SSB stuff, plus
 # what if you update b44 but not b43? It will bust.
@@ -55,6 +52,7 @@ function usage {
 	echo -e "\nSupported group drivers:"
 	echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k carl9170 zd1211rw ath6kl ${NORMAL}>"
 	echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ath6kl ${NORMAL}>"
+	echo -e "\t${CYAN}brcm80211${NORMAL} < ${PURPLE} brcmsmac brcmfmac ${NORMAL}>"
 	echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
@@ -220,11 +218,6 @@ function disable_staging {
 	perl -i -ne 'print if ! /CONFIG_COMPAT_STAGING/ ' Makefile
 }
 
-function disable_brcm80211 {
-	backup_file Makefile
-	perl -i -ne 'print if ! /brcm80211/ ' Makefile
-}
-
 function disable_update-initramfs
 {
 	backup_file Makefile
@@ -244,6 +237,12 @@ function select_ath9k_driver
 	# In the future here we'll add stuff to disable ath9k_htc
 }
 
+function select_brcm80211_driver 
+{
+	backup_file $BRCM80211_MAKEFILE
+	perl -i -ne 'print if /'$1'/ || /CONFIG_BRCMUTIL/ ' $BRCM80211_MAKEFILE
+}
+
 function restore_file {
 	#ORIG=$(shell ${1%%.${BACKUP_EXT}})
 	ORIG=${1%%.bk}
@@ -306,7 +305,6 @@ case $1 in
 		;;
 	ath)
 		disable_bt_usb_ethernet_var
-		disable_brcm80211
 		select_drivers		CONFIG_ATH_COMMON
 		disable_var_01
 		;;
@@ -347,6 +345,13 @@ case $1 in
 		disable_staging
 		disable_var_01
 		;;
+	brcm80211)
+		disable_staging
+		disable_bt_usb_ethernet_var
+		select_drivers		CONFIG_BRCMUTIL \
+					CONFIG_BRCMFMAC \
+					CONFIG_BRCMSMAC
+		;;
 # Singular modules
 	ath5k)
 		disable_staging
@@ -379,9 +384,17 @@ case $1 in
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_ATH6KL
 		;;
-	brcm80211)
+	brcmsmac)
+		disable_staging
+		disable_bt_usb_ethernet_var
+		select_drivers		CONFIG_BRCMUTIL CONFIG_BRCMFMAC
+		select_brcm80211_driver	CONFIG_BRCMSMAC
+		;;
+	brcmfmac)
+		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_NOTHING
+		select_drivers		CONFIG_BRCMUTIL CONFIG_BRCMFMAC
+		select_brcm80211_driver	CONFIG_BRCMFMAC
 		;;
 	zd1211rw)
 		select_driver		CONFIG_COMPAT_ZD1211RW
-- 
1.7.4.1

