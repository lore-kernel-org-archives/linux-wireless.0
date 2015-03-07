Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:55939 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbCGCkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 21:40:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <874mpy2gw5.fsf@kamboji.qca.qualcomm.com>
	<87fv9h7cwl.fsf@x220.int.ebiederm.org>
Date: Fri, 06 Mar 2015 20:36:34 -0600
In-Reply-To: <87fv9h7cwl.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 06 Mar 2015 20:35:22 -0600")
Message-ID: <87bnk57cul.fsf_-_@x220.int.ebiederm.org> (sfid-20150307_034021_884086_17C2A473)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Subject: [PATCH 1/2] iwlwifi: mvm: Fix the build of mvm/mac-ctxt.c with debugfs disabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


When attempting to build my kernel I get:
  CC      drivers/net/wireless/iwlwifi/mvm/mac-ctxt.o
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c: In function ‘iwl_mvm_beacon_loss_iterator’:
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1378:30: error: ‘struct iwl_mvm_vif’ has no member named ‘mvm’

Fix that by making the new code depend on IWLWIFI_DEBUGFS as the
definition of mvm in struct iwl_mvm_if does.

Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: 9d761fd8a58360e iwlwifi: mvm: add trigger for firmware dump upon missed beacons
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 581b3b8f29f9..7ad736ff90ff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1375,18 +1375,21 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 {
 	struct iwl_missed_beacons_notif *missed_beacons = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct iwl_mvm *mvm = mvmvif->mvm;
 	struct iwl_fw_dbg_trigger_missed_bcon *bcon_trig;
 	struct iwl_fw_dbg_trigger_tlv *trigger;
 	u32 stop_trig_missed_bcon, stop_trig_missed_bcon_since_rx;
 	u32 rx_missed_bcon, rx_missed_bcon_since_rx;
+#endif
 
 	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
 		return;
-
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	rx_missed_bcon = le32_to_cpu(missed_beacons->consec_missed_beacons);
 	rx_missed_bcon_since_rx =
 		le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx);
+#endif
 	/*
 	 * TODO: the threshold should be adjusted based on latency conditions,
 	 * and/or in case of a CS flow on one of the other AP vifs.
@@ -1395,6 +1398,7 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (!iwl_fw_dbg_trigger_enabled(mvm->fw,
 					FW_DBG_TRIGGER_MISSED_BEACONS))
 		return;
@@ -1414,6 +1418,7 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
 		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
 int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
-- 
2.2.1

