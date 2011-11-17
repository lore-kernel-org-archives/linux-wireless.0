Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43484 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1KQVXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: make patches apply again
Date: Thu, 17 Nov 2011 22:23:41 +0100
Message-Id: <1321565021-7290-3-git-send-email-hauke@hauke-m.de> (sfid-20111117_222358_863804_6FE49039)
In-Reply-To: <1321565021-7290-1-git-send-email-hauke@hauke-m.de>
References: <1321565021-7290-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/40-netdev-hw-features.patch |   56 +++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/patches/40-netdev-hw-features.patch b/patches/40-netdev-hw-features.patch
index 9c9dd94..6a7a01d 100644
--- a/patches/40-netdev-hw-features.patch
+++ b/patches/40-netdev-hw-features.patch
@@ -44,15 +44,15 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  void atl1c_set_ethtool_ops(struct net_device *netdev)
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -486,6 +486,7 @@ static void atl1c_set_rxbufsize(struct a
+@@ -487,6 +487,7 @@ static void atl1c_set_rxbufsize(struct a
  		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) : AT_RX_BUF_SIZE;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- static u32 atl1c_fix_features(struct net_device *netdev, u32 features)
+ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
+ 	netdev_features_t features)
  {
- 	/*
-@@ -512,6 +513,7 @@ static int atl1c_set_features(struct net
+@@ -515,6 +516,7 @@ static int atl1c_set_features(struct net
  
  	return 0;
  }
@@ -60,7 +60,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  /*
   * atl1c_change_mtu - Change the Maximum Transfer Unit
-@@ -539,8 +541,19 @@ static int atl1c_change_mtu(struct net_d
+@@ -542,8 +544,19 @@ static int atl1c_change_mtu(struct net_d
  		netdev->mtu = new_mtu;
  		adapter->hw.max_frame_size = new_mtu;
  		atl1c_set_rxbufsize(adapter, netdev);
@@ -80,7 +80,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  		atl1c_up(adapter);
  		clear_bit(__AT_RESETTING, &adapter->flags);
  		if (adapter->hw.ctrl_flags & ATL1C_FPGA_VERSION) {
-@@ -2605,8 +2618,10 @@ static const struct net_device_ops atl1c
+@@ -2608,8 +2621,10 @@ static const struct net_device_ops atl1c
  	.ndo_set_mac_address	= atl1c_set_mac_addr,
  	.ndo_set_rx_mode	= atl1c_set_multi,
  	.ndo_change_mtu		= atl1c_change_mtu,
@@ -91,7 +91,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  	.ndo_do_ioctl		= atl1c_ioctl,
  	.ndo_tx_timeout		= atl1c_tx_timeout,
  	.ndo_get_stats		= atl1c_get_stats,
-@@ -2626,6 +2641,7 @@ static int atl1c_init_netdev(struct net_
+@@ -2629,6 +2644,7 @@ static int atl1c_init_netdev(struct net_
  	atl1c_set_ethtool_ops(netdev);
  
  	/* TODO: add when ready */
@@ -99,7 +99,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  	netdev->hw_features =	NETIF_F_SG	   |
  				NETIF_F_HW_CSUM	   |
  				NETIF_F_HW_VLAN_RX |
-@@ -2633,6 +2649,14 @@ static int atl1c_init_netdev(struct net_
+@@ -2636,6 +2652,14 @@ static int atl1c_init_netdev(struct net_
  				NETIF_F_TSO6;
  	netdev->features =	netdev->hw_features |
  				NETIF_F_HW_VLAN_TX;
@@ -116,7 +116,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
 --- a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
 +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
-@@ -382,6 +382,11 @@ static const struct ethtool_ops atl1e_et
+@@ -384,6 +384,11 @@ static const struct ethtool_ops atl1e_et
  	.get_eeprom_len         = atl1e_get_eeprom_len,
  	.get_eeprom             = atl1e_get_eeprom,
  	.set_eeprom             = atl1e_set_eeprom,
@@ -130,15 +130,15 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  void atl1e_set_ethtool_ops(struct net_device *netdev)
 --- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
 +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
-@@ -374,6 +374,7 @@ static int atl1e_set_mac_addr(struct net
+@@ -375,6 +375,7 @@ static int atl1e_set_mac_addr(struct net
  	return 0;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- static u32 atl1e_fix_features(struct net_device *netdev, u32 features)
+ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
+ 	netdev_features_t features)
  {
- 	/*
-@@ -397,6 +398,7 @@ static int atl1e_set_features(struct net
+@@ -400,6 +401,7 @@ static int atl1e_set_features(struct net
  
  	return 0;
  }
@@ -146,7 +146,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  /*
   * atl1e_change_mtu - Change the Maximum Transfer Unit
-@@ -1948,7 +1950,11 @@ void atl1e_down(struct atl1e_adapter *ad
+@@ -1951,7 +1953,11 @@ void atl1e_down(struct atl1e_adapter *ad
  	 * reschedule our watchdog timer */
  	set_bit(__AT_DOWN, &adapter->flags);
  
@@ -158,7 +158,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	/* reset MAC to disable all RX/TX */
  	atl1e_reset_hw(&adapter->hw);
-@@ -2218,8 +2224,10 @@ static const struct net_device_ops atl1e
+@@ -2221,8 +2227,10 @@ static const struct net_device_ops atl1e
  	.ndo_set_rx_mode	= atl1e_set_multi,
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_mac_address	= atl1e_set_mac_addr,
@@ -169,7 +169,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  	.ndo_change_mtu		= atl1e_change_mtu,
  	.ndo_do_ioctl		= atl1e_ioctl,
  	.ndo_tx_timeout		= atl1e_tx_timeout,
-@@ -2240,10 +2248,15 @@ static int atl1e_init_netdev(struct net_
+@@ -2243,10 +2251,15 @@ static int atl1e_init_netdev(struct net_
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1e_set_ethtool_ops(netdev);
  
@@ -240,15 +240,15 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
 --- a/drivers/net/ethernet/atheros/atlx/atl2.c
 +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
-@@ -395,6 +395,7 @@ static void atl2_restore_vlan(struct atl
+@@ -396,6 +396,7 @@ static void atl2_restore_vlan(struct atl
  	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- static u32 atl2_fix_features(struct net_device *netdev, u32 features)
+ static netdev_features_t atl2_fix_features(struct net_device *netdev,
+ 	netdev_features_t features)
  {
- 	/*
-@@ -418,6 +419,7 @@ static int atl2_set_features(struct net_
+@@ -421,6 +422,7 @@ static int atl2_set_features(struct net_
  
  	return 0;
  }
@@ -256,7 +256,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  static void atl2_intr_rx(struct atl2_adapter *adapter)
  {
-@@ -1333,8 +1335,10 @@ static const struct net_device_ops atl2_
+@@ -1336,8 +1338,10 @@ static const struct net_device_ops atl2_
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_mac_address	= atl2_set_mac,
  	.ndo_change_mtu		= atl2_change_mtu,
@@ -267,7 +267,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  	.ndo_do_ioctl		= atl2_ioctl,
  	.ndo_tx_timeout		= atl2_tx_timeout,
  #ifdef CONFIG_NET_POLL_CONTROLLER
-@@ -1432,8 +1436,12 @@ static int __devinit atl2_probe(struct p
+@@ -1435,8 +1439,12 @@ static int __devinit atl2_probe(struct p
  
  	err = -EIO;
  
@@ -280,7 +280,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	/* Init PHY as early as possible due to power saving issue  */
  	atl2_phy_init(&adapter->hw);
-@@ -1860,6 +1868,13 @@ static int atl2_set_settings(struct net_
+@@ -1863,6 +1871,13 @@ static int atl2_set_settings(struct net_
  	return 0;
  }
  
@@ -294,7 +294,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  static u32 atl2_get_msglevel(struct net_device *netdev)
  {
  	return 0;
-@@ -2127,6 +2142,14 @@ static const struct ethtool_ops atl2_eth
+@@ -2132,6 +2147,14 @@ static const struct ethtool_ops atl2_eth
  	.get_eeprom_len		= atl2_get_eeprom_len,
  	.get_eeprom		= atl2_get_eeprom,
  	.set_eeprom		= atl2_set_eeprom,
@@ -311,15 +311,15 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  static void atl2_set_ethtool_ops(struct net_device *netdev)
 --- a/drivers/net/ethernet/atheros/atlx/atlx.c
 +++ b/drivers/net/ethernet/atheros/atlx/atlx.c
-@@ -246,6 +246,7 @@ static void atlx_restore_vlan(struct atl
+@@ -247,6 +247,7 @@ static void atlx_restore_vlan(struct atl
  	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- static u32 atlx_fix_features(struct net_device *netdev, u32 features)
+ static netdev_features_t atlx_fix_features(struct net_device *netdev,
+ 	netdev_features_t features)
  {
- 	/*
-@@ -269,5 +270,6 @@ static int atlx_set_features(struct net_
+@@ -272,5 +273,6 @@ static int atlx_set_features(struct net_
  
  	return 0;
  }
-- 
1.7.4.1

