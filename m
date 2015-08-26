Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:11233 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbHZUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:13 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/12] brcmfmac: change parameters for brcmf_remove_interface()
Date: Wed, 26 Aug 2015 22:14:55 +0200
Message-ID: <1440620104-2715-4-git-send-email-arend@broadcom.com> (sfid-20150826_223108_640253_6D0DC078)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just pass the interface to be removed, ie. the struct brcmf_if instance.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 13 +++++++------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index a293275..0c29bf6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4983,7 +4983,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 		brcmf_dbg(CONN, "AP mode link down\n");
 		complete(&cfg->vif_disabled);
 		if (ifp->vif->mbss)
-			brcmf_remove_interface(ifp->drvr, ifp->bssidx);
+			brcmf_remove_interface(ifp);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 1f65ce8..157f0d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -887,12 +887,13 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	}
 }
 
-void brcmf_remove_interface(struct brcmf_pub *drvr, u32 bssidx)
+void brcmf_remove_interface(struct brcmf_if *ifp)
 {
-	if (drvr->iflist[bssidx]) {
-		brcmf_fws_del_interface(drvr->iflist[bssidx]);
-		brcmf_del_if(drvr, bssidx);
-	}
+	if (!ifp || WARN_ON(ifp->drvr->iflist[ifp->bssidx] != ifp))
+		return;
+
+	brcmf_fws_del_interface(ifp);
+	brcmf_del_if(ifp->drvr, ifp->bssidx);
 }
 
 int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr)
@@ -1122,7 +1123,7 @@ void brcmf_detach(struct device *dev)
 
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-		brcmf_remove_interface(drvr, i);
+		brcmf_remove_interface(drvr->iflist[i]);
 
 	brcmf_cfg80211_detach(drvr->config);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 1dc5b96..eb0c177 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -206,7 +206,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			      char *name, u8 *mac_addr);
-void brcmf_remove_interface(struct brcmf_pub *drvr, u32 bssidx);
+void brcmf_remove_interface(struct brcmf_if *ifp);
 int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index ec62492..4d4cc2c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -222,7 +222,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
 	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
-		brcmf_remove_interface(drvr, ifevent->bssidx);
+		brcmf_remove_interface(ifp);
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index a9ba775..6a70c06 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2140,7 +2140,7 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
 {
 	cfg80211_unregister_wdev(&vif->wdev);
 	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	brcmf_remove_interface(vif->ifp->drvr, vif->ifp->bssidx);
+	brcmf_remove_interface(vif->ifp);
 	brcmf_free_vif(vif);
 }
 
-- 
1.9.1

