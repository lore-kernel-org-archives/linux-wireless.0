Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1567 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765926Ab3DEI6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/16] brcmfmac: use struct brcmf_if instance iso
 netdevice in escan functions
Date: Fri, 5 Apr 2013 10:57:49 +0200
Message-ID: <1365152274-4252-12-git-send-email-arend@broadcom.com> (sfid-20130405_111305_245833_822EBD19)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

escan functionality is also required for P2P device operations so it
is better not to rely on struct netdevice instances.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   17 ++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   68 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    9 ++-
 3 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 454a8de..e587dfb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -773,7 +773,7 @@ exit:
  * validates the channels in the request.
  */
 static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
-			       struct net_device *ndev,
+			       struct brcmf_if *ifp,
 			       struct cfg80211_scan_request *request,
 			       u16 action)
 {
@@ -1261,7 +1261,7 @@ static void
 brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
-	struct net_device *ndev = cfg->escan_info.ndev;
+	struct brcmf_if *ifp = cfg->escan_info.ifp;
 
 	if (test_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status) &&
 	    (test_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status) ||
@@ -1271,12 +1271,12 @@ brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
 		 * So abort scan for off channel completion.
 		 */
 		if (p2p->af_sent_channel)
-			brcmf_notify_escan_complete(cfg, ndev, true, true);
+			brcmf_notify_escan_complete(cfg, ifp, true, true);
 	} else if (test_bit(BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
 			    &p2p->status)) {
 		brcmf_dbg(TRACE, "*** Wake UP ** abort listen for next af frame\n");
 		/* So abort scan to cancel listen */
-		brcmf_notify_escan_complete(cfg, ndev, true, true);
+		brcmf_notify_escan_complete(cfg, ifp, true, true);
 	}
 }
 
@@ -1637,6 +1637,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_fil_af_params_le *af_params)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_config_af_params config_af_params;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
@@ -1725,7 +1726,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 
 	/* To make sure to send successfully action frame, turn off mpc */
 	if (config_af_params.mpc_onoff == 0)
-		brcmf_set_mpc(netdev_priv(ndev), 0);
+		brcmf_set_mpc(ifp, 0);
 
 	/* set status and destination address before sending af */
 	if (p2p->next_af_subtype != P2P_PAF_SUBTYPE_INVALID) {
@@ -1753,7 +1754,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		 * care of current piggback algo, lets abort the scan here
 		 * itself.
 		 */
-		brcmf_notify_escan_complete(cfg, ndev, true, true);
+		brcmf_notify_escan_complete(cfg, ifp, true, true);
 
 		/* update channel */
 		af_params->channel = cpu_to_le32(afx_hdl->peer_chan);
@@ -1820,7 +1821,7 @@ exit:
 	clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status);
 	/* if all done, turn mpc on again */
 	if (config_af_params.mpc_onoff == 1)
-		brcmf_set_mpc(netdev_priv(ndev), 1);
+		brcmf_set_mpc(ifp, 1);
 
 	return ack;
 }
@@ -2040,7 +2041,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		brcmf_err("vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
 		return -EPERM;
 	}
-	brcmf_notify_escan_complete(cfg, vif->ifp->ndev, true, true);
+	brcmf_notify_escan_complete(cfg, vif->ifp, true, true);
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
 	if (!vif) {
 		brcmf_err("vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3b79f0c..d4e1201 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -504,12 +504,10 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 	}
 }
 
-s32
-brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
-			    struct net_device *ndev,
-			    bool aborted, bool fw_abort)
+s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
+				struct brcmf_if *ifp, bool aborted,
+				bool fw_abort)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_scan_params_le params_le;
 	struct cfg80211_scan_request *scan_request;
 	s32 err = 0;
@@ -578,9 +576,9 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	if (ndev) {
 		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status) &&
-		    cfg->escan_info.ndev == ndev)
-			brcmf_notify_escan_complete(cfg, ndev, true,
-						    true);
+		    cfg->escan_info.ifp == netdev_priv(ndev))
+			brcmf_notify_escan_complete(cfg, netdev_priv(ndev),
+						    true, true);
 
 		brcmf_fil_iovar_int_set(netdev_priv(ndev), "mpc", 1);
 	}
@@ -762,7 +760,7 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 }
 
 static s32
-brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
+brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		struct cfg80211_scan_request *request, u16 action)
 {
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
@@ -791,8 +789,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 	params->action = cpu_to_le16(action);
 	params->sync_id = cpu_to_le16(0x1234);
 
-	err = brcmf_fil_iovar_data_set(netdev_priv(ndev), "escan",
-				       params, params_size);
+	err = brcmf_fil_iovar_data_set(ifp, "escan", params, params_size);
 	if (err) {
 		if (err == -EBUSY)
 			brcmf_dbg(INFO, "system busy : escan canceled\n");
@@ -807,16 +804,15 @@ exit:
 
 static s32
 brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
-	       struct net_device *ndev, struct cfg80211_scan_request *request)
+	       struct brcmf_if *ifp, struct cfg80211_scan_request *request)
 {
 	s32 err;
 	u32 passive_scan;
 	struct brcmf_scan_results *results;
 	struct escan_info *escan = &cfg->escan_info;
-	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	brcmf_dbg(SCAN, "Enter\n");
-	escan->ndev = ndev;
+	escan->ifp = ifp;
 	escan->wiphy = wiphy;
 	escan->escan_state = WL_ESCAN_STATE_SCANNING;
 	passive_scan = cfg->active_scan ? 0 : 1;
@@ -832,19 +828,19 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	results->count = 0;
 	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
 
-	err = escan->run(cfg, ndev, request, WL_ESCAN_ACTION_START);
+	err = escan->run(cfg, ifp, request, WL_ESCAN_ACTION_START);
 	if (err)
 		brcmf_set_mpc(ifp, 1);
 	return err;
 }
 
 static s32
-brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
+brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 		     struct cfg80211_scan_request *request,
 		     struct cfg80211_ssid *this_ssid)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_if *ifp = vif->ifp;
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = &cfg->scan_req_int;
 	u32 passive_scan;
@@ -870,10 +866,8 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	/* If scan req comes for p2p0, send it over primary I/F */
-	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
-		ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
-		ndev = ifp->ndev;
-	}
+	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
+		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
 	/* Arm scan timeout timer */
 	mod_timer(&cfg->escan_timeout, jiffies +
@@ -894,11 +888,11 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
 		cfg->escan_info.run = brcmf_run_escan;
-		err = brcmf_p2p_scan_prep(wiphy, request, ifp->vif);
+		err = brcmf_p2p_scan_prep(wiphy, request, vif);
 		if (err)
 			goto scan_out;
 
-		err = brcmf_do_escan(cfg, wiphy, ndev, request);
+		err = brcmf_do_escan(cfg, wiphy, vif->ifp, request);
 		if (err)
 			goto scan_out;
 	} else {
@@ -950,16 +944,15 @@ scan_out:
 static s32
 brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
-	struct net_device *ndev = request->wdev->netdev;
+	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
-
-	if (!check_vif_up(container_of(request->wdev,
-				       struct brcmf_cfg80211_vif, wdev)))
+	vif = container_of(request->wdev, struct brcmf_cfg80211_vif, wdev);
+	if (!check_vif_up(vif))
 		return -EIO;
 
-	err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
+	err = brcmf_cfg80211_escan(wiphy, vif, request, NULL);
 
 	if (err)
 		brcmf_err("scan error (%d)\n", err);
@@ -2471,7 +2464,7 @@ void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 	set_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
 	if (cfg->scan_request) {
 		escan->escan_state = WL_ESCAN_STATE_IDLE;
-		brcmf_notify_escan_complete(cfg, escan->ndev, true, true);
+		brcmf_notify_escan_complete(cfg, escan->ifp, true, true);
 	}
 	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	clear_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
@@ -2483,7 +2476,7 @@ static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
 			container_of(work, struct brcmf_cfg80211_info,
 				     escan_timeout_work);
 
-	brcmf_notify_escan_complete(cfg, cfg->escan_info.ndev, true, true);
+	brcmf_notify_escan_complete(cfg, cfg->escan_info.ifp, true, true);
 }
 
 static void brcmf_escan_timeout(unsigned long data)
@@ -2534,7 +2527,6 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			     const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct net_device *ndev = ifp->ndev;
 	s32 status;
 	s32 err = 0;
 	struct brcmf_escan_result_le *escan_result_le;
@@ -2547,9 +2539,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
 	status = e->status;
 
-	if (!ndev || !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("scan not ready ndev %p drv_status %x\n", ndev,
-			  !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
+	if (!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		brcmf_err("scan not ready, bssidx=%d\n", ifp->bssidx);
 		return -EPERM;
 	}
 
@@ -2620,7 +2611,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 				cfg->escan_info.escan_buf;
 			brcmf_inform_bss(cfg);
 			aborted = status != BRCMF_E_STATUS_SUCCESS;
-			brcmf_notify_escan_complete(cfg, ndev, aborted,
+			brcmf_notify_escan_complete(cfg, ifp, aborted,
 						    false);
 		} else
 			brcmf_dbg(SCAN, "Ignored scan complete result 0x%x\n",
@@ -2856,7 +2847,6 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct net_device *ndev = ifp->ndev;
 	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
 	struct cfg80211_scan_request *request = NULL;
 	struct cfg80211_ssid *ssid = NULL;
@@ -2940,7 +2930,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 		}
 
 		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-		err = brcmf_do_escan(cfg, wiphy, ndev, request);
+		err = brcmf_do_escan(cfg, wiphy, ifp, request);
 		if (err) {
 			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 			goto out_err;
@@ -3097,7 +3087,7 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 	brcmf_dbg(SCAN, "enter\n");
 	brcmf_dev_pno_clean(ndev);
 	if (cfg->sched_escan)
-		brcmf_notify_escan_complete(cfg, ndev, true, true);
+		brcmf_notify_escan_complete(cfg, netdev_priv(ndev), true, true);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index cd4af98..2907437 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -238,9 +238,8 @@ struct escan_info {
 	u32 escan_state;
 	u8 escan_buf[WL_ESCAN_BUF_SIZE];
 	struct wiphy *wiphy;
-	struct net_device *ndev;
-	s32 (*run)(struct brcmf_cfg80211_info *cfg,
-		   struct net_device *ndev,
+	struct brcmf_if *ifp;
+	s32 (*run)(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		   struct cfg80211_scan_request *request, u16 action);
 };
 
@@ -493,8 +492,8 @@ bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
 int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 					  u8 action, ulong timeout);
 s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
-				struct net_device *ndev,
-				bool aborted, bool fw_abort);
+				struct brcmf_if *ifp, bool aborted,
+				bool fw_abort);
 void brcmf_set_mpc(struct brcmf_if *ndev, int mpc);
 void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg);
 
-- 
1.7.10.4


