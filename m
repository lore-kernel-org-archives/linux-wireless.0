Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEC119C553
	for <linux-wireless@vger.kernel.org>; Sun,  1 Mar 2026 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772363951; cv=none; b=sRiUMAO2DKlkolRa/B8EGuSYNBdrup3L44/7FfcQwl4C0wTlcDAqMk1ywNHASorhsB/e5HOtwd2wwImGvc+JbvTi8Rc3zwAoD/nWZWs6bLJ+pUAWEvf+gCWZDWqjpnNBvFTAZSWpGLYOWMs98cFFt7POkAokKFrQFWKa/yNvH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772363951; c=relaxed/simple;
	bh=iR6VCgX6OZypW1fkgTTMiwCINixW9yf0scGhLlXTI0o=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=SbR3xWRklyiu37vlMAZ5PS1xi6g10zJ5z7S+cJxLA9KlJXkBLP+Nd+NEay1qO+nw0cpv/ur7g40WCnFRrnD9YEIOTrnavq7Np0LUTMsOZMXJLkkalzZoHHBsuZcqLvtwLMIUy/SLZw1ZwYVWepnf4TaGS/tDRhuWhQr6Xs6/gvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ijRdwMMm; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ijRdwMMm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772363948; x=1803899948;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iR6VCgX6OZypW1fkgTTMiwCINixW9yf0scGhLlXTI0o=;
  b=ijRdwMMmMT5ZWcRkfbW0o136BXNm92scrFhYsD99oTip3wEXjWZXKWRH
   y3aGfKiF7GmwqovynVHOLuzg8eb3ICXtjLk8T2fqxwVR2JPIBk8jSRShe
   eNFnfXni+cOs5J/B6Pk3jBxXdFuaosStbFoAQZmKhVBBCs4m/Ui56Sq5U
   5jFkQ8jOWkiEQ2yJhfoncKbDwxTmuKfEm5g6RivkAq8deMnbdLvcVDiHB
   F7eoS6IjPKKGUp9hqsE6s0gd80ml+KPGcNGDwVQyLbCV4b4KFiyKpkpAq
   46xzVpNzCdwR/ZUrj2obt5/FlO/tAl1BUZ9EQHot+RLqNtSRY5Tyy9a0q
   Q==;
X-CSE-ConnectionGUID: CBpZOqaSShCVTjYnELONqg==
X-CSE-MsgGUID: iUAowkTbRw6RgRoPr4JtQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="84026818"
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="84026818"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 03:19:07 -0800
X-CSE-ConnectionGUID: uZnYc6iYTLSZvHW3MbQxnw==
X-CSE-MsgGUID: 1wq3Sz4GTDKhDkTGu9Ukdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="217467221"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 03:19:06 -0800
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wifi: cfg80211: make cluster id an array
Date: Sun,  1 Mar 2026 13:18:50 +0200
Message-Id: <20260301131848.b0085a6b4eb3.Ib16bf5cca55463d4c89e18099cf1dfe4de95d405@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

cfg80211_nan_conf::cluster_id is currently a pointer, but there is no real
reason to not have it an array. It makes things easier as there is no
need to check the pointer validity each time.
If a cluster ID wasn't provided by user space it will be randomized.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/nan.c |  5 ++---
 include/net/cfg80211.h                       |  3 +--
 net/mac80211/cfg.c                           | 12 ++----------
 net/wireless/nl80211.c                       | 14 +++++++++++---
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/nan.c b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
index 2dbd3d58b0c6..4d8e85f2bd7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/nan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
@@ -54,9 +54,8 @@ static int iwl_mld_nan_config(struct iwl_mld *mld,
 	ether_addr_copy(cmd.nmi_addr, vif->addr);
 	cmd.master_pref = conf->master_pref;
 
-	if (conf->cluster_id)
-		memcpy(cmd.cluster_id, conf->cluster_id + 4,
-		       sizeof(cmd.cluster_id));
+	memcpy(cmd.cluster_id, conf->cluster_id + 4,
+	       sizeof(cmd.cluster_id));
 
 	cmd.scan_period = conf->scan_period < 255 ? conf->scan_period : 255;
 	cmd.dwell_time =
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc01de19c798..73f4aa15c956 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4020,7 +4020,6 @@ struct cfg80211_nan_band_config {
  *	(i.e. BIT(NL80211_BAND_2GHZ)).
  * @cluster_id: cluster ID used for NAN synchronization. This is a MAC address
  *	that can take a value from 50-6F-9A-01-00-00 to 50-6F-9A-01-FF-FF.
- *	If NULL, the device will pick a random Cluster ID.
  * @scan_period: period (in seconds) between NAN scans.
  * @scan_dwell_time: dwell time (in milliseconds) for NAN scans.
  * @discovery_beacon_interval: interval (in TUs) for discovery beacons.
@@ -4036,7 +4035,7 @@ struct cfg80211_nan_band_config {
 struct cfg80211_nan_conf {
 	u8 master_pref;
 	u8 bands;
-	const u8 *cluster_id;
+	u8 cluster_id[ETH_ALEN] __aligned(2);
 	u16 scan_period;
 	u16 scan_dwell_time;
 	u8 discovery_beacon_interval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b92b4a5c2636..490e2d9b1720 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -330,7 +330,6 @@ static void ieee80211_stop_p2p_device(struct wiphy *wiphy,
 
 static void ieee80211_nan_conf_free(struct cfg80211_nan_conf *conf)
 {
-	kfree(conf->cluster_id);
 	kfree(conf->extra_nan_attrs);
 	kfree(conf->vendor_elems);
 	memset(conf, 0, sizeof(*conf));
@@ -372,9 +371,6 @@ static int ieee80211_nan_conf_copy(struct cfg80211_nan_conf *dst,
 		memcpy(&dst->band_cfgs, &src->band_cfgs,
 		       sizeof(dst->band_cfgs));
 
-		kfree(dst->cluster_id);
-		dst->cluster_id = NULL;
-
 		kfree(dst->extra_nan_attrs);
 		dst->extra_nan_attrs = NULL;
 		dst->extra_nan_attrs_len = 0;
@@ -383,12 +379,8 @@ static int ieee80211_nan_conf_copy(struct cfg80211_nan_conf *dst,
 		dst->vendor_elems = NULL;
 		dst->vendor_elems_len = 0;
 
-		if (src->cluster_id) {
-			dst->cluster_id = kmemdup(src->cluster_id, ETH_ALEN,
-						  GFP_KERNEL);
-			if (!dst->cluster_id)
-				goto no_mem;
-		}
+		if (is_zero_ether_addr(dst->cluster_id))
+			ether_addr_copy(dst->cluster_id, src->cluster_id);
 
 		if (src->extra_nan_attrs && src->extra_nan_attrs_len) {
 			dst->extra_nan_attrs = kmemdup(src->extra_nan_attrs,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b94231c8441c..e220ccbba91b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21,6 +21,7 @@
 #include <linux/nospec.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
+#include <linux/random.h>
 #include <net/net_namespace.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
@@ -15725,9 +15726,16 @@ static int nl80211_parse_nan_conf(struct wiphy *wiphy,
 		return err;
 
 	changed |= CFG80211_NAN_CONF_CHANGED_CONFIG;
-	if (attrs[NL80211_NAN_CONF_CLUSTER_ID] && start)
-		conf->cluster_id =
-			nla_data(attrs[NL80211_NAN_CONF_CLUSTER_ID]);
+	if (attrs[NL80211_NAN_CONF_CLUSTER_ID] && start) {
+		ether_addr_copy(conf->cluster_id,
+				nla_data(attrs[NL80211_NAN_CONF_CLUSTER_ID]));
+	} else if (start) {
+		conf->cluster_id[0] = 0x50;
+		conf->cluster_id[1] = 0x6f;
+		conf->cluster_id[2] = 0x9a;
+		conf->cluster_id[3] = 0x01;
+		get_random_bytes(&conf->cluster_id[4], 2);
+	}
 
 	if (attrs[NL80211_NAN_CONF_EXTRA_ATTRS]) {
 		conf->extra_nan_attrs =
-- 
2.34.1

