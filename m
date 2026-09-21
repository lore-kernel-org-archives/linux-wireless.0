Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B4C44BC91
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023193; cv=none; b=IgdWqq/wYtgpV3BGsoXU4x4I0TchfIOi0bVQdEPYgBpgbFWI9SevwGT7WiIrUlDzxc053bXgpGwzBAP+74QYLLM0vDRu7CAbUM6Rhl1A2MWPEHy+qq0JHujnp39tCz3nnRHpLWHQdfPXfWUmoLFAmtMrJNj6cp5u38mvobtmsog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023193; c=relaxed/simple;
	bh=Fws72MrMAWg3I3qVYAKcWCDm+4+RdQGuFghcjT+o32c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e1a2Yjgy/38T5iAwuZPKX7yYyV9hg/43sfeb7iEmkZ02pVx96HoSipS7oX3JWyK3SrODVl8lMOA2PxkogRO8M5WWS4w4MXneDeeh+zvTtwamGiN+GnNgrA2O3RWIYC8FcKPFziTkVP5YTJt+CsOSL0oZcqdG4EklfUpFkDcXa/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PH1Foeqa; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PH1Foeqa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023192; x=1821559192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fws72MrMAWg3I3qVYAKcWCDm+4+RdQGuFghcjT+o32c=;
  b=PH1FoeqaTzXQyiShciWXAoVwFTACprOS/M1VG+HKIChLzK/DWf498l29
   GnfH1HIooY4m6M+ZILdaNkorg/wxPv0HkKBw79rGUEluz0EJr/wGkZUWY
   /ziwRMCNG8Yr/zjWMpCjXnGhM6TaRs9Vd5erQqZJsOJiyVgI9xIg5HNz/
   EybNlaEKS5j+SDCgeq9zWA9WhWOCfw34hUZzfbD/H+hBp39zfkYmWS/O5
   bmlfZatISkkSVDQ4W/a6a3b4+hFGHY5ktdy7NtFce/jfR1t1oXpyPYt/y
   NC9r8yuD7G4NU6FfFDylhPSIaGADX4rb0KfZb/ZcGmEVtrduRCJPhhSrO
   g==;
X-CSE-ConnectionGUID: J5K6CiARTlaGhEPiqpWcbw==
X-CSE-MsgGUID: E8Mab80BSvi05lVPadMaRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128811"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128811"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:52 -0700
X-CSE-ConnectionGUID: CXK7u6bOTXyEyuC0sgNzNw==
X-CSE-MsgGUID: 3QJrkTEDSy+IDc3WcxMRsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762131"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:51 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mld: remove NAN keys before removing internal stations
Date: Mon, 21 Sep 2026 23:41:25 +0300
Message-Id: <20260921233731.6d541e506ee4.Idaed08b15314b26abb4dc9f4a8a41e61a021597e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ayala Beker <ayala.beker@intel.com>

FW expects all keys to be removed before removing a station.
On NAN teardown, iwl_mld_stop_nan() removed the NAN
internal stations while their IGTK/BIGTK were still in FW.
mac80211 frees NAN keys only after drv_stop_nan() returns, so
they are available while NAN is still up.

Remove the NAN group keys before deleting the NAN internal stations.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/nan.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/nan.c b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
index 8853fcb2b4ec..10df33a238d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/nan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
@@ -5,6 +5,7 @@
 
 #include "mld.h"
 #include "iface.h"
+#include "key.h"
 #include "link.h"
 #include "mlo.h"
 #include "tlc.h"
@@ -107,6 +108,20 @@ static void iwl_mld_nan_flush(struct iwl_mld *mld, struct ieee80211_vif *vif)
 	iwl_mld_flush_link_sta_txqs(mld, sta->sta_id);
 }
 
+static void iwl_mld_remove_nan_keys_iter(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_sta *sta,
+					 struct ieee80211_key_conf *key,
+					 void *data)
+{
+	struct iwl_mld *mld = data;
+
+	if (sta || key->hw_key_idx == STA_KEY_IDX_INVALID)
+		return;
+
+	iwl_mld_remove_key(mld, vif, NULL, key);
+}
+
 static void iwl_mld_nan_remove_stations(struct iwl_mld *mld,
 					struct ieee80211_vif *vif)
 {
@@ -296,6 +311,8 @@ int iwl_mld_stop_nan(struct ieee80211_hw *hw,
 	if (ret)
 		IWL_ERR(mld, "NAN: Failed to stop NAN. ret=%d\n", ret);
 
+	ieee80211_iter_keys(mld->hw, vif, iwl_mld_remove_nan_keys_iter, mld);
+
 	/* assume that higher layer guarantees that no additional frames are
 	 * added before calling this callback
 	 */
-- 
2.34.1

