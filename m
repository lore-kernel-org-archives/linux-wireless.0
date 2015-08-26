Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56115 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbbHZUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:13 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: correct detection of p2pdev interface event
Date: Wed, 26 Aug 2015 22:14:57 +0200
Message-ID: <1440620104-2715-6-git-send-email-arend@broadcom.com> (sfid-20150826_221538_949265_2DD33F1A)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The p2pdev interface is setup in firmware resulting in a interface
event. This event has role and no-if flag. When role is p2p client
and no-if flag is set it indicates that this is the p2pdev interface.
This info is used in handling the event and adding interface in the
driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c |  8 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/core.h |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 15 +++++++--------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 126081a..b9ed0ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -795,7 +795,7 @@ fail:
 }
 
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
-			      char *name, u8 *mac_addr)
+			      bool is_p2pdev, char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
@@ -821,7 +821,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		}
 	}
 
-	if (!brcmf_p2p_enable && bssidx == 1) {
+	if (!brcmf_p2p_enable && is_p2pdev) {
 		/* this is P2P_DEVICE interface */
 		brcmf_dbg(INFO, "allocate non-netdev interface\n");
 		ifp = kzalloc(sizeof(*ifp), GFP_KERNEL);
@@ -999,12 +999,12 @@ int brcmf_bus_start(struct device *dev)
 	brcmf_dbg(TRACE, "\n");
 
 	/* add primary networking interface */
-	ifp = brcmf_add_if(drvr, 0, 0, "wlan%d", NULL);
+	ifp = brcmf_add_if(drvr, 0, 0, false, "wlan%d", NULL);
 	if (IS_ERR(ifp))
 		return PTR_ERR(ifp);
 
 	if (brcmf_p2p_enable)
-		p2p_ifp = brcmf_add_if(drvr, 1, 0, "p2p%d", NULL);
+		p2p_ifp = brcmf_add_if(drvr, 1, 0, false, "p2p%d", NULL);
 	else
 		p2p_ifp = NULL;
 	if (IS_ERR(p2p_ifp))
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index eb0c177..5fb9f4be 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -205,7 +205,7 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
-			      char *name, u8 *mac_addr);
+			      bool is_p2pdev, char *name, u8 *mac_addr);
 void brcmf_remove_interface(struct brcmf_if *ifp);
 int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 4d4cc2c..1afaf97 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -179,6 +179,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 {
 	struct brcmf_if_event *ifevent = data;
 	struct brcmf_if *ifp;
+	bool is_p2pdev;
 	int err = 0;
 
 	brcmf_dbg(EVENT, "action: %u idx: %u bsscfg: %u flags: %u role: %u\n",
@@ -186,18 +187,16 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		  ifevent->flags, ifevent->role);
 
 	/* The P2P Device interface event must not be ignored
-	 * contrary to what firmware tells us. The only way to
-	 * distinguish the P2P Device is by looking at the ifidx
-	 * and bssidx received.
+	 * contrary to what firmware tells us.
 	 */
-	if (!(ifevent->ifidx == 0 && ifevent->bssidx == 1) &&
-	    (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
+	is_p2pdev = (ifevent->flags & BRCMF_E_IF_FLAG_NOIF) &&
+		    ifevent->role == BRCMF_E_IF_ROLE_P2P_CLIENT;
+	if (!is_p2pdev && (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
 		brcmf_dbg(EVENT, "event can be ignored\n");
 		return;
 	}
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("invalid interface index: %u\n",
-			  ifevent->ifidx);
+		brcmf_err("invalid interface index: %u\n", ifevent->ifidx);
 		return;
 	}
 
@@ -207,7 +206,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
 			  emsg->addr);
 		ifp = brcmf_add_if(drvr, ifevent->bssidx, ifevent->ifidx,
-				   emsg->ifname, emsg->addr);
+				   is_p2pdev, emsg->ifname, emsg->addr);
 		if (IS_ERR(ifp))
 			return;
 		brcmf_fws_add_interface(ifp);
-- 
1.9.1

