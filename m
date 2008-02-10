Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53733 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYBJPL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:11:57 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 10/12] Allocate struct at76_priv using ieee80211_alloc_hw()
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:01:04 +0200
Message-ID: <20080210150104.17592.93910.stgit@tikku> (sfid-20080210_151201_912214_91F3E232)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is for the preparation to remove struct net_device.

Also netdev is not registered anymore so the legacy stack does not have
visible interface anymore.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   74 +++++++++++++++------------------------
 drivers/net/wireless/at76_usb.h |    2 +
 2 files changed, 30 insertions(+), 46 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 8391443..38a89b4 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5224,8 +5224,7 @@ static void at76_mac80211_tx_callback(struct urb *urb)
 static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
-	struct at76_mac80211_priv *mac80211_priv = hw->priv;
-	struct at76_priv *priv = mac80211_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
 	int padding, submit_len, ret;
 
@@ -5281,8 +5280,7 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 static int at76_mac80211_start(struct ieee80211_hw *hw)
 {
-	struct at76_mac80211_priv *mac80211_priv = hw->priv;
-	struct at76_priv *priv = mac80211_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 	int ret;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
@@ -5308,8 +5306,7 @@ error:
 
 static void at76_mac80211_stop(struct ieee80211_hw *hw)
 {
-	struct at76_mac80211_priv *mac80211_priv = hw->priv;
-	struct at76_priv *priv = mac80211_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 
@@ -5331,8 +5328,7 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 static int at76_add_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 	int ret = 0;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
@@ -5430,8 +5426,7 @@ exit:
 
 static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 	struct at76_req_scan scan;
 	int ret;
 
@@ -5475,8 +5470,7 @@ exit:
 
 static int at76_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s(): channel %d radio %d",
 		 __func__, conf->channel->hw_value, conf->radio_enabled);
@@ -5501,8 +5495,7 @@ static int at76_config_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_if_conf *conf)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s(): ssid_len=%zd", __func__, conf->ssid_len);
 	at76_dbg_dump(DBG_MAC80211, conf->ssid, conf->ssid_len, "ssid:");
@@ -5529,8 +5522,7 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 				  unsigned int *total_flags, int mc_count,
 				  struct dev_addr_list *mc_list)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
 	int flags;
 
 	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
@@ -5560,8 +5552,8 @@ static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			const u8 *local_address, const u8 *address,
 			struct ieee80211_key_conf *key)
 {
-	struct at76_mac80211_priv *m_priv = hw->priv;
-	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_priv *priv = hw->priv;
+
 	int i;
 
 	at76_dbg(DBG_MAC80211, "%s(): cmd %d key->alg %d key->keyidx %d "
@@ -5621,19 +5613,31 @@ static const struct ieee80211_ops at76_ops = {
 /* Allocate network device and initialize private data */
 static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 {
-	struct at76_mac80211_priv *mac80211_priv;
+	struct at76_netdev_priv *netdevice_priv;
 	struct net_device *netdev;
+	struct ieee80211_hw *hw;
 	struct at76_priv *priv;
 	int i;
 
+	hw = ieee80211_alloc_hw(sizeof(struct at76_priv), &at76_ops);
+	if (!hw) {
+		printk(KERN_ERR DRIVER_NAME ": could not register"
+		       " ieee80211_hw\n");
+		return NULL;
+	}
+
+	priv = hw->priv;
+	priv->hw = hw;
+
 	/* allocate memory for our device state and initialize it */
-	netdev = alloc_etherdev(sizeof(struct at76_priv));
+	netdev = alloc_etherdev(sizeof(struct at76_netdev_priv));
 	if (!netdev) {
 		dev_printk(KERN_ERR, &udev->dev, "out of memory\n");
 		return NULL;
 	}
 
-	priv = netdev_priv(netdev);
+	netdevice_priv = netdev_priv(netdev);
+	netdevice_priv->at76_priv = NULL;
 
 	priv->udev = udev;
 	priv->netdev = netdev;
@@ -5677,17 +5681,6 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
 
-	priv->hw = ieee80211_alloc_hw(sizeof(struct at76_mac80211_priv),
-				      &at76_ops);
-	if (!priv->hw) {
-		printk(KERN_ERR DRIVER_NAME ": could not register"
-		       " ieee80211_hw\n");
-		return NULL;
-	}
-
-	mac80211_priv = priv->hw->priv;
-	mac80211_priv->at76_priv = priv;
-
 	/* unit us */
 	priv->hw->channel_change_time = 100000;
 
@@ -5864,14 +5857,6 @@ static int at76_init_new_device(struct at76_priv *priv,
 	netdev->set_mac_address = at76_set_mac_address;
 	dev_alloc_name(netdev, "wlan%d");
 
-	ret = register_netdev(priv->netdev);
-	if (ret) {
-		dev_printk(KERN_ERR, &interface->dev,
-			   "cannot register netdevice (status %d)!\n", ret);
-		goto exit;
-	}
-	priv->netdev_registered = 1;
-
 	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
 	       netdev->name, interface->dev.bus_id, mac2str(priv->mac_addr),
 	       priv->fw_version.major, priv->fw_version.minor,
@@ -5917,9 +5902,6 @@ static void at76_delete_device(struct at76_priv *priv)
 	if (priv->mac80211_registered)
 		ieee80211_unregister_hw(priv->hw);
 
-	ieee80211_free_hw(priv->hw);
-	priv->hw = NULL;
-
 	/* assuming we used keventd, it must quiesce too */
 	flush_scheduled_work();
 
@@ -5956,8 +5938,10 @@ static void at76_delete_device(struct at76_priv *priv)
 		}
 	usb_put_dev(priv->udev);
 
-	at76_dbg(DBG_PROC_ENTRY, "%s: before freeing priv/netdev", __func__);
-	free_netdev(priv->netdev);	/* priv is in netdev */
+	at76_dbg(DBG_PROC_ENTRY, "%s: before freeing priv/ieee80211_hw",
+		 __func__);
+	free_netdev(priv->netdev);
+	ieee80211_free_hw(priv->hw);
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
 }
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 5375f75..a79e33e 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -563,7 +563,7 @@ struct at76_priv {
 	int mac80211_registered;
 };
 
-struct at76_mac80211_priv {
+struct at76_netdev_priv {
 	struct at76_priv *at76_priv;
 };
 

