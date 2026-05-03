Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2514E3AE1A2
	for <linux-wireless@vger.kernel.org>; Sun,  3 May 2026 08:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798768; cv=none; b=hdYnqpRYT/41V452lPdFfory6vwXC/+DN5O0Er7O2jRUOwxBGZfbUaKbLPxJfJfUNPLv7QS/32Aq3UdAdc6ggqu5bnaiO3jyXTr+dMH1gJiHExYRRcAvYIg7F0T4F/Vj5+NrFJEWQocv8NTnKQpZO9GONwEg/lcZa0Xf4ijILZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798768; c=relaxed/simple;
	bh=XMUBzYW4ZmvubPpHYMYpnNs13e+TeVRvFuTp6UT2SaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BeKbrxGjrgfkPv2AqzxxYnvg8Qwo89GPi33kcqLeR6hJ8yxLYNP8vQxb5zGE/zSpgi8RNRhaiCFeVW0yG8ohkvfn4oyCHFvzIWjs7r9sl46R1TngWBiSMLSCYaQIX8AcHJYuS3l5Ynf+BokuMDH2VGCWTUX8o/HVomXzchQNhMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gdfVg81x; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdfVg81x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777798766; x=1809334766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XMUBzYW4ZmvubPpHYMYpnNs13e+TeVRvFuTp6UT2SaM=;
  b=gdfVg81x2Z9qc/rgyMHLtY9R3tF3G9YHVv9gHO+TCvUmkhUHMjBRjUkO
   FBiS4nIHN4IVW4b8DZazoHvfx8lwXgyFU0FgN61QqPmOysyiotm8Cnuw+
   X0DZgMQykTBQ8D2AR49HXCDSa0TLwqJ3YO/TajiHacty4EB923EPQuUvb
   BGcVncyActPxF+FF6unN+2Aaqi8a4GcDFLmsd4ZyOmVfjzmR4KiHNcAGh
   Gv7WBjckdijLfSJyxMTTAhXB4uB261yCrpEsbzSMGL/ceLd2wT+yB2Eja
   m3tKMGStkOilG+b316oTRePwdwAEJm9mSM/wlbjfEewdvHwvO4F/pEmpF
   g==;
X-CSE-ConnectionGUID: Qn9n8SgJQcGP0FqeDJ63Dg==
X-CSE-MsgGUID: R8cTu7XMQYa0ZLarZiQH7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="89380357"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="89380357"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:24 -0700
X-CSE-ConnectionGUID: 69pBNdMDRF+KlB71+eJYtQ==
X-CSE-MsgGUID: ptW7edIJRx2bIu7o9kI+Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="235123784"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH v3 wireless-next 03/15] wifi: mac80211: accept protected frames for NAN device
Date: Sun,  3 May 2026 11:58:55 +0300
Message-Id: <20260503115440.1900c926c2e8.Ia25b2e82b250058fefa179c39327d9c8b3c3cd62@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260503085907.257378-1-miriam.rachel.korenblit@intel.com>
References: <20260503085907.257378-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Some frames sent to the NAN device may be protected, such as
protected action frames (in particular protected dual of
public action).

Accept robust management frames except disassoc on the NAN
device, and clean up the code a little bit.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/rx.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 82ea7404f3da..e1f376e0620c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4624,16 +4624,24 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		    ieee80211_has_fromds(hdr->frame_control))
 			return false;
 
-		/* Accept only frames that are addressed to the NAN cluster
+		/*
+		 * Accept only frames that are addressed to the NAN cluster
 		 * (based on the Cluster ID). From these frames, accept only
-		 * action frames or authentication frames that are addressed to
-		 * the local NAN interface.
+		 *  - public action frames,
+		 *  - authentication frames to the local address, and
+		 *  - robust management frames except disassoc.
 		 */
-		return memcmp(sdata->u.nan.conf.cluster_id,
-			      hdr->addr3, ETH_ALEN) == 0 &&
-			(ieee80211_is_public_action(hdr, skb->len) ||
-			 (ieee80211_is_auth(hdr->frame_control) &&
-			  ether_addr_equal(sdata->vif.addr, hdr->addr1)));
+		if (!ether_addr_equal(sdata->u.nan.conf.cluster_id, hdr->addr3))
+			return false;
+		if (ieee80211_is_public_action(hdr, skb->len))
+			return true;
+		if (ieee80211_is_auth(hdr->frame_control) &&
+		    ether_addr_equal(sdata->vif.addr, hdr->addr1))
+			return true;
+		if (!ieee80211_is_disassoc(hdr->frame_control) &&
+		    ieee80211_is_robust_mgmt_frame(skb))
+			return true;
+		return false;
 	case NL80211_IFTYPE_NAN_DATA:
 		if (ieee80211_has_tods(hdr->frame_control) ||
 		    ieee80211_has_fromds(hdr->frame_control))
-- 
2.34.1

