Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37409 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1JYKK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:10:56 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 05/34] ath6kl: Define an initial vif structure and use it
Date: Tue, 25 Oct 2011 15:40:01 +0530
Message-ID: <1319537430-12459-6-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121058_940431_E539337D)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif specific information need to be moved from struct ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   21 ++++++++++++---------
 drivers/net/wireless/ath/ath6kl/core.h     |    9 ++++++++-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fcddf1a..88ce9cc 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2046,19 +2046,22 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 					enum nl80211_iftype type)
 {
 	struct net_device *ndev;
-	struct wireless_dev *wdev;
+	struct ath6kl_vif *vif;
 
-	ndev = alloc_netdev(sizeof(*wdev), "wlan%d", ether_setup);
+	ndev = alloc_netdev(sizeof(*vif), "wlan%d", ether_setup);
 	if (!ndev)
 		return NULL;
 
-	wdev = netdev_priv(ndev);
-	ndev->ieee80211_ptr = wdev;
-	wdev->wiphy = ar->wiphy;
-	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
-	wdev->netdev = ndev;
-	wdev->iftype = type;
-	ar->wdev = wdev;
+	vif = netdev_priv(ndev);
+	ndev->ieee80211_ptr = &vif->wdev;
+	vif->wdev.wiphy = ar->wiphy;
+	vif->ar = ar;
+	ar->vif = vif;
+	vif->ndev = ndev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(vif->wdev.wiphy));
+	vif->wdev.netdev = ndev;
+	vif->wdev.iftype = type;
+	ar->wdev = &vif->wdev;
 	ar->net_dev = ndev;
 
 	init_netdev(ndev);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index d827551..01ebfd5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,6 +380,12 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+struct ath6kl_vif {
+	struct wireless_dev wdev;
+	struct net_device *ndev;
+	struct ath6kl *ar;
+};
+
 /* Flag info */
 #define WMI_ENABLED	0
 #define WMI_READY	1
@@ -410,6 +416,7 @@ struct ath6kl {
 	int total_tx_data_pend;
 	struct htc_target *htc_target;
 	void *hif_priv;
+	struct ath6kl_vif *vif;
 	spinlock_t lock;
 	struct semaphore sem;
 	int ssid_len;
@@ -543,7 +550,7 @@ struct ath6kl {
 
 static inline void *ath6kl_priv(struct net_device *dev)
 {
-	return wdev_priv(dev->ieee80211_ptr);
+	return ((struct ath6kl_vif *) netdev_priv(dev))->ar;
 }
 
 static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
-- 
1.7.0.4

