Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46082 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaKXOgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:36 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so6008447wiw.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 61/75] iwlwifi: mvm: disable beacon filtering during CSA
Date: Mon, 24 Nov 2014 16:34:37 +0200
Message-Id: <1416839691-28533-61-git-send-email-egrumbach@gmail.com> (sfid-20141124_153642_863054_CF02FE8A)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 7acdfa7..a62014e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3206,6 +3206,12 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
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
@@ -3246,6 +3252,10 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
 
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
+		if (ret)
+			goto out_unlock;
 	}
 
 	mvmvif->ps_disabled = false;
-- 
1.9.1

