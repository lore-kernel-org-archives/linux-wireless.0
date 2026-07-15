Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D243EC698
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142310; cv=none; b=jxfWdrF1OwYGMowdxB/PZ/MW8qCWMNYcwuZjeHZ26fxCgjAfQOcmg6vUepGHi8axBvOvbTTPq+K8fsKXcNSaAs8NS/N3oHUz67as2++v+HMBTT2DKW3Wk8VmByH1tyuDr4UkyWzulvGGCSg6OlFv+HowKd0gWY6LmsjziwSEvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142310; c=relaxed/simple;
	bh=Zzra6xv2NpgO+uNTPpxht0uePNoIJ35Eg6k51hV5lnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r5iMr4oqRROdNiSKTX8s64i7+gHFiLfnyhOIJ4I7aZSZ/HWbuSYb/8+/3UoqnCutaJZYD6W2wf5frY/tM4QgwILt6ILxrbncWHsrkVlqvyaUSB0XONeU9QGDWYtVW6yn0Kt1lw5/h0/xE9BGst0wX0IAK+SG7XNv/0OyqoeLnpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fk7cXyr9; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fk7cXyr9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142300; x=1815678300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zzra6xv2NpgO+uNTPpxht0uePNoIJ35Eg6k51hV5lnA=;
  b=Fk7cXyr9cK7YBuMaMlWNxS05iN5G7+Bvr1U9vOeLIswVG2hrYBBu6DAP
   XffHjzq1CSuk743iSNNCqKu/6BCYvTcA0sPwBqjaNqYMb5di3Ehgvg6bI
   KkIZ2JWNDNxFy8Rjc2axvH2Jz4mUfhXVKRB4rpIA3PZBF9QBQiGZkDl5/
   nVH1E7iehwV8R3ZvgQrjm7zr+QuwTU50EhUw9Uw0sOp+EkfTs+ti5ajs3
   H4C1vhLWCWXgTmaXdT8CKm3JJGc03mmoBbcc9X+eg1tKyYwOA8Hb5LWJZ
   +t79H+eIk4tVTY9k5o62f0dYgie05cWvd5LdgAIrfQyuJguyL+hHfI2jr
   A==;
X-CSE-ConnectionGUID: a/UD5zHFTvWwvL21YDZVwA==
X-CSE-MsgGUID: uiQGO1g8R/alS/qVjLbRdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340688"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340688"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:54 -0700
X-CSE-ConnectionGUID: P+v107jlQ7y9Ub5K7+Sinw==
X-CSE-MsgGUID: jFI8jeqwQ4mFsZrymUwzJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851892"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:53 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mld: support aborting an ongoing ftm request
Date: Wed, 15 Jul 2026 22:04:17 +0300
Message-Id: <20260715220243.340040bdc6a3.Ifbbf70021e42bf1d59db6ec45a73f1806a1c2289@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Add support for aborting an ongoing FTM request.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../intel/iwlwifi/mld/ftm-initiator.c         | 21 +++++++++++++++++++
 .../intel/iwlwifi/mld/ftm-initiator.h         |  1 +
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 10 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
index 81df3fdfcbf5..a4b8037b5c76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
@@ -459,3 +459,24 @@ void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld)
 			       mld->ftm_initiator.req, GFP_KERNEL);
 	iwl_mld_ftm_reset(mld);
 }
+
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req)
+{
+	struct iwl_tof_range_abort_cmd cmd = {
+		.request_id = req->cookie,
+	};
+
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (req != mld->ftm_initiator.req)
+		return;
+
+	if (iwl_mld_send_cmd_pdu(mld, WIDE_ID(LOCATION_GROUP,
+					      TOF_RANGE_ABORT_CMD),
+				 &cmd))
+		IWL_ERR(mld, "failed to abort FTM process\n");
+
+	iwl_mld_cancel_notifications_of_object(mld, IWL_MLD_OBJECT_TYPE_FTM_REQ,
+					       mld->ftm_initiator.req->cookie);
+	iwl_mld_ftm_reset(mld);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
index 3fab25a52508..e82237b31467 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
@@ -25,5 +25,6 @@ int iwl_mld_ftm_start(struct iwl_mld *mld, struct ieee80211_vif *vif,
 void iwl_mld_handle_ftm_resp_notif(struct iwl_mld *mld,
 				   struct iwl_rx_packet *pkt);
 void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld);
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req);
 
 #endif /* __iwl_mld_ftm_initiator_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 4065d8e4fa8c..17922ed3800d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2852,6 +2852,15 @@ static int iwl_mld_start_pmsr(struct ieee80211_hw *hw,
 	return iwl_mld_ftm_start(mld, vif, request);
 }
 
+static void iwl_mld_abort_pmsr(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_pmsr_request *request)
+{
+	struct iwl_mld *mld = IWL_MAC80211_GET_MLD(hw);
+
+	iwl_mld_ftm_abort(mld, request);
+}
+
 static enum ieee80211_neg_ttlm_res
 iwl_mld_can_neg_ttlm(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     struct ieee80211_neg_ttlm *neg_ttlm)
@@ -2973,6 +2982,7 @@ const struct ieee80211_ops iwl_mld_hw_ops = {
 	.prep_add_interface = iwl_mld_prep_add_interface,
 	.set_hw_timestamp = iwl_mld_set_hw_timestamp,
 	.start_pmsr = iwl_mld_start_pmsr,
+	.abort_pmsr = iwl_mld_abort_pmsr,
 	.can_neg_ttlm = iwl_mld_can_neg_ttlm,
 	.start_nan = iwl_mld_start_nan,
 	.stop_nan = iwl_mld_stop_nan,
-- 
2.34.1

