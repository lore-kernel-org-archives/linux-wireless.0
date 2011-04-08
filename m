Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48512 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531Ab1DHTJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 15:09:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: remove ar9170
Date: Fri,  8 Apr 2011 21:08:51 +0200
Message-Id: <1302289731-28482-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar9170 was replaced by carl9170 and is now removed from kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                            |    7 -----
 patches/25-multicast-list_head.patch |   50 ++++-----------------------------
 scripts/admin-update.sh              |    1 -
 scripts/driver-select                |    6 ----
 4 files changed, 6 insertions(+), 58 deletions(-)

diff --git a/config.mk b/config.mk
index 846d2e0..37f32a1 100644
--- a/config.mk
+++ b/config.mk
@@ -426,13 +426,6 @@ endif #CONFIG_MAC80211_LEDS
 
 CONFIG_AT76C50X_USB=m
 
-ifndef CONFIG_COMPAT_KERNEL_28
-CONFIG_AR9170_USB=m
-ifdef CONFIG_MAC80211_LEDS
-CONFIG_AR9170_LEDS=y
-endif #CONFIG_MAC80211_LEDS
-endif #CONFIG_COMPAT_KERNEL_28
-
 ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_CARL9170=m
 ifdef CONFIG_MAC80211_LEDS
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 087cb0a..5c36416 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -122,44 +122,6 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
  
  	return mc_filter[0] | ((u64)(mc_filter[1]) << 32);
---- a/drivers/net/wireless/ath/ar9170/main.c
-+++ b/drivers/net/wireless/ath/ar9170/main.c
-@@ -1606,17 +1606,35 @@ out:
- 	return err;
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- static u64 ar9170_op_prepare_multicast(struct ieee80211_hw *hw,
- 				       struct netdev_hw_addr_list *mc_list)
-+#else
-+static u64 ar9170_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
-+				       struct dev_addr_list *ha)
-+#endif
- {
- 	u64 mchash;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 	struct netdev_hw_addr *ha;
-+#else
-+	int i;
-+#endif
- 
- 	/* always get broadcast frames */
- 	mchash = 1ULL << (0xff >> 2);
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 	netdev_hw_addr_list_for_each(ha, mc_list)
- 		mchash |= 1ULL << (ha->addr[5] >> 2);
-+#else
-+	for (i = 0; i < mc_count; i++) {
-+		if (WARN_ON(!ha))
-+			break;
-+		mchash |= 1ULL << (ha->dmi_addr[5] >> 2);
-+		ha = ha->next;
-+	}
-+#endif
- 
- 	return mchash;
- }
 --- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
 +++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
 @@ -322,20 +322,42 @@ ath5k_bss_info_changed(struct ieee80211_
@@ -363,7 +325,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	p += sprintf(p, "num_tx_bytes = %lu\n", priv->stats.tx_bytes);
 --- a/drivers/net/wireless/mwl8k.c
 +++ b/drivers/net/wireless/mwl8k.c
-@@ -2466,15 +2466,21 @@ struct mwl8k_cmd_mac_multicast_adr {
+@@ -2467,15 +2467,21 @@ struct mwl8k_cmd_mac_multicast_adr {
  
  static struct mwl8k_cmd_pkt *
  __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
@@ -385,7 +347,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	if (allmulti || mc_count > priv->num_mcaddrs) {
  		allmulti = 1;
-@@ -2495,13 +2501,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
+@@ -2496,13 +2502,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
  	if (allmulti) {
  		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_ALL_MULTICAST);
  	} else if (mc_count) {
@@ -413,7 +375,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		}
  	}
  
-@@ -4642,7 +4662,11 @@ mwl8k_bss_info_changed(struct ieee80211_
+@@ -4652,7 +4672,11 @@ mwl8k_bss_info_changed(struct ieee80211_
  }
  
  static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
@@ -425,7 +387,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  {
  	struct mwl8k_cmd_pkt *cmd;
  
-@@ -4653,7 +4677,11 @@ static u64 mwl8k_prepare_multicast(struc
+@@ -4663,7 +4687,11 @@ static u64 mwl8k_prepare_multicast(struc
  	 * we'll end up throwing this packet away and creating a new
  	 * one in mwl8k_configure_filter().
  	 */
@@ -437,7 +399,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	return (unsigned long)cmd;
  }
-@@ -4775,7 +4803,11 @@ static void mwl8k_configure_filter(struc
+@@ -4785,7 +4813,11 @@ static void mwl8k_configure_filter(struc
  	 */
  	if (*total_flags & FIF_ALLMULTI) {
  		kfree(cmd);
@@ -648,7 +610,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1826,7 +1826,11 @@ struct ieee80211_ops {
+@@ -1837,7 +1837,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 0a1225e..3310278 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -217,7 +217,6 @@ fi
 # Drivers that have their own directory
 DRIVERS="drivers/net/wireless/ath"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
-DRIVERS="$DRIVERS drivers/net/wireless/ath/ar9170"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
 DRIVERS="$DRIVERS drivers/ssb"
diff --git a/scripts/driver-select b/scripts/driver-select
index 69531f0..5abf81b 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -215,11 +215,6 @@ function disable_ath6kl {
 	perl -i -ne 'print if ! /ath6kl/ ' Makefile
 }
 
-function disable_ar9170 {
-	backup_file drivers/net/wireless/ath/Makefile
-	perl -i -ne 'print if ! /ar9170/ ' drivers/net/wireless/ath/Makefile
-}
-
 function disable_brcm80211 {
 	backup_file Makefile
 	perl -i -ne 'print if ! /brcm80211/ ' Makefile
@@ -306,7 +301,6 @@ case $1 in
 	ath)
 		disable_bt_usb_ethernet_var
 		disable_brcm80211
-		disable_ar9170
 		select_drivers		CONFIG_ATH_COMMON
 		disable_var_01
 		;;
-- 
1.7.1

