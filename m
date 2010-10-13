Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0JMWsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:53 -0400
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id o9DMmqK5022921
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe12.cbf.corp.google.com with ESMTP id o9DMmpPK020047
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:52 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:13:50 -0700
Subject: [PATCH 3/6] Add a function for evaluating rate changes for possible notification
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Called from a work proc, this examines the last transmit rate change
to see if it warrants an event transmission.

Signed-off-by: Paul Stewart <pstew@google.com>

---
 net/mac80211/rate.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rate.h |    8 +++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4f772de..5e39494 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -399,3 +399,77 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 	rate_control_put(ref);
 }
 
+u32 ieee80211_rate_calculate(struct ieee80211_local *local,
+			     struct ieee80211_if_managed *ifmgd)
+{
+	u32 rate_val;
+	u32 modulation, streams, base_rate, mcs, gi_div;
+	struct ieee80211_tx_rate *rate_ptr = &ifmgd->last_cqm_tx_rate;
+	struct ieee80211_supported_band *sband;
+	static int mod_table[8] = { 1, 2, 3, 4, 6, 8, 9, 10 };
+
+	if (!(rate_ptr->flags & IEEE80211_TX_RC_MCS)) {
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		return sband->bitrates[ifmgd->last_cqm_tx_rate.idx].bitrate;
+	}
+
+	mcs = rate_ptr->idx;
+
+	/* MCS values over 32 are not yet supported */
+	if (mcs >= 32)
+		return 0;
+
+	modulation = mcs & 7;
+	streams = (mcs >> 3) + 1;
+	base_rate = (rate_ptr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
+		13500000 : 6500000;
+	gi_div = (rate_ptr->flags & IEEE80211_TX_RC_SHORT_GI) ? 9 : 10;
+	rate_val = base_rate * mod_table[modulation] * streams / gi_div;
+
+	return ((rate_val + 5000) / 10000) * 100;
+}
+
+void ieee80211_cqm_bitrate_notify(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_bss_conf *bss_conf;
+	u32 bitrate, threshold;
+	int prev_state, new_state;
+
+        WARN_ON(!mutex_is_locked(&local->iflist_mtx));
+
+        list_for_each_entry(sdata, &local->interfaces, list) {
+                if (!netif_running(sdata->dev) ||
+		    sdata->vif.type != NL80211_IFTYPE_STATION)
+                        continue;
+
+		ifmgd = &sdata->u.mgd;
+		bss_conf = &sdata->vif.bss_conf;
+
+		if (!(ifmgd->flags & IEEE80211_STA_TX_RATE_CHANGED) ||
+		    bss_conf->cqm_bitrate_thold == 0)
+			continue;
+
+		bitrate = ieee80211_rate_calculate(local, ifmgd);
+		threshold = bss_conf->cqm_bitrate_thold;
+		prev_state = (ifmgd->last_cqm_bitrate < threshold);
+		new_state = (bitrate < threshold);
+
+		/*
+		 * Trigger a bitrate notification if one of the following is
+		 * true:
+		 *   - We haven't sent one since the threshold was reconfigured
+		 *   - We have crossed the threshold in either direction
+		 *   - We are below threshold, and the bitrate has decreased yet
+		 *     again.
+		 */
+		if (ifmgd->last_cqm_bitrate == 0 || prev_state != new_state ||
+		    (new_state && bitrate < ifmgd->last_cqm_bitrate)) {
+			cfg80211_cqm_bitrate_notify(sdata->dev, bitrate,
+						    GFP_KERNEL);
+			ifmgd->last_cqm_bitrate = bitrate;
+		}
+		ifmgd->flags &= ~IEEE80211_STA_TX_RATE_CHANGED;
+	}
+}
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 168427b..33e4ca3 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -120,6 +120,14 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 void rate_control_deinitialize(struct ieee80211_local *local);
 
 
+/* Notify listeners about transmit rate changes */
+void ieee80211_cqm_bitrate_notify(struct ieee80211_local *local);
+
+/* Convert rate into cfg80211-compatible struct? */
+void ieee80211_rate_convert_cfg(struct ieee80211_local *local,
+				struct ieee80211_if_managed *ifmgd,
+				struct rate_info *rate);
+
 /* Rate control algorithms */
 #ifdef CONFIG_MAC80211_RC_PID
 extern int rc80211_pid_init(void);
-- 
1.7.1

