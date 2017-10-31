Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751776AbdJaBFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:05 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 2/9] qtnfmac: initialize HT/VHT caps "can override" masks
Date: Mon, 30 Oct 2017 18:04:48 -0700
Message-Id: <20171031010455.27772-3-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020519_366268_237D0170)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
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
index 2f60331..b6a2540 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -925,6 +925,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->available_antennas_rx = mac->macinfo.num_rx_chain;
 
 	wiphy->max_ap_assoc_sta = mac->macinfo.max_ap_assoc_sta;
+	wiphy->ht_capa_mod_mask = &mac->macinfo.ht_cap_mod_mask;
+	wiphy->vht_capa_mod_mask = &mac->macinfo.vht_cap_mod_mask;
 
 	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index a7422c5..35ff7e8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1110,9 +1110,10 @@ qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
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
index da2c24e..74b94ce 100644
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
index dfef7fa..b2c4e27 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -636,8 +636,8 @@ struct qlink_resp {
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
@@ -649,8 +649,8 @@ struct qlink_resp_get_mac_info {
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
