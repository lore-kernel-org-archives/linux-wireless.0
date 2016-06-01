Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35452 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbcFAOi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 10:38:58 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RFC] brcmfmac: support deleting MBSS AP interfaces
Date: Wed,  1 Jun 2016 16:36:56 +0200
Message-Id: <1464791845-23944-1-git-send-email-zajec5@gmail.com> (sfid-20160601_163925_929020_D5E0E867)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already support adding extra (AP) interfaces so it also makes an
obvious sense to allow deleting them.

Adding a new interface is implemented by sending request to firmware for
creating a new BSS and waiting for a proper event. Ideally deleting
interface should be handled in a similar way. There should be a request
to firmware for deleting BSS and firmware should respond with an event.

Unfortunately it doesn't seem to work with recent firmwares. They never
seem to delete BSS and never send BRCMF_E_IF_DEL. As a workaround this
patch deletes Linux interface while keeping a track of BSSes present in
a firmware. If there is request for adding a new interface this code is
capable of reusing existing BSS-es.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 84 +++++++++++++++-------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  4 +-
 4 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d23b95e..ce35ada 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -35,6 +35,7 @@
 #include "cfg80211.h"
 #include "feature.h"
 #include "fwil.h"
+#include "fwsignal.h"
 #include "proto.h"
 #include "vendor.h"
 #include "bus.h"
@@ -556,10 +557,10 @@ static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
 	return -ENOMEM;
 }
 
-static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
+static int brcmf_cfg80211_request_ap_if(struct brcmf_cfg80211_info *cfg, int bsscfgidx)
 {
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_mbss_ssid_le mbss_ssid_le;
-	int bsscfgidx;
 	int err;
 
 	memset(&mbss_ssid_le, 0, sizeof(mbss_ssid_le));
@@ -594,6 +595,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_cfg80211_vif *vif;
+	int bsscfgidx;
 	int err;
 
 	if (brcmf_cfg80211_vif_event_armed(cfg))
@@ -605,30 +607,49 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	if (IS_ERR(vif))
 		return (struct wireless_dev *)vif;
 
-	brcmf_cfg80211_arm_vif_event(cfg, vif);
+	bsscfgidx = brcmf_get_first_free_bsscfgidx(cfg->pub);
+	brcmf_err("bsscfgidx:%d cfg->pub->bss2if[bsscfgidx]:%d\n", bsscfgidx, cfg->pub->bss2if[bsscfgidx]);
+	if (cfg->pub->bss2if[bsscfgidx] != BRCMF_IDX_INVALID) {
+		ifp = brcmf_add_if(cfg->pub, bsscfgidx, cfg->pub->bss2if[bsscfgidx], false, "wlan%d", params->macaddr);
+		if (IS_ERR(ifp)) {
+			err = PTR_ERR(ifp);
+			goto fail;
+		}
+		brcmf_fws_add_interface(ifp);
 
-	err = brcmf_cfg80211_request_ap_if(ifp);
-	if (err) {
-		brcmf_cfg80211_arm_vif_event(cfg, NULL);
-		goto fail;
-	}
+		ifp->vif = vif;
+		vif->ifp = ifp;
+		if (ifp->ndev) {
+			vif->wdev.netdev = ifp->ndev;
+			ifp->ndev->ieee80211_ptr = &vif->wdev;
+			SET_NETDEV_DEV(ifp->ndev, wiphy_dev(cfg->wiphy));
+		}
+	} else {
+		brcmf_cfg80211_arm_vif_event(cfg, vif);
 
-	/* wait for firmware event */
-	err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_ADD,
-					    BRCMF_VIF_EVENT_TIMEOUT);
-	brcmf_cfg80211_arm_vif_event(cfg, NULL);
-	if (!err) {
-		brcmf_err("timeout occurred\n");
-		err = -EIO;
-		goto fail;
-	}
+		err = brcmf_cfg80211_request_ap_if(cfg, bsscfgidx);
+		if (err) {
+			brcmf_cfg80211_arm_vif_event(cfg, NULL);
+			goto fail;
+		}
 
-	/* interface created in firmware */
-	ifp = vif->ifp;
-	if (!ifp) {
-		brcmf_err("no if pointer provided\n");
-		err = -ENOENT;
-		goto fail;
+		/* wait for firmware event */
+		err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_ADD,
+						BRCMF_VIF_EVENT_TIMEOUT);
+		brcmf_cfg80211_arm_vif_event(cfg, NULL);
+		if (!err) {
+			brcmf_err("timeout occurred\n");
+			err = -EIO;
+			goto fail;
+		}
+
+		/* interface created in firmware */
+		ifp = vif->ifp;
+		if (!ifp) {
+			brcmf_err("no if pointer provided\n");
+			err = -ENOENT;
+			goto fail;
+		}
 	}
 
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
@@ -781,12 +802,26 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	return err;
 }
 
+static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
+				       struct wireless_dev *wdev)
+{
+	struct net_device *ndev = wdev->netdev;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
+	brcmf_remove_interface(ifp);
+
+	return 0;
+}
+
 static
 int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct net_device *ndev = wdev->netdev;
 
+	if (ndev == cfg_to_ndev(cfg))
+		return -ENOTSUPP;
+
 	/* vif event pending in firmware */
 	if (brcmf_cfg80211_vif_event_armed(cfg))
 		return -EBUSY;
@@ -803,12 +838,13 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 		return -EOPNOTSUPP;
+	case NL80211_IFTYPE_AP:
+		return brcmf_cfg80211_del_ap_iface(wiphy, wdev);
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 6a76480..1208c21 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -634,7 +634,7 @@ fail:
 }
 
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
-			      bool is_p2pdev, char *name, u8 *mac_addr)
+			      bool is_p2pdev, const char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
@@ -680,6 +680,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 		/* store mapping ifidx to bsscfgidx */
 		if (drvr->if2bss[ifidx] == BRCMF_BSSIDX_INVALID)
 			drvr->if2bss[ifidx] = bsscfgidx;
+		if (drvr->bss2if[bsscfgidx] == BRCMF_IDX_INVALID)
+			drvr->bss2if[bsscfgidx] = ifidx;
 	}
 
 	ifp->drvr = drvr;
@@ -910,6 +912,8 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 
 	for (i = 0; i < ARRAY_SIZE(drvr->if2bss); i++)
 		drvr->if2bss[i] = BRCMF_BSSIDX_INVALID;
+	for (i = 0; i < ARRAY_SIZE(drvr->bss2if); i++)
+		drvr->bss2if[i] = BRCMF_IDX_INVALID;
 
 	mutex_init(&drvr->proto_block);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 2a075c5..edd322a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -29,6 +29,7 @@
 
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
+#define BRCMF_IDX_INVALID	-1
 
 /* Small, medium and maximum buffer size for dcmd
  */
@@ -125,6 +126,7 @@ struct brcmf_pub {
 
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 	s32 if2bss[BRCMF_MAX_IFS];
+	s32 bss2if[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
@@ -215,7 +217,7 @@ char *brcmf_ifname(struct brcmf_if *ifp);
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
-			      bool is_p2pdev, char *name, u8 *mac_addr);
+			      bool is_p2pdev, const char *name, u8 *mac_addr);
 void brcmf_remove_interface(struct brcmf_if *ifp);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index b390561..5bde857 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -182,8 +182,10 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
 		brcmf_remove_interface(ifp);
+		drvr->bss2if[ifp->bsscfgidx] = BRCMF_IDX_INVALID;
+	}
 }
 
 /**
-- 
1.8.4.5

