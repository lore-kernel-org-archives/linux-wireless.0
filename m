Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33078 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYBJPN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:13:26 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 11/12] Prepare for struct net_device removal
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:01:11 +0200
Message-ID: <20080210150111.17592.70564.stgit@tikku> (sfid-20080210_151331_222179_74A8E29D)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cleanup to make it easier to remove the struct net_device.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 38a89b4..4832198 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5026,7 +5026,7 @@ static void at76_rx_tasklet(unsigned long param)
 		return;
 	}
 
-	if (!priv->rx_skb || !netdev || !priv->rx_skb->data)
+	if (!priv->rx_skb || !priv->rx_skb->data)
 		return;
 
 	buf = (struct at76_rx_buffer *)priv->rx_skb->data;
@@ -5045,10 +5045,9 @@ static void at76_rx_tasklet(unsigned long param)
 	}
 
 	at76_dbg(DBG_RX_ATMEL_HDR,
-		 "%s: rx frame: rate %d rssi %d noise %d link %d %s",
+		 "%s: rx frame: rate %d rssi %d noise %d link %d",
 		 wiphy_name(priv->hw->wiphy), buf->rx_rate, buf->rssi,
-		 buf->noise_level, buf->link_quality,
-		 hex2str(i802_11_hdr, 48));
+		 buf->noise_level, buf->link_quality);
 
 	{
 		struct ieee80211_rx_status rx_status = {0};
@@ -5857,13 +5856,6 @@ static int at76_init_new_device(struct at76_priv *priv,
 	netdev->set_mac_address = at76_set_mac_address;
 	dev_alloc_name(netdev, "wlan%d");
 
-	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
-	       netdev->name, interface->dev.bus_id, mac2str(priv->mac_addr),
-	       priv->fw_version.major, priv->fw_version.minor,
-	       priv->fw_version.patch, priv->fw_version.build);
-	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n", netdev->name,
-	       priv->regulatory_domain, priv->domain->name);
-
 	/* we let this timer run the whole time this driver instance lives */
 	mod_timer(&priv->bss_list_timer, jiffies + BSS_LIST_TIMEOUT);
 
@@ -5883,6 +5875,15 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	priv->mac80211_registered = 1;
 
+	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
+	       wiphy_name(priv->hw->wiphy),
+	       interface->dev.bus_id, mac2str(priv->mac_addr),
+	       priv->fw_version.major, priv->fw_version.minor,
+	       priv->fw_version.patch, priv->fw_version.build);
+	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n",
+	       wiphy_name(priv->hw->wiphy),
+	       priv->regulatory_domain, priv->domain->name);
+
 exit:
 	return ret;
 }

