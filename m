Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbcHBLoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:44:05 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 8/8] wil6210: fix wiphy registration sequence
Date: Tue,  2 Aug 2016 14:42:12 +0300
Message-Id: <1470138132-18071-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_194755_400684_B5492DCD)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Currently wiphy structure is initialized and registered
in wil_if_alloc, before some information is available such
as MAC address and capabilities. As a result there is a
small chance user space will get incorrect information
from calls such as NL80211_CMD_GET_WIPHY.
Fix this by seperating the registration and moving it
to wil_if_add which is executed later, after all
relevant information is known.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  7 -------
 drivers/net/wireless/ath/wil6210/main.c     |  3 +++
 drivers/net/wireless/ath/wil6210/netdev.c   | 32 +++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 310a385..ffacc76 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1503,14 +1503,8 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev)
 	set_wiphy_dev(wdev->wiphy, dev);
 	wil_wiphy_init(wdev->wiphy);
 
-	rc = wiphy_register(wdev->wiphy);
-	if (rc < 0)
-		goto out_failed_reg;
-
 	return wdev;
 
-out_failed_reg:
-	wiphy_free(wdev->wiphy);
 out:
 	kfree(wdev);
 
@@ -1526,7 +1520,6 @@ void wil_wdev_free(struct wil6210_priv *wil)
 	if (!wdev)
 		return;
 
-	wiphy_unregister(wdev->wiphy);
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index dd0ee7f..d0b180c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -232,6 +232,9 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 
+	if (unlikely(!ndev))
+		return;
+
 	might_sleep();
 	wil_info(wil, "%s(bssid=%pM, reason=%d, ev%s)\n", __func__, bssid,
 		 reason_code, from_event ? "+" : "-");
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 0984097..4bc9bb0a 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -179,13 +179,6 @@ void *wil_if_alloc(struct device *dev)
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
-	netif_napi_add(ndev, &wil->napi_rx, wil6210_netdev_poll_rx,
-		       WIL6210_NAPI_BUDGET);
-	netif_tx_napi_add(ndev, &wil->napi_tx, wil6210_netdev_poll_tx,
-		       WIL6210_NAPI_BUDGET);
-
-	netif_tx_stop_all_queues(ndev);
-
 	return wil;
 
  out_priv:
@@ -216,25 +209,46 @@ void wil_if_free(struct wil6210_priv *wil)
 
 int wil_if_add(struct wil6210_priv *wil)
 {
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+	struct wiphy *wiphy = wdev->wiphy;
 	struct net_device *ndev = wil_to_ndev(wil);
 	int rc;
 
-	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "entered");
+
+	rc = wiphy_register(wiphy);
+	if (rc < 0) {
+		wil_err(wil, "failed to register wiphy, err %d\n", rc);
+		return rc;
+	}
+
+	netif_napi_add(ndev, &wil->napi_rx, wil6210_netdev_poll_rx,
+		       WIL6210_NAPI_BUDGET);
+	netif_tx_napi_add(ndev, &wil->napi_tx, wil6210_netdev_poll_tx,
+			  WIL6210_NAPI_BUDGET);
+
+	netif_tx_stop_all_queues(ndev);
 
 	rc = register_netdev(ndev);
 	if (rc < 0) {
 		dev_err(&ndev->dev, "Failed to register netdev: %d\n", rc);
-		return rc;
+		goto out_wiphy;
 	}
 
 	return 0;
+
+out_wiphy:
+	wiphy_unregister(wdev->wiphy);
+	return rc;
 }
 
 void wil_if_remove(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	unregister_netdev(ndev);
+	wiphy_unregister(wdev->wiphy);
 }
-- 
1.9.1

