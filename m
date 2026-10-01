Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B9F4B826E
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860724; cv=none; b=GS8vV7ytzghPzF7ivHzIFZIZzBrX1cVx1ELvex+xAW9WDGOU4xheg+VwnmwELcjM8RwYD/AHc7nUX8NgJCzPDxv+q76BZ6tq7jSA7qyI9g68YROg3zd8NrrUChY7Lp6h8/l/eFaR39jDNKF/WRufIkcDwPEmx4fLnCjtTVQ+xPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860724; c=relaxed/simple;
	bh=3VEi6YFr6x6/LganLNb2++aBR83ExTGkR1Tm3YxIRpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sUR1U/yECHLq2fMdunkMfoA7nYImgBjZfeczdjVRg/SCsirbPQoCc1olsKEfs7Tc8cW8ewYeRANGzVa2HlfBafq606MaOX3CAnxGF4m9O1qiODWpJ59eMrlkRkIfSvEfGX9JGWBF/Ldt4RCaMYPo1N0LQpgtttkEJAy7Nq/veek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QZOS+SNM; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QZOS+SNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860721; x=1822396721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3VEi6YFr6x6/LganLNb2++aBR83ExTGkR1Tm3YxIRpw=;
  b=QZOS+SNM4LM9Ec48m4zg1Wi8IjEdfHrV7+PfVRMZ3Z9TklIqHIFPTpnv
   pc9AOzKpFmGFhNcpUau9biLLYPIysQaM1BiD/L3uWpsop8uHcq4L1kY1Q
   7YnM2E9DRzYLXH4Vcvx6LbNxVRSioF56KqeddpMzRsUf/7AqqIhNiPuwC
   gQA809Ms1JdPOFuuUl+QLPDEKlPXxdcAojn6fIQK6ZBxPXKYT1UYzdZb4
   BfWu+dfOGdinC8IalGqweCKJeqc7VpRxcAPN+imwq4w7CISB0FPaoOuX9
   g2QXN8HJ7enDtqPN3pB9LckApS4DTURIYVKyr4wQWsMdKt34L4+tRnmLG
   A==;
X-CSE-ConnectionGUID: m96T7dBHT+yUzkV7HShkwA==
X-CSE-MsgGUID: l40DlhHeRU2p84WE6CO8Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423629"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423629"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:41 -0700
X-CSE-ConnectionGUID: Q3jIzggdT6250TBR4rDjHw==
X-CSE-MsgGUID: nw5Hnn4HTVSbsVSR74G/Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485534"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 07/15]  wifi: iwlwifi: correctly report TB sounding PPDUs in sniffer
Date: Thu,  1 Oct 2026 16:20:20 +0300
Message-Id: <20261001161715.f8f6a08851a8.I8689a2a1599578aea53dda62cffc7f012d1d10f7@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Sounding PPDUs are currently reported as "not for us" in the
sniffer, since PHY reports that aren't detected as sounding
immediately by a zero-length indication (which doesn't exist
for trigger-based) are released only on the next PHY sniffer
notification, when no MPDU was received.

The "not for us" indication is, however, wrong in both cases:
for TB sounding PPDUs it should be sounding, for others it
should be some unspecified (DSP?) error. Fix both cases.

Fixes: 92e87cee465c ("wifi: iwlwifi: mld: update to new sniffer API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 33 +++++++++++++++------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 738b6fb9770f..60d653b5b755 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -2864,7 +2864,7 @@ void iwl_mld_handle_rsc_notif(struct iwl_mld *mld,
 #endif /* CONFIG_PM_SLEEP */
 
 static void iwl_mld_no_data_rx(struct iwl_mld *mld,
-			       struct napi_struct *napi, u8 status,
+			       struct napi_struct *napi, bool no_mpdu,
 			       struct iwl_rx_phy_air_sniffer_ntfy *ntfy)
 {
 	struct ieee80211_rx_status *rx_status;
@@ -2889,11 +2889,26 @@ static void iwl_mld_no_data_rx(struct iwl_mld *mld,
 	/* 0-length PSDU */
 	rx_status->flag |= RX_FLAG_NO_PSDU;
 
-	switch (status) {
+	switch (ntfy->status) {
 	case IWL_SNIF_STAT_PLCP_RX_OK:
-		/* we only get here with sounding PPDUs */
-		rx_status->zero_length_psdu_type =
-			IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
+		/*
+		 * For trigger-based PPDUs, the firmware decodes the PHY header
+		 * and releases with a good status only if the frame was for the
+		 * configured AID (the bad status depends on the version), and
+		 * also only sets IWL_SNIF_FLAG_VALID_TB_RX if receiving for the
+		 * configured AID.
+		 *
+		 * So trigger-based PHY notifications without MPDU are sounding
+		 * PPDUs, while other releases without MPDU are some kind of
+		 * error after a good PHY header - don't flag failed PLCP in
+		 * this case, but release as unspecified zero-len reason.
+		 */
+		if (no_mpdu && !(ntfy->flags & IWL_SNIF_FLAG_VALID_TB_RX))
+			rx_status->zero_length_psdu_type =
+				IEEE80211_RADIOTAP_ZERO_LEN_PSDU_VENDOR;
+		else
+			rx_status->zero_length_psdu_type =
+				IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
 		break;
 	case IWL_SNIF_STAT_AID_NOT_FOR_US:
 		rx_status->zero_length_psdu_type =
@@ -2904,6 +2919,7 @@ static void iwl_mld_no_data_rx(struct iwl_mld *mld,
 	case IWL_SNIF_STAT_PLCP_RX_SIGB_ERR:
 	case IWL_SNIF_STAT_UNKNOWN_ERROR:
 	default:
+		/* some kind of PLCP error - no details from FW */
 		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
 		fallthrough;
 	case IWL_SNIF_STAT_UNEXPECTED_TB:
@@ -2947,10 +2963,9 @@ void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 			 "invalid air sniffer notification size\n"))
 		return;
 
-	/* check if there's an old one to release as errored */
+	/* check if there's an old one to release */
 	if (mld->monitor.phy.valid && !mld->monitor.phy.used)
-		iwl_mld_no_data_rx(mld, napi, IWL_SNIF_STAT_AID_NOT_FOR_US,
-				   &mld->monitor.phy.data);
+		iwl_mld_no_data_rx(mld, napi, true, &mld->monitor.phy.data);
 
 	/* old data is no longer valid now */
 	mld->monitor.phy.valid = false;
@@ -2987,7 +3002,7 @@ void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 	}
 
 	if (ntfy->status != IWL_SNIF_STAT_PLCP_RX_OK || is_ndp) {
-		iwl_mld_no_data_rx(mld, napi, ntfy->status, ntfy);
+		iwl_mld_no_data_rx(mld, napi, false, ntfy);
 		return;
 	}
 
-- 
2.34.1

