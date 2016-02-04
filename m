Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58454 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbcBDJa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:30:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 41/70] staging: wilc1000: linux_mon.c: replaces PRINT_ER with netdev_err
Date: Thu, 4 Feb 2016 18:24:02 +0900
Message-ID: <1454577871-667-2-git-send-email-glen.lee@atmel.com> (sfid-20160204_103106_510797_7698E2A7)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patches replaces PRINT_ER with netdev_err.
Removes unnecessary debug logs as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index e9bb0ec..f0a94e5 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -157,10 +157,8 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct tx_complete_mon_data *mgmt_tx = NULL;
 
-	if (!dev) {
-		PRINT_D(HOSTAPD_DBG, "ERROR: dev == NULL\n");
+	if (!dev)
 		return -EFAULT;
-	}
 
 	netif_stop_queue(dev);
 	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
@@ -205,17 +203,12 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		return -EFAULT;
 
 	mon_priv = netdev_priv(wilc_wfi_mon);
-
-	if (!mon_priv) {
-		PRINT_ER("Monitor interface private structure is NULL\n");
+	if (!mon_priv)
 		return -EFAULT;
-	}
-
 	rtap_len = ieee80211_get_radiotap_len(skb->data);
-	if (skb->len < rtap_len) {
-		PRINT_ER("Error in radiotap header\n");
+	if (skb->len < rtap_len)
 		return -1;
-	}
+
 	/* skip the radiotap header */
 	PRINT_INFO(HOSTAPD_DBG, "Radiotap len: %d\n", rtap_len);
 
@@ -273,7 +266,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	/* if source address and bssid fields are equal>>Mac header */
 	/*send it to mgmt frames handler */
 	if (!(memcmp(srcAdd, bssid, 6))) {
-		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
+		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
+		if (ret)
+			netdev_err(dev, "fail to mgmt tx\n");
 		dev_kfree_skb(skb);
 	} else {
 		ret = wilc_mac_xmit(skb, mon_priv->real_ndev);
@@ -307,11 +302,8 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 	}
 
 	wilc_wfi_mon = alloc_etherdev(sizeof(struct WILC_WFI_mon_priv));
-	if (!wilc_wfi_mon) {
-		PRINT_ER("failed to allocate memory\n");
+	if (!wilc_wfi_mon)
 		return NULL;
-	}
-
 	wilc_wfi_mon->type = ARPHRD_IEEE80211_RADIOTAP;
 	strncpy(wilc_wfi_mon->name, name, IFNAMSIZ);
 	wilc_wfi_mon->name[IFNAMSIZ - 1] = 0;
@@ -319,14 +311,12 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 
 	ret = register_netdevice(wilc_wfi_mon);
 	if (ret) {
-		PRINT_ER(" register_netdevice failed (%d)\n", ret);
+		netdev_err(real_dev, "register_netdevice failed\n");
 		return NULL;
 	}
 	priv = netdev_priv(wilc_wfi_mon);
-	if (!priv) {
-		PRINT_ER("private structure is NULL\n");
+	if (!priv)
 		return NULL;
-	}
 
 	priv->real_ndev = real_dev;
 
-- 
1.9.1

