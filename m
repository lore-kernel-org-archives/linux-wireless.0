Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbcCIRqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/21] iwlwifi: mvm: turn off AMSDU bit in QoS control for de-aggregated AMSDUs
Date: Wed,  9 Mar 2016 19:45:39 +0200
Message-Id: <1457545550-30677-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185950_790835_ECE05DB2)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Our hardware de-aggregates AMSDUs but copies the mac header
as it to the de-aggregated MPDUs. We need to turn off the AMSDU
bit in the QoS control ourselves.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index cd6ca37..9a54f2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -519,6 +519,18 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			rcu_read_unlock();
 			return;
 		}
+
+		/*
+		 * Our hardware de-aggregates AMSDUs but copies the mac header
+		 * as it to the de-aggregated MPDUs. We need to turn off the
+		 * AMSDU bit in the QoS control ourselves.
+		 */
+		if ((desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU) &&
+		    !WARN_ON(!ieee80211_is_data_qos(hdr->frame_control))) {
+			u8 *qc = ieee80211_get_qos_ctl(hdr);
+
+			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+		}
 	}
 
 	/*
-- 
2.5.0

