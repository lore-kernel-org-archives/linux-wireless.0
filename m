Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3487 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/19] staging: brcm80211: fixed sparse endianness
 warnings on fullmac scan pars
Date: Fri, 16 Sep 2011 12:27:58 -0700
Message-ID: <1316201288-29635-10-git-send-email-frankyl@broadcom.com> (sfid-20110916_212844_913337_8B207BAE)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Three structures that are sent to the dongle have been annotated for correct
endianness:  struct brcmf_iscan_params, brcmf_scan_params,
brcmf_cfg80211_scan_req.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   33 +++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   59 ++++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 3 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 2967ada..e1d7c57 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -410,24 +410,24 @@ struct brcmf_ssid_le {
 	unsigned char SSID[32];
 };
 
-struct brcmf_scan_params {
-	struct brcmf_ssid ssid;	/* default: {0, ""} */
+struct brcmf_scan_params_le {
+	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
 	u8 bssid[ETH_ALEN];	/* default: bcast */
 	s8 bss_type;		/* default: any,
 				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
 				 */
 	u8 scan_type;	/* flags, 0 use default */
-	s32 nprobes;	  /* -1 use default, number of probes per channel */
-	s32 active_time;	/* -1 use default, dwell time per channel for
+	__le32 nprobes;	  /* -1 use default, number of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
 				 * active scanning
 				 */
-	s32 passive_time;	/* -1 use default, dwell time per channel
+	__le32 passive_time;	/* -1 use default, dwell time per channel
 				 * for passive scanning
 				 */
-	s32 home_time;	/* -1 use default, dwell time for the home channel
-				 * between channel scans
+	__le32 home_time;	/* -1 use default, dwell time for the
+				 * home channel between channel scans
 				 */
-	s32 channel_num;	/* count of channels and ssids that follow
+	__le32 channel_num;	/* count of channels and ssids that follow
 				 *
 				 * low half is count of channels in
 				 * channel_list, 0 means default (use all
@@ -443,22 +443,17 @@ struct brcmf_scan_params {
 				 * fixed parameter portion is assumed, otherwise
 				 * ssid in the fixed portion is ignored
 				 */
-	u16 channel_list[1];	/* list of chanspecs */
+	__le16 channel_list[1];	/* list of chanspecs */
 };
 
 /* incremental scan struct */
-struct brcmf_iscan_params {
-	u32 version;
-	u16 action;
-	u16 scan_duration;
-	struct brcmf_scan_params params;
+struct brcmf_iscan_params_le {
+	__le32 version;
+	__le16 action;
+	__le16 scan_duration;
+	struct brcmf_scan_params_le params_le;
 };
 
-/* 3 fields + size of brcmf_scan_params, not including variable length array */
-#define BRCMF_ISCAN_PARAMS_FIXED_SIZE \
-	(offsetof(struct brcmf_iscan_params, params) + \
-	 sizeof(struct brcmf_ssid))
-
 struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c4a8117..2dced70 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -359,9 +359,10 @@ static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 	s8 buf[BRCMF_C_IOCTL_SMLEN];
 	u32 len;
 	s32 err = 0;
+	__le32 val_le;
 
-	val = cpu_to_le32(val);
-	len = brcmu_mkiovar(name, (char *)(&val), sizeof(val), buf,
+	val_le = cpu_to_le32(val);
+	len = brcmu_mkiovar(name, (char *)(&val_le), sizeof(val_le), buf,
 			    sizeof(buf));
 	BUG_ON(!len);
 
@@ -411,25 +412,19 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static void wl_iscan_prep(struct brcmf_scan_params *params,
+static void wl_iscan_prep(struct brcmf_scan_params_le *params_le,
 			  struct brcmf_ssid *ssid)
 {
-	memcpy(params->bssid, ether_bcast, ETH_ALEN);
-	params->bss_type = DOT11_BSSTYPE_ANY;
-	params->scan_type = 0;
-	params->nprobes = -1;
-	params->active_time = -1;
-	params->passive_time = -1;
-	params->home_time = -1;
-	params->channel_num = 0;
-
-	params->nprobes = cpu_to_le32(params->nprobes);
-	params->active_time = cpu_to_le32(params->active_time);
-	params->passive_time = cpu_to_le32(params->passive_time);
-	params->home_time = cpu_to_le32(params->home_time);
+	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
+	params_le->bss_type = DOT11_BSSTYPE_ANY;
+	params_le->scan_type = 0;
+	params_le->channel_num = 0;
+	params_le->nprobes = cpu_to_le32(-1);
+	params_le->active_time = cpu_to_le32(-1);
+	params_le->passive_time = cpu_to_le32(-1);
+	params_le->home_time = cpu_to_le32(-1);
 	if (ssid && ssid->SSID_len)
-		memcpy(&params->ssid, ssid, sizeof(struct brcmf_ssid));
-
+		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
 }
 
 static s32
@@ -460,9 +455,9 @@ static s32
 brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 		struct brcmf_ssid *ssid, u16 action)
 {
-	s32 params_size = (BRCMF_SCAN_PARAMS_FIXED_SIZE +
-				offsetof(struct brcmf_iscan_params, params));
-	struct brcmf_iscan_params *params;
+	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
+			  offsetof(struct brcmf_iscan_params_le, params_le);
+	struct brcmf_iscan_params_le *params;
 	s32 err = 0;
 
 	if (ssid && ssid->SSID_len)
@@ -472,13 +467,12 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 		return -ENOMEM;
 	BUG_ON(params_size >= BRCMF_C_IOCTL_SMLEN);
 
-	wl_iscan_prep(&params->params, ssid);
+	wl_iscan_prep(&params->params_le, ssid);
 
 	params->version = cpu_to_le32(BRCMF_ISCAN_REQ_VERSION);
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
-	/* params_size += offsetof(struct brcmf_iscan_params, params); */
 	err = brcmf_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
 				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (unlikely(err)) {
@@ -537,6 +531,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	bool iscan_req;
 	bool spec_scan;
 	s32 err = 0;
+	u32 SSID_len;
 
 	if (unlikely(test_bit(WL_STATUS_SCANNING, &cfg_priv->status))) {
 		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
@@ -577,12 +572,12 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	} else {
 		WL_SCAN("ssid \"%s\", ssid_len (%d)\n",
 		       ssids->ssid, ssids->ssid_len);
-		memset(&sr->ssid, 0, sizeof(sr->ssid));
-		sr->ssid.SSID_len =
-			    min_t(u8, sizeof(sr->ssid.SSID), ssids->ssid_len);
-		if (sr->ssid.SSID_len) {
-			memcpy(sr->ssid.SSID, ssids->ssid, sr->ssid.SSID_len);
-			sr->ssid.SSID_len = cpu_to_le32(sr->ssid.SSID_len);
+		memset(&sr->ssid_le, 0, sizeof(sr->ssid_le));
+		SSID_len = min_t(u8, sizeof(sr->ssid_le.SSID), ssids->ssid_len);
+		sr->ssid_le.SSID_len = cpu_to_le32(0);
+		if (SSID_len) {
+			memcpy(sr->ssid_le.SSID, ssids->ssid, SSID_len);
+			sr->ssid_le.SSID_len = cpu_to_le32(SSID_len);
 			spec_scan = true;
 		} else {
 			WL_SCAN("Broadcast scan\n");
@@ -596,12 +591,12 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid,
-				sizeof(sr->ssid));
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid_le,
+				      sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				WL_INFO("system busy : scan for \"%s\" "
-					"canceled\n", sr->ssid.SSID);
+					"canceled\n", sr->ssid_le.SSID);
 			else
 				WL_ERR("WLC_SCAN error (%d)\n", err);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index db71762..7a8c671 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -188,7 +188,7 @@ struct brcmf_cfg80211_dev {
 
 /* basic structure of scan request */
 struct brcmf_cfg80211_scan_req {
-	struct brcmf_ssid ssid;
+	struct brcmf_ssid_le ssid_le;
 };
 
 /* basic structure of information element */
-- 
1.7.1


