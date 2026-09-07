Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85638F926
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802441; cv=none; b=gfPl+DQJ6Drk8ycBMc0UipoNIQ/VmweIXg1xBamlHym63QypwiVBxvdL9WYOe0MieCX4BXX21UuxEH4uyz5Xtbi7U0jNDWXEzaS+3+PmADkHXtR9UP0o87HTZ/TbAncW8xSl/RwdaZKneWTRpgybSt5rXX4Ol9i0tjH3qdDCA8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802441; c=relaxed/simple;
	bh=of48Zn3QG9OYX8GAvL5SV6+iszJ6IbVmTNPc/HsZkX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PTiRkSBjkRmz24RBeT6oz2EBKQunB0segPk+AFALTU9qkbFlYRx023gQuBvaXDm6j9BSGcqV7g1owDe6atTK/FGS3qPQJZRj7jNnsmsLFg6GMWNhyb9UQsOfUcI+ONZk1pkp++B9+CQBKAdn+sxTa4dPNmq8SvUXfcFq1C4kfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NnvbdDjb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NnvbdDjb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788802440; x=1820338440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=of48Zn3QG9OYX8GAvL5SV6+iszJ6IbVmTNPc/HsZkX8=;
  b=NnvbdDjb2n3V7Yb17xzYcao82U+gXRLxrsfJHWOsEyHjnQ4cXt1JjWKv
   QVrzcowx1NPCWruWmLWL3a55x6zQEg6UKx6bk7ViFH5Y+ZYFuQcRMrofE
   EiN0kysRhxR+k9+gtvcr9UhJll2+KnnRSkSEfW/BCWu1jQSS3M7VrapzI
   LI9CtuuqX5XDjZVOmzRV2sq1Z6cHKoB+R2u2UR5ke0Zyk6dVPQJEgdzRG
   K0xIRhkEnvmRrJlh4ZCyc1prfAkF7LbvoTDptKf8bT0lMC8GOllerAQiz
   5islvvihsFXuHmnC0hUashNgqipPgORDES0I2Yie2ET1ypnoUG9GXeSq2
   g==;
X-CSE-ConnectionGUID: i/osVX5xTOSowC1KVHRLkQ==
X-CSE-MsgGUID: liiepQS4Sme5WS20tFnsOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99866319"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="99866319"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:33:59 -0700
X-CSE-ConnectionGUID: R4oqDbeYTbetFVKXGZFqLg==
X-CSE-MsgGUID: b7lzx7mZTgadGwZUmphHdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="274917180"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:33:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless 2/2] wifi: mac80211: implement NAN non-evacuable channels
Date: Mon,  7 Sep 2026 20:35:57 +0300
Message-Id: <20260907203545.4a1413ac7687.I38b685378c3557679ed6387922a94a7da821555c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
References: <20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
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
index 7bb4618065b6..33ff018c33ec 100644
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
index 53b0b08d3459..929fc8930a35 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2087,6 +2087,8 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
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

