Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3759 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760218Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 24/27] brcmfmac: Fix rtnl_lock lockup when registering
 netdev.
Date: Fri, 8 Feb 2013 15:53:59 +0100
Message-ID: <1360335242-12608-25-git-send-email-arend@broadcom.com> (sfid-20130208_163816_894914_59AA4AB6)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When adding a virtual interface cfg80211 already has taken the
rtnl_lock. So when the netdevice is being registered the
register_netdevice should be used instead of register_netdev.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h         |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c   |   11 ++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c        |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index c4a6083..ef6f23b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -585,7 +585,7 @@ extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 extern int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 			       struct sk_buff *rxp);
 
-extern int brcmf_net_attach(struct brcmf_if *ifp);
+extern int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx,
 				     s32 ifidx, char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e61be4d..6e3846c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -599,10 +599,11 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
-int brcmf_net_attach(struct brcmf_if *ifp)
+int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
+	s32 err;
 
 	brcmf_dbg(TRACE, "Enter, idx=%d mac=%pM\n", ifp->bssidx,
 		  ifp->mac_addr);
@@ -623,7 +624,11 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 
-	if (register_netdev(ndev) != 0) {
+	if (rtnl_locked)
+		err = register_netdevice(ndev);
+	else
+		err = register_netdev(ndev);
+	if (err != 0) {
 		brcmf_err("couldn't register the net device\n");
 		goto fail;
 	}
@@ -876,7 +881,7 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
-	ret = brcmf_net_attach(ifp);
+	ret = brcmf_net_attach(ifp, false);
 fail:
 	if (ret < 0) {
 		brcmf_err("failed: %d\n", ret);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 1fd29b0..e9d6f91 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -200,7 +200,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 			return;
 
 		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
-			err = brcmf_net_attach(ifp);
+			err = brcmf_net_attach(ifp, false);
 	}
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f283a7e..6cdb578 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4668,7 +4668,7 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 
 		/* waiting process need to set the netdev name */
 		wait_for_completion(&event->vif_complete);
-		return brcmf_net_attach(ifp);
+		return brcmf_net_attach(ifp, true);
 
 	case BRCMF_E_IF_DEL:
 		ifp->vif = NULL;
-- 
1.7.10.4


