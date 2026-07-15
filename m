Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C822A425892
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142357; cv=none; b=CEn5Jts8nqUQcDn+SkMFlTue/DKDzK8xfP8H7/B88u0CYBl5sp0kRk2Ua7UeWHck50ahTBVIy0r5F3u0Bl2qHLK7bzSbXDBJ4uUbRUXz82a1Q9sKCvfdMn2akYODPTKlToS9X7MJMO1W/7HFznv0CLpGao6XKtUAQMgrSm3WZcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142357; c=relaxed/simple;
	bh=tFLGymxYM/g8LTdwJX5r9J4gUu2AJ06fIRtn9jSRxrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FADZON4EBBlPpJ/dJr0D1H+NGQR6T3hBsJLRsEr+hjNGtW2pv4qcSjP3cN5SLMs5xpwff0DrJD71IVf0WNfjmkEK+59jJEi0eTh8BJWtPC20e6zrCpu5c9jBQ2huGnolnFPCpi9G/mYFLOxY9gmrZHq5l1s314lBCHFg1jjurHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XMW6z/9W; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMW6z/9W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142346; x=1815678346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tFLGymxYM/g8LTdwJX5r9J4gUu2AJ06fIRtn9jSRxrU=;
  b=XMW6z/9WW6Q+M7JRSvoUHUgKjN5KmKSXraBVIR6jIU4tazce2CX6JO1/
   GIypdwz6SQLLIQXq4CGS7vzVeUMYwLqccAOr+NxM1BZ2e5OB6K3djrSvH
   N5etH2cs1ZGD4aE8kyqpuu7J0bmoCPpC4kS1ruJb7WAkNluqmN6ujD2CS
   jMwXlQKuZB4fmq8nUii3t6/ras7nZqBwzKceqQf7I8UWMFe+KtHh7BI2J
   R8E0AoB3/eGXlwQaeTeoqfrxRXeklkeACTvxKJEJODvpeUjDj0iwCkLgh
   6d72nRFSRTl+3OI2Ls1S6gAMb+4D8mOaV2nUC+u2gEGPMMJdoMwO19TFn
   w==;
X-CSE-ConnectionGUID: a+9AciPNTNG9F9K4Qr2zhQ==
X-CSE-MsgGUID: pC/b7dxnRqGd3pss0LyUrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340745"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340745"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:13 -0700
X-CSE-ConnectionGUID: x7b1RwgNRtyNKrt3rAcSWA==
X-CSE-MsgGUID: u3rE6f3+RP2rjnNY8lWSdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852054"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead
Date: Wed, 15 Jul 2026 22:04:30 +0300
Message-Id: <20260715220243.89a0c44a72a3.I45cca8b84a25943d5771199af6b0155dbac77b58@changeid>
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

From: Ilan Peer <ilan.peer@intel.com>

When a channel context is unassigned, there is a path to cleanup the FW
state in case of NON MLO connection: remove the link and add it again.
However, when the transport is dead, e.g., during device removal etc.,
this flow will fail and as a result the mld_vif->link[0] would be set to
NULL. Later, when the interface is removed, iwl_mld_remove_link() would
warn as the link is NULL.

Fix this by not doing the cleanup when the device is dead.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 17922ed3800d..92985e500459 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1280,11 +1280,13 @@ void iwl_mld_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	iwl_mld_tlc_update_phy(mld, vif, link);
 
 	/* in the non-MLO case, remove/re-add the link to clean up FW state.
-	 * In MLO, it'll be done in drv_change_vif_link
+	 * In MLO, it'll be done in drv_change_vif_link.
+	 * Do not do so during restart or in case the device is dead.
 	 */
 	if (!ieee80211_vif_is_mld(vif) && !mld_vif->ap_sta &&
 	    !WARN_ON_ONCE(vif->cfg.assoc) &&
-	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart) {
+	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart &&
+	    !iwl_trans_is_dead(mld->trans)) {
 		iwl_mld_remove_link(mld, link);
 		iwl_mld_add_link(mld, link);
 	}
-- 
2.34.1

