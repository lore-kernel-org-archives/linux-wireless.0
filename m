Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF055012B5
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017180; cv=none; b=by2xhzzJdhLTo1ABHG6r4v78rPfZH4MPf8k1Q7i+sMZEW3LT8LfVTKSXI1GJ3V0MmNumxvbzNGhCDGqlhYbcjmb45OiULzX7x16eKIeusnOgVifSkxRcu8TCkSBjkKlUrvchVL8YXuIlHKIb3AkwTV95kuvQ/k9XCt5pe26vAnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017180; c=relaxed/simple;
	bh=oPmaApSiz+KKHsLNzSzcz2HAriFoJ4IlbLU0gAdyshs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U+j7ou6P38QXJ2FTh6v8bwoMbx8qeCmLoQc7RhGstcHNeEa1no8WEEi3i0BUPARyR6K3D0ksUDlKO4JCvOIv7ujQMexHtNw5LOEg2LxVemmduoSJYrr/q1A2sP74unn1M4KPbcCscTAYI/9jXBiICGTJFzgnWGglToQ56IFdpSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P3MkhxW6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P3MkhxW6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790017179; x=1821553179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oPmaApSiz+KKHsLNzSzcz2HAriFoJ4IlbLU0gAdyshs=;
  b=P3MkhxW6B3wqyzHreNow9oEZjYzq8psemxaVPu9pQfBYW5hoWgl3jCZp
   QA+hO0i165ANp1XFV6sMHvNMZIQ7wjuUg90iqJ58Wc5tJdLHuZqO4cVRT
   8jR+tYpYrz6IAfkicEPfvBGnS+mf5uYnZrLYr3UzS/ai2oNqsdYOAO0O4
   zvRbMTjpAbXLh4RkCTb+LjOVZri/HZYrz5V04rrs0R2evJzGsSh0FOhoc
   QVcOEiGaT/gPEQHQ2fUACj3Glf/D64jRV96SaV1eeYjLfHziwnlPDfW5q
   BRe6PfVq7cRt59BlwOjKA5yaaPt+iH28JMgISkn8fj3vFpeIzs1mMkfbj
   A==;
X-CSE-ConnectionGUID: CXpcpcVWRWWoRDyyAWg++g==
X-CSE-MsgGUID: FrsxqyldS+aG9XqOAIw+Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101155185"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="101155185"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:59:38 -0700
X-CSE-ConnectionGUID: 0Mli3AuqTIK4HS5dZH3TYg==
X-CSE-MsgGUID: 9IbAMAOuSC2NkYZD58VgUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277573349"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:59:29 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: implement NAN non-evacuable channels
Date: Mon, 21 Sep 2026 22:00:23 +0300
Message-Id: <20260921215936.ef5884349253.I38b685378c3557679ed6387922a94a7da821555c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921215936.2efc32011e73.Ice8839058e114f6f9783079807df446388187dda@changeid>
References: <20260921215936.2efc32011e73.Ice8839058e114f6f9783079807df446388187dda@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Implement the nan_set_non_evac_channels operation in mac80211. It marks
the provided channels as non-evacuable in the current local schedule and
clears the flag on all other channels. All provided channels must exist
in the current schedule, otherwise -ENOENT is returned.

ieee80211_nan_find_evac_chan() skips channels marked as non-evacuable
when selecting a channel to evacuate for concurrent operations.

Fixes: 42c9de58d990 ("wifi: mac80211: add NAN channel evacuation support")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         | 13 +++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/nan.c         | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1172d7b83ed1..46ae2aa6e4e7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -923,12 +923,14 @@ struct ieee80211_bss_conf {
  * @channel_entry: the Channel Entry blob as defined in Wi-Fi Aware
  *	(TM) 4.0 specification Table 100 (Channel Entry format for the NAN
  *	Availability attribute).
+ * @no_evacuate: if set, this channel must not be evacuated
  */
 struct ieee80211_nan_channel {
 	struct ieee80211_chan_req chanreq;
 	u8 needed_rx_chains;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	u8 channel_entry[6];
+	bool no_evacuate;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..cdcf1f057707 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5973,6 +5973,18 @@ ieee80211_set_peer_nan_sched(struct wiphy *wiphy,
 	return ieee80211_nan_set_peer_sched(sdata, sched);
 }
 
+static int
+ieee80211_set_nan_non_evac_channels(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    struct cfg80211_nan_non_evac_channels *channels)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	lockdep_assert_wiphy(wiphy);
+
+	return ieee80211_nan_set_non_evac_channels(sdata, channels);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6091,4 +6103,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_epcs = ieee80211_set_epcs,
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
+	.nan_set_non_evac_channels = ieee80211_set_nan_non_evac_channels,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9514f01778be..eaaffb80a422 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2088,6 +2088,8 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_nan_local_sched *sched);
 int ieee80211_nan_set_peer_sched(struct ieee80211_sub_if_data *sdata,
 				 struct cfg80211_nan_peer_sched *sched);
+int ieee80211_nan_set_non_evac_channels(struct ieee80211_sub_if_data *sdata,
+					struct cfg80211_nan_non_evac_channels *channels);
 void ieee80211_nan_free_peer_sched(struct ieee80211_nan_peer_sched *sched);
 void ieee80211_nan_update_ndi_carrier(struct ieee80211_sub_if_data *ndi_sdata);
 struct ieee80211_nan_channel *
diff --git a/net/mac80211/nan.c b/net/mac80211/nan.c
index 19e08661be43..38bd105121ac 100644
--- a/net/mac80211/nan.c
+++ b/net/mac80211/nan.c
@@ -248,6 +248,35 @@ ieee80211_nan_find_free_channel(struct ieee80211_nan_sched_cfg *sched_cfg)
 	return NULL;
 }
 
+int
+ieee80211_nan_set_non_evac_channels(struct ieee80211_sub_if_data *sdata,
+				    struct cfg80211_nan_non_evac_channels *channels)
+{
+	struct ieee80211_nan_sched_cfg *sched_cfg = &sdata->vif.cfg.nan_sched;
+
+	/*
+	 * cfg80211 already validated that all provided channels belong to the
+	 * current schedule, so just clear all non-evacuable flags and set the
+	 * ones in the list.
+	 */
+	for (int j = 0; j < ARRAY_SIZE(sched_cfg->channels); j++)
+		sched_cfg->channels[j].no_evacuate = false;
+
+	for (int i = 0; i < channels->n_channels; i++) {
+		for (int j = 0; j < ARRAY_SIZE(sched_cfg->channels); j++) {
+			if (!sched_cfg->channels[j].chanreq.oper.chan)
+				continue;
+			if (cfg80211_chandef_identical(&sched_cfg->channels[j].chanreq.oper,
+						       &channels->chandefs[i])) {
+				sched_cfg->channels[j].no_evacuate = true;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
 int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_nan_local_sched *sched)
 {
@@ -786,6 +815,10 @@ ieee80211_nan_find_evac_chan(struct ieee80211_local *local,
 
 		usable_channels++;
 
+		/* No-evacuate channel is usable but cannot be evacuated */
+		if (chan->no_evacuate)
+			continue;
+
 		chan_ctx = container_of(chan->chanctx_conf,
 					struct ieee80211_chanctx, conf);
 
-- 
2.34.1

