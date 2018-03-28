Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750799AbeC1KYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 06:24:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 13:24:10 +0300
Message-Id: <20180328102411.25677-3-luca@coelho.fi> (sfid-20180328_122428_152706_1AA5D9BF)
In-Reply-To: <20180328102411.25677-1-luca@coelho.fi>
References: <20180328102411.25677-1-luca@coelho.fi>
Subject: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI requirements
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

ETSI has recently added new requirements that restrict the WMM
parameter values for 5GHz frequencies.  We need to take care of the
following scenarios in order to comply with these new requirements:

1. When using mac80211 default values;
2. When the userspace tries to configure its own values;
3. When associating to an AP which advertises WWM IE.

When associating to an AP, the client uses the values in the
advertised WMM IE.  But the AP may not comply with the new ETSI
requirements, so the client needs to check the current regulatory
rules and use those limits accordingly.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         |  3 +++
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mlme.c        |  1 +
 net/mac80211/util.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.c         |  4 ++--
 5 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5c4b105ca398..36d128ebbac8 100644
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
index ae9c33cd8ada..69c276ed6eb5 100644
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
@@ -1865,6 +1866,9 @@ extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
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
index ea3ba03fb952..a3bcf953d423 100644
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
index 55cd2922627a..11f9cfc016d9 100644
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
@@ -1113,6 +1114,48 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
+
+	if (!center_freq) {
+		rcu_read_unlock();
+		return;
+	}
+
+	rrule = freq_reg_info(sdata->wdev.wiphy, MHZ_TO_KHZ(center_freq));
+
+	if (IS_ERR_OR_NULL(rrule) || !rrule->wmm_rule) {
+		rcu_read_unlock();
+		return;
+	}
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
+	rcu_read_unlock();
+}
+
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify, bool enable_qos)
 {
@@ -1206,6 +1249,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				break;
 			}
 		}
+		ieee80211_regulatory_limit_wmm_params(sdata, &qparam, ac);
 
 		qparam.uapsd = false;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7c7c0e0f8d9d..2520734bd1db 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -135,12 +135,12 @@ static void restore_regulatory_settings(bool reset_user);
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
-	return rtnl_dereference(cfg80211_regdomain);
+	return rcu_dereference_rtnl(cfg80211_regdomain);
 }
 
 const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
-	return rtnl_dereference(wiphy->regd);
+	return rcu_dereference_rtnl(wiphy->regd);
 }
 
 static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)
-- 
2.16.2
