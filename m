Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59591367F4A
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028041; cv=none; b=qXGeV7oumKoI0kyRgMHnnUdoRWIURfqOW+To+2dKQAvZNejz9BIMMroi9geG4M0Dg6FOKLnuRoEfbBx9YeV6j5Lbfuae2XKRNfE9QqxpC1r1euYWmty3PiR7dUCCTM8E1oVL56bOk49ZpkPjTUNIB/EZJ5MYCU0p8lSrrmG5FS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028041; c=relaxed/simple;
	bh=US93Y1DGDDBLZnSWCimweTRl2hxBEuq/1ZApc2s51TA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lGU32tzg47rs3Gt9oMkVCKNLAyr+1TV024g54DwjnbAGbaFm9HpSQVaFkcMiMq+InH1Xc3aILtu86xF5EY6b9VIx6+/5rVa4QvnKiMMZXDwsk8mVg5qShmHCaUMpFmgriHswSApfIzZZAVCQeuazGwV6q00TYWKuPDKUmdwRouA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BififYEL; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BififYEL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028040; x=1815564040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=US93Y1DGDDBLZnSWCimweTRl2hxBEuq/1ZApc2s51TA=;
  b=BififYELIOk4DcaTVCViWvOfYwCXXQAt0GDdkLi0i/j7clmXnBEkBvGM
   qSTo8MgYrZAFNgG6S9kI8iVBKN+SV0cV8UQ7Sjtb+M1jpdRVTKTovXD+l
   O+UdZr0ANHNycMUqOC0knC80R0mt/LgEmvxIMO0bdDW2rTT80GvHQdOL8
   ozMPE8j31EP5nGzVK6HdbWCrcA2cMd6rXiqcrQCDE2H4fywAyx3TO8qD9
   dmy26IgOQ5/7a5dzLOWzlWwuNyDDrwd/yokMn4vyx8mY73TlhE81lTMxl
   +ZiLDmhSwW/hvI30MKHvCZcEtshwtKN+HCX0/PE7cUBwWEhDiOn2ZKRWu
   A==;
X-CSE-ConnectionGUID: wMLbU99aSriDCE5syKc/Nw==
X-CSE-MsgGUID: cQ0VUKx5Q7SCpmvaJ3MCKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200320"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200320"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:40 -0700
X-CSE-ConnectionGUID: aVrYRqGeSKSDWPRX2+DIoA==
X-CSE-MsgGUID: JcNBnJj6Qu6z8JgvPfiIoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250189"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 11/15] wifi: iwlwifi: mvm: validate mac_link_id in session protect notif
Date: Tue, 14 Jul 2026 14:20:00 +0300
Message-Id: <20260714141909.547ea470e686.I931445ae6f37bf0e1ef6f112c811712fc48af9c9@changeid>
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

Check the mac_id before accessing the vif_id_to_mac array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 1692b6e75f57..93b46c9e2333 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -951,6 +951,11 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_vif *mvmvif;
 
+	if (IWL_FW_CHECK(mvm, id >= ARRAY_SIZE(mvm->vif_id_to_mac),
+			 "Invalid mac_link_id (%d) in session protect notif\n",
+			 id))
+		return;
+
 	rcu_read_lock();
 
 	/* note we use link ID == MAC ID */
-- 
2.34.1

