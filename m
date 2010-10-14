Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0JNSET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:19 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/9] iwlwifi: allow probe-after-rx on 2.4 GHz
Date: Thu, 14 Oct 2010 11:02:43 -0700
Message-Id: <1287079370-20587-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are two passive 2.4 GHz channels: 12 and 13.
If you have a hidden SSID on those, you will not
be able to connect to it because we don't send out
probe requests there. We can allow this by using
the firmware's probe-after-rx functionality on
those channels as well.

This fixes
https://bugzilla.kernel.org/show_bug.cgi?id=16462

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   40 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 +++++-----
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c1a3898..b555edd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1447,35 +1447,35 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		if (priv->cfg->bt_params &&
 		    priv->cfg->bt_params->advanced_bt_coexist)
 			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
-		scan->good_CRC_th = IWL_GOOD_CRC_TH_DISABLED;
 		break;
 	case IEEE80211_BAND_5GHZ:
 		rate = IWL_RATE_6M_PLCP;
-		/*
-		 * If active scanning is requested but a certain channel is
-		 * marked passive, we can do active scanning if we detect
-		 * transmissions.
-		 *
-		 * There is an issue with some firmware versions that triggers
-		 * a sysassert on a "good CRC threshold" of zero (== disabled),
-		 * on a radar channel even though this means that we should NOT
-		 * send probes.
-		 *
-		 * The "good CRC threshold" is the number of frames that we
-		 * need to receive during our dwell time on a channel before
-		 * sending out probes -- setting this to a huge value will
-		 * mean we never reach it, but at the same time work around
-		 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
-		 * here instead of IWL_GOOD_CRC_TH_DISABLED.
-		 */
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-						IWL_GOOD_CRC_TH_NEVER;
 		break;
 	default:
 		IWL_WARN(priv, "Invalid scan band\n");
 		return -EIO;
 	}
 
+	/*
+	 * If active scanning is requested but a certain channel is
+	 * marked passive, we can do active scanning if we detect
+	 * transmissions.
+	 *
+	 * There is an issue with some firmware versions that triggers
+	 * a sysassert on a "good CRC threshold" of zero (== disabled),
+	 * on a radar channel even though this means that we should NOT
+	 * send probes.
+	 *
+	 * The "good CRC threshold" is the number of frames that we
+	 * need to receive during our dwell time on a channel before
+	 * sending out probes -- setting this to a huge value will
+	 * mean we never reach it, but at the same time work around
+	 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
+	 * here instead of IWL_GOOD_CRC_TH_DISABLED.
+	 */
+	scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+					IWL_GOOD_CRC_TH_NEVER;
+
 	band = priv->scan_band;
 
 	if (priv->cfg->scan_rx_antennas[band])
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 980c609..3ee3e55 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2938,18 +2938,10 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate = IWL_RATE_1M_PLCP;
-		scan->good_CRC_th = 0;
 		band = IEEE80211_BAND_2GHZ;
 		break;
 	case IEEE80211_BAND_5GHZ:
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
-		/*
-		 * If active scaning is requested but a certain channel
-		 * is marked passive, we can do active scanning if we
-		 * detect transmissions.
-		 */
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-						IWL_GOOD_CRC_TH_DISABLED;
 		band = IEEE80211_BAND_5GHZ;
 		break;
 	default:
@@ -2957,6 +2949,14 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		return -EIO;
 	}
 
+	/*
+	 * If active scaning is requested but a certain channel
+	 * is marked passive, we can do active scanning if we
+	 * detect transmissions.
+	 */
+	scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+					IWL_GOOD_CRC_TH_DISABLED;
+
 	if (!priv->is_internal_short_scan) {
 		scan->tx_cmd.len = cpu_to_le16(
 			iwl_fill_probe_req(priv,
-- 
1.7.0.4

