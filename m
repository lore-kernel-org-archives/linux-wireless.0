Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054492EEE93
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 19:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783364432; cv=none; b=K6lcj1IOswJhHKbqi13+ATYb+ZOBGt2dVpeGdnxHjTZguqSgAXNDnOiPLHYRQ0H4ZxEDn1LwX5BOLCJUAnYWEcz3lvCaEOmiZ1tRseO++Ot/UYAsl+AUNlJD/1Ysgk5duQCFdb2W74+phiz2VlRTEsnbItxRDhSsqOWnX6KoURc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783364432; c=relaxed/simple;
	bh=X4/h8GBbG2fpHq/yfHygZ2of0m3xFkwHFcyYsef0dpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZTWu2B1Bn5qlNhSdimCa4LlwIIlHIv3Teus1uzcehxBvfnFkh07HQzBOuhsVBt7qY4Y5IUv2/YsLApsbXwUkaQKwk9dIj+mC7jzf3MOy7NkbU3R1w93oE7s18GIqx5VilJ1foPLyA9Al0kkP7I2RmRVuWIDDYicG9l/VhhJ0chc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cqMiRWq2; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cqMiRWq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783364427; x=1814900427;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X4/h8GBbG2fpHq/yfHygZ2of0m3xFkwHFcyYsef0dpg=;
  b=cqMiRWq2//Hva/WXoVqwFPLFsJzk9qtmtMFCYPUuDyqggow2ZYlZzdQs
   ezvzs9cZxASaY0DGkaMtYNH5Lmt26SKBPDPhYzr3K0naoFXqPepB4UegC
   SJ1M9hsoLfoGLXIo+bm/rj+WiUYrEB5DZW1y9RRuFnZdTzXXxjC8Trcwo
   Rf2LaSj5IrYrLyPj7DDL0e1B/tzVGH23pRwZXOe07XC/qdy/GmYWpV92o
   YJ7NSPis2vlOfwicdrMIkLjYJxrSzx3cPdYTVHOjLXHY0kmRm/kk6THb2
   Hj+ZD2nVEZrsuhm/NiAMM4oeCIMD/WH8fN5MoxHM22zdrV018BVdT8Zsm
   w==;
X-CSE-ConnectionGUID: X6czRkT4QUmqWPI7NsW4oQ==
X-CSE-MsgGUID: yCnaL6fTTByMiz6ZtGgFhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="82985424"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="82985424"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 12:00:26 -0700
X-CSE-ConnectionGUID: cOTfDHpXQAC+xLpi2i7q/A==
X-CSE-MsgGUID: Z8cYv2eNSHqUMmB49NUEEw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 12:00:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: recalculate rx_nss on IBSS peer capability update
Date: Mon,  6 Jul 2026 22:00:02 +0300
Message-Id: <20260706215954.422adfd57b71.I5a47f65c5e38a221712f5203e5c8040304b382b5@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

When IBSS peer capabilities change, rates_updated is set to true in
ieee80211_update_sta_info(), but rx_nss is never recalculated.
For peers with HT/VHT, this leaves rx_nss at 0 instead of the
correct value, causing drivers to use incorrect rate scaling
parameters.

The root cause is that the commit below moved NSS initialisation
out of rate_control_rate_init() into explicit call sites, but
missing the rates_updated path in ieee80211_update_sta_info().

Fix this by calling ieee80211_sta_init_nss_bw_capa() before
rate_control_rate_init() when peer capabilities are updated,
consistent with the other IBSS call sites added by that commit.

Fixes: e5ad38a9b261 ("wifi: mac80211: clean up STA NSS handling")
Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/ibss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d0fd6054f182..1e5414ee27c0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1029,8 +1029,8 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
 		u8 rx_nss = sta->sta.deflink.rx_nss;
 
-		/* Force rx_nss recalculation */
-		sta->sta.deflink.rx_nss = 0;
+		ieee80211_sta_init_nss_bw_capa(&sta->deflink,
+					       &sdata->deflink.conf->chanreq.oper);
 		rate_control_rate_init(&sta->deflink);
 		if (sta->sta.deflink.rx_nss != rx_nss)
 			changed |= IEEE80211_RC_NSS_CHANGED;
-- 
2.34.1

