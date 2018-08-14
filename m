Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41320 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:27 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/24] staging: wilc1000: moved last_scanned_shadow & last_scanned_cnt to wilc_priv struct
Date: Tue, 14 Aug 2018 12:19:57 +0530
Message-ID: <1534229416-13254-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085041_703368_B47F7EB5)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variables and moved the varibles as part of private
data. last_scanned_shadow & last_scanned_cnt variable is moved to
'wilc_priv' to maintain for each interface. After moving static
variable, clear_shadow_scan() doesn't require check 'op_ifcs'
count as now for each interface the againg timer is initiated.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 105 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +
 2 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 00a167b..1eac244 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -82,8 +82,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
-static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
-static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
 static u8 op_ifcs;
 
@@ -157,21 +155,18 @@ static struct ieee80211_supported_band wilc_band_2ghz = {
 #define AGING_TIME	(9 * 1000)
 #define DURING_IP_TIME_OUT	15000
 
-static void clear_shadow_scan(void)
+static void clear_shadow_scan(struct wilc_priv *priv)
 {
 	int i;
 
-	if (op_ifcs != 0)
-		return;
-
-	for (i = 0; i < last_scanned_cnt; i++) {
-		kfree(last_scanned_shadow[i].ies);
-		last_scanned_shadow[i].ies = NULL;
+	for (i = 0; i < priv->scanned_cnt; i++) {
+		kfree(priv->scanned_shadow[i].ies);
+		priv->scanned_shadow[i].ies = NULL;
 
-		kfree(last_scanned_shadow[i].join_params);
-		last_scanned_shadow[i].join_params = NULL;
+		kfree(priv->scanned_shadow[i].join_params);
+		priv->scanned_shadow[i].join_params = NULL;
 	}
-	last_scanned_cnt = 0;
+	priv->scanned_cnt = 0;
 }
 
 static u32 get_rssi_avg(struct network_info *network_info)
@@ -193,14 +188,14 @@ static void refresh_scan(struct wilc_priv *priv, bool direct_scan)
 	struct wiphy *wiphy = priv->dev->ieee80211_ptr->wiphy;
 	int i;
 
-	for (i = 0; i < last_scanned_cnt; i++) {
+	for (i = 0; i < priv->scanned_cnt; i++) {
 		struct network_info *network_info;
 		s32 freq;
 		struct ieee80211_channel *channel;
 		int rssi;
 		struct cfg80211_bss *bss;
 
-		network_info = &last_scanned_shadow[i];
+		network_info = &priv->scanned_shadow[i];
 
 		if (!memcmp("DIRECT-", network_info->ssid, 7) && !direct_scan)
 			continue;
@@ -224,20 +219,20 @@ static void refresh_scan(struct wilc_priv *priv, bool direct_scan)
 	}
 }
 
-static void reset_shadow_found(void)
+static void reset_shadow_found(struct wilc_priv *priv)
 {
 	int i;
 
-	for (i = 0; i < last_scanned_cnt; i++)
-		last_scanned_shadow[i].found = 0;
+	for (i = 0; i < priv->scanned_cnt; i++)
+		priv->scanned_shadow[i].found = 0;
 }
 
-static void update_scan_time(void)
+static void update_scan_time(struct wilc_priv *priv)
 {
 	int i;
 
-	for (i = 0; i < last_scanned_cnt; i++)
-		last_scanned_shadow[i].time_scan = jiffies;
+	for (i = 0; i < priv->scanned_cnt; i++)
+		priv->scanned_shadow[i].time_scan = jiffies;
 }
 
 static void remove_network_from_shadow(struct timer_list *t)
@@ -246,22 +241,22 @@ static void remove_network_from_shadow(struct timer_list *t)
 	unsigned long now = jiffies;
 	int i, j;
 
-	for (i = 0; i < last_scanned_cnt; i++) {
-		if (!time_after(now, last_scanned_shadow[i].time_scan +
+	for (i = 0; i < priv->scanned_cnt; i++) {
+		if (!time_after(now, priv->scanned_shadow[i].time_scan +
 				(unsigned long)(SCAN_RESULT_EXPIRE)))
 			continue;
-		kfree(last_scanned_shadow[i].ies);
-		last_scanned_shadow[i].ies = NULL;
+		kfree(priv->scanned_shadow[i].ies);
+		priv->scanned_shadow[i].ies = NULL;
 
-		kfree(last_scanned_shadow[i].join_params);
+		kfree(priv->scanned_shadow[i].join_params);
 
-		for (j = i; (j < last_scanned_cnt - 1); j++)
-			last_scanned_shadow[j] = last_scanned_shadow[j + 1];
+		for (j = i; (j < priv->scanned_cnt - 1); j++)
+			priv->scanned_shadow[j] = priv->scanned_shadow[j + 1];
 
-		last_scanned_cnt--;
+		priv->scanned_cnt--;
 	}
 
-	if (last_scanned_cnt != 0)
+	if (priv->scanned_cnt != 0)
 		mod_timer(&priv->aging_timer,
 			  jiffies + msecs_to_jiffies(AGING_TIME));
 }
@@ -277,13 +272,13 @@ static int is_network_in_shadow(struct network_info *nw_info,
 	int state = -1;
 	int i;
 
-	if (last_scanned_cnt == 0) {
+	if (priv->scanned_cnt == 0) {
 		mod_timer(&priv->aging_timer,
 			  jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
-		for (i = 0; i < last_scanned_cnt; i++) {
-			if (memcmp(last_scanned_shadow[i].bssid,
+		for (i = 0; i < priv->scanned_cnt; i++) {
+			if (memcmp(priv->scanned_shadow[i].bssid,
 				   nw_info->bssid, 6) == 0) {
 				state = i;
 				break;
@@ -301,16 +296,16 @@ static void add_network_to_shadow(struct network_info *nw_info,
 	u8 rssi_index = 0;
 	struct network_info *shadow_nw_info;
 
-	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW)
+	if (priv->scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW)
 		return;
 
 	if (ap_found == -1) {
-		ap_index = last_scanned_cnt;
-		last_scanned_cnt++;
+		ap_index = priv->scanned_cnt;
+		priv->scanned_cnt++;
 	} else {
 		ap_index = ap_found;
 	}
-	shadow_nw_info = &last_scanned_shadow[ap_index];
+	shadow_nw_info = &priv->scanned_shadow[ap_index];
 	rssi_index = shadow_nw_info->rssi_history.index;
 	shadow_nw_info->rssi_history.samples[rssi_index++] = nw_info->rssi;
 	if (rssi_index == NUM_RSSI) {
@@ -402,7 +397,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 			u32 i;
 
 			for (i = 0; i < priv->rcvd_ch_cnt; i++) {
-				if (memcmp(last_scanned_shadow[i].bssid,
+				if (memcmp(priv->scanned_shadow[i].bssid,
 					   network_info->bssid, 6) == 0)
 					break;
 			}
@@ -410,8 +405,8 @@ static void cfg_scan_result(enum scan_event scan_event,
 			if (i >= priv->rcvd_ch_cnt)
 				return;
 
-			last_scanned_shadow[i].rssi = network_info->rssi;
-			last_scanned_shadow[i].time_scan = jiffies;
+			priv->scanned_shadow[i].rssi = network_info->rssi;
+			priv->scanned_shadow[i].time_scan = jiffies;
 		}
 	} else if (scan_event == SCAN_EVENT_DONE) {
 		refresh_scan(priv, false);
@@ -437,7 +432,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 				.aborted = false,
 			};
 
-			update_scan_time();
+			update_scan_time(priv);
 			refresh_scan(priv, false);
 
 			cfg80211_scan_done(priv->scan_req, &info);
@@ -448,11 +443,11 @@ static void cfg_scan_result(enum scan_event scan_event,
 	}
 }
 
-static inline bool wilc_wfi_cfg_scan_time_expired(int i)
+static inline bool wilc_cfg_scan_time_expired(struct wilc_priv *priv, int i)
 {
 	unsigned long now = jiffies;
 
-	if (time_after(now, last_scanned_shadow[i].time_scan_cached +
+	if (time_after(now, priv->scanned_shadow[i].time_scan_cached +
 		       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
 		return true;
 	else
@@ -501,11 +496,11 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			memcpy(priv->associated_bss, conn_info->bssid,
 			       ETH_ALEN);
 
-			for (i = 0; i < last_scanned_cnt; i++) {
-				if (memcmp(last_scanned_shadow[i].bssid,
+			for (i = 0; i < priv->scanned_cnt; i++) {
+				if (memcmp(priv->scanned_shadow[i].bssid,
 					   conn_info->bssid,
 					   ETH_ALEN) == 0) {
-					if (wilc_wfi_cfg_scan_time_expired(i))
+					if (wilc_cfg_scan_time_expired(priv, i))
 						scan_refresh = true;
 
 					break;
@@ -619,7 +614,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->rcvd_ch_cnt = 0;
 
-	reset_shadow_found();
+	reset_shadow_found(priv);
 
 	priv->cfg_scanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
@@ -679,18 +674,18 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	else
 		wfi_drv->p2p_connect = 0;
 
-	for (i = 0; i < last_scanned_cnt; i++) {
-		if (sme->ssid_len == last_scanned_shadow[i].ssid_len &&
-		    memcmp(last_scanned_shadow[i].ssid,
+	for (i = 0; i < priv->scanned_cnt; i++) {
+		if (sme->ssid_len == priv->scanned_shadow[i].ssid_len &&
+		    memcmp(priv->scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
 			if (!sme->bssid) {
 				if (sel_bssi_idx == UINT_MAX ||
-				    last_scanned_shadow[i].rssi >
-				    last_scanned_shadow[sel_bssi_idx].rssi)
+				    priv->scanned_shadow[i].rssi >
+				    priv->scanned_shadow[sel_bssi_idx].rssi)
 					sel_bssi_idx = i;
 			} else {
-				if (memcmp(last_scanned_shadow[i].bssid,
+				if (memcmp(priv->scanned_shadow[i].bssid,
 					   sme->bssid,
 					   ETH_ALEN) == 0) {
 					sel_bssi_idx = i;
@@ -700,8 +695,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	if (sel_bssi_idx < last_scanned_cnt) {
-		nw_info = &last_scanned_shadow[sel_bssi_idx];
+	if (sel_bssi_idx < priv->scanned_cnt) {
+		nw_info = &priv->scanned_shadow[sel_bssi_idx];
 	} else {
 		ret = -ENOENT;
 		wilc_connecting = 0;
@@ -2194,7 +2189,7 @@ int wilc_deinit_host_int(struct net_device *net)
 	ret = wilc_deinit(vif);
 
 	del_timer_sync(&priv->aging_timer);
-	clear_shadow_scan();
+	clear_shadow_scan(priv);
 	if (op_ifcs == 0)
 		del_timer_sync(&wilc_during_ip_timer);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a76b68c..3767e31 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -95,6 +95,8 @@ struct wilc_priv {
 	struct mutex scan_req_lock;
 	bool p2p_listen_state;
 	struct timer_list aging_timer;
+	struct network_info scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
+	int scanned_cnt;
 };
 
 struct frame_reg {
-- 
2.7.4
