Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D145305676
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298864; cv=none; b=e1w8u3+ZkSyovWAw4RYkE57DvAvGNUBfMu/oNd6bGyPfrQHL+HPDo5q9nuUkhssvF0tQfrbbsS5iRdz8CRjIqpyN8S5Sf9wPpBvB3kQfaAhxqO9vzALr4xZ88YfkCpkKyoTyNuw9e3Et52lZJt3Oi6LBjjaXkw5lGQQWtWO2EVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298864; c=relaxed/simple;
	bh=YT2ongYJWPUgzQc/jxzto5Wn0mgmqObAvHUZCIYg4K8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l5Mmgu7SMErDUizUS9lAvJivQ7Msoah9yWqjkm3R2B2V5fKRseLrjfQtRrR+uicTrj+Jtx1gL9v+zICnuvmwGj/YzSCAOSRjJvvMzlIxS/Bkq6uGOIBIZBYKqQtzbVNB/iYhjSAaOCrERmsF4QqL4/hi1/Nwwp2TPyQzxz7/SVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JRKc2AAL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JRKc2AAL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298863; x=1815834863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YT2ongYJWPUgzQc/jxzto5Wn0mgmqObAvHUZCIYg4K8=;
  b=JRKc2AALf1fDAx/oImob3QxjMNj5ymWbdlhuiU3Ya5oOiis23p6pLUpi
   dvPYHmAJDdGQcuoZbfgRQEJkgB0l5pgpSOGUCjDemEgPfzIi+8shJyg4A
   LPLtUgjKKml1YfcgQxhq8ybzRBZNKTOVHE8LBJsjmzWjXoNugRTbUwVqa
   Og4T1GBfNRYAGKBECVXgBC5Xg+pwOT53COYt6tq+650iSugFc/bsPN8FG
   jpfDLE2qJdJ2oLaBMbsxFHo2rKksNuJsN5TL07aeqBZMEEeKbHsRIMTHq
   OffFL0rGvHtfmdNOpDerx2cmaIOhLgvxj6w4mCqk6W7D2o06DTb35ghW6
   A==;
X-CSE-ConnectionGUID: 4MWQWYyNQEudu86J792Ysg==
X-CSE-MsgGUID: s3jrVGANTuqvJkRhC/xTCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571422"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571422"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:10 -0700
X-CSE-ConnectionGUID: hM56EnXYSwWWrU8ysX/ouA==
X-CSE-MsgGUID: m6sityBjSZen89TVCDrrJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035097"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 5/5] wifi: iwlwifi: validate SEC_RT TLV minimum size
Date: Fri, 17 Jul 2026 17:33:40 +0300
Message-Id: <20260717173215.17b040b27edc.I6b32d1e9ad707417e2e604f08a63582456209372@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
References: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Reject firmware section TLVs that are shorter than the offset field
before subtracting sizeof(offset) from the section size.

This prevents size underflow for malformed TLVs.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 001895f4f4bd..7f1515dfc5bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -492,7 +492,7 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
  * Gets uCode section from tlv.
  */
 static int iwl_store_ucode_sec(struct fw_img_parsing *img,
-			       const void *data, int size)
+			       const void *data, size_t size)
 {
 	struct fw_sec *sec;
 	const struct fw_sec_parsing *sec_parse;
@@ -501,6 +501,9 @@ static int iwl_store_ucode_sec(struct fw_img_parsing *img,
 	if (WARN_ON(!img || !data))
 		return -EINVAL;
 
+	if (size < sizeof(sec_parse->offset))
+		return -EINVAL;
+
 	sec_parse = (const struct fw_sec_parsing *)data;
 
 	alloc_size = sizeof(*img->sec) * (img->sec_counter + 1);
-- 
2.34.1

