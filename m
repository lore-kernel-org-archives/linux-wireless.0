Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbbAYIx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:26 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 02/10] wil6210: fix timing of netif_carrier_on indication
Date: Sun, 25 Jan 2015 10:52:43 +0200
Message-Id: <1422175971-8075-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095334_551454_58C048EA)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

netif_carrier_on indication was too late. In case Rx packet received
before netif_carrier_on indication, upper layers could not send
Tx packet back.

The fix is to indicate netif_carrier_on earlier:
for STA, indicate netif_carrier_on when association starts.
for AP/PCP, indicate netif_carrier_on upon starting AP/PCP.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  8 +++++---
 drivers/net/wireless/ath/wil6210/main.c     | 30 ++++++-----------------------
 drivers/net/wireless/ath/wil6210/netdev.c   |  4 +---
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 --
 drivers/net/wireless/ath/wil6210/wmi.c      |  2 --
 5 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index bd013fd..553aa2e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -454,6 +454,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
 	if (rc == 0) {
+		netif_carrier_on(ndev);
 		/* Connect can take lots of time */
 		mod_timer(&wil->connect_timer,
 			  jiffies + msecs_to_jiffies(2000));
@@ -757,12 +758,12 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	wil->secure_pcp = info->privacy;
 
+	netif_carrier_on(ndev);
+
 	rc = wmi_pcp_start(wil, info->beacon_interval, wmi_nettype,
 			   channel->hw_value);
 	if (rc)
-		goto out;
-
-	netif_carrier_on(ndev);
+		netif_carrier_off(ndev);
 
 out:
 	mutex_unlock(&wil->mutex);
@@ -777,6 +778,7 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	netif_carrier_off(ndev);
 	wil_set_recovery_state(wil, fw_recovery_idle);
 
 	mutex_lock(&wil->mutex);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 62dc241..00c9b0f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -248,7 +248,9 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wil_link_off(wil);
+		netif_tx_stop_all_queues(ndev);
+		netif_carrier_off(ndev);
+
 		if (test_bit(wil_status_fwconnected, wil->status)) {
 			clear_bit(wil_status_fwconnected, wil->status);
 			cfg80211_disconnected(ndev, reason_code,
@@ -395,6 +397,8 @@ static void wil_connect_worker(struct work_struct *work)
 	int rc;
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
 						connect_worker);
+	struct net_device *ndev = wil_to_ndev(wil);
+
 	int cid = wil->pending_connect_cid;
 	int ringid = wil_find_free_vring(wil);
 
@@ -409,7 +413,7 @@ static void wil_connect_worker(struct work_struct *work)
 	wil->pending_connect_cid = -1;
 	if (rc == 0) {
 		wil->sta[cid].status = wil_sta_connected;
-		wil_link_on(wil);
+		netif_tx_wake_all_queues(ndev);
 	} else {
 		wil->sta[cid].status = wil_sta_unused;
 	}
@@ -741,28 +745,6 @@ void wil_fw_error_recovery(struct wil6210_priv *wil)
 	schedule_work(&wil->fw_error_worker);
 }
 
-void wil_link_on(struct wil6210_priv *wil)
-{
-	struct net_device *ndev = wil_to_ndev(wil);
-
-	wil_dbg_misc(wil, "%s()\n", __func__);
-
-	netif_carrier_on(ndev);
-	wil_dbg_misc(wil, "netif_tx_wake : link on\n");
-	netif_tx_wake_all_queues(ndev);
-}
-
-void wil_link_off(struct wil6210_priv *wil)
-{
-	struct net_device *ndev = wil_to_ndev(wil);
-
-	wil_dbg_misc(wil, "%s()\n", __func__);
-
-	netif_tx_stop_all_queues(ndev);
-	wil_dbg_misc(wil, "netif_tx_stop : link off\n");
-	netif_carrier_off(ndev);
-}
-
 int __wil_up(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index e81703c..f1f9e51 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -174,7 +174,7 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	netif_napi_add(ndev, &wil->napi_tx, wil6210_netdev_poll_tx,
 		       WIL6210_NAPI_BUDGET);
 
-	wil_link_off(wil);
+	netif_tx_stop_all_queues(ndev);
 
 	return wil;
 
@@ -217,8 +217,6 @@ int wil_if_add(struct wil6210_priv *wil)
 		return rc;
 	}
 
-	wil_link_off(wil);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index da3fe78..b4404e7 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -649,8 +649,6 @@ void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_set_recovery_state(struct wil6210_priv *wil, int state);
-void wil_link_on(struct wil6210_priv *wil);
-void wil_link_off(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
 int __wil_up(struct wil6210_priv *wil);
 int wil_down(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 097d78b..0f3e433 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -566,7 +566,6 @@ static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid, u16 wsize)
 
 static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 {
-	struct net_device *ndev = wil_to_ndev(wil);
 	struct wmi_data_port_open_event *evt = d;
 	u8 cid = evt->cid;
 
@@ -580,7 +579,6 @@ static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 	wil->sta[cid].data_port_open = true;
 	if (agg_wsize >= 0)
 		wil_addba_tx_cid(wil, cid, agg_wsize);
-	netif_carrier_on(ndev);
 }
 
 static void wmi_evt_linkdown(struct wil6210_priv *wil, int id, void *d, int len)
-- 
2.1.0

