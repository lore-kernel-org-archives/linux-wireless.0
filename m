Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35442 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbcFQK3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 06:29:51 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH REBASED] brcmfmac: fix lockup when removing P2P interface after event timeout
Date: Fri, 17 Jun 2016 12:29:21 +0200
Message-Id: <1466159371-19968-1-git-send-email-zajec5@gmail.com> (sfid-20160617_123014_475548_4F3FCC50)
In-Reply-To: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing P2P interface is handled by sending a proper request to the
firmware. On success firmware triggers an event and driver's handler
removes a matching interface.

However on event timeout we remove interface directly from the cfg80211
callback. Current code doesn't handle this case correctly as it always
assumes rtnl to be unlocked.

Fix it by adding an extra rtnl_locked parameter to functions and calling
unregister_netdevice when needed.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
REBASED on top of wireless-drivers-next. This bug isn't very common and
changes may conflict with other patches, so it makes more sense to pick
it for -next.
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 29 +++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  4 +--
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index faf4e46..7b38c2b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -548,12 +548,16 @@ fail:
 	return -EBADE;
 }
 
-static void brcmf_net_detach(struct net_device *ndev)
+static void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked)
 {
-	if (ndev->reg_state == NETREG_REGISTERED)
-		unregister_netdev(ndev);
-	else
+	if (ndev->reg_state == NETREG_REGISTERED) {
+		if (rtnl_locked)
+			unregister_netdevice(ndev);
+		else
+			unregister_netdev(ndev);
+	} else {
 		brcmf_cfg80211_free_netdev(ndev);
+	}
 }
 
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on)
@@ -651,7 +655,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 			brcmf_err("ERROR: netdev:%s already exists\n",
 				  ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
-			brcmf_net_detach(ifp->ndev);
+			brcmf_net_detach(ifp->ndev, false);
 			drvr->iflist[bsscfgidx] = NULL;
 		} else {
 			brcmf_dbg(INFO, "netdev:%s ignore IF event\n",
@@ -699,7 +703,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 	return ifp;
 }
 
-static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx)
+static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
+			 bool rtnl_locked)
 {
 	struct brcmf_if *ifp;
 
@@ -729,7 +734,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx)
 			cancel_work_sync(&ifp->multicast_work);
 			cancel_work_sync(&ifp->ndoffload_work);
 		}
-		brcmf_net_detach(ifp->ndev);
+		brcmf_net_detach(ifp->ndev, rtnl_locked);
 	} else {
 		/* Only p2p device interfaces which get dynamically created
 		 * end up here. In this case the p2p module should be informed
@@ -743,14 +748,14 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx)
 	}
 }
 
-void brcmf_remove_interface(struct brcmf_if *ifp)
+void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked)
 {
 	if (!ifp || WARN_ON(ifp->drvr->iflist[ifp->bsscfgidx] != ifp))
 		return;
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", ifp->bsscfgidx,
 		  ifp->ifidx);
 	brcmf_fws_del_interface(ifp);
-	brcmf_del_if(ifp->drvr, ifp->bsscfgidx);
+	brcmf_del_if(ifp->drvr, ifp->bsscfgidx, rtnl_locked);
 }
 
 #ifdef CONFIG_INET
@@ -1057,9 +1062,9 @@ fail:
 		brcmf_fws_deinit(drvr);
 	}
 	if (ifp)
-		brcmf_net_detach(ifp->ndev);
+		brcmf_net_detach(ifp->ndev, false);
 	if (p2p_ifp)
-		brcmf_net_detach(p2p_ifp->ndev);
+		brcmf_net_detach(p2p_ifp->ndev, false);
 	drvr->iflist[0] = NULL;
 	drvr->iflist[1] = NULL;
 	if (drvr->settings->ignore_probe_fail)
@@ -1128,7 +1133,7 @@ void brcmf_detach(struct device *dev)
 
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-		brcmf_remove_interface(drvr->iflist[i]);
+		brcmf_remove_interface(drvr->iflist[i], false);
 
 	brcmf_cfg80211_detach(drvr->config);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 2a075c5..a0a6f7f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -216,7 +216,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 			      bool is_p2pdev, char *name, u8 *mac_addr);
-void brcmf_remove_interface(struct brcmf_if *ifp);
+void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index b390561..9da7a4c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -183,7 +183,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
 	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
-		brcmf_remove_interface(ifp);
+		brcmf_remove_interface(ifp, false);
 }
 
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index f38a821..426ff05 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2287,7 +2287,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 			err = 0;
 	}
 	if (err)
-		brcmf_remove_interface(vif->ifp);
+		brcmf_remove_interface(vif->ifp, true);
 
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE)
@@ -2393,7 +2393,7 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 	if (vif != NULL) {
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
-		brcmf_remove_interface(vif->ifp);
+		brcmf_remove_interface(vif->ifp, false);
 	}
 	/* just set it all to zero */
 	memset(p2p, 0, sizeof(*p2p));
-- 
1.8.4.5

