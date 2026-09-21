Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1713448D1E
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023186; cv=none; b=d9ogzvHpu/gkPeS0JTNBaZgZJlAUshFH3TycVXRyNAbT91d9FJK9UW3x0UtxG2E9fQJ4W/PO8H+9gi03uJW2KSODaHGn9CbIEiuCMllDQ9ibAQmkN/fhEtVImHzMVmUy/9ggpCLSEvS9PvPZhljMGjiCLGq/dHrybNPO4XP1W4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023186; c=relaxed/simple;
	bh=/I1Emb6EhScArrnB32hsZ77MmvxJrudaOBco5TfbMR4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YW3u8BEbSM24e/B08utyWTV4hSzuhutRLQhRppZSdHgXIK881Qr19Z+1NQKMW8kRPdsdu94kOGthsKjA7MjAHMQsRZYKmIxir+mq059vJqqLxZA0lu7e9SkpKsZeitpe3BQXanSskWhjS1Y9zMZgDncZ5CLzLg4rmOlawt8kQuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FILxlGdZ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FILxlGdZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023184; x=1821559184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/I1Emb6EhScArrnB32hsZ77MmvxJrudaOBco5TfbMR4=;
  b=FILxlGdZUshJwuiww7O+kdLcpkdOJ4ZuK4g5l5xrozXfCqyoiHhnnpw4
   c6pqDc9PkMwfjbQSTc4Sp2AlS3h0w/5e3czE+bITW5JtYJKs94zKqcyrh
   TpjJZHoXulclzgBvTW396B0AiBc5s1p2t9ardOGIBSeyiDDw3PRQc+Hmy
   IJi9bNmZ1XHFlqzYLB/ejVGeGuvR9BioNYITLFdgLhH0qPoA4CJKr26t+
   rXqWRNfbBwfLK9AU1BiNMREafmR4/evyzhWMssrN5SCmQdRzoRwkRfnSc
   c2MT5ukKv43C5JwKBZv0PhqbbkAZU0LKhl+mlgo03PwD6MWUvckjfghBM
   w==;
X-CSE-ConnectionGUID: /EdNEsVPS9OAgxaMeyhPfA==
X-CSE-MsgGUID: gEUJCzTDQKKI7UVsClHz5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128793"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128793"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:43 -0700
X-CSE-ConnectionGUID: P1MF7wM3S+22bk74WS2nmw==
X-CSE-MsgGUID: x8yoQTnfQkWmdjLHCtfVfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762052"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:43 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: mvm: remove SRAM access through debugfs
Date: Mon, 21 Sep 2026 23:41:19 +0300
Message-Id: <20260921233730.60f5274c7116.Ieec87672d84763b599e2d322525f68acff63e701@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is not really secure and we won't really need on old devices
(driven by iwlmvm) anyway.
Just remove the code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 68 -------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 2 files changed, 69 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index e6b9896dc4ac..b7315598d522 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -153,72 +153,6 @@ static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos)
-{
-	struct iwl_mvm *mvm = file->private_data;
-	const struct fw_img *img;
-	unsigned int ofs, len;
-	size_t ret;
-	u8 *ptr;
-
-	if (!iwl_mvm_firmware_running(mvm))
-		return -EINVAL;
-
-	/* default is to dump the entire data segment */
-	img = &mvm->fw->img[mvm->fwrt.cur_fw_img];
-	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	len = img->sec[IWL_UCODE_SECTION_DATA].len;
-
-	if (mvm->dbgfs_sram_len) {
-		ofs = mvm->dbgfs_sram_offset;
-		len = mvm->dbgfs_sram_len;
-	}
-
-	ptr = kzalloc(len, GFP_KERNEL);
-	if (!ptr)
-		return -ENOMEM;
-
-	iwl_trans_read_mem_bytes(mvm->trans, ofs, ptr, len);
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, ptr, len);
-
-	kfree(ptr);
-
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_sram_write(struct iwl_mvm *mvm, char *buf,
-				    size_t count, loff_t *ppos)
-{
-	const struct fw_img *img;
-	u32 offset, len;
-	u32 img_offset, img_len;
-
-	if (!iwl_mvm_firmware_running(mvm))
-		return -EINVAL;
-
-	img = &mvm->fw->img[mvm->fwrt.cur_fw_img];
-	img_offset = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	img_len = img->sec[IWL_UCODE_SECTION_DATA].len;
-
-	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
-		if ((offset & 0x3) || (len & 0x3))
-			return -EINVAL;
-
-		if (offset + len > img_offset + img_len)
-			return -EINVAL;
-
-		mvm->dbgfs_sram_offset = offset;
-		mvm->dbgfs_sram_len = len;
-	} else {
-		mvm->dbgfs_sram_offset = 0;
-		mvm->dbgfs_sram_len = 0;
-	}
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_set_nic_temperature_read(struct file *file,
 						  char __user *user_buf,
 						  size_t count, loff_t *ppos)
@@ -1916,7 +1850,6 @@ MVM_DEBUGFS_WRITE_FILE_OPS(start_ctdp, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(force_ctkill, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(send_echo_cmd, 8);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram, 64);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(set_nic_temperature, 64);
 MVM_DEBUGFS_READ_FILE_OPS(nic_temp);
 MVM_DEBUGFS_READ_FILE_OPS(stations);
@@ -2114,7 +2047,6 @@ void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
 	spin_lock_init(&mvm->drv_stats_lock);
 
 	MVM_DEBUGFS_ADD_FILE(tx_flush, mvm->debugfs_dir, 0200);
-	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE(nic_temp, mvm->debugfs_dir, 0400);
 	MVM_DEBUGFS_ADD_FILE(ctdp_budget, mvm->debugfs_dir, 0400);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index fb1fc9c42280..ae2ee8771f16 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1053,7 +1053,6 @@ struct iwl_mvm {
 	 */
 	struct dentry *debugfs_dir;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	u32 dbgfs_sram_offset, dbgfs_sram_len;
 	u32 dbgfs_prph_reg_addr;
 	bool disable_power_off;
 	bool disable_power_off_d3;
-- 
2.34.1

