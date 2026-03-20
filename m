Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B17373BF1
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2026 08:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994192; cv=none; b=Qu31vxWX/TQdPMXNkzKz9/AChqbC08czcL4VNcZgO+XciurcRfnNOc362ACshj6MQsL6Glq2wCYCdT0cV4CNNywC5p+L9Ts1Pm+UF0SWNktHiTBZmRUguiOn6GYDWaDCflwAGgVmRQ5CjMKVJ3eSDqSt8yzhHBmM+rayxv+XAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994192; c=relaxed/simple;
	bh=ZdzrltQ12IXhZK0ZN9bqeFwlX88NMtRnEvO0DiTiUSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JqPfVtvQuWAZHNhPRg5yS/2fhpphZCYEl3yC0RxU5sAuPL3U3GSLXsI0pP0dijb/ELvX3ojspr6lLtCYcTxUXLpFrMlW6FEzQO+bE1HMn5pHTnwvTjbwEEcB3ook5PQEXBNNiPNdgBgN4qGWgxwhU9pnigYAOzwfqXIkz85Rob4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BstkgwuV; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BstkgwuV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773994191; x=1805530191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZdzrltQ12IXhZK0ZN9bqeFwlX88NMtRnEvO0DiTiUSs=;
  b=BstkgwuVYuFrzDkPP/kDyzKZZV7n/lLK4JgUZUQv4gsFSUZxvHLgrWfq
   0o91DbWFopnSLNEBir873eBMXTHSXhLYcPdZy9VSLrp8vQyv+qPGD1sqd
   DGYd5OaxYizcD1jXT0JW5lN11JPfb9I1YsCwJQ58dIG8zPOihG2eFpKa0
   YV7plMebfsj/HKT0ulS6DXsVyZ/QbQQXGYT1qO5lCnu6TfYk5o5D5chsN
   MZoktRuUsr68WGfV6RxBk/WGw41AehtPLgD2HJBYbb9iGfxn1gZZyOqp0
   78amAWNZcQ9ooJrsKPFXH6+ahQkXzsSDyFp/hlsCMBrKLuAnruZ+fc5Na
   A==;
X-CSE-ConnectionGUID: bq7jD6zUROGq+GzOt681fg==
X-CSE-MsgGUID: 5xIkOYlQTa6SdgTof1Ok5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="86154155"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="86154155"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:51 -0700
X-CSE-ConnectionGUID: f8mtjaqaQ2qPOlHFqwTwOQ==
X-CSE-MsgGUID: 2DUCfJNcRxe4dfYDM8Rh+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="227692628"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:51 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: mld: make iwl_mld_mac80211_iftype_to_fw() static
Date: Fri, 20 Mar 2026 10:09:17 +0200
Message-Id: <20260320100746.45867b060b3d.Iee64056fab7881ea5146433bacef8c2e936c45b1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
References: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This function is only used within the file, so make it static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/iface.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mld/iface.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.c b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
index dc96214671d9..472592aa97fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
@@ -74,7 +74,7 @@ static int iwl_mld_send_mac_cmd(struct iwl_mld *mld,
 	return ret;
 }
 
-int iwl_mld_mac80211_iftype_to_fw(const struct ieee80211_vif *vif)
+static int iwl_mld_mac80211_iftype_to_fw(const struct ieee80211_vif *vif)
 {
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.h b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
index 62fca166afd1..3e106c93f0db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
@@ -219,8 +219,6 @@ iwl_mld_link_from_mac80211(struct ieee80211_bss_conf *bss_conf)
 	return iwl_mld_link_dereference_check(mld_vif, bss_conf->link_id);
 }
 
-int iwl_mld_mac80211_iftype_to_fw(const struct ieee80211_vif *vif);
-
 /* Cleanup function for struct iwl_mld_vif, will be called in restart */
 void iwl_mld_cleanup_vif(void *data, u8 *mac, struct ieee80211_vif *vif);
 int iwl_mld_mac_fw_action(struct iwl_mld *mld, struct ieee80211_vif *vif,
-- 
2.34.1

