Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43DF270552
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028805; cv=none; b=NbO1h4DwvD1HB0+6yVfCZzfrlSA6k1uJhCukylA43dYgHdvff+x7g6XD7kLLiN2E6ZCKbhO0WPiE46OYcLhHhsAoVNqtOvb36UW6TR71qTCFC5Ezy9K9iagxyUx470RitZ2xaaiszptLabcVUocBpNXccfc4eGZZI1uajblRYUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028805; c=relaxed/simple;
	bh=IQUc0nZimLwzbW/BXUVMiGO68xJDJqQ9W8XvhVnSV9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i+ZgNp7tr8FLfXGcyhuGLqtNPy0WSnKqSJKzghTy/TBI6qrNS0r8qzWJVVc0HbgrDNGD+iK6f9zg/UWOE46YLfDDuxnAp0ien8FbZN6FSFUaZ2DFM7Ie7+A6dba1LpEAj9+eUw1Sp8MbxK8l+VnAs9f3fqpGSU2iIFfbD7H05Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jed+3pL8; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jed+3pL8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028804; x=1815564804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQUc0nZimLwzbW/BXUVMiGO68xJDJqQ9W8XvhVnSV9s=;
  b=Jed+3pL8slOVNhoMNzZ3IjJyX4H4XLf/K48VcNicO/oVB5wmR2LcJSce
   QrxyI0VYJALu5oOn/hE6O6RWDgqIfyMvPKg0otFuFQTOnav41ATPdis1s
   IeFqB+EWse16iIE27twB187SUZKcur+HFE8wX7SvmKGS2l6I8U3mz46A+
   6Xs4SotF+U/MiQPYe1Dw7bKX8UGSL6VJjcdWMi4Fq5fgiKs7ApRGTkeCQ
   nkS0MSUgMwr60vt1R63gtTD/6dpaPXkJBctkJAiQTdJQXXUowPkq8GdZ6
   jFBG5C1hISF8Y0I4JJIfQJkRq0RPa91hSGytrVzb6RijdkW50VMtmu91R
   w==;
X-CSE-ConnectionGUID: OZdoFSBMTKml6rw4Kf7o0g==
X-CSE-MsgGUID: eIDWR/bfTi+SV7N6a3v2Vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469612"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469612"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:23 -0700
X-CSE-ConnectionGUID: /gkKD1W8Qymy4sINFEP23Q==
X-CSE-MsgGUID: bPhwGml7SiODzHznieLbgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882995"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:22 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Tue, 14 Jul 2026 14:32:39 +0300
Message-Id: <20260714143119.7d3c5efe2d1a.I16b23c328a677257257f695fa6f439e41fbcd081@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
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

