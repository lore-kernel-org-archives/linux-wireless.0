Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE03A8388
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074803; cv=none; b=hEzqs7NjSF30886WXrdBTAnElZEcv2Z/td3HpW+b//fHC/dR9TfrQn407+l/LRSNtvukAsLyc9mkXQrLUuo0Ri5D0RZ3RNhREYNwYKBI8xoaHrbbV3WToHBUVlM6+5TdWFz3tAlAof73EvOfnN+acA1+T2GRL+7lM3vRsI0tUFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074803; c=relaxed/simple;
	bh=6Yc1i890ylo8DZLg2b5owasl1t+sT2bo3PdOrihd4ns=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NyhV8jPk3nD90loL1r9VI1iZtmfT1Vzd6z8sWvh7dnIunZIRjOyElmpJJ5pOxVmQCxRXv19UuI0vAbvYSl9f8XreVwxJ142BI9R6hDMxAPlG3riMfbwJ/6JFmx2ecN402LLd/i1RnZU2fmWiybcAYH3AHGTaIbvfqgDNtv1/6ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dT03RUce; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dT03RUce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790074799; x=1821610799;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6Yc1i890ylo8DZLg2b5owasl1t+sT2bo3PdOrihd4ns=;
  b=dT03RUce0lFKRRfYMWvkH/cH4lMRub72R/aowT5EicINhjrS8HGvlii/
   oKC6wXH66SjtHhWvcHAL8YFCzXcCQ0MfOgIfhme1+JBNynJ/3Xs1n9ls/
   md6cIs6TXR1gUNzbvVWi+pyTwYRknNF5AZGjW1G4CQbQqVAQmhnM4GdE4
   UnTm7VaqAUlVKpKCrpaDPZmAcT5mLYKf681yZEv/nSAiY7WRFCavd/PKB
   9oTV+UKL8jiv9cMNaZKbXHl5EMvCr1omEtEGCImNbzXprc5/ApJXYPMEC
   J8a4MnB96q0vw1dZUmrkP92lTe6mcsw7Fu8iHCVG+n349dQqeriZ0p5cI
   Q==;
X-CSE-ConnectionGUID: u53lUL/CSzCIU6NHJDLG4w==
X-CSE-MsgGUID: h8ZdV7k2QKWoV+fG7QDMlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101328051"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="101328051"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:59:57 -0700
X-CSE-ConnectionGUID: mQ7BGWDyRzupcEUTZjC2zQ==
X-CSE-MsgGUID: iSjsWYsBTkGJcqyL/hzPLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273252994"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:59:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 wireless] wifi: nl80211: allow a NAN peer schedule with 2 channels in the same slot
Date: Tue, 22 Sep 2026 14:01:51 +0300
Message-Id: <20260922140131.6c3e3f552bda.I056644aaeea3f96605272651c4108e9ff224caf1@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

A NAN peer that has dual radio can schedule a slot to 2 different
channels.
Until now, for single radio devices, we disallowed such a peer schedule.
This was done so because the assumption was that the user space needs to
pick one of the channels for us, according to its logic.

But for devices that have their ULW logic offloaded, it can be useful if we
program it with the full information and let it decide what to do.
For example:
- peer has slot S scheduled to C1 and C2
- local schedule has S scheduled to C1
- in practice, the device is on C2 at S, for example due to non-NAN
  activity

In that case, this extra information can actually be useful to the
device, and bring to more efficient usage of the time.

Allow a peer schedule that has a single slot scheduled to two different
channels.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
v2: resending after nipa bot didn't work
 include/uapi/linux/nl80211.h | 10 ++++++----
 net/wireless/nl80211.c       | 23 ++---------------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..0d72d505980c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1399,10 +1399,12 @@
  *	be provided.
  *	Each peer channel must be compatible with at least one local channel
  *	set by %NL80211_CMD_SET_LOCAL_NAN_SCHED. Different maps must not
- *	contain compatible channels.
- *	For single-radio devices (n_radio <= 1), different maps must not
- *	schedule the same time slot, as the device cannot operate on multiple
- *	channels simultaneously.
+ *	contain compatible channels. Two maps may schedule the same time slot.
+ *	The device decides at runtime which of the channels to follow.
+ *	For example, the local schedule may place slot S on channel c1 while
+ *	the peer advertises slot S on both c1 and c2. If the device is anyway
+ *	on c2 during slot S (e.g. via the ULW mechanism for non-NAN activity),
+ *	it may use slot S on c2 to communicate with the peer.
  *	When updating an existing peer schedule, the full new schedule must be
  *	provided - partial updates are not supported. The new schedule will
  *	completely replace the previous one.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ddce61ec016a..2997327bbe97 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17468,8 +17468,7 @@ nl80211_parse_nan_peer_map(struct genl_info *info, struct nlattr *map_attr,
 					  map->schedule, n_channels);
 }
 
-static int nl80211_nan_validate_map_pair(struct wiphy *wiphy,
-					 struct genl_info *info,
+static int nl80211_nan_validate_map_pair(struct genl_info *info,
 					 const struct cfg80211_nan_peer_map *map1,
 					 const struct cfg80211_nan_peer_map *map2,
 					 struct cfg80211_nan_channel *nan_channels)
@@ -17504,24 +17503,6 @@ static int nl80211_nan_validate_map_pair(struct wiphy *wiphy,
 		}
 	}
 
-	/*
-	 * Check for conflicting time slots between maps.
-	 * Only check for single-radio devices (n_radio <= 1) which cannot
-	 * operate on multiple channels simultaneously.
-	 */
-	if (wiphy->n_radio > 1)
-		return 0;
-
-	for (int i = 0; i < ARRAY_SIZE(map1->schedule); i++) {
-		if (map1->schedule[i] != NL80211_NAN_SCHED_NOT_AVAIL_SLOT &&
-		    map2->schedule[i] != NL80211_NAN_SCHED_NOT_AVAIL_SLOT) {
-			NL_SET_ERR_MSG_FMT(info->extack,
-					   "Maps %u and %u both schedule slot %d",
-					   map1->map_id, map2->map_id, i);
-			return -EINVAL;
-		}
-	}
-
 	return 0;
 }
 
@@ -17638,7 +17619,7 @@ static int nl80211_nan_set_peer_sched(struct sk_buff *skb,
 
 			/* Validate against previous maps */
 			for (int j = 0; j < n_maps; j++) {
-				ret = nl80211_nan_validate_map_pair(&rdev->wiphy, info,
+				ret = nl80211_nan_validate_map_pair(info,
 								    &sched.maps[j],
 								    &sched.maps[n_maps],
 								    nan_channels);
-- 
2.34.1

