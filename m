Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0LVO22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:28 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so5082982wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:27 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 12/18] wl1271: AP mode - add STA add/remove ops
Date: Wed, 22 Dec 2010 16:27:31 +0200
Message-Id: <1293028057-6212-13-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate and free host link IDs (HLIDs) for each link. A per-STA
data structure keeps the HLID of each STA.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  108 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++
 2 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f777073..13a1c6e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1192,6 +1192,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->flags = 0;
 	wl->vif = NULL;
 	wl->filters = 0;
+	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -2347,6 +2348,109 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+static int wl1271_allocate_hlid(struct wl1271 *wl,
+			     struct ieee80211_sta *sta,
+			     u8 *hlid)
+{
+	struct wl1271_station *wl_sta;
+	int id;
+
+	id = find_first_zero_bit(wl->ap_hlid_map, AP_MAX_STATIONS);
+	if (id >= AP_MAX_STATIONS) {
+		wl1271_warning("could not allocate HLID - too much stations");
+		return -EBUSY;
+	}
+
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+
+	__set_bit(id, wl->ap_hlid_map);
+	wl_sta->hlid = WL1271_AP_STA_HLID_START + id;
+	*hlid = wl_sta->hlid;
+	return 0;
+}
+
+static void wl1271_free_hlid(struct wl1271 *wl, u8 hlid)
+{
+	int id = hlid - WL1271_AP_STA_HLID_START;
+
+	__clear_bit(id, wl->ap_hlid_map);
+}
+
+static int wl1271_op_sta_add(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret = 0;
+	u8 hlid;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	if (wl->bss_type != BSS_TYPE_AP_BSS)
+		goto out;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 add sta %d", (int)sta->aid);
+
+	ret = wl1271_allocate_hlid(wl, sta, &hlid);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_cmd_add_sta(wl, sta, hlid);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
+static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl1271_station *wl_sta;
+	int ret = 0;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	if (wl->bss_type != BSS_TYPE_AP_BSS)
+		goto out;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	ret = wl1271_cmd_remove_sta(wl, wl_sta->hlid);
+	if (ret < 0)
+		goto out_sleep;
+
+	wl1271_free_hlid(wl, wl_sta->hlid);
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
@@ -2593,6 +2697,8 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
+	.sta_add = wl1271_op_sta_add,
+	.sta_remove = wl1271_op_sta_remove,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
@@ -2786,6 +2892,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
+	wl->hw->sta_data_size = sizeof(struct wl1271_station);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wl1271_init_ieee80211);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a378d52..3bd03af 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -435,6 +435,13 @@ struct wl1271 {
 
 	/* Most recently reported noise in dBm */
 	s8 noise;
+
+	/* map for HLIDs of associated stations - when operating in AP mode */
+	unsigned long ap_hlid_map[BITS_TO_LONGS(AP_MAX_STATIONS)];
+};
+
+struct wl1271_station {
+	u8 hlid;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
-- 
1.7.1

