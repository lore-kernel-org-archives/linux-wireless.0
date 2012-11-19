Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38209 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2KSQjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:45 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051752eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:45 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/15] wlcore: add chanctx implementation
Date: Mon, 19 Nov 2012 18:39:23 +0200
Message-Id: <1353343170-26516-9-git-send-email-eliad@wizery.com> (sfid-20121119_173952_507956_82E60242)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some basic chanctx implementation.

Only add debug prints, and save the vif's channel/band/type.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   66 +++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4f4a9e5..caafd8c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4150,6 +4150,67 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static int wlcore_op_add_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_chanctx_conf *ctx)
+{
+	wl1271_debug(DEBUG_MAC80211, "mac80211 add chanctx %d (type %d)",
+		     ieee80211_frequency_to_channel(ctx->channel->center_freq),
+		     ctx->channel_type);
+	return 0;
+}
+
+static void wlcore_op_remove_chanctx(struct ieee80211_hw *hw,
+				     struct ieee80211_chanctx_conf *ctx)
+{
+	wl1271_debug(DEBUG_MAC80211, "mac80211 remove chanctx %d (type %d)",
+		     ieee80211_frequency_to_channel(ctx->channel->center_freq),
+		     ctx->channel_type);
+}
+
+static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
+				     struct ieee80211_chanctx_conf *ctx,
+				     u32 changed)
+{
+	wl1271_debug(DEBUG_MAC80211,
+		     "mac80211 change chanctx %d (type %d) changed 0x%x",
+		     ieee80211_frequency_to_channel(ctx->channel->center_freq),
+		     ctx->channel_type, changed);
+}
+
+static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_chanctx_conf *ctx)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int channel = ieee80211_frequency_to_channel(
+		ctx->channel->center_freq);
+
+	wl1271_debug(DEBUG_MAC80211,
+		     "mac80211 assign chanctx (role %d) %d (type %d)",
+		     wlvif->role_id, channel, ctx->channel_type);
+
+	wlcore_tx_work_locked(wl);
+	wlvif->band = ctx->channel->band;
+	wlvif->channel = channel;
+	wlvif->channel_type = ctx->channel_type;
+
+	return 0;
+}
+
+static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   struct ieee80211_chanctx_conf *ctx)
+{
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
+	wl1271_debug(DEBUG_MAC80211,
+		     "mac80211 unassign chanctx (role %d) %d (type %d)",
+		     wlvif->role_id,
+		     ieee80211_frequency_to_channel(ctx->channel->center_freq),
+		     ctx->channel_type);
+}
+
 static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
@@ -4972,6 +5033,11 @@ static const struct ieee80211_ops wl1271_ops = {
 	.flush = wlcore_op_flush,
 	.remain_on_channel = wlcore_op_remain_on_channel,
 	.cancel_remain_on_channel = wlcore_op_cancel_remain_on_channel,
+	.add_chanctx = wlcore_op_add_chanctx,
+	.remove_chanctx = wlcore_op_remove_chanctx,
+	.change_chanctx = wlcore_op_change_chanctx,
+	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
+	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.6.401.g6a319

