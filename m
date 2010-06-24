Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46986 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0FXVAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 17:00:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: refresh patches
Date: Thu, 24 Jun 2010 23:00:04 +0200
Message-Id: <1277413205-6753-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refresh patches and backport netdev_ops for iwmc3200wifi

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   20 ++++++++++----------
 patches/01-netdev.patch                  |   26 ++++++++++++++------------
 patches/03-rfkill.patch                  |    2 +-
 patches/05-usb.patch                     |    2 +-
 patches/06-header-changes.patch          |   12 ------------
 patches/08-rename-iwl4965-config.patch   |    4 ++--
 patches/19-kfifo.patch                   |    8 ++++----
 patches/25-multicast-list_head.patch     |    4 ++--
 patches/28-pm-qos-params.patch           |    2 +-
 9 files changed, 35 insertions(+), 45 deletions(-)

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index 2649ee3..b64715f 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -105,15 +105,15 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -516,6 +517,7 @@ void ath_deinit_leds(struct ath_softc *s
- #define SC_OP_TSF_RESET              BIT(11)
+@@ -517,6 +518,7 @@ void ath_deinit_leds(struct ath_softc *s
  #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
  #define SC_OP_BT_SCAN		     BIT(13)
-+#define SC_OP_PKTLOGGING	     BIT(14)
+ #define SC_OP_ANI_RUN		     BIT(14)
++#define SC_OP_PKTLOGGING	     BIT(15)
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -594,6 +596,10 @@ struct ath_softc {
+@@ -595,6 +597,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -161,7 +161,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2396,7 +2396,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
+@@ -2417,7 +2417,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
  		phybits |= AR_PHY_ERR_RADAR;
  	if (bits & ATH9K_RX_FILTER_PHYERR)
  		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
@@ -172,7 +172,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		REG_WRITE(ah, AR_RXCFG,
 --- a/drivers/net/wireless/ath/ath9k/hw.h
 +++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -602,7 +602,7 @@ struct ath_hw_ops {
+@@ -603,7 +603,7 @@ struct ath_hw_ops {
  			    const void *ds0, dma_addr_t buf_addr,
  			    unsigned int qcu);
  	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -181,10 +181,10 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
  			      u32 pktLen, enum ath9k_pkt_type type,
  			      u32 txPower, u32 keyIx,
-@@ -819,6 +819,8 @@ struct ath_hw {
- 
- 	u32 paprd_gain_table_entries[PAPRD_GAIN_TABLE_ENTRIES];
- 	u8 paprd_gain_table_index[PAPRD_GAIN_TABLE_ENTRIES];
+@@ -826,6 +826,8 @@ struct ath_hw {
+ 	 * this register when in sleep states.
+ 	 */
+ 	u32 WARegVal;
 +
 +	bool is_pkt_logging;
  };
diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 98cb477..32afc2f 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -215,9 +215,20 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.spy_data = &priv->ieee->spy_data;
  	net_dev->wireless_data = &priv->wireless_data;
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
+--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
++++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
+@@ -129,7 +129,7 @@ void *iwm_if_alloc(int sizeof_bus, struc
+ 		goto out_priv;
+ 	}
+ 
+-	ndev->netdev_ops = &iwm_netdev_ops;
++	netdev_attach_ops(ndev, &iwm_netdev_ops);
+ 	ndev->ieee80211_ptr = wdev;
+ 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+ 	wdev->netdev = ndev;
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -968,7 +968,7 @@ struct lbs_private *lbs_add_card(void *c
+@@ -866,7 +866,7 @@ struct lbs_private *lbs_add_card(void *c
  	wdev->netdev = dev;
  	priv->dev = dev;
  
@@ -225,19 +236,10 @@ without creating a headache on maintenance of the pathes.
 +	netdev_attach_ops(dev, &lbs_netdev_ops);
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
- #ifdef	WIRELESS_EXT
-@@ -1304,7 +1304,7 @@ static int lbs_add_rtap(struct lbs_priva
- 
- 	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
- 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
--	rtap_dev->netdev_ops = &rtap_netdev_ops;
-+	netdev_attach_ops(rtap_dev, &rtap_netdev_ops);
- 	rtap_dev->ml_priv = priv;
- 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
- 
+ 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 --- a/drivers/net/wireless/libertas/mesh.c
 +++ b/drivers/net/wireless/libertas/mesh.c
-@@ -363,7 +363,7 @@ int lbs_add_mesh(struct lbs_private *pri
+@@ -364,7 +364,7 @@ int lbs_add_mesh(struct lbs_private *pri
  	mesh_dev->ml_priv = priv;
  	priv->mesh_dev = mesh_dev;
  
diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index c7c242b..2ddf967 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2171,7 +2171,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2192,7 +2192,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/patches/05-usb.patch b/patches/05-usb.patch
index 5d6fbda..a231b0f 100644
--- a/patches/05-usb.patch
+++ b/patches/05-usb.patch
@@ -14,7 +14,7 @@ USB opt soft_unbid was added as of 2.6.27.
  static int __init p54u_init(void)
 --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
 +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
-@@ -1030,7 +1030,9 @@ static struct usb_driver ath9k_hif_usb_d
+@@ -1039,7 +1039,9 @@ static struct usb_driver ath9k_hif_usb_d
  	.reset_resume = ath9k_hif_usb_resume,
  #endif
  	.id_table = ath9k_hif_usb_ids,
diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index b3c71fb..e0846f5 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -16,18 +16,6 @@ cases.
  
  struct b43_wldev;
  
---- a/drivers/net/wireless/libertas/assoc.c
-+++ b/drivers/net/wireless/libertas/assoc.c
-@@ -6,6 +6,9 @@
- #include <linux/if_arp.h>
- #include <linux/slab.h>
- #include <net/lib80211.h>
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+#include <asm/unaligned.h>
-+#endif
- 
- #include "assoc.h"
- #include "decl.h"
 --- a/drivers/net/wireless/wl12xx/wl1251_main.c
 +++ b/drivers/net/wireless/wl12xx/wl1251_main.c
 @@ -26,6 +26,9 @@
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 1329994..681ff22 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -6,7 +6,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
 --- a/drivers/net/wireless/iwlwifi/Makefile
 +++ b/drivers/net/wireless/iwlwifi/Makefile
 @@ -14,7 +14,7 @@ iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-
- iwlagn-objs		+= iwl-agn-lib.o
+ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o iwl-agn-calib.o
  iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
  
 -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4080,10 +4080,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4079,10 +4079,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
index b957599..66a0287 100644
--- a/patches/19-kfifo.patch
+++ b/patches/19-kfifo.patch
@@ -3,7 +3,7 @@ not be backported easily with defines in the compat module.
 
 --- a/drivers/net/wireless/libertas/dev.h
 +++ b/drivers/net/wireless/libertas/dev.h
-@@ -125,7 +125,11 @@ struct lbs_private {
+@@ -126,7 +126,11 @@ struct lbs_private {
  	u32 resp_len[2];
  
  	/* Events sent from hardware to driver */
@@ -17,7 +17,7 @@ not be backported easily with defines in the compat module.
  	struct task_struct *main_thread;
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -887,8 +887,14 @@ static int lbs_init_adapter(struct lbs_p
+@@ -788,8 +788,14 @@ static int lbs_init_adapter(struct lbs_p
  	priv->resp_len[0] = priv->resp_len[1] = 0;
  
  	/* Create the event FIFO */
@@ -32,7 +32,7 @@ not be backported easily with defines in the compat module.
  		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
  		goto out;
  	}
-@@ -904,7 +910,12 @@ static void lbs_free_adapter(struct lbs_
+@@ -805,7 +811,12 @@ static void lbs_free_adapter(struct lbs_
  	lbs_deb_enter(LBS_DEB_MAIN);
  
  	lbs_free_cmd_buffer(priv);
@@ -44,4 +44,4 @@ not be backported easily with defines in the compat module.
 +#endif
  	del_timer(&priv->command_timer);
  	del_timer(&priv->auto_deepsleep_timer);
- 	kfree(priv->networks);
+ 
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index d90e4b1..f7304cb 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -229,7 +229,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return ((u64)(mfilt[1]) << 32) | mfilt[0];
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -328,18 +328,34 @@ static int lbs_add_mcast_addrs(struct cm
+@@ -247,18 +247,34 @@ static int lbs_add_mcast_addrs(struct cm
  	netif_addr_lock_bh(dev);
  	cnt = netdev_mc_count(dev);
  	netdev_for_each_mc_addr(ha, dev) {
@@ -576,7 +576,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return hash.low | ((u64)hash.high << 32);
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1686,7 +1686,11 @@ struct ieee80211_ops {
+@@ -1695,7 +1695,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
index 20cbc28..204ade5 100644
--- a/patches/28-pm-qos-params.patch
+++ b/patches/28-pm-qos-params.patch
@@ -61,7 +61,7 @@
  module_init(ipw2100_init);
 --- a/net/mac80211/mlme.c
 +++ b/net/mac80211/mlme.c
-@@ -556,7 +556,11 @@ void ieee80211_recalc_ps(struct ieee8021
+@@ -590,7 +590,11 @@ void ieee80211_recalc_ps(struct ieee8021
  		s32 beaconint_us;
  
  		if (latency < 0)
-- 
1.7.0.4

