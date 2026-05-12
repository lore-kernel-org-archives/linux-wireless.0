Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BE82D0606
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 05:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563403; cv=none; b=fKiAhvmXain9/NgrjNpiRjfZuzwA+iNUbwX6kgQ82oa142JRtDxN/NFUE/SZVNkRKZFY9fFPOYWSo833M0um5TqDTp4YDfng/APTXrgPW+BxW51VYIkhAPz5WXmMJiRzm52u4pKjs4eaQ4/7QoVu9sRpOv5FhCHCc4AUd4jzFXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563403; c=relaxed/simple;
	bh=UWwBfn1Dxw4WchI94uKNZVpKfSy5AVbPCQLfrXwTJdk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=df0+8qMR8EYXrPYqpHUCqV2iB0pg/PUHu+HFxjmsUMMEKBf9jEIzTNep5r4uUOXkteP8QGUuNl1fpif+AnZWn2Ik+wUvfnVXMLhkJDkzpo6jDI70O5WjMYiL5GXaNeiPDbRnFzJ35ON3amuZHMCdLeoSLPZ757p3fOBMN4EprRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jpp43Alv; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jpp43Alv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778563402; x=1810099402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UWwBfn1Dxw4WchI94uKNZVpKfSy5AVbPCQLfrXwTJdk=;
  b=Jpp43Alv6zsxETzjLJHoejQar01mhO/U36LtlaJX5TvoX4C6kQinlBJd
   xx1Vyi54UvdbS7WJgExpdT3x8bL3uBQyy6zJPCYk8rf3csgj8fyGAGlgn
   +b7lIZuuvFKewpEPCYkuWVIfisKVYiyNk3d2gBJiao5yJUKLy31x7x4T3
   GAk9b2itDdIp2dAJbyopGB6jRki4wimVT0557s/Bz6M/KgvloMxvZI3kC
   BEfhP4JHitTgs7hEIIILbNGQr48NCfVMLm+yZ1aH4diKwOru9zczwjuaK
   +PlmZOj1weOPoK+hNhCnsSCUKBfdfnvppTn7eBbinqvqtyBWr4dIP/FIX
   g==;
X-CSE-ConnectionGUID: x1zSmFxFSGSbxGdZLjQbiw==
X-CSE-MsgGUID: +gzIzmMLRe+gjjQDD+vrHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="78495085"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="78495085"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:22 -0700
X-CSE-ConnectionGUID: EjHmZ2URR+eR9nk7uw+iFw==
X-CSE-MsgGUID: wO6zcYb8Sa6G32SgIU5GWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="233187466"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jeremy Compostella <jeremy.compostella@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: pcie: fix ACPI DSM check
Date: Tue, 12 May 2026 08:22:53 +0300
Message-Id: <20260512082114.81c4022ae602.Id3f575944ee6b87634cfb976d7334eac227d18a6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
References: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The acpi_check_dsm() function expects a bitmap of function
IDs to check for, not a single value. Evidently, on many
platforms function 1 exists so checking for 2 succeeded,
but it's wrong, we need to check correctly for function 2.
Fix that.

Fixes: 9673c35486d4 ("wifi: iwlwifi: implement product reset for TOP errors")
Reported-by: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 377b2e30b540..9f4c99dca195 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -2044,7 +2044,7 @@ iwl_trans_pcie_call_prod_reset_dsm(struct pci_dev *pdev, u16 cmd, u16 value)
 						 0xDD, 0x26, 0xB5, 0xFD);
 
 	if (!acpi_check_dsm(ACPI_HANDLE(&pdev->dev), &dsm_guid, ACPI_DSM_REV,
-			    DSM_INTERNAL_FUNC_PRODUCT_RESET))
+			    BIT(DSM_INTERNAL_FUNC_PRODUCT_RESET)))
 		return ERR_PTR(-ENODEV);
 
 	return iwl_acpi_get_dsm_object(&pdev->dev, ACPI_DSM_REV,
-- 
2.34.1

