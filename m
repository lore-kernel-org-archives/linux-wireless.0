Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B137D10B
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2026 08:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994183; cv=none; b=YO4lQCuymXLCOK/CLRBrKhxgyqmuu86m6npkWn0a8Oo8mpg05FKidAfmjOKeE8OEea3jhxHwOtM63CtNHIzaI0QNJZwZdTxRjEfVXATCQ851jQ49Z97vXXrFJ4+K/8dZIzaU0Dfjw9wcL7sxDAV6sIafotNdq/yPWPjD3VSESXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994183; c=relaxed/simple;
	bh=yon2T/GowPrWFYoSyHWebX415jrOCuiccWaIEDuZjY8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DUeXTXIRZBgKxD441aYCkqY9XRvimzHpGZwObsL0K1KrJEq63fEt7i2jF7emYmsrmj7M+qiNdMfmKdXNfq2lSlkiKl7crhCsRn5e87TVS2Q1OtGyLgY715UAJ5awQrXat+iAmy/VSkx1RasLjXObWTTzAgTcERhTFOQZZt2pNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YvLQm2wY; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YvLQm2wY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773994182; x=1805530182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yon2T/GowPrWFYoSyHWebX415jrOCuiccWaIEDuZjY8=;
  b=YvLQm2wYF+hgnxe9vrdegUD1tDH3uHbZcFZHRiAMTGbzmRjqIKeLaj6P
   k6OdOG8e6mkRSJVLhwKoNc/PIqF/81hJdtxB1dsFx/MdBK7fQrAmIzuCN
   6NAGT2g6zJqnQ1v6I8VadTJZ++ZTrv7olniR/K7RlVGE/Nr19IfIm59R2
   6m9Tg7YA0VxF7Am1Oj04AByyfpcssgjBDEB82uGVGt8J/1X2TANa4WDIB
   114//xCn8K0O9e3Vf6Y25tB99sycuiZaMso+p4B4zIODz4PskJQCMl+/A
   JFoi4bzx6mN+9Y4vOtI4kwD1XCcaxhxd1yw4iyOfmXTPYYXCuXo8MNpNc
   g==;
X-CSE-ConnectionGUID: 2oeIKW89SPWmMpfhegSMcQ==
X-CSE-MsgGUID: 7pEHPR31QYGqRoEI/YKjQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="86154131"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="86154131"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:42 -0700
X-CSE-ConnectionGUID: vC6JX8QAQsubmzOOCjJUbw==
X-CSE-MsgGUID: mnNIcQw5TvmFvbeW65kuzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="227692588"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: mld: eliminate duplicate WIDE_ID in PPAG command handling
Date: Fri, 20 Mar 2026 10:09:11 +0200
Message-Id: <20260320100746.7b7e6315e2cc.Icffcc47ac1e876708b6219a89fd546a018797d44@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
References: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Extract the PER_PLATFORM_ANT_GAIN_CMD command ID into a local variable
to avoid duplicating WIDE_ID(PHY_OPS_GROUP, PER_PLATFORM_ANT_GAIN_CMD).

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/regulatory.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index 2486d78d6fc3..f91f61ca9b2e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -211,10 +211,8 @@ static int iwl_mld_ppag_send_cmd(struct iwl_mld *mld)
 		.v8.ppag_config_info.hdr.table_revision = fwrt->ppag_bios_rev,
 		.v8.ppag_config_info.value = cpu_to_le32(fwrt->ppag_flags),
 	};
-	int cmd_ver =
-		iwl_fw_lookup_cmd_ver(mld->fw,
-				      WIDE_ID(PHY_OPS_GROUP,
-					      PER_PLATFORM_ANT_GAIN_CMD), 1);
+	u32 cmd_id = WIDE_ID(PHY_OPS_GROUP, PER_PLATFORM_ANT_GAIN_CMD);
+	int cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, cmd_id, 1);
 	int cmd_len = sizeof(cmd.v8);
 	int ret;
 
@@ -271,9 +269,7 @@ static int iwl_mld_ppag_send_cmd(struct iwl_mld *mld)
 	}
 
 	IWL_DEBUG_RADIO(mld, "Sending PER_PLATFORM_ANT_GAIN_CMD\n");
-	ret = iwl_mld_send_cmd_pdu(mld, WIDE_ID(PHY_OPS_GROUP,
-						PER_PLATFORM_ANT_GAIN_CMD),
-				   &cmd, cmd_len);
+	ret = iwl_mld_send_cmd_pdu(mld, cmd_id, &cmd, cmd_len);
 	if (ret < 0)
 		IWL_ERR(mld, "failed to send PER_PLATFORM_ANT_GAIN_CMD (%d)\n",
 			ret);
-- 
2.34.1

