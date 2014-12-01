Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45181 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaLANds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:33:48 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/9] wil6210: propagate disconnect reason
Date: Mon, 1 Dec 2014 15:33:15 +0200
Message-ID: <1417440803-26883-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143352_494832_E1B4BB3F)
In-Reply-To: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Propagate reason for the disconnect through the relevant call chains:
- report to cfg80211 reason as reported by the firmware
- provide to the firmware reason as requested by cfg80211

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/ath/wil6210/main.c     | 25 ++++++++++++-------------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  8 ++++----
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 0fc0b9f..38332a6 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -798,7 +798,7 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, params->mac, false);
+	wil6210_disconnect(wil, params->mac, params->reason_code, false);
 	mutex_unlock(&wil->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6212983..151ff6b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -104,7 +104,7 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 }
 
 static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
-			       bool from_event)
+			       u16 reason_code, bool from_event)
 {
 	uint i;
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -117,8 +117,7 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 	sta->data_port_open = false;
 	if (sta->status != wil_sta_unused) {
 		if (!from_event)
-			wmi_disconnect_sta(wil, sta->addr,
-					   WLAN_REASON_DEAUTH_LEAVING);
+			wmi_disconnect_sta(wil, sta->addr, reason_code);
 
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_AP:
@@ -152,7 +151,7 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 }
 
 static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
-				bool from_event)
+				u16 reason_code, bool from_event)
 {
 	int cid = -ENOENT;
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -167,10 +166,10 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	}
 
 	if (cid >= 0) /* disconnect 1 peer */
-		wil_disconnect_cid(wil, cid, from_event);
+		wil_disconnect_cid(wil, cid, reason_code, from_event);
 	else /* disconnect all */
 		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
-			wil_disconnect_cid(wil, cid, from_event);
+			wil_disconnect_cid(wil, cid, reason_code, from_event);
 
 	/* link state */
 	switch (wdev->iftype) {
@@ -179,8 +178,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 		wil_link_off(wil);
 		if (test_bit(wil_status_fwconnected, &wil->status)) {
 			clear_bit(wil_status_fwconnected, &wil->status);
-			cfg80211_disconnected(ndev,
-					      WLAN_STATUS_UNSPECIFIED_FAILURE,
+			cfg80211_disconnected(ndev, reason_code,
 					      NULL, 0, GFP_KERNEL);
 		} else if (test_bit(wil_status_fwconnecting, &wil->status)) {
 			cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
@@ -200,7 +198,7 @@ static void wil_disconnect_worker(struct work_struct *work)
 			struct wil6210_priv, disconnect_worker);
 
 	mutex_lock(&wil->mutex);
-	_wil6210_disconnect(wil, NULL, false);
+	_wil6210_disconnect(wil, NULL, WLAN_REASON_UNSPECIFIED, false);
 	mutex_unlock(&wil->mutex);
 }
 
@@ -392,18 +390,19 @@ int wil_priv_init(struct wil6210_priv *wil)
  * wil6210_disconnect - disconnect one connection
  * @wil: driver context
  * @bssid: peer to disconnect, NULL to disconnect all
+ * @reason_code: Reason code for the Disassociation frame
  * @from_event: whether is invoked from FW event handler
  *
  * Disconnect and release associated resources. If invoked not from the
  * FW event handler, issue WMI command(s) to trigger MAC disconnect.
  */
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
-			bool from_event)
+			u16 reason_code, bool from_event)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	del_timer_sync(&wil->connect_timer);
-	_wil6210_disconnect(wil, bssid, from_event);
+	_wil6210_disconnect(wil, bssid, reason_code, from_event);
 }
 
 void wil_priv_deinit(struct wil6210_priv *wil)
@@ -415,7 +414,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, NULL, false);
+	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	mutex_unlock(&wil->mutex);
 	wmi_event_flush(wil);
 	destroy_workqueue(wil->wmi_wq_conn);
@@ -600,7 +599,7 @@ int wil_reset(struct wil6210_priv *wil)
 	WARN_ON(test_bit(wil_status_napi_en, &wil->status));
 
 	cancel_work_sync(&wil->disconnect_worker);
-	wil6210_disconnect(wil, NULL, false);
+	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 
 	wil->status = 0; /* prevent NAPI from being scheduled */
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 95d3a06..18cff53 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -586,7 +586,7 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
 int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
-			bool from_event);
+			u16 reason_code, bool from_event);
 
 int wil_rx_init(struct wil6210_priv *wil);
 void wil_rx_fini(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index bb1e066..63476c8 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -478,15 +478,15 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 			       void *d, int len)
 {
 	struct wmi_disconnect_event *evt = d;
+	u16 reason_code = le16_to_cpu(evt->protocol_reason_status);
 
-	wil_dbg_wmi(wil, "Disconnect %pM reason %d proto %d wmi\n",
-		    evt->bssid,
-		    evt->protocol_reason_status, evt->disconnect_reason);
+	wil_dbg_wmi(wil, "Disconnect %pM reason [proto %d wmi %d]\n",
+		    evt->bssid, reason_code, evt->disconnect_reason);
 
 	wil->sinfo_gen++;
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, evt->bssid, true);
+	wil6210_disconnect(wil, evt->bssid, reason_code, true);
 	mutex_unlock(&wil->mutex);
 }
 
-- 
2.1.0

