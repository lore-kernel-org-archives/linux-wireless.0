Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5FC191F84;
	Thu, 12 Feb 2026 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770900707; cv=none; b=n4Hgz5FFc36cwhc8vpxmhoXy6RBPaXYbWtArd08VX3VHIZHcsAgYOIyBzoXOWea3aODiSqGqOIeNXZ0CFEmDSWthu6f2B2qRfRLAWoWR1Qx8xyqOscCiITPKbq7PkZjHNOMG9Qe6/UdZ2cpxMBcXcOToBVFq1IryGKB0J8AfPvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770900707; c=relaxed/simple;
	bh=PyVwbo3G2WaDgrVWH5+kW9Klx0qdUxGwxHjil+oq0k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+YDHfNRUpp68rvo6vcLCkB9+1l2DXXIc9h1YbTIcUZKGd5e+S75XIFeH6olyh6FUS9SdjXYJ1Mgm2XkFQoiMkl7eaC465HhturFJJ+JNvxEWD83sUijo0GOR9TUWaRy1A1hz35GU0/IphRiqaZNIY07N+5pHL93TudSvAtaclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=izkPJ3y0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="izkPJ3y0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770900705; x=1802436705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PyVwbo3G2WaDgrVWH5+kW9Klx0qdUxGwxHjil+oq0k4=;
  b=izkPJ3y0Oqc3kqKDKbvedP+JzGenbpYKMUaaVIcFtrjhiA0uDuHKQjmK
   THsatzORHZ6wzOg6gBN8K0BJ+ogXASPu8Ah5NGxdNzUgc0VcPq7FIcVk/
   zHafuxlLSdOzTBVv5M2ZiyfzA7EZwBWLaRf6AYV/2vOfyl+pnXp4Kfgdn
   coWQUBrQMn3gy975daoVcqMCIZUkTqGxH0ADSQYyHZ0rvfaOi8agkiWSp
   +YjrUv/1O8pZuMQmLSP0j9XRB6juNZhNjVkesv5lPyZcYJmHPNNQCzacQ
   ysT1WF+pWradT3O3cOj1+Ky2EueL9TcI2rW3YKtpUmKseNzLS6DePS0VU
   g==;
X-CSE-ConnectionGUID: YBdTq6RdTs6aGBNb2tJBIw==
X-CSE-MsgGUID: kSe1PlgIQH+a5HWSc8JvPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72254017"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="72254017"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 04:51:45 -0800
X-CSE-ConnectionGUID: FA5gVCb9QZKpXm/ZR1xihA==
X-CSE-MsgGUID: bkpau9f3QgyODNgg6lR35A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="217553313"
Received: from b580.bj.intel.com ([10.238.152.74])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 04:51:41 -0800
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
Subject: [PATCH v2 1/2] wifi: iwlwifi: mvm: fix race condition in PTP removal
Date: Thu, 12 Feb 2026 20:50:34 +0800
Message-ID: <20260212125035.1345718-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <DM3PPF63A6024A9E1EF4081E342AF4BED81A365A@DM3PPF63A6024A9.namprd11.prod.outlook.com>
References: <DM3PPF63A6024A9E1EF4081E342AF4BED81A365A@DM3PPF63A6024A9.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwl_mvm_ptp_remove() calls cancel_delayed_work_sync() only after
ptp_clock_unregister() and clearing ptp_data state (ptp_clock,
ptp_clock_info, last_gp2).

This creates a race where the delayed work iwl_mvm_ptp_work() can
execute between ptp_clock_unregister() and cancel_delayed_work_sync(),
observing partially cleared PTP state.

Move cancel_delayed_work_sync() before ptp_clock_unregister() to
ensure the delayed work is fully stopped before any PTP cleanup
begins.

Fixes: 1595ecce1cf3 ("wifi: iwlwifi: mvm: add support for PTP HW clock (PHC)")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index ad156b82eaa9..efb291ceb0e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -323,11 +323,11 @@ void iwl_mvm_ptp_remove(struct iwl_mvm *mvm)
 			       mvm->ptp_data.ptp_clock_info.name,
 			       ptp_clock_index(mvm->ptp_data.ptp_clock));
 
+		cancel_delayed_work_sync(&mvm->ptp_data.dwork);
 		ptp_clock_unregister(mvm->ptp_data.ptp_clock);
 		mvm->ptp_data.ptp_clock = NULL;
 		memset(&mvm->ptp_data.ptp_clock_info, 0,
 		       sizeof(mvm->ptp_data.ptp_clock_info));
 		mvm->ptp_data.last_gp2 = 0;
-		cancel_delayed_work_sync(&mvm->ptp_data.dwork);
 	}
 }
-- 
2.48.1

