Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E5FECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8414F20840
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8414F20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbeJaRzz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:55 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23734 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727381AbeJaRzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:54 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2018 13:55:51 EDT
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418127"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:31 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147927"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:31 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 07/16] wil6210: refactor disconnect flow
Date:   Wed, 31 Oct 2018 10:52:15 +0200
Message-Id: <1540975944-30576-8-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Separate sending command to the fw from the event handling function to
simplify the disconnect flow and track the from_event flag correctly.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |   2 +-
 drivers/net/wireless/ath/wil6210/main.c     | 180 +++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/netdev.c   |   2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |   8 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  28 ++---
 5 files changed, 148 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e9135d6..9b2f9f5 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -2015,7 +2015,7 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 		     params->mac, params->reason_code, vif->mid);
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(vif, params->mac, params->reason_code, false);
+	wil6210_disconnect(vif, params->mac, params->reason_code);
 	mutex_unlock(&wil->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 2b328c1..9dd068d 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -215,8 +215,21 @@ static void wil_ring_fini_tx(struct wil6210_priv *wil, int id)
 	wil->txrx_ops.ring_fini_tx(wil, ring);
 }
 
-static void wil_disconnect_cid(struct wil6210_vif *vif, int cid,
-			       u16 reason_code, bool from_event)
+static bool wil_vif_is_connected(struct wil6210_priv *wil, u8 mid)
+{
+	int i;
+
+	for (i = 0; i < WIL6210_MAX_CID; i++) {
+		if (wil->sta[i].mid == mid &&
+		    wil->sta[i].status == wil_sta_connected)
+			return true;
+	}
+
+	return false;
+}
+
+static void wil_disconnect_cid_complete(struct wil6210_vif *vif, int cid,
+					u16 reason_code)
 __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
 	uint i;
@@ -227,24 +240,14 @@ static void wil_disconnect_cid(struct wil6210_vif *vif, int cid,
 	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	might_sleep();
-	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
+	wil_dbg_misc(wil,
+		     "disconnect_cid_complete: CID %d, MID %d, status %d\n",
 		     cid, sta->mid, sta->status);
-	/* inform upper/lower layers */
+	/* inform upper layers */
 	if (sta->status != wil_sta_unused) {
 		if (vif->mid != sta->mid) {
 			wil_err(wil, "STA MID mismatch with VIF MID(%d)\n",
 				vif->mid);
-			/* let FW override sta->mid but be more strict with
-			 * user space requests
-			 */
-			if (!from_event)
-				return;
-		}
-		if (!from_event) {
-			bool del_sta = (wdev->iftype == NL80211_IFTYPE_AP) ?
-						disable_ap_sme : false;
-			wmi_disconnect_sta(vif, sta->addr, reason_code,
-					   true, del_sta);
 		}
 
 		switch (wdev->iftype) {
@@ -284,36 +287,20 @@ static void wil_disconnect_cid(struct wil6210_vif *vif, int cid,
 	sta->stats.tx_latency_min_us = U32_MAX;
 }
 
-static bool wil_vif_is_connected(struct wil6210_priv *wil, u8 mid)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
-		if (wil->sta[i].mid == mid &&
-		    wil->sta[i].status == wil_sta_connected)
-			return true;
-	}
-
-	return false;
-}
-
-static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
-				u16 reason_code, bool from_event)
+static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
+					 const u8 *bssid, u16 reason_code)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
 	int cid = -ENOENT;
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 
-	if (unlikely(!vif))
-		return;
-
 	ndev = vif_to_ndev(vif);
 	wdev = vif_to_wdev(vif);
 
 	might_sleep();
-	wil_info(wil, "bssid=%pM, reason=%d, ev%s\n", bssid,
-		 reason_code, from_event ? "+" : "-");
+	wil_info(wil, "disconnect_complete: bssid=%pM, reason=%d\n",
+		 bssid, reason_code);
 
 	/* Cases are:
 	 * - disconnect single STA, still connected
@@ -328,14 +315,15 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 	if (bssid && !is_broadcast_ether_addr(bssid) &&
 	    !ether_addr_equal_unaligned(ndev->dev_addr, bssid)) {
 		cid = wil_find_cid(wil, vif->mid, bssid);
-		wil_dbg_misc(wil, "Disconnect %pM, CID=%d, reason=%d\n",
+		wil_dbg_misc(wil,
+			     "Disconnect complete %pM, CID=%d, reason=%d\n",
 			     bssid, cid, reason_code);
 		if (cid >= 0) /* disconnect 1 peer */
-			wil_disconnect_cid(vif, cid, reason_code, from_event);
+			wil_disconnect_cid_complete(vif, cid, reason_code);
 	} else { /* all */
-		wil_dbg_misc(wil, "Disconnect all\n");
+		wil_dbg_misc(wil, "Disconnect complete all\n");
 		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
-			wil_disconnect_cid(vif, cid, reason_code, from_event);
+			wil_disconnect_cid_complete(vif, cid, reason_code);
 	}
 
 	/* link state */
@@ -381,6 +369,85 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 	}
 }
 
+static int wil_disconnect_cid(struct wil6210_vif *vif, int cid,
+			      u16 reason_code)
+__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	struct wireless_dev *wdev = vif_to_wdev(vif);
+	struct wil_sta_info *sta = &wil->sta[cid];
+	bool del_sta = false;
+
+	might_sleep();
+	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
+		     cid, sta->mid, sta->status);
+
+	if (sta->status == wil_sta_unused)
+		return 0;
+
+	if (vif->mid != sta->mid) {
+		wil_err(wil, "STA MID mismatch with VIF MID(%d)\n", vif->mid);
+		return -EINVAL;
+	}
+
+	/* inform lower layers */
+	if (wdev->iftype == NL80211_IFTYPE_AP && disable_ap_sme)
+		del_sta = true;
+
+	/* disconnect by sending command disconnect/del_sta and wait
+	 * synchronously for WMI_DISCONNECT_EVENTID event.
+	 */
+	return wmi_disconnect_sta(vif, sta->addr, reason_code, del_sta);
+}
+
+static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
+				u16 reason_code)
+{
+	struct wil6210_priv *wil;
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+	int cid = -ENOENT;
+
+	if (unlikely(!vif))
+		return;
+
+	wil = vif_to_wil(vif);
+	ndev = vif_to_ndev(vif);
+	wdev = vif_to_wdev(vif);
+
+	might_sleep();
+	wil_info(wil, "disconnect bssid=%pM, reason=%d\n", bssid, reason_code);
+
+	/* Cases are:
+	 * - disconnect single STA, still connected
+	 * - disconnect single STA, already disconnected
+	 * - disconnect all
+	 *
+	 * For "disconnect all", there are 3 options:
+	 * - bssid == NULL
+	 * - bssid is broadcast address (ff:ff:ff:ff:ff:ff)
+	 * - bssid is our MAC address
+	 */
+	if (bssid && !is_broadcast_ether_addr(bssid) &&
+	    !ether_addr_equal_unaligned(ndev->dev_addr, bssid)) {
+		cid = wil_find_cid(wil, vif->mid, bssid);
+		wil_dbg_misc(wil, "Disconnect %pM, CID=%d, reason=%d\n",
+			     bssid, cid, reason_code);
+		if (cid >= 0) /* disconnect 1 peer */
+			wil_disconnect_cid(vif, cid, reason_code);
+	} else { /* all */
+		wil_dbg_misc(wil, "Disconnect all\n");
+		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+			wil_disconnect_cid(vif, cid, reason_code);
+	}
+
+	/* call event handler manually after processing wmi_call,
+	 * to avoid deadlock - disconnect event handler acquires
+	 * wil->mutex while it is already held here
+	 */
+	_wil6210_disconnect_complete(vif, bssid, reason_code);
+}
+
 void wil_disconnect_worker(struct work_struct *work)
 {
 	struct wil6210_vif *vif = container_of(work,
@@ -705,20 +772,41 @@ void wil6210_bus_request(struct wil6210_priv *wil, u32 kbps)
  * @vif: virtual interface context
  * @bssid: peer to disconnect, NULL to disconnect all
  * @reason_code: Reason code for the Disassociation frame
- * @from_event: whether is invoked from FW event handler
  *
- * Disconnect and release associated resources. If invoked not from the
- * FW event handler, issue WMI command(s) to trigger MAC disconnect.
+ * Disconnect and release associated resources. Issue WMI
+ * command(s) to trigger MAC disconnect. When command was issued
+ * successfully, call the wil6210_disconnect_complete function
+ * to handle the event synchronously
  */
 void wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
-			u16 reason_code, bool from_event)
+			u16 reason_code)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+
+	wil_dbg_misc(wil, "disconnecting\n");
+
+	del_timer_sync(&vif->connect_timer);
+	_wil6210_disconnect(vif, bssid, reason_code);
+}
+
+/**
+ * wil6210_disconnect_complete - handle disconnect event
+ * @vif: virtual interface context
+ * @bssid: peer to disconnect, NULL to disconnect all
+ * @reason_code: Reason code for the Disassociation frame
+ *
+ * Release associated resources and indicate upper layers the
+ * connection is terminated.
+ */
+void wil6210_disconnect_complete(struct wil6210_vif *vif, const u8 *bssid,
+				 u16 reason_code)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
 
-	wil_dbg_misc(wil, "disconnect\n");
+	wil_dbg_misc(wil, "got disconnect\n");
 
 	del_timer_sync(&vif->connect_timer);
-	_wil6210_disconnect(vif, bssid, reason_code, from_event);
+	_wil6210_disconnect_complete(vif, bssid, reason_code);
 }
 
 void wil_priv_deinit(struct wil6210_priv *wil)
@@ -1525,7 +1613,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		if (vif) {
 			cancel_work_sync(&vif->disconnect_worker);
 			wil6210_disconnect(vif, NULL,
-					   WLAN_REASON_DEAUTH_LEAVING, false);
+					   WLAN_REASON_DEAUTH_LEAVING);
 		}
 	}
 	wil_bcast_fini_all(wil);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 64fa1a2..b4e0eb1 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -512,7 +512,7 @@ void wil_vif_remove(struct wil6210_priv *wil, u8 mid)
 	}
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(vif, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
+	wil6210_disconnect(vif, NULL, WLAN_REASON_DEAUTH_LEAVING);
 	mutex_unlock(&wil->mutex);
 
 	ndev = vif_to_ndev(vif);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8050c4b..ad7003f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1229,8 +1229,8 @@ int wmi_add_cipher_key(struct wil6210_vif *vif, u8 key_index,
 int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
-int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac,
-		       u16 reason, bool full_disconnect, bool del_sta);
+int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac, u16 reason,
+		       bool del_sta);
 int wmi_addba(struct wil6210_priv *wil, u8 mid,
 	      u8 ringid, u8 size, u16 timeout);
 int wmi_delba_tx(struct wil6210_priv *wil, u8 mid, u8 ringid, u16 reason);
@@ -1316,7 +1316,9 @@ int wmi_pcp_start(struct wil6210_vif *vif, int bi, u8 wmi_nettype, u8 chan,
 void wil_abort_scan_all_vifs(struct wil6210_priv *wil, bool sync);
 void wil6210_bus_request(struct wil6210_priv *wil, u32 kbps);
 void wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
-			u16 reason_code, bool from_event);
+			u16 reason_code);
+void wil6210_disconnect_complete(struct wil6210_vif *vif, const u8 *bssid,
+				 u16 reason_code);
 void wil_probe_client_flush(struct wil6210_vif *vif);
 void wil_probe_client_worker(struct work_struct *work);
 void wil_disconnect_worker(struct work_struct *work);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 4859f0e..5ff1862 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1018,7 +1018,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 		wil_err(wil, "config tx vring failed for CID %d, rc (%d)\n",
 			evt->cid, rc);
 		wmi_disconnect_sta(vif, wil->sta[evt->cid].addr,
-				   WLAN_REASON_UNSPECIFIED, false, false);
+				   WLAN_REASON_UNSPECIFIED, false);
 	} else {
 		wil_info(wil, "successful connection to CID %d\n", evt->cid);
 	}
@@ -1112,7 +1112,7 @@ static void wmi_evt_disconnect(struct wil6210_vif *vif, int id,
 	}
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(vif, evt->bssid, reason_code, true);
+	wil6210_disconnect_complete(vif, evt->bssid, reason_code);
 	mutex_unlock(&wil->mutex);
 }
 
@@ -1637,7 +1637,7 @@ static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
 	return;
 
 fail:
-	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID, false);
+	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID);
 }
 
 static void
@@ -1766,7 +1766,7 @@ static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
 	return;
 
 fail:
-	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID, false);
+	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID);
 }
 
 /**
@@ -2560,12 +2560,11 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_bb, u32 *t_rf)
 	return 0;
 }
 
-int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac,
-		       u16 reason, bool full_disconnect, bool del_sta)
+int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac, u16 reason,
+		       bool del_sta)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
 	int rc;
-	u16 reason_code;
 	struct wmi_disconnect_sta_cmd disc_sta_cmd = {
 		.disconnect_reason = cpu_to_le16(reason),
 	};
@@ -2598,21 +2597,8 @@ int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac,
 		wil_fw_error_recovery(wil);
 		return rc;
 	}
+	wil->sinfo_gen++;
 
-	if (full_disconnect) {
-		/* call event handler manually after processing wmi_call,
-		 * to avoid deadlock - disconnect event handler acquires
-		 * wil->mutex while it is already held here
-		 */
-		reason_code = le16_to_cpu(reply.evt.protocol_reason_status);
-
-		wil_dbg_wmi(wil, "Disconnect %pM reason [proto %d wmi %d]\n",
-			    reply.evt.bssid, reason_code,
-			    reply.evt.disconnect_reason);
-
-		wil->sinfo_gen++;
-		wil6210_disconnect(vif, reply.evt.bssid, reason_code, true);
-	}
 	return 0;
 }
 
-- 
1.9.1

