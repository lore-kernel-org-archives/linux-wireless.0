Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2KZQGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:01 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2233462wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:00 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/11] wlcore: use new set bandwidth command to adjusting channel BW
Date: Mon, 26 Nov 2012 18:05:41 +0200
Message-Id: <1353945950-3899-3-git-send-email-arik@wizery.com> (sfid-20121126_170614_089738_0F2EC2D0)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We support changing the channel BW when we started the STA role on
a 40Mhz bandwidth. Otherwise a reconnection is required.
Save the started channel width and use it when channel width updates
arrive.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c      |   31 +++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h      |   14 +++++++++++
 drivers/net/wireless/ti/wl18xx/main.c     |   38 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.c      |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    8 ++++++
 drivers/net/wireless/ti/wlcore/main.c     |   12 +++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 ++
 8 files changed, 108 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index adff9cd..801d8af 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -109,3 +109,34 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl18xx_acx_peer_ht_operation_mode(struct wl1271 *wl, u8 hlid, bool wide)
+{
+	struct wlcore_peer_ht_operation_mode *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx peer ht operation mode hlid %d bw %d",
+		     hlid, wide);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->hlid = hlid;
+	acx->bandwidth = wide ? WLCORE_BANDWIDTH_40MHZ : WLCORE_BANDWIDTH_20MHZ;
+
+	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_OPERATION_MODE_CFG, acx,
+				   sizeof(*acx));
+
+	if (ret < 0) {
+		wl1271_warning("acx peer ht operation mode failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 394d125..b57e348 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -284,10 +284,24 @@ struct wl18xx_acx_clear_statistics {
 	struct acx_header header;
 };
 
+enum wlcore_bandwidth {
+	WLCORE_BANDWIDTH_20MHZ,
+	WLCORE_BANDWIDTH_40MHZ,
+};
+
+struct wlcore_peer_ht_operation_mode {
+	struct acx_header header;
+
+	u8 hlid;
+	u8 bandwidth; /* enum wlcore_bandwidth */
+	u8 padding[2];
+};
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
 int wl18xx_acx_set_checksum_state(struct wl1271 *wl);
 int wl18xx_acx_clear_statistics(struct wl1271 *wl);
+int wl18xx_acx_peer_ht_operation_mode(struct wl1271 *wl, u8 hlid, bool wide);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c015231..c616c21 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1319,6 +1319,43 @@ static u32 wl18xx_pre_pkt_send(struct wl1271 *wl,
 	return buf_offset;
 }
 
+static void wl18xx_sta_rc_update(struct wl1271 *wl,
+				 struct wl12xx_vif *wlvif,
+				 struct ieee80211_sta *sta,
+				 u32 changed)
+{
+	bool wide = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 sta_rc_update wide %d", wide);
+
+	if (!(changed & IEEE80211_RC_BW_CHANGED))
+		return;
+
+	mutex_lock(&wl->mutex);
+
+	/* sanity */
+	if (WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS))
+		goto out;
+
+	/* ignore the change before association */
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		goto out;
+
+	/*
+	 * If we started out as wide, we can change the operation mode. If we
+	 * thought this was a 20mhz AP, we have to reconnect
+	 */
+	if (wlvif->sta.role_chan_type == NL80211_CHAN_HT40MINUS ||
+	    wlvif->sta.role_chan_type == NL80211_CHAN_HT40PLUS)
+		wl18xx_acx_peer_ht_operation_mode(wl, wlvif->sta.hlid, wide);
+	else
+		ieee80211_connection_loss(wl12xx_wlvif_to_vif(wlvif));
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+
 static int wl18xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl18xx_ops = {
@@ -1354,6 +1391,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.set_key	= wl18xx_set_key,
 	.channel_switch	= wl18xx_cmd_channel_switch,
 	.pre_pkt_send	= wl18xx_pre_pkt_send,
+	.sta_rc_update	= wl18xx_sta_rc_update,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 599c006..65f071d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -480,6 +480,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto err_hlid;
 	}
 
+	wlvif->sta.role_chan_type = wlvif->channel_type;
 	goto out_free;
 
 err_hlid:
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 2673d78..0e0b656 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -201,4 +201,12 @@ wlcore_hw_pre_pkt_send(struct wl1271 *wl, u32 buf_offset, u32 last_len)
 	return buf_offset;
 }
 
+static inline void
+wlcore_hw_sta_rc_update(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			struct ieee80211_sta *sta, u32 changed)
+{
+	if (wl->ops->sta_rc_update)
+		wl->ops->sta_rc_update(wl, wlvif, sta, changed);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0ed7f10..475d0cd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4948,6 +4948,17 @@ static int wlcore_op_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
+static void wlcore_op_sta_rc_update(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_sta *sta,
+				    u32 changed)
+{
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl1271 *wl = hw->priv;
+
+	wlcore_hw_sta_rc_update(wl, wlvif, sta, changed);
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -5146,6 +5157,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.change_chanctx = wlcore_op_change_chanctx,
 	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
 	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
+	.sta_rc_update = wlcore_op_sta_rc_update,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index b315897..037c56e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -101,6 +101,8 @@ struct wlcore_ops {
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
 	u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
+	void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      struct ieee80211_sta *sta, u32 changed);
 };
 
 enum wlcore_partitions {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 6be1e8e..e3a77aa 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -341,6 +341,8 @@ struct wl12xx_vif {
 			u8 klv_template_id;
 
 			bool qos;
+			/* channel type we started the STA role with */
+			enum nl80211_channel_type role_chan_type;
 		} sta;
 		struct {
 			u8 global_hlid;
-- 
1.7.9.5

