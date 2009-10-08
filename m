Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23101 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759786AbZJHS7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:59:02 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/20] wl1271: Configure beacon filtering on if PSM used
Date: Thu,  8 Oct 2009 21:56:35 +0300
Message-Id: <1255028196-6565-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable beacon filtering when PSM is enabled

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   11 +++++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    7 ++++++-
 drivers/net/wireless/wl12xx/wl1271_init.c |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_ps.c   |   11 +++++++++++
 5 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 4b5fd94..b9dfa09 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -386,7 +386,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_beacon_filter_opt(struct wl1271 *wl)
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 {
 	struct acx_beacon_filter_option *beacon_filter;
 	int ret;
@@ -399,7 +399,7 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl)
 		goto out;
 	}
 
-	beacon_filter->enable = 0;
+	beacon_filter->enable = enable_filter;
 	beacon_filter->max_num_beacons = 0;
 
 	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
@@ -417,6 +417,7 @@ out:
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 {
 	struct acx_beacon_filter_ie_table *ie_table;
+	int idx = 0;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx beacon filter table");
@@ -427,8 +428,10 @@ int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 		goto out;
 	}
 
-	ie_table->num_ie = 0;
-	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
+	/* configure default beacon pass-through rules */
+	ie_table->num_ie = 1;
+	ie_table->table[idx++] = BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN;
+	ie_table->table[idx++] = BEACON_RULE_PASS_ON_APPEARANCE;
 
 	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
 				   ie_table, sizeof(*ie_table));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index bb21bcb..0c2a107 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -398,6 +398,11 @@ struct acx_beacon_filter_option {
 			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
 			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
 
+#define BEACON_RULE_PASS_ON_CHANGE                     BIT(0)
+#define BEACON_RULE_PASS_ON_APPEARANCE                 BIT(1)
+
+#define BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN         (37)
+
 struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
@@ -1206,7 +1211,7 @@ int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 				 void *mc_list, u32 mc_list_len);
 int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
-int wl1271_acx_beacon_filter_opt(struct wl1271 *wl);
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
 int wl1271_acx_conn_monit_params(struct wl1271 *wl);
 int wl1271_acx_sg_enable(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index d3db3fb..bf4d0e1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -136,7 +136,8 @@ static int wl1271_init_beacon_filter(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_acx_beacon_filter_opt(wl);
+	/* disable beacon filtering at this stage */
+	ret = wl1271_acx_beacon_filter_opt(wl, false);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e6f9e9b..3662715 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1319,7 +1319,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->channel_change_time = 10000;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
+		IEEE80211_HW_NOISE_DBM |
+		IEEE80211_HW_BEACON_FILTER;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 0f6ea16..5580e53 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -129,6 +129,12 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 	switch (mode) {
 	case STATION_POWER_SAVE_MODE:
 		wl1271_debug(DEBUG_PSM, "entering psm");
+
+		/* enable beacon filtering */
+		ret = wl1271_acx_beacon_filter_opt(wl, true);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
@@ -146,6 +152,11 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
+		/* disable beacon filtering */
+		ret = wl1271_acx_beacon_filter_opt(wl, false);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
-- 
1.5.6.5

