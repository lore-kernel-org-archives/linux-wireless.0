Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2396 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0HLCLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 22:11:22 -0400
Subject: drivers/net/wireless: Restore upper case words in wiphy_<level>
 messages
From: Joe Perches <joe@perches.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201008112131.01906.chunkeey@googlemail.com>
References: <201008112131.01906.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 19:11:19 -0700
Message-ID: <1281579079.2074.9.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit c96c31e499b70964cfc88744046c998bb710e4b8
"(drivers/net/wireless: Use wiphy_<level>)"
inadvertently changed some upper case words to
lower case.  Restore the original case.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/adm8211.c                 |    8 +++---
 drivers/net/wireless/at76c50x-usb.c            |   22 +++++++-------
 drivers/net/wireless/ath/ar9170/main.c         |    4 +-
 drivers/net/wireless/mac80211_hwsim.c          |    2 +-
 drivers/net/wireless/mwl8k.c                   |   34 ++++++++++++------------
 drivers/net/wireless/p54/eeprom.c              |    6 ++--
 drivers/net/wireless/p54/fwio.c                |    2 +-
 drivers/net/wireless/p54/led.c                 |    4 +-
 drivers/net/wireless/p54/p54pci.c              |    2 +-
 drivers/net/wireless/p54/txrx.c                |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c     |    6 ++--
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |    4 +-
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |    4 +-
 13 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 382ae72..f9aa1bc 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -732,7 +732,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 
 	/* Nothing to do for ADMtek BBP */
 	} else if (priv->bbp_type != ADM8211_TYPE_ADMTEK)
-		wiphy_debug(dev->wiphy, "unsupported bbp type %d\n",
+		wiphy_debug(dev->wiphy, "unsupported BBP type %d\n",
 			    priv->bbp_type);
 
 	ADM8211_RESTORE();
@@ -1032,7 +1032,7 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 			break;
 		}
 	} else
-		wiphy_debug(dev->wiphy, "unsupported bbp %d\n", priv->bbp_type);
+		wiphy_debug(dev->wiphy, "unsupported BBP %d\n", priv->bbp_type);
 
 	ADM8211_CSR_WRITE(SYNRF, 0);
 
@@ -1525,7 +1525,7 @@ static int adm8211_start(struct ieee80211_hw *dev)
 	retval = request_irq(priv->pdev->irq, adm8211_interrupt,
 			     IRQF_SHARED, "adm8211", dev);
 	if (retval) {
-		wiphy_err(dev->wiphy, "failed to register irq handler\n");
+		wiphy_err(dev->wiphy, "failed to register IRQ handler\n");
 		goto fail;
 	}
 
@@ -1902,7 +1902,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		goto err_free_eeprom;
 	}
 
-	wiphy_info(dev->wiphy, "hwaddr %pM, rev 0x%02x\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, Rev 0x%02x\n",
 		   dev->wiphy->perm_addr, pdev->revision);
 
 	return 0;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index b1c2667..1128fa8 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -655,7 +655,7 @@ static int at76_get_hw_config(struct at76_priv *priv)
 exit:
 	kfree(hwcfg);
 	if (ret < 0)
-		wiphy_err(priv->hw->wiphy, "cannot get hw config (error %d)\n",
+		wiphy_err(priv->hw->wiphy, "cannot get HW Config (error %d)\n",
 			  ret);
 
 	return ret;
@@ -960,7 +960,7 @@ static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 			   sizeof(struct mib_mac_addr));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (mac_addr) failed: %d\n", ret);
+			  "at76_get_mib (MAC_ADDR) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -989,7 +989,7 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 			   sizeof(struct mib_mac_wep));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (mac_wep) failed: %d\n", ret);
+			  "at76_get_mib (MAC_WEP) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1026,7 +1026,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (mac_mgmt) failed: %d\n", ret);
+			  "at76_get_mib (MAC_MGMT) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1062,7 +1062,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC, m, sizeof(struct mib_mac));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (mac) failed: %d\n", ret);
+			  "at76_get_mib (MAC) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1099,7 +1099,7 @@ static void at76_dump_mib_phy(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_PHY, m, sizeof(struct mib_phy));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (phy) failed: %d\n", ret);
+			  "at76_get_mib (PHY) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1132,7 +1132,7 @@ static void at76_dump_mib_local(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (local) failed: %d\n", ret);
+			  "at76_get_mib (LOCAL) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1158,7 +1158,7 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
 			   sizeof(struct mib_mdomain));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
-			  "at76_get_mib (mdomain) failed: %d\n", ret);
+			  "at76_get_mib (MDOMAIN) failed: %d\n", ret);
 		goto exit;
 	}
 
@@ -1229,7 +1229,7 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 	struct sk_buff *skb = priv->rx_skb;
 
 	if (!priv->rx_urb) {
-		wiphy_err(priv->hw->wiphy, "%s: priv->rx_urb is null\n",
+		wiphy_err(priv->hw->wiphy, "%s: priv->rx_urb is NULL\n",
 			  __func__);
 		return -EFAULT;
 	}
@@ -1792,7 +1792,7 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		wiphy_err(priv->hw->wiphy, "error in tx submit urb: %d\n", ret);
 		if (ret == -EINVAL)
 			wiphy_err(priv->hw->wiphy,
-				  "-einval: tx urb %p hcpriv %p complete %p\n",
+				  "-EINVAL: tx urb %p hcpriv %p complete %p\n",
 				  priv->tx_urb,
 				  priv->tx_urb->hcpriv, priv->tx_urb->complete);
 	}
@@ -2310,7 +2310,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	priv->mac80211_registered = 1;
 
-	wiphy_info(priv->hw->wiphy, "usb %s, mac %pM, firmware %d.%d.%d-%d\n",
+	wiphy_info(priv->hw->wiphy, "USB %s, MAC %pM, firmware %d.%d.%d-%d\n",
 		   dev_name(&interface->dev), priv->mac_addr,
 		   priv->fw_version.major, priv->fw_version.minor,
 		   priv->fw_version.patch, priv->fw_version.build);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index cabf57f..25ad97e 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -245,7 +245,7 @@ static void __ar9170_dump_txstats(struct ar9170 *ar)
 {
 	int i;
 
-	wiphy_debug(ar->hw->wiphy, "qos queue stats\n");
+	wiphy_debug(ar->hw->wiphy, "QoS queue stats\n");
 
 	for (i = 0; i < __AR9170_NUM_TXQ; i++)
 		wiphy_debug(ar->hw->wiphy,
@@ -387,7 +387,7 @@ static struct sk_buff *ar9170_get_queued_skb(struct ar9170 *ar,
 		if (mac && compare_ether_addr(ieee80211_get_DA(hdr), mac)) {
 #ifdef AR9170_QUEUE_DEBUG
 			wiphy_debug(ar->hw->wiphy,
-				    "skip frame => da %pM != %pM\n",
+				    "skip frame => DA %pM != %pM\n",
 				    mac, ieee80211_get_DA(hdr));
 			ar9170_print_txheader(ar, skb);
 #endif /* AR9170_QUEUE_DEBUG */
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 05d179a..db93969 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -486,7 +486,7 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	struct ieee80211_rx_status rx_status;
 
 	if (data->idle) {
-		wiphy_debug(hw->wiphy, "trying to tx when idle - reject\n");
+		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
 		return false;
 	}
 
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 31888da..15ebb50 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -910,14 +910,14 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 
 	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
 	if (rxq->rxd == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc rx descriptors\n");
+		wiphy_err(hw->wiphy, "failed to alloc RX descriptors\n");
 		return -ENOMEM;
 	}
 	memset(rxq->rxd, 0, size);
 
 	rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc rx skbuff list\n");
+		wiphy_err(hw->wiphy, "failed to alloc RX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
 		return -ENOMEM;
 	}
@@ -1145,14 +1145,14 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 
 	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
 	if (txq->txd == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc tx descriptors\n");
+		wiphy_err(hw->wiphy, "failed to alloc TX descriptors\n");
 		return -ENOMEM;
 	}
 	memset(txq->txd, 0, size);
 
 	txq->skb = kmalloc(MWL8K_TX_DESCS * sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc tx skbuff list\n");
+		wiphy_err(hw->wiphy, "failed to alloc TX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
 		return -ENOMEM;
 	}
@@ -1573,7 +1573,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 					PCI_DMA_BIDIRECTIONAL);
 
 	if (!timeout) {
-		wiphy_err(hw->wiphy, "command %s timeout after %u ms\n",
+		wiphy_err(hw->wiphy, "Command %s timeout after %u ms\n",
 			  mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
 			  MWL8K_CMD_TIMEOUT_MS);
 		rc = -ETIMEDOUT;
@@ -1584,11 +1584,11 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 
 		rc = cmd->result ? -EINVAL : 0;
 		if (rc)
-			wiphy_err(hw->wiphy, "command %s error 0x%x\n",
+			wiphy_err(hw->wiphy, "Command %s error 0x%x\n",
 				  mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
 				  le16_to_cpu(cmd->result));
 		else if (ms > 2000)
-			wiphy_notice(hw->wiphy, "command %s took %d ms\n",
+			wiphy_notice(hw->wiphy, "Command %s took %d ms\n",
 				     mwl8k_cmd_name(cmd->code,
 						    buf, sizeof(buf)),
 				     ms);
@@ -3210,7 +3210,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
-		wiphy_err(hw->wiphy, "failed to register irq handler\n");
+		wiphy_err(hw->wiphy, "failed to register IRQ handler\n");
 		return -EIO;
 	}
 
@@ -3926,7 +3926,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	priv->sram = pci_iomap(pdev, 0, 0x10000);
 	if (priv->sram == NULL) {
-		wiphy_err(hw->wiphy, "cannot map device sram\n");
+		wiphy_err(hw->wiphy, "Cannot map device SRAM\n");
 		goto err_iounmap;
 	}
 
@@ -3938,7 +3938,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	if (priv->regs == NULL) {
 		priv->regs = pci_iomap(pdev, 2, 0x10000);
 		if (priv->regs == NULL) {
-			wiphy_err(hw->wiphy, "cannot map device registers\n");
+			wiphy_err(hw->wiphy, "Cannot map device registers\n");
 			goto err_iounmap;
 		}
 	}
@@ -3950,14 +3950,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Ask userland hotplug daemon for the device firmware */
 	rc = mwl8k_request_firmware(priv);
 	if (rc) {
-		wiphy_err(hw->wiphy, "firmware files not found\n");
+		wiphy_err(hw->wiphy, "Firmware files not found\n");
 		goto err_stop_firmware;
 	}
 
 	/* Load firmware into hardware */
 	rc = mwl8k_load_firmware(hw);
 	if (rc) {
-		wiphy_err(hw->wiphy, "cannot start firmware\n");
+		wiphy_err(hw->wiphy, "Cannot start firmware\n");
 		goto err_stop_firmware;
 	}
 
@@ -4047,7 +4047,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
-		wiphy_err(hw->wiphy, "failed to register irq handler\n");
+		wiphy_err(hw->wiphy, "failed to register IRQ handler\n");
 		goto err_free_queues;
 	}
 
@@ -4067,7 +4067,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		rc = mwl8k_cmd_get_hw_spec_sta(hw);
 	}
 	if (rc) {
-		wiphy_err(hw->wiphy, "cannot initialise firmware\n");
+		wiphy_err(hw->wiphy, "Cannot initialise firmware\n");
 		goto err_free_irq;
 	}
 
@@ -4081,14 +4081,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Turn radio off */
 	rc = mwl8k_cmd_radio_disable(hw);
 	if (rc) {
-		wiphy_err(hw->wiphy, "cannot disable\n");
+		wiphy_err(hw->wiphy, "Cannot disable\n");
 		goto err_free_irq;
 	}
 
 	/* Clear MAC address */
 	rc = mwl8k_cmd_set_mac_addr(hw, NULL, "\x00\x00\x00\x00\x00\x00");
 	if (rc) {
-		wiphy_err(hw->wiphy, "cannot clear mac address\n");
+		wiphy_err(hw->wiphy, "Cannot clear MAC address\n");
 		goto err_free_irq;
 	}
 
@@ -4098,7 +4098,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	rc = ieee80211_register_hw(hw);
 	if (rc) {
-		wiphy_err(hw->wiphy, "cannot register device\n");
+		wiphy_err(hw->wiphy, "Cannot register device\n");
 		goto err_free_queues;
 	}
 
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 92facc3..78347041 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -167,7 +167,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 	}
 
 	if (j == 0) {
-		wiphy_err(dev->wiphy, "disabling totally damaged %d GHz band\n",
+		wiphy_err(dev->wiphy, "Disabling totally damaged %d GHz band\n",
 			  (band == IEEE80211_BAND_2GHZ) ? 2 : 5);
 
 		ret = -ENODATA;
@@ -695,12 +695,12 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		u8 perm_addr[ETH_ALEN];
 
 		wiphy_warn(dev->wiphy,
-			   "invalid hwaddr! using randomly generated mac addr\n");
+			   "Invalid hwaddr! Using randomly generated MAC addr\n");
 		random_ether_addr(perm_addr);
 		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 	}
 
-	wiphy_info(dev->wiphy, "hwaddr %pM, mac:isl38%02x rf:%s\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, MAC:isl38%02x RF:%s\n",
 		   dev->wiphy->perm_addr, priv->version,
 		   p54_rf_chips[priv->rxhw]);
 
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 47006bc..15b20c2 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -125,7 +125,7 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 
 	if (fw_version)
 		wiphy_info(priv->hw->wiphy,
-			   "fw rev %s - softmac protocol %x.%x\n",
+			   "FW rev %s - Softmac protocol %x.%x\n",
 			   fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
 
 	if (priv->fw_var < 0x500)
diff --git a/drivers/net/wireless/p54/led.c b/drivers/net/wireless/p54/led.c
index ea91f5c..3837e1e 100644
--- a/drivers/net/wireless/p54/led.c
+++ b/drivers/net/wireless/p54/led.c
@@ -58,7 +58,7 @@ static void p54_update_leds(struct work_struct *work)
 	err = p54_set_leds(priv);
 	if (err && net_ratelimit())
 		wiphy_err(priv->hw->wiphy,
-			  "failed to update leds (%d).\n", err);
+			  "failed to update LEDs (%d).\n", err);
 
 	if (rerun)
 		ieee80211_queue_delayed_work(priv->hw, &priv->led_work,
@@ -103,7 +103,7 @@ static int p54_register_led(struct p54_common *priv,
 	err = led_classdev_register(wiphy_dev(priv->hw->wiphy), &led->led_dev);
 	if (err)
 		wiphy_err(priv->hw->wiphy,
-			  "failed to register %s led.\n", name);
+			  "Failed to register %s LED.\n", name);
 	else
 		led->registered = 1;
 
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 71a101f..da9adca 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -468,7 +468,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 	P54P_READ(dev_int);
 
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		wiphy_err(dev->wiphy, "cannot boot firmware!\n");
+		wiphy_err(dev->wiphy, "Cannot boot firmware!\n");
 		p54p_stop(dev);
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 427b46f..173aec3 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -540,7 +540,7 @@ static void p54_rx_trap(struct p54_common *priv, struct sk_buff *skb)
 	case P54_TRAP_BEACON_TX:
 		break;
 	case P54_TRAP_RADAR:
-		wiphy_info(priv->hw->wiphy, "radar (freq:%d mhz)\n", freq);
+		wiphy_info(priv->hw->wiphy, "radar (freq:%d MHz)\n", freq);
 		break;
 	case P54_TRAP_NO_BEACON:
 		if (priv->vif)
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 67b3227..490b668 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -445,7 +445,7 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 					     &priv->rx_ring_dma);
 
 	if (!priv->rx_ring || (unsigned long)priv->rx_ring & 0xFF) {
-		wiphy_err(dev->wiphy, "cannot allocate rx ring\n");
+		wiphy_err(dev->wiphy, "Cannot allocate RX ring\n");
 		return -ENOMEM;
 	}
 
@@ -502,7 +502,7 @@ static int rtl8180_init_tx_ring(struct ieee80211_hw *dev,
 
 	ring = pci_alloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
-		wiphy_err(dev->wiphy, "cannot allocate tx ring (prio = %d)\n",
+		wiphy_err(dev->wiphy, "Cannot allocate TX ring (prio = %d)\n",
 			  prio);
 		return -ENOMEM;
 	}
@@ -568,7 +568,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
 			  IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret) {
-		wiphy_err(dev->wiphy, "failed to register irq handler\n");
+		wiphy_err(dev->wiphy, "failed to register IRQ handler\n");
 		goto err_free_rings;
 	}
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index efa2860..98e0351 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -573,7 +573,7 @@ static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
 	} while (--i);
 
 	if (!i) {
-		wiphy_err(dev->wiphy, "reset timeout!\n");
+		wiphy_err(dev->wiphy, "Reset timeout!\n");
 		return -ETIMEDOUT;
 	}
 
@@ -1526,7 +1526,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	mutex_init(&priv->conf_mutex);
 	skb_queue_head_init(&priv->b_tx_status.queue);
 
-	wiphy_info(dev->wiphy, "hwaddr %pM, %s v%d + %s, rfkill mask %d\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, %s V%d + %s, rfkill mask %d\n",
 		   mac_addr, chip_name, priv->asic_rev, priv->rf->name,
 		   priv->rfkill_mask);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
index fd96f91..97eebdc 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -366,7 +366,7 @@ static void rtl8225_rf_init(struct ieee80211_hw *dev)
 		rtl8225_write(dev, 0x02, 0x044d);
 		msleep(100);
 		if (!(rtl8225_read(dev, 6) & (1 << 7)))
-			wiphy_warn(dev->wiphy, "rf calibration failed! %x\n",
+			wiphy_warn(dev->wiphy, "RF Calibration Failed! %x\n",
 				   rtl8225_read(dev, 6));
 	}
 
@@ -735,7 +735,7 @@ static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 		rtl8225_write(dev, 0x02, 0x044D);
 		msleep(100);
 		if (!(rtl8225_read(dev, 6) & (1 << 7)))
-			wiphy_warn(dev->wiphy, "rf calibration failed! %x\n",
+			wiphy_warn(dev->wiphy, "RF Calibration Failed! %x\n",
 				   rtl8225_read(dev, 6));
 	}
 


