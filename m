Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16110 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1GVFnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 26/31] ath6kl: Use bit field macros to maintain wlan enabled and disabled status
Date: Fri, 22 Jul 2011 08:41:59 +0300
Message-ID: <1311313324-6766-28-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074343_310031_986B51C1)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +------
 drivers/net/wireless/ath/ath6kl/init.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4284a41..a70d2ac 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -223,7 +223,7 @@ static bool ath6kl_cfg80211_ready(struct ath6kl *ar)
 		return false;
 	}
 
-	if (ar->wlan_state == WLAN_DISABLED) {
+	if (!test_bit(WLAN_ENABLED, &ar->flag)) {
 		ath6kl_err("wlan disabled\n");
 		return false;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 86177f0..6778475 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -134,11 +134,6 @@ enum sme_state {
 	SME_CONNECTED
 };
 
-enum ath6kl_wlan_state {
-	WLAN_DISABLED,
-	WLAN_ENABLED
-};
-
 struct skb_hold_q {
 	struct sk_buff *skb;
 	bool is_amsdu;
@@ -365,6 +360,7 @@ struct ath6kl_req_key {
 #define DESTROY_IN_PROGRESS  9
 #define NETDEV_REGISTERED    10
 #define SKIP_SCAN	     11
+#define WLAN_ENABLED	     12
 
 struct ath6kl {
 	struct device *dev;
@@ -401,7 +397,6 @@ struct ath6kl {
 	u8 tx_pwr;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
-	enum ath6kl_wlan_state wlan_state;
 	struct ath6kl_node_mapping node_map[MAX_NODE_NUM];
 	u8 ibss_ps_enable;
 	u8 node_num;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index fe61871..d574d08 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -584,7 +584,7 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	init_netdev(dev);
 
 	ar->net_dev = dev;
-	ar->wlan_state = WLAN_ENABLED;
+	set_bit(WLAN_ENABLED, &ar->flag);
 
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
 
@@ -1239,7 +1239,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	if (ar->wlan_pwr_state != WLAN_POWER_STATE_CUT_PWR)
 		ath6kl_stop_endpoint(ndev, false, true);
 
-	ar->wlan_state = WLAN_DISABLED;
+	clear_bit(WLAN_ENABLED, &ar->flag);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f325a23..284e3e9 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1275,7 +1275,7 @@ static int ath6kl_open(struct net_device *dev)
 
 	spin_lock_irqsave(&ar->lock, flags);
 
-	ar->wlan_state = WLAN_ENABLED;
+	set_bit(WLAN_ENABLED, &ar->flag);
 
 	if (test_bit(CONNECTED, &ar->flag)) {
 		netif_carrier_on(dev);
@@ -1301,7 +1301,7 @@ static int ath6kl_close(struct net_device *dev)
 					      0, 0, 0))
 			return -EIO;
 
-		ar->wlan_state = WLAN_DISABLED;
+		clear_bit(WLAN_ENABLED, &ar->flag);
 	}
 
 	ath6kl_cfg80211_scan_complete_event(ar, -ECANCELED);
-- 
1.7.1

