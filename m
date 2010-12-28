Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47335 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0L1Rha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:30 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4468650ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:29 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 12/18] wl1271: AP mode - add STA add/remove ops
Date: Tue, 28 Dec 2010 19:36:42 +0200
Message-Id: <1293557808-27068-13-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate and free host link IDs (HLIDs) for each link. A per-STA
data structure keeps the HLID of each STA.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  112 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c237142..b8a3d6d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1192,6 +1192,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->flags = 0;
 	wl->vif = NULL;
 	wl->filters = 0;
+	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -2399,6 +2400,113 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
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
+	int ret = 0, id;
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
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	id = wl_sta->hlid - WL1271_AP_STA_HLID_START;
+	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
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
@@ -2645,6 +2753,8 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
+	.sta_add = wl1271_op_sta_add,
+	.sta_remove = wl1271_op_sta_remove,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
@@ -2838,6 +2948,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
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

