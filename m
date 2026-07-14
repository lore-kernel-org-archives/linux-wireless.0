Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1443647B425
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037768; cv=none; b=Qj1WhV+sYVWuiLjgOX84jyuLxBrE6nPbpdta4yTNYSMgBydS/in8MGGXvLGilSfpR22QTxsjFNuniRHYH16fzHsvN8VqzdjljUR9d27tDf4yLZP4MDYAIcs+vSXy7F6VhLOjZmKfgDlsHKwWOrHm+RRkQ2KYFs7jVbXYxPwNw50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037768; c=relaxed/simple;
	bh=my+qKsnNy4Haj0ddMtWhReKNx7JpYeiaftIBmkM2kHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mb2jZRlK6HupEhdJbmYwKgsLpdk5HDPglaaqO2zYPHfoZ7Sz/3gKS0fqGcKIfaBPp7qMh9PkTjrLMTk1bNbwVoyReQeKjOnXebnv8sr+o+2KwLu7RFUKW6FnXctxNjgqnv6xG3XGC9Nmr8xOQ6/Rna6SOl+8UVkiPhGUjbNViu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YweQZbPr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YweQZbPr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037767; x=1815573767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=my+qKsnNy4Haj0ddMtWhReKNx7JpYeiaftIBmkM2kHs=;
  b=YweQZbPrMRiWDrWM7ksUNW/df8+jCe2JrIQxR8mZRLeQirJ1LGnil0Wz
   g2VratBN+dWZVo8wAlOn0kqndc74Er6e/q24GvXhEd/+KffwFJcFajXu2
   eWV+dxTefE+hoLxDmKV5R/z5QyaAxZf+K0hxNLTq7TwcVD0Z+EP419laT
   6q9gUJUIywt2aN0hDN7C8tG/RXdWHmWbmqqdNGxiug3Hd45ZW6fwCrWhI
   5uVul+Xh2fFGYOvGQr0nYHcvZMOaDJeDPowip9fD/q8G8jg25By652RNS
   AQNaHghmGRgV4dl32umUl4mvi/iDF/IcQgY181nbJrK5y3ZPuTIhzaXkg
   w==;
X-CSE-ConnectionGUID: Z8eHoGqkRDSM30ega6q7nw==
X-CSE-MsgGUID: DQ7ZyxiLTn2BPtvhnQobCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84855080"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84855080"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:47 -0700
X-CSE-ConnectionGUID: oYBB60ffTi2rm7nfq3jl9w==
X-CSE-MsgGUID: h0M5sgkFR6mTRBkXccdC/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="254737848"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 04/15] wifi: iwlwifi: support TTL platform device ID
Date: Tue, 14 Jul 2026 17:02:07 +0300
Message-Id: <20260714165826.46183446954f.Icc260831e530c1c92c9be615a7077768b1b9ae30@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
References: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Add support for a new device ID that we will have on TTL (sc2).

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 7a7b10152e5a..a3e6c9e09a3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -548,6 +548,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xD340, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0x6E70, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0xD240, PCI_ANY_ID, iwl_sc_mac_cfg)},
+	{IWL_PCI_DEVICE(0x9327, PCI_ANY_ID, iwl_sc_mac_cfg)},
 #endif /* CONFIG_IWLMVM || CONFIG_IWLMLD */
 
 	{0}
-- 
2.34.1

