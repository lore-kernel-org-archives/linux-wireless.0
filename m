Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43994 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753014AbdCHNVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 08:21:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: kirtika@google.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: reject/clear user rate mask if not usable
Date: Wed,  8 Mar 2017 14:20:22 +0100
Message-Id: <20170308132022.4216-1-johannes@sipsolutions.net> (sfid-20170308_142122_587641_AAD67C42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the user rate mask results in no (basic) rates being usable,
clear it. Also, if we're already operating when it's set, reject
it instead.

Technically, selecting basic rates as the criterion is a bit too
restrictive, but calculating the usable rates over all stations
(e.g. in AP mode) is harder, and all stations must support the
basic rates. Similarly, in client mode, the basic rates will be
used anyway for control frames.

This fixes the "no supported rates (...) in rate_mask ..." warning
that occurs on TX when you've selected a rate mask that's not
compatible with the connection (e.g. an AP that enables only the
rates 36, 48, 54 and you've selected only 6, 9, 12.)

Reported-by: Kirtika Ruchandani <kirtika@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  | 18 +++++++++++++++++-
 net/mac80211/mlme.c |  2 ++
 net/mac80211/rate.c | 27 +++++++++++++++++++++++++++
 net/mac80211/rate.h |  2 ++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9c7490cb2243..8bc3d3669348 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3,7 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
- * Copyright (C) 2015-2016 Intel Deutschland GmbH
+ * Copyright (C) 2015-2017 Intel Deutschland GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -2042,6 +2042,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 					 params->basic_rates_len,
 					 &sdata->vif.bss_conf.basic_rates);
 		changed |= BSS_CHANGED_BASIC_RATES;
+		ieee80211_check_rate_mask(sdata);
 	}
 
 	if (params->ap_isolate >= 0) {
@@ -2685,6 +2686,21 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			return ret;
 	}
 
+	/*
+	 * If active validate the setting and reject it if it doesn't leave
+	 * at least one basic rate usable, since we really have to be able
+	 * to send something, and if we're an AP we have to be able to do
+	 * so at a basic rate so that all clients can receive it.
+	 */
+	if (rcu_access_pointer(sdata->vif.chanctx_conf) &&
+	    sdata->vif.bss_conf.chandef.chan) {
+		u32 basic_rates = sdata->vif.bss_conf.basic_rates;
+		enum nl80211_band band = sdata->vif.bss_conf.chandef.chan->band;
+
+		if (!(mask->control[band].legacy & basic_rates))
+			return -EINVAL;
+	}
+
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband = wiphy->bands[i];
 		int j;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4b4d29edec09..24d69bcf71ad 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1908,6 +1908,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.associated = cbss;
 	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
 
+	ieee80211_check_rate_mask(sdata);
+
 	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
 
 	if (sdata->vif.p2p ||
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 094c15645228..3bddd9bbb76f 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
+ * Copyright 2017	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -241,6 +242,32 @@ static void rate_control_free(struct ieee80211_local *local,
 	kfree(ctrl_ref);
 }
 
+void ieee80211_check_rate_mask(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	u32 user_mask, basic_rates = sdata->vif.bss_conf.basic_rates;
+	enum nl80211_band band;
+
+	if (WARN_ON(!sdata->vif.bss_conf.chandef.chan))
+		return;
+
+	if (WARN_ON_ONCE(!basic_rates))
+		return;
+
+	band = sdata->vif.bss_conf.chandef.chan->band;
+	user_mask = sdata->rc_rateidx_mask[band];
+	sband = local->hw.wiphy->bands[band];
+
+	if (user_mask & basic_rates)
+		return;
+
+	sdata_dbg(sdata,
+		  "no overlap between basic rates (0x%x) and user mask (0x%x on band %d) - clearing the latter",
+		  basic_rates, user_mask, band);
+	sdata->rc_rateidx_mask[band] = (1 << sband->n_bitrates) - 1;
+}
+
 static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index d51a1cce4d4a..f7825ef5f871 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -110,6 +110,8 @@ static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 #endif
 }
 
+void ieee80211_check_rate_mask(struct ieee80211_sub_if_data *sdata);
+
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
  * first available algorithm. */
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
-- 
2.11.0
