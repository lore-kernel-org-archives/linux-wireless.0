Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4231E7660
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442949; cv=none; b=a81BZKyhFpRHqU3sUpOG0uTS16tM4uSXgHCFuI4qtIXPi9OBJhCsLiiboBXceCCiOS0wcqsGNIZ7I6A1g7LmMbor55rQmzOr2LRjmh6emBQpS+rS6mvrnW6ZmZ9epcoNY89mRm0wk1LOXLWV49e266Yd3Tzs/nVDl51Pj1J2wPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442949; c=relaxed/simple;
	bh=lhd5//PZg2P4P/bezJHnA98dsmQgWWvJu6o2EKMD+Rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U8iAKd8jCW0GBqXNz8g0TqmPLKD06ueeB8eudJSGrK7WXbSlzrk7laEp9isdpyZMx7ERXvtla/41frybLlBmJMlt/8e5n+erwYKEhtXBlRw3ymAQfjgy5fT+xdLVKldlluQaFQAki3PykUl7Ur9l1ubAz+QEYRhE4ebyhoKvMGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfdqtn6U; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfdqtn6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442949; x=1821978949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lhd5//PZg2P4P/bezJHnA98dsmQgWWvJu6o2EKMD+Rc=;
  b=nfdqtn6UYGR2lc6OlpBxsTGRO+9sa44h26NquPOTHPwItR/YCBmUYW+O
   Fnal1TInmmwJAxyX4xq81yE8JzXKhGXV4I8sZd8ztPgcdOqMmMZL5lJJp
   JvXxCl/aIwMOMykFv2OCFbLtoYzEWObcRtsXyMNKR13IjCCzV9CQNgtzm
   L+kvXGofceNwe7tbApFCT4UalpGHTQp6mo0U2agiwbEmGW8r0UnHd8XcC
   11tH8DjiVqgXd/IuUn6szoKeLQWo2RCwaUg/6YLFV8hhJjMHOVP/dplh6
   mhZSfs+b+jZ7ALJc3szTZyVZLdecPREYADksuVGBw9zi92hTgBzToWK2J
   Q==;
X-CSE-ConnectionGUID: uoN3QIBrR+OadRw0nuBTQA==
X-CSE-MsgGUID: AbEtnadUQVqszYGSaEmTNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533286"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533286"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:49 -0700
X-CSE-ConnectionGUID: 5ALuDuGWRqicPdjpS7v/2w==
X-CSE-MsgGUID: LjGNl0tNQ3aTLjUz3w4Vwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196991"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:47 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 08/15] wifi: iwlwifi: pcie: order RX reads after the write pointer
Date: Sat, 26 Sep 2026 20:17:27 +0300
Message-Id: <20260926201527.1bff8cebef69.I24dec81516e37a33674e87ed3359c41e59d12e5e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_pcie_rx_handle() reads the last closed RB index from rb_stts and
then reads the completion descriptor and the RB contents that this
index makes visible. Nothing orders those two reads: there is no
barrier, the descriptor address derives from rxq->read rather than
from the index just read, so there is no address dependency, and the
"while (i != r)" test is only a control dependency, which does not
order loads on arm64.

The CPU can therefore speculate past the loop test, perform the
completion descriptor load early and sample the value from before
the device's DMA, then resolve the rb_stts load to the value from
after it. On arm64 (Jetson AGX Orin) this showed up as recurring
"Invalid rxb from HW <vid>" naming an in-range rbid the driver still
owned, and "frame on invalid queue" for an RB tagged with the queue
that used it before the wrap. Both force an NMI and a firmware
restart. x86 never shows it because loads are not reordered with
loads there.

Add a dma_rmb() after reading the write pointer, as other NIC drivers
do when consuming a DMA descriptor ring. It is a no-op on x86 and a
dmb on arm64. Verified to stop the warnings on Orin.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index eb70922cf516..d1ef0365b932 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1519,6 +1519,11 @@ static int iwl_pcie_rx_handle(struct iwl_trans *trans, int queue, int budget)
 	r = iwl_get_closed_rb_stts(trans, rxq);
 	i = rxq->read;
 
+	/* Order the read of the write pointer before any read of the
+	 * completion descriptors and of the RB contents it makes visible.
+	 */
+	dma_rmb();
+
 	/* W/A 9000 device step A0 wrap-around bug */
 	r &= (rxq->queue_size - 1);
 
-- 
2.34.1

