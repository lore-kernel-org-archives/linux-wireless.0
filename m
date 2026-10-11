Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623C432313
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716740; cv=none; b=nv/5UqFXH/n+9lZ023684aPaKsSNrYbyXwDnMnZQ4IoIqszQtOEyr6rVcaSUM8+o2BhLduJoKZjkcgESc6j5ehJSVhYzO4eOvY3VawlOT+7Q2/YwrUoegfP2YNvvHkkHyV46indDj2U4i+gsBPN+JdsoEkVT3tvlGbqWrLqYl0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716740; c=relaxed/simple;
	bh=6G4HYK46mC72OSWawl0Jhft3UyRSvepwthRsbOCdrlE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=On/48w9F3d3dUIwM26Ixb/ZpcZsdPMjuaMuljuy+t39zs+XyVWP2SDBzUK+WS/+KE8y94ZOH0afdNHAy9SDTYLYiaGWMlWdiDYgjLCWmrQ2jPDodOikSUIAfGmmNzuGTqO++wvGKwM7elXWwWwz89+tfBkNxDEYJziZ7IxeDj64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PvYfKyz5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PvYfKyz5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716739; x=1823252739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6G4HYK46mC72OSWawl0Jhft3UyRSvepwthRsbOCdrlE=;
  b=PvYfKyz5VERmouU6Z+ZUc7kgPVYDCFDRwk9zUFnX8L6B8S0poGVeyBpX
   z00zIbrpWS9yoQBLvzbJjUP6BNipY+pb8FSWJTf1/9k2LKIHymgYu7hJ1
   JukU4zPK9HIZB/yhZJHaDaPIw9/KKsVaWqkFMRr3fybmDqNI493SuEHtq
   rJC4U4ClJHkb5EhZFzST5zi1iExjvQYbXWZVf/co2dxQvKVPfZfGAcjIJ
   OmFT8c0wO68wulpkC1tDwdWVhsnNpDbs1sJeKzhDF8REHwqF1VlK9ur68
   drM/n0xs0RNiClqg+LFzatEYPAACFcfSASO2OfHle4VK3QIyudJD5EcDU
   A==;
X-CSE-ConnectionGUID: hN1uYutRQc2LifhKNbgkXg==
X-CSE-MsgGUID: jiM1W0yDSqeQH6yXECkSrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454187"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454187"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:39 -0700
X-CSE-ConnectionGUID: 7Rhu4D/7TT6fBabjci+3kA==
X-CSE-MsgGUID: JZ0KTPGMQgWuRneC7vtc1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651039"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:37 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 13/13] wifi: iwlwifi: trans: remove the unused write8 operation
Date: Sun, 11 Oct 2026 14:07:14 +0300
Message-Id: <20261011140453.fecac6ba37d1.Icf8e741c8ccc6eff1abd046223b575c07f69aff5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Unlike the other bus operations, write8 has no generic wrapper and is
never dispatched through trans->ops: all the callers are in the pcie
code and call iwl_trans_pcie_write8() directly. Remove it.

Assisted-by: LLM
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h  | 2 --
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 5db07f1eab56..7a358daab584 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1237,7 +1237,6 @@ void iwl_trans_fw_reset_handshake(struct iwl_trans *trans);
  * @send_cmd: send a host command to the firmware
  * @alloc_tx_cmd: allocate a device TX command
  * @free_tx_cmd: free a device TX command
- * @write8: write a byte to a device register
  * @write32: write a dword to a device register
  * @read32: read a dword from a device register
  * @read_prph: read a peripheral register
@@ -1291,7 +1290,6 @@ struct iwl_trans_ops {
 	void (*free_tx_cmd)(struct iwl_trans *trans,
 			    struct iwl_device_tx_cmd *dev_cmd);
 
-	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
 	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 	u32 (*read_prph)(struct iwl_trans *trans, u32 ofs);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bd6e38d5f631..0f4e309fe32b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3704,7 +3704,6 @@ const struct iwl_trans_ops iwl_trans_pcie_ops = {
 	.alloc_tx_cmd = iwl_pcie_alloc_tx_cmd,
 	.free_tx_cmd = iwl_pcie_free_tx_cmd,
 
-	.write8 = iwl_trans_pcie_write8,
 	.write32 = iwl_trans_pcie_write32,
 	.read32 = iwl_trans_pcie_read32,
 	.read_prph = iwl_trans_pcie_read_prph,
-- 
2.34.1

