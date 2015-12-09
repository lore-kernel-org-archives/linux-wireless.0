Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58828 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbbLIKW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/13] brcmfmac: Use local storage for ssid iovar.
Date: Wed, 9 Dec 2015 11:22:41 +0100
Message-ID: <1449656572-16158-3-git-send-email-arend@broadcom.com> (sfid-20151209_112327_825038_9B2CC567)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: I8f4438e7f86879d41e0d936f03164da755b8ca06
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5446
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 18 +++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    |  7 -------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 4aebb2a..b7b60f52 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1031,11 +1031,11 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 	struct brcmf_if *ifp = vif->ifp;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = &cfg->scan_req_int;
 	u32 passive_scan;
 	bool escan_req;
 	bool spec_scan;
 	s32 err;
+	struct brcmf_ssid_le ssid_le;
 	u32 SSID_len;
 
 	brcmf_dbg(SCAN, "START ESCAN\n");
@@ -1088,13 +1088,13 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 	} else {
 		brcmf_dbg(SCAN, "ssid \"%s\", ssid_len (%d)\n",
 			  ssids->ssid, ssids->ssid_len);
-		memset(&sr->ssid_le, 0, sizeof(sr->ssid_le));
-		SSID_len = min_t(u8, sizeof(sr->ssid_le.SSID), ssids->ssid_len);
-		sr->ssid_le.SSID_len = cpu_to_le32(0);
+		memset(&ssid_le, 0, sizeof(ssid_le));
+		SSID_len = min_t(u8, sizeof(ssid_le.SSID), ssids->ssid_len);
+		ssid_le.SSID_len = cpu_to_le32(0);
 		spec_scan = false;
 		if (SSID_len) {
-			memcpy(sr->ssid_le.SSID, ssids->ssid, SSID_len);
-			sr->ssid_le.SSID_len = cpu_to_le32(SSID_len);
+			memcpy(ssid_le.SSID, ssids->ssid, SSID_len);
+			ssid_le.SSID_len = cpu_to_le32(SSID_len);
 			spec_scan = true;
 		} else
 			brcmf_dbg(SCAN, "Broadcast scan\n");
@@ -1107,12 +1107,12 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 			goto scan_out;
 		}
 		brcmf_scan_config_mpc(ifp, 0);
-		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
-					     &sr->ssid_le, sizeof(sr->ssid_le));
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN, &ssid_le,
+					     sizeof(ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				brcmf_dbg(INFO, "BUSY: scan for \"%s\" canceled\n",
-					  sr->ssid_le.SSID);
+					  ssid_le.SSID);
 			else
 				brcmf_err("WLC_SCAN error (%d)\n", err);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index cf7a93d..e77f137 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -99,11 +99,6 @@ struct brcmf_cfg80211_conf {
 	struct ieee80211_channel channel;
 };
 
-/* basic structure of scan request */
-struct brcmf_cfg80211_scan_req {
-	struct brcmf_ssid_le ssid_le;
-};
-
 /* basic structure of information element */
 struct brcmf_cfg80211_ie {
 	u16 offset;
@@ -337,7 +332,6 @@ struct brcmf_cfg80211_vif_event {
  * @scan_request: cfg80211 scan request object.
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
- * @scan_req_int: internal scan request object.
  * @bss_info: bss information for cfg80211 layer.
  * @ie: information element object for internal purpose.
  * @conn_info: association info.
@@ -372,7 +366,6 @@ struct brcmf_cfg80211_info {
 	struct brcmf_btcoex_info *btcoex;
 	struct cfg80211_scan_request *scan_request;
 	struct mutex usr_sync;
-	struct brcmf_cfg80211_scan_req scan_req_int;
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_ie ie;
 	struct brcmf_cfg80211_connect_info conn_info;
-- 
1.9.1

