Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754480AbdHYCbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:05 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 19/27] qtnfmac: initialize HT/VHT caps "can override" masks
Date: Thu, 24 Aug 2017 19:30:16 -0700
Message-Id: <20170825023024.10565-20-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043111_384016_D1CFDD81)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Information on which HT/VHT capabilities can be overridden is reported
per-MAC by wireless device.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 ++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 7 ++++---
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 4 ++--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 8 ++++----
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 28612da..d6780f42 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -913,6 +913,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->available_antennas_rx = mac->macinfo.num_rx_chain;
 
 	wiphy->max_ap_assoc_sta = mac->macinfo.max_ap_assoc_sta;
+	wiphy->ht_capa_mod_mask = &mac->macinfo.ht_cap_mod_mask;
+	wiphy->vht_capa_mod_mask = &mac->macinfo.vht_cap_mod_mask;
 
 	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 065a93f..b26cd01 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1108,9 +1108,10 @@ qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
 			qlink_chan_width_mask_to_nl(le16_to_cpu(
 					resp_info->radar_detect_widths));
 
-	memcpy(&mac_info->ht_cap, &resp_info->ht_cap, sizeof(mac_info->ht_cap));
-	memcpy(&mac_info->vht_cap, &resp_info->vht_cap,
-	       sizeof(mac_info->vht_cap));
+	memcpy(&mac_info->ht_cap_mod_mask, &resp_info->ht_cap_mod_mask,
+	       sizeof(mac_info->ht_cap_mod_mask));
+	memcpy(&mac_info->vht_cap_mod_mask, &resp_info->vht_cap_mod_mask,
+	       sizeof(mac_info->vht_cap_mod_mask));
 }
 
 static void qtnf_cmd_resp_band_fill_htcap(const u8 *info,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 44a2cbb..3e74736 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -103,8 +103,8 @@ struct qtnf_mac_info {
 	u8 sretry_limit;
 	u8 coverage_class;
 	u8 radar_detect_widths;
-	struct ieee80211_ht_cap ht_cap;
-	struct ieee80211_vht_cap vht_cap;
+	struct ieee80211_ht_cap ht_cap_mod_mask;
+	struct ieee80211_vht_cap vht_cap_mod_mask;
 	struct ieee80211_iface_limit *limits;
 	size_t n_limits;
 };
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index de0e5b9..a9f410b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -627,8 +627,8 @@ struct qlink_resp {
  *	specified WMAC).
  * @num_tx_chain: Number of transmit chains used by WMAC.
  * @num_rx_chain: Number of receive chains used by WMAC.
- * @vht_cap: VHT capabilities.
- * @ht_cap: HT capabilities.
+ * @vht_cap_mod_mask: mask specifying which VHT capabilities can be altered.
+ * @ht_cap_mod_mask: mask specifying which HT capabilities can be altered.
  * @bands_cap: wireless bands WMAC can operate in, bitmap of &enum qlink_band.
  * @phymode_cap: PHY modes WMAC can operate in, bitmap of &enum qlink_phy_mode.
  * @max_ap_assoc_sta: Maximum number of associations supported by WMAC.
@@ -640,8 +640,8 @@ struct qlink_resp_get_mac_info {
 	u8 dev_mac[ETH_ALEN];
 	u8 num_tx_chain;
 	u8 num_rx_chain;
-	struct ieee80211_vht_cap vht_cap;
-	struct ieee80211_ht_cap ht_cap;
+	struct ieee80211_vht_cap vht_cap_mod_mask;
+	struct ieee80211_ht_cap ht_cap_mod_mask;
 	u8 bands_cap;
 	u8 phymode_cap;
 	__le16 max_ap_assoc_sta;
-- 
2.9.5
