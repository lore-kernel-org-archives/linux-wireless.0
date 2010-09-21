Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51736 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IUU0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 16:26:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wirelsss: refresh patches
Date: Tue, 21 Sep 2010 22:26:30 +0200
Message-Id: <1285100791-384-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

33-autoconf.patch is removed because it is not needed any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   36 +++++++++++++++---------------
 patches/11-dev-pm-ops.patch              |   15 ++++++-----
 patches/25-multicast-list_head.patch     |   28 ++++++----------------
 patches/33-autoconf.patch                |   15 ------------
 4 files changed, 34 insertions(+), 60 deletions(-)
 delete mode 100644 patches/33-autoconf.patch

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index 9206382..af85bdf 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -34,9 +34,9 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
 
 --- a/drivers/net/wireless/ath/ath9k/Kconfig
 +++ b/drivers/net/wireless/ath/ath9k/Kconfig
-@@ -32,6 +32,13 @@ config ATH9K_DEBUGFS
- 
- 	  Also required for changing debug message flags at run time.
+@@ -40,6 +40,13 @@ config ATH9K_RATE_CONTROL
+ 	  Say Y, if you want to use the ath9k specific rate control
+ 	  module instead of minstrel_ht.
  
 +config ATH9K_PKTLOG
 +	bool "ath9k packet logging support"
@@ -48,14 +48,14 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  config ATH9K_HTC
         tristate "Atheros HTC based wireless cards support"
         depends on USB && MAC80211
-@@ -53,3 +60,4 @@ config ATH9K_HTC_DEBUGFS
+@@ -61,3 +68,4 @@ config ATH9K_HTC_DEBUGFS
  	depends on ATH9K_HTC && DEBUG_FS
  	---help---
  	  Say Y, if you need access to ath9k_htc's statistics.
 +
 --- a/drivers/net/wireless/ath/ath9k/Makefile
 +++ b/drivers/net/wireless/ath/ath9k/Makefile
-@@ -10,6 +10,7 @@ ath9k-y +=	beacon.o \
+@@ -10,6 +10,7 @@ ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc
  ath9k-$(CONFIG_PCI) += pci.o
  ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
  ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
@@ -105,7 +105,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -568,6 +569,7 @@ struct ath_ant_comb {
+@@ -566,6 +567,7 @@ struct ath_ant_comb {
  #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
  #define SC_OP_BT_SCAN		     BIT(13)
  #define SC_OP_ANI_RUN		     BIT(14)
@@ -113,7 +113,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -646,6 +648,10 @@ struct ath_softc {
+@@ -644,6 +646,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -126,7 +126,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	struct ath_btcoex btcoex;
 --- a/drivers/net/wireless/ath/ath9k/debug.c
 +++ b/drivers/net/wireless/ath/ath9k/debug.c
-@@ -1025,6 +1025,9 @@ int ath9k_init_debug(struct ath_hw *ah)
+@@ -1058,6 +1058,9 @@ int ath9k_init_debug(struct ath_hw *ah)
  			sc, &fops_regdump))
  		goto err;
  
@@ -136,7 +136,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	return 0;
  err:
  	ath9k_exit_debug(ah);
-@@ -1036,6 +1039,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
+@@ -1069,6 +1072,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
  	struct ath_common *common = ath9k_hw_common(ah);
  	struct ath_softc *sc = (struct ath_softc *) common->priv;
  
@@ -161,7 +161,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2436,7 +2436,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
+@@ -2167,7 +2167,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
  		phybits |= AR_PHY_ERR_RADAR;
  	if (bits & ATH9K_RX_FILTER_PHYERR)
  		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
@@ -1298,7 +1298,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  }
  
  static const
-@@ -1379,7 +1386,8 @@ static void ath_tx_status(void *priv, st
+@@ -1395,7 +1402,8 @@ static void ath_tx_status(void *priv, st
  		tx_status = 1;
  
  	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
@@ -1318,7 +1318,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	/*
  	 * The hw can techncically differ from common->hw when using ath9k
  	 * virtual wiphy so to account for that we iterate over the active
-@@ -1715,12 +1716,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
+@@ -1716,12 +1717,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
  				 dma_type);
  
  		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
@@ -1346,16 +1346,16 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 --- a/drivers/net/wireless/ath/ath9k/xmit.c
 +++ b/drivers/net/wireless/ath/ath9k/xmit.c
-@@ -431,6 +431,8 @@ static void ath_tx_complete_aggr(struct 
+@@ -436,6 +436,8 @@ static void ath_tx_complete_aggr(struct 
  			list_move_tail(&bf->list, &bf_head);
  		}
  
 +		ath9k_pktlog_txcomplete(sc, &bf_head, bf, bf_last);
 +
- 		if (!txpending) {
+ 		if (!txpending || (tid->state & AGGR_CLEANUP)) {
  			/*
  			 * complete the acked-ones/xretried ones; update
-@@ -2097,7 +2099,7 @@ static void ath_tx_processq(struct ath_s
+@@ -2076,7 +2078,7 @@ static void ath_tx_processq(struct ath_s
  		ds = lastbf->bf_desc;
  
  		memset(&ts, 0, sizeof(ts));
@@ -1364,7 +1364,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS) {
  			spin_unlock_bh(&txq->axq_lock);
  			break;
-@@ -2146,10 +2148,14 @@ static void ath_tx_processq(struct ath_s
+@@ -2125,10 +2127,14 @@ static void ath_tx_processq(struct ath_s
  			ath_tx_rc_status(bf, &ts, 0, txok, true);
  		}
  
@@ -1381,7 +1381,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  		ath_wake_mac80211_queue(sc, txq);
  
-@@ -2221,9 +2227,11 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2200,9 +2206,11 @@ void ath_tx_edma_tasklet(struct ath_soft
  	struct list_head bf_head;
  	int status;
  	int txok;
@@ -1394,7 +1394,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS)
  			break;
  		if (status == -EIO) {
-@@ -2275,14 +2283,18 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2254,14 +2262,18 @@ void ath_tx_edma_tasklet(struct ath_soft
  			ath_tx_rc_status(bf, &txs, 0, txok, true);
  		}
  
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 69f2951..cdf4b0b 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -9,10 +9,10 @@ calls on compat code with only slight modifications.
 
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -199,6 +199,33 @@ static void __devexit	ath5k_pci_remove(s
- #ifdef CONFIG_PM_SLEEP
- static int		ath5k_pci_suspend(struct device *dev);
- static int		ath5k_pci_resume(struct device *dev);
+@@ -3499,6 +3499,34 @@ static int ath5k_pci_resume(struct devic
+ 	return 0;
+ }
+ 
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 +static int ath5k_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
 +{
@@ -40,10 +40,11 @@ calls on compat code with only slight modifications.
 +	return ath5k_pci_resume(&pdev->dev);
 +}
 +#endif
- 
++
  static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
-@@ -211,7 +238,12 @@ static struct pci_driver ath5k_pci_drive
+ #else
+@@ -3510,7 +3538,12 @@ static struct pci_driver ath5k_pci_drive
  	.id_table	= ath5k_pci_id_table,
  	.probe		= ath5k_pci_probe,
  	.remove		= __devexit_p(ath5k_pci_remove),
@@ -55,4 +56,4 @@ calls on compat code with only slight modifications.
 +#endif
  };
  
- 
+ /*
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 5a6bb16..71b9c9d 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -162,19 +162,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/ath/ath5k/base.c
 +++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -263,7 +263,11 @@ static void ath5k_remove_interface(struc
- 		struct ieee80211_vif *vif);
- static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
- static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 				   struct netdev_hw_addr_list *mc_list);
-+#else
-+				   int mc_count, struct dev_addr_list *mc_list);
-+#endif
- static void ath5k_configure_filter(struct ieee80211_hw *hw,
- 		unsigned int changed_flags,
- 		unsigned int *new_flags,
-@@ -3167,20 +3171,42 @@ unlock:
+@@ -2776,20 +2776,42 @@ unlock:
  }
  
  static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -217,7 +205,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3189,6 +3215,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -2798,6 +2820,9 @@ static u64 ath5k_prepare_multicast(struc
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -513,7 +501,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 --- a/drivers/net/wireless/wl12xx/wl1271_main.c
 +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
-@@ -1323,11 +1323,20 @@ struct wl1271_filter_params {
+@@ -1325,11 +1325,20 @@ struct wl1271_filter_params {
  	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
  };
  
@@ -534,7 +522,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	struct wl1271 *wl = hw->priv;
  
  	if (unlikely(wl->state == WL1271_STATE_OFF))
-@@ -1340,16 +1349,40 @@ static u64 wl1271_op_prepare_multicast(s
+@@ -1342,16 +1351,40 @@ static u64 wl1271_op_prepare_multicast(s
  	}
  
  	/* update multicast filtering parameters */
@@ -614,7 +602,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return hash.low | ((u64)hash.high << 32);
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1710,7 +1710,11 @@ struct ieee80211_ops {
+@@ -1713,7 +1713,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
@@ -690,7 +678,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -417,8 +417,13 @@ static void ieee80211_do_stop(struct iee
+@@ -420,8 +420,13 @@ static void ieee80211_do_stop(struct iee
  
  	netif_addr_lock_bh(sdata->dev);
  	spin_lock_bh(&local->filter_lock);
@@ -704,7 +692,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  	netif_addr_unlock_bh(sdata->dev);
  
-@@ -602,7 +607,12 @@ static void ieee80211_set_multicast_list
+@@ -605,7 +610,12 @@ static void ieee80211_set_multicast_list
  		sdata->flags ^= IEEE80211_SDATA_PROMISC;
  	}
  	spin_lock_bh(&local->filter_lock);
@@ -731,7 +719,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	spin_unlock_bh(&local->filter_lock);
  
  	/* be a bit nasty */
-@@ -524,9 +528,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
+@@ -539,9 +543,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
  
  	INIT_LIST_HEAD(&local->interfaces);
diff --git a/patches/33-autoconf.patch b/patches/33-autoconf.patch
deleted file mode 100644
index 5d767fd..0000000
--- a/patches/33-autoconf.patch
+++ /dev/null
@@ -1,15 +0,0 @@
---- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
-+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
-@@ -27,7 +27,12 @@
- #include <linux/version.h>
- 
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
- #include <generated/autoconf.h>
-+#else
-+#include <linux/autoconf.h>
-+#endif
-+#include <linux/compat_autoconf.h>
- #include <linux/init.h>
- #include <linux/kernel.h>
- #include <linux/sched.h>
-- 
1.7.0.4

