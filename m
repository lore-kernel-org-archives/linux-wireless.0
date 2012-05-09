Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2EITO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 15:14:57 -0400
Date: Wed, 9 May 2012 22:14:51 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Use correct max-scan-SSIDs limit
Message-ID: <20120509191451.GA5835@jouni.qca.qualcomm.com> (sfid-20120509_211501_531381_E1C7E9E8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The currently used firmware images support 16 SSIDs in the scan
request (indexes 0..15), so update the host driver to use the same
limit to allow some more SSIDs to be scanned per request. In addition,
change the max-index to max-SSIDs to make it easier to understand the
implementation and fix couple of off-by-one checks that could limit
the maximum number of entries too strictly.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b869a35..a6bebc2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -888,7 +888,7 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 {
 	u8 i;
 
-	if (n_ssids > MAX_PROBED_SSID_INDEX)
+	if (n_ssids > MAX_PROBED_SSIDS)
 		return -EINVAL;
 
 	for (i = 0; i < n_ssids; i++) {
@@ -900,7 +900,7 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 	}
 
 	/* Make sure no old entries are left behind */
-	for (i = n_ssids; i < MAX_PROBED_SSID_INDEX; i++) {
+	for (i = n_ssids; i < MAX_PROBED_SSIDS; i++) {
 		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx, i,
 					  DISABLE_SSID_FLAG, 0, NULL);
 	}
@@ -3470,7 +3470,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	}
 
 	/* max num of ssids that can be probed during scanning */
-	wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
+	wiphy->max_scan_ssids = MAX_PROBED_SSIDS;
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
 	switch (ar->hw.cap) {
 	case WMI_11AN_CAP:
@@ -3527,7 +3527,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->wowlan.pattern_min_len = 1;
 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
 
-	wiphy->max_sched_scan_ssids = MAX_PROBED_SSID_INDEX;
+	wiphy->max_sched_scan_ssids = MAX_PROBED_SSIDS;
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
 			    WIPHY_FLAG_HAVE_AP_SME |
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ee8ec23..bdd3b2c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1995,7 +1995,7 @@ int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 if_idx, u8 index, u8 flag,
 	struct wmi_probed_ssid_cmd *cmd;
 	int ret;
 
-	if (index > MAX_PROBED_SSID_INDEX)
+	if (index >= MAX_PROBED_SSIDS)
 		return -EINVAL;
 
 	if (ssid_len > sizeof(cmd->ssid))
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9076bec..3518550 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -978,7 +978,7 @@ struct wmi_bss_filter_cmd {
 } __packed;
 
 /* WMI_SET_PROBED_SSID_CMDID */
-#define MAX_PROBED_SSID_INDEX   9
+#define MAX_PROBED_SSIDS   16
 
 enum wmi_ssid_flag {
 	/* disables entry */
@@ -992,7 +992,7 @@ enum wmi_ssid_flag {
 };
 
 struct wmi_probed_ssid_cmd {
-	/* 0 to MAX_PROBED_SSID_INDEX */
+	/* 0 to MAX_PROBED_SSIDS - 1 */
 	u8 entry_index;
 
 	/* see, enum wmi_ssid_flg */
-- 
1.7.5.4


-- 
Jouni Malinen                                            PGP id EFC895FA
