Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:20962 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763426Ab3DDUDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 16:03:54 -0400
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 3/3] mac80211: implement cfg80211_ops::get_max_tp() API
Date: Thu, 4 Apr 2013 21:57:22 +0200
Message-ID: <1365105442-31876-3-git-send-email-antonio@open-mesh.com> (sfid-20130404_220357_360912_0BDECC95)
In-Reply-To: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the get_max_tp() API function by asking the
rate control algorithm for the maximum estimated throughput

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/cfg.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index edca2a2..2a78957 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3374,6 +3374,27 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	return ret;
 }
 
+int ieee80211_get_max_tp(struct wireless_dev *wdev, const u8 *peer, u32 *tp)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct rate_control_ref *ref = sdata->local->rate_ctrl;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, peer);
+	rcu_read_unlock();
+
+	if (!sta)
+		return -ENOENT;
+
+	if (!ref->ops->get_max_tp)
+		return -EOPNOTSUPP;
+
+	ref->ops->get_max_tp(sta->rate_ctrl_priv, tp);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 {
@@ -3459,4 +3480,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.get_max_tp = ieee80211_get_max_tp,
 };
-- 
1.8.1.5

