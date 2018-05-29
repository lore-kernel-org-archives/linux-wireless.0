Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933391AbeE2MA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:27 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/9] qtnfmac: simplify notation
Date: Tue, 29 May 2018 14:59:58 +0300
Message-Id: <20180529120005.21498-3-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140035_087644_357BA1B2)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shorten line lengths using a more compact notation to access mac info.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 25 ++++++++++++-----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 5122dc798064..bf624d975953 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -955,6 +955,7 @@ qtnf_wiphy_setup_if_comb(struct wiphy *wiphy, struct qtnf_mac_info *mac_info)
 int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 {
 	struct wiphy *wiphy = priv_to_wiphy(mac);
+	struct qtnf_mac_info *macinfo = &mac->macinfo;
 	int ret;
 
 	if (!wiphy) {
@@ -962,20 +963,20 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		return -EFAULT;
 	}
 
-	wiphy->frag_threshold = mac->macinfo.frag_thr;
-	wiphy->rts_threshold = mac->macinfo.rts_thr;
-	wiphy->retry_short = mac->macinfo.sretry_limit;
-	wiphy->retry_long = mac->macinfo.lretry_limit;
-	wiphy->coverage_class = mac->macinfo.coverage_class;
+	wiphy->frag_threshold = macinfo->frag_thr;
+	wiphy->rts_threshold = macinfo->rts_thr;
+	wiphy->retry_short = macinfo->sretry_limit;
+	wiphy->retry_long = macinfo->lretry_limit;
+	wiphy->coverage_class = macinfo->coverage_class;
 
 	wiphy->max_scan_ssids = QTNF_MAX_SSID_LIST_LENGTH;
 	wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
 	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
-	wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
+	wiphy->max_acl_mac_addrs = macinfo->max_acl_mac_addrs;
 	wiphy->max_num_csa_counters = 2;
 
-	ret = qtnf_wiphy_setup_if_comb(wiphy, &mac->macinfo);
+	ret = qtnf_wiphy_setup_if_comb(wiphy, macinfo);
 	if (ret)
 		goto out;
 
@@ -994,12 +995,12 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
 
-	wiphy->available_antennas_tx = mac->macinfo.num_tx_chain;
-	wiphy->available_antennas_rx = mac->macinfo.num_rx_chain;
+	wiphy->available_antennas_tx = macinfo->num_tx_chain;
+	wiphy->available_antennas_rx = macinfo->num_rx_chain;
 
-	wiphy->max_ap_assoc_sta = mac->macinfo.max_ap_assoc_sta;
-	wiphy->ht_capa_mod_mask = &mac->macinfo.ht_cap_mod_mask;
-	wiphy->vht_capa_mod_mask = &mac->macinfo.vht_cap_mod_mask;
+	wiphy->max_ap_assoc_sta = macinfo->max_ap_assoc_sta;
+	wiphy->ht_capa_mod_mask = &macinfo->ht_cap_mod_mask;
+	wiphy->vht_capa_mod_mask = &macinfo->vht_cap_mod_mask;
 
 	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
 
-- 
2.11.0
