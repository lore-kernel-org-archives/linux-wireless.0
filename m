Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:38956 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933414AbeFVRvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 13:51:12 -0400
From: Joe Perches <joe@perches.com>
To: Derek Chickles <derek.chickles@caviumnetworks.com>,
        Satanand Burla <satananda.burla@caviumnetworks.com>,
        Felix Manlunas <felix.manlunas@caviumnetworks.com>,
        Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Harish Patil <harish.patil@cavium.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Dept-GELinuxNICDev@cavium.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Bert Kenward <bkenward@solarflare.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org, linux-omap@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH] net: drivers/net: Convert random_ether_addr to eth_random_addr
Date: Fri, 22 Jun 2018 10:51:00 -0700
Message-Id: <c558b59181756dfe647bcdeaf659c386701c0948.1529689773.git.joe@perches.com> (sfid-20180622_195203_132013_7BF48137)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

random_ether_addr is a #define for eth_random_addr which is
generally preferred in kernel code by ~3:1

Convert the uses of random_ether_addr to enable removing the #define

Miscellanea:

o Convert &vfmac[0] to equivalent vfmac and avoid unnecessary line wrap

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c          | 5 ++---
 drivers/net/ethernet/cortina/gemini.c                    | 2 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c               | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c              | 2 +-
 drivers/net/ethernet/microchip/lan743x_main.c            | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c          | 2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c                    | 2 +-
 drivers/net/ethernet/ti/cpsw.c                           | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                     | 4 ++--
 drivers/net/ntb_netdev.c                                 | 2 +-
 drivers/net/usb/lan78xx.c                                | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c                      | 2 +-
 net/batman-adv/bridge_loop_avoidance.c                   | 2 +-
 14 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 8a815bb57177..7cb4e753829b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3569,9 +3569,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		for (j = 0; j < octeon_dev->sriov_info.max_vfs; j++) {
 			u8 vfmac[ETH_ALEN];
 
-			random_ether_addr(&vfmac[0]);
-			if (__liquidio_set_vf_mac(netdev, j,
-						  &vfmac[0], false)) {
+			eth_random_addr(vfmac);
+			if (__liquidio_set_vf_mac(netdev, j, vfmac, false)) {
 				dev_err(&octeon_dev->pci_dev->dev,
 					"Error setting VF%d MAC address\n",
 					j);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6d7404f66f84..ce1f04fdbf70 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2435,7 +2435,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 			port->mac_addr[0], port->mac_addr[1],
 			port->mac_addr[2]);
 		dev_info(dev, "using a random ethernet address\n");
-		random_ether_addr(netdev->dev_addr);
+		eth_random_addr(netdev->dev_addr);
 	}
 	gmac_write_mac_address(netdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 340e28211135..14374a856d30 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -904,7 +904,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		hip04_config_port(ndev, SPEED_100, DUPLEX_FULL);
 
 	hip04_config_fifo(priv);
-	random_ether_addr(ndev->dev_addr);
+	eth_random_addr(ndev->dev_addr);
 	hip04_update_mac_address(ndev);
 
 	ret = hip04_alloc_ring(ndev, d);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c944bd10b03d..95e9dfbe9839 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11978,7 +11978,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 		snprintf(netdev->name, IFNAMSIZ, "%.*sv%%d",
 			 IFNAMSIZ - 4,
 			 pf->vsi[pf->lan_vsi]->netdev->name);
-		random_ether_addr(mac_addr);
+		eth_random_addr(mac_addr);
 
 		spin_lock_bh(&vsi->mac_filter_hash_lock);
 		i40e_add_mac_filter(vsi, mac_addr);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index dd947e4dd3ce..e1747a490066 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -828,7 +828,7 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 	}
 
 	if (!mac_address_valid)
-		random_ether_addr(adapter->mac_address);
+		eth_random_addr(adapter->mac_address);
 	lan743x_mac_set_address(adapter, adapter->mac_address);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_address);
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 0c744b9c6e0a..77e386ebff09 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -212,7 +212,7 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 			vp->max_tx_bw = MAX_BW;
 			vp->min_tx_bw = MIN_BW;
 			vp->spoofchk = false;
-			random_ether_addr(vp->mac);
+			eth_random_addr(vp->mac);
 			dev_info(&adapter->pdev->dev,
 				 "MAC Address %pM is configured for VF %d\n",
 				 vp->mac, i);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index b9a7548ec6a0..0afc3d335d56 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -210,7 +210,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->netdev_ops = &rmnet_vnd_ops;
 	rmnet_dev->mtu = RMNET_DFLT_PACKET_SIZE;
 	rmnet_dev->needed_headroom = RMNET_NEEDED_HEADROOM;
-	random_ether_addr(rmnet_dev->dev_addr);
+	eth_random_addr(rmnet_dev->dev_addr);
 	rmnet_dev->tx_queue_len = RMNET_TX_QUEUE_LEN;
 
 	/* Raw IP mode */
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 019cef1d3cf7..8820be83ce85 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -199,7 +199,7 @@ static int efx_ef10_sriov_alloc_vf_vswitching(struct efx_nic *efx)
 		return -ENOMEM;
 
 	for (i = 0; i < efx->vf_count; i++) {
-		random_ether_addr(nic_data->vf[i].mac);
+		eth_random_addr(nic_data->vf[i].mac);
 		nic_data->vf[i].efx = NULL;
 		nic_data->vf[i].vlan = EFX_EF10_NO_VLAN;
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 358edab9e72e..093998124149 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2927,7 +2927,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 		dev_info(cpsw->dev, "cpsw: Detected MACID = %pM\n",
 			 priv_sl2->mac_addr);
 	} else {
-		random_ether_addr(priv_sl2->mac_addr);
+		eth_random_addr(priv_sl2->mac_addr);
 		dev_info(cpsw->dev, "cpsw: Random MACID = %pM\n",
 			 priv_sl2->mac_addr);
 	}
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index e40aa3e31af2..6ebf110cd594 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2052,7 +2052,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		if (is_valid_ether_addr(efuse_mac_addr))
 			ether_addr_copy(ndev->dev_addr, efuse_mac_addr);
 		else
-			random_ether_addr(ndev->dev_addr);
+			eth_random_addr(ndev->dev_addr);
 
 		devm_iounmap(dev, efuse);
 		devm_release_mem_region(dev, res.start, size);
@@ -2061,7 +2061,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		if (mac_addr)
 			ether_addr_copy(ndev->dev_addr, mac_addr);
 		else
-			random_ether_addr(ndev->dev_addr);
+			eth_random_addr(ndev->dev_addr);
 	}
 
 	ret = of_property_read_string(node_interface, "rx-channel",
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 306a662eba94..df8d49ad48c3 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -430,7 +430,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 	ndev->hw_features = ndev->features;
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
 
-	random_ether_addr(ndev->perm_addr);
+	eth_random_addr(ndev->perm_addr);
 	memcpy(ndev->dev_addr, ndev->perm_addr, ndev->addr_len);
 
 	ndev->netdev_ops = &ntb_netdev_ops;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 8dff87ec6d99..a89570f34937 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1720,7 +1720,7 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 				  "MAC address read from EEPROM");
 		} else {
 			/* generate random MAC */
-			random_ether_addr(addr);
+			eth_random_addr(addr);
 			netif_dbg(dev, ifup, dev->net,
 				  "MAC address set to random addr");
 		}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e60bea4604e4..1665066f4e24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -496,7 +496,7 @@ static void ath9k_hw_init_macaddr(struct ath_hw *ah)
 	ath_err(common, "eeprom contains invalid mac address: %pM\n",
 		common->macaddr);
 
-	random_ether_addr(common->macaddr);
+	eth_random_addr(common->macaddr);
 	ath_err(common, "random mac address will be used: %pM\n",
 		common->macaddr);
 
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index a2de5a44bd41..ff9659af6b91 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1449,7 +1449,7 @@ static void batadv_bla_periodic_work(struct work_struct *work)
 		 * detection frames. Set the locally administered bit to avoid
 		 * collisions with users mac addresses.
 		 */
-		random_ether_addr(bat_priv->bla.loopdetect_addr);
+		eth_random_addr(bat_priv->bla.loopdetect_addr);
 		bat_priv->bla.loopdetect_addr[0] = 0xba;
 		bat_priv->bla.loopdetect_addr[1] = 0xbe;
 		bat_priv->bla.loopdetect_lasttime = jiffies;
-- 
2.15.0
