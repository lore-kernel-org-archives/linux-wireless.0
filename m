Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF6D3F210A
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077689; cv=none; b=eOZy+X0Eq7P0RanmIGcFn8c2XnJp39FdWGiuWF9eoDj2yAirbYK0gF60QITWvnsYn/fTSxviykpZPtCQLTD0cHREsvOKDpWwqd38TX0+6c+KdR269PXh0YPZXDdjDomsQg3ubW/ujZl8z25MIEja5ktizHDCO1b8f2+GbLBS2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077689; c=relaxed/simple;
	bh=lZ7R5Hap8pVYq+74dfZ5mEldRWfyaHQJ1/zVkQz4NqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xja0mk2zpbs3LG+vaOi8gX1OM29s9vi/ce5DAXMd+1J4yWMZ9954tM81Ims4mhzIl5uj1EJRYX+iNzeD9ICV41B+ITYLb8iYl/a78lK2/7ZWDBrr2P0Qw8fojG/XAYOFyi9mycupPdC8hSqrECm7vU+3C1eHgZJlWAxHAyMfKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2005wg2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2005wg2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077687; x=1821613687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZ7R5Hap8pVYq+74dfZ5mEldRWfyaHQJ1/zVkQz4NqU=;
  b=j2005wg2miMDIKzdmCPH2ENDQRVi8tRWnWly/FLDiuBSofVGRopUaWiC
   VJKvUKN1wq8kXDtOP0pY4VkxHchc49cVuKc1utshNzJCqjPCzaCEL6kqR
   V3XV0dO7HT5voXixoyvlz7HLblwsjJR7m//B5io2HLPI0iWufLYam0HSv
   cgfXZXsTZvN63RY37R0ZhDXPjAdk1fqStVrigO4dBoCa5JcIGYi0EGyFU
   AfYri7rHqDYe8XqzcUPBVDpWpVuDiN+Fat9GsFjfCDgLW+tNSz3NgCfVF
   kg0ESRT6IASV14uFA/AhMc2lwJjmypjbjWPZi8L11Ceu/WKr92JbAhq3/
   A==;
X-CSE-ConnectionGUID: ferv+VwLRmyNhCzGxhxWLQ==
X-CSE-MsgGUID: HHredaqIT8y/zCZW9bUe6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170500"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170500"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:07 -0700
X-CSE-ConnectionGUID: 9zZgWaWsTTK5B1u6dbDNkg==
X-CSE-MsgGUID: 3oYyqDkXSVOWs1SqngDIFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275329"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: poke the config space in case of command timeout
Date: Tue, 22 Sep 2026 14:49:49 +0300
Message-Id: <20260922144819.ef433f3da32b.I017c1c7a1dd3ac6f111d4640966968b82f37e291@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There is a race between the PCI link power save flow and the
notification flow from the firmware. The firmware prepares the
notification in DRAM and then sends an MSI-X message to interrupt the
CPU and let it know it can handle the notification. In case the PCI
link goes L1.2 between the access to the DRAM to copy the notification
and the MSI-X interrupt, the host won't be interrupted.

Add a work-around to cope with this situation. If the command response
was not received after 200ms, read the config space of the device just
to wake up the link. This will allow the MSI-X interrupt to go through
and the CPU will get the interrupt.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221501
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/gen1_2/tx.c   | 31 ++++++++++++++++---
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
index 060074c2871b..fae5beed2ecb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
@@ -2560,6 +2560,7 @@ void iwl_pcie_freeze_txq_timer(struct iwl_trans *trans,
 	}
 }
 
+#define HOST_COMPLETE_QUICK_TIMEOUT	msecs_to_jiffies(200)
 #define HOST_COMPLETE_TIMEOUT	(2 * HZ)
 
 static int iwl_trans_pcie_send_hcmd_sync(struct iwl_trans *trans,
@@ -2593,10 +2594,32 @@ static int iwl_trans_pcie_send_hcmd_sync(struct iwl_trans *trans,
 		return ret;
 	}
 
-	ret = wait_event_timeout(trans_pcie->wait_command_queue,
-				 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
-					   &trans->status),
-				 HOST_COMPLETE_TIMEOUT);
+	/*
+	 * There is a race between the PCI link power save flows and the
+	 * notification / MSI-X interrupt in the firmware.
+	 * If we didn't get a response after 200ms, poke the config space
+	 * to force a wake-up of the PCI link.
+	 */
+	for (int i = 0; i < 2; i++) {
+		ret = wait_event_timeout(trans_pcie->wait_command_queue,
+					 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
+						   &trans->status),
+					 i == 0 ? HOST_COMPLETE_QUICK_TIMEOUT :
+						  HOST_COMPLETE_TIMEOUT);
+		if (ret)
+			break;
+
+		if (i == 0) {
+			u32 val;
+
+			pci_read_config_dword(trans_pcie->pci_dev,
+					      PCI_VENDOR_ID, &val);
+			IWL_DEBUG_HC(trans,
+				     "write_ptr: %d: no response after %ums poking config space\n",
+				     txq->write_ptr,
+				     jiffies_to_msecs(HOST_COMPLETE_QUICK_TIMEOUT));
+		}
+	}
 	if (!ret) {
 		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
 			cmd_str, jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
-- 
2.34.1

