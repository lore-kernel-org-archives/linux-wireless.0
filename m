Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60032 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab1GVQub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:50:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat-wireless: adapt some changes to atheros ethernet driver
Date: Fri, 22 Jul 2011 18:50:13 +0200
Message-Id: <1311353415-30952-3-git-send-email-hauke@hauke-m.de> (sfid-20110722_185034_204226_A09B44DD)
In-Reply-To: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
References: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/40-netdev-hw-features.patch |  138 ++++++++++++++++++++++++++++-------
 1 files changed, 110 insertions(+), 28 deletions(-)

diff --git a/patches/40-netdev-hw-features.patch b/patches/40-netdev-hw-features.patch
index 3e07c23..791db54 100644
--- a/patches/40-netdev-hw-features.patch
+++ b/patches/40-netdev-hw-features.patch
@@ -44,23 +44,23 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  void atl1c_set_ethtool_ops(struct net_device *netdev)
 --- a/drivers/net/atl1c/atl1c_main.c
 +++ b/drivers/net/atl1c/atl1c_main.c
-@@ -485,6 +485,7 @@ static void atl1c_set_rxbufsize(struct a
+@@ -486,6 +486,7 @@ static void atl1c_set_rxbufsize(struct a
  		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) : AT_RX_BUF_SIZE;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
  static u32 atl1c_fix_features(struct net_device *netdev, u32 features)
  {
- 	if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-@@ -492,6 +493,7 @@ static u32 atl1c_fix_features(struct net
+ 	/*
+@@ -512,6 +513,7 @@ static int atl1c_set_features(struct net
  
- 	return features;
+ 	return 0;
  }
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
  
  /*
   * atl1c_change_mtu - Change the Maximum Transfer Unit
-@@ -519,8 +521,19 @@ static int atl1c_change_mtu(struct net_d
+@@ -539,8 +541,19 @@ static int atl1c_change_mtu(struct net_d
  		netdev->mtu = new_mtu;
  		adapter->hw.max_frame_size = new_mtu;
  		atl1c_set_rxbufsize(adapter, netdev);
@@ -80,28 +80,29 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  		atl1c_up(adapter);
  		clear_bit(__AT_RESETTING, &adapter->flags);
  		if (adapter->hw.ctrl_flags & ATL1C_FPGA_VERSION) {
-@@ -2588,7 +2601,9 @@ static const struct net_device_ops atl1c
- 	.ndo_set_mac_address 	= atl1c_set_mac_addr,
+@@ -2606,8 +2619,10 @@ static const struct net_device_ops atl1c
+ 	.ndo_set_mac_address	= atl1c_set_mac_addr,
  	.ndo_set_multicast_list = atl1c_set_multi,
  	.ndo_change_mtu		= atl1c_change_mtu,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
  	.ndo_fix_features	= atl1c_fix_features,
+ 	.ndo_set_features	= atl1c_set_features,
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
  	.ndo_do_ioctl		= atl1c_ioctl,
  	.ndo_tx_timeout		= atl1c_tx_timeout,
  	.ndo_get_stats		= atl1c_get_stats,
-@@ -2609,6 +2624,7 @@ static int atl1c_init_netdev(struct net_
+@@ -2627,6 +2642,7 @@ static int atl1c_init_netdev(struct net_
  	atl1c_set_ethtool_ops(netdev);
  
  	/* TODO: add when ready */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
  	netdev->hw_features =	NETIF_F_SG	   |
  				NETIF_F_HW_CSUM	   |
- 				NETIF_F_HW_VLAN_TX |
-@@ -2616,6 +2632,14 @@ static int atl1c_init_netdev(struct net_
+ 				NETIF_F_HW_VLAN_RX |
+@@ -2634,6 +2650,14 @@ static int atl1c_init_netdev(struct net_
  				NETIF_F_TSO6;
  	netdev->features =	netdev->hw_features |
- 				NETIF_F_HW_VLAN_RX;
+ 				NETIF_F_HW_VLAN_TX;
 +#else
 +	netdev->features =	NETIF_F_SG	   |
 +				NETIF_F_HW_CSUM	   |
@@ -129,7 +130,23 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  void atl1e_set_ethtool_ops(struct net_device *netdev)
 --- a/drivers/net/atl1e/atl1e_main.c
 +++ b/drivers/net/atl1e/atl1e_main.c
-@@ -1928,7 +1928,11 @@ void atl1e_down(struct atl1e_adapter *ad
+@@ -374,6 +374,7 @@ static int atl1e_set_mac_addr(struct net
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ static u32 atl1e_fix_features(struct net_device *netdev, u32 features)
+ {
+ 	/*
+@@ -397,6 +398,7 @@ static int atl1e_set_features(struct net
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 
+ /*
+  * atl1e_change_mtu - Change the Maximum Transfer Unit
+@@ -1949,7 +1951,11 @@ void atl1e_down(struct atl1e_adapter *ad
  	 * reschedule our watchdog timer */
  	set_bit(__AT_DOWN, &adapter->flags);
  
@@ -141,32 +158,53 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	/* reset MAC to disable all RX/TX */
  	atl1e_reset_hw(&adapter->hw);
-@@ -2220,10 +2224,17 @@ static int atl1e_init_netdev(struct net_
+@@ -2219,8 +2225,10 @@ static const struct net_device_ops atl1e
+ 	.ndo_set_multicast_list	= atl1e_set_multi,
+ 	.ndo_validate_addr	= eth_validate_addr,
+ 	.ndo_set_mac_address	= atl1e_set_mac_addr,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ 	.ndo_fix_features	= atl1e_fix_features,
+ 	.ndo_set_features	= atl1e_set_features,
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 	.ndo_change_mtu		= atl1e_change_mtu,
+ 	.ndo_do_ioctl		= atl1e_ioctl,
+ 	.ndo_tx_timeout		= atl1e_tx_timeout,
+@@ -2241,10 +2249,15 @@ static int atl1e_init_netdev(struct net_
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1e_set_ethtool_ops(netdev);
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
  	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
- 		NETIF_F_HW_VLAN_TX;
- 	netdev->features = netdev->hw_features |
- 		NETIF_F_HW_VLAN_RX | NETIF_F_LLTX;
+ 			      NETIF_F_HW_VLAN_RX;
+ 	netdev->features = netdev->hw_features | NETIF_F_LLTX |
+ 			   NETIF_F_HW_VLAN_TX;
 +#else
-+	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM |
-+		NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
-+	netdev->features |= NETIF_F_LLTX;
-+	netdev->features |= NETIF_F_TSO;
++	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
++			   NETIF_F_HW_VLAN_RX | NETIF_F_LLTX | NETIF_F_HW_VLAN_TX;
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
  
  	return 0;
  }
 --- a/drivers/net/atlx/atl1.c
 +++ b/drivers/net/atlx/atl1.c
-@@ -2987,10 +2987,12 @@ static int __devinit atl1_probe(struct p
+@@ -2876,8 +2876,10 @@ static const struct net_device_ops atl1_
+ 	.ndo_validate_addr	= eth_validate_addr,
+ 	.ndo_set_mac_address	= atl1_set_mac,
+ 	.ndo_change_mtu		= atl1_change_mtu,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ 	.ndo_fix_features	= atlx_fix_features,
+ 	.ndo_set_features	= atlx_set_features,
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 	.ndo_do_ioctl		= atlx_ioctl,
+ 	.ndo_tx_timeout		= atlx_tx_timeout,
+ #ifdef CONFIG_NET_POLL_CONTROLLER
+@@ -2987,11 +2989,13 @@ static int __devinit atl1_probe(struct p
  	netdev->features |= NETIF_F_SG;
  	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- 	netdev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO;
+ 	netdev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
+ 			      NETIF_F_HW_VLAN_RX;
  
  	/* is this valid? see atl1_setup_mac_ctrl() */
  	netdev->features |= NETIF_F_RXCSUM;
@@ -174,7 +212,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	/*
  	 * patch for some L1 of old version,
-@@ -3607,6 +3609,14 @@ static int atl1_set_pauseparam(struct ne
+@@ -3608,6 +3612,14 @@ static int atl1_set_pauseparam(struct ne
  	return 0;
  }
  
@@ -189,7 +227,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  static void atl1_get_strings(struct net_device *netdev, u32 stringset,
  	u8 *data)
  {
-@@ -3679,4 +3689,10 @@ static const struct ethtool_ops atl1_eth
+@@ -3680,4 +3692,10 @@ static const struct ethtool_ops atl1_eth
  	.nway_reset		= atl1_nway_reset,
  	.get_ethtool_stats	= atl1_get_ethtool_stats,
  	.get_sset_count		= atl1_get_sset_count,
@@ -202,12 +240,39 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
 --- a/drivers/net/atlx/atl2.c
 +++ b/drivers/net/atlx/atl2.c
-@@ -1414,8 +1414,12 @@ static int __devinit atl2_probe(struct p
+@@ -395,6 +395,7 @@ static void atl2_restore_vlan(struct atl
+ 	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ static u32 atl2_fix_features(struct net_device *netdev, u32 features)
+ {
+ 	/*
+@@ -418,6 +419,7 @@ static int atl2_set_features(struct net_
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 
+ static void atl2_intr_rx(struct atl2_adapter *adapter)
+ {
+@@ -1333,8 +1335,10 @@ static const struct net_device_ops atl2_
+ 	.ndo_validate_addr	= eth_validate_addr,
+ 	.ndo_set_mac_address	= atl2_set_mac,
+ 	.ndo_change_mtu		= atl2_change_mtu,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ 	.ndo_fix_features	= atl2_fix_features,
+ 	.ndo_set_features	= atl2_set_features,
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 	.ndo_do_ioctl		= atl2_ioctl,
+ 	.ndo_tx_timeout		= atl2_tx_timeout,
+ #ifdef CONFIG_NET_POLL_CONTROLLER
+@@ -1432,8 +1436,12 @@ static int __devinit atl2_probe(struct p
  
  	err = -EIO;
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- 	netdev->hw_features = NETIF_F_SG;
+ 	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_VLAN_RX;
 +#endif
 +#if defined(NETIF_F_HW_VLAN_TX) || (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
  	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
@@ -215,7 +280,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	/* Init PHY as early as possible due to power saving issue  */
  	atl2_phy_init(&adapter->hw);
-@@ -1842,6 +1846,13 @@ static int atl2_set_settings(struct net_
+@@ -1860,6 +1868,13 @@ static int atl2_set_settings(struct net_
  	return 0;
  }
  
@@ -229,7 +294,7 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  static u32 atl2_get_msglevel(struct net_device *netdev)
  {
  	return 0;
-@@ -2109,6 +2120,14 @@ static const struct ethtool_ops atl2_eth
+@@ -2127,6 +2142,14 @@ static const struct ethtool_ops atl2_eth
  	.get_eeprom_len		= atl2_get_eeprom_len,
  	.get_eeprom		= atl2_get_eeprom,
  	.set_eeprom		= atl2_set_eeprom,
@@ -244,3 +309,20 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
  
  static void atl2_set_ethtool_ops(struct net_device *netdev)
+--- a/drivers/net/atlx/atlx.c
++++ b/drivers/net/atlx/atlx.c
+@@ -246,6 +246,7 @@ static void atlx_restore_vlan(struct atl
+ 	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ static u32 atlx_fix_features(struct net_device *netdev, u32 features)
+ {
+ 	/*
+@@ -269,5 +270,6 @@ static int atlx_set_features(struct net_
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 
+ #endif /* ATLX_C */
-- 
1.7.4.1

