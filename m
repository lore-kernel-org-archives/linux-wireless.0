Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1752BC4332F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Nov 2021 06:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E648B60C4B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Nov 2021 06:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhKLGbX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Nov 2021 01:31:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:56660 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231802AbhKLGbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Nov 2021 01:31:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="213119365"
X-IronPort-AV: E=Sophos;i="5.87,228,1631602800"; 
   d="scan'208";a="213119365"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 22:28:31 -0800
X-IronPort-AV: E=Sophos;i="5.87,228,1631602800"; 
   d="scan'208";a="492865294"
Received: from cohendro-mobl2.ger.corp.intel.com (HELO egrumbac-mobl1.intel.com) ([10.255.199.64])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 22:28:30 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v8 6/6] iwlwifi: mvm: read the rfkill state and feed it to iwlmei
Date:   Fri, 12 Nov 2021 08:28:14 +0200
Message-Id: <20211112062814.7502-6-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211112062814.7502-1-emmanuel.grumbach@intel.com>
References: <20211112062814.7502-1-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Read the rfkill state upon boot, mac start and mac stop.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 8 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9a666cc259f4..20422e640059 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1148,6 +1148,8 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 	ret = __iwl_mvm_mac_start(mvm);
 	mutex_unlock(&mvm->mutex);
 
+	iwl_mvm_mei_set_sw_rfkill_state(mvm);
+
 	return ret;
 }
 
@@ -1265,6 +1267,8 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	 */
 	flush_work(&mvm->roc_done_wk);
 
+	iwl_mvm_mei_set_sw_rfkill_state(mvm);
+
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_mac_stop(mvm);
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 34b4a280a293..64ff2395800c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2218,10 +2218,14 @@ static inline void iwl_mvm_mei_device_down(struct iwl_mvm *mvm)
 		iwl_mei_device_down();
 }
 
-static inline void iwl_mvm_mei_set_sw_rfkill_state(struct iwl_mvm *mvm, bool sw_rfkill)
+static inline void iwl_mvm_mei_set_sw_rfkill_state(struct iwl_mvm *mvm)
 {
+	bool sw_rfkill =
+		mvm->hw_registered ? rfkill_blocked(mvm->hw->wiphy->rfkill) : false;
+
 	if (mvm->mei_registered)
-		iwl_mei_set_rfkill_state(iwl_mvm_is_radio_killed(mvm), sw_rfkill);
+		iwl_mei_set_rfkill_state(iwl_mvm_is_radio_killed(mvm),
+					 sw_rfkill);
 }
 
 void iwl_mvm_send_roaming_forbidden_event(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 82fea029d4d0..3ab0217abeea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -756,6 +756,9 @@ static int iwl_mvm_start_post_nvm(struct iwl_mvm *mvm)
 	wiphy_rfkill_set_hw_state_reason(mvm->hw->wiphy,
 					 mvm->mei_rfkill_blocked,
 					 RFKILL_HARD_BLOCK_NOT_OWNER);
+
+	iwl_mvm_mei_set_sw_rfkill_state(mvm);
+
 	return 0;
 }
 
-- 
2.25.1

