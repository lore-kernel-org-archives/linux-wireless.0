Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50302 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAUzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 16:55:35 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/3] backports: add new alx upstream backport
Date: Mon,  1 Jul 2013 13:55:19 -0700
Message-Id: <1372712120-16606-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20130701_225538_453378_65AD4C14)
In-Reply-To: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This backports the new upstream alx driver and
properly splits up each required backports into
its respective collateral evolution bucket.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../network/0001-netdev_ops/alx.patch              |   11 ++
 .../network/0007-pci_dev_dev_flags/INFO            |   28 +++++
 .../network/0007-pci_dev_dev_flags/alx.patch       |   13 +++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   24 ++++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   14 +++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   58 +++++++++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   13 +++
 .../network/0001-backport-alx/alx.patch            |  123 --------------------
 .../0003-alx-deactivate-loopback-test/alx.patch    |   25 ----
 9 files changed, 161 insertions(+), 148 deletions(-)
 create mode 100644 patches/collateral-evolutions/network/0001-netdev_ops/alx.patch
 create mode 100644 patches/collateral-evolutions/network/0007-pci_dev_dev_flags/INFO
 create mode 100644 patches/collateral-evolutions/network/0007-pci_dev_dev_flags/alx.patch
 create mode 100644 patches/collateral-evolutions/network/11-dev-pm-ops/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/25-multicast-list_head/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/40-netdev-hw-features/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/61-netdev-addr_assign_type/drivers_net_ethernet_atheros_alx_main.patch
 delete mode 100644 patches/unified-drivers/network/0001-backport-alx/alx.patch
 delete mode 100644 patches/unified-drivers/network/0003-alx-deactivate-loopback-test/alx.patch

diff --git a/patches/collateral-evolutions/network/0001-netdev_ops/alx.patch b/patches/collateral-evolutions/network/0001-netdev_ops/alx.patch
new file mode 100644
index 0000000..46ed1fe
--- /dev/null
+++ b/patches/collateral-evolutions/network/0001-netdev_ops/alx.patch
@@ -0,0 +1,11 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -1317,7 +1317,7 @@ static int alx_probe(struct pci_dev *pde
+ 		goto out_free_netdev;
+ 	}
+ 
+-	netdev->netdev_ops = &alx_netdev_ops;
++	netdev_attach_ops(netdev, &alx_netdev_ops);
+ 	SET_ETHTOOL_OPS(netdev, &alx_ethtool_ops);
+ 	netdev->irq = pdev->irq;
+ 	netdev->watchdog_timeo = ALX_WATCHDOG_TIME;
diff --git a/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/INFO b/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/INFO
new file mode 100644
index 0000000..fc95b61
--- /dev/null
+++ b/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/INFO
@@ -0,0 +1,28 @@
+The struct pci_dev dev_flags member was added as of
+v2.6.24 via ba698ad4. This collateral evolution can be
+enhanced and backported atomically through these series
+of patches. The end goal is to optimize this in SmPL form.
+
+mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains ba698ad4
+v2.6.24-rc2~28^2~6
+
+commit ba698ad4b7e466cbb4a8bde6b9da8080ab06808d
+Author: David Miller <davem@davemloft.net>
+Date:   Thu Oct 25 01:16:30 2007 -0700
+
+    PCI: Add quirk for devices which disable MSI when INTX_DISABLE is set.
+    
+    A reasonably common problem with some devices is that they will
+    disable MSI generation when the INTX_DISABLE bit is set in the
+    PCI_COMMAND register.
+    
+    Quirk this explicitly, guarding the pci_intx() calls in msi.c with
+    this quirk indication.
+    
+    The first entries for this quirk are for 5714 and 5780 Tigon3 chips,
+    and thus we can remove the workaround code from the tg3.c driver.
+    
+    Signed-off-by: David S. Miller <davem@davemloft.net>
+    Acked-by: Michael Chan <mchan@broadcom.com>
+    Acked-by: Jeff Garzik <jgarzik@redhat.com>
+    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
diff --git a/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/alx.patch b/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/alx.patch
new file mode 100644
index 0000000..aa782b7
--- /dev/null
+++ b/patches/collateral-evolutions/network/0007-pci_dev_dev_flags/alx.patch
@@ -0,0 +1,13 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -1322,8 +1322,10 @@ static int alx_probe(struct pci_dev *pde
+ 	netdev->irq = pdev->irq;
+ 	netdev->watchdog_timeo = ALX_WATCHDOG_TIME;
+ 
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
+ 	if (ent->driver_data & ALX_DEV_QUIRK_MSI_INTX_DISABLE_BUG)
+ 		pdev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
++#endif
+ 
+ 	err = alx_init_sw(alx);
+ 	if (err) {
diff --git a/patches/collateral-evolutions/network/11-dev-pm-ops/drivers_net_ethernet_atheros_alx_main.patch b/patches/collateral-evolutions/network/11-dev-pm-ops/drivers_net_ethernet_atheros_alx_main.patch
new file mode 100644
index 0000000..4f4cce9
--- /dev/null
+++ b/patches/collateral-evolutions/network/11-dev-pm-ops/drivers_net_ethernet_atheros_alx_main.patch
@@ -0,0 +1,24 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -1590,6 +1590,8 @@ static const struct pci_error_handlers a
+ };
+ 
+ #ifdef CONFIG_PM_SLEEP
++compat_pci_suspend(alx_suspend);
++compat_pci_resume(alx_resume);
+ static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
+ #define ALX_PM_OPS      (&alx_pm_ops)
+ #else
+@@ -1615,7 +1617,12 @@ static struct pci_driver alx_driver = {
+ 	.remove      = alx_remove,
+ 	.shutdown    = alx_shutdown,
+ 	.err_handler = &alx_err_handlers,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	.driver.pm   = ALX_PM_OPS,
++#elif defined(CONFIG_PM_SLEEP)
++	.suspend        = alx_suspend_compat,
++	.resume         = alx_resume_compat,
++#endif
+ };
+ 
+ module_pci_driver(alx_driver);
diff --git a/patches/collateral-evolutions/network/25-multicast-list_head/drivers_net_ethernet_atheros_alx_main.patch b/patches/collateral-evolutions/network/25-multicast-list_head/drivers_net_ethernet_atheros_alx_main.patch
new file mode 100644
index 0000000..886bb87
--- /dev/null
+++ b/patches/collateral-evolutions/network/25-multicast-list_head/drivers_net_ethernet_atheros_alx_main.patch
@@ -0,0 +1,14 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -466,7 +466,11 @@ static void __alx_set_rx_mode(struct net
+ 
+ 	if (!(netdev->flags & IFF_ALLMULTI)) {
+ 		netdev_for_each_mc_addr(ha, netdev)
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 			alx_add_mc_addr(hw, ha->addr, mc_hash);
++#else
++			alx_add_mc_addr(hw, ha->dmi_addr, mc_hash);
++#endif
+ 
+ 		alx_write_mem32(hw, ALX_HASH_TBL0, mc_hash[0]);
+ 		alx_write_mem32(hw, ALX_HASH_TBL1, mc_hash[1]);
diff --git a/patches/collateral-evolutions/network/40-netdev-hw-features/drivers_net_ethernet_atheros_alx_main.patch b/patches/collateral-evolutions/network/40-netdev-hw-features/drivers_net_ethernet_atheros_alx_main.patch
new file mode 100644
index 0000000..35e3371
--- /dev/null
+++ b/patches/collateral-evolutions/network/40-netdev-hw-features/drivers_net_ethernet_atheros_alx_main.patch
@@ -0,0 +1,58 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -737,6 +737,7 @@ static int alx_init_sw(struct alx_priv *
+ }
+ 
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ static netdev_features_t alx_fix_features(struct net_device *netdev,
+ 					  netdev_features_t features)
+ {
+@@ -745,6 +746,7 @@ static netdev_features_t alx_fix_feature
+ 
+ 	return features;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 
+ static void alx_netif_stop(struct alx_priv *alx)
+ {
+@@ -820,7 +822,17 @@ static int alx_change_mtu(struct net_dev
+ 	alx->hw.mtu = mtu;
+ 	alx->rxbuf_size = mtu > ALX_DEF_RXBUF_SIZE ?
+ 			   ALIGN(max_frame, 8) : ALX_DEF_RXBUF_SIZE;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39))
++	if (mtu > (7*1024)) {
++		netdev->features &= ~NETIF_F_TSO;
++		netdev->features &= ~NETIF_F_TSO6;
++	} else {
++		netdev->features |= NETIF_F_TSO;
++		netdev->features |= NETIF_F_TSO6;
++	}
++#else
+ 	netdev_update_features(netdev);
++#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
+ 	if (netif_running(netdev))
+ 		alx_reinit(alx);
+ 	return 0;
+@@ -1238,7 +1250,9 @@ static const struct net_device_ops alx_n
+ 	.ndo_change_mtu         = alx_change_mtu,
+ 	.ndo_do_ioctl           = alx_ioctl,
+ 	.ndo_tx_timeout         = alx_tx_timeout,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ 	.ndo_fix_features	= alx_fix_features,
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ #ifdef CONFIG_NET_POLL_CONTROLLER
+ 	.ndo_poll_controller    = alx_poll_controller,
+ #endif
+@@ -1361,7 +1375,11 @@ static int alx_probe(struct pci_dev *pde
+ 		}
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
+ 	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
++#else
++	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM;
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
+ 
+ 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
+ 		dev_warn(&pdev->dev,
diff --git a/patches/collateral-evolutions/network/61-netdev-addr_assign_type/drivers_net_ethernet_atheros_alx_main.patch b/patches/collateral-evolutions/network/61-netdev-addr_assign_type/drivers_net_ethernet_atheros_alx_main.patch
new file mode 100644
index 0000000..a492664
--- /dev/null
+++ b/patches/collateral-evolutions/network/61-netdev-addr_assign_type/drivers_net_ethernet_atheros_alx_main.patch
@@ -0,0 +1,13 @@
+--- a/drivers/net/ethernet/atheros/alx/main.c
++++ b/drivers/net/ethernet/atheros/alx/main.c
+@@ -499,8 +499,10 @@ static int alx_set_mac_address(struct ne
+ 	if (!is_valid_ether_addr(addr->sa_data))
+ 		return -EADDRNOTAVAIL;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	if (netdev->addr_assign_type & NET_ADDR_RANDOM)
+ 		netdev->addr_assign_type ^= NET_ADDR_RANDOM;
++#endif
+ 
+ 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+ 	memcpy(hw->mac_addr, addr->sa_data, netdev->addr_len);
diff --git a/patches/unified-drivers/network/0001-backport-alx/alx.patch b/patches/unified-drivers/network/0001-backport-alx/alx.patch
deleted file mode 100644
index a0a9c1f..0000000
--- a/patches/unified-drivers/network/0001-backport-alx/alx.patch
+++ /dev/null
@@ -1,123 +0,0 @@
---- a/drivers/net/ethernet/atheros/alx/alx_main.c
-+++ b/drivers/net/ethernet/atheros/alx/alx_main.c
-@@ -98,7 +98,11 @@ static void __alx_set_rx_mode(struct net
- 
- 	/* comoute mc addresses' hash value ,and put it into hash table */
- 	netdev_for_each_mc_addr(ha, netdev)
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 		alx_add_mc_addr(hw, ha->addr);
-+#else
-+		alx_add_mc_addr(hw, ha->dmi_addr);
-+#endif
- 
- 	ALX_MEM_W32(hw, ALX_HASH_TBL0, hw->mc_hash[0]);
- 	ALX_MEM_W32(hw, ALX_HASH_TBL1, hw->mc_hash[1]);
-@@ -130,8 +134,10 @@ static int alx_set_mac_address(struct ne
- 	if (!is_valid_ether_addr(addr->sa_data))
- 		return -EADDRNOTAVAIL;
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	if (netdev->addr_assign_type & NET_ADDR_RANDOM)
- 		netdev->addr_assign_type ^= NET_ADDR_RANDOM;
-+#endif
- 
- 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
- 	memcpy(hw->mac_addr, addr->sa_data, netdev->addr_len);
-@@ -1138,6 +1144,7 @@ static void alx_set_vlan_mode(struct alx
- }
- 
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- static netdev_features_t alx_fix_features(struct net_device *netdev,
- 					  netdev_features_t features)
- {
-@@ -1170,6 +1177,7 @@ static int alx_set_features(struct net_d
- 
- 	return 0;
- }
-+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
- 
- /* alx_change_mtu - Change the Maximum Transfer Unit */
- static int alx_change_mtu(struct net_device *netdev, int new_mtu)
-@@ -1194,7 +1202,17 @@ static int alx_change_mtu(struct net_dev
- 		adpt->hw.mtu = new_mtu;
- 		adpt->rxbuf_size = new_mtu > ALX_DEF_RXBUF_SIZE ?
- 				   ALIGN(max_frame, 8) : ALX_DEF_RXBUF_SIZE;
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39))
-+		if (new_mtu > (7*1024)) {
-+			netdev->features &= ~NETIF_F_TSO;
-+			netdev->features &= ~NETIF_F_TSO6;
-+		} else {
-+			netdev->features |= NETIF_F_TSO;
-+			netdev->features |= NETIF_F_TSO6;
-+		}
-+#else
- 		netdev_update_features(netdev);
-+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
- 		if (netif_running(netdev))
- 			alx_reinit(adpt, false);
- 	}
-@@ -2460,8 +2478,10 @@ static const struct net_device_ops alx_n
- 	.ndo_change_mtu         = alx_change_mtu,
- 	.ndo_do_ioctl           = alx_ioctl,
- 	.ndo_tx_timeout         = alx_tx_timeout,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- 	.ndo_fix_features	= alx_fix_features,
- 	.ndo_set_features	= alx_set_features,
-+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
- #ifdef CONFIG_NET_POLL_CONTROLLER
- 	.ndo_poll_controller    = alx_poll_controller,
- #endif
-@@ -2563,7 +2583,7 @@ alx_probe(struct pci_dev *pdev, const st
- 		goto err_iomap;
- 	}
- 
--	netdev->netdev_ops = &alx_netdev_ops;
-+	netdev_attach_ops(netdev, &alx_netdev_ops);
- 	alx_set_ethtool_ops(netdev);
- 	netdev->irq  = pdev->irq;
- 	netdev->watchdog_timeo = ALX_WATCHDOG_TIME;
-@@ -2608,12 +2628,21 @@ alx_probe(struct pci_dev *pdev, const st
- 		}
- 	}
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39))
- 	netdev->hw_features = NETIF_F_SG	 |
- 			      NETIF_F_HW_CSUM	 |
- 			      NETIF_F_HW_VLAN_CTAG_RX |
- 			      NETIF_F_TSO        |
- 			      NETIF_F_TSO6;
- 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
-+#else
-+	netdev->features = NETIF_F_SG            |
-+			   NETIF_F_HW_CSUM       |
-+			   NETIF_F_HW_VLAN_CTAG_RX    |
-+			   NETIF_F_TSO           |
-+			   NETIF_F_TSO6          |
-+			   NETIF_F_HW_VLAN_CTAG_TX;
-+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)) */
- 
- 	/* read permanent mac addr from register or eFuse */
- 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
-@@ -2789,6 +2818,8 @@ static struct pci_error_handlers alx_err
- };
- 
- #ifdef CONFIG_PM_SLEEP
-+compat_pci_suspend(alx_suspend);
-+compat_pci_resume(alx_resume);
- static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
- #define ALX_PM_OPS      (&alx_pm_ops)
- #else
-@@ -2802,7 +2833,12 @@ static struct pci_driver alx_driver = {
- 	.remove      = alx_remove,
- 	.shutdown    = alx_shutdown,
- 	.err_handler = &alx_err_handler,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	.driver.pm   = ALX_PM_OPS,
-+#elif defined(CONFIG_PM_SLEEP)
-+	.suspend        = alx_suspend_compat,
-+	.resume         = alx_resume_compat,
-+#endif
- };
- 
- module_pci_driver(alx_driver);
diff --git a/patches/unified-drivers/network/0003-alx-deactivate-loopback-test/alx.patch b/patches/unified-drivers/network/0003-alx-deactivate-loopback-test/alx.patch
deleted file mode 100644
index 3ed96a4..0000000
--- a/patches/unified-drivers/network/0003-alx-deactivate-loopback-test/alx.patch
+++ /dev/null
@@ -1,25 +0,0 @@
---- a/drivers/net/ethernet/atheros/alx/alx_ethtool.c
-+++ b/drivers/net/ethernet/atheros/alx/alx_ethtool.c
-@@ -1687,7 +1687,9 @@ static void alx_self_test(struct net_dev
- {
- 	struct alx_adapter *adpt = netdev_priv(netdev);
- 	bool if_running = netif_running(netdev);
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
- 	bool phy_lpback = etest->flags & ETH_TEST_FL_EXTERNAL_LB;
-+#endif
- 
- 	ALX_FLAG_SET(adpt, TESTING);
- 	memset(data, 0, sizeof(u64) * ALX_TEST_LEN);
-@@ -1707,10 +1709,12 @@ static void alx_self_test(struct net_dev
- 		if (alx_diag_interrupt(adpt, &data[2]))
- 			etest->flags |= ETH_TEST_FL_FAILED;
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
- 		if (phy_lpback)
- 			etest->flags |= ETH_TEST_FL_EXTERNAL_LB_DONE;
- 		if (alx_diag_loopback(adpt, &data[3], phy_lpback))
- 			etest->flags |= ETH_TEST_FL_FAILED;
-+#endif
- 
- 	} else {
- 		netif_info(adpt, hw, adpt->netdev,  "online test start...\n");
-- 
1.7.10.4

