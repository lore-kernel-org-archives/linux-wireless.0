Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4995 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932570AbdBVPci (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 10:32:38 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Disallow DFS simulation if DFS channel is not enabled
Date: Wed, 22 Feb 2017 21:03:11 +0530
Message-ID: <1487777591-29743-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170222_163242_196941_DCB52AC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

If DFS is not enabled in hostapd (ieee80211h=0) DFS channels shall
not be available for use even though the hardware may have the capability
to support DFS. With this configuration (DFS disabled in hostapd) trying to
bring up ath10k device in DFS channel for AP mode fails and trying to
simulate DFS in ath10k debugfs results in a warning in cfg80211 complaining
invalid channel and this should be avoided in the driver itself rather than
false propogating RADAR detection to mac80211/cfg80211. Fix this by
checking for the first vif 'is_started' state(should work for client mode
as well) as all the vifs shall be configured for the same channel

sys/kernel/debug/ieee80211/phy1/ath10k# echo 1 > dfs_simulate_radar

WARNING: at net/wireless/chan.c:265 cfg80211_radar_event+0x24/0x60
Workqueue: phy0 ieee80211_dfs_radar_detected_work [mac80211]
[<c022f2d4>] (warn_slowpath_null) from
[<bf72dab8>] (cfg80211_radar_event+0x24/0x60 [cfg80211])
[<bf72dab8>] (cfg80211_radar_event [cfg80211]) from
[<bf7813e0>] (ieee80211_dfs_radar_detected_work+0x94/0xa0 [mac80211])
[<bf7813e0>] (ieee80211_dfs_radar_detected_work [mac80211]) from
[<c0242320>] (process_one_work+0x20c/0x32c)

WARNING: at net/wireless/nl80211.c:2488 nl80211_get_mpath+0x13c/0x4cc
 Workqueue: phy0 ieee80211_dfs_radar_detected_work [mac80211]
[<c022f2d4>] (warn_slowpath_null) from
[<bf72dab8>] (cfg80211_radar_event+0x24/0x60 [cfg80211])
[<bf72dab8>] (cfg80211_radar_event [cfg80211]) from
[<bf7813e0>] (ieee80211_dfs_radar_detected_work+0x94/0xa0 [mac80211])
[<bf7813e0>] (ieee80211_dfs_radar_detected_work [mac80211]) from
[<c0242320>] (process_one_work+0x20c/0x32c)

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[thanks Kalle, Jouni and Tamizh for the first level review]

 drivers/net/wireless/ath/ath10k/debug.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fb0ade3..ac9090b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1997,6 +1997,15 @@ static ssize_t ath10k_write_simulate_radar(struct file *file,
 					   size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
+	struct ath10k_vif *arvif;
+
+	/* Just check for for the first vif alone, as all the vifs will be
+	 * sharing the same channel and if the channel is disabled, all the
+	 * vifs will share the same 'is_started' state.
+	 */
+	arvif = list_first_entry(&ar->arvifs, typeof(*arvif), list);
+	if (!arvif->is_started)
+		return -EINVAL;
 
 	ieee80211_radar_detected(ar->hw);
 
-- 
1.9.1
