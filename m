Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0HKTbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 15:31:11 -0400
Received: by bwz3 with SMTP id 3so370589bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Aug 2010 12:31:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: revert %pM to %pm conversion
Date: Wed, 11 Aug 2010 21:31:01 +0200
Cc: Joe Perches <joe@perches.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008112131.01906.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch: "drivers/net/wireless: Use wiphy_<level>" not
only replaced printk(KERN_<level> with wiphy_<level>, but
also converted some format string characters to lower case.

This would be totally fine, if it wasn't for this tiny
little detail:

(extract from lib/vsprintf.c)
/*
 * Show a '%p' thing.  A kernel extension is that the '%p'
 * is followed by an extra set of alphanumeric characters
 * that are extended format specifiers.
 * [...]
 * - 'M' For a 6-byte MAC address, it prints the address
 *		  in the usual colon-separated hex notation
 * - 'm' For a 6-byte MAC address, it prints the hex
 *		  address without colons
 */

In case of p54, the kernel now prints:
 phy4: hwaddr 000011223344, mac:isl3892 rf:Xbow

and before the commit, it looked like this:
 phy4: hwaddr 00:00:11:22:33:44, mac:isl3892 rf:Xbow

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index a105087..382ae72 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1902,7 +1902,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		goto err_free_eeprom;
 	}
 
-	wiphy_info(dev->wiphy, "hwaddr %pm, rev 0x%02x\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, rev 0x%02x\n",
 		   dev->wiphy->perm_addr, pdev->revision);
 
 	return 0;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index d5140a8..b1c2667 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2310,7 +2310,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	priv->mac80211_registered = 1;
 
-	wiphy_info(priv->hw->wiphy, "usb %s, mac %pm, firmware %d.%d.%d-%d\n",
+	wiphy_info(priv->hw->wiphy, "usb %s, mac %pM, firmware %d.%d.%d-%d\n",
 		   dev_name(&interface->dev), priv->mac_addr,
 		   priv->fw_version.major, priv->fw_version.minor,
 		   priv->fw_version.patch, priv->fw_version.build);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c67b05f..cabf57f 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -387,7 +387,7 @@ static struct sk_buff *ar9170_get_queued_skb(struct ar9170 *ar,
 		if (mac && compare_ether_addr(ieee80211_get_DA(hdr), mac)) {
 #ifdef AR9170_QUEUE_DEBUG
 			wiphy_debug(ar->hw->wiphy,
-				    "skip frame => da %pm != %pm\n",
+				    "skip frame => da %pM != %pM\n",
 				    mac, ieee80211_get_DA(hdr));
 			ar9170_print_txheader(ar, skb);
 #endif /* AR9170_QUEUE_DEBUG */
@@ -495,7 +495,7 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 			AR9170_TX_PHY_QOS_SHIFT;
 #ifdef AR9170_QUEUE_DEBUG
 		wiphy_debug(ar->hw->wiphy,
-			    "recv tx_status for %pm, p:%08x, q:%d\n",
+			    "recv tx_status for %pM, p:%08x, q:%d\n",
 			    cmd->tx_status.dst, phy, q);
 #endif /* AR9170_QUEUE_DEBUG */
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 01ad7f7..05d179a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1467,7 +1467,7 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		}
 
-		wiphy_debug(hw->wiphy, "hwaddr %pm registered\n",
+		wiphy_debug(hw->wiphy, "hwaddr %pM registered\n",
 			    hw->wiphy->perm_addr);
 
 		data->debugfs = debugfs_create_dir("hwsim",
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d761ed2..31888da 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4102,7 +4102,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_free_queues;
 	}
 
-	wiphy_info(hw->wiphy, "%s v%d, %pm, %s firmware %u.%u.%u.%u\n",
+	wiphy_info(hw->wiphy, "%s v%d, %pM, %s firmware %u.%u.%u.%u\n",
 		   priv->device_info->part_name,
 		   priv->hw_rev, hw->wiphy->perm_addr,
 		   priv->ap_fw ? "AP" : "STA",
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d687cb7..92facc3 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -700,7 +700,7 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 	}
 
-	wiphy_info(dev->wiphy, "hwaddr %pm, mac:isl38%02x rf:%s\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, mac:isl38%02x rf:%s\n",
 		   dev->wiphy->perm_addr, priv->version,
 		   p54_rf_chips[priv->rxhw]);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index b50c39a..67b3227 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -1107,7 +1107,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	wiphy_info(dev->wiphy, "hwaddr %pm, %s + %s\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, %s + %s\n",
 		   mac_addr, chip_name, priv->rf->name);
 
 	return 0;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 5738a55..efa2860 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1526,7 +1526,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	mutex_init(&priv->conf_mutex);
 	skb_queue_head_init(&priv->b_tx_status.queue);
 
-	wiphy_info(dev->wiphy, "hwaddr %pm, %s v%d + %s, rfkill mask %d\n",
+	wiphy_info(dev->wiphy, "hwaddr %pM, %s v%d + %s, rfkill mask %d\n",
 		   mac_addr, chip_name, priv->asic_rev, priv->rf->name,
 		   priv->rfkill_mask);
 
