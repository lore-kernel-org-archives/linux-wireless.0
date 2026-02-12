Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F522F39DE;
	Thu, 12 Feb 2026 12:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770900718; cv=none; b=oMN4P2Ej0MDAJBmKfLBXgvM8a7DGY3TU3AITiPfVfI5ZQdZZt4WvJWnntm1R0kCnAGpsPEnAMzyuUPqmSzPgezpPgnzD4q2MI2X0rHKPnFwFQGcoEpbZZ7ln2/zQPkh4mtq0uZBokaKgDxmRHecbJwVRX8qwVL4k0mCh9ZfZW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770900718; c=relaxed/simple;
	bh=5PADlxX/i4hi1VtzVuL+/fMGXH/GtoU6RGW/xNTvkbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3BcmMCpxB+0U87MEZCbefClSoQFgoF/mS1XjJJgE4XR/gRSsKI3sl0N/CFLc3Joll1LoHkQCKqAF8bbmwQEyp3x4bKslEfn2LuutNNg4vQDOazTXxJF7833Qe+BPTNK22JKnYlbJ0pDfYiGmtjAcku+XMu+HzBgayHzY9votSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WRk/Lspw; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WRk/Lspw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770900717; x=1802436717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5PADlxX/i4hi1VtzVuL+/fMGXH/GtoU6RGW/xNTvkbA=;
  b=WRk/Lspw69jjWmZeFYk3mPiJQnxRNtvbkXRVsIHml0Spp6waSpdGO6RY
   9818mhxeXGdUygfwUfAaLAF/0lQye0TxPZXRHzpizjl6RBXJAJx8X3Ro+
   vveeHR3jWE2M9+n4sD7jXjzmaJqE/6JzWDtx+8tX8UJo7xNQfik2F55Sm
   QxHgRsCrlhkWxhdMD37w0pvIbBKnNBSAaGypTj6pfGag+d8I0pDXl16lM
   bXTY4Jo1NYvGdhV9XlFgx1KYJ8XlT4yHEo87rF1oVaDbEsH0pKl0Phiyi
   IInDoVLYccZFu0oBCKXviLHEerFY/alCf8dvePZ9y/QF3vB/hVIdjDh4g
   Q==;
X-CSE-ConnectionGUID: jWV3RxjNSXq1wNGycJiFvQ==
X-CSE-MsgGUID: 0Hks4yIwQ/CIfpU5vAif8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72254028"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="72254028"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 04:51:51 -0800
X-CSE-ConnectionGUID: g7rFGx85TkSh4eFZ3STacg==
X-CSE-MsgGUID: TdTu/8/vS1CpLsgXK5HHPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="217553359"
Received: from b580.bj.intel.com ([10.238.152.74])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 04:51:48 -0800
From: Junjie Cao <junjie.cao@intel.com>
To: miriam.rachel.korenblit@intel.com,
	johannes.berg@intel.com,
	linux-wireless@vger.kernel.org,
	richardcochran@gmail.com
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yedidya.ben.shimol@intel.com,
	avraham.stern@intel.com,
	daniel.gabay@intel.com,
	krishnanand.prabhu@intel.com,
	luciano.coelho@intel.com,
	gregory.greenman@intel.com,
	stable@vger.kernel.org,
	Junjie Cao <junjie.cao@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH v2 2/2] wifi: iwlwifi: mld: fix race condition in PTP removal
Date: Thu, 12 Feb 2026 20:50:35 +0800
Message-ID: <20260212125035.1345718-2-junjie.cao@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260212125035.1345718-1-junjie.cao@intel.com>
References: <DM3PPF63A6024A9E1EF4081E342AF4BED81A365A@DM3PPF63A6024A9.namprd11.prod.outlook.com>
 <20260212125035.1345718-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwl_mld_ptp_remove() calls cancel_delayed_work_sync() only after
ptp_clock_unregister() and clearing ptp_data state (ptp_clock,
last_gp2, wrap_counter).

This creates a race where the delayed work iwl_mld_ptp_work() can
execute between ptp_clock_unregister() and cancel_delayed_work_sync(),
observing partially cleared PTP state.

Move cancel_delayed_work_sync() before ptp_clock_unregister() to
ensure the delayed work is fully stopped before any PTP cleanup
begins.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index 231920425c06..b40182320801 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -319,10 +319,10 @@ void iwl_mld_ptp_remove(struct iwl_mld *mld)
 			       mld->ptp_data.ptp_clock_info.name,
 			       ptp_clock_index(mld->ptp_data.ptp_clock));
 
+		cancel_delayed_work_sync(&mld->ptp_data.dwork);
 		ptp_clock_unregister(mld->ptp_data.ptp_clock);
 		mld->ptp_data.ptp_clock = NULL;
 		mld->ptp_data.last_gp2 = 0;
 		mld->ptp_data.wrap_counter = 0;
-		cancel_delayed_work_sync(&mld->ptp_data.dwork);
 	}
 }
-- 
2.48.1

