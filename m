Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61971 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBCU7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:06 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so3974833ead.8
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:05 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/62] iwlwifi: mvm: fix quota allocation
Date: Mon,  3 Feb 2014 22:57:37 +0200
Message-Id: <1391461088-8082-31-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_036378_EA954C65)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Divide the maximal quota between all the data interfaces even in the
case of a single low latency binding without any other non low latency
interfaces, so that afterwards the quota allocation (which considers
the number of data interfaces) will be correct.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c |   36 +++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index f07ae48..06d8429 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -234,15 +234,24 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 				break;
 			}
 		}
-		if (n_non_lowlat) {
-			quota = (QUOTA_100 - QUOTA_LOWLAT_MIN) / n_non_lowlat;
-			quota_rem = QUOTA_100 - n_non_lowlat * quota -
-				    QUOTA_LOWLAT_MIN;
-		} else {
-			quota = QUOTA_100;
-			quota_rem = 0;
-		}
+	}
+
+	if (data.n_low_latency_bindings == 1 && n_non_lowlat) {
+		/*
+		 * Reserve quota for the low latency binding in case that
+		 * there are several data bindings but only a single
+		 * low latency one. Split the rest of the quota equally
+		 * between the other data interfaces.
+		 */
+		quota = (QUOTA_100 - QUOTA_LOWLAT_MIN) / n_non_lowlat;
+		quota_rem = QUOTA_100 - n_non_lowlat * quota -
+			    QUOTA_LOWLAT_MIN;
 	} else if (num_active_macs) {
+		/*
+		 * There are 0 or more than 1 low latency bindings, or all the
+		 * data interfaces belong to the single low latency binding.
+		 * Split the quota equally between the data interfaces.
+		 */
 		quota = QUOTA_100 / num_active_macs;
 		quota_rem = QUOTA_100 % num_active_macs;
 	} else {
@@ -262,11 +271,22 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 			cmd.quotas[idx].quota = cpu_to_le32(0);
 		else if (data.n_low_latency_bindings == 1 && n_non_lowlat &&
 			 data.low_latency[i])
+			/*
+			 * There is more than one binding, but only one of the
+			 * bindings is in low latency. For this case, allocate
+			 * the minimal required quota for the low latency
+			 * binding.
+			 */
 			cmd.quotas[idx].quota = cpu_to_le32(QUOTA_LOWLAT_MIN);
+
 		else
 			cmd.quotas[idx].quota =
 				cpu_to_le32(quota * data.n_interfaces[i]);
 
+		WARN_ONCE(le32_to_cpu(cmd.quotas[idx].quota) > QUOTA_100,
+			  "Binding=%d, quota=%u > max=%u\n",
+			  idx, le32_to_cpu(cmd.quotas[idx].quota), QUOTA_100);
+
 		if (data.n_interfaces[i] && !data.low_latency[i])
 			cmd.quotas[idx].max_duration =
 				cpu_to_le32(ll_max_duration);
-- 
1.7.9.5

