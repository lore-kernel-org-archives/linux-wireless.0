Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43861 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbcFSOHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 10:07:18 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id u5JE6eBM023065
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2016 09:06:41 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id u5JE7H6p030472
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2016 09:07:17 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: reconfigure sta rates on authorization
Date: Sun, 19 Jun 2016 17:08:58 +0300
Message-ID: <1466345338-31972-1-git-send-email-guym@ti.com> (sfid-20160619_160725_130111_40FDF07B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since stations can now be added before association
(NL80211_FEATURE_FULL_AP_CLIENT_STATE support),
no supported rates are set when the station is added
to the fw, resulting in fw recovery.

Fix it by first configuring the AP basic rates as
the station configured rates (when the station is
first added to the driver), and after the station
was authorized re-configure it, now with the actual
supported rates.

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  | 7 +++++++
 drivers/net/wireless/ti/wlcore/main.c | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 3315356..5f360ce 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1566,6 +1566,13 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates,
 							wlvif->band));
 
+	if (!cmd->supported_rates) {
+		wl1271_debug(DEBUG_CMD,
+			     "peer has no supported rates yet, configuring basic rates: 0x%x",
+			     wlvif->basic_rate_set);
+		cmd->supported_rates = cpu_to_le32(wlvif->basic_rate_set);
+	}
+
 	wl1271_debug(DEBUG_CMD, "new peer rates=0x%x queues=0x%x",
 		     cmd->supported_rates, sta->uapsd_queues);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 10fd24c..a53033d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5091,6 +5091,11 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 		if (ret < 0)
 			return ret;
 
+		/* reconfigure rates */
+		ret = wl12xx_cmd_add_peer(wl, wlvif, sta, wl_sta->hlid);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true,
 						     wl_sta->hlid);
 		if (ret)
-- 
2.6.4

