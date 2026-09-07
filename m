Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF45F3EC817
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801901; cv=none; b=FMJIPJb5pjNiwCv+h/WEJF8Ba0ZZy9P1jqu81KWEqb4rB7juH6NGQnFzVVDPuTkSgRmeuT4eQkutpxWEoQhfI/oweOcfRBXXIMDIcI8fPEsT1xd02bBnl0UoPXInuAuJFOoQL6kDxu+lb5y4nFTNBBVWi9CUu3d6eIP+nj/OpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801901; c=relaxed/simple;
	bh=vitwRGq5CIRS5pxV0hOQ+gBITECGrVYgYaOHi9brBRI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eOelQsfRGoEUPmBhDDO8YcEp1+ddN5Z2brJWVL5dR/mC7vIameKlIQGBEDrtRdazg8pl4OrhacSEsM3fZCegR8t4x5apXx9pb66GOo70KiIT+p2wG19dkT9wSJm6kB153GKKC3rrxAwlHPL7MLV7nyRMmgAiSuZMD36FrnNexDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ai5dW87Z; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ai5dW87Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788801898; x=1820337898;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vitwRGq5CIRS5pxV0hOQ+gBITECGrVYgYaOHi9brBRI=;
  b=ai5dW87ZinY3EY83CPYx1DzSjil00cH3AY9Wxi0EfHHmQ6zPmTvRrvw/
   r0vaktUv4z2YUeFY7MTAJZTo6K2zjpxXlwrRBcFonCDSKpGrwZ45oE+OZ
   YrJVLJOLa33OlWsnqJsyeei9cOoZnnX1ZwesKmYQNgYSVIqrF27F5yXhC
   xC8MyoS84lhsq89/GwX0m13WhAm0XHj0Jfl/wsWJ2xawMbraGLsECADvK
   nSobLPioCJUNmfRA0ayc7nTEsRgWji9ABpcDGbBCaIA9JVzXNixB2zQcL
   ErviyeeEL3y7Jnb2/qotThUocCU3kJUxtSJW4mnknwv1I8Gk50k+c3IjD
   g==;
X-CSE-ConnectionGUID: 8cYkA4ivSGer+jb1R6Xz+g==
X-CSE-MsgGUID: wRzkcpziQbmkw2yD4N+4MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="93072038"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="93072038"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:24:58 -0700
X-CSE-ConnectionGUID: ZZWUqW3YQjSGkDcFprJMiQ==
X-CSE-MsgGUID: 1WHFbXumS5GWkBkcMfkK6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="269045644"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:24:57 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless] wifi: nl80211: allow a NAN peer schedule with 2 channels in the same slot
Date: Mon,  7 Sep 2026 20:26:52 +0300
Message-Id: <20260907202640.98f283330365.I056644aaeea3f96605272651c4108e9ff224caf1@changeid>
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
 include/uapi/linux/nl80211.h | 10 ++++++----
 net/wireless/nl80211.c       | 23 ++---------------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9998f6c0a665..2e2715d24227 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1397,10 +1397,12 @@
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
index 5adcb6bd0fc5..6dba0ff53061 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17273,8 +17273,7 @@ nl80211_parse_nan_peer_map(struct genl_info *info, struct nlattr *map_attr,
 					  map->schedule, n_channels);
 }
 
-static int nl80211_nan_validate_map_pair(struct wiphy *wiphy,
-					 struct genl_info *info,
+static int nl80211_nan_validate_map_pair(struct genl_info *info,
 					 const struct cfg80211_nan_peer_map *map1,
 					 const struct cfg80211_nan_peer_map *map2,
 					 struct cfg80211_nan_channel *nan_channels)
@@ -17309,24 +17308,6 @@ static int nl80211_nan_validate_map_pair(struct wiphy *wiphy,
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
 
@@ -17444,7 +17425,7 @@ static int nl80211_nan_set_peer_sched(struct sk_buff *skb,
 
 			/* Validate against previous maps */
 			for (int j = 0; j < n_maps; j++) {
-				ret = nl80211_nan_validate_map_pair(&rdev->wiphy, info,
+				ret = nl80211_nan_validate_map_pair(info,
 								    &sched.maps[j],
 								    &sched.maps[n_maps],
 								    nan_channels);
-- 
2.34.1

