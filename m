Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54808 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbcLLMAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:20 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Subject: [RFC V3 08/11] brcmfmac: report gscan capabilities if firmware supports it
Date: Mon, 12 Dec 2016 11:59:54 +0000
Message-Id: <1481543997-24624-9-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130023_245157_2792B8F6)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Fill the gscan capability information in the wiphy structure if
it is supported by firmware. The values are hardcoded as it can
not be obtained from firmware.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7ffc4ab..374b72c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -207,6 +207,16 @@ static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 		REG_RULE(5470-10, 5850+10, 80, 6, 20, 0), }
 };

+static const struct wiphy_gscan_caps brcmf_gscan_caps = {
+	.max_scan_cache_size = 320,
+	.max_scan_buckets = 8,
+	.max_ap_cache_per_scan = 32,
+	.max_rssi_sample_size = 8,
+	.max_scan_reporting_threshold = 100,
+	.max_hotlist_bssids = 64,
+	.max_significant_wifi_change_aps = 16,
+};
+
 /* Note: brcmf_cipher_suites is an array of int defining which cipher suites
  * are supported. A pointer to this array and the number of entries is passed
  * on to upper layers. AES_CMAC defines whether or not the driver supports MFP.
@@ -6426,7 +6436,12 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->max_remain_on_channel_duration = 5000;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO))
 		brcmf_wiphy_pno_params(wiphy);
-
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_GSCAN)) {
+		wiphy->gscan = kmemdup(&brcmf_gscan_caps,
+				       sizeof(brcmf_gscan_caps), GFP_KERNEL);
+		if (!wiphy->gscan)
+			return -ENOMEM;
+	}
 	/* vendor commands/events support */
 	wiphy->vendor_commands = brcmf_vendor_cmds;
 	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
@@ -6735,6 +6750,7 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 	if (!wiphy)
 		return;

+	kfree(wiphy->gscan);
 	if (wiphy->iface_combinations) {
 		for (i = 0; i < wiphy->n_iface_combinations; i++)
 			kfree(wiphy->iface_combinations[i].limits);
--
1.9.1
