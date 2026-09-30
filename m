Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00386476680
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760193; cv=none; b=ZTMPgR9s9lWNCYPKVPBcwjPpFIrxIXyYkXA6wMe3CwXmzzeJvn1+fzChdVhXs/yabN/E9HPZlj/qoD0lSaS+vbY5JIJpGlOH/XX2HsYij7PZ7KXklFItkAAItJP0nVz4hnv71IVRAZDa0Rb3zNJRfuqs9emPLHXFtO0qu6zrq5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760193; c=relaxed/simple;
	bh=9861icRCTKauDj6sdcNFby9MfOn87P4QJ7KdmsL1slE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EzY52QO523BgNMWGJzyjqSnRZCJaJ94qWXnyTvlHiw2UhcUkk+gvGEzbUKpDLl0Yha7c7P4vbaW9CYNagx6pX/tpK/i67o5/hMfqDdxOeaPmcn2+IabOh17BDqtGtuIA7pzDXNaTABTefnSlPk3YwPRC6GLtPMteFhUhwnqLNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOZ3xYjW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOZ3xYjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790760192; x=1822296192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9861icRCTKauDj6sdcNFby9MfOn87P4QJ7KdmsL1slE=;
  b=FOZ3xYjWjykd/VGMBGjUwhfqRxBiZwi7+ec3klcAdhhXSwArm+vWh7Mr
   p//nBNjoREEy0+bG2B6FnXBqXD3PVAQPyz93KbZeflk7Pj1HRSsJMDBa8
   G0bWnjSiyLDPFeWEfUkRASankplnAzIKADQ71O7R2JuKsovhRX2chzIj2
   Zeszhs61l+Th5gSYaiv3/QqvS/jmMA/PSnAwoDsKEjEBHAzXBsy7HjhWg
   UAm/ez4KBM8zOPcVnG2UOhEF7WYa8hl1T8WvbarZ8AFCGb/LZm8XVpnDO
   +h80VsANYrQe9d5SemqLBb1ZahBbqWXpS5hwXQOydBRifGkNMmp429cA8
   Q==;
X-CSE-ConnectionGUID: xpjnaejTSEaCuYiwXZfSnw==
X-CSE-MsgGUID: CYU8COmXRa+fYey58hacMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102020377"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102020377"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:12 -0700
X-CSE-ConnectionGUID: 6rH5RzsWT5CZFTtPyEkqwg==
X-CSE-MsgGUID: Dm4j19CKSQ+ghdIz3kY9wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275202759"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:10 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-fixes 2/5] wifi: iwlwifi: trans: don't memset trans::conf when it is still needed
Date: Wed, 30 Sep 2026 12:25:04 +0300
Message-Id: <20260930122439.5ea1111fca04.I2214b2bee4d2051f3597d7ab8c7746f521d48cc4@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
References: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Currently, trans::conf is cleared in opmode_leave(), which means that
in the rest of the remove() it will be zeroed.

But some of the freeing code still needs some data from it, for example
the cmd_queue id.

For older devices that their cmd_queue id is not 0, it can cause us to
free queue 0 as it was a command queue.

A command queue is different from a regular queue, the first has its cmd as
regular kmalloc'ed memory while a regular queue has it from a
kmem_cache, so the two should be freed differently.

To avoid that, don't clear the trans::conf, there won't be a new opmode
anyway in the device's lifecycle.

Fixes: 432a41232ca9 ("wifi: iwlwifi: dvm: restore n_no_reclaim_cmds setting")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 73aae1125042..486752d4da75 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -421,7 +421,6 @@ void iwl_trans_op_mode_leave(struct iwl_trans *trans)
 	cancel_delayed_work_sync(&trans->restart.wk);
 
 	trans->op_mode = NULL;
-	memset(&trans->conf, 0, sizeof(trans->conf));
 
 	trans->state = IWL_TRANS_NO_FW;
 }
-- 
2.34.1

