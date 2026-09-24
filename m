Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20244746BF
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246385; cv=none; b=c80YwU75wE5DlgUi78nEaBMHb7hk7biGjqdCjHncC5d2Wq/dHQtI3s/IF4oZBYAFFi8djf8kdrT17X4UuPa2yncr+75c2UTCUEmP7bI8euFbAKLm1leB4n6Jgh5kPFU+hPWQA85i1pbwd+cG8tGUKfZHBF3aEVAubh0vm8Eczsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246385; c=relaxed/simple;
	bh=lhd5//PZg2P4P/bezJHnA98dsmQgWWvJu6o2EKMD+Rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EWAKFqwt8keSyI1aHF3r6cNm2tiWa8QOQ7nIkcK8gE0gVP9ez2ZfKI41/MDlgho+wdpI+zfefMC9A+lrj6/XgKAfln+vYSMruY1U2xRSTA3V/ECmtzsnXNLhyCrdGtO4AUzdocL+rbyxfT5RulStZvnIu5EHmm62PsOjLjhjafA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fbIBHymd; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fbIBHymd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246384; x=1821782384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lhd5//PZg2P4P/bezJHnA98dsmQgWWvJu6o2EKMD+Rc=;
  b=fbIBHymd5+935qsC/ZoGcA88mORjx3dAwqFEFuYxgq87ZJR+PiFW4712
   vZGFqZNOQo0o/BK81Khk/awLR/ziErL409DBHUnC/MhXbnGX9vI0zUkJG
   tMYi2LZo20lbvAsTL2W8L6ReB0YLm3CmV19ZU1zCZtmWAhrqkurpfd95J
   AoG3AyR2eoDMj6zCiDCMsS5Yh6/VTmb2mGTELrGCCo920r8Bu5QzdshUV
   nqsegce0tuPhcMwn7QC/S9ti2DZ4oCNWZA5D5FDZGf8jilFzNSPc0wjSz
   cYpDEi/1Gy4Ztw7bsWLG5ugxxq+aiHzpMCBXprKWTzuC/4QOcCJiH+/o2
   w==;
X-CSE-ConnectionGUID: WA165e/aTB6GGzXrjU4nvQ==
X-CSE-MsgGUID: 23alU5/dR3OnbFjnUFW0Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134882"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134882"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:44 -0700
X-CSE-ConnectionGUID: GzXQJUfRQ5e7i21z9Tlarw==
X-CSE-MsgGUID: alF/od/2SASrzi0TD6xRCg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:43 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: pcie: order RX reads after the write pointer
Date: Thu, 24 Sep 2026 13:41:22 +0300
Message-Id: <20260924133942.bb2e30eca4c0.I24dec81516e37a33674e87ed3359c41e59d12e5e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
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

