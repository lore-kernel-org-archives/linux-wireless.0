Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1618 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760201Ab3BHO4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 26/27] brcmfmac: Create netdev before returning from
 add_virtual_intf.
Date: Fri, 8 Feb 2013 15:54:01 +0100
Message-ID: <1360335242-12608-27-git-send-email-arend@broadcom.com> (sfid-20130208_163814_197843_8B82110A)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently netdev gets created possibly after returning from
add_virtual_intf. This is because add_if is handled asynch. This
is wrong and netdev should be up before returning.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c         |    6 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   10 +---------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h |    2 --
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fd09074..84d6acd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1591,7 +1591,11 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	}
 
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
-	brcmf_cfg80211_vif_complete(cfg);
+	err = brcmf_net_attach(ifp, true);
+	if (err) {
+		brcmf_err("Registering netdevice failed\n");
+		goto fail;
+	}
 	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = vif;
 	/* Disable firmware roaming for P2P interface  */
 	brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6cdb578..b5cc154 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4665,10 +4665,7 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 		SET_NETDEV_DEV(ifp->ndev, wiphy_dev(cfg->wiphy));
 		mutex_unlock(&event->vif_event_lock);
 		wake_up(&event->vif_wq);
-
-		/* waiting process need to set the netdev name */
-		wait_for_completion(&event->vif_complete);
-		return brcmf_net_attach(ifp, true);
+		return 0;
 
 	case BRCMF_E_IF_DEL:
 		ifp->vif = NULL;
@@ -4800,7 +4797,6 @@ static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 {
 	init_waitqueue_head(&event->vif_wq);
-	init_completion(&event->vif_complete);
 	mutex_init(&event->vif_event_lock);
 }
 
@@ -5154,7 +5150,3 @@ int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 				  vif_event_equals(event, action), timeout);
 }
 
-void brcmf_cfg80211_vif_complete(struct brcmf_cfg80211_info *cfg)
-{
-	complete(&cfg->vif_event.vif_complete);
-}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index b886f22..8b5d498 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -337,7 +337,6 @@ struct brcmf_pno_scanresults_le {
 struct brcmf_cfg80211_vif_event {
 	wait_queue_head_t vif_wq;
 	struct mutex vif_event_lock;
-	struct completion vif_complete;
 	u8 action;
 	struct brcmf_cfg80211_vif *vif;
 };
@@ -493,7 +492,6 @@ void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
 bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
 int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 					  u8 action, ulong timeout);
-void brcmf_cfg80211_vif_complete(struct brcmf_cfg80211_info *info);
 s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct net_device *ndev,
 				bool aborted, bool fw_abort);
-- 
1.7.10.4


