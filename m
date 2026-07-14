Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDBF363C60
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028029; cv=none; b=ASTVVymfkJLJU2m7xpPQqz0/azC7/pRv+xy5FJpptWnhRdNvrJs8+wcdpIlHvpFu0P4KvYxQ2dgVUEMlfnJzL4J4aYrsQd9DvrxxJ1sjT2OLt9+eMhSwlOaAmFTela+bDhNrOi9DqSsv14KynkEq0l0LgntDez7WLuGWrE2589M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028029; c=relaxed/simple;
	bh=gVN6LVlUqxXkVuOtlsdBv2JBxzGKYZjE5+chX9X6Fng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KDTHviQIcBgJfiVcrRhBRYBNDtx160RuVWVF9xl/4l7P7d+1rlod3F9yOIYY/nSaC+WGiP32aPNeBRR5SGjKwSEiTpcDSSu+z7CK9zO0yn0iGbiGBukosxY+pKWDhFppyK/64V+YCKKg2r8+0LKJQRsDwcB6vzxD0nyUnYpdpcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kLzmNmdE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kLzmNmdE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028027; x=1815564027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVN6LVlUqxXkVuOtlsdBv2JBxzGKYZjE5+chX9X6Fng=;
  b=kLzmNmdEZBBVhxkhYSyoflv4eTKj67pabZwB+oc5tbD9289eoCjTZ24o
   566olnyf5pGElwtmEJtqpbqdYL9lzBtWnncw4flf//jprVBWuffBS9d0N
   spvNXxHfaYH9RGI/iA0xiO7thHXslFdN5VL1UzlvDVZtYvaupiw90VLhs
   ZKN/m5wAEzrUlaV0Gg6as7WK/PUwpftB4AjU1zkg6DzFzP4gioJ9ZNTR5
   vU0hcsLoTqQVTraTu/Wr2zO2rueeB8EgBdF2XvSN6RCM/nYLqmZGu8NkM
   Mhps4+ka1tDRneVQPFYLn5cIls/iFoj/2wZrM3SB+vjWekBddj0BOrD3s
   Q==;
X-CSE-ConnectionGUID: HXYjtcJsR4id9TIJaM61dw==
X-CSE-MsgGUID: 23p/WRwQTT+yhl/AX81MzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200295"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200295"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:27 -0700
X-CSE-ConnectionGUID: eBXcW3InTwS/3gBmaB3lgQ==
X-CSE-MsgGUID: 1sHPFU8FQ8W9gOXgICFhpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250146"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:26 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-fixes 02/15] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Tue, 14 Jul 2026 14:19:51 +0300
Message-Id: <20260714141909.d22bf52a18d0.If0ef6612a67cca671428b06dbdeec68549e50ae6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
References: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Before looking at the 11th byte, check the length is big enough.

Fixes: 4f58121dc40a ("iwlwifi: mvm: Block 26-tone RU OFDMA transmissions")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 74bd4038fd56..48cc10db7b96 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3490,7 +3490,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.34.1

