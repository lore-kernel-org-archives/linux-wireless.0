Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9116 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbbHZUPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:18 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/12] brcmfmac: add mapping for interface index to bsscfg index
Date: Wed, 26 Aug 2015 22:15:00 +0200
Message-ID: <1440620104-2715-9-git-send-email-arend@broadcom.com> (sfid-20150826_221524_352658_B4069342)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the P2P Device interface in firmware uses the same interface
index as the primary interface we use the bsscfg index as index in the
struct brcmf_pub::iflist. However, in the data path we get the interface
index and not the bsscfg index. So we need a mapping of interface index
to bsscfg index, which can be determined upon handle adding the interface.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 22 +++++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/core.h |  1 +
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index cd0bffe..5d81b74 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -85,21 +85,20 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 {
+	struct brcmf_if *ifp;
+	s32 bssidx;
+
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
 		brcmf_err("ifidx %d out of range\n", ifidx);
 		return NULL;
 	}
 
-	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
-	 * events this is easy because it contains the bssidx which maps
-	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
-	 * bssidx 1 is used for p2p0 and no data can be received or
-	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
-	 */
-	if (ifidx)
-		ifidx++;
+	ifp = NULL;
+	bssidx = drvr->if2bss[ifidx];
+	if (bssidx >= 0)
+		ifp = drvr->iflist[bssidx];
 
-	return drvr->iflist[ifidx];
+	return ifp;
 }
 
 static void _brcmf_set_multicast_list(struct work_struct *work)
@@ -831,6 +830,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 
 		ifp = netdev_priv(ndev);
 		ifp->ndev = ndev;
+		/* store mapping ifidx to bssidx */
+		drvr->if2bss[ifidx] = bssidx;
 	}
 
 	ifp->drvr = drvr;
@@ -855,6 +856,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	struct brcmf_if *ifp;
 
 	ifp = drvr->iflist[bssidx];
+	drvr->if2bss[ifp->ifidx] = -1;
 	drvr->iflist[bssidx] = NULL;
 	if (!ifp) {
 		brcmf_err("Null interface, idx=%d\n", bssidx);
@@ -862,6 +864,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	}
 	brcmf_dbg(TRACE, "Enter, idx=%d, ifidx=%d\n", bssidx, ifp->ifidx);
 	if (ifp->ndev) {
+		drvr->if2bss[ifp->ifidx] = -1;
 		if (bssidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
 				rtnl_lock();
@@ -926,6 +929,7 @@ int brcmf_attach(struct device *dev)
 	if (!drvr)
 		return -ENOMEM;
 
+	memset(drvr->if2bss, 0xFF, sizeof(drvr->if2bss));
 	mutex_init(&drvr->proto_block);
 
 	/* Link to bus module */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 576e7ac..d81ff95 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -122,6 +122,7 @@ struct brcmf_pub {
 	struct mac_address addresses[BRCMF_MAX_IFS];
 
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
+	s32 if2bss[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
-- 
1.9.1

