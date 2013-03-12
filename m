Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab3CLNpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:40 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CDjdgG003614
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:39 -0500
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CDjdwf017448
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:39 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Nadim Zubidat <nadimz@ti.com>
Subject: [PATCH 06/13] wlcore: report rssi from roaming statistics
Date: Tue, 12 Mar 2013 15:44:17 +0200
Message-ID: <1363095864-24422-7-git-send-email-coelho@ti.com> (sfid-20130312_144600_912815_4C54DAB6)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nadim Zubidat <nadimz@ti.com>

report the average beacon rssi which is calculated
by firmware for roaming statistics instead of the
last rx packet rssi. this results a more accurate
rssi reporting

Signed-off-by: Nadim Zubidat <nadimz@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/acx.c  |   29 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/acx.h  |   14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/main.c |   34 +++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index c796543..7a970cd 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1736,6 +1736,35 @@ out:
 
 }
 
+int wlcore_acx_average_rssi(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    s8 *avg_rssi)
+{
+	struct acx_roaming_stats *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx roaming statistics");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->role_id = wlvif->role_id;
+	ret = wl1271_cmd_interrogate(wl, ACX_ROAMING_STATISTICS_TBL,
+				     acx, sizeof(*acx));
+	if (ret	< 0) {
+		wl1271_warning("acx roaming statistics failed: %d", ret);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	*avg_rssi = acx->rssi_beacon;
+out:
+	kfree(acx);
+	return ret;
+}
+
 #ifdef CONFIG_PM
 /* Set the global behaviour of RX filters - On/Off + default action */
 int wl1271_acx_default_rx_filter_enable(struct wl1271 *wl, bool enable,
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 1a61e85..6dcfad9 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -953,6 +953,18 @@ struct acx_rx_filter_cfg {
 	u8 fields[0];
 } __packed;
 
+struct acx_roaming_stats {
+	struct acx_header header;
+
+	u8	role_id;
+	u8	pad[3];
+	u32	missed_beacons;
+	u8	snr_data;
+	u8	snr_bacon;
+	s8	rssi_data;
+	s8	rssi_beacon;
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS           = 0x0000,
 	ACX_MEM_CFG                      = 0x0001,
@@ -1110,6 +1122,8 @@ int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
 int wl12xx_acx_config_hangover(struct wl1271 *wl);
+int wlcore_acx_average_rssi(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    s8 *avg_rssi);
 
 #ifdef CONFIG_PM
 int wl1271_acx_default_rx_filter_enable(struct wl1271 *wl, bool enable,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c1a60cd..bf86c71 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5094,6 +5094,39 @@ static void wlcore_op_sta_rc_update(struct ieee80211_hw *hw,
 	wlcore_hw_sta_rc_update(wl, wlvif, sta, changed);
 }
 
+static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       s8 *rssi_dbm)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int ret = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 get_rssi");
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_sleep;
+
+	ret = wlcore_acx_average_rssi(wl, wlvif, rssi_dbm);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -5293,6 +5326,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
 	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
 	.sta_rc_update = wlcore_op_sta_rc_update,
+	.get_rssi = wlcore_op_get_rssi,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.10.4

