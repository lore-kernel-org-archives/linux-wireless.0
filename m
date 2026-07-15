Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487DB431A31
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141894; cv=none; b=WqPHRjL2pipqRlnCQajHmeRNQPbm/dSu9tubJHHm+abNFQpTKTxbm7kJa7g0PcpMmVJnjLPyAPRQw6jsIiB1lUGJRUb9VOA0DduAh+PE6tP6fn8HdHUqtgLM4DSrN+RmfSRNGzhzZagHwLibWZzehlVctxk/Uz8BFukktBiAvuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141894; c=relaxed/simple;
	bh=IIdYuKwtwIf0lr9iyLLHFvhOtKP5PmqMjJH7XAsd7QU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MbF2wMRZtMfl+2j6+9d39KxDmK6bd3qp6f5i2dkomgVLiEd77LOx2eG8Fb75zqbsC1vgu1+b7L5Kbh/61opSGLscopSYxfN7OFmreUsPgpUZqpSks+Zc1Tfu24PZEAgw9wrWPBs6MsTnYodANTrlDNf27fS2vl4JjB50N2k9oBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jy/HPlXr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jy/HPlXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141890; x=1815677890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IIdYuKwtwIf0lr9iyLLHFvhOtKP5PmqMjJH7XAsd7QU=;
  b=Jy/HPlXrjvPmfI70617u4UT2NKZnuvCDtfKloyehTdd6YCvo1k66utIo
   xkI8TghmCrQ4iQd+aw5j19YKGweAvhr0DTlHd+WWvFq9moEyMfgfuUjFZ
   p8NVom9xEGTu9fnASH6LFf7aqyKcv/GavJRzxUy4X1njV/0U1Gfb0T+ly
   k7ckdjl6+knKzvh5svpTPcSOyBsSbfs+2JnkMQTmW3V0VuHcZdr0b8Lhj
   XCpxKDeYptDXWXSRJOr9+ChCoTxp6H7uvOhQ//AHR0QN6rOoY5DS9PI7a
   wh2nkGDXOKk1oal9AYy1dD+OXvU3/F/ydUDE4EKlGd5oIxyhUvJfsoRk2
   w==;
X-CSE-ConnectionGUID: XDwZ9B4wRTqlKg32nIbuVA==
X-CSE-MsgGUID: jzU1a2IDSDWJ18eKy3alYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160921"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160921"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:56 -0700
X-CSE-ConnectionGUID: Aj9ImbipQ4+WHcordyNCGQ==
X-CSE-MsgGUID: TpBCAw/iTDyoaWm9dKoVVg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:55 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 12/15] wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
Date: Wed, 15 Jul 2026 21:57:12 +0300
Message-Id: <20260715215523.d7c3e75d47af.If88948108cfc8b5fb3ce5531d927855d1b3b6b30@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

ba_notif->tid is a firmware-controlled u8 that is used directly
as an array index into tid_data[] without any validation. Add a
bounds check against IWL_MAX_TID_COUNT before dereferencing the
array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index e02c376296c4..d3c2fe830477 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2161,6 +2161,9 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	ba_notif = (void *)pkt->data;
 	sta_id = ba_notif->sta_id;
 	tid = ba_notif->tid;
+	if (IWL_FW_CHECK(mvm, tid >= ARRAY_SIZE(mvmsta->tid_data),
+			 "invalid TID %d in BA notif\n", tid))
+		return;
 	/* "flow" corresponds to Tx queue */
 	txq = le16_to_cpu(ba_notif->scd_flow);
 	/* "ssn" is start of block-ack Tx window, corresponds to index
-- 
2.34.1

