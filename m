Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24348 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdBWNTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 08:19:34 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2] ath10k: Update available channel list for 5G radio
Date: Thu, 23 Feb 2017 18:48:22 +0530
Message-ID: <1487855902-32090-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170223_141938_403731_D2FFD25B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

If a 5 GHz radio is calibrated for operation in both
the low band (channels 36 to 64) and high band(channels 100 to 169),
hardware allows operations in all the listed channels. However,
if the chip has been calibrated only for the low/high band and
a high/low band channel is configured, due to lack of calibration
there will be potentially invalid signal on those non calibrated channels.
To avoid this problem this patch sets IEEE80211_CHAN_DISABLED flag for
those non calibrated channels by using low_5ghz_chan and high_5ghz_chan
values which we get from target through wmi service ready event.

Driver initialized flags are getting re initialized in handle_channel
in cfg80211. So calling the function to disable the non supported channel
from reg_notifier().

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
v2:
  * Removed two separate arrays for channel list, and changed logic
    to disable non calibrated channels.

 drivers/net/wireless/ath/ath10k/core.h |    2 ++
 drivers/net/wireless/ath/ath10k/mac.c  |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |    6 ++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |    2 ++
 4 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 88d14be..d4b9a0e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -775,6 +775,8 @@ struct ath10k {
 	u32 num_rf_chains;
 	u32 max_spatial_stream;
 	/* protected by conf_mutex */
+	u32 low_5ghz_chan;
+	u32 high_5ghz_chan;
 	bool ani_enabled;
 
 	bool p2p;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index abc291d..c5b6c2a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3126,6 +3126,21 @@ static void ath10k_regd_update(struct ath10k *ar)
 		ath10k_warn(ar, "failed to set pdev regdomain: %d\n", ret);
 }
 
+void ath10k_mac_update_channel_list(struct ath10k *ar,
+				    struct ieee80211_supported_band *band)
+{
+	int i;
+
+	if (ar->low_5ghz_chan && ar->high_5ghz_chan) {
+		for (i = 0; i < band->n_channels; i++) {
+			if (band->channels[i].center_freq < ar->low_5ghz_chan ||
+			    band->channels[i].center_freq > ar->high_5ghz_chan)
+				band->channels[i].flags |=
+					IEEE80211_CHAN_DISABLED;
+		}
+	}
+}
+
 static void ath10k_reg_notifier(struct wiphy *wiphy,
 				struct regulatory_request *request)
 {
@@ -3149,6 +3164,10 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 	if (ar->state == ATH10K_STATE_ON)
 		ath10k_regd_update(ar);
 	mutex_unlock(&ar->conf_mutex);
+
+	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY)
+		ath10k_mac_update_channel_list(ar,
+				ar->hw->wiphy->bands[NL80211_BAND_5GHZ]);
 }
 
 /***************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2f1743e..b31c4f7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4593,6 +4593,8 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	arg->phy_capab = ev->phy_capability;
 	arg->num_rf_chains = ev->num_rf_chains;
 	arg->eeprom_rd = ev->hal_reg_capabilities.eeprom_rd;
+	arg->low_5ghz_chan = ev->hal_reg_capabilities.low_5ghz_chan;
+	arg->high_5ghz_chan = ev->hal_reg_capabilities.high_5ghz_chan;
 	arg->num_mem_reqs = ev->num_mem_reqs;
 	arg->service_map = ev->wmi_service_bitmap;
 	arg->service_map_len = sizeof(ev->wmi_service_bitmap);
@@ -4629,6 +4631,8 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	arg->phy_capab = ev->phy_capability;
 	arg->num_rf_chains = ev->num_rf_chains;
 	arg->eeprom_rd = ev->hal_reg_capabilities.eeprom_rd;
+	arg->low_5ghz_chan = ev->hal_reg_capabilities.low_5ghz_chan;
+	arg->high_5ghz_chan = ev->hal_reg_capabilities.high_5ghz_chan;
 	arg->num_mem_reqs = ev->num_mem_reqs;
 	arg->service_map = ev->wmi_service_bitmap;
 	arg->service_map_len = sizeof(ev->wmi_service_bitmap);
@@ -4682,6 +4686,8 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	ar->phy_capability = __le32_to_cpu(arg.phy_capab);
 	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
 	ar->hw_eeprom_rd = __le32_to_cpu(arg.eeprom_rd);
+	ar->low_5ghz_chan = __le32_to_cpu(arg.low_5ghz_chan);
+	ar->high_5ghz_chan = __le32_to_cpu(arg.high_5ghz_chan);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			arg.service_map, arg.service_map_len);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 386aa51..78350d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6335,6 +6335,8 @@ struct wmi_svc_rdy_ev_arg {
 	__le32 num_rf_chains;
 	__le32 eeprom_rd;
 	__le32 num_mem_reqs;
+	__le32 low_5ghz_chan;
+	__le32 high_5ghz_chan;
 	const __le32 *service_map;
 	size_t service_map_len;
 	const struct wlan_host_mem_req *mem_reqs[WMI_MAX_MEM_REQS];
-- 
1.7.9.5
