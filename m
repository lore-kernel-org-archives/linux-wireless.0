Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED48743F088
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141903; cv=none; b=ZBYOETEVtPZ0d1b9wTn/mIcFKw7Hwvs50MvLxnUCqg2lVNhvUmFjbfIsXW4FNzBY2cPCwACQao7EL50jP7Q0DkvghTTI0whfj+5FkNGFmvo7j80TgNhPNbSHo0kEPbEbt/taL8YPp1g7i3CnYY4QS2fSxirnI0XoclV3xDAycOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141903; c=relaxed/simple;
	bh=HoMD4xaWtqA0ASinzui67MKOdt6yi9LUUHJOIBlFuj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=URIAxncJgSQNxA2NIbV5u+TxMakaaGCLMjv6jt2AR3kP97R7H3AimN4LizRoBY9HtGGjIT2J75qJcepzhj9cCgtlWP44PdauC+jPm/Nv1CH/UXr0DQAVl3ybnnpyMzrXotmhAxxnO9wL/R/cutRYMVKJxgs/fYay08TrtzF4ivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jwajWa1c; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwajWa1c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141896; x=1815677896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HoMD4xaWtqA0ASinzui67MKOdt6yi9LUUHJOIBlFuj4=;
  b=jwajWa1cpvhbnpAvjCWc0piqaDa6K2pVT2jUoHkOvAQF2Q+FE20i6Lny
   Zpg3D8R0QInKERr19es6ZkBxAi74xnzBZAb8Qm7nUvQyLF+dlwJR+P4wM
   1wZ86dIjq4z5FzRFFj8qzGsxK2D9UbUWBbaWzpX4z50HgOpRI2oaJjK8o
   jkKqE/9M4y3esSz0GYbwihkdjtYOa4IIsHJeYX9mh+2pwEZsN/rZIC8PS
   EitpIGSURvNRxdIYKjENNvcc2yzNqxkdggocQ4NsAKu9ukvjjbG4mBH65
   VCO4BgtRXqQ+EexjSj0zP5Nph1bC/EbLs2AxWdo0Km1SItR52TK/hWQ9T
   Q==;
X-CSE-ConnectionGUID: tCnVBKotQFCR1k4BKDVCew==
X-CSE-MsgGUID: UizKlDdcQcSa5heunRifkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160929"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160929"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:59 -0700
X-CSE-ConnectionGUID: AgIF4EUESOuH8sWUu4VhbA==
X-CSE-MsgGUID: 9w253VmiQg6t2/IwJcL6Rg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 14/15] wifi: iwlwifi: mvm: fix a possible underflow
Date: Wed, 15 Jul 2026 21:57:14 +0300
Message-Id: <20260715215523.fbd989cc85e2.If68de403bfa4943732c025961154c20b01b09e83@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We shouldn't trust the firmware about the length of the wowlan packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 4eaba0bc4a1e..109265149963 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1509,6 +1509,10 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(truncated < 0))
 			truncated = 0;
 
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(pktsize < sizeof(*hdr)))
+			return;
+
 		if (ieee80211_is_data(hdr->frame_control)) {
 			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 			int ivlen = 0, icvlen = 4; /* also FCS */
@@ -1517,10 +1521,6 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 			if (!pkt)
 				goto report;
 
-			skb_put_data(pkt, pktdata, hdrlen);
-			pktdata += hdrlen;
-			pktsize -= hdrlen;
-
 			if (ieee80211_has_protected(hdr->frame_control)) {
 				/*
 				 * This is unlocked and using gtk_i(c)vlen,
@@ -1546,6 +1546,17 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 				truncated = 0;
 			}
 
+			if (IWL_FW_CHECK(mvm,
+					 pktsize <= hdrlen + ivlen + icvlen,
+					 "pktsize is too small %d\n",
+					 pktsize)) {
+				kfree_skb(pkt);
+				return;
+			}
+
+			skb_put_data(pkt, pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
 			pktsize -= ivlen + icvlen;
 			pktdata += ivlen;
 
-- 
2.34.1

