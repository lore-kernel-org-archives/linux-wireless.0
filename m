Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752728AbdJaBFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:06 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 3/9] qtnfmac: get rid of PHYMODE capabilities flags
Date: Mon, 30 Oct 2017 18:04:49 -0700
Message-Id: <20171031010455.27772-4-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020520_280475_BF7D7CB2)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Supported WiFi operation modes are now identified per-band based on
HT/VHT capabilities of each band.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  3 ---
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  1 -
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  1 -
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 ++---------
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index b6a2540..1a0c538 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -891,9 +891,6 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	if (ret)
 		goto out;
 
-	pr_info("MAC%u: phymode=%#x radar=%#x\n", mac->macid,
-		mac->macinfo.phymode_cap, mac->macinfo.radar_detect_widths);
-
 	wiphy->frag_threshold = mac->macinfo.frag_thr;
 	wiphy->rts_threshold = mac->macinfo.rts_thr;
 	wiphy->retry_short = mac->macinfo.sretry_limit;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 35ff7e8..503187a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1090,7 +1090,6 @@ qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
 	mac_info = &mac->macinfo;
 
 	mac_info->bands_cap = resp_info->bands_cap;
-	mac_info->phymode_cap = resp_info->phymode_cap;
 	memcpy(&mac_info->dev_mac, &resp_info->dev_mac,
 	       sizeof(mac_info->dev_mac));
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 74b94ce..1b7bc03 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -92,7 +92,6 @@ struct qtnf_vif {
 
 struct qtnf_mac_info {
 	u8 bands_cap;
-	u8 phymode_cap;
 	u8 dev_mac[ETH_ALEN];
 	u8 num_tx_chain;
 	u8 num_rx_chain;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index b2c4e27..c558d81 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -74,12 +74,6 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_STA_INACT_TIMEOUT = BIT(1),
 };
 
-enum qlink_phy_mode {
-	QLINK_PHYMODE_BGN	= BIT(0),
-	QLINK_PHYMODE_AN	= BIT(1),
-	QLINK_PHYMODE_AC	= BIT(2),
-};
-
 enum qlink_iface_type {
 	QLINK_IFTYPE_AP		= 1,
 	QLINK_IFTYPE_STATION	= 2,
@@ -639,7 +633,6 @@ struct qlink_resp {
  * @vht_cap_mod_mask: mask specifying which VHT capabilities can be altered.
  * @ht_cap_mod_mask: mask specifying which HT capabilities can be altered.
  * @bands_cap: wireless bands WMAC can operate in, bitmap of &enum qlink_band.
- * @phymode_cap: PHY modes WMAC can operate in, bitmap of &enum qlink_phy_mode.
  * @max_ap_assoc_sta: Maximum number of associations supported by WMAC.
  * @radar_detect_widths: bitmask of channels BW for which WMAC can detect radar.
  * @var_info: variable-length WMAC info data.
@@ -651,10 +644,10 @@ struct qlink_resp_get_mac_info {
 	u8 num_rx_chain;
 	struct ieee80211_vht_cap vht_cap_mod_mask;
 	struct ieee80211_ht_cap ht_cap_mod_mask;
-	u8 bands_cap;
-	u8 phymode_cap;
 	__le16 max_ap_assoc_sta;
 	__le16 radar_detect_widths;
+	u8 bands_cap;
+	u8 rsvd[1];
 	u8 var_info[0];
 } __packed;
 
-- 
2.9.5
