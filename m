Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41797 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1HPNYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 09:24:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=20compat-wireless=3A=20adapt=20moving=20of=20ethernet=20drivers?=
Date: Tue, 16 Aug 2011 15:24:41 +0200
Message-Id: <1313501082-10786-1-git-send-email-hauke@hauke-m.de> (sfid-20110816_152459_382118_8936EAB1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ethernet drivers where are not directly under drivers/net any more but now in drivers/net/ethernet/<vendor>.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                             |    2 +-
 patches/01-netdev.patch              |   20 ++++++++++----------
 patches/11-dev-pm-ops.patch          |   18 +++++++++---------
 patches/25-multicast-list_head.patch |   22 +++++++++++-----------
 patches/40-netdev-hw-features.patch  |   28 ++++++++++++++--------------
 scripts/admin-update.sh              |   17 ++++++++---------
 scripts/driver-select                |   18 ++++++++++--------
 7 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/Makefile b/Makefile
index 463a56c..b6d7079 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_COMPAT_WIRELESS_MODULES) += drivers/net/wireless/
 
 obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
-obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
+obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/ethernet/broadcom/ drivers/net/ethernet/atheros/
 obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/bcma/ drivers/misc/eeprom/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index d500584..f28dd12 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -105,8 +105,8 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
---- a/drivers/net/b44.c
-+++ b/drivers/net/b44.c
+--- a/drivers/net/ethernet/broadcom/b44.c
++++ b/drivers/net/ethernet/broadcom/b44.c
 @@ -2160,7 +2160,7 @@ static int __devinit b44_init_one(struct
  	bp->rx_pending = B44_DEF_RX_RING_PENDING;
  	bp->tx_pending = B44_DEF_TX_RING_PENDING;
@@ -334,8 +334,8 @@ without creating a headache on maintenance of the pathes.
  
  	dev->watchdog_timeo  = HZ * 2;
  }
---- a/drivers/net/atl1e/atl1e_main.c
-+++ b/drivers/net/atl1e/atl1e_main.c
+--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
++++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
 @@ -2232,7 +2232,7 @@ static int atl1e_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
@@ -345,8 +345,8 @@ without creating a headache on maintenance of the pathes.
  
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1e_set_ethtool_ops(netdev);
---- a/drivers/net/atl1c/atl1c_main.c
-+++ b/drivers/net/atl1c/atl1c_main.c
+--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
++++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 @@ -2618,7 +2618,7 @@ static int atl1c_init_netdev(struct net_
  	pci_set_drvdata(pdev, netdev);
  
@@ -356,8 +356,8 @@ without creating a headache on maintenance of the pathes.
  	netdev->watchdog_timeo = AT_TX_WATCHDOG;
  	atl1c_set_ethtool_ops(netdev);
  
---- a/drivers/net/atlx/atl1.c
-+++ b/drivers/net/atlx/atl1.c
+--- a/drivers/net/ethernet/atheros/atlx/atl1.c
++++ b/drivers/net/ethernet/atheros/atlx/atl1.c
 @@ -2969,7 +2969,7 @@ static int __devinit atl1_probe(struct p
  	adapter->mii.phy_id_mask = 0x1f;
  	adapter->mii.reg_num_mask = 0x1f;
@@ -367,8 +367,8 @@ without creating a headache on maintenance of the pathes.
  	netdev->watchdog_timeo = 5 * HZ;
  
  	netdev->ethtool_ops = &atl1_ethtool_ops;
---- a/drivers/net/atlx/atl2.c
-+++ b/drivers/net/atlx/atl2.c
+--- a/drivers/net/ethernet/atheros/atlx/atl2.c
++++ b/drivers/net/ethernet/atheros/atlx/atl2.c
 @@ -1411,7 +1411,7 @@ static int __devinit atl2_probe(struct p
  
  	atl2_setup_pcicmd(pdev);
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index cd1da00..b486016 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,8 +7,8 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
---- a/drivers/net/atl1c/atl1c_main.c
-+++ b/drivers/net/atl1c/atl1c_main.c
+--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
++++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 @@ -2898,6 +2898,9 @@ static struct pci_error_handlers atl1c_e
  
  static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
@@ -32,8 +32,8 @@ calls on compat code with only slight modifications.
  };
  
  /*
---- a/drivers/net/atlx/atl1.c
-+++ b/drivers/net/atlx/atl1.c
+--- a/drivers/net/ethernet/atheros/atlx/atl1.c
++++ b/drivers/net/ethernet/atheros/atlx/atl1.c
 @@ -2836,6 +2836,9 @@ static int atl1_resume(struct device *de
  	return 0;
  }
@@ -118,7 +118,7 @@ calls on compat code with only slight modifications.
  int ath_pci_init(void)
 --- a/drivers/net/wireless/libertas/if_spi.c
 +++ b/drivers/net/wireless/libertas/if_spi.c
-@@ -1255,6 +1255,7 @@ static int __devexit libertas_spi_remove
+@@ -1251,6 +1251,7 @@ static int __devexit libertas_spi_remove
  	return 0;
  }
  
@@ -126,7 +126,7 @@ calls on compat code with only slight modifications.
  static int if_spi_suspend(struct device *dev)
  {
  	struct spi_device *spi = to_spi_device(dev);
-@@ -1288,6 +1289,7 @@ static const struct dev_pm_ops if_spi_pm
+@@ -1284,6 +1285,7 @@ static const struct dev_pm_ops if_spi_pm
  	.suspend	= if_spi_suspend,
  	.resume		= if_spi_resume,
  };
@@ -134,7 +134,7 @@ calls on compat code with only slight modifications.
  
  static struct spi_driver libertas_spi_driver = {
  	.probe	= if_spi_probe,
-@@ -1296,7 +1298,9 @@ static struct spi_driver libertas_spi_dr
+@@ -1292,7 +1294,9 @@ static struct spi_driver libertas_spi_dr
  		.name	= "libertas_spi",
  		.bus	= &spi_bus_type,
  		.owner	= THIS_MODULE,
@@ -219,7 +219,7 @@ calls on compat code with only slight modifications.
  static int __init iwl4965_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
-@@ -537,6 +537,9 @@ static int iwl_pci_resume(struct device
+@@ -532,6 +532,9 @@ static int iwl_pci_resume(struct device
  
  static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
  
@@ -229,7 +229,7 @@ calls on compat code with only slight modifications.
  #define IWL_PM_OPS	(&iwl_dev_pm_ops)
  
  #else
-@@ -550,7 +553,12 @@ static struct pci_driver iwl_pci_driver
+@@ -545,7 +548,12 @@ static struct pci_driver iwl_pci_driver
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 98953b7..44ce762 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -11,8 +11,8 @@ Backport commit 22bedad3ce112d5ca1eaf043d4990fa2ed698c87:
 
 This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
 
---- a/drivers/net/atl1c/atl1c_main.c
-+++ b/drivers/net/atl1c/atl1c_main.c
+--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
++++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 @@ -406,7 +406,11 @@ static void atl1c_set_multi(struct net_d
  
  	/* comoute mc addresses' hash value ,and put it into hash table */
@@ -25,8 +25,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		atl1c_hash_set(hw, hash_value);
  	}
  }
---- a/drivers/net/atl1e/atl1e_main.c
-+++ b/drivers/net/atl1e/atl1e_main.c
+--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
++++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
 @@ -308,7 +308,11 @@ static void atl1e_set_multi(struct net_d
  
  	/* comoute mc addresses' hash value ,and put it into hash table */
@@ -39,8 +39,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		atl1e_hash_set(hw, hash_value);
  	}
  }
---- a/drivers/net/atlx/atl2.c
-+++ b/drivers/net/atlx/atl2.c
+--- a/drivers/net/ethernet/atheros/atlx/atl2.c
++++ b/drivers/net/ethernet/atheros/atlx/atl2.c
 @@ -159,7 +159,11 @@ static void atl2_set_multi(struct net_de
  
  	/* comoute mc addresses' hash value ,and put it into hash table */
@@ -53,8 +53,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		atl2_hash_set(hw, hash_value);
  	}
  }
---- a/drivers/net/atlx/atlx.c
-+++ b/drivers/net/atlx/atlx.c
+--- a/drivers/net/ethernet/atheros/atlx/atlx.c
++++ b/drivers/net/ethernet/atheros/atlx/atlx.c
 @@ -149,7 +149,11 @@ static void atlx_set_multi(struct net_de
  
  	/* compute mc addresses' hash value ,and put it into hash table */
@@ -67,8 +67,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		atlx_hash_set(hw, hash_value);
  	}
  }
---- a/drivers/net/b44.c
-+++ b/drivers/net/b44.c
+--- a/drivers/net/ethernet/broadcom/b44.c
++++ b/drivers/net/ethernet/broadcom/b44.c
 @@ -1687,7 +1687,11 @@ static int __b44_load_mcast(struct b44 *
  	netdev_for_each_mc_addr(ha, dev) {
  		if (i == num_ents)
@@ -217,7 +217,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
-@@ -237,18 +237,34 @@ static int lbs_add_mcast_addrs(struct cm
+@@ -311,18 +311,34 @@ static int lbs_add_mcast_addrs(struct cm
  	netif_addr_lock_bh(dev);
  	cnt = netdev_mc_count(dev);
  	netdev_for_each_mc_addr(ha, dev) {
diff --git a/patches/40-netdev-hw-features.patch b/patches/40-netdev-hw-features.patch
index 791db54..22a0e9d 100644
--- a/patches/40-netdev-hw-features.patch
+++ b/patches/40-netdev-hw-features.patch
@@ -14,8 +14,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
     Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
     Signed-off-by: David S. Miller <davem@davemloft.net>
 
---- a/drivers/net/atl1c/atl1c_ethtool.c
-+++ b/drivers/net/atl1c/atl1c_ethtool.c
+--- a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
++++ b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
 @@ -114,6 +114,13 @@ static int atl1c_set_settings(struct net
  	return 0;
  }
@@ -42,8 +42,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
  
  void atl1c_set_ethtool_ops(struct net_device *netdev)
---- a/drivers/net/atl1c/atl1c_main.c
-+++ b/drivers/net/atl1c/atl1c_main.c
+--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
++++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 @@ -486,6 +486,7 @@ static void atl1c_set_rxbufsize(struct a
  		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) : AT_RX_BUF_SIZE;
  }
@@ -114,8 +114,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  	return 0;
  }
  
---- a/drivers/net/atl1e/atl1e_ethtool.c
-+++ b/drivers/net/atl1e/atl1e_ethtool.c
+--- a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
++++ b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
 @@ -382,6 +382,11 @@ static const struct ethtool_ops atl1e_et
  	.get_eeprom_len         = atl1e_get_eeprom_len,
  	.get_eeprom             = atl1e_get_eeprom,
@@ -128,8 +128,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
  
  void atl1e_set_ethtool_ops(struct net_device *netdev)
---- a/drivers/net/atl1e/atl1e_main.c
-+++ b/drivers/net/atl1e/atl1e_main.c
+--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
++++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
 @@ -374,6 +374,7 @@ static int atl1e_set_mac_addr(struct net
  	return 0;
  }
@@ -185,8 +185,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  
  	return 0;
  }
---- a/drivers/net/atlx/atl1.c
-+++ b/drivers/net/atlx/atl1.c
+--- a/drivers/net/ethernet/atheros/atlx/atl1.c
++++ b/drivers/net/ethernet/atheros/atlx/atl1.c
 @@ -2876,8 +2876,10 @@ static const struct net_device_ops atl1_
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_mac_address	= atl1_set_mac,
@@ -238,8 +238,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
 +	.set_tso		= ethtool_op_set_tso,
 +#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
  };
---- a/drivers/net/atlx/atl2.c
-+++ b/drivers/net/atlx/atl2.c
+--- a/drivers/net/ethernet/atheros/atlx/atl2.c
++++ b/drivers/net/ethernet/atheros/atlx/atl2.c
 @@ -395,6 +395,7 @@ static void atl2_restore_vlan(struct atl
  	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
  }
@@ -309,8 +309,8 @@ Date:   Thu Apr 7 07:32:18 2011 +0000
  };
  
  static void atl2_set_ethtool_ops(struct net_device *netdev)
---- a/drivers/net/atlx/atlx.c
-+++ b/drivers/net/atlx/atlx.c
+--- a/drivers/net/ethernet/atheros/atlx/atlx.c
++++ b/drivers/net/ethernet/atheros/atlx/atlx.c
 @@ -246,6 +246,7 @@ static void atlx_restore_vlan(struct atl
  	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
  }
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 87b7e5f..edd45d4 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -251,9 +251,10 @@ DRIVERS="$DRIVERS drivers/net/wireless/mwifiex"
 STAGING_DRIVERS="drivers/staging/brcm80211"
 
 # Ethernet drivers
-DRIVERS="$DRIVERS drivers/net/atl1c"
-DRIVERS="$DRIVERS drivers/net/atl1e"
-DRIVERS="$DRIVERS drivers/net/atlx"
+DRIVERS="$DRIVERS drivers/net/ethernet/atheros"
+DRIVERS="$DRIVERS drivers/net/ethernet/atheros/atl1c"
+DRIVERS="$DRIVERS drivers/net/ethernet/atheros/atl1e"
+DRIVERS="$DRIVERS drivers/net/ethernet/atheros/atlx"
 
 # Bluetooth drivers
 DRIVERS_BT="drivers/bluetooth"
@@ -278,7 +279,9 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	drivers/ssb/ \
 	drivers/bcma/ \
 	drivers/net/usb/ \
-	drivers/net/wireless/
+	drivers/net/wireless/ \
+	drivers/net/ethernet/atheros \
+	drivers/net/ethernet/broadcom
 mkdir -p include/net/bluetooth/
 
 # include/linux
@@ -376,15 +379,11 @@ for i in $RNDIS_REQS; do
 	cp $GIT_TREE/$DIR/$i $DIR/
 done
 
-DIR="drivers/net"
+DIR="drivers/net/ethernet/broadcom"
 echo > $DIR/Makefile
 cp $GIT_TREE/$DIR/b44.[ch] $DIR
 # Not yet
 echo "obj-\$(CONFIG_B44) += b44.o" >> $DIR/Makefile
-echo "obj-\$(CONFIG_ATL1) += atlx/" >> $DIR/Makefile
-echo "obj-\$(CONFIG_ATL2) += atlx/" >> $DIR/Makefile
-echo "obj-\$(CONFIG_ATL1E) += atl1e/" >> $DIR/Makefile
-echo "obj-\$(CONFIG_ATL1C) += atl1c/" >> $DIR/Makefile
 
 # Misc
 mkdir -p drivers/misc/eeprom/
diff --git a/scripts/driver-select b/scripts/driver-select
index 5abf81b..208f618 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -10,7 +10,8 @@ ATH9K_MAKEFILE="drivers/net/wireless/ath/ath9k/Makefile"
 RT2X00_MAKEFILE="drivers/net/wireless/rt2x00/Makefile"
 NET_WIRELESS_MAKEFILE="net/wireless/Makefile"
 EEPROM_MAKEFILE="drivers/misc/eeprom/Makefile"
-DRIVERS_NET="drivers/net/Makefile"
+DRIVERS_NET_ATHEROS="drivers/net/ethernet/atheros/Makefile"
+DRIVERS_NET_BROADCOM="drivers/net/ethernet/broadcom/Makefile"
 DRIVERS_NET_USB_MAKEFILE="drivers/net/usb/Makefile"
 SSB_MAKEFILE="drivers/ssb/Makefile"
 
@@ -114,8 +115,8 @@ function disable_lib80211
 }
 
 function disable_b44 {
-	backup_file $DRIVERS_NET
-	perl -i -ne 'print if ! /CONFIG_B44/ ' $DRIVERS_NET
+	backup_file $DRIVERS_NET_BROADCOM
+	perl -i -ne 'print if ! /CONFIG_B44/ ' $DRIVERS_NET_BROADCOM
 }
 
 function disable_ssb
@@ -175,7 +176,8 @@ function disable_bt_usb_ethernet_var {
 
 function enable_only_ethernet {
 	backup_file Makefile
-	backup_file $DRIVERS_NET
+	backup_file $DRIVERS_NET_BROADCOM
+	backup_file $DRIVERS_NET_ATHEROS
 	disable_staging
 	disable_usbnet
 	disable_var_03
@@ -405,19 +407,19 @@ case $1 in
 # Ethernet and Bluetooth drivers
 	atl1)
 		enable_only_ethernet
-		echo -e "obj-\$(CONFIG_ATL1) += atlx/" > $DRIVERS_NET
+		echo -e "obj-\$(CONFIG_ATL1) += atlx/" > $DRIVERS_NET_ATHEROS
 		;;
 	atl2)
 		enable_only_ethernet
-		echo -e "obj-\$(CONFIG_ATL2) += atlx/" > $DRIVERS_NET
+		echo -e "obj-\$(CONFIG_ATL2) += atlx/" > $DRIVERS_NET_ATHEROS
 		;;
 	atl1e)
 		enable_only_ethernet
-		echo -e "obj-\$(CONFIG_ATL1E) += atl1e/" > $DRIVERS_NET
+		echo -e "obj-\$(CONFIG_ATL1E) += atl1e/" > $DRIVERS_NET_ATHEROS
 		;;
 	atl1c)
 		enable_only_ethernet
-		echo -e "obj-\$(CONFIG_ATL1C) += atl1c/" > $DRIVERS_NET
+		echo -e "obj-\$(CONFIG_ATL1C) += atl1c/" > $DRIVERS_NET_ATHEROS
 		;;
 	atlxx)
 		select_drivers		CONFIG_ATL1 CONFIG_ATL2 CONFIG_ATL1E CONFIG_ATL1C
-- 
1.7.4.1

