Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F0037106A
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037801; cv=none; b=kDtLVTrOJdwbepu0zjFaMlXcgDZY+PFS/0EOL459vdiU2rAA4DnrLZDICDPthvq9YANKqYoSVDW8wxs3VuXY5wAP0JBRy1xJs8TEeWtWzj9Q1paIUlstwrhO5i+twbiVPRKpc4uoce/7OI3nkM80fcPZOtPUBl32jgOeN/iCywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037801; c=relaxed/simple;
	bh=IQUc0nZimLwzbW/BXUVMiGO68xJDJqQ9W8XvhVnSV9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k3sySPMdF36NO8kEa/d0KogIautxJdH9fq/5cWw1O1uwV56dV4CGUv6MvTqZpBJskPJPsulBhe9ftPKBgE1Ok6ugns3K8gDvBlSmsoUXRuO3FWRU5K4VibLwcyQ4x1Ez6QyTosupveNpXBnrPFkUjNuu7brHbQhd28Uf1p4dRis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QAU4P7R7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QAU4P7R7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037799; x=1815573799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQUc0nZimLwzbW/BXUVMiGO68xJDJqQ9W8XvhVnSV9s=;
  b=QAU4P7R7B5krN6/F+BB2SVwsRrE5AMS1mt/9xEKCd4H7i7InLRb6ZBgP
   6iNGvKwcpXVlGsKw+ZFc3c6ZhQZTbow9hoJKRZPJv+/GHle6F5ThkSq5v
   kVDk5GNIEFoDTCgQcIpYomLRwaMbjfZehIN/szbdH0S1q6PKUbnZzrEhY
   qxCoRilMWw9INL1lfdwx2PuVSCGxJxSFT9w0gTT52XTkdOCn63pdXnZ4G
   sDyDD/9GynP8BPW8sHI4XCuhyvfG/UGtugAUGIzsDl0JyD7p7fM6yBYUu
   7Pqx7IfrL+ARrZnWDVVgGn0t5CyivEsRUmBa8zHyuFFgOTen+LlmmhSGO
   Q==;
X-CSE-ConnectionGUID: lCT2myomSnmbyQiaGBriyA==
X-CSE-MsgGUID: 9OeGzbw7S3yQJlh1PToIoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84855160"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84855160"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:03:02 -0700
X-CSE-ConnectionGUID: Cp+iPng0SNiyUSd7mxDl+Q==
X-CSE-MsgGUID: XA7RcsyHSN+JkHXjPbpR/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="254737945"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:03:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 13/15] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Tue, 14 Jul 2026 17:02:16 +0300
Message-Id: <20260714165826.7d3c5efe2d1a.I16b23c328a677257257f695fa6f439e41fbcd081@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The smart fifo is a feature in the firmware configured by the driver.
The driver keeps a state to remember what was the last configuration
sent to the firmware. Obviously, if the firmware stops, we need to
reconfigure the smart fifo. Since we didn't reset that state upon
firmware stop, we thought the firmware is already properly
configured and we didn't send the smart fifo configuration command
as part of the init sequence.

Reset the smart fifo state in iwl_mvm_stop_device() so that we
will properly send the command during the init that will come
later.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f43895c2f3c6..09150feb330d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1535,6 +1535,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.34.1

