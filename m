Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4153444BC91
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023186; cv=none; b=NqUQD+oTEHpEEd4P59DR3RMIqMvvXBhO3ML39+Wr5oNo3a2FkbgGfJVF3ySayhWNCIs7djTkI19r7L59pdM/J86oI7Y8tJtyQCObPo0fcCfsxRLyJCt4Yp3SIvf1BxHBiGUgj/ZozMUqPO7yh/+yR8HRk+F5iwb6BsdgColLnHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023186; c=relaxed/simple;
	bh=YLIhAo6Di7Ss7KgZhjGk1ctjOlxF4h2AP0P2LheJcbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JHizqZWEg+4SPfCKB+uuMgRo/iWt8nQxPKRb5wuPRLYOhe9x8Ax83l2HrCwCviIEsgJofF4Pc9eQsaqG5IfeoksESZ7Fzf4AotN+JaTE3j1k6thFijuTLH8SETW2Yrt6Ogd/eSPbBzQipitFtG7Oqtx6KLYX0If4APhC632cZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ncRaJ/PP; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ncRaJ/PP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023185; x=1821559185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YLIhAo6Di7Ss7KgZhjGk1ctjOlxF4h2AP0P2LheJcbs=;
  b=ncRaJ/PPzhcJi/+MTiELrXh/rQ2xfnfl/SybnA0g5U4m07ectsOo/Cn3
   U1rmAe6RStoU1dpXBRu8DMBAp3wbDZ0AJYonBgk7fxptB4Lb5FPhcM3Zr
   i0/7pYlfTzp9/GoNOf3jaKuo+n2Lg8h/GPn4LL9nMHLvJ+Znu18Vsfhe+
   pJ2RiafPk2o4o+/cuTraaq3KLK8z8+/iQR9Jm8WVbRWVGNgeI1jsua22r
   gVmo6fxFSLRAOWQEJkSTTmOiyUolrhP/715QPFQegiLAPZfbDzQNFzKZe
   kTX2hKPqC9zC3LBUsMGQ2vBscN7BiEJYWh0DfjpeQgXyNNK5NBw0IpcSA
   A==;
X-CSE-ConnectionGUID: J+nFxPXRQi2KHrdpENYFbw==
X-CSE-MsgGUID: pvPOsX/yRkOGmrG929PvXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128797"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128797"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:45 -0700
X-CSE-ConnectionGUID: /DvrOuVAS4yo3QS60AJ5Tg==
X-CSE-MsgGUID: 6onRvT/IQC6dPVg7QXdAhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762063"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:44 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: dbg: validate dram_alloc_id from debug TLV
Date: Mon, 21 Sep 2026 23:41:20 +0300
Message-Id: <20260921233730.4c896fab0bb7.I3296a5523ce58df085ea0867694ea157c00945bd@changeid>
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

iwl_dbg_tlv_alloc_region() did not validate reg->dram_alloc_id for
IWL_FW_INI_REGION_DRAM_BUFFER regions, and the DRAM monitor dump
consumers in fw/dbg.c used it directly to index the fw_mon_ini array.

Check that dram_alloc_id is in range at TLV parse time, and add bounds
checks in iwl_dump_ini_mon_dram_iter(), iwl_dump_ini_mon_dram_ranges()
and iwl_dump_ini_mon_dram_get_size() before accessing the array.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |  9 +++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a314fabbf06d..8c8d15ac71ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -344,6 +344,9 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 	struct iwl_dram_data *frag;
 	u32 alloc_id = le32_to_cpu(reg->dram_alloc_id);
 
+	if (WARN_ON_ONCE(alloc_id >= ARRAY_SIZE(fwrt->trans->dbg.fw_mon_ini)))
+		return -EINVAL;
+
 	frag = &fwrt->trans->dbg.fw_mon_ini[alloc_id].frags[idx];
 
 	range->dram_base_addr = cpu_to_le64(frag->physical);
@@ -957,6 +960,9 @@ iwl_dump_ini_mon_dram_ranges(struct iwl_fw_runtime *fwrt,
 	u32 ranges = 0, alloc_id = le32_to_cpu(reg->dram_alloc_id);
 	int i;
 
+	if (WARN_ON_ONCE(alloc_id >= ARRAY_SIZE(fwrt->trans->dbg.fw_mon_ini)))
+		return 0;
+
 	fw_mon = &fwrt->trans->dbg.fw_mon_ini[alloc_id];
 
 	for (i = 0; i < fw_mon->num_frags; i++) {
@@ -1085,6 +1091,9 @@ iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
 	u32 size = 0, alloc_id = le32_to_cpu(reg->dram_alloc_id);
 	int i;
 
+	if (WARN_ON_ONCE(alloc_id >= ARRAY_SIZE(fwrt->trans->dbg.fw_mon_ini)))
+		return 0;
+
 	fw_mon = &fwrt->trans->dbg.fw_mon_ini[alloc_id];
 
 	for (i = 0; i < fw_mon->num_frags; i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index bd2a9e4b4b5f..5576598cc6e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -229,6 +229,18 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
+	if (type == IWL_FW_INI_REGION_DRAM_BUFFER) {
+		u32 alloc_id = le32_to_cpu(reg->dram_alloc_id);
+
+		if (alloc_id <= IWL_FW_INI_ALLOCATION_INVALID ||
+		    alloc_id >= ARRAY_SIZE(trans->dbg.fw_mon_ini)) {
+			IWL_ERR(trans,
+				"WRT: Invalid dram_alloc_id %u for region %u\n",
+				alloc_id, id);
+			return -EINVAL;
+		}
+	}
+
 	if (type == IWL_FW_INI_REGION_INTERNAL_BUFFER) {
 		trans->dbg.imr_data.sram_addr =
 			le32_to_cpu(reg->internal_buffer.base_addr);
-- 
2.34.1

