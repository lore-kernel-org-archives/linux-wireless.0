Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59437 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbaKJJYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:24:16 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:18 +0200
Message-Id: <1415610621-27438-14-git-send-email-luca@coelho.fi> (sfid-20141110_102420_787997_F6C59EB7)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 13/16] iwlwifi: mvm: disable beacon filtering during CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

After a channel switch, transmission on the new channel is only
started once we see a beacon on it.  Thus, beacon filtering needs to
be disabled during channel switch so that mac80211 receives this
beacon and finishes the process.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 55ab81e..7c031ee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3079,6 +3079,12 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		iwl_mvm_schedule_csa_period(mvm, vif, vif->bss_conf.beacon_int,
 					    apply_time);
+		if (mvmvif->bf_data.bf_enabled) {
+			ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
+			if (ret)
+				goto out_unlock;
+		}
+
 		break;
 	default:
 		break;
@@ -3119,6 +3125,10 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
 
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
+		if (ret)
+			goto out_unlock;
 	}
 
 	mvmvif->ps_disabled = false;
-- 
2.1.1

