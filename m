Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3809448BAB
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023181; cv=none; b=tAH6+013saZMpO+JFOTdyI02jyVGdokwyIbK9pbEhWb0geo/HUHCAVgPCzAic7mwJupjyR0zlmn5j3i4mQFzhNLJKyhv7GWcUYwKvjuiqyIfWnGfXtORRPvdQYmOdiBOsDWB001+TaNt1CEr1bO9aoVtjFaBczhAR6fnBoyac6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023181; c=relaxed/simple;
	bh=4ZpwkT70E5yXbb5CxbFdIOuj6s+kf4ORRbBh8XFO6Hg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UDQNX+b6GH8TUWf8r5ZiVKOcXOUrixukpN4lT9vtGTCKJbHqVRbVe2PWSiPLkVNB7UNBO3a2gYt8vxwuPMENgtMNavtt70LU8qSC0oIm8o0rFbZf9giaLeuzylHex61xskXy1QpxSjBY37pRD5+YGZbv1a8HCvTHRZbIFt1PZ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gR1YQR9Y; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gR1YQR9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023180; x=1821559180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ZpwkT70E5yXbb5CxbFdIOuj6s+kf4ORRbBh8XFO6Hg=;
  b=gR1YQR9YJYdEXJ4ePHVvyaECmbN84OjaTd3ncZSiX2vlJNOjXeCfg278
   x/BpOLQMhZ//fOG+I3WWYOMUlPK5S2gri62dkH5cD+kGmPq0UxrT5tJ6g
   ORFXA3nr9VymBIZdbhMmnmgPWvVXEbBujmpfbrh07wQw7mpsBMfxCjkwl
   rrqkWCqPlEjL+jZuZ+FjwPxrspyw9+2eTwB+UcYCPT1K9z6MKCQnrVxRR
   I09p2DvauUf5hWA2zzua0ebfYLgZFJwO+Oe4MMF1I5Js0enNeameXnBZd
   3CvewDDwE1pFIkCDWM3Oi/cQuN7kkJmtd05X//J0rVoOZzUr/PpFYmCCe
   Q==;
X-CSE-ConnectionGUID: trbGmQOnS9m9/CiBCBsi2g==
X-CSE-MsgGUID: krTB73qLTEC06f6ed3/Qiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128780"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128780"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:39 -0700
X-CSE-ConnectionGUID: NNIXeNsYQA2Y9hT5Sgf+ww==
X-CSE-MsgGUID: jtU6HkmdQX2ECG7uvoLQjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762005"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: fw: fix integer overflow in INI dump size calc
Date: Mon, 21 Sep 2026 23:41:16 +0300
Message-Id: <20260921233730.0644f76cd8af.Id0d26b11fcdb33a5eff7824343caa6dc23385fd5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The INI debug dump get_size handlers compute the region size as
hdr_size + ranges * (size + sizeof(range)) using u32 arithmetic.
Both the per-range size and the number of ranges originate from
debug TLVs with no upper bound, so the multiplication and additions
can overflow u32. A small value passes the
size < sizeof(*header) check in iwl_dump_ini_mem_prep().

Add the size computation in each handler using
check_add_overflow()/check_mul_overflow() and return 0 when the
result would overflow. For the block handler the variable per-pair
sizes are summed with check_add_overflow() before computing size,
since that accumulation can overflow on its own.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4-8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 37 +++++++++++++++++----
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6621ef9358bc..a314fabbf06d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1016,8 +1016,16 @@ static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 	if (!size || !ranges)
 		return 0;
 
-	return sizeof(struct iwl_fw_ini_error_dump) + ranges *
-		(size + sizeof(struct iwl_fw_ini_error_dump_range));
+	if (check_add_overflow(size,
+			       (u32)sizeof(struct iwl_fw_ini_error_dump_range),
+			       &size) ||
+	    check_mul_overflow(ranges, size, &size) ||
+	    check_add_overflow(size,
+			       (u32)sizeof(struct iwl_fw_ini_error_dump),
+			       &size))
+		return 0;
+
+	return size;
 }
 
 static u32
@@ -1028,15 +1036,24 @@ iwl_dump_ini_mem_block_get_size(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_ini_addr_size *pairs = (void *)reg->addrs;
 	u32 ranges = iwl_dump_ini_mem_block_ranges(fwrt, reg_data);
 	u32 size = sizeof(struct iwl_fw_ini_error_dump);
+	u32 range_hdrs;
 	int range;
 
 	if (!ranges)
 		return 0;
 
 	for (range = 0; range < ranges; range++)
-		size += le32_to_cpu(pairs[range].size);
+		if (check_add_overflow(size, le32_to_cpu(pairs[range].size),
+				       &size))
+			return 0;
+
+	if (check_mul_overflow(ranges,
+			       (u32)sizeof(struct iwl_fw_ini_error_dump_range),
+			       &range_hdrs) ||
+	    check_add_overflow(size, range_hdrs, &size))
+		return 0;
 
-	return size + ranges * sizeof(struct iwl_fw_ini_error_dump_range);
+	return size;
 }
 
 static u32
@@ -1112,8 +1129,16 @@ static u32 iwl_dump_ini_mon_dbgi_get_size(struct iwl_fw_runtime *fwrt,
 	if (!size || !ranges)
 		return 0;
 
-	return sizeof(struct iwl_fw_ini_monitor_dump) + ranges *
-		(size + sizeof(struct iwl_fw_ini_error_dump_range));
+	if (check_add_overflow(size,
+			       (u32)sizeof(struct iwl_fw_ini_error_dump_range),
+			       &size) ||
+	    check_mul_overflow(ranges, size, &size) ||
+	    check_add_overflow(size,
+			       (u32)sizeof(struct iwl_fw_ini_monitor_dump),
+			       &size))
+		return 0;
+
+	return size;
 }
 
 static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
-- 
2.34.1

