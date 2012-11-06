Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1169 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab2KFAWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 24/24] brcmfmac: use struct brcmf_if parameter in
 firmware event callbacks
Date: Mon, 5 Nov 2012 16:22:32 -0800
Message-ID: <1352161352-30405-25-git-send-email-frankyl@broadcom.com> (sfid-20121106_012314_513886_EB3B6B14)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Firmware events are passed to wl_cfg80211 module associated with
the primary net device. With virtual interface support events can
be received for different interfaces, ie. struct brcmf_if instances.
Pass it in the event to determine appropriate net device associated
with the event.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    3 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   47 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   42 ++++++++---------
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2bb1207..c2cd28e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -304,8 +304,9 @@ static int brcmf_host_event(struct brcmf_pub *drvr, int *ifidx,
 	if (bcmerror != 0)
 		return bcmerror;
 
+	/* only forward if interface has netdev */
 	if (drvr->iflist[*ifidx]->ndev)
-		brcmf_cfg80211_event(drvr->iflist[*ifidx]->ndev,
+		brcmf_cfg80211_event(drvr->iflist[*ifidx],
 				     event, *data);
 
 	return bcmerror;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4fbf5b3..4387ca5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2453,10 +2453,11 @@ brcmf_compare_update_same_bss(struct brcmf_bss_info_le *bss,
 }
 
 static s32
-brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_info *cfg,
-			     struct net_device *ndev,
+brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			     const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct net_device *ndev = ifp->ndev;
 	s32 status;
 	s32 err = 0;
 	struct brcmf_escan_result_le *escan_result_le;
@@ -2772,10 +2773,11 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
  * cfg80211_scan_request one out of the received PNO event.
  */
 static s32
-brcmf_notify_sched_scan_results(struct brcmf_cfg80211_info *cfg,
-				struct net_device *ndev,
+brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct net_device *ndev = ifp->ndev;
 	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
 	struct cfg80211_scan_request *request = NULL;
 	struct cfg80211_ssid *ssid = NULL;
@@ -4111,11 +4113,11 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 }
 
 static s32
-brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
-			    struct net_device *ndev,
+brcmf_notify_connect_status(struct brcmf_if *ifp,
 			    const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct net_device *ndev = ifp->ndev;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	s32 err = 0;
 
@@ -4163,28 +4165,26 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 }
 
 static s32
-brcmf_notify_roaming_status(struct brcmf_cfg80211_info *cfg,
-			    struct net_device *ndev,
+brcmf_notify_roaming_status(struct brcmf_if *ifp,
 			    const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 err = 0;
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
 		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
-			brcmf_bss_roaming_done(cfg, ndev, e);
+			brcmf_bss_roaming_done(cfg, ifp->ndev, e);
 		else
-			brcmf_bss_connect_done(cfg, ndev, e, true);
+			brcmf_bss_connect_done(cfg, ifp->ndev, e, true);
 	}
 
 	return err;
 }
 
 static s32
-brcmf_notify_mic_status(struct brcmf_cfg80211_info *cfg,
-			struct net_device *ndev,
+brcmf_notify_mic_status(struct brcmf_if *ifp,
 			const struct brcmf_event_msg *e, void *data)
 {
 	u16 flags = be16_to_cpu(e->flags);
@@ -4195,7 +4195,7 @@ brcmf_notify_mic_status(struct brcmf_cfg80211_info *cfg,
 	else
 		key_type = NL80211_KEYTYPE_PAIRWISE;
 
-	cfg80211_michael_mic_failure(ndev, (u8 *)&e->addr, key_type, -1,
+	cfg80211_michael_mic_failure(ifp->ndev, (u8 *)&e->addr, key_type, -1,
 				     NULL, GFP_KERNEL);
 
 	return 0;
@@ -4288,9 +4288,10 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 */
 
 static s32
-brcmf_enq_event(struct brcmf_cfg80211_info *cfg, u32 event,
+brcmf_enq_event(struct brcmf_if *ifp, u32 event,
 		const struct brcmf_event_msg *msg, void *data)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
 	ulong flags;
@@ -4308,6 +4309,7 @@ brcmf_enq_event(struct brcmf_cfg80211_info *cfg, u32 event,
 		return -ENOMEM;
 
 	e->etype = event;
+	e->ifp = ifp;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 	if (data)
 		memcpy(&e->edata, data, data_len);
@@ -4340,9 +4342,7 @@ static void brcmf_cfg80211_event_handler(struct work_struct *work)
 	do {
 		WL_INFO("event type (%d)\n", e->etype);
 		if (cfg->el.handler[e->etype])
-			cfg->el.handler[e->etype](cfg,
-						       cfg_to_ndev(cfg),
-						       &e->emsg, e->edata);
+			cfg->el.handler[e->etype](e->ifp, &e->emsg, e->edata);
 		else
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
 		brcmf_put_event(e);
@@ -4461,14 +4461,13 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	}
 }
 
-void
-brcmf_cfg80211_event(struct net_device *ndev,
-		  const struct brcmf_event_msg *e, void *data)
+void brcmf_cfg80211_event(struct brcmf_if *ifp,
+			  const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	u32 event_type = be32_to_cpu(e->event_type);
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
-	if (!brcmf_enq_event(cfg, event_type, e, data))
+	if (!brcmf_enq_event(ifp, event_type, e, data))
 		schedule_work(&cfg->event_work);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index e4de9fc..399925d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -137,17 +137,6 @@ struct brcmf_cfg80211_conf {
 	struct ieee80211_channel channel;
 };
 
-/* forward declaration */
-struct brcmf_cfg80211_info;
-
-/* cfg80211 main event loop */
-struct brcmf_cfg80211_event_loop {
-	s32(*handler[BRCMF_E_LAST]) (struct brcmf_cfg80211_info *cfg,
-				     struct net_device *ndev,
-				     const struct brcmf_event_msg *e,
-				     void *data);
-};
-
 /* basic structure of scan request */
 struct brcmf_cfg80211_scan_req {
 	struct brcmf_ssid_le ssid_le;
@@ -159,14 +148,6 @@ struct brcmf_cfg80211_ie {
 	u8 buf[WL_TLV_INFO_MAX];
 };
 
-/* event queue for cfg80211 main event */
-struct brcmf_cfg80211_event_q {
-	struct list_head evt_q_list;
-	u32 etype;
-	struct brcmf_event_msg emsg;
-	s8 edata[1];
-};
-
 /* security information with currently associated ap */
 struct brcmf_cfg80211_security {
 	u32 wpa_versions;
@@ -245,6 +226,25 @@ struct brcmf_cfg80211_vif {
 	struct list_head list;
 };
 
+/* forward declaration */
+struct brcmf_cfg80211_info;
+
+/* cfg80211 main event loop */
+struct brcmf_cfg80211_event_loop {
+	s32(*handler[BRCMF_E_LAST]) (struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *e,
+				     void *data);
+};
+
+/* event queue for cfg80211 main event */
+struct brcmf_cfg80211_event_q {
+	struct list_head evt_q_list;
+	u32 etype;
+	struct brcmf_if *ifp;
+	struct brcmf_event_msg emsg;
+	s8 edata[1];
+};
+
 /* association inform */
 struct brcmf_cfg80211_connect_info {
 	u8 *req_ie;
@@ -484,8 +484,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 
 /* event handler from dongle */
-void brcmf_cfg80211_event(struct net_device *ndev,
-			  const struct brcmf_event_msg *e, void *data);
+void brcmf_cfg80211_event(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
+			  void *data);
 s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg);
 
-- 
1.7.9.5


