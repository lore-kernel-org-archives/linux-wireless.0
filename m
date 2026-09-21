Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634F44A417
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023178; cv=none; b=NN221PsCbs8dYXl50y/05MuMqEncOZhoZ61S2sIu0mIfi5ycsTY72Uvz27YigUjZSGdK4aV075h3Sog7b66GVbS7kPS018egFU3qCcbkwtBuEB3c+gAGNnuqjaOpNFybjbm+hzuYe8ZBGxroZH2bgWMxO7nRbT8tagL09TUrEs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023178; c=relaxed/simple;
	bh=QqXqf7QpZNNaAfXrpKhCo3+dCT8aAA7Aopl4ARPisso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mbVABwIJWThofuEFfEeOoHN1MRSbr9AijvYMywWVmFpVo9EptNOnUvM9PmlGSKtBGKH0GZ559SHMe/dqxxMp8q78pcsfTn8kCe2c23dGBxixnDVXW0GKHVoh540AenmhSrJ42tzU/RBnfCjoS1QwgEyNwrOs68RMD/nUjRgXQlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WUifq0iX; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WUifq0iX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023176; x=1821559176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QqXqf7QpZNNaAfXrpKhCo3+dCT8aAA7Aopl4ARPisso=;
  b=WUifq0iXFEit6fRxMcrZOHtvKhN6Y2tLGqLvhHuowrgDQWPMt7KFIGKd
   9xag2S9JYc4n5W+2lM7MaXnKPG5a9hwkAw8WvsVMf32HY7KOMI6vrGv/w
   8S0uXq1LA0OLml42TA22awalZwg3W8UDw2VEYHDE/k3QF5oTY5Rzn1hom
   NxXOiDUm0MqVkgJWILSebmlmd1+HF+j3t1zwKyN5EG3cnj+D5HHSojSXR
   s7AR60emzY8HHdb1u+jzRUgz3qozB/faRrAdqzKmua2GkGC5f80/a+JcY
   SW2+npCwS3q4JmFWQyxrSscsVu4PAVEDTJf1HolDmQcDd2IcEEFH63lr3
   A==;
X-CSE-ConnectionGUID: eATf6enaRhijeRYfYNq4yw==
X-CSE-MsgGUID: ZvnUWH5GQ4eisQcU/UFFvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128770"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128770"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:35 -0700
X-CSE-ConnectionGUID: QAGPQb2pR0OlkLV+sy5Ssw==
X-CSE-MsgGUID: DNQwwrD5SxC4BtuDicKH2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761956"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: mld: config TLC only after attaching station to a link
Date: Mon, 21 Sep 2026 23:41:13 +0300
Message-Id: <20260921233730.24cefdd72e7d.Ib32c29716c805531f881c61d13931f5b3d7084a9@changeid>
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

From: Avraham Stern <avraham.stern@intel.com>

When a NAN link is activated, the TLC config command was sent for all
the NAN stations. The TLC config was sent on all phys used by NAN.
However, when a new NAN channel is added when there is already a NAN
station (e.g. during schedule update), the station is not yet
attached to the link of this phy (until the new schedule is
applied by firmware). Sending a TLC command for the station on the
new phy at this stage results in an assert because in firmware the
station is not yet attached with the phy of this channel.
Fix it by sending the TLC command only after configuring the station
for the new phy.

Fixes: bc2f28ead224 ("wifi: iwlwifi: mld: add TLC support for NAN stations")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/nan.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/nan.c b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
index dbe7a54a38b7..8853fcb2b4ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/nan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
@@ -576,21 +576,11 @@ static int iwl_mld_nan_link_set_active(struct iwl_mld *mld,
 				       bool active)
 {
 	struct iwl_link_config_cmd cmd;
-	struct ieee80211_sta *sta;
 	int ret;
 
 	if (nan_link->active == active)
 		return 0;
 
-	if (active) {
-		for_each_station(sta, mld->hw) {
-			struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
-
-			if (mld_sta->sta_type == STATION_TYPE_NAN_PEER_NDI)
-				iwl_mld_config_tlc(mld, mld_sta->vif, sta);
-		}
-	}
-
 	nan_link->active = active;
 
 	iwl_mld_nan_link_prep_cmd(mld, nan_link, &cmd,
@@ -602,10 +592,8 @@ static int iwl_mld_nan_link_set_active(struct iwl_mld *mld,
 		return ret;
 	}
 
-	if (!active) {
+	if (!active)
 		nan_link->chanctx = NULL;
-		/* TODO: when FW is ready, Update phy in TLC to invalid after */
-	}
 
 	return 0;
 }
@@ -847,6 +835,10 @@ void iwl_mld_nan_vif_cfg_changed(struct iwl_mld *mld,
 			if (mld_sta->sta_type == STATION_TYPE_NAN_PEER_NMI ||
 			    mld_sta->sta_type == STATION_TYPE_NAN_PEER_NDI)
 				iwl_mld_add_modify_sta_cmd(mld, &sta->deflink);
+
+			if (added_links &&
+			    mld_sta->sta_type == STATION_TYPE_NAN_PEER_NDI)
+				iwl_mld_config_tlc(mld, mld_sta->vif, sta);
 		}
 
 		/*
-- 
2.34.1

