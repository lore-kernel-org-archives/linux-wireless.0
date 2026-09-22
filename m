Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756E5533590
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072886; cv=none; b=tgTrH0qau9CeyM26dpSV7M03YZeNWJ6pUfhQZbX2zPL2Ih3vF/ORrQQmW5A4VroMTwgjq7ZnuKqZYkMV9gCl6wjhxvpdsqGrr7F3arkClN94AnaInVP/XX6csmSGslu3T5VabAXu7JGE8/UC0ho9zSsRcks9IvrYFhCsDAljorw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072886; c=relaxed/simple;
	bh=yDS+RMz9XGsfpGb+FE/OvFRU3l828N3SZkspApEg+C4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lafW9N5Gjq+986zAtFcsopBK+noZ8OjPEvefaCyZiWjrQMQ1EH56XJ3ChLi1BLxpIQRm7wHvpEwJOGtuc0Mo26Tm1Cy3Zb6urN3PMDS4UYSo3TIzFirT13DvHubdNKj/R3UPevfUKdm+M4Jjd+Ipexc0GVK4p+dgmnc5vQoqyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X4phVwJD; arc=none smtp.client-ip=192.198.163.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4phVwJD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790072884; x=1821608884;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yDS+RMz9XGsfpGb+FE/OvFRU3l828N3SZkspApEg+C4=;
  b=X4phVwJDSO1YKjTnBjkqiyVVDYhdNMjvaowT5wNnp/D2Txwy2e1g8aoz
   rBaMR2yIylxC3x8Ru2R+ertB/sX/Y7o8cUt0Y4vWkW8fAZtS8KRaVNgDu
   kFuBTKmk6u2iFrhUMCNxkbzyz7661Z2iLtWAIOX9aYy8Bui/POybPncQ/
   9XwnYntLs35xsfj9LzO6qTysLacxtaLTJWtsvuyVTgAFv38yXGIu8j6zl
   fhFgHxUF8cuId7Ka1IhmkbtojttSHLYI0QACP0FM0vU3iTuvirIuBm0Fy
   f+qEIFbr8gmj5JJRQ8sS44pdfxKx/9DYpzsSyHwrp3v3B/XliJK/BopTp
   g==;
X-CSE-ConnectionGUID: /ErxksHoThe76raFhDl0AA==
X-CSE-MsgGUID: R8iCwuHyTpmzXvqPVJFomw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="1165319"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="1165319"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:28:03 -0700
X-CSE-ConnectionGUID: XAco8Iw/T4G+xZBx5dHfrg==
X-CSE-MsgGUID: YhPMoov3QSCNf6TgJE59Kg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:28:02 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 wireless-next] wifi: cfg80211: require zero terminator in valid_regdb country table
Date: Tue, 22 Sep 2026 13:30:01 +0300
Message-Id: <20260922132954.3d75b1440a1b.Ib92fa3a47e4cd5109c6139e9a4aac85c50f9be22@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

valid_regdb() walks the regulatory.db country table and returns
true as soon as either:
- a zero coll_ptr entry (the required terminator) is found, or
- the next country entry would no longer fit in the buffer.

The second case silently accepts a database image whose country
table reaches the end of the buffer without a zero-terminator.
The callers of valid_regdb() assume that every country is zero
terminated.

Exit immediately upon zero terminator, don't accept a database
without a zero terminator.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a8336baf85dc..f01b19075c58 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -820,13 +820,13 @@ static bool valid_regdb(const u8 *data, unsigned int size)
 	country = &hdr->country[0];
 	while ((u8 *)(country + 1) <= data + size) {
 		if (!country->coll_ptr)
-			break;
+			return true;
 		if (!valid_country(data, size, country))
 			return false;
 		country++;
 	}
 
-	return true;
+	return false;
 }
 
 static void set_wmm_rule(const struct fwdb_header *db,
-- 
2.34.1

