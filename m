Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E6351C25
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028795; cv=none; b=lnj6UjH2lBLI52Us8fqdJEb+FL2FsL/HEKJFXP1BMHZpCbSYBFKhYHfqt9yCV+ea42HVbo6d7qGFOuUghBUtuSMOYnM5BAsOvRHPZSSQR2Ivwb9B5JAWKVeVWiGNsoX5UeIuXqMya8Kn7zUiHmw2LTZjw1vrPxV/Cp2dqRO1cbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028795; c=relaxed/simple;
	bh=kToOHH2LMGOkjzhmHvcFtiTtvHdqP0NHtTDvEqxGlmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UfsACxU0WaVfkawrrmWOulfQBGUxyhjdX2Y0xYzxg+9m8cT8iOMQJtok4tP5RtUrHwWb4+U7lbHMPyFp40Fo5ku/uRKi9CG18P8Did7G8CEaZyBhEpNPrd056GGfi/5neDM8MLfNfrp400QS5vjK8HlB2FPH/j3ZxmahypRctIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q7Pzr9Ch; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q7Pzr9Ch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028794; x=1815564794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kToOHH2LMGOkjzhmHvcFtiTtvHdqP0NHtTDvEqxGlmw=;
  b=Q7Pzr9ChPA0og6fk8chkN+lfDGxAaX7htkvRtBe1GR60DEwligAkYmpI
   RKSHsKs8NtAd/TOhIaqrTV3cnJIdyI3/5erjHIyfQA06G3IkgJ1pNeYaa
   pIuWvRr4ci/vzXxWF6eYoNo1KXCD8+Calu8/5U70xaJrz3WOzJa5tPyHc
   WBpwSVy5CGA142rUWaqcKR9Ews3/2D7kPGrxW8w6GjfdNORya8TUJ5uI6
   hZtppbKTCeR+tCCyJGxY18D3rMdnfsnAlGhD2gV4tb/cLnKdDPFkKtPvp
   KBvbxaQL49s0UOeLOe8dmvZU3yBzpvMxG1vKQ+6QLclq/6tH6/ic8rMnW
   g==;
X-CSE-ConnectionGUID: svov/p/RTfW0USz5Y3T1ag==
X-CSE-MsgGUID: TS7vAE3/QfetiKNCExzxFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469587"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469587"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:13 -0700
X-CSE-ConnectionGUID: +3/3HY4HTTyBgMc6RQYrTA==
X-CSE-MsgGUID: a5DOmGYPTyK8ibVFS7uT0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882927"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: mvm: validate monitor notif link_id
Date: Tue, 14 Jul 2026 14:32:33 +0300
Message-Id: <20260714143119.7601d05649a4.I237f58a007af761468057c9c09039953a3bb37da@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

MONITOR_NOTIF link_id is firmware-provided. Validate link_id range
with IWL_FW_CHECK before vif lookup. Payload length is already
checked by RX_HANDLER.
Use iwl_mvm_rcu_dereference_vif_id which does all we need which allows
us to drop iwl_mvm_get_vif_by_macid.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  4 +--
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 30 -------------------
 3 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4420005ef69e..979b39314981 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2405,7 +2405,6 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 				     bool sync,
 				     const void *data, u32 size);
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
-struct ieee80211_vif *iwl_mvm_get_vif_by_macid(struct iwl_mvm *mvm, u32 macid);
 bool iwl_mvm_is_vif_assoc(struct iwl_mvm *mvm);
 
 #define MVM_TCM_PERIOD_MSEC 500
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 2297392db955..f43895c2f3c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -155,8 +155,8 @@ static void iwl_mvm_rx_monitor_notif(struct iwl_mvm *mvm,
 	if (notif->type != cpu_to_le32(IWL_DP_MON_NOTIF_TYPE_EXT_CCA))
 		return;
 
-	/* FIXME: should fetch the link and not the vif */
-	vif = iwl_mvm_get_vif_by_macid(mvm, notif->link_id);
+	/* mac_id = link_id since we don't support MLO */
+	vif = iwl_mvm_rcu_dereference_vif_id(mvm, notif->link_id, false);
 	if (!vif || vif->type != NL80211_IFTYPE_STATION)
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 7eae10982869..2fd4a9961145 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -689,36 +689,6 @@ struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm)
 	return bss_iter_data.vif;
 }
 
-struct iwl_bss_find_iter_data {
-	struct ieee80211_vif *vif;
-	u32 macid;
-};
-
-static void iwl_mvm_bss_find_iface_iterator(void *_data, u8 *mac,
-					    struct ieee80211_vif *vif)
-{
-	struct iwl_bss_find_iter_data *data = _data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	if (mvmvif->id == data->macid)
-		data->vif = vif;
-}
-
-struct ieee80211_vif *iwl_mvm_get_vif_by_macid(struct iwl_mvm *mvm, u32 macid)
-{
-	struct iwl_bss_find_iter_data data = {
-		.macid = macid,
-	};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_bss_find_iface_iterator, &data);
-
-	return data.vif;
-}
-
 struct iwl_sta_iter_data {
 	bool assoc;
 };
-- 
2.34.1

