Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49903 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaL2GYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:35 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so21094175wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:34 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.32
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:33 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/13] wlcore: allow using dfs channels
Date: Mon, 29 Dec 2014 08:24:11 +0200
Message-Id: <1419834253-18331-11-git-send-email-eliad@wizery.com> (sfid-20141229_074347_333341_4A470816)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are going to support dfs channels, there
is no reason to mark them as NO_IR (having
the DFS flag is enough anyway).

Additionally, when setting the regdomain configuration,
enable usable dfs channels.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  | 16 +++++++++-------
 drivers/net/wireless/ti/wlcore/main.c | 14 --------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index aacad4e..50ca10c 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1687,9 +1687,7 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 {
 	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
 	int ret = 0, i, b, ch_bit_idx;
-	struct ieee80211_channel *channel;
 	u32 tmp_ch_bitmap[2];
-	u16 ch;
 	struct wiphy *wiphy = wl->hw->wiphy;
 	struct ieee80211_supported_band *band;
 	bool timeout = false;
@@ -1704,12 +1702,16 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 	for (b = IEEE80211_BAND_2GHZ; b <= IEEE80211_BAND_5GHZ; b++) {
 		band = wiphy->bands[b];
 		for (i = 0; i < band->n_channels; i++) {
-			channel = &band->channels[i];
-			ch = channel->hw_value;
+			struct ieee80211_channel *channel = &band->channels[i];
+			u16 ch = channel->hw_value;
+			u32 flags = channel->flags;
 
-			if (channel->flags & (IEEE80211_CHAN_DISABLED |
-					      IEEE80211_CHAN_RADAR |
-					      IEEE80211_CHAN_NO_IR))
+			if (flags & (IEEE80211_CHAN_DISABLED |
+				     IEEE80211_CHAN_NO_IR))
+				continue;
+
+			if ((flags & IEEE80211_CHAN_RADAR) &&
+			    channel->dfs_state != NL80211_DFS_AVAILABLE)
 				continue;
 
 			ch_bit_idx = wlcore_get_reg_conf_ch_idx(b, ch);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 362515f..d99f289 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -79,23 +79,9 @@ static int wl12xx_set_authorized(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static void wl1271_reg_notify(struct wiphy *wiphy,
 			      struct regulatory_request *request)
 {
-	struct ieee80211_supported_band *band;
-	struct ieee80211_channel *ch;
-	int i;
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct wl1271 *wl = hw->priv;
 
-	band = wiphy->bands[IEEE80211_BAND_5GHZ];
-	for (i = 0; i < band->n_channels; i++) {
-		ch = &band->channels[i];
-		if (ch->flags & IEEE80211_CHAN_DISABLED)
-			continue;
-
-		if (ch->flags & IEEE80211_CHAN_RADAR)
-			ch->flags |= IEEE80211_CHAN_NO_IR;
-
-	}
-
 	wlcore_regdomain_config(wl);
 }
 
-- 
1.8.5.2.229.g4448466.dirty

