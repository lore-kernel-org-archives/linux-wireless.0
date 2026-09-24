Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4356B470EA0
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246382; cv=none; b=RUJafdQgLymGLGll3JsAdTuiU1wTv0oQ+NX9oP5QmykoX2veVqijynn1+WwcSAfrf0oNhaShL493BOs644kLJR5WBQnuQF0TAJkm30PwOmcx6dnTjju2R7cZmywYhciBdGYy6BkbJv9oguOj2KU63oNblxSjJv0UoMOJyiih7xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246382; c=relaxed/simple;
	bh=Ketx6bY9gp013xQKeMnB/GQaKyR9L95/pJiSvFTbVmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fXKC8qbRVujZZ7PiGrAXPFPo98P+UOsNH8cQfbfZPQJZaTEwbd7j1cXZ39kAG5hHOheJVGwSx3JWLYhtaxuwSpwYprM1MiKopfmmazbW0uTR040ir3vpFs3fjWXSofowNiWvHyMCCnrBOZHWG2U8Tm1p0hBhajvl1UKyKDVbGGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhhYeKt/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhhYeKt/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246381; x=1821782381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ketx6bY9gp013xQKeMnB/GQaKyR9L95/pJiSvFTbVmw=;
  b=UhhYeKt/VBcALV31V8OzcGcu8CUffGMH94LhU3GBK4U020FH7QtZWzIv
   aT0JqfOZwl1N3dPslsKgQkM4bBld7FuObVKnxXBPC7zF5NUKZM6jGVzy7
   t9kzdv28t0k7zAWlHTlHc2eIQhSskfAwpv4UTNxhmfAHyHG/j+3qMxZfk
   cwNWbjRTWHdM7kGgUPN9JEgSfG+st7PEt5lJpPyYtjS4dXSK08oFa9WEq
   kutj8g+KUAs+hz/e0Q8P1x4b8u83mCJtzfixhqvPPxJAH3w/4c9zdDPkd
   cFR+D1J2MS2k6z05b+Z5g3AcleJoIgU2Hiy/Jep0bDmnaWgQGzHTp8vw1
   Q==;
X-CSE-ConnectionGUID: x5kmswxCR0CCHzB4OeiHAw==
X-CSE-MsgGUID: fo/UnX29Q/i4pXr/gEIwSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134879"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134879"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:41 -0700
X-CSE-ConnectionGUID: QCqGKQcRT+OK+fpEbNvUyw==
X-CSE-MsgGUID: Qw2uKfyqT/qnic9cQ8lxtQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: fw: harden UEFI reduced-power TLV parsing
Date: Thu, 24 Sep 2026 13:41:20 +0300
Message-Id: <20260924133942.31af40cc9eff.I570750f27d9530d4c76922d2699a272d9c60a0ab@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

UEFI reduced-power parsing advanced by ALIGN(tlv_len, 4) but
validated only tlv_len. When remaining bytes were between these
values, len could underflow and parsing could continue past the
buffer boundary.

Validate remaining bytes against the aligned length before
advancing in both TLV walkers. Also reject short PNVM_SKU TLVs
before reading sku_id fields.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 49 +++++++++++++++-----
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 86825318c543..dffd5e68f41d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -251,15 +251,24 @@ static int iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 	memset(pnvm_data, 0, sizeof(*pnvm_data));
 
 	while (len >= sizeof(*tlv)) {
-		u32 tlv_len, tlv_type;
+		u32 tlv_len, tlv_type, tlv_len_aligned;
 
 		len -= sizeof(*tlv);
 		tlv = (const void *)data;
 
 		tlv_len = le32_to_cpu(tlv->length);
 		tlv_type = le32_to_cpu(tlv->type);
+		tlv_len_aligned = ALIGN(tlv_len, 4);
 
-		if (len < tlv_len) {
+		/* Make sure ALIGN() did not overflow for a malformed TLV length. */
+		if (tlv_len_aligned < tlv_len) {
+			IWL_ERR(trans,
+				"TLV len overflows on alignment: %u\n",
+				tlv_len);
+			return -EINVAL;
+		}
+
+		if (len < tlv_len_aligned) {
 			IWL_ERR(trans, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
 			return -EINVAL;
@@ -278,13 +287,13 @@ static int iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 				     "New REDUCE_POWER section started, stop parsing.\n");
 			goto done;
 		default:
-			IWL_DEBUG_FW(trans, "Found TLV 0x%0x, len %d\n",
+			IWL_DEBUG_FW(trans, "Found TLV 0x%0x, len %u\n",
 				     tlv_type, tlv_len);
 			break;
 		}
 
-		len -= ALIGN(tlv_len, 4);
-		data += ALIGN(tlv_len, 4);
+		len -= tlv_len_aligned;
+		data += tlv_len_aligned;
 	}
 
 done:
@@ -305,15 +314,24 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 	IWL_DEBUG_FW(trans, "Parsing REDUCE_POWER data\n");
 
 	while (len >= sizeof(*tlv)) {
-		u32 tlv_len, tlv_type;
+		u32 tlv_len, tlv_type, tlv_len_aligned;
 
 		len -= sizeof(*tlv);
 		tlv = (const void *)data;
 
 		tlv_len = le32_to_cpu(tlv->length);
 		tlv_type = le32_to_cpu(tlv->type);
+		tlv_len_aligned = ALIGN(tlv_len, 4);
+
+		/* Make sure ALIGN() did not overflow for a malformed TLV length. */
+		if (tlv_len_aligned < tlv_len) {
+			IWL_ERR(trans,
+				"TLV len overflows on alignment: %u\n",
+				tlv_len);
+			return -EINVAL;
+		}
 
-		if (len < tlv_len) {
+		if (len < tlv_len_aligned) {
 			IWL_ERR(trans, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
 			return -EINVAL;
@@ -323,8 +341,15 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 			const struct iwl_sku_id *tlv_sku_id =
 				(const void *)(data + sizeof(*tlv));
 
+			if (tlv_len < sizeof(*tlv_sku_id)) {
+				IWL_ERR(trans,
+					"Invalid IWL_UCODE_TLV_PNVM_SKU len %u\n",
+					tlv_len);
+				return -EINVAL;
+			}
+
 			IWL_DEBUG_FW(trans,
-				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
+				     "Got IWL_UCODE_TLV_PNVM_SKU len %u\n",
 				     tlv_len);
 			if (tlv_len < sizeof(*tlv_sku_id)) {
 				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",
@@ -337,8 +362,8 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 				     le32_to_cpu(tlv_sku_id->data[1]),
 				     le32_to_cpu(tlv_sku_id->data[2]));
 
-			data += sizeof(*tlv) + ALIGN(tlv_len, 4);
-			len -= ALIGN(tlv_len, 4);
+			data += sizeof(*tlv) + tlv_len_aligned;
+			len -= tlv_len_aligned;
 
 			if (sku_id[0] == tlv_sku_id->data[0] &&
 			    sku_id[1] == tlv_sku_id->data[1] &&
@@ -352,8 +377,8 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 				IWL_DEBUG_FW(trans, "SKU ID didn't match!\n");
 			}
 		} else {
-			data += sizeof(*tlv) + ALIGN(tlv_len, 4);
-			len -= ALIGN(tlv_len, 4);
+			data += sizeof(*tlv) + tlv_len_aligned;
+			len -= tlv_len_aligned;
 		}
 	}
 
-- 
2.34.1

