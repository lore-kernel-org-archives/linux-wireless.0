Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702A446077
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142309; cv=none; b=HhsCfVbMVPBoTCKxmbuluSxVVlEtgW8N82bpjpL7S5T0jFxgEwpL5ULS9DO++cPINAIb7fFu9eGRXQlINnYf/jABw9PSEE/8BTiPQDqGt9CKeLF8NvBOU9RsmYFw1fxu+kYMgjjTJ7A0DFKB1Ky30yUL4b+6w3AuClM2WdPAWjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142309; c=relaxed/simple;
	bh=zcwYmy6YO58ZDECrI7PcoThfbRHlerDk9BpC5mARIK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T9ZzUq8YDm+cOD0FQGT1uKCdyE7jaHK72j7RjRTWp3KqSO0/7mUO9XMK94lFjfhU3XoH/GBh/BSq/5WFZZ8QqQwZol1MXa9GEP9LioScrdol4pjcKpiMuYIbMiu3ATl5/X5+NtWuGCqaxrsL0SFPm3VGQnHtBIzl9fUTXyoutSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GUOn2Sz+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GUOn2Sz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142299; x=1815678299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zcwYmy6YO58ZDECrI7PcoThfbRHlerDk9BpC5mARIK4=;
  b=GUOn2Sz+8y1+KDXdFp7zP8VotbOQ7SayfamwK7di0jDLKwFN23u3BVWj
   jgKfFxZg1EQfqjPJLQeA5kgFimmdzpZgae1c7EWXE9SUCFrWBtu+q3gK3
   mUXd/8E9GWAFZIZUVKKBun/bBdQQV0/X0SC/bugIr6dE0CtBQmse0/Ni+
   F0fzqLgcuVucwPl9qWl6XUWBSmc1QjoTBa5h6RKuBKg96uUFbmbLp+g+Z
   NJYsPd3yFPEXhEoVrjlphXt3OtG2F4ZzltGYWzcDT7MTXeX4O2xP4oA2M
   ivp/9oxClLTlUpKuDhJhuZFr9Tgbx8ugk7Cki8RTYhNo9OABg0/afl9td
   w==;
X-CSE-ConnectionGUID: ppXJIl7ATd+do6Be0A6k1g==
X-CSE-MsgGUID: CSZMrpDNRu6gFqhpSGq+XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340700"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340700"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:57 -0700
X-CSE-ConnectionGUID: Z4mqOWGYRVqBxfXjSfX0Gw==
X-CSE-MsgGUID: HyGh3EZzQLmJq/5b/GCi/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851908"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: mvm/mld: fix PPE threshold debug print loop
Date: Wed, 15 Jul 2026 22:04:19 +0300
Message-Id: <20260715220243.5e1d3448bfca.I6919627382d46605b41b0c6a6f34deedfd45523c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The loop should print all bandwidths, the extra * results in
calculating the wrong ARRAY_SIZE() here (of the array inside
the per-bandwidth, not the per-bandwidth array.) Fix that,
and also clarify the array variable assignment.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c      | 5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index e18d86f021dc..7957ac11b0cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -355,10 +355,9 @@ static void iwl_mld_fill_pkt_ext(struct iwl_mld *mld,
 
 	for (int i = 0; i < MAX_HE_SUPP_NSS; i++) {
 		for (int bw = 0;
-		     bw < ARRAY_SIZE(*pkt_ext->pkt_ext_qam_th[i]);
+		     bw < ARRAY_SIZE(pkt_ext->pkt_ext_qam_th[i]);
 		     bw++) {
-			u8 *qam_th =
-				&pkt_ext->pkt_ext_qam_th[i][bw][0];
+			u8 *qam_th = pkt_ext->pkt_ext_qam_th[i][bw];
 
 			IWL_DEBUG_HT(mld,
 				     "PPE table: nss[%d] bw[%d] PPET8 = %d, PPET16 = %d\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index fd2a50563ab5..14aec0bfd173 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2352,10 +2352,9 @@ int iwl_mvm_set_sta_pkt_ext(struct iwl_mvm *mvm,
 		int bw;
 
 		for (bw = 0;
-		     bw < ARRAY_SIZE(*pkt_ext->pkt_ext_qam_th[i]);
+		     bw < ARRAY_SIZE(pkt_ext->pkt_ext_qam_th[i]);
 		     bw++) {
-			u8 *qam_th =
-				&pkt_ext->pkt_ext_qam_th[i][bw][0];
+			u8 *qam_th = pkt_ext->pkt_ext_qam_th[i][bw];
 
 			IWL_DEBUG_HT(mvm,
 				     "PPE table: nss[%d] bw[%d] PPET8 = %d, PPET16 = %d\n",
-- 
2.34.1

