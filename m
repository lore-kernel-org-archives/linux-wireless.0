Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39426 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1JVNQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:16:32 -0400
Received: by bkbzt19 with SMTP id zt19so5989302bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:16:30 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wl12xx: configure the probe response offloading support
Date: Sat, 22 Oct 2011 15:14:38 +0200
Message-Id: <1319289279-21950-1-git-send-email-guy@wizery.com> (sfid-20111022_151635_228491_9E185E1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure and respond to a probe response offload query with
the relevant protocols supported currently by the driver.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |    2 ++
 drivers/net/wireless/wl12xx/main.c |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 04bb8fb..714f9d4 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1264,6 +1264,8 @@ struct conf_drv_settings {
 	struct conf_rate_policy_settings rate;
 	struct conf_hangover_settings hangover;
 	u8 hci_io_ds;
+	/* a bitmap of supported protocols for probe response offloading */
+	u32 probe_resp_offload;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f76be5a..0a7d020 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -373,6 +373,10 @@ static struct conf_drv_settings default_conf = {
 		.increase_time              = 1,
 		.window_size                = 16,
 	},
+	.probe_resp_offload =
+		BIT(NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS) |
+		BIT(NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2) |
+		BIT(NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P),
 };
 
 static char *fwlog_param;
@@ -4081,6 +4085,16 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+static int wl1271_op_get_probe_resp_offload(struct ieee80211_hw *hw,
+				u32 *supp_protocols)
+{
+	struct wl1271 *wl = hw->priv;
+
+	*supp_protocols = wl->conf.probe_resp_offload;
+
+	return 0;
+}
+
 static int wl1271_allocate_sta(struct wl1271 *wl,
 			     struct wl12xx_vif *wlvif,
 			     struct ieee80211_sta *sta)
@@ -4666,6 +4680,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
 	.channel_switch = wl12xx_op_channel_switch,
+	.get_probe_resp_offload = wl1271_op_get_probe_resp_offload,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.4.1

