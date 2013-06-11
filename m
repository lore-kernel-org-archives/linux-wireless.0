Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42952 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3FKIou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 04:44:50 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/2] mac80211: abort CAC in stop_ap()
Date: Tue, 11 Jun 2013 10:44:39 +0200
Message-Id: <1370940280-7876-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130611_104454_092095_269BAE36)
In-Reply-To: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a CAC is running and stop_ap is called (e.g. when hostapd is killed
while performing CAC), the CAC must be aborted immediately.
Otherwise ieee80211_stop_ap() will try to stop it when it's too late -
wdev->channel is already NULL and the abort event can not be generated.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/cfg.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3062210..7f89fc0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1071,6 +1071,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	if (sdata->wdev.cac_started) {
+		cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
+		WARN_ON(local->suspended);
+		cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_ABORTED,
+				   GFP_KERNEL);
+	}
 	drv_stop_ap(sdata->local, sdata);
 
 	/* free all potentially still buffered bcast frames */
-- 
1.7.10.4

