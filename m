Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbcCBH5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/43] iwlwifi: mvm: update rx_status with mactime flag
Date: Wed,  2 Mar 2016 09:56:21 +0200
Message-Id: <1456905404-14435-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_565178_97C14F6B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When forming IBSS, mac80211 scans in order to find an already
existing cell to join.
In case the scan does not find any existing cell a new IBSS
cell is formed.
When receiving the beacons of another IBSS cell we should
merge if the other IBSS cell's TSF is higher than ours.
However, currently iwlmvm does not set any timestamp flag in
rx_status so there is no valid rx timestamp to compare the
beacon's TSF to.
The reason for that is that TSF as indicated by the firmware
is at INA time, but up till now mac80211 expected the TSF at
the beginning or end of the MPDU.
Set the flag to the newly added RX_FLAG_MACTIME_PLCP_START flag.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       | 8 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 2 ++
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 535134d..e885db3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1484,6 +1484,8 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	/* update rx_status according to the notification's metadata */
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.mactime = le64_to_cpu(sb->tsf);
+	/* TSF as indicated by the firmware  is at INA time */
+	rx_status.flag |= RX_FLAG_MACTIME_PLCP_START;
 	rx_status.device_timestamp = le32_to_cpu(sb->system_time);
 	rx_status.band =
 		(sb->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 055a8b0..ad625f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -322,11 +322,9 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_status->freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_info->channel),
 					       rx_status->band);
-	/*
-	 * TSF as indicated by the fw is at INA time, but mac80211 expects the
-	 * TSF at the beginning of the MPDU.
-	 */
-	/*rx_status->flag |= RX_FLAG_MACTIME_MPDU;*/
+
+	/* TSF as indicated by the firmware  is at INA time */
+	rx_status->flag |= RX_FLAG_MACTIME_PLCP_START;
 
 	iwl_mvm_get_signal_strength(mvm, phy_info, rx_status);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 615dea1..a9180b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -332,6 +332,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_status->freq = ieee80211_channel_to_frequency(desc->channel,
 							 rx_status->band);
 	iwl_mvm_get_signal_strength(mvm, desc, rx_status);
+	/* TSF as indicated by the firmware is at INA time */
+	rx_status->flag |= RX_FLAG_MACTIME_PLCP_START;
 
 	rcu_read_lock();
 
-- 
2.5.0

