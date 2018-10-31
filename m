Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E51FECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60EE20685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E60EE20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbeJaRz4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:56 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbeJaRz4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:56 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418125"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:30 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147925"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:29 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 05/16] wil6210: add recovery for FW error while in AP mode
Date:   Wed, 31 Oct 2018 10:52:13 +0200
Message-Id: <1540975944-30576-6-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

AP configuration is stored by the driver. Upon FW error, disconnect
notification is sent to user space for any associated stations. AP is
then internally restarted with the stored configuration.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 102 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c     |  17 ++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |   9 +++
 3 files changed, 120 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d18e81f..e9135d6 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -51,6 +51,19 @@
 	CHAN60G(4, 0),
 };
 
+static void
+wil_memdup_ie(u8 **pdst, size_t *pdst_len, const u8 *src, size_t src_len)
+{
+	kfree(*pdst);
+	*pdst = NULL;
+	*pdst_len = 0;
+	if (src_len > 0) {
+		*pdst = kmemdup(src, src_len, GFP_KERNEL);
+		if (*pdst)
+			*pdst_len = src_len;
+	}
+}
+
 static int wil_num_supported_channels(struct wil6210_priv *wil)
 {
 	int num_channels = ARRAY_SIZE(wil_60ghz_channels);
@@ -1441,11 +1454,19 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 
 	rc = wmi_add_cipher_key(vif, key_index, mac_addr, params->key_len,
 				params->key, key_usage);
-	if (!rc && !IS_ERR(cs))
+	if (!rc && !IS_ERR(cs)) {
+		/* update local storage used for AP recovery */
+		if (key_usage == WMI_KEY_USE_TX_GROUP && params->key &&
+		    params->key_len <= WMI_MAX_KEY_LEN) {
+			vif->gtk_index = key_index;
+			memcpy(vif->gtk, params->key, params->key_len);
+			vif->gtk_len = params->key_len;
+		}
 		/* in FT set crypto will take place upon receiving
 		 * WMI_RING_EN_EVENTID event
 		 */
 		wil_set_crypto_rx(key_index, key_usage, cs, params);
+	}
 
 	return rc;
 }
@@ -1634,6 +1655,14 @@ static int _wil_cfg80211_set_ies(struct wil6210_vif *vif,
 	u16 len = 0, proberesp_len = 0;
 	u8 *ies = NULL, *proberesp;
 
+	/* update local storage used for AP recovery */
+	wil_memdup_ie(&vif->proberesp, &vif->proberesp_len, bcon->probe_resp,
+		      bcon->probe_resp_len);
+	wil_memdup_ie(&vif->proberesp_ies, &vif->proberesp_ies_len,
+		      bcon->proberesp_ies, bcon->proberesp_ies_len);
+	wil_memdup_ie(&vif->assocresp_ies, &vif->assocresp_ies_len,
+		      bcon->assocresp_ies, bcon->assocresp_ies_len);
+
 	proberesp = _wil_cfg80211_get_proberesp_ies(bcon->probe_resp,
 						    bcon->probe_resp_len,
 						    &proberesp_len);
@@ -1735,6 +1764,9 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	vif->channel = chan;
 	vif->hidden_ssid = hidden_ssid;
 	vif->pbss = pbss;
+	vif->bi = bi;
+	memcpy(vif->ssid, ssid, ssid_len);
+	vif->ssid_len = ssid_len;
 
 	netif_carrier_on(ndev);
 	if (!wil_has_other_active_ifaces(wil, ndev, false, true))
@@ -1761,11 +1793,64 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	return rc;
 }
 
+void wil_cfg80211_ap_recovery(struct wil6210_priv *wil)
+{
+	int rc, i;
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+
+	for (i = 0; i < wil->max_vifs; i++) {
+		struct wil6210_vif *vif = wil->vifs[i];
+		struct net_device *ndev;
+		struct cfg80211_beacon_data bcon = {};
+		struct key_params key_params = {};
+
+		if (!vif || vif->ssid_len == 0)
+			continue;
+
+		ndev = vif_to_ndev(vif);
+		bcon.proberesp_ies = vif->proberesp_ies;
+		bcon.assocresp_ies = vif->assocresp_ies;
+		bcon.probe_resp = vif->proberesp;
+		bcon.proberesp_ies_len = vif->proberesp_ies_len;
+		bcon.assocresp_ies_len = vif->assocresp_ies_len;
+		bcon.probe_resp_len = vif->proberesp_len;
+
+		wil_info(wil,
+			 "AP (vif %d) recovery: privacy %d, bi %d, channel %d, hidden %d, pbss %d\n",
+			 i, vif->privacy, vif->bi, vif->channel,
+			 vif->hidden_ssid, vif->pbss);
+		wil_hex_dump_misc("SSID ", DUMP_PREFIX_OFFSET, 16, 1,
+				  vif->ssid, vif->ssid_len, true);
+		rc = _wil_cfg80211_start_ap(wiphy, ndev,
+					    vif->ssid, vif->ssid_len,
+					    vif->privacy, vif->bi,
+					    vif->channel, &bcon,
+					    vif->hidden_ssid, vif->pbss);
+		if (rc) {
+			wil_err(wil, "vif %d recovery failed (%d)\n", i, rc);
+			continue;
+		}
+
+		if (!vif->privacy || vif->gtk_len == 0)
+			continue;
+
+		key_params.key = vif->gtk;
+		key_params.key_len = vif->gtk_len;
+		key_params.seq_len = IEEE80211_GCMP_PN_LEN;
+		rc = wil_cfg80211_add_key(wiphy, ndev, vif->gtk_index, false,
+					  NULL, &key_params);
+		if (rc)
+			wil_err(wil, "vif %d recovery add key failed (%d)\n",
+				i, rc);
+	}
+}
+
 static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 				      struct net_device *ndev,
 				      struct cfg80211_beacon_data *bcon)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
 	int rc;
 	u32 privacy = 0;
@@ -1778,15 +1863,16 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 			     bcon->tail_len))
 		privacy = 1;
 
+	memcpy(vif->ssid, wdev->ssid, wdev->ssid_len);
+	vif->ssid_len = wdev->ssid_len;
+
 	/* in case privacy has changed, need to restart the AP */
 	if (vif->privacy != privacy) {
-		struct wireless_dev *wdev = ndev->ieee80211_ptr;
-
 		wil_dbg_misc(wil, "privacy changed %d=>%d. Restarting AP\n",
 			     vif->privacy, privacy);
 
-		rc = _wil_cfg80211_start_ap(wiphy, ndev, wdev->ssid,
-					    wdev->ssid_len, privacy,
+		rc = _wil_cfg80211_start_ap(wiphy, ndev, vif->ssid,
+					    vif->ssid_len, privacy,
 					    wdev->beacon_interval,
 					    vif->channel, bcon,
 					    vif->hidden_ssid,
@@ -1876,6 +1962,12 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	wmi_pcp_stop(vif);
 	clear_bit(wil_vif_ft_roam, vif->status);
+	vif->ssid_len = 0;
+	wil_memdup_ie(&vif->proberesp, &vif->proberesp_len, NULL, 0);
+	wil_memdup_ie(&vif->proberesp_ies, &vif->proberesp_ies_len, NULL, 0);
+	wil_memdup_ie(&vif->assocresp_ies, &vif->assocresp_ies_len, NULL, 0);
+	memset(vif->gtk, 0, WMI_MAX_KEY_LEN);
+	vif->gtk_len = 0;
 
 	if (last)
 		__wil_down(wil);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 55084770..2b328c1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -18,6 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 
 #include "wil6210.h"
 #include "txrx.h"
@@ -485,10 +486,11 @@ static void wil_fw_error_worker(struct work_struct *work)
 	if (wil_wait_for_recovery(wil) != 0)
 		return;
 
+	rtnl_lock();
 	mutex_lock(&wil->mutex);
 	/* Needs adaptation for multiple VIFs
 	 * need to go over all VIFs and consider the appropriate
-	 * recovery.
+	 * recovery because each one can have different iftype.
 	 */
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -500,15 +502,24 @@ static void wil_fw_error_worker(struct work_struct *work)
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		wil_info(wil, "No recovery for AP-like interface\n");
-		/* recovery in these modes is done by upper layers */
+		if (no_fw_recovery) /* upper layers do recovery */
+			break;
+		/* silent recovery, upper layers will see disconnect */
+		__wil_down(wil);
+		__wil_up(wil);
+		mutex_unlock(&wil->mutex);
+		wil_cfg80211_ap_recovery(wil);
+		mutex_lock(&wil->mutex);
+		wil_info(wil, "... completed\n");
 		break;
 	default:
 		wil_err(wil, "No recovery - unknown interface type %d\n",
 			wdev->iftype);
 		break;
 	}
+
 	mutex_unlock(&wil->mutex);
+	rtnl_unlock();
 }
 
 static int wil_find_free_ring(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 31753f94..8050c4b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -849,6 +849,14 @@ struct wil6210_vif {
 	u8 hidden_ssid; /* relevant in AP mode */
 	u32 ap_isolate; /* no intra-BSS communication */
 	bool pbss;
+	int bi;
+	u8 *proberesp, *proberesp_ies, *assocresp_ies;
+	size_t proberesp_len, proberesp_ies_len, assocresp_ies_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	size_t ssid_len;
+	u8 gtk_index;
+	u8 gtk[WMI_MAX_KEY_LEN];
+	size_t gtk_len;
 	int bcast_ring;
 	struct cfg80211_bss *bss; /* connected bss, relevant in STA mode */
 	int locally_generated_disc; /* relevant in STA mode */
@@ -1277,6 +1285,7 @@ int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
+void wil_cfg80211_ap_recovery(struct wil6210_priv *wil);
 int wil_cfg80211_iface_combinations_from_fw(
 	struct wil6210_priv *wil,
 	const struct wil_fw_record_concurrency *conc);
-- 
1.9.1

