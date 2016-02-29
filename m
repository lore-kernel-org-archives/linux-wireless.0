Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28791 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbcB2VdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:33:09 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 07/15] wil6210: basic PBSS/PCP support
Date: Mon, 29 Feb 2016 23:32:42 +0200
Message-Id: <1456781570-16552-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_223335_402579_6B84DA63)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

PBSS (Personal Basic Service Set) is a new BSS type for DMG
networks. It is similar to infrastructure BSS, having an AP-like
entity called PCP (PBSS Control Point), but it has few differences.
For example, stations inside a PBSS can communicate directly, and
the PCP role can be transferred between stations.

This change adds PBSS support, and has 2 main parts:
1. When starting an AP, add an option to start as a PCP instead.
This is implemented by a new PBSS flag which is passed as part of
the cfg80211_ap_settings structure.
2. When connecting to a BSS, add an option to connect to a PCP
instead of an AP. This is again implemented by a new PBSS flag,
added to the cfg80211_connect_params structure.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 27 ++++++++++++++-------------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 ++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 0c25e8b..4a95e1c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -402,6 +402,7 @@ static void wil_print_connect_params(struct wil6210_priv *wil,
 		print_hex_dump(KERN_INFO, "  SSID: ", DUMP_PREFIX_OFFSET,
 			       16, 1, sme->ssid, sme->ssid_len, true);
 	wil_info(wil, "  Privacy: %s\n", sme->privacy ? "secure" : "open");
+	wil_info(wil, "  PBSS: %d\n", sme->pbss);
 	wil_print_crypto(wil, &sme->crypto);
 }
 
@@ -416,6 +417,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	const u8 *rsn_eid;
 	int ch;
 	int rc = 0;
+	enum ieee80211_bss_type bss_type = IEEE80211_BSS_TYPE_ESS;
 
 	wil_print_connect_params(wil, sme);
 
@@ -434,14 +436,12 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	if (sme->privacy && !rsn_eid)
 		wil_info(wil, "WSC connection\n");
 
-	if (sme->pbss) {
-		wil_err(wil, "connect - PBSS not yet supported\n");
-		return -EOPNOTSUPP;
-	}
+	if (sme->pbss)
+		bss_type = IEEE80211_BSS_TYPE_PBSS;
 
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
-			       IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_ANY);
+			       bss_type, IEEE80211_PRIVACY_ANY);
 	if (!bss) {
 		wil_err(wil, "Unable to find BSS\n");
 		return -ENOENT;
@@ -936,13 +936,16 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 				  const u8 *ssid, size_t ssid_len, u32 privacy,
 				  int bi, u8 chan,
 				  struct cfg80211_beacon_data *bcon,
-				  u8 hidden_ssid)
+				  u8 hidden_ssid, u32 pbss)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 
+	if (pbss)
+		wmi_nettype = WMI_NETTYPE_P2P;
+
 	wil_set_recovery_state(wil, fw_recovery_idle);
 
 	mutex_lock(&wil->mutex);
@@ -963,6 +966,7 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	wil->privacy = privacy;
 	wil->channel = chan;
 	wil->hidden_ssid = hidden_ssid;
+	wil->pbss = pbss;
 
 	netif_carrier_on(ndev);
 
@@ -1012,7 +1016,8 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 					    wdev->ssid_len, privacy,
 					    wdev->beacon_interval,
 					    wil->channel, bcon,
-					    wil->hidden_ssid);
+					    wil->hidden_ssid,
+					    wil->pbss);
 	} else {
 		rc = _wil_cfg80211_set_ies(wiphy, bcon);
 	}
@@ -1038,11 +1043,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	if (info->pbss) {
-		wil_err(wil, "AP: PBSS not yet supported\n");
-		return -EOPNOTSUPP;
-	}
-
 	switch (info->hidden_ssid) {
 	case NL80211_HIDDEN_SSID_NOT_IN_USE:
 		hidden_ssid = WMI_HIDDEN_SSID_DISABLED;
@@ -1068,6 +1068,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		     info->hidden_ssid);
 	wil_dbg_misc(wil, "BI %d DTIM %d\n", info->beacon_interval,
 		     info->dtim_period);
+	wil_dbg_misc(wil, "PBSS %d\n", info->pbss);
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
 			     info->ssid, info->ssid_len);
 	wil_print_bcon_data(bcon);
@@ -1076,7 +1077,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	rc = _wil_cfg80211_start_ap(wiphy, ndev,
 				    info->ssid, info->ssid_len, info->privacy,
 				    info->beacon_interval, channel->hw_value,
-				    bcon, hidden_ssid);
+				    bcon, hidden_ssid, info->pbss);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e69df0c..69d970a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -604,6 +604,8 @@ struct wil6210_priv {
 	struct wil_platform_ops platform_ops;
 
 	struct pmc_ctx pmc;
+
+	bool pbss;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
-- 
1.8.5.2

