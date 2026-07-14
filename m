Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AC4446E0
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037774; cv=none; b=ePBmCrPys6shNjUuBdfN5wmdEIYUjwwP7kJd2uax420jWwVWpiQ7XixVp7OPOy7RSn6hYBgluSaSkTj/LcyIFkRfHtLQCI4yCF+Lzji8h9E4EuiZQUqfGfwWhsJ2HIq/WARJMpWaQrtDkoufjKbI8WdkzqnuTQ+EeTlMj33gTRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037774; c=relaxed/simple;
	bh=Twbd1G0EESuvA9DN23mLsgMoDXe31L/E0EXKO0gd0v0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h75G71KAEuVjtc0KI6YdWET0iOzd8gTh9ekKitUIypP8WYWAr7KNwE2Vly3tZndjpUkPkhlqTSqvnmnccorQ+PJDZjYnVTuHNVVefAmtzWSX0yE+sNRvIz0vMes6ivvlbitAtg/J90s4ORhYp4USERU1PdDsz8eCFSQI/K0mJWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TcLG9YUo; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcLG9YUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037773; x=1815573773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Twbd1G0EESuvA9DN23mLsgMoDXe31L/E0EXKO0gd0v0=;
  b=TcLG9YUol+wyNRz3xbqO2K+AbXU4czj5Q/Jum//0kwlsvOaSo/QQb4Ll
   qM1D6LFFQEK+AI7aPuO9mHmhEkQOsiLitruGICSoi5Ao6AITE6AiTQsvs
   TW7OGjgjUTvHXYb8rdOPYrgoFYs8uXwH7Jsk+AxFPv5EjjsiH4H4CS0aN
   AdlvRGMIVcnU5wRW6kOh2HlxO5dZArymmtj3hAVjXKvClNN89wqgFd/Qk
   QrJPp1qBOVbvr624YYApnCzXok02pdc/fbddZm2/KX7WkrDYMI/LvWu86
   sFUWgQY8x/lGrQGZRkyS9t6LySWMHmopR8nNCSKA77co6QylUP38M11UX
   g==;
X-CSE-ConnectionGUID: BJK5u5TWRlqWSX01/DDxiA==
X-CSE-MsgGUID: Yu0sqHgsQ+aeNBejx0BNjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84855111"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84855111"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:53 -0700
X-CSE-ConnectionGUID: E3laRtXyTkGvIN0TgjHvag==
X-CSE-MsgGUID: yWaS9JqCRjyavok4q7yROQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="254737872"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:52 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 08/15] wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy
Date: Tue, 14 Jul 2026 17:02:11 +0300
Message-Id: <20260714165826.07aa49f755a2.I734a27b1b0eeb5b0e821aee3318fee8dc0a6bc03@changeid>
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

When we fail to load the fw during op-mode start, we purge the list
of the async handlers but we don't cancel the work.
Same when we stop the op-mode.

Before freeing wiphy, we need to cancel/flush any pending wiphy work,
otherwise the work will fire with a freed memory.
cfg80211 will do it anyway, but it will warn.

Cancel the work in those cases.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 78c78cf891cd..5a6c9ab20fd6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -446,6 +446,8 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	}
 
 	if (ret) {
+		/* wiphy memory is about to be freed, we should cancel any pending work */
+		wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 		wiphy_unlock(mld->wiphy);
 		rtnl_unlock();
 		goto err;
@@ -511,6 +513,7 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 	iwl_mld_thermal_exit(mld);
 
 	wiphy_lock(mld->wiphy);
+	wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 	iwl_mld_low_latency_stop(mld);
 	iwl_mld_deinit_time_sync(mld);
 	wiphy_unlock(mld->wiphy);
-- 
2.34.1

