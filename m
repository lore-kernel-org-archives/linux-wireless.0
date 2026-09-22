Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D22253D0BD
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077706; cv=none; b=pAGH6ArN5D53u7yJYMnCyI8BJQo8N4GkyTqZmswElCuPjio5rfozTEDhW1MUbxdzSwaJVjhChc/vCuEy9Myr6j6jVzZehi08v4uMp6ONhWx/SPp7ksyOF7OuYO7HRaecY5+DNJY27tWj1t72WMVlnM0nJ9+qOkJI+qX1D0+ijec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077706; c=relaxed/simple;
	bh=2kMJ0JybYfIQWMjNWT500Ymqze39FFWYo2kkwaRuwkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P65I8Ms6BwRaqZbYpsU8RY4sWe+YSaqrscmrfctXG7PpvSzl1a3ouyQwItTQ/ZlL/ilXTdnRDJdycRKRttnUlzqfr+vDW069ZmLdcSmYkjQ2RYhFldJ6VuPc3xlES9f7CM36Dp8yoEbIc3dRw8JfCa0Udh/wUiE3+hzTIjJtlm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXqKeknx; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXqKeknx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077704; x=1821613704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2kMJ0JybYfIQWMjNWT500Ymqze39FFWYo2kkwaRuwkA=;
  b=TXqKeknxj543z7aOJGkIQHf+Z6IPLMUwq+04FIohKotPDhnaHhLKxmFH
   JM5B50AUQ6iT8HLDH11yu0Fvvz1sa7QogWbdYhS5aU8pP+TKFla1t43oH
   0zPVqdMgVpMxwvKRuGgZxhZNjdrrW4zil2YzdrWEpKeEBap7N6REsP5/w
   Yg4uN7g+Wj9gyDuzM+DYSNUHZovzKn9ds5Xx66/fHkOSRQvJnSGwg6Ma1
   6/knmS5rzlUWpkVMWzLayvYSQHzyPDzekZGha4wy8N4I9+bLGIR1VqIJP
   J/DJPdb2zlXk919vELVsgQZBZixGqaOFHzS1Quxhtzu8NoIa053vpJvXw
   A==;
X-CSE-ConnectionGUID: Uf6VI+sSS7y+QaP8J4TQLQ==
X-CSE-MsgGUID: Xm5TmeOBTBiXNI6+m4xvsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170543"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170543"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:17 -0700
X-CSE-ConnectionGUID: I353BAApSOeN7gTYjDLa1Q==
X-CSE-MsgGUID: zw+bIn7dT+GVCJRnYCqNYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275408"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:15 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: mld: pass phy status explicitly for sniffer
Date: Tue, 22 Sep 2026 14:49:56 +0300
Message-Id: <20260922144819.86c1201ae2f6.I4b10b530325df711c7d229f1c487285a4dfcd294@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

In some cases the frame status is changed to AID_NOT_FOR_US if no data
is received. Pass the status explicitly so that the PHY data remains
intact as that simplifies debugging.

Fixes: 92e87cee465c ("wifi: iwlwifi: mld: update to new sniffer API")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 02bdf6ccbcdc..82da642146a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -2281,7 +2281,7 @@ void iwl_mld_handle_rsc_notif(struct iwl_mld *mld,
 #endif /* CONFIG_PM_SLEEP */
 
 static void iwl_mld_no_data_rx(struct iwl_mld *mld,
-			       struct napi_struct *napi,
+			       struct napi_struct *napi, u8 status,
 			       struct iwl_rx_phy_air_sniffer_ntfy *ntfy)
 {
 	struct ieee80211_rx_status *rx_status;
@@ -2306,7 +2306,7 @@ static void iwl_mld_no_data_rx(struct iwl_mld *mld,
 	/* 0-length PSDU */
 	rx_status->flag |= RX_FLAG_NO_PSDU;
 
-	switch (ntfy->status) {
+	switch (status) {
 	case IWL_SNIF_STAT_PLCP_RX_OK:
 		/* we only get here with sounding PPDUs */
 		rx_status->zero_length_psdu_type =
@@ -2365,11 +2365,9 @@ void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 		return;
 
 	/* check if there's an old one to release as errored */
-	if (mld->monitor.phy.valid && !mld->monitor.phy.used) {
-		/* didn't capture data, so override status */
-		mld->monitor.phy.data.status = IWL_SNIF_STAT_AID_NOT_FOR_US;
-		iwl_mld_no_data_rx(mld, napi, &mld->monitor.phy.data);
-	}
+	if (mld->monitor.phy.valid && !mld->monitor.phy.used)
+		iwl_mld_no_data_rx(mld, napi, IWL_SNIF_STAT_AID_NOT_FOR_US,
+				   &mld->monitor.phy.data);
 
 	/* old data is no longer valid now */
 	mld->monitor.phy.valid = false;
@@ -2406,7 +2404,7 @@ void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 	}
 
 	if (ntfy->status != IWL_SNIF_STAT_PLCP_RX_OK || is_ndp) {
-		iwl_mld_no_data_rx(mld, napi, ntfy);
+		iwl_mld_no_data_rx(mld, napi, ntfy->status, ntfy);
 		return;
 	}
 
-- 
2.34.1

