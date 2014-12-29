Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36912 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaL2GYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:23 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so358077wgh.30
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:21 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.20
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:20 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/13] wlcore/wl18xx: handle rc updates in a separate work
Date: Mon, 29 Dec 2014 08:24:03 +0200
Message-Id: <1419834253-18331-3-git-send-email-eliad@wizery.com> (sfid-20141229_072426_954612_7360A4B4)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_rc_update runs in atomic context. thus, a new work
should be scheduled in order to configure the fw
with the required configuration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c     | 18 ++++------------
 drivers/net/wireless/ti/wlcore/hw_ops.h   |  5 ++---
 drivers/net/wireless/ti/wlcore/main.c     | 35 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h   |  3 +--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  4 ++++
 5 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 7af1936..6946d18 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1559,26 +1559,19 @@ static u32 wl18xx_pre_pkt_send(struct wl1271 *wl,
 }
 
 static void wl18xx_sta_rc_update(struct wl1271 *wl,
-				 struct wl12xx_vif *wlvif,
-				 struct ieee80211_sta *sta,
-				 u32 changed)
+				 struct wl12xx_vif *wlvif)
 {
-	bool wide = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
+	bool wide = wlvif->rc_update_bw >= IEEE80211_STA_RX_BW_40;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 sta_rc_update wide %d", wide);
 
-	if (!(changed & IEEE80211_RC_BW_CHANGED))
-		return;
-
-	mutex_lock(&wl->mutex);
-
 	/* sanity */
 	if (WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS))
-		goto out;
+		return;
 
 	/* ignore the change before association */
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out;
+		return;
 
 	/*
 	 * If we started out as wide, we can change the operation mode. If we
@@ -1589,9 +1582,6 @@ static void wl18xx_sta_rc_update(struct wl1271 *wl,
 		wl18xx_acx_peer_ht_operation_mode(wl, wlvif->sta.hlid, wide);
 	else
 		ieee80211_connection_loss(wl12xx_wlvif_to_vif(wlvif));
-
-out:
-	mutex_unlock(&wl->mutex);
 }
 
 static int wl18xx_set_peer_cap(struct wl1271 *wl,
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index aa9f82c..29ce55f 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -211,11 +211,10 @@ wlcore_hw_pre_pkt_send(struct wl1271 *wl, u32 buf_offset, u32 last_len)
 }
 
 static inline void
-wlcore_hw_sta_rc_update(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			struct ieee80211_sta *sta, u32 changed)
+wlcore_hw_sta_rc_update(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	if (wl->ops->sta_rc_update)
-		wl->ops->sta_rc_update(wl, wlvif, sta, changed);
+		wl->ops->sta_rc_update(wl, wlvif);
 }
 
 static inline int
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2a99456..f6e37d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -226,6 +226,29 @@ void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
 		msecs_to_jiffies(wl->conf.tx.tx_watchdog_timeout));
 }
 
+static void wlcore_rc_update_work(struct work_struct *work)
+{
+	int ret;
+	struct wl12xx_vif *wlvif = container_of(work, struct wl12xx_vif,
+						rc_update_work);
+	struct wl1271 *wl = wlvif->wl;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wlcore_hw_sta_rc_update(wl, wlvif);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wl12xx_tx_watchdog_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
@@ -2279,6 +2302,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		  wl1271_rx_streaming_enable_work);
 	INIT_WORK(&wlvif->rx_streaming_disable_work,
 		  wl1271_rx_streaming_disable_work);
+	INIT_WORK(&wlvif->rc_update_work, wlcore_rc_update_work);
 	INIT_DELAYED_WORK(&wlvif->channel_switch_work,
 			  wlcore_channel_switch_work);
 	INIT_DELAYED_WORK(&wlvif->connection_loss_work,
@@ -2724,6 +2748,7 @@ unlock:
 	del_timer_sync(&wlvif->rx_streaming_timer);
 	cancel_work_sync(&wlvif->rx_streaming_enable_work);
 	cancel_work_sync(&wlvif->rx_streaming_disable_work);
+	cancel_work_sync(&wlvif->rc_update_work);
 	cancel_delayed_work_sync(&wlvif->connection_loss_work);
 	cancel_delayed_work_sync(&wlvif->channel_switch_work);
 	cancel_delayed_work_sync(&wlvif->pending_auth_complete_work);
@@ -5371,9 +5396,15 @@ static void wlcore_op_sta_rc_update(struct ieee80211_hw *hw,
 				    u32 changed)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	struct wl1271 *wl = hw->priv;
 
-	wlcore_hw_sta_rc_update(wl, wlvif, sta, changed);
+	wl1271_debug(DEBUG_MAC80211, "mac80211 sta_rc_update");
+
+	if (!(changed & IEEE80211_RC_BW_CHANGED))
+		return;
+
+	/* this callback is atomic, so schedule a new work */
+	wlvif->rc_update_bw = sta->bandwidth;
+	ieee80211_queue_work(hw, &wlvif->rc_update_work);
 }
 
 static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index df78cf1..2440ebe 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -106,8 +106,7 @@ struct wlcore_ops {
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
 	u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
-	void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			      struct ieee80211_sta *sta, u32 changed);
+	void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	int (*set_peer_cap)(struct wl1271 *wl,
 			    struct ieee80211_sta_ht_cap *ht_cap,
 			    bool allow_ht_operation,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 0e52556..811851d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -463,6 +463,10 @@ struct wl12xx_vif {
 	/* work for canceling ROC after pending auth reply */
 	struct delayed_work pending_auth_complete_work;
 
+	/* update rate conrol */
+	enum ieee80211_sta_rx_bandwidth rc_update_bw;
+	struct work_struct rc_update_work;
+
 	/*
 	 * total freed FW packets on the link.
 	 * For STA this holds the PN of the link to the AP.
-- 
1.8.5.2.229.g4448466.dirty

