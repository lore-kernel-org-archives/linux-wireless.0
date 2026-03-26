Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C416D3BE17E
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 10:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520117; cv=none; b=INqqUUdqTW2Do1z0e67WPnH3rQlgKNNL4OaLzGgF+p0y7UY29nlFkbCFNsODFb6vYvvNxlBpBxiTovMAuED398o1JPcp0OsLG0XONAHfgZnvI8xOxOVNYfSYNFF4UH+vyHnfdWOKdCYmB1b6ox8341UDgsHkcIuAvKxhRANKO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520117; c=relaxed/simple;
	bh=7/9Xvr1HvaGpmI4e/IFJQ7nTgza+yQyMBg+CaNV9do0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rirrTPwEG8afhF6vXo0jZ36IoUjhQdGF6lcAZGvwt7lNNdfIWvBkCiUGy8EKL0BuSoFU9DZH8MDbQFp26E+yj4J5snb21391FArLgR/YD/MzowrYI78vv3aV8a8R377+XJRJsL045d/9SA4iNgNMmWEyby2ajo3mlds2HqAUuDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jGkq+qb0; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jGkq+qb0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774520116; x=1806056116;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=7/9Xvr1HvaGpmI4e/IFJQ7nTgza+yQyMBg+CaNV9do0=;
  b=jGkq+qb0pX4Y7ftd1juDVO7lQ+pT3w/nWm7CfyxC+J3Kr5e1E4lmQoKt
   5ySXuWLRrWbqxohkpAVBVwXVH+UIxxjKrKIH1mqclWDaNK04QAQHhOM7c
   UVjvrqsIJR8gXfoeg3tDYJoLfOOQbjKcEuJfOstrh4DSSrvIh3AAtFqJK
   giNnG6E4yzglKx0WYoXBuCw57wy5X+gt5GlmFmTtMBPJt31RA3AASKaNv
   orZXls4xT6p1YFVH/ESWe8l6mtMAHjwhz+fPHImDrNUDOIUcAQ9HiqCvi
   +DeG+YlC+MjsvM0om10ByB/sZWBtVjZiHAZg0pGKRqSXxOjc4u+S9xJ/m
   A==;
X-CSE-ConnectionGUID: w2wYQp30RliCRVP6LYUYww==
X-CSE-MsgGUID: aEFch7jlSkSHMjoCyjr4xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="87048568"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="87048568"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 03:15:13 -0700
X-CSE-ConnectionGUID: 2R+2yj3ZSkGBnlm7fWXsSw==
X-CSE-MsgGUID: 8ajTtVKzQ2GR5SYpZ5Bsqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="221653218"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 03:15:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 wireless-next 11/15] wifi: mac80211: add support for TX over NAN_DATA interfaces
Date: Thu, 26 Mar 2026 12:14:41 +0200
Message-Id: <20260326121156.b1d248947158.I04b27d9727f7a553fa80520cf6e532683ac03690@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260326101445.1443198-1-miriam.rachel.korenblit@intel.com>
References: <20260326101445.1443198-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Add support for TXing frames over NAN_DATA interfaces:
- find the NDI station
- populoate the addresses fields
- use NUM_NL80211_BANDS for the band, similar to NAN interfaces.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/tx.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 730c208c3bdf..b0eacab6763d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2541,6 +2541,13 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 		if (!sta)
 			return -ENOLINK;
 		break;
+	case NL80211_IFTYPE_NAN_DATA:
+		if (is_multicast_ether_addr(skb->data)) {
+			*sta_out = ERR_PTR(-ENOENT);
+			return 0;
+		}
+		sta = sta_info_get(sdata, skb->data);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2834,18 +2841,37 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		memcpy(hdr.addr3, sdata->u.ibss.bssid, ETH_ALEN);
 		hdrlen = 24;
 		break;
+	case NL80211_IFTYPE_NAN_DATA: {
+		struct ieee80211_sub_if_data *nmi;
+
+		/* DA SA Cluster ID */
+		memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		nmi = rcu_dereference(sdata->u.nan_data.nmi);
+		if (!nmi) {
+			ret = -ENOTCONN;
+			goto free;
+		}
+		memcpy(hdr.addr3, nmi->wdev.u.nan.cluster_id, ETH_ALEN);
+		hdrlen = 24;
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto free;
 	}
 
 	if (!chanctx_conf) {
-		if (!ieee80211_vif_is_mld(&sdata->vif)) {
+		if (sdata->vif.type == NL80211_IFTYPE_NAN_DATA) {
+			 /* NAN operates on multiple bands */
+			band = NUM_NL80211_BANDS;
+		} else if (!ieee80211_vif_is_mld(&sdata->vif)) {
 			ret = -ENOTCONN;
 			goto free;
+		} else {
+			/* MLD transmissions must not rely on the band */
+			band = 0;
 		}
-		/* MLD transmissions must not rely on the band */
-		band = 0;
 	} else {
 		band = chanctx_conf->def.chan->band;
 	}
-- 
2.34.1

