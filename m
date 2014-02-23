Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48225 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaBWT5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:32 -0500
Received: by mail-we0-f172.google.com with SMTP id u56so4100314wes.17
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/17] iwlwifi: mvm: set immediate apply time bit in time events
Date: Sun, 23 Feb 2014 21:57:03 +0200
Message-Id: <1393185428-8524-12-git-send-email-egrumbach@gmail.com> (sfid-20140223_205736_449360_BF545194)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Newer firmware support a new bit in the policy  that allows
to request to apply the time event immediately. Add this bit
without removing the workarounds we used until now to support
older firmares.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |    1 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 4d808a9..807fa52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -712,6 +712,7 @@ enum {
 	TE_V2_NOTIF_HOST_FRAG_END = BIT(5),
 	TE_V2_NOTIF_INTERNAL_FRAG_START = BIT(6),
 	TE_V2_NOTIF_INTERNAL_FRAG_END = BIT(7),
+	T2_V2_START_IMMEDIATELY = BIT(11),
 
 	TE_V2_NOTIF_MSK = 0xff,
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index e145dd4..6133124 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -438,7 +438,8 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	time_cmd.duration = cpu_to_le32(duration);
 	time_cmd.repeat = 1;
 	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
-				      TE_V2_NOTIF_HOST_EVENT_END);
+				      TE_V2_NOTIF_HOST_EVENT_END |
+				      T2_V2_START_IMMEDIATELY);
 
 	iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
@@ -553,7 +554,8 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	time_cmd.duration = cpu_to_le32(MSEC_TO_TU(duration));
 	time_cmd.repeat = 1;
 	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
-				      TE_V2_NOTIF_HOST_EVENT_END);
+				      TE_V2_NOTIF_HOST_EVENT_END |
+				      T2_V2_START_IMMEDIATELY);
 
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
-- 
1.7.9.5

