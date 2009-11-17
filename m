Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17884 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZKQQsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:48:32 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 03/16] wl1251: Configure beacon filtering on if PSM used
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:30 +0200
Message-ID: <20091117164829.2236.13707.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable beacon filtering when PSM is enabled

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_acx.c  |   11 +++++++----
 drivers/net/wireless/wl12xx/wl1251_acx.h  |    7 ++++++-
 drivers/net/wireless/wl12xx/wl1251_init.c |    3 ++-
 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 drivers/net/wireless/wl12xx/wl1251_ps.c   |   10 ++++++++++
 5 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 4a9c708..50633e0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -494,7 +494,7 @@ out:
 	return ret;
 }
 
-int wl1251_acx_beacon_filter_opt(struct wl1251 *wl)
+int wl1251_acx_beacon_filter_opt(struct wl1251 *wl, bool enable_filter)
 {
 	struct acx_beacon_filter_option *beacon_filter;
 	int ret;
@@ -507,7 +507,7 @@ int wl1251_acx_beacon_filter_opt(struct wl1251 *wl)
 		goto out;
 	}
 
-	beacon_filter->enable = 0;
+	beacon_filter->enable = enable_filter;
 	beacon_filter->max_num_beacons = 0;
 
 	ret = wl1251_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
@@ -525,6 +525,7 @@ out:
 int wl1251_acx_beacon_filter_table(struct wl1251 *wl)
 {
 	struct acx_beacon_filter_ie_table *ie_table;
+	int idx = 0;
 	int ret;
 
 	wl1251_debug(DEBUG_ACX, "acx beacon filter table");
@@ -535,8 +536,10 @@ int wl1251_acx_beacon_filter_table(struct wl1251 *wl)
 		goto out;
 	}
 
-	ie_table->num_ie = 0;
-	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
+	/* configure default beacon pass-through rules */
+	ie_table->num_ie = 1;
+	ie_table->table[idx++] = BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN;
+	ie_table->table[idx++] = BEACON_RULE_PASS_ON_APPEARANCE;
 
 	ret = wl1251_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
 				   ie_table, sizeof(*ie_table));
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 926789c..ce1c995 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -450,6 +450,11 @@ struct acx_beacon_filter_option {
 			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
 			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
 
+#define BEACON_RULE_PASS_ON_CHANGE                     BIT(0)
+#define BEACON_RULE_PASS_ON_APPEARANCE                 BIT(1)
+
+#define BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN         (37)
+
 struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
@@ -1283,7 +1288,7 @@ int wl1251_acx_slot(struct wl1251 *wl, enum acx_slot_type slot_time);
 int wl1251_acx_group_address_tbl(struct wl1251 *wl);
 int wl1251_acx_service_period_timeout(struct wl1251 *wl);
 int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold);
-int wl1251_acx_beacon_filter_opt(struct wl1251 *wl);
+int wl1251_acx_beacon_filter_opt(struct wl1251 *wl, bool enable_filter);
 int wl1251_acx_beacon_filter_table(struct wl1251 *wl);
 int wl1251_acx_conn_monit_params(struct wl1251 *wl);
 int wl1251_acx_sg_enable(struct wl1251 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index 035ab11..5cb5733 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -147,7 +147,8 @@ int wl1251_hw_init_beacon_filter(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl1251_acx_beacon_filter_opt(wl);
+	/* disable beacon filtering at this stage */
+	ret = wl1251_acx_beacon_filter_opt(wl, false);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 601c430..900e6e2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1323,7 +1323,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
-		IEEE80211_HW_SUPPORTS_PS;
+		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_BEACON_FILTER;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index c53e287..c3e348a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -119,6 +119,11 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 	case STATION_POWER_SAVE_MODE:
 		wl1251_debug(DEBUG_PSM, "entering psm");
 
+		/* enable beacon filtering */
+		ret = wl1251_acx_beacon_filter_opt(wl, true);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1251_acx_wake_up_conditions(wl,
 						    WAKE_UP_EVENT_DTIM_BITMAP,
 						    wl->listen_int);
@@ -142,6 +147,11 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
+		/* disable beacon filtering */
+		ret = wl1251_acx_beacon_filter_opt(wl, false);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1251_acx_wake_up_conditions(wl,
 						    WAKE_UP_EVENT_DTIM_BITMAP,
 						    wl->listen_int);

