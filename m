Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2966 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab2JVRgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/14] brcmfmac: use struct brcmf_if as interface object
 for fwil functions
Date: Mon, 22 Oct 2012 10:36:23 -0700
Message-ID: <1350927387-25608-11-git-send-email-frankyl@broadcom.com> (sfid-20121022_193647_732474_E0C91BFF)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The functions for communicating were given the net_device only because
its private data contained struct brcmf_if object. However, not all
firmware related interfaces will be associated with a net_device. To
accomodate provisioning firmware for such interfaces the struct
brcmf_if object will be passed to the fwil functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   40 ++--
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   26 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  251 +++++++++++---------
 3 files changed, 162 insertions(+), 155 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index a3a39cc..6c39308 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -57,9 +57,8 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 }
 
 s32
-brcmf_fil_cmd_data_set(struct net_device *ndev, u32 cmd, void *data, u32 len)
+brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	mutex_lock(&ifp->drvr->proto_block);
@@ -74,9 +73,8 @@ brcmf_fil_cmd_data_set(struct net_device *ndev, u32 cmd, void *data, u32 len)
 }
 
 s32
-brcmf_fil_cmd_data_get(struct net_device *ndev, u32 cmd, void *data, u32 len)
+brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	mutex_lock(&ifp->drvr->proto_block);
@@ -92,9 +90,8 @@ brcmf_fil_cmd_data_get(struct net_device *ndev, u32 cmd, void *data, u32 len)
 
 
 s32
-brcmf_fil_cmd_int_set(struct net_device *ndev, u32 cmd, u32 data)
+brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 	__le32 data_le = cpu_to_le32(data);
 
@@ -106,9 +103,8 @@ brcmf_fil_cmd_int_set(struct net_device *ndev, u32 cmd, u32 data)
 }
 
 s32
-brcmf_fil_cmd_int_get(struct net_device *ndev, u32 cmd, u32 *data)
+brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 	__le32 data_le = cpu_to_le32(*data);
 
@@ -141,10 +137,9 @@ brcmf_create_iovar(char *name, char *data, u32 datalen, char *buf, u32 buflen)
 
 
 s32
-brcmf_fil_iovar_data_set(struct net_device *ndev, char *name, void *data,
+brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
 			 u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u32 buflen;
@@ -169,10 +164,9 @@ brcmf_fil_iovar_data_set(struct net_device *ndev, char *name, void *data,
 }
 
 s32
-brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
+brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			 u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u32 buflen;
@@ -199,20 +193,20 @@ brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
 }
 
 s32
-brcmf_fil_iovar_int_set(struct net_device *ndev, char *name, u32 data)
+brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
-	return brcmf_fil_iovar_data_set(ndev, name, &data_le, sizeof(data_le));
+	return brcmf_fil_iovar_data_set(ifp, name, &data_le, sizeof(data_le));
 }
 
 s32
-brcmf_fil_iovar_int_get(struct net_device *ndev, char *name, u32 *data)
+brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
 
-	err = brcmf_fil_iovar_data_get(ndev, name, &data_le, sizeof(data_le));
+	err = brcmf_fil_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
 	if (err == 0)
 		*data = le32_to_cpu(data_le);
 	return err;
@@ -264,10 +258,9 @@ brcmf_create_bsscfg(s32 bssidx, char *name, char *data, u32 datalen, char *buf,
 }
 
 s32
-brcmf_fil_bsscfg_data_set(struct net_device *ndev, char *name,
+brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 			  void *data, u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u32 buflen;
@@ -292,10 +285,9 @@ brcmf_fil_bsscfg_data_set(struct net_device *ndev, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_data_get(struct net_device *ndev, char *name,
+brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 			  void *data, u32 len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u32 buflen;
@@ -322,21 +314,21 @@ brcmf_fil_bsscfg_data_get(struct net_device *ndev, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_int_set(struct net_device *ndev, char *name, u32 data)
+brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
-	return brcmf_fil_bsscfg_data_set(ndev, name, &data_le,
+	return brcmf_fil_bsscfg_data_set(ifp, name, &data_le,
 					 sizeof(data_le));
 }
 
 s32
-brcmf_fil_bsscfg_int_get(struct net_device *ndev, char *name, u32 *data)
+brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
 
-	err = brcmf_fil_bsscfg_data_get(ndev, name, &data_le,
+	err = brcmf_fil_bsscfg_data_get(ifp, name, &data_le,
 					sizeof(data_le));
 	if (err == 0)
 		*data = le32_to_cpu(data_le);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 4d08499..16eb820 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -17,25 +17,23 @@
 #ifndef _fwil_h_
 #define _fwil_h_
 
-s32 brcmf_fil_cmd_data_set(struct net_device *ndev, u32 cmd, void *data,
-			   u32 len);
-s32 brcmf_fil_cmd_data_get(struct net_device *ndev, u32 cmd, void *data,
-			   u32 len);
-s32 brcmf_fil_cmd_int_set(struct net_device *ndev, u32 cmd, u32 data);
-s32 brcmf_fil_cmd_int_get(struct net_device *ndev, u32 cmd, u32 *data);
+s32 brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
+s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
+s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
+s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data);
 
-s32 brcmf_fil_iovar_data_set(struct net_device *ndev, char *name, void *data,
+s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
 			     u32 len);
-s32 brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
+s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			     u32 len);
-s32 brcmf_fil_iovar_int_set(struct net_device *ndev, char *name, u32 data);
-s32 brcmf_fil_iovar_int_get(struct net_device *ndev, char *name, u32 *data);
+s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data);
+s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data);
 
-s32 brcmf_fil_bsscfg_data_set(struct net_device *ndev, char *name, void *data,
+s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name, void *data,
 			      u32 len);
-s32 brcmf_fil_bsscfg_data_get(struct net_device *ndev, char *name, void *data,
+s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name, void *data,
 			      u32 len);
-s32 brcmf_fil_bsscfg_int_set(struct net_device *ndev, char *name, u32 data);
-s32 brcmf_fil_bsscfg_int_get(struct net_device *ndev, char *name, u32 *data);
+s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data);
+s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data);
 
 #endif /* _fwil_h_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5a3093d..61d9489 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -442,7 +442,7 @@ send_key_to_dongle(struct brcmf_cfg80211_info *cfg, s32 bssidx,
 
 	brcmf_netdev_wait_pend8021x(ndev);
 
-	err = brcmf_fil_bsscfg_data_set(ndev, "wsec_key", &key_le,
+	err = brcmf_fil_bsscfg_data_set(netdev_priv(ndev), "wsec_key", &key_le,
 					sizeof(key_le));
 
 	if (err)
@@ -496,7 +496,8 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		WL_INFO("IF Type = AP\n");
 	} else {
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_INFRA, infra);
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+					    BRCMF_C_SET_INFRA, infra);
 		if (err) {
 			WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
@@ -530,7 +531,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
 	if (test_bit(WL_STATUS_READY, &cfg->status)) {
-		err = brcmf_fil_iovar_int_set(ndev, "mpc", mpc);
+		err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "mpc", mpc);
 		if (err) {
 			WL_ERR("fail to set mpc\n");
 			return;
@@ -578,8 +579,8 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
-	err = brcmf_fil_iovar_data_set(iscan->ndev, "iscan", params,
-				       params_size);
+	err = brcmf_fil_iovar_data_set(netdev_priv(iscan->ndev), "iscan",
+				       params, params_size);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
@@ -605,7 +606,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_info *cfg)
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
 	passive_scan = cfg->active_scan ? 0 : 1;
-	err = brcmf_fil_cmd_int_set(cfg_to_ndev(cfg),
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
 				    BRCMF_C_SET_PASSIVE_SCAN, passive_scan);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -689,15 +690,16 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 
 		passive_scan = cfg->active_scan ? 0 : 1;
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+					    BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &sr->ssid_le,
-					     sizeof(sr->ssid_le));
+		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				WL_INFO("system busy : scan for \"%s\" "
@@ -829,8 +831,8 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		/* Scan is aborted by setting channel_list[0] to -1 */
 		params_le.channel_list[0] = cpu_to_le16(-1);
 		/* E-Scan (or anyother type) can be aborted by SCAN */
-		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &params_le,
-					     sizeof(params_le));
+		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+					     &params_le, sizeof(params_le));
 		if (err)
 			WL_ERR("Scan abort  failed\n");
 	}
@@ -888,7 +890,8 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 	params->action = cpu_to_le16(action);
 	params->sync_id = cpu_to_le16(0x1234);
 
-	err = brcmf_fil_iovar_data_set(ndev, "escan", params, params_size);
+	err = brcmf_fil_iovar_data_set(netdev_priv(ndev), "escan",
+				       params, params_size);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : escan canceled\n");
@@ -914,7 +917,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	cfg->escan_info.wiphy = wiphy;
 	cfg->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
 	passive_scan = cfg->active_scan ? 0 : 1;
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PASSIVE_SCAN,
 				    passive_scan);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -1001,15 +1004,16 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 
 		passive_scan = cfg->active_scan ? 0 : 1;
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+					    BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &sr->ssid_le,
-					     sizeof(sr->ssid_le));
+		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				WL_INFO("BUSY: scan for \"%s\" canceled\n",
@@ -1061,7 +1065,8 @@ static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_fil_iovar_int_set(ndev, "rtsthresh", rts_threshold);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "rtsthresh",
+				      rts_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
@@ -1072,7 +1077,8 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_fil_iovar_int_set(ndev, "fragthresh", frag_threshold);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "fragthresh",
+				      frag_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
@@ -1084,7 +1090,7 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 	s32 err = 0;
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
-	err = brcmf_fil_cmd_int_set(ndev, cmd, retry);
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), cmd, retry);
 	if (err) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -1178,7 +1184,8 @@ static void brcmf_link_down(struct brcmf_cfg80211_info *cfg)
 	if (cfg->link_up) {
 		ndev = cfg_to_ndev(cfg);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_DISASSOC, NULL, 0);
+		err = brcmf_fil_cmd_data_set(netdev_priv(ndev),
+					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		cfg->link_up = false;
@@ -1250,7 +1257,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	if (params->privacy)
 		wsec |= WEP_ENABLED;
 
-	err = brcmf_fil_iovar_int_set(ndev, "wsec", wsec);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", wsec);
 	if (err) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
@@ -1262,7 +1269,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_fil_cmd_int_set(ndev, BRCM_SET_BCNPRD, bcnprd);
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCM_SET_BCNPRD, bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1304,7 +1311,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 		/* set channel for starter */
 		target_channel = cfg->channel;
-		err = brcmf_fil_cmd_int_set(ndev, BRCM_SET_CHANNEL,
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCM_SET_CHANNEL,
 					    target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -1316,7 +1323,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	cfg->ibss_starter = false;
 
 
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID,
+	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1363,7 +1370,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	else
 		val = WPA_AUTH_DISABLED;
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
-	err = brcmf_fil_iovar_int_set(ndev, "wpa_auth", val);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
@@ -1403,7 +1410,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		break;
 	}
 
-	err = brcmf_fil_iovar_int_set(ndev, "auth", val);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "auth", val);
 	if (err) {
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
@@ -1468,7 +1475,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 	}
 
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
-	err = brcmf_fil_iovar_int_set(ndev, "wsec", pval | gval);
+	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", pval | gval);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -1491,7 +1498,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	s32 err = 0;
 
 	if (sme->crypto.n_akm_suites) {
-		err = brcmf_fil_iovar_int_get(ndev, "wpa_auth", &val);
+		err = brcmf_fil_iovar_int_get(netdev_priv(ndev),
+					      "wpa_auth", &val);
 		if (err) {
 			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
@@ -1525,7 +1533,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		}
 
 		WL_CONN("setting wpa_auth to %d\n", val);
-		err = brcmf_fil_iovar_int_set(ndev, "wpa_auth", val);
+		err = brcmf_fil_iovar_int_set(netdev_priv(ndev),
+					      "wpa_auth", val);
 		if (err) {
 			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
@@ -1598,7 +1607,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	if (sec->auth_type == NL80211_AUTHTYPE_SHARED_KEY) {
 		WL_CONN("set auth_type to shared key\n");
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
-		err = brcmf_fil_bsscfg_int_set(ndev, "auth", val);
+		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 		if (err)
 			WL_ERR("set auth failed (%d)\n", err);
 	}
@@ -1686,7 +1695,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_ch_to_chanspec(cfg->channel,
 			     &join_params, &join_params_size);
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID,
+	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1715,8 +1724,8 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_DISASSOC, &scbval,
-				     sizeof(struct brcmf_scb_val_le));
+	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_DISASSOC,
+				     &scbval, sizeof(scbval));
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -1732,7 +1741,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 {
 
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
@@ -1756,7 +1765,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	}
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_RADIO, disable);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_RADIO, disable);
 	if (err)
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1764,8 +1773,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 		txpwrmw = 0xffff;
 	else
 		txpwrmw = (u16) dbm;
-	err = brcmf_fil_iovar_int_set(ndev, "qtxpower",
-			(s32) (brcmf_mw_to_qdbm(txpwrmw)));
+	err = brcmf_fil_iovar_int_set(ifp, "qtxpower",
+				      (s32)brcmf_mw_to_qdbm(txpwrmw));
 	if (err)
 		WL_ERR("qtxpower error (%d)\n", err);
 	cfg->conf->tx_power = dbm;
@@ -1787,7 +1796,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_fil_iovar_int_get(ndev, "qtxpower", &txpwrdbm);
+	err = brcmf_fil_iovar_int_get(netdev_priv(ndev), "qtxpower", &txpwrdbm);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		goto done;
@@ -1805,19 +1814,16 @@ static s32
 brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
-	s32 bssidx;
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1826,8 +1832,8 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
 		index = key_idx;
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_KEY_PRIMARY,
-					    index);
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
 			WL_ERR("error (%d)\n", err);
 	}
@@ -1996,13 +2002,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		goto done;
 
-	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
-	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
@@ -2072,7 +2078,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&params, 0, sizeof(params));
 
 	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -2138,7 +2144,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (cfg->conf->mode == WL_MODE_AP) {
 		memcpy(&sta_info_le, mac, ETH_ALEN);
-		err = brcmf_fil_iovar_data_get(ndev, "sta_info", &sta_info_le,
+		err = brcmf_fil_iovar_data_get(netdev_priv(ndev), "sta_info",
+					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
 			WL_ERR("GET STA INFO failed, %d\n", err);
@@ -2160,7 +2167,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 		/* Report the current tx rate */
-	err = brcmf_fil_cmd_int_get(ndev, BRCMF_C_GET_RATE, &rate);
+	err = brcmf_fil_cmd_int_get(netdev_priv(ndev), BRCMF_C_GET_RATE, &rate);
 		if (err) {
 			WL_ERR("Could not get rate (%d)\n", err);
 			goto done;
@@ -2172,8 +2179,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 
 		if (test_bit(WL_STATUS_CONNECTED, &cfg->status)) {
 			memset(&scb_val, 0, sizeof(scb_val));
-		err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_RSSI, &scb_val,
-					     sizeof(struct brcmf_scb_val_le));
+		err = brcmf_fil_cmd_data_get(netdev_priv(ndev),
+					     BRCMF_C_GET_RSSI, &scb_val,
+					     sizeof(scb_val));
 			if (err) {
 				WL_ERR("Could not get rssi (%d)\n", err);
 				goto done;
@@ -2218,7 +2226,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	pm = enabled ? PM_FAST : PM_OFF;
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PM, pm);
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -2249,8 +2257,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_fil_cmd_data_get(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
-				     sizeof(rateset_le));
+	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCM_GET_CURR_RATESET,
+				     &rateset_le, sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
 		goto done;
@@ -2277,8 +2285,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	 *      Set rate override,
 	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
 	 */
-	err_bg = brcmf_fil_iovar_int_set(ndev, "bg_rate", rate);
-	err_a = brcmf_fil_iovar_int_set(ndev, "a_rate", rate);
+	err_bg = brcmf_fil_iovar_int_set(netdev_priv(ndev), "bg_rate", rate);
+	err_a = brcmf_fil_iovar_int_set(netdev_priv(ndev), "a_rate", rate);
 	if (err_bg && err_a) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
@@ -2407,8 +2415,8 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_BSS_INFO, buf,
-				     WL_BSS_INFO_MAX);
+	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
+				     buf, WL_BSS_INFO_MAX);
 	if (err) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2533,6 +2541,7 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
 	struct brcmf_tlv *tim;
@@ -2549,8 +2558,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	ssid = &profile->ssid;
 
 	*(__le32 *)cfg->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_fil_cmd_data_get(cfg_to_ndev(cfg),
-				     BRCMF_C_GET_BSS_INFO,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
 		WL_ERR("Could not get bss info %d\n", err);
@@ -2576,8 +2584,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = brcmf_fil_iovar_int_get(cfg_to_ndev(cfg),
-					      "dtim_assoc", &var);
+		err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
 		if (err) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
@@ -2677,7 +2684,7 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 	results_le->version = 0;
 	results_le->count = 0;
 
-	err = brcmf_fil_iovar_data_get(iscan->ndev, "iscanresults",
+	err = brcmf_fil_iovar_data_get(netdev_priv(iscan->ndev), "iscanresults",
 				       iscan->scan_buf,
 				       sizeof(iscan->scan_buf));
 	if (err) {
@@ -3080,8 +3087,8 @@ brcmf_update_pmklist(struct net_device *ndev,
 	}
 
 	if (!err)
-		brcmf_fil_iovar_data_set(ndev, "pmkid_info", (char *)pmk_list,
-					 sizeof(*pmk_list));
+		brcmf_fil_iovar_data_set(netdev_priv(ndev), "pmkid_info",
+					 (char *)pmk_list, sizeof(*pmk_list));
 
 	return err;
 }
@@ -3320,10 +3327,11 @@ static int brcmf_dev_pno_clean(struct net_device *ndev)
 	int ret;
 
 	/* Disable pfn */
-	ret = brcmf_fil_iovar_int_set(ndev, "pfn", 0);
+	ret = brcmf_fil_iovar_int_set(netdev_priv(ndev), "pfn", 0);
 	if (ret == 0) {
 		/* clear pfn */
-		ret = brcmf_fil_iovar_data_set(ndev, "pfnclear", NULL, 0);
+		ret = brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfnclear",
+					       NULL, 0);
 	}
 	if (ret < 0)
 		WL_ERR("failed code %d\n", ret);
@@ -3346,8 +3354,8 @@ static int brcmf_dev_pno_config(struct net_device *ndev)
 	/* set up pno scan fr */
 	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
 
-	return brcmf_fil_iovar_data_set(ndev, "pfn_set", &pfn_param,
-					sizeof(pfn_param));
+	return brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfn_set",
+					&pfn_param, sizeof(pfn_param));
 }
 
 static int
@@ -3420,14 +3428,15 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
 			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
 			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
-			ret = brcmf_fil_iovar_data_set(ndev, "pfn_add",
-						       &pfn, sizeof(pfn));
+			ret = brcmf_fil_iovar_data_set(netdev_priv(ndev),
+						       "pfn_add", &pfn,
+						       sizeof(pfn));
 			WL_SCAN(">>> PNO filter %s for ssid (%s)\n",
 				ret == 0 ? "set" : "failed",
 				ssid->ssid);
 		}
 		/* Enable the PNO */
-		if (brcmf_fil_iovar_int_set(ndev, "pfn", 1) < 0) {
+		if (brcmf_fil_iovar_int_set(netdev_priv(ndev), "pfn", 1) < 0) {
 			WL_ERR("PNO enable failed!! ret=%d\n", ret);
 			return -EINVAL;
 		}
@@ -3464,11 +3473,11 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 		 dcmd->buf, dcmd->len);
 
 	if (dcmd->set)
-		ret = brcmf_fil_cmd_data_set(ndev, dcmd->cmd, dcmd->buf,
-					     dcmd->len);
+		ret = brcmf_fil_cmd_data_set(netdev_priv(ndev), dcmd->cmd,
+					     dcmd->buf, dcmd->len);
 	else
-		ret = brcmf_fil_cmd_data_get(ndev, dcmd->cmd, dcmd->buf,
-					     dcmd->len);
+		ret = brcmf_fil_cmd_data_get(netdev_priv(ndev), dcmd->cmd,
+					     dcmd->buf, dcmd->len);
 	if (ret == 0) {
 		reply = cfg80211_testmode_alloc_reply_skb(wiphy, sizeof(*dcmd));
 		nla_put(reply, NL80211_ATTR_TESTDATA, sizeof(*dcmd), dcmd);
@@ -3480,22 +3489,23 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 
 static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	/* set auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, "auth", 0);
+	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
-	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", 0);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", 0);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, "wpa_auth", WPA_AUTH_NONE);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", WPA_AUTH_NONE);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		return err;
@@ -3516,6 +3526,7 @@ static s32
 brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 		     bool is_rsn_ie, s32 bssidx)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	u32 auth = 0; /* d11 open authentication */
 	u16 count;
 	s32 err = 0;
@@ -3656,7 +3667,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 				wme_bss_disable = 0;
 		}
 		/* set wme_bss_disable to sync RSN Capabilities */
-		err = brcmf_fil_bsscfg_int_set(ndev, "wme_bss_disable",
+		err = brcmf_fil_bsscfg_int_set(ifp, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
 			WL_ERR("wme_bss_disable error %d\n", err);
@@ -3667,19 +3678,19 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	wsec = (pval | gval | SES_OW_ENABLED);
 
 	/* set auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, "auth", auth);
+	err = brcmf_fil_bsscfg_int_set(ifp, "auth", auth);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
-	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		goto exit;
 	}
 	/* set upper-layer auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, "wpa_auth", wpa_auth);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_auth);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		goto exit;
@@ -3909,7 +3920,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 		}
 	}
 	if (total_ie_buf_len) {
-		err  = brcmf_fil_bsscfg_data_set(ndev, "vndr_ie",
+		err  = brcmf_fil_bsscfg_data_set(netdev_priv(ndev), "vndr_ie",
 						 iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
@@ -3926,6 +3937,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
 {
 	s32 ie_offset;
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_tlv *ssid_ie;
 	struct brcmf_ssid_le ssid_le;
 	s32 err = -EPERM;
@@ -3966,17 +3978,17 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	brcmf_set_mpc(ndev, 0);
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_DOWN, 1);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 	if (err < 0) {
 		WL_ERR("BRCMF_C_DOWN error %d\n", err);
 		goto exit;
 	}
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_INFRA, 1);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 	if (err < 0) {
 		WL_ERR("SET INFRA error %d\n", err);
 		goto exit;
 	}
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_AP, 1);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 	if (err < 0) {
 		WL_ERR("setting AP mode failed %d\n", err);
 		goto exit;
@@ -4045,7 +4057,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_TRACE("Applied Vndr IEs for Probe Resp\n");
 
 	if (settings->beacon_interval) {
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_BCNPRD,
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 					    settings->beacon_interval);
 		if (err < 0) {
 			WL_ERR("Beacon Interval Set Error, %d\n", err);
@@ -4053,14 +4065,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 	if (settings->dtim_period) {
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_DTIMPRD,
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
 					    settings->dtim_period);
 		if (err < 0) {
 			WL_ERR("DTIM Interval Set Error, %d\n", err);
 			goto exit;
 		}
 	}
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_UP, 1);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 	if (err < 0) {
 		WL_ERR("BRCMF_C_UP error (%d)\n", err);
 		goto exit;
@@ -4070,8 +4082,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	/* join parameters starts with ssid */
 	memcpy(&join_params.ssid_le, &ssid_le, sizeof(ssid_le));
 	/* create softap */
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID, &join_params,
-				     sizeof(join_params));
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
+				     &join_params, sizeof(join_params));
 	if (err < 0) {
 		WL_ERR("SET SSID error (%d)\n", err);
 		goto exit;
@@ -4096,12 +4108,13 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_AP, 0);
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+					    BRCMF_C_SET_AP, 0);
 		if (err < 0) {
 			WL_ERR("setting AP mode failed %d\n", err);
 			goto exit;
 		}
-		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_UP, 0);
+		err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_UP, 0);
 		if (err < 0) {
 			WL_ERR("BRCMF_C_UP error %d\n", err);
 			goto exit;
@@ -4131,7 +4144,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	memcpy(&scbval.ea, mac, ETH_ALEN);
 	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
-	err = brcmf_fil_cmd_data_set(ndev,
+	err = brcmf_fil_cmd_data_set(netdev_priv(ndev),
 				     BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
@@ -4335,7 +4348,7 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_info *cfg)
 
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 {
-	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	u32 req_len;
@@ -4344,8 +4357,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 
 	brcmf_clear_assoc_ies(cfg);
 
-	err = brcmf_fil_iovar_data_get(ndev, "assoc_info", cfg->extra_buf,
-				       WL_ASSOC_INFO_MAX);
+	err = brcmf_fil_iovar_data_get(ifp, "assoc_info",
+				       cfg->extra_buf, WL_ASSOC_INFO_MAX);
 	if (err) {
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
@@ -4355,7 +4368,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 	req_len = le32_to_cpu(assoc_info->req_len);
 	resp_len = le32_to_cpu(assoc_info->resp_len);
 	if (req_len) {
-		err = brcmf_fil_iovar_data_get(ndev, "assoc_req_ies",
+		err = brcmf_fil_iovar_data_get(ifp, "assoc_req_ies",
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
@@ -4371,7 +4384,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 		conn_info->req_ie = NULL;
 	}
 	if (resp_len) {
-		err = brcmf_fil_iovar_data_get(ndev, "assoc_resp_ies",
+		err = brcmf_fil_iovar_data_get(ifp, "assoc_resp_ies",
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
@@ -4422,8 +4435,8 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 
 	/* data sent to dongle has to be little endian */
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
-	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_BSS_INFO, buf,
-				     WL_BSS_INFO_MAX);
+	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
+				     buf, WL_BSS_INFO_MAX);
 
 	if (err)
 		goto done;
@@ -4637,7 +4650,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 		goto scan_done_out;
 	}
 
-	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_CHANNEL,
+	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_CHANNEL,
 				     &channel_inform_le,
 				     sizeof(channel_inform_le));
 	if (err) {
@@ -4653,7 +4666,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 
 	memset(cfg->scan_results, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_SCAN_RESULTS,
+	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_SCAN_RESULTS,
 				     cfg->scan_results, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
@@ -5004,8 +5017,8 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	WL_TRACE("Enter\n");
 
 	/* Setup event_msgs */
-	err = brcmf_fil_iovar_data_get(ndev, "event_msgs", eventmask,
-				       BRCMF_EVENTING_MASK_LEN);
+	err = brcmf_fil_iovar_data_get(netdev_priv(ndev), "event_msgs",
+				       eventmask, BRCMF_EVENTING_MASK_LEN);
 	if (err) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -5033,8 +5046,8 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
 	setbit(eventmask, BRCMF_E_PFN_NET_FOUND);
 
-	err = brcmf_fil_iovar_data_set(ndev, "event_msgs", eventmask,
-				       BRCMF_EVENTING_MASK_LEN);
+	err = brcmf_fil_iovar_data_set(netdev_priv(ndev), "event_msgs",
+				       eventmask, BRCMF_EVENTING_MASK_LEN);
 	if (err) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -5048,6 +5061,7 @@ dongle_eventmsg_out:
 static s32
 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 	__le32 roamtrigger[2];
 	__le32 roam_delta[2];
@@ -5057,7 +5071,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * off to report link down
 	 */
 	if (roamvar) {
-		err = brcmf_fil_iovar_int_set(ndev, "bcn_timeout", bcn_timeout);
+		err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 		if (err) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
@@ -5069,7 +5083,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * to take care of roaming
 	 */
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
-	err = brcmf_fil_iovar_int_set(ndev, "roam_off", roamvar);
+	err = brcmf_fil_iovar_int_set(ifp, "roam_off", roamvar);
 	if (err) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -5077,7 +5091,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roamtrigger[0] = cpu_to_le32(WL_ROAM_TRIGGER_LEVEL);
 	roamtrigger[1] = cpu_to_le32(BRCM_BAND_ALL);
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_ROAM_TRIGGER,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
@@ -5086,7 +5100,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roam_delta[0] = cpu_to_le32(WL_ROAM_DELTA);
 	roam_delta[1] = cpu_to_le32(BRCM_BAND_ALL);
-	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_ROAM_DELTA,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
@@ -5101,9 +5115,10 @@ static s32
 brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		      s32 scan_unassoc_time, s32 scan_passive_time)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    scan_assoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -5112,7 +5127,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			WL_ERR("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    scan_unassoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -5122,7 +5137,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 				    scan_passive_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -5138,12 +5153,13 @@ dongle_scantime_out:
 
 static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct wiphy *wiphy;
 	s32 phy_list;
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_fil_cmd_data_get(cfg_to_ndev(cfg), BRCM_GET_PHYLIST,
+	err = brcmf_fil_cmd_data_get(ifp, BRCM_GET_PHYLIST,
 				     &phy_list, sizeof(phy_list));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -5186,7 +5202,8 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 		goto default_conf_out;
 
 	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
-	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PM, power_mode);
+	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PM,
+				    power_mode);
 	if (err)
 		goto default_conf_out;
 	WL_INFO("power save set to %s\n",
-- 
1.7.6


