Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC9448CF3
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023181; cv=none; b=tQ/SGeoop/CR28fl1Kvrnbonae+RA3a7wplF2HJQGyiKsXfpfdb2042nQkm4FibzUWke1y2PZTsIptBjXCgvSCayBv+PpVVJTHHwMkK4sLfacKF58IJP7ceZDk0fJzwEImmbS30MkPWbs/xzASM4AVBua/WbEVHd6Lc+VojEaJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023181; c=relaxed/simple;
	bh=q5/gZdCg1frFXgNuc+KWU8KBjsfPYsqZ5uLmm8zfrDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NzMbsyXp106E/WWb5UgpxUV+dLKFY6oFE3PbOu8cA3TIPeZ8oZnIVD8NXxyvskCX7suIjfnKmOxhzzy1ViHGZSlMoRto4V4grQvP2lw8FTt31Xp71IbU8R2LWm4uC6xo5XrMWo1gv/3KK1TOk3Rens0tqo+y7wItLetbbfbgBBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVu9erUt; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVu9erUt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023178; x=1821559178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q5/gZdCg1frFXgNuc+KWU8KBjsfPYsqZ5uLmm8zfrDI=;
  b=JVu9erUtBIBAhd0wgkbD5nKtLExZzVGQ0qBsvTbB7CB7HvoO6M718L7d
   XCqlEpSNQ+m+bTIPFZ/o1og8aNfqfHez9O57NroCJSrjDEqrsMB4fHw9S
   kqDo0rzQcBns4Gijfl38EFMYkQV18dBxe3pVIin0daOjMY8PoyYt4Ql3z
   YyDN9Pz3jcU0QwY1cRTZ7CZGcUaKzETq7hZp456jMplMRtaPmllhJqnm4
   gWCQZ++wch2Z3CNYqyR0HI7cVeG/Y1R3ASeXEWSjO5LmXohAPmy18GX0H
   kY+c3VgNYlfHc7L0uhijYWN/BUESQT/bWMtuNMt6fQ8m/wqUwQ6j3BezX
   A==;
X-CSE-ConnectionGUID: 6l9bOwtcRK64v8dQW6Ta1g==
X-CSE-MsgGUID: 91eht3ySQUiwFLCLC9rMLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128778"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128778"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:38 -0700
X-CSE-ConnectionGUID: bRoX9i81TeytmLXcGULG8w==
X-CSE-MsgGUID: E5lPexnPT/y8aO1QUrjSkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761987"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:37 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: don't use bss_conf in NAN
Date: Mon, 21 Sep 2026 23:41:15 +0300
Message-Id: <20260921233730.18fefde9f26d.I8bc0c16de230f3bd45b80101db0936f1e4aea516@changeid>
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

When we receive the TLC notif, we try to fetch the band from the vif
link. However, in NAN we don't have the bss_conf (link_conf[0] is
technically pointing to vif::bss_conf, but it doesn't point to a
channel).

For now we don't have a way to fetch the channel used by this TLC
instance (a NAN station can have multiple), but in the future we will
have a TLC object in the driver and then we will have a phy id in it.

For now, just take either the minimum between both lmacs or the only
existing one.

Fixes: bc2f28ead224 ("wifi: iwlwifi: mld: add TLC support for NAN stations")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
index b6c2fa3664cb..1f5994f8be26 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
@@ -824,8 +824,13 @@ iwl_mld_get_amsdu_size_of_tid(struct iwl_mld *mld,
 
 	txf = iwl_mld_mac80211_ac_to_fw_tx_fifo(ac);
 
-	/* Only one link: take the lmac according to the band */
-	if (hweight16(sta->valid_links) <= 1) {
+	/*
+	 * Only one link: take the lmac according to the band
+	 * In NAN, we don't have a link_conf.
+	 * TODO: once we have a TLC object, we can know better the band.
+	 */
+	if (hweight16(sta->valid_links) <= 1 &&
+	    vif->type != NL80211_IFTYPE_NAN_DATA) {
 		enum nl80211_band band;
 		struct ieee80211_bss_conf *link =
 			wiphy_dereference(mld->wiphy,
-- 
2.34.1

