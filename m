Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262E9329E55
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168590; cv=none; b=Z/s9OZ07y+Gkpa/QCWuzMJSIQiYq5lE5PRiT3iNMFSx/zoWSRwZEfTmjDj7T9nZkRx5v66krsPUmoDNlbEjuGY6a/CINyn9rjwWJVt8mpzZE4E/MVLH7yE9UYHamCHi+zaUf9zn7Z8+/Lak6wnr5Vfg18rJutdoE2ZBMzaRpbVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168590; c=relaxed/simple;
	bh=3sLHEDNBYyD0eaMWG47Gnn+UH3D8f1+VU2HvFXf60fM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZVj7WBloeiW25X+miMkdpVUTa+6nUVvRxB94GRm0XZEHURL2dcF5elmX6V2+1gI03hxuvcKgroBlnk63Gk48yS1Sx1KE4lVYLUJEtNytpSHFJlShuHS9QJDb15AYFGQs+LTESmWUDtzUYRoi9Lg2hB+xlHKDX+TWG2iqzEycKyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bjjvcHle; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bjjvcHle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168588; x=1821704588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3sLHEDNBYyD0eaMWG47Gnn+UH3D8f1+VU2HvFXf60fM=;
  b=bjjvcHle1RvpELal7GzeQrlHiT+pmhf2J/DnzpVliPp9e77tFAlG6pZt
   jBIXVuy1qbC5s8OtmNdbLuQOupd5SdKKNZ7X0I21YlQ2ih2ucbuxrMSqQ
   YBkcA3KDGq+WiSkUS30Gj0imWxF5y3qq8DYJ+iA42GVBvigM/6xuWNA1K
   3GrbpU+ATTrRdcXlbC2PePcihBfMwWM+kxtC3q6aAgU1qkqkRguoE5FZD
   FRTrd6huonff8oS4cAKkc5fZmZebjktY7KadlJfGj1hLt7iQUNPnGPtXU
   XpdIpcygvu9UccXbVPKXGvEJ4LYd9ZZA6iEmz9Gdbx+jR0XvZfkCrx5+l
   w==;
X-CSE-ConnectionGUID: t6ynkLp0S52BrEVOPIvr8w==
X-CSE-MsgGUID: o8TVdhBDSuC/C6gaU9DGrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781319"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781319"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
X-CSE-ConnectionGUID: 1+FzbpBHSr6yWnAXYqmLlw==
X-CSE-MsgGUID: ePJjsnMDTQGw+jguehmEWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4696991"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:01 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mvm: remove indirection_tbl debugfs entry
Date: Wed, 23 Sep 2026 16:04:44 +0300
Message-Id: <20260923160318.bc19cf5a20b9.I04cbf6a929070775a7e0cb04c7330421e6777f4e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The RSS indirection table debugfs knob is not used, and its pattern
repetition logic triggered a static analysis out-of-bounds report on
the trailing copy that forms a one-past-the-end pointer.  Rather than
reworking unused code, drop the entry entirely.

Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 50 -------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index b7315598d522..99fb149b8543 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1145,53 +1145,6 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
-					       char *buf, size_t count,
-					       loff_t *ppos)
-{
-	struct iwl_rss_config_cmd cmd = {
-		.flags = cpu_to_le32(IWL_RSS_ENABLE),
-		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
-			     IWL_RSS_HASH_TYPE_IPV4_UDP |
-			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
-			     IWL_RSS_HASH_TYPE_IPV6_TCP |
-			     IWL_RSS_HASH_TYPE_IPV6_UDP |
-			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
-	};
-	int ret, i, num_repeats, nbytes = count / 2;
-
-	ret = hex2bin(cmd.indirection_table, buf, nbytes);
-	if (ret)
-		return ret;
-
-	/*
-	 * The input is the redirection table, partial or full.
-	 * Repeat the pattern if needed.
-	 * For example, input of 01020F will be repeated 42 times,
-	 * indirecting RSS hash results to queues 1, 2, 15 (skipping
-	 * queues 3 - 14).
-	 */
-	num_repeats = ARRAY_SIZE(cmd.indirection_table) / nbytes;
-	for (i = 1; i < num_repeats; i++)
-		memcpy(&cmd.indirection_table[i * nbytes],
-		       cmd.indirection_table, nbytes);
-	/* handle cut in the middle pattern for the last places */
-	memcpy(&cmd.indirection_table[i * nbytes], cmd.indirection_table,
-	       ARRAY_SIZE(cmd.indirection_table) % nbytes);
-
-	netdev_rss_key_fill(cmd.secret_key, sizeof(cmd.secret_key));
-
-	mutex_lock(&mvm->mutex);
-	if (iwl_mvm_firmware_running(mvm))
-		ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0,
-					   sizeof(cmd), &cmd);
-	else
-		ret = 0;
-	mutex_unlock(&mvm->mutex);
-
-	return ret ?: count;
-}
-
 static ssize_t iwl_dbgfs_inject_packet_write(struct iwl_mvm *mvm,
 					     char *buf, size_t count,
 					     loff_t *ppos)
@@ -1866,8 +1819,6 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_clear, 64);
 MVM_DEBUGFS_WRITE_FILE_OPS(dbg_time_point, 64);
-MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl,
-			   (IWL_RSS_INDIRECTION_TABLE_SIZE * 2));
 MVM_DEBUGFS_WRITE_FILE_OPS(inject_packet, 512);
 MVM_DEBUGFS_WRITE_FILE_OPS(inject_beacon_ie, 512);
 MVM_DEBUGFS_WRITE_FILE_OPS(inject_beacon_ie_restore, 512);
@@ -2066,7 +2017,6 @@ void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_clear, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(dbg_time_point, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, 0200);
-	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(inject_beacon_ie, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(inject_beacon_ie_restore, mvm->debugfs_dir, 0200);
-- 
2.34.1

