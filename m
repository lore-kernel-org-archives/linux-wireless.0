Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16357 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaB0OaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:30:20 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 15/16] wil6210: single station disconnect
Date: Thu, 27 Feb 2014 16:20:54 +0200
Message-ID: <1393510855-17566-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_153023_727735_8FDBF07D)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

implement del_station() method in the struct cfg80211_ops
It allows to disconnect single peer from the AP

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  9 +++++++++
 drivers/net/wireless/ath/wil6210/main.c     |  6 ++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 21 ++++++++++++++-------
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c19e895..a4da064 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -657,6 +657,14 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	return rc;
 }
 
+static int wil_cfg80211_del_station(struct wiphy *wiphy,
+				    struct net_device *dev, u8 *mac)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	wil6210_disconnect(wil, mac);
+	return 0;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
 	.scan = wil_cfg80211_scan,
 	.connect = wil_cfg80211_connect,
@@ -674,6 +682,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	/* AP mode */
 	.start_ap = wil_cfg80211_start_ap,
 	.stop_ap = wil_cfg80211_stop_ap,
+	.del_station = wil_cfg80211_del_station,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a0ea135..41c362d 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -58,6 +58,12 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 {
 	uint i;
 	struct wil_sta_info *sta = &wil->sta[cid];
+
+	if (sta->status != wil_sta_unused) {
+		wmi_disconnect_sta(wil, sta->addr, WLAN_REASON_DEAUTH_LEAVING);
+		sta->status = wil_sta_unused;
+	}
+
 	for (i = 0; i < WIL_STA_TID_NUM; i++) {
 		struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
 		sta->tid_rx[i] = NULL;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b64175a..980dccc 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -437,6 +437,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
+int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 70b3a9b..24eed09 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -455,19 +455,14 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 			       void *d, int len)
 {
 	struct wmi_disconnect_event *evt = d;
-	int cid = wil_find_cid(wil, evt->bssid);
 
-	wil_dbg_wmi(wil, "Disconnect %pM CID %d reason %d proto %d wmi\n",
-		    evt->bssid, cid,
+	wil_dbg_wmi(wil, "Disconnect %pM reason %d proto %d wmi\n",
+		    evt->bssid,
 		    evt->protocol_reason_status, evt->disconnect_reason);
 
 	wil->sinfo_gen++;
 
-	/* TODO: fix for multiple connections */
-
 	wil6210_disconnect(wil, evt->bssid);
-	if (cid >= 0)
-		wil->sta[cid].status = wil_sta_unused;
 }
 
 static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
@@ -1062,6 +1057,18 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r)
 	return 0;
 }
 
+int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason)
+{
+	struct wmi_disconnect_sta_cmd cmd = {
+		.disconnect_reason = cpu_to_le16(reason),
+	};
+	memcpy(cmd.dst_mac, mac, ETH_ALEN);
+
+	wil_dbg_wmi(wil, "%s(%pM, reason %d)\n", __func__, mac, reason);
+
+	return wmi_send(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd));
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.8.3.2

