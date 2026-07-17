Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183D418A42
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298709; cv=none; b=HOvOlpcyDHkRufG8lbu4vOWpPLo6B0GAD3c53fa9b5cxJiBCBOqXTLGAyXoMH1WNFi01tSVud28NfbKJKFXYrDudvu8yykihavvu535g4O2WzTFEpzQZ3Piizb6i6E2Bx1JR9NbGiWnVhz3GmCwNV3/qlp0OFZHIsfO1Harp/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298709; c=relaxed/simple;
	bh=fxb/rDolbrWv2G1FIIUHNFAq9eaueRXykYUnhOogRxc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f2Lf0i4yHqsXwsDSsJLUiEjf8Q3g5LdlSXLFN4rfs7ttGfNln6zXmdeRQSweuMZp7lL9wX2VQ8yuce/VLKnYB7jJzt6sB/wI1FRn4r4ndDsQUQopJVS1rdJRyNSzLek1Gk8lGVC2oEj3Ij6cGXHWH+uGX4rnSfzl5FvkTbPsVT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTlJuhL0; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTlJuhL0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298708; x=1815834708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fxb/rDolbrWv2G1FIIUHNFAq9eaueRXykYUnhOogRxc=;
  b=TTlJuhL0najW/Dj5YfWfDZuPOJJA1LSCo1j6VtwapjBJwx8XG81HsGRw
   w5bNyHUPVD0PSHWlCT+iAgVWPN4UMaic0jsSEfN/iIj4O6QZ26hb7Q/Oo
   1f+8/lsIseY9h3VCc4bjW2Ea+0JLkgoLpewiIEkWpxJhY4vJQLYUUTM3d
   lVK9KHLbkZbB1irps2PsDq81RC016R1UVRU5d+aqkUKY6AduEprTld0FG
   6k6nsYRHFdf1NVDWGvQb0fF6Uorq9uKqGtDV8cIyy2aWyX1h15yZ2Necx
   wBtQdH1pX0tFVWjBxFdKbYJgW12fgOlVIhPd4tMqntZgxYc00YildS8Nm
   g==;
X-CSE-ConnectionGUID: ZqFRWSzwQoWznDoYz8VYAA==
X-CSE-MsgGUID: EpzQZsEwTe67juDzWkRb/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84926013"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84926013"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:48 -0700
X-CSE-ConnectionGUID: Wfv/Fz73QT6XeUKMX3LIUA==
X-CSE-MsgGUID: 9pp2+PQrSny7fBVFL8lDCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885752"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 8/8] wifi: iwlwifi: mld: move BIOS reading code to where it belongs
Date: Fri, 17 Jul 2026 17:31:12 +0300
Message-Id: <20260717172958.b19a33e0b507.I73f6b5e6a81d0f411f12589ceb30afa655c0a16b@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

We have a dedicated function to fetch all the BIOS tables when the opmode
starts, and yet we read a couple of tables directly from
iwl_op_mode_mld_start, which is already a large function that does
multiple things.
Move the reading of the sgom, puncturing, and RFI enablement to the
dedicated iwl_mld_get_bios_tables.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c        | 2 --
 drivers/net/wireless/intel/iwlwifi/mld/regulatory.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 7c49d0441fdf..6e991fb99ff3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -419,8 +419,6 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	iwl_mld_construct_fw_runtime(mld, trans, fw, dbgfs_dir);
 
 	iwl_mld_get_bios_tables(mld);
-	iwl_uefi_get_sgom_table(trans, &mld->fwrt);
-	iwl_uefi_get_puncturing(&mld->fwrt);
 
 	iwl_mld_hw_set_regulatory(mld);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index be311f6c3d9f..ad899ce5c64a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -84,6 +84,9 @@ void iwl_mld_get_bios_tables(struct iwl_mld *mld)
 	iwl_uefi_get_uneb_table(mld->trans, &mld->fwrt);
 
 	iwl_bios_get_phy_filters(&mld->fwrt);
+
+	iwl_uefi_get_sgom_table(mld->trans, &mld->fwrt);
+	iwl_uefi_get_puncturing(&mld->fwrt);
 }
 
 static int iwl_mld_geo_sar_init(struct iwl_mld *mld)
-- 
2.34.1

