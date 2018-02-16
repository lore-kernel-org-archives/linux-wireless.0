Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59146 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758548AbeBPQNY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 11:13:24 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Feb 2018 18:13:00 +0200
Message-Id: <20180216161301.29339-13-luca@coelho.fi> (sfid-20180216_171328_919669_C636A0DA)
In-Reply-To: <20180216161301.29339-1-luca@coelho.fi>
References: <20180216161301.29339-1-luca@coelho.fi>
Subject: [PATCH 12/13] mac80211: limit wmm params to comply with ETSI requirements
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

ETSI has recently restricted the WMM parameters values for
5GHz frequencies. There are two scenarios which may cause
to violate ETSI requirements.
1. Using mac80211 default values.
2. Userspace entity tries to configure its own values
2. Associating to AP which advertises WWM IE.

In the latter case, the client configures the data from the  WMM IE as
it's WMM parameters. The AP might not comply with ETSI requirements.
Thus we should limit wmm parameters, when the current regulatory rule
implies that, to make sure we comply with ETSI requirements.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         |  3 +++
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mlme.c        |  1 +
 net/mac80211/util.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..bb22e05075f4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -2156,6 +2157,8 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	 */
 	p.uapsd = false;
 
+	ieee80211_regulatory_limit_wmm_params(sdata, &p, params->ac);
+
 	sdata->tx_conf[params->ac] = p;
 	if (drv_conf_tx(local, sdata, params->ac, &p)) {
 		wiphy_debug(local->hw.wiphy,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 536f04d14592..a58e8433fb5e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1862,6 +1863,9 @@ extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
 int ieee80211_frame_duration(enum nl80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
+void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_tx_queue_params *qparam,
+					   int ac);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify, bool enable_qos);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0024eff9bb84..23b66c611727 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1792,6 +1792,7 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				   params[ac].cw_min, params[ac].cw_max, aci);
 			return false;
 		}
+		ieee80211_regulatory_limit_wmm_params(sdata, &params[ac], ac);
 	}
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1f82191ce601..b5b0c943411e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -5,6 +5,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017	Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1113,6 +1114,44 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	return crc;
 }
 
+void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_tx_queue_params
+					   *qparam, int ac)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	const struct ieee80211_reg_rule *rrule;
+	struct ieee80211_wmm_ac *wmm_ac;
+	u16 center_freq = 0;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf)
+		center_freq = chanctx_conf->def.chan->center_freq;
+	rcu_read_unlock();
+
+	if (!center_freq)
+		return;
+
+	rrule = freq_reg_info(sdata->wdev.wiphy, MHZ_TO_KHZ(center_freq));
+
+	if (IS_ERR_OR_NULL(rrule) || !rrule->wmm_rule)
+		return;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		wmm_ac = &rrule->wmm_rule->ap[ac];
+	else
+		wmm_ac = &rrule->wmm_rule->client[ac];
+	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
+	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
+	qparam->aifs = max_t(u8, qparam->aifs, wmm_ac->aifsn);
+	qparam->txop = !qparam->txop ? wmm_ac->cot / 32 :
+		min_t(u16, qparam->txop, wmm_ac->cot / 32);
+}
+
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify, bool enable_qos)
 {
@@ -1206,6 +1245,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				break;
 			}
 		}
+		ieee80211_regulatory_limit_wmm_params(sdata, &qparam, ac);
 
 		qparam.uapsd = false;
 
-- 
2.15.1
