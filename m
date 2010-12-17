Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56958 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab0LQWm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:42:57 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patches apply again.
Date: Fri, 17 Dec 2010 23:42:46 +0100
Message-Id: <1292625768-17318-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch |   18 +++++++++---------
 patches/99-change-makefiles.patch    |    7 ++++---
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 09099ff..8ad8391 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -162,7 +162,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -3122,20 +3122,42 @@ unlock:
+@@ -3131,20 +3131,42 @@ unlock:
  }
  
  static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -205,7 +205,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3144,6 +3166,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -3153,6 +3175,9 @@ static u64 ath5k_prepare_multicast(struc
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -501,7 +501,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 --- a/drivers/net/wireless/wl12xx/main.c
 +++ b/drivers/net/wireless/wl12xx/main.c
-@@ -1481,11 +1481,20 @@ struct wl1271_filter_params {
+@@ -1501,11 +1501,20 @@ struct wl1271_filter_params {
  	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
  };
  
@@ -522,7 +522,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	struct wl1271 *wl = hw->priv;
  
  	if (unlikely(wl->state == WL1271_STATE_OFF))
-@@ -1498,16 +1507,40 @@ static u64 wl1271_op_prepare_multicast(s
+@@ -1518,16 +1527,40 @@ static u64 wl1271_op_prepare_multicast(s
  	}
  
  	/* update multicast filtering parameters */
@@ -607,11 +607,11 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		if (!cnt)
  			break;
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 		memcpy(bufp, ha->addr, ETHER_ADDR_LEN);
+ 		memcpy(bufp, ha->addr, ETH_ALEN);
 +#else
-+		memcpy(bufp, ha->dmi_addr, ETHER_ADDR_LEN);
++		memcpy(bufp, ha->dmi_addr, ETH_ALEN);
 +#endif
- 		bufp += ETHER_ADDR_LEN;
+ 		bufp += ETH_ALEN;
  		cnt--;
  	}
 --- a/include/net/mac80211.h
@@ -677,7 +677,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/ieee80211_i.h
 +++ b/net/mac80211/ieee80211_i.h
-@@ -718,7 +718,12 @@ struct ieee80211_local {
+@@ -719,7 +719,12 @@ struct ieee80211_local {
  	struct work_struct recalc_smps;
  
  	/* aggregated multicast list */
@@ -733,7 +733,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  
  	/* be a bit nasty */
-@@ -550,9 +554,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
+@@ -555,9 +559,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
  
  	INIT_LIST_HEAD(&local->interfaces);
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 5114869..42c7ea3 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -45,7 +45,7 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-@@ -7,31 +7,16 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
+@@ -7,32 +7,16 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
  
  obj-$(CONFIG_HERMES)		+= orinoco/
  
@@ -66,11 +66,12 @@ only the wireless stuff.
  obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
  obj-$(CONFIG_RTL8180)		+= rtl818x/
  obj-$(CONFIG_RTL8187)		+= rtl818x/
- 
+-obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
+-
 -# 16-bit wireless PCMCIA client drivers
 -obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
 -obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
--
+ 
  obj-$(CONFIG_USB_NET_COMPAT_RNDIS_WLAN)	+= rndis_wlan.o
  
 -obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
-- 
1.7.1

