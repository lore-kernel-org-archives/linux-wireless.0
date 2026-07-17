Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2793FB7DE
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298847; cv=none; b=FSjKgv9fQV0/on5nrNUkoW1dRXYX+M8mEbxaqBMOKC5SH3zOtwLsswL0kjnaqE1/Bua40tb2h/VN4dPge9qUK+aHNqlEmhdvyyhyhes3BkdqyABpx62s5atiqASNCQr9SXU0MmevZ3hih5l58+1FhLT7SrUYCSVV/uuGTVg/FQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298847; c=relaxed/simple;
	bh=b2jc8rZsmFoYw9VrzllVXEFJb0MNG3GtWEE+K89MEqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rRExTnjaZrnjrlN99hV2kaMcte5ygtq1bvkoBqnkwmcz7eETmVvMsuivXuK5xdbdE/BuoZLGZ6YpYYM2uY5E2q9T7kenj6bkCJ/RmnBA84N9Cra6f+xt0zBp5lKfl25AUOWqcGxHN4WiJYckoLVThdCQIcr6a4g8yosxqlL6UR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTN8OnhP; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTN8OnhP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298846; x=1815834846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b2jc8rZsmFoYw9VrzllVXEFJb0MNG3GtWEE+K89MEqs=;
  b=LTN8OnhP5nk1jLPX1BBWoq2sJwFdYABEykKgaWUN/xmNXkqaay9ucEJM
   dD37WBIA27aIW2HXFs3RerPhnCuJshqLEdYezSNIhQ/SJ6/Gwv3XuT03E
   yn9PgZIC+vCCtE0sr0rXlOaq8j1isFXaNNk9ZyrNAbQe28Wwd6iYnRev+
   Jq2up/OmTmXbGk2sXkerCtbCwVbS+sx8M16fiFqiml9amTyYiEwJy3r7N
   4zabdFECVuagFaCvMIwmmDB0BAfrbmE8+ImfRWxByvu8g/JctYcdVIaDv
   pic0JQYnkdzhne2oEWT2iSrFfWzFeUSNFM6B4MQjCzhrcOJX3qDNijkwi
   w==;
X-CSE-ConnectionGUID: aftfGGRqR/OgbVKtQl1KAw==
X-CSE-MsgGUID: WF+NJtWQRoazo0khyMxQwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571410"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571410"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:06 -0700
X-CSE-ConnectionGUID: Kp3WYJWfQIq5yDc3emdvOw==
X-CSE-MsgGUID: EKAodU+zRy2ZTV2xrMfOgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035086"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:04 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 2/5] wifi: iwlwifi: dbg-tlv: bound aligned TLV walk length
Date: Fri, 17 Jul 2026 17:33:37 +0300
Message-Id: <20260717173215.e08d6550c6ec.Iad64190a7d5cded553aff41973120396aef1b557@changeid>
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

Validate ALIGN(tlv_len, 4) before advancing through external debug
TLVs to prevent parser length underflow.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index d021b24d04d6..b1a55909f0d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -475,6 +475,7 @@ static int iwl_dbg_tlv_parse_bin(struct iwl_trans *trans, const u8 *data,
 {
 	const struct iwl_ucode_tlv *tlv;
 	u32 tlv_len;
+	size_t aligned_tlv_len;
 
 	while (len >= sizeof(*tlv)) {
 		len -= sizeof(*tlv);
@@ -487,8 +488,16 @@ static int iwl_dbg_tlv_parse_bin(struct iwl_trans *trans, const u8 *data,
 				len, tlv_len);
 			return -EINVAL;
 		}
-		len -= ALIGN(tlv_len, 4);
-		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		aligned_tlv_len = ALIGN(tlv_len, 4);
+		if (len < aligned_tlv_len) {
+			IWL_ERR(trans, "invalid aligned TLV len: %zd/%zu\n",
+				len, aligned_tlv_len);
+			return -EINVAL;
+		}
+
+		len -= aligned_tlv_len;
+		data += sizeof(*tlv) + aligned_tlv_len;
 
 		iwl_dbg_tlv_alloc(trans, tlv, true);
 	}
-- 
2.34.1

