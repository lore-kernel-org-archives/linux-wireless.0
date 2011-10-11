Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1JKJ4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 05:56:51 -0400
Received: by wyg34 with SMTP id 34so6803972wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 02:56:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: reconfigure rate policies on set_bitrate_mask
Date: Tue, 11 Oct 2011 11:57:39 +0200
Message-Id: <1318327059-14158-1-git-send-email-eliad@wizery.com> (sfid-20111011_115653_363459_55F75500)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate policies are configured only after association,
resulting in auth req being sent in wrong rates.

Reconfigure rate policies on bitrate mask change.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2037208..d2b13ca 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4330,7 +4330,7 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271 *wl = hw->priv;
-	int i;
+	int i, ret = 0;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 set_bitrate_mask 0x%x 0x%x",
 		mask->control[NL80211_BAND_2GHZ].legacy,
@@ -4343,9 +4343,28 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 			wl1271_tx_enabled_rates_get(wl,
 						    mask->control[i].legacy,
 						    i);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
+	    !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
+
+		ret = wl1271_ps_elp_wakeup(wl);
+		if (ret < 0)
+			goto out;
+
+		wl1271_set_band_rate(wl, wlvif);
+		wlvif->basic_rate =
+			wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+
+		wl1271_ps_elp_sleep(wl);
+	}
+out:
 	mutex_unlock(&wl->mutex);
 
-	return 0;
+	return ret;
 }
 
 static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
-- 
1.7.6.401.g6a319

