Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56991 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJ1Oui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:50:38 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/5] wil6210: prevent double disconnect command issuing
Date: Tue, 28 Oct 2014 16:50:08 +0200
Message-ID: <1414507810-23141-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155041_845647_249F343B)
In-Reply-To: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disconnect flow may be invoked either from upper layer request,
or from event reported by the firmware.

In case of firmware event, driver need to release resources for the station but
not send another disconnect WMI command.

In case of upper layer request, WMI_DISCONNECT_STA_CMDID command need to
be issued for the firmware to perform disconnect on the MAC layer. Eventually,
event is expected to confirm MAC disconnect, but it is better to not wait for
firmware event and release station resources immediately. FW may fail to
report disconnect for various reasons, so one could not rely on event always reported.

Introduce parameter to distinguish 2 cases above to prevent double WMI command
issuing.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/ath/wil6210/main.c     | 35 ++++++++++++++++++++---------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c      |  2 +-
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d9f4b30..4248fb3 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -797,7 +797,7 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, mac);
+	wil6210_disconnect(wil, mac, false);
 	mutex_unlock(&wil->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0e95557..b3a84ae 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -74,7 +74,8 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 		__raw_writel(*s++, d++);
 }
 
-static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
+static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
+			       bool from_event)
 {
 	uint i;
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -86,7 +87,10 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 
 	sta->data_port_open = false;
 	if (sta->status != wil_sta_unused) {
-		wmi_disconnect_sta(wil, sta->addr, WLAN_REASON_DEAUTH_LEAVING);
+		if (!from_event)
+			wmi_disconnect_sta(wil, sta->addr,
+					   WLAN_REASON_DEAUTH_LEAVING);
+
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
@@ -118,7 +122,8 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 	memset(&sta->stats, 0, sizeof(sta->stats));
 }
 
-static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
+static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
+				bool from_event)
 {
 	int cid = -ENOENT;
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -133,10 +138,10 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 	}
 
 	if (cid >= 0) /* disconnect 1 peer */
-		wil_disconnect_cid(wil, cid);
+		wil_disconnect_cid(wil, cid, from_event);
 	else /* disconnect all */
 		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
-			wil_disconnect_cid(wil, cid);
+			wil_disconnect_cid(wil, cid, from_event);
 
 	/* link state */
 	switch (wdev->iftype) {
@@ -166,7 +171,7 @@ static void wil_disconnect_worker(struct work_struct *work)
 			struct wil6210_priv, disconnect_worker);
 
 	mutex_lock(&wil->mutex);
-	_wil6210_disconnect(wil, NULL);
+	_wil6210_disconnect(wil, NULL, false);
 	mutex_unlock(&wil->mutex);
 }
 
@@ -351,12 +356,22 @@ int wil_priv_init(struct wil6210_priv *wil)
 	return 0;
 }
 
-void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
+/**
+ * wil6210_disconnect - disconnect one connection
+ * @wil: driver context
+ * @bssid: peer to disconnect, NULL to disconnect all
+ * @from_event: whether is invoked from FW event handler
+ *
+ * Disconnect and release associated resources. If invoked not from the
+ * FW event handler, issue WMI command(s) to trigger MAC disconnect.
+ */
+void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
+			bool from_event)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	del_timer_sync(&wil->connect_timer);
-	_wil6210_disconnect(wil, bssid);
+	_wil6210_disconnect(wil, bssid, from_event);
 }
 
 void wil_priv_deinit(struct wil6210_priv *wil)
@@ -368,7 +383,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, NULL);
+	wil6210_disconnect(wil, NULL, false);
 	mutex_unlock(&wil->mutex);
 	wmi_event_flush(wil);
 	destroy_workqueue(wil->wmi_wq_conn);
@@ -553,7 +568,7 @@ int wil_reset(struct wil6210_priv *wil)
 	WARN_ON(test_bit(wil_status_napi_en, &wil->status));
 
 	cancel_work_sync(&wil->disconnect_worker);
-	wil6210_disconnect(wil, NULL);
+	wil6210_disconnect(wil, NULL, false);
 
 	wil->status = 0; /* prevent NAPI from being scheduled */
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 18f8729..3674e27 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -584,7 +584,8 @@ void wil_wdev_free(struct wil6210_priv *wil);
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
 int wmi_pcp_stop(struct wil6210_priv *wil);
-void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid);
+void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
+			bool from_event);
 
 int wil_rx_init(struct wil6210_priv *wil);
 void wil_rx_fini(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 4311df9..9661fa1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -486,7 +486,7 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 	wil->sinfo_gen++;
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, evt->bssid);
+	wil6210_disconnect(wil, evt->bssid, true);
 	mutex_unlock(&wil->mutex);
 }
 
-- 
2.1.0

