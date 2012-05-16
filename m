Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:44745 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966982Ab2EPK3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 06:29:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Naveen Singh <navesing@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Include match ssid list in scheduled scan
Date: Wed, 16 May 2012 13:29:00 +0300
Message-Id: <1337164140-16098-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120516_122932_297242_88E48213)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <navesing@qca.qualcomm.com>

Scheduled scan implementation was only taking probed list into
consideration. The matched list was dropped. This would cause
FW not to report the AP as the list never had that AP's SSID
populated. This was causing long connection time when supplicant
would just issue a wild card SSID in probed list. As a part of
this implementation, ath6kl driver would create a complete list
by taking both probed and matched list and pass it to FW. FW would
probe for the SSID that it needs to and would match against the
relevant SSIDS that is been configured.

kvalo: whitespace changes, less indentation in the for loop, use ++

Signed-off-by: Naveen Singh <navesing@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   98 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/core.h     |    5 ++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    6 ++
 3 files changed, 99 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 22843a1..599b29b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -53,6 +53,11 @@
 
 #define DEFAULT_BG_SCAN_PERIOD 60
 
+struct ath6kl_cfg80211_match_probe_ssid {
+	struct cfg80211_ssid ssid;
+	u8 flag;
+};
+
 static struct ieee80211_rate ath6kl_rates[] = {
 	RATETAB_ENT(10, 0x1, 0),
 	RATETAB_ENT(20, 0x2, 0),
@@ -884,23 +889,76 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 
 static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 				   struct ath6kl_vif *vif,
-				   struct cfg80211_ssid *ssids, int n_ssids)
+				   struct cfg80211_ssid *ssids, int n_ssids,
+				   struct cfg80211_match_set *match_set,
+				   int n_match_ssid)
 {
-	u8 i;
+	u8 i, j, index_to_add, ssid_found = false;
+	struct ath6kl_cfg80211_match_probe_ssid ssid_list[MAX_PROBED_SSIDS];
+
+	memset(ssid_list, 0, sizeof(ssid_list));
 
-	if (n_ssids > MAX_PROBED_SSIDS)
+	if (n_ssids > MAX_PROBED_SSIDS ||
+	    n_match_ssid > MAX_PROBED_SSIDS)
 		return -EINVAL;
 
 	for (i = 0; i < n_ssids; i++) {
+		memcpy(ssid_list[i].ssid.ssid,
+		       ssids[i].ssid,
+		       ssids[i].ssid_len);
+		ssid_list[i].ssid.ssid_len = ssids[i].ssid_len;
+
+		if (ssids[i].ssid_len)
+			ssid_list[i].flag = SPECIFIC_SSID_FLAG;
+		else
+			ssid_list[i].flag = ANY_SSID_FLAG;
+
+		if (n_match_ssid == 0)
+			ssid_list[i].flag |= MATCH_SSID_FLAG;
+	}
+
+	index_to_add = i;
+
+	for (i = 0; i < n_match_ssid; i++) {
+		ssid_found = false;
+
+		for (j = 0; j < n_ssids; j++) {
+			if ((match_set[i].ssid.ssid_len ==
+			     ssid_list[j].ssid.ssid_len) &&
+			    (!memcmp(ssid_list[j].ssid.ssid,
+				     match_set[i].ssid.ssid,
+				     match_set[i].ssid.ssid_len))) {
+				ssid_list[j].flag |= MATCH_SSID_FLAG;
+				ssid_found = true;
+				break;
+			}
+		}
+
+		if (ssid_found)
+			continue;
+
+		if (index_to_add >= MAX_PROBED_SSIDS)
+			continue;
+
+		ssid_list[index_to_add].ssid.ssid_len =
+			match_set[i].ssid.ssid_len;
+		memcpy(ssid_list[index_to_add].ssid.ssid,
+		       match_set[i].ssid.ssid,
+		       match_set[i].ssid.ssid_len);
+		ssid_list[index_to_add].flag |= MATCH_SSID_FLAG;
+		index_to_add++;
+	}
+
+	for (i = 0; i < index_to_add; i++) {
 		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx, i,
-					  ssids[i].ssid_len ?
-					  SPECIFIC_SSID_FLAG : ANY_SSID_FLAG,
-					  ssids[i].ssid_len,
-					  ssids[i].ssid);
+					  ssid_list[i].flag,
+					  ssid_list[i].ssid.ssid_len,
+					  ssid_list[i].ssid.ssid);
+
 	}
 
 	/* Make sure no old entries are left behind */
-	for (i = n_ssids; i < MAX_PROBED_SSIDS; i++) {
+	for (i = index_to_add; i < MAX_PROBED_SSIDS; i++) {
 		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx, i,
 					  DISABLE_SSID_FLAG, 0, NULL);
 	}
@@ -934,7 +992,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
-				      request->n_ssids);
+				      request->n_ssids, NULL, 0);
 	if (ret < 0)
 		return ret;
 
@@ -3164,10 +3222,24 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 
 	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
-				      request->n_ssids);
+				      request->n_ssids,
+				      request->match_sets,
+				      request->n_match_sets);
 	if (ret < 0)
 		return ret;
 
+	if (!request->n_match_sets) {
+		ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					       ALL_BSS_FILTER, 0);
+		if (ret < 0)
+			return ret;
+	} else {
+		 ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+						MATCHED_SSID_FILTER, 0);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* fw uses seconds, also make sure that it's >0 */
 	interval = max_t(u16, 1, request->interval / 1000);
 
@@ -3475,6 +3547,12 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 
 	/* max num of ssids that can be probed during scanning */
 	wiphy->max_scan_ssids = MAX_PROBED_SSIDS;
+
+	/* max num of ssids that can be matched after scan */
+	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST,
+		     ar->fw_capabilities))
+		wiphy->max_match_sets = MAX_PROBED_SSIDS;
+
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
 	switch (ar->hw.cap) {
 	case WMI_11AN_CAP:
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 79c7055..c5fde45 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -107,6 +107,11 @@ enum ath6kl_fw_capability {
 	 */
 	ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
 
+	/*
+	 * FW supports matching of ssid in schedule scan
+	 */
+	ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 3518550..774e8fd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -960,6 +960,9 @@ enum wmi_bss_filter {
 	/* beacons matching probed ssid */
 	PROBED_SSID_FILTER,
 
+	/* beacons matching matched ssid */
+	MATCHED_SSID_FILTER,
+
 	/* marker only */
 	LAST_BSS_FILTER,
 };
@@ -989,6 +992,9 @@ enum wmi_ssid_flag {
 
 	/* probes for any ssid */
 	ANY_SSID_FLAG = 0x02,
+
+	/* match for ssid */
+	MATCH_SSID_FLAG = 0x08,
 };
 
 struct wmi_probed_ssid_cmd {
-- 
1.7.1

