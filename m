Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946CC3630AE
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028039; cv=none; b=ub1zkA6sjIGbO9VyjCGaPbTDhjUqJWUzXUiLB5W1eEZzb+JlLm/c9baYtHEzVkSZiULSQjLkH9/mvb2CVyREFkdNjc/hJz/s6bU+z/j1pGmXoxXIRdMGkLW9jCW37r296OahxqMCgEoVihoIxvu/U8hFMTdc7IbiXZJlJnN9/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028039; c=relaxed/simple;
	bh=kcjC9DZf/z3WSQqiju+EjELqC/2FS9+wfTOm0eE794c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kfuejysDLLrih8PdP2d0OTxHv67dYMVTQRk/GY6GWFRKpzYoD2LywmiXQM3/KSNqLdrSkKDE4vsxyO5DKAgq1MNcE2mEfYBTic0MjqlizseTy69x59w/BHJJ3i8+AMDMLpUGFOk7CLbPQNo5orX6qgb+crgV9+lLppHiY+ObPGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TKXHPLNH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKXHPLNH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028038; x=1815564038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcjC9DZf/z3WSQqiju+EjELqC/2FS9+wfTOm0eE794c=;
  b=TKXHPLNHnGfs4wWlhlkFxORVdJEzropGiOOjU8DqPx8xMwy0I5dFIt5x
   bNV0Ip307Qdcka9IRqNoXoMSKv9f7EiyxxX8p1lHGGpZI6Xxxyo8bB/yT
   /s5D9fwSFB4SaY4SrVtLR3x/cVkGhjhDBh7cYVQVnQckjuS2hHDEP06IU
   iX8Ia0enpV+krjwL1+CrAlP5/MvWY8ecBCisbHvSls/rCzvN3ZK59xqOU
   JDLllYwkuIprQQzZlEhje7RpjgAjyZvGBW8OT4TLGfJRZDKm0xAX+mYYa
   6UqGGXjuyU96aHurmj+eD0zxhMuzVWXEfwZURBgk4uffGoMgjjW74lfmT
   A==;
X-CSE-ConnectionGUID: 8NouGp9DQW6Q6aVi6d3txA==
X-CSE-MsgGUID: 7nNqYSBqTz6NcXMs0h4X2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200317"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200317"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:38 -0700
X-CSE-ConnectionGUID: ANLQOC8eRniBFTuyHIt6+w==
X-CSE-MsgGUID: A9PyhxgRRCaubO9T/i/lbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250182"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:37 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 10/15] wifi: iwlwifi: mvm: validate sta_id in BA window status notif
Date: Tue, 14 Jul 2026 14:19:59 +0300
Message-Id: <20260714141909.2e97f337f3cb.Ic3f0f404082ccdea13809a3c0b70e0f5417e1037@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
References: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

BA_WINDOW_STATUS_NOTIFICATION_ID extracts a 5-bit sta_id from the
firmware notification and uses it to index fw_id_to_mac_id[] without
bounds checking. Validate sta_id before array access to prevent
out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 269c4b45de80..ab1eb2eb0c3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -1227,6 +1227,11 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 		/* get the station */
 		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
 			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		if (IWL_FW_CHECK(mvm,
+				 sta_id >= mvm->fw->ucode_capa.num_stations,
+				 "Invalid sta id (%d) in BA window status notification\n",
+				 sta_id))
+			continue;
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-- 
2.34.1

