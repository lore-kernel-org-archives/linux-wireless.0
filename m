Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34370 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbbH0K5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 06:57:32 -0400
Received: by igui7 with SMTP id i7so58320633igu.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 03:57:31 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath10k: implement mesh support
Date: Thu, 27 Aug 2015 06:57:04 -0400
Message-Id: <1440673024-13696-4-git-send-email-me@bobcopeland.com> (sfid-20150827_125741_652978_9597AC08)
In-Reply-To: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for mesh to ath10k.  We simply use an AP virtual interface
in the firmware in order to enable beaconing without TSF adoption, and
use the raw (802.11) transmit mode.

Due to firmware limitations, the firmware must operate in raw
(non-native 802.11) mode.  As this is configured at firmware init time,
a new "rawmode" modparam is added, and mesh interfaces are available
only if rawmode=true.  The firmware must advertise support for rawmode
(tested successfully with firmware 10.2.4.70-2).

When loaded with rawmode=1, ath10k can operate an open mesh STA via
something like the following:

    ip link set wlan0 down
    iw dev wlan0 set type mp
    ip link set wlan0 up
    iw dev wlan0 set freq 5745 80 5775
    iw dev wlan0 mesh join mesh-vht

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Since ath10k ml posting:
 * added raw mode feature flag check
 * usage and firmware notes in commit log

 drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b87b986..9dafe25 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -34,16 +34,19 @@ unsigned int ath10k_debug_mask;
 static unsigned int ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
+static bool rawmode;
 
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
 module_param_named(cryptmode, ath10k_cryptmode_param, uint, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);
+module_param(rawmode, bool, 0644);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
+MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
@@ -1117,6 +1120,15 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
 	ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
 
+	if (rawmode) {
+		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
+			      ar->fw_features)) {
+			ath10k_err(ar, "rawmode = 1 requires support from firmware");
+			return -EINVAL;
+		}
+		set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
+	}
+
 	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
 		ar->wmi.rx_decap_mode = ATH10K_HW_TXRX_RAW;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7dfe37f..b0f1594 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4176,6 +4176,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_ADHOC:
 		arvif->vdev_type = WMI_VDEV_TYPE_IBSS;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+			ret = -EINVAL;
+			ath10k_warn(ar, "must load driver with rawmode=1 to add mesh interfaces\n");
+			goto err;
+		}
+		arvif->vdev_type = WMI_VDEV_TYPE_AP;
+		break;
 	case NL80211_IFTYPE_AP:
 		arvif->vdev_type = WMI_VDEV_TYPE_AP;
 
@@ -4216,6 +4224,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	 * become corrupted, e.g. have garbled IEs or out-of-date TIM bitmap.
 	 */
 	if (vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_MESH_POINT ||
 	    vif->type == NL80211_IFTYPE_AP) {
 		arvif->beacon_buf = dma_zalloc_coherent(ar->dev,
 							IEEE80211_MAX_FRAME_LEN,
@@ -4555,6 +4564,13 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn(ar, "failed to update beacon template: %d\n",
 				    ret);
+
+		if (ieee80211_vif_is_mesh(vif)) {
+			/* mesh doesn't use SSID but firmware needs it */
+			strncpy(arvif->u.ap.ssid, "mesh",
+				sizeof(arvif->u.ap.ssid));
+			arvif->u.ap.ssid_len = 4;
+		}
 	}
 
 	if (changed & BSS_CHANGED_AP_PROBE_RESP) {
@@ -5294,6 +5310,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_MESH_POINT ||
 		    vif->type == NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * New association.
@@ -5329,6 +5346,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		    new_state == IEEE80211_STA_AUTH &&
 		    (vif->type == NL80211_IFTYPE_AP ||
+		     vif->type == NL80211_IFTYPE_MESH_POINT ||
 		     vif->type == NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * Disassociation.
@@ -6642,14 +6660,16 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	},
 	{
 	.max	= 7,
-	.types	= BIT(NL80211_IFTYPE_AP)
+	.types	= BIT(NL80211_IFTYPE_AP) |
+		  BIT(NL80211_IFTYPE_MESH_POINT)
 	},
 };
 
 static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
 	{
 	.max	= 8,
-	.types	= BIT(NL80211_IFTYPE_AP)
+	.types	= BIT(NL80211_IFTYPE_AP) |
+		  BIT(NL80211_IFTYPE_MESH_POINT)
 	},
 };
 
@@ -6688,7 +6708,8 @@ static const struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
 		.max = 2,
 		.types = BIT(NL80211_IFTYPE_AP) |
 			 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			 BIT(NL80211_IFTYPE_P2P_GO),
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_MESH_POINT)
 	},
 	{
 		.max = 1,
@@ -6708,7 +6729,8 @@ static const struct ieee80211_iface_limit ath10k_tlv_qcs_if_limit[] = {
 	{
 		.max = 1,
 		.types = BIT(NL80211_IFTYPE_AP) |
-			 BIT(NL80211_IFTYPE_P2P_GO),
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_MESH_POINT),
 	},
 	{
 		.max = 1,
@@ -6998,7 +7020,8 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_AP);
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
 
 	ar->hw->wiphy->available_antennas_rx = ar->supp_rx_chainmask;
 	ar->hw->wiphy->available_antennas_tx = ar->supp_tx_chainmask;
-- 
2.1.4

