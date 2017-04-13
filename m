Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51720 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbdDMIci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:32:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: ilan.peer@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: use per-interface power level
Date: Thu, 13 Apr 2017 10:32:34 +0200
Message-Id: <20170413083234.1072-1-johannes@sipsolutions.net> (sfid-20170413_103242_551196_661A5FA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When channel contexts are used, there's no global power level
(the power_level is always 0). Use the per-interface TX power
in mac80211_hwsim to have a proper setting for both cases.

This fixes the bgscan_simple and bgscan_learn test cases when
the number of channels advertised by hwsim is >1 by default.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4e58513d24e8..7ac45af44144 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -558,8 +558,6 @@ struct mac80211_hwsim_data {
 	/* wmediumd portid responsible for netgroup of this radio */
 	u32 wmediumd;
 
-	int power_level;
-
 	/* difference between this hw's clock and the real clock, in usecs */
 	s64 tsf_offset;
 	s64 bcn_delta;
@@ -1207,7 +1205,9 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
 		rx_status.flag |= RX_FLAG_SHORT_GI;
 	/* TODO: simulate real signal strength (and optional packet loss) */
-	rx_status.signal = data->power_level - 50;
+	rx_status.signal = -50;
+	if (info->control.vif)
+		rx_status.signal += info->control.vif->bss_conf.txpower;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1633,7 +1633,6 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	}
 	mutex_unlock(&data->mutex);
 
-	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
 		tasklet_hrtimer_cancel(&data->beacon_timer);
 	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
@@ -2253,7 +2252,6 @@ static const char mac80211_hwsim_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"d_tx_failed",
 	"d_ps_mode",
 	"d_group",
-	"d_tx_power",
 };
 
 #define MAC80211_HWSIM_SSTATS_LEN ARRAY_SIZE(mac80211_hwsim_gstrings_stats)
@@ -2290,7 +2288,6 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 	data[i++] = ar->tx_failed;
 	data[i++] = ar->ps;
 	data[i++] = ar->group;
-	data[i++] = ar->power_level;
 
 	WARN_ON(i != MAC80211_HWSIM_SSTATS_LEN);
 }
-- 
2.11.0
