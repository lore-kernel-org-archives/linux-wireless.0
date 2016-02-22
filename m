Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29585 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbcBVEO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:14:59 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V3 02/24] staging: wilc1000: linux_mon.c: removes debug logs
Date: Mon, 22 Feb 2016 13:11:47 +0900
Message-ID: <1456114329-7036-3-git-send-email-leo.kim@atmel.com> (sfid-20160222_051501_682322_CECEE4A5)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes unnecessary debug logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 9fcb497..558fb50 100644
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
 
@@ -306,11 +299,8 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 		return wilc_wfi_mon;
 
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
@@ -322,10 +312,8 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
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

