Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E803B47E1
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759005; cv=none; b=XShTaxxvGq2d1aySziYruhBpHjwVdDpYTw/cRS7Gk6u41oDxOQnB4LqKHwgvr32RpxJ8z/e8bsAzcLCVskbhTdL/TcHG6aXZT6Sbuhngi7qPdpyxMaAMO7RNSJ6offyAZRUXI4bV4/0ecAzh3+ow/IlVKkixIQxD4f2vL14escE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759005; c=relaxed/simple;
	bh=lzG1B8JkumQhMMcqRC85E4tpIbI1G9NwFtIC2hJHWmo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jdQB9EhqUOpqSai04F80De68elTw1sfjOJ4kvnLM4GjJ2E0K8nonMM/gbWY4eHAN0Ll4bJxdKTeOPRFo11Jn1uHofRDPOm/7TXC8WwWCfGynobS1Q2qG9oDIf1XinttF75gSjVhKjPTiEatNciDQ6jr9VNp/qkLB1OpUkMHfQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AM3O1ni3; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AM3O1ni3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759004; x=1822295004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lzG1B8JkumQhMMcqRC85E4tpIbI1G9NwFtIC2hJHWmo=;
  b=AM3O1ni3ol8RcWBA5ixB/jZZ4Goy59OX6aCZYxoQdCCb6CzIhveXXUY5
   NJabGkYdBOVoBwLIcxIJNxNFl21iD9Mzqbu+pIv6x5xPuHTdUgJXupgYv
   Wz9VMCdCUVeFVeCYz7Wyc8Xo6rgokz238Y5CcZMnXeNJRT4Ah235AJQVZ
   bvkRZ0mdnBWuX/phWxNqZhnGni98u6vqXIb9jCAF/irUz4LG1dDl33lVC
   +LO0sKbjMgtfi2wXF8DoBSC/tSoV6bAPVwCGeV28DIMiEd1F/Zoy1JlK4
   MTlTIlsagrYNlFucMoo+3zlGkOroIzPI263G7M2r2rhW9Vd+3DBvVXwB1
   A==;
X-CSE-ConnectionGUID: yXYJEEQQQ5WapTszp9B8AQ==
X-CSE-MsgGUID: MT4/xckJTgGy4p6/kn5/NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="93978375"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="93978375"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:03:23 -0700
X-CSE-ConnectionGUID: +W6ZyE9XQomseRFRZQkirA==
X-CSE-MsgGUID: 0oQ6F765TCW2fzqd2Nr9DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="273724538"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:03:21 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: set SP in reg connectivity with any channel
Date: Wed, 30 Sep 2026 12:05:18 +0300
Message-Id: <20260930120507.2ba7e2905019.I6d589cf60434ba9d3e007fe4537c8c8e2aeb7415@changeid>
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

The regulatory connectivity element is informational and for
debug, per spec, but that didn't stop some situations/tests
from requiring certain bits to be set, notably the SP bit to
be set if any channel is available for AFC client behaviour,
even if that seems to reduce the utility of the bit.

Set the bit accordingly by initialising the flags to NO_AFC
and then masking for all enabled channels.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9e1749d2e427..44feb80274c6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2731,13 +2731,13 @@ int ieee80211_put_he_cap(struct sk_buff *skb,
 void ieee80211_put_reg_conn(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb)
 {
+	u32 flags = IEEE80211_CHAN_NO_6GHZ_AFC_CLIENT;
 	struct ieee80211_local *local = sdata->local;
 	u8 reg_conn = IEEE80211_REG_CONN_LPI_VALID |
 		      IEEE80211_REG_CONN_LPI_VALUE |
 		      IEEE80211_REG_CONN_SP_VALID;
 	struct ieee80211_supported_band *sband;
 	bool available_channels = false;
-	u32 flags = 0;
 	int i;
 
 	sband = local->hw.wiphy->bands[NL80211_BAND_6GHZ];
@@ -2747,7 +2747,7 @@ void ieee80211_put_reg_conn(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < sband->n_channels; i++) {
 		if (sband->channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
-		flags |= sband->channels[i].flags;
+		flags &= sband->channels[i].flags;
 		available_channels = true;
 	}
 
-- 
2.34.1

