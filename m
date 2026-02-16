Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A40299947
	for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2026 21:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771278913; cv=none; b=cAO8fcmngn3nX2x6sA9KuMTf5+7Si5gTweJVeVR/AUghrlvQRbQV+zivkGoyKaGkIbK8T863xAT8qcibCbQyiejg5p4eaY6VSa6yNxnogmM7f8aUy+asYIaWVE/x8emHdQkz4pyNCH0rs44q/1NBXwOE9X5cb95QFJA0IjTD6Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771278913; c=relaxed/simple;
	bh=ipfSXeXk+s0MH/s/viVQdzrTBN3RsrzjB5ZONf0Q10M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q067onytX398ExVxvEvhnmaJQlKIOTGVK+W7ZfF33Vo1kQHcIgfWZr9NJKZ9OLBj1lRNLQScHIKzRriLfdvSJi0mmnmIsJopYmRp/m4uO8Ej9w18BhHZiI6zw9Lbt8K9c5ltUD6UyiKbOEasCEKhzLA795VVYZxjaBMQAP5So38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jplzUffT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jplzUffT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771278913; x=1802814913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ipfSXeXk+s0MH/s/viVQdzrTBN3RsrzjB5ZONf0Q10M=;
  b=jplzUffT0/Tgj4Gv30je3W+5nvgHCLQeMFP5voOVOtRIEkzE4KZRz3Dh
   YwC2rnMi5Q+u6zZZuzdmyAYUzh0eNcyaq+Anwm4oZl0hk0Dia5PKC3yMA
   OQMFX64yxpUyjE0SOtSZrdNzPuKuQCkeJLSrAxdUDssUIr5q8EpyEP4Et
   1bK88fQv8GX7Vi/kA2hdjWGUDSZOVUrjzdGmO861PRnqQLGXA2tJbZzWH
   8YNZltvOVGkATMZUTje9MFGAXjjprf3UZavkL7mmEIkokvRrJMZDFeJ3n
   lJjy1QV8bmQyiZfMWX+F2OnBPw4cqlRhwIAgVkZx2zN/DS5NP9WCk11kq
   Q==;
X-CSE-ConnectionGUID: UDsU+FYkQdeoOSPJ1WrQYQ==
X-CSE-MsgGUID: fWFIoUdaQz2pcxqsebRjrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="75980290"
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="75980290"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 13:55:13 -0800
X-CSE-ConnectionGUID: SY71UJpHRiqE5mUcEOTpyg==
X-CSE-MsgGUID: d20os6OwTveGbcqPtGQq0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="213547320"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 13:55:11 -0800
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: cfg80211: make sure NAN chandefs are valid
Date: Mon, 16 Feb 2026 23:54:44 +0200
Message-Id: <20260216215452.1538316-4-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260216215452.1538316-1-miriam.rachel.korenblit@intel.com>
References: <20260216215452.1538316-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Until now there was not handling for NAN in reg_wdev_chan_valid.
Now as this wdev might use chandefs, check the validity of those.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260108102921.51b42ffc9a42.Iacb030fc17027afb55707ca1d6dc146631d55767@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/reg.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 139cb27e5a81..43c5193a6ed9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2361,6 +2361,18 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (!wdev->netdev || !netif_running(wdev->netdev))
 		return true;
 
+	/* NAN doesn't have links, handle it separately */
+	if (iftype == NL80211_IFTYPE_NAN) {
+		for (int i = 0; i < wdev->u.nan.n_channels; i++) {
+			ret = cfg80211_reg_can_beacon(wiphy,
+						      &wdev->u.nan.chandefs[i],
+						      NL80211_IFTYPE_NAN);
+			if (!ret)
+				return false;
+		}
+		return true;
+	}
+
 	for (link = 0; link < ARRAY_SIZE(wdev->links); link++) {
 		struct ieee80211_channel *chan;
 
@@ -2410,9 +2422,6 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 				continue;
 			chandef = wdev->u.ocb.chandef;
 			break;
-		case NL80211_IFTYPE_NAN:
-			/* we have no info, but NAN is also pretty universal */
-			continue;
 		default:
 			/* others not implemented for now */
 			WARN_ON_ONCE(1);
-- 
2.34.1

