Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114A83655F0
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758866; cv=none; b=tHn6wdDQGAajqDXHDIh8SgZl2DhOsEKfIOfxwhi3F/U5PbYAqgJOm1LW/Y/ex3sdTq/5Eb34aP2HbzdLXECP2A++H79kDXewathmRkQc+ht7wuR/XwCzNhGsxlsH1YsLaafJWZGs3PhyphvgWeBDggQiDXeqVZRE9fM4JCVu2Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758866; c=relaxed/simple;
	bh=P4nULrjjahqiHFZjwZW6vODo/Ei2yE/EzHgLyNiFDHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rocnrWERHW4DZAY3poOgPVPHcXg3O1f7L1piPpXslBkwSfEJWpvfvcJIgAjBMPA+qPKHKYzhFR63Ww/aicNNpfn8W2Yx21xJDhS+WVf+Oc9hR9B92B08iswmJOiTfUprA2IqH1yXg+uqhPuOYMKuHNdffKxd47xsJR2wpbs1Ysw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZGRs9Q35; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZGRs9Q35"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790758865; x=1822294865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P4nULrjjahqiHFZjwZW6vODo/Ei2yE/EzHgLyNiFDHc=;
  b=ZGRs9Q35VdDA3BGeOcIlNa3NoRFyYe08qCGmwv5uX/OeRy4oHzR1J5md
   mZYi4u54boG39Cq/v26tPyg/Sfbt9ubMqlBJUjZnxSrwkOgQNxae8jM14
   pARxV7QoJCQ8TvQ30hIiTsEteeoCKAT454hAhZmjdHGxo+VLN2HoSM1iU
   Tp8vsN6vcbtoMsxKP/+33ulK2mc2aK5zdKy96WvYrGXC3VmbU2myyl803
   /lfr6B4L52jHOU357ripyvGWqdZ08f6az4XYzidfbBtz3fVE8cwvH63LN
   f1LXNNLTipD5i0WwyK0qFAuT7MQIzp3OMbYp1276f1HAzKHCl25XOWY01
   w==;
X-CSE-ConnectionGUID: C0NgY9trTYaQthB/ihqtSA==
X-CSE-MsgGUID: S6a/rtH2TcWFp0//Bnul7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102062822"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102062822"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:01:05 -0700
X-CSE-ConnectionGUID: OSEiix0MT5GQ8g7eY70ZPA==
X-CSE-MsgGUID: YNiK2yEBStWS/dmSSDa+9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="274240822"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:01:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 wireless-next 2/2] wifi: mac80211: fix and clean up protected TWT support
Date: Wed, 30 Sep 2026 12:02:57 +0300
Message-Id: <20260930120021.844fde440b63.I80999965c70e50d756ab62833fc7f53f2481cf3d@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930120021.1eb6760356f2.Ie4962eaca97be29c7f08043d615534c7aeb3f370@changeid>
References: <20260930120021.1eb6760356f2.Ie4962eaca97be29c7f08043d615534c7aeb3f370@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The "twt_protected" flag in the link/bss_conf information
really isn't right since this is negotiated via RSNX and
therefore cannot differ per link. Move it to be a per-STA
indication and also derive it from the new assoc request
flag since that gets used with security profile.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/mld/iface.c    |  4 +++-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 ++-
 include/net/mac80211.h                        |  4 ++--
 net/mac80211/ieee80211_i.h                    |  1 +
 net/mac80211/mlme.c                           | 21 ++++++++++++-------
 5 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.c b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
index 2b837c6fa5fe..0307abff5644 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
@@ -241,6 +241,8 @@ static void iwl_mld_fill_mac_cmd_sta(struct iwl_mld *mld,
 				     struct ieee80211_vif *vif, u32 action,
 				     struct iwl_mac_config_cmd *cmd)
 {
+	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	struct ieee80211_sta *ap_sta = mld_vif->ap_sta;
 	struct ieee80211_bss_conf *link;
 	u32 twt_policy = 0;
 	int link_id;
@@ -290,7 +292,7 @@ static void iwl_mld_fill_mac_cmd_sta(struct iwl_mld *mld,
 
 		if (link->twt_requester)
 			twt_policy |= TWT_SUPPORTED;
-		if (link->twt_protected)
+		if (ap_sta && ap_sta->twt_protected)
 			twt_policy |= PROTECTED_TWT_SUPPORTED;
 		if (link->twt_broadcast)
 			twt_policy |= BROADCAST_TWT_SUPPORTED;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b2c5be22c293..b41b4bbf0049 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -644,11 +644,12 @@ __le32 iwl_mvm_mac_ctxt_cmd_p2p_sta_get_oppps_ctwin(struct iwl_mvm *mvm,
 u32 iwl_mvm_mac_ctxt_cmd_sta_get_twt_policy(struct iwl_mvm *mvm,
 					    struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u32 twt_policy = 0;
 
 	if (vif->bss_conf.twt_requester && IWL_MVM_USE_TWT)
 		twt_policy |= TWT_SUPPORTED;
-	if (vif->bss_conf.twt_protected)
+	if (mvmvif->ap_sta && mvmvif->ap_sta->twt_protected)
 		twt_policy |= PROTECTED_TWT_SUPPORTED;
 	if (vif->bss_conf.twt_broadcast)
 		twt_policy |= BROADCAST_TWT_SUPPORTED;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb9f8e14b3b6..a24d849b8f9c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -640,7 +640,6 @@ struct ieee80211_bss_npca_params {
  *	mode only, set if the AP advertises TWT responder role)
  * @twt_responder: does this BSS support TWT requester (relevant for managed
  *	mode only, set if the AP advertises TWT responder role)
- * @twt_protected: does this BSS support protected TWT frames
  * @twt_broadcast: does this BSS support broadcast TWT
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble
@@ -812,7 +811,6 @@ struct ieee80211_bss_conf {
 	bool he_support;
 	bool twt_requester;
 	bool twt_responder;
-	bool twt_protected;
 	bool twt_broadcast;
 	/* erp related data */
 	bool use_cts_prot;
@@ -2728,6 +2726,7 @@ struct ieee80211_link_sta {
  * @spp_amsdu: indicates whether the STA uses SPP A-MSDU or not.
  * @epp_peer: indicates that the peer is an EPP peer.
  * @cip: indicates whether the STA uses control frame protection or not.
+ * @twt_protected: does this STA support protected TWT frames
  * @nmi: For NDI stations, pointer to the NMI station of the peer.
  * @nan_sched: NAN peer schedule for this station. Valid only for NMI stations.
  * @ext_mld_capa_ops: the MLD's extended MLD capabilities and operations
@@ -2750,6 +2749,7 @@ struct ieee80211_sta {
 	u16 eml_cap;
 
 	bool cip;
+	bool twt_protected;
 
 	struct ieee80211_sta_aggregates *cur;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1430527d216c..b571019bd05a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -487,6 +487,7 @@ struct ieee80211_mgd_assoc_data {
 	bool s1g;
 	bool spp_amsdu;
 	bool cip;
+	bool protected_twt;
 
 	s8 assoc_link_id;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3a17d1ccd32a..173afe176891 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6169,13 +6169,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 						  link_sta);
 
 		bss_conf->he_support = link_sta->pub->he_cap.has_he;
-		if (elems->rsnx && elems->rsnx_len &&
-		    (elems->rsnx[0] & WLAN_RSNX_CAPA_PROTECTED_TWT) &&
-		    wiphy_ext_feature_isset(local->hw.wiphy,
-					    NL80211_EXT_FEATURE_PROTECTED_TWT))
-			bss_conf->twt_protected = true;
-		else
-			bss_conf->twt_protected = false;
 
 		*changed |= ieee80211_recalc_twt_req(sdata, sband, link,
 						     link_sta, elems);
@@ -6208,7 +6201,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	} else {
 		bss_conf->he_support = false;
 		bss_conf->twt_requester = false;
-		bss_conf->twt_protected = false;
 		bss_conf->eht_support = false;
 		bss_conf->epcs_support = false;
 	}
@@ -7016,6 +7008,18 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta.spp_amsdu = assoc_data->spp_amsdu;
 	sta->sta.cip = assoc_data->cip;
+	sta->sta.twt_protected = assoc_data->protected_twt;
+
+	/*
+	 * backward compatibility - assumes that RSNX will not
+	 * indicate anything (if present at all) _less_ than
+	 * security profile RSNX content might
+	 */
+	if (elems->rsnx && elems->rsnx_len &&
+	    (elems->rsnx[0] & WLAN_RSNX_CAPA_PROTECTED_TWT) &&
+	    wiphy_ext_feature_isset(local->hw.wiphy,
+				    NL80211_EXT_FEATURE_PROTECTED_TWT))
+		sta->sta.twt_protected = true;
 
 	if (ieee80211_vif_is_mld(&sdata->vif)) {
 		if (!elems->ml_basic)
@@ -10596,6 +10600,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	assoc_data->spp_amsdu = req->flags & ASSOC_REQ_SPP_AMSDU;
 	assoc_data->cip = req->flags & ASSOC_REQ_CIP;
+	assoc_data->protected_twt = req->flags & ASSOC_REQ_PROTECTED_TWT;
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
-- 
2.34.1

