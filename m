Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47645 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0ECSf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 14:35:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patches
Date: Mon,  3 May 2010 20:35:46 +0200
Message-Id: <1272911746-17268-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the patches apply cleanly again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch |   26 +++++++++++++-------------
 patches/26-sdio-quirks.patch         |    4 ++--
 patches/99-change-makefiles.patch    |    5 +++--
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index d18735c..3cfde8a 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -124,7 +124,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return mc_filter[0] | ((u64)(mc_filter[1]) << 32);
 --- a/drivers/net/wireless/ath/ar9170/main.c
 +++ b/drivers/net/wireless/ath/ar9170/main.c
-@@ -2047,17 +2047,35 @@ out:
+@@ -2046,17 +2046,35 @@ out:
  	return err;
  }
  
@@ -174,7 +174,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void ath5k_configure_filter(struct ieee80211_hw *hw,
  		unsigned int changed_flags,
  		unsigned int *new_flags,
-@@ -3108,20 +3112,42 @@ unlock:
+@@ -3107,20 +3111,42 @@ unlock:
  }
  
  static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -217,7 +217,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3130,6 +3156,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -3129,6 +3155,9 @@ static u64 ath5k_prepare_multicast(struc
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -305,7 +305,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/mwl8k.c
 +++ b/drivers/net/wireless/mwl8k.c
-@@ -1939,15 +1939,21 @@ struct mwl8k_cmd_mac_multicast_adr {
+@@ -1937,15 +1937,21 @@ struct mwl8k_cmd_mac_multicast_adr {
  
  static struct mwl8k_cmd_pkt *
  __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
@@ -327,7 +327,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	if (allmulti || mc_count > priv->num_mcaddrs) {
  		allmulti = 1;
-@@ -1968,13 +1974,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
+@@ -1966,13 +1972,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
  	if (allmulti) {
  		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_ALL_MULTICAST);
  	} else if (mc_count) {
@@ -355,7 +355,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		}
  	}
  
-@@ -3553,7 +3573,11 @@ mwl8k_bss_info_changed(struct ieee80211_
+@@ -3551,7 +3571,11 @@ mwl8k_bss_info_changed(struct ieee80211_
  }
  
  static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
@@ -367,7 +367,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  {
  	struct mwl8k_cmd_pkt *cmd;
  
-@@ -3564,7 +3588,11 @@ static u64 mwl8k_prepare_multicast(struc
+@@ -3562,7 +3586,11 @@ static u64 mwl8k_prepare_multicast(struc
  	 * we'll end up throwing this packet away and creating a new
  	 * one in mwl8k_configure_filter().
  	 */
@@ -379,7 +379,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	return (unsigned long)cmd;
  }
-@@ -3687,7 +3715,11 @@ static void mwl8k_configure_filter(struc
+@@ -3685,7 +3713,11 @@ static void mwl8k_configure_filter(struc
  	 */
  	if (*total_flags & FIF_ALLMULTI) {
  		kfree(cmd);
@@ -433,7 +433,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
 +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
-@@ -724,10 +724,19 @@ static void rtl8180_bss_info_changed(str
+@@ -725,10 +725,19 @@ static void rtl8180_bss_info_changed(str
  	        priv->rf->conf_erp(dev, info);
  }
  
@@ -475,7 +475,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 --- a/drivers/net/wireless/wl12xx/wl1271_main.c
 +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
-@@ -1305,11 +1305,20 @@ struct wl1271_filter_params {
+@@ -1344,11 +1344,20 @@ struct wl1271_filter_params {
  	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
  };
  
@@ -494,9 +494,9 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
 +	int i;
 +#endif
  	struct wl1271 *wl = hw->priv;
- 	int i;
  
-@@ -1323,16 +1332,40 @@ static u64 wl1271_op_prepare_multicast(s
+ 	if (unlikely(wl->state == WL1271_STATE_OFF))
+@@ -1361,16 +1370,40 @@ static u64 wl1271_op_prepare_multicast(s
  	}
  
  	/* update multicast filtering parameters */
@@ -576,7 +576,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return hash.low | ((u64)hash.high << 32);
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1642,7 +1642,11 @@ struct ieee80211_ops {
+@@ -1646,7 +1646,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
diff --git a/patches/26-sdio-quirks.patch b/patches/26-sdio-quirks.patch
index 2fec33d..133e9bb 100644
--- a/patches/26-sdio-quirks.patch
+++ b/patches/26-sdio-quirks.patch
@@ -2,7 +2,7 @@ The quirks attribute is not available on older kernels.
 
 --- a/drivers/net/wireless/libertas/if_sdio.c
 +++ b/drivers/net/wireless/libertas/if_sdio.c
-@@ -1003,6 +1003,7 @@ static int if_sdio_probe(struct sdio_fun
+@@ -1005,6 +1005,7 @@ static int if_sdio_probe(struct sdio_fun
  	if (ret)
  		goto disable;
  
@@ -10,7 +10,7 @@ The quirks attribute is not available on older kernels.
  	/* For 1-bit transfers to the 8686 model, we need to enable the
  	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
  	 * bit to allow access to non-vendor registers. */
-@@ -1021,6 +1022,7 @@ static int if_sdio_probe(struct sdio_fun
+@@ -1023,6 +1024,7 @@ static int if_sdio_probe(struct sdio_fun
  		if (ret)
  			goto release_int;
  	}
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index ad7ccc5..47f3b5c 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,26 +2,6 @@
+@@ -2,27 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -39,7 +39,8 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 -obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
 -obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
--
+-obj-$(CONFIG_USB_SIERRA_NET)	+= sierra_net.o
+ 
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
 @@ -7,31 +7,16 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
-- 
1.7.0.4

