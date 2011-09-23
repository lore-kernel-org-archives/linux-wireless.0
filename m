Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2398 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/19] staging: brcm80211: more fullmac sparse
 endianness scan related changes
Date: Thu, 22 Sep 2011 17:07:42 -0700
Message-ID: <1316736476-23725-6-git-send-email-frankyl@broadcom.com> (sfid-20110923_020845_508733_4E01004B)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Annotated endianness on structures send/received to/from dongle.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   25 +++++++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   64 +++++++++++-----------
 2 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index c368f71..1e18ad0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -469,6 +469,13 @@ struct brcmf_scan_results {
 	struct brcmf_bss_info bss_info[1];
 };
 
+struct brcmf_scan_results_le {
+	__le32 buflen;
+	__le32 version;
+	__le32 count;
+	struct brcmf_bss_info bss_info[1];
+};
+
 /* used for association with a specific BSSID and chanspec list */
 struct brcmf_assoc_params_le {
 	/* 00:00:00:00:00:00: broadcast scan */
@@ -492,8 +499,14 @@ struct brcmf_join_params {
 
 /* incremental scan results struct */
 struct brcmf_iscan_results {
-	u32 status;
-	struct brcmf_scan_results results;
+	union {
+		u32 status;
+		__le32 status_le;
+	};
+	union {
+		struct brcmf_scan_results results;
+		struct brcmf_scan_results_le results_le;
+	};
 };
 
 /* size of brcmf_iscan_results not including variable length array */
@@ -549,10 +562,10 @@ struct brcmf_scb_val_le {
 };
 
 /* channel encoding */
-struct brcmf_channel_info {
-	int hw_channel;
-	int target_channel;
-	int scan_channel;
+struct brcmf_channel_info_le {
+	__le32 hw_channel;
+	__le32 target_channel;
+	__le32 scan_channel;
 };
 
 /* Linux network driver ioctl encoding */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b4befec..5e86e21 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2201,18 +2201,20 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 {
 	struct brcmf_iscan_results list;
 	struct brcmf_scan_results *results;
+	struct brcmf_scan_results_le *results_le;
 	struct brcmf_iscan_results *list_buf;
 	s32 err = 0;
 
 	memset(iscan->scan_buf, 0, WL_ISCAN_BUF_MAX);
 	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
 	results = &list_buf->results;
+	results_le = &list_buf->results_le;
 	results->buflen = BRCMF_ISCAN_RESULTS_FIXED_SIZE;
 	results->version = 0;
 	results->count = 0;
 
 	memset(&list, 0, sizeof(list));
-	list.results.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
+	list.results_le.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
 	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
 				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
 				WL_ISCAN_BUF_MAX);
@@ -2220,12 +2222,12 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
-	results->buflen = le32_to_cpu(results->buflen);
-	results->version = le32_to_cpu(results->version);
-	results->count = le32_to_cpu(results->count);
-	WL_SCAN("results->count = %d\n", results->count);
-	WL_SCAN("results->buflen = %d\n", results->buflen);
-	*status = le32_to_cpu(list_buf->status);
+	results->buflen = le32_to_cpu(results_le->buflen);
+	results->version = le32_to_cpu(results_le->version);
+	results->count = le32_to_cpu(results_le->count);
+	WL_SCAN("results->count = %d\n", results_le->count);
+	WL_SCAN("results->buflen = %d\n", results_le->buflen);
+	*status = le32_to_cpu(list_buf->status_le);
 	WL_SCAN("status = %d\n", *status);
 	*bss_list = results;
 
@@ -2848,11 +2850,12 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 {
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
-	struct brcmf_channel_info channel;
+	struct brcmf_channel_info_le channel_le;
 	struct ieee80211_channel *notify_channel;
 	struct ieee80211_supported_band *band;
 	u32 freq;
 	s32 err = 0;
+	u32 target_channel;
 
 	WL_TRACE("Enter\n");
 
@@ -2860,18 +2863,18 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 	brcmf_update_prof(cfg_priv, NULL, &e->addr, WL_PROF_BSSID);
 	brcmf_update_bss_info(cfg_priv);
 
-	brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel, sizeof(channel));
+	brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
+			sizeof(channel_le));
 
-	channel.target_channel = le32_to_cpu(channel.target_channel);
-	WL_CONN("Roamed to channel %d\n", channel.target_channel);
+	target_channel = le32_to_cpu(channel_le.target_channel);
+	WL_CONN("Roamed to channel %d\n", target_channel);
 
-	if (channel.target_channel <= CH_MAX_2G_CHANNEL)
+	if (target_channel <= CH_MAX_2G_CHANNEL)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 
-	freq = ieee80211_channel_to_frequency(channel.target_channel,
-						band->band);
+	freq = ieee80211_channel_to_frequency(target_channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
 	cfg80211_roamed(ndev, notify_channel,
@@ -3011,11 +3014,12 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 			 struct net_device *ndev,
 			 const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_channel_info channel_inform;
-	struct brcmf_scan_results *bss_list;
+	struct brcmf_channel_info_le channel_inform_le;
+	struct brcmf_scan_results_le *bss_list_le;
 	u32 len = WL_SCAN_BUF_MAX;
 	s32 err = 0;
 	bool scan_abort = false;
+	u32 scan_channel;
 
 	WL_TRACE("Enter\n");
 
@@ -3032,34 +3036,32 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 		goto scan_done_out;
 	}
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform,
-			sizeof(channel_inform));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform_le,
+			      sizeof(channel_inform_le));
 	if (unlikely(err)) {
 		WL_ERR("scan busy (%d)\n", err);
 		scan_abort = true;
 		goto scan_done_out;
 	}
-	channel_inform.scan_channel = le32_to_cpu(channel_inform.scan_channel);
-	if (unlikely(channel_inform.scan_channel)) {
-
-		WL_CONN("channel_inform.scan_channel (%d)\n",
-		       channel_inform.scan_channel);
-	}
+	scan_channel = le32_to_cpu(channel_inform_le.scan_channel);
+	if (unlikely(scan_channel))
+		WL_CONN("channel_inform.scan_channel (%d)\n", scan_channel);
 	cfg_priv->bss_list = cfg_priv->scan_results;
-	bss_list = cfg_priv->bss_list;
-	memset(bss_list, 0, len);
-	bss_list->buflen = cpu_to_le32(len);
+	bss_list_le = (struct brcmf_scan_results_le *) cfg_priv->bss_list;
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS, bss_list, len);
+	memset(cfg_priv->scan_results, 0, len);
+	bss_list_le->buflen = cpu_to_le32(len);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS,
+			      cfg_priv->scan_results, len);
 	if (unlikely(err)) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
 		scan_abort = true;
 		goto scan_done_out;
 	}
-	bss_list->buflen = le32_to_cpu(bss_list->buflen);
-	bss_list->version = le32_to_cpu(bss_list->version);
-	bss_list->count = le32_to_cpu(bss_list->count);
+	cfg_priv->scan_results->buflen = le32_to_cpu(bss_list_le->buflen);
+	cfg_priv->scan_results->version = le32_to_cpu(bss_list_le->version);
+	cfg_priv->scan_results->count = le32_to_cpu(bss_list_le->count);
 
 	err = brcmf_inform_bss(cfg_priv);
 	if (err) {
-- 
1.7.1


