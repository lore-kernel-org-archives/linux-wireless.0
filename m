Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37461 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaKXOfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:15 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so9029917wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/75] iwlwifi: mvm: refactor temperature notification handling
Date: Mon, 24 Nov 2014 16:33:48 +0200
Message-Id: <1416839691-28533-12-git-send-email-egrumbach@gmail.com> (sfid-20141124_153527_942045_6319A68D)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Refactor the temperature handling code so that it is easier to reuse
it with other notification flows.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/rx.c  | 23 +--------------
 drivers/net/wireless/iwlwifi/mvm/tt.c  | 51 ++++++++++++++++++++++++++--------
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e56abdd..9ac2d4c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1210,6 +1210,7 @@ bool iwl_mvm_is_idle(struct iwl_mvm *mvm);
 
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
+void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 3cf40f3..93d5b69 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -500,29 +500,8 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 		.mvm = mvm,
 	};
 
-	/*
-	 * set temperature debug enabled - ignore FW temperature updates
-	 * and use the user set temperature.
-	 */
-	if (mvm->temperature_test) {
-		if (mvm->temperature < le32_to_cpu(common->temperature))
-			IWL_DEBUG_TEMP(mvm,
-				       "Ignoring FW temperature update that is greater than the debug set temperature (debug temp = %d, fw temp = %d)\n",
-				       mvm->temperature,
-				       le32_to_cpu(common->temperature));
-		/*
-		 * skip iwl_mvm_tt_handler since we are in
-		 * temperature debug mode and we are ignoring
-		 * the new temperature value
-		 */
-		goto update;
-	}
+	iwl_mvm_tt_temp_changed(mvm, le32_to_cpu(common->temperature));
 
-	if (mvm->temperature != le32_to_cpu(common->temperature)) {
-		mvm->temperature = le32_to_cpu(common->temperature);
-		iwl_mvm_tt_handler(mvm);
-	}
-update:
 	iwl_mvm_update_rx_statistics(mvm, stats);
 
 	ieee80211_iterate_active_interfaces(mvm->hw,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index d4f2c29..35acf00 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -95,29 +95,58 @@ static void iwl_mvm_exit_ctkill(struct iwl_mvm *mvm)
 	iwl_mvm_set_hw_ctkill_state(mvm, false);
 }
 
-static bool iwl_mvm_temp_notif(struct iwl_notif_wait_data *notif_wait,
-			       struct iwl_rx_packet *pkt, void *data)
+void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp)
+{
+	/* ignore the notification if we are in test mode */
+	if (mvm->temperature_test)
+		return;
+
+	if (mvm->temperature == temp)
+		return;
+
+	mvm->temperature = temp;
+	iwl_mvm_tt_handler(mvm);
+}
+
+static int iwl_mvm_temp_notif_parse(struct iwl_mvm *mvm,
+				    struct iwl_rx_packet *pkt)
 {
-	struct iwl_mvm *mvm =
-		container_of(notif_wait, struct iwl_mvm, notif_wait);
-	int *temp = data;
 	struct iwl_dts_measurement_notif *notif;
 	int len = iwl_rx_packet_payload_len(pkt);
+	int temp;
 
 	if (WARN_ON_ONCE(len != sizeof(*notif))) {
 		IWL_ERR(mvm, "Invalid DTS_MEASUREMENT_NOTIFICATION\n");
-		return true;
+		return -EINVAL;
 	}
 
 	notif = (void *)pkt->data;
 
-	*temp = le32_to_cpu(notif->temp);
+	temp = le32_to_cpu(notif->temp);
 
 	/* shouldn't be negative, but since it's s32, make sure it isn't */
-	if (WARN_ON_ONCE(*temp < 0))
-		*temp = 0;
+	if (WARN_ON_ONCE(temp < 0))
+		temp = 0;
+
+	IWL_DEBUG_TEMP(mvm, "DTS_MEASUREMENT_NOTIFICATION - %d\n", temp);
+
+	return temp;
+}
+
+static bool iwl_mvm_temp_notif_wait(struct iwl_notif_wait_data *notif_wait,
+				    struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	int *temp = data;
+	int ret;
+
+	ret = iwl_mvm_temp_notif_parse(mvm, pkt);
+	if (ret < 0)
+		return true;
+
+	*temp = ret;
 
-	IWL_DEBUG_TEMP(mvm, "DTS_MEASUREMENT_NOTIFICATION - %d\n", *temp);
 	return true;
 }
 
@@ -141,7 +170,7 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_temp_notif,
 				   temp_notif, ARRAY_SIZE(temp_notif),
-				   iwl_mvm_temp_notif, &temp);
+				   iwl_mvm_temp_notif_wait, &temp);
 
 	ret = iwl_mvm_get_temp_cmd(mvm);
 	if (ret) {
-- 
1.9.1

