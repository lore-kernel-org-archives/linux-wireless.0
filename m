Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D9F5275AB
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077708; cv=none; b=Ftg6WI8K1BSO85BmBCRbK6I0iruqjwitaR2YSSC4yTjLFBO5yKhLFnxKZCO0FWNe5In8uTAH99fyXIIiMatv+5Ww8CRsZpkPU0C5K6y+2Ge5YHVBT3Jl/6ZAbioYb171XpE3rNPRuQMDY+p1mSaxFv8sycincNpHesxEy3XlFgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077708; c=relaxed/simple;
	bh=egV3uApDWdYlBpGaTUBKG8Hos6SA2b+sNr5R0Nu7z+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WM4ldtHUO1JEdo8rClPGdQOzCXxp5nZP/Dg/xlu3R2pSCrMLCEmPcPOG2Uh4oESMDiiRvs/F1mIIKOz7Wio2c4DnmspwLHwS4Q4HP+ul98a08eh0ROUfR6bdE1TN3epkzN+xoYFfeI0zkjiXYI0Lb9EqU3/n3fPOOmZuoDNRBP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6AavGBM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6AavGBM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077707; x=1821613707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=egV3uApDWdYlBpGaTUBKG8Hos6SA2b+sNr5R0Nu7z+I=;
  b=m6AavGBMeLvjlFatUkxPX4g8yNCLFXCtAzhu8iYsBd9IfSs/v7+tgwgy
   UO3XmRfkWkd4PKtMZXYqNJoUYhfY6NKKZ1Az8nYdMipoeq7sa1XTEB0fu
   rQkz7nxwvSLBHyswgwoqDPzXZvJEChz1j+mdXOaK49JrTx4rRVVMobN3D
   uPWvUJenIAN68bCFAm3ieuQKWI5JnfQcXY6PKSDayRM3HF7qTX1r9SCeU
   QTG6lOuEJ8dENcfbZJ+jHrGQNoRWuCGBuW9r5Kh02962mXjUrzN42M9oV
   AuLTFuFc/EXMF1HZjYc7oPV/m4sxCNXDBX+9A08vR/qntOnN4Jc4Hw6NK
   A==;
X-CSE-ConnectionGUID: 6BsflKGxQXalFO/GbmmxuQ==
X-CSE-MsgGUID: YsYhR2xFQhmBENCl9wtA7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170564"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170564"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:24 -0700
X-CSE-ConnectionGUID: 4COb1GiHTTiMRAdeZqe2QQ==
X-CSE-MsgGUID: SYksNNsdTz+Iwb6Apy21TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275430"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: fw: fix dbg dest TLV size check by version
Date: Tue, 22 Sep 2026 14:50:01 +0300
Message-Id: <20260922144819.7eb8d71ff962.I81295f046c785da613331c6a619897ccf66007d6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Validate FW_DBG_DEST TLV size before using it:
Validate the version byte first, then check the length of each version
of the payload.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ef9d50ee3704..0982e60842b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1103,10 +1103,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			const struct iwl_fw_dbg_dest_tlv_v1 *dest_v1 = NULL;
 			u8 mon_mode;
 
+			if (tlv_len < sizeof(*pieces->dbg_dest_ver))
+				goto invalid_tlv_len;
+
 			pieces->dbg_dest_ver = (const u8 *)tlv_data;
 			if (*pieces->dbg_dest_ver == 1) {
+				if (tlv_len < sizeof(*dest))
+					goto invalid_tlv_len;
 				dest = (const void *)tlv_data;
 			} else if (*pieces->dbg_dest_ver == 0) {
+				if (tlv_len < sizeof(*dest_v1))
+					goto invalid_tlv_len;
 				dest_v1 = (const void *)tlv_data;
 			} else {
 				IWL_ERR(drv,
-- 
2.34.1

