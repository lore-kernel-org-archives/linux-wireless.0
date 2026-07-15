Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377F6442FDD
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140451; cv=none; b=ja41qcnVNAiDHBsvcCf6KNkeiLXImDr867qUWJTlqImAB6OdA5kOaGPxG/4mwCHnC6IYh+dnTWzBUvjVfPjrF4efeKDRhLV+OiPOfjkbIcM7Pa9TXixLsTEyOIvcEqYMgbn/dbBUM4J+8Vz5jFdTMbI6ZZq1jjMR0ezmzTqfMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140451; c=relaxed/simple;
	bh=5UZY5gfNquLX5qI4vfxSxdH3Hq7K7JEyX3VmHZ7mSdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sP3MF30dMqwIfsYreOlBlDrUOpxoC1DL3PtCP8gSX17laZMYT/ldNbDWvE7DbcbW3ybrT74cF9XhUc6lgYvyQNHzpTLi0VCAUNzstGoserCSRLs3gtHnXYY1VANSt5v6xjQ/dZqmPE8J4padlOFaQIoiIvh7tJM8staQPeieub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FAM72H8I; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FAM72H8I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784140446; x=1815676446;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5UZY5gfNquLX5qI4vfxSxdH3Hq7K7JEyX3VmHZ7mSdM=;
  b=FAM72H8I2POZSqRVpSvMhVS+RofgmlwrKhiyXBOpxlfk/X+rowQSyKpd
   BV40n0tfhLed2rR24i282uPs7PzQaqReCyiiXdQxp4FE+DinFv8DZ+LJD
   vhtNt70JFditl+2dRnBtsbsR4pEk+5lUaWNJPmjsbkWCzjvbu22WNk2wV
   gq5J6/QIohzZXA+mRJaA/UFilFeswomQW5DFReWEp/fkx5rkPyFtazzAr
   IIghj3WzM3VQpwQJrd+ViYWdUF/Bmb4Oh/67Bqk5f2M1UiI1Wca/br5AI
   gFCS6PDhCOSof76cfr7hzEc+w6HFvKNHow+k9dv/uvjLrEyCkAv7Xmnez
   Q==;
X-CSE-ConnectionGUID: AJwIC7WTR8W0Rm0N3IXyBQ==
X-CSE-MsgGUID: hHnfMEIRRbKEW6F0tDEEIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84753016"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="84753016"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:34:00 -0700
X-CSE-ConnectionGUID: VQIln3IyTgeFQAPw8yWO6A==
X-CSE-MsgGUID: CEVFx7PoT4GoJp3md0UFzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251847543"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:33:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: fix monitor min_def bandwidth
Date: Wed, 15 Jul 2026 21:33:38 +0300
Message-Id: <20260715213312.9fe95421689d.I24e08f95e97deb46c6393ee732057d63e6436a2e@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Due to reshuffling, the min_def is no longer calculated
taking a newly created monitor interface into account as
link->conf->chanctx_conf is only assigned after the new
bandwidth has been calculated. To handle this, rsvd_for
is assigned, but the monitor code didn't handle that.
Fix this by checking rsvd_for for monitor explicitly.

Fixes: 3f451a2cf56c ("wifi: mac80211: use for_each_chanctx_user_* in one more place")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/chan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5152b84a3357..75bb204ad743 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -607,10 +607,12 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		max_bw = max(max_bw, width);
 	}
 
-	if (!rsvd_for ||
-	    rsvd_for->sdata == rcu_access_pointer(local->monitor_sdata))
+	if (!rsvd_for)
 		goto check_monitor;
 
+	if (rsvd_for->sdata == rcu_access_pointer(local->monitor_sdata))
+		return max(max_bw, ctx->conf.def.width);
+
 	/* Consider the link for which this chanctx is reserved/going to be assigned */
 	width = ieee80211_get_width_of_link(rsvd_for);
 	max_bw = max(max_bw, width);
-- 
2.34.1

