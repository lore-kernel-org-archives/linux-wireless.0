Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3441 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/9] brcm80211: fmac: remove primary mac address
 handling from brcmf_net_attach
Date: Wed, 11 Apr 2012 11:52:44 +0200
Message-ID: <1334137971-3972-3-git-send-email-arend@broadcom.com> (sfid-20120411_115337_372395_D31FF52B)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac address for the primary interface was handled different from
the other interfaces. The code has been restructured such that the
brcmf_net_attach function treats the interfaces equal.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   25 +++++++++----------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 153d369..07836a8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -843,27 +843,26 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
-static int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
+static int brcmf_net_attach(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
-	u8 temp_addr[ETH_ALEN] = {
-		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
+	u8 temp_addr[ETH_ALEN];
 
-	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
+	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
-	ndev = drvr->iflist[ifidx]->ndev;
+	ndev = drvr->iflist[ifp->idx]->ndev;
 	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
 	/*
-	 * We have to use the primary MAC for virtual interfaces
+	 * determine mac address to use
 	 */
-	if (ifidx != 0) {
-		/* for virtual interfaces use the primary MAC  */
+	if (is_valid_ether_addr(ifp->mac_addr))
+		memcpy(temp_addr, ifp->mac_addr, ETH_ALEN);
+	else
 		memcpy(temp_addr, drvr->mac, ETH_ALEN);
 
-	}
-
-	if (ifidx == 1) {
+	if (ifp->idx == 1) {
 		brcmf_dbg(TRACE, "ACCESS POINT MAC:\n");
 		/*  ACCESSPOINT INTERFACE CASE */
 		temp_addr[0] |= 0X02;	/* set bit 2 ,
@@ -879,7 +878,7 @@ static int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
 
 	/* attach to cfg80211 for primary interface */
-	if (!ifidx) {
+	if (!ifp->idx) {
 		drvr->config = brcmf_cfg80211_attach(ndev, drvr->dev, drvr);
 		if (drvr->config == NULL) {
 			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
@@ -940,7 +939,7 @@ brcmf_add_if(struct device *dev, int ifidx, char *name, u8 *mac_addr)
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	if (brcmf_net_attach(drvr, ifp->idx)) {
+	if (brcmf_net_attach(ifp)) {
 		brcmf_dbg(ERROR, "brcmf_net_attach failed");
 		free_netdev(ifp->ndev);
 		drvr->iflist[ifidx] = NULL;
-- 
1.7.5.4


