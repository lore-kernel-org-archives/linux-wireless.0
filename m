Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1350 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab3BFRmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:36 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/12] brcmfmac: Update tracelogging for multiple
 netdevs.
Date: Wed, 6 Feb 2013 18:40:42 +0100
Message-ID: <1360172447-2424-8-git-send-email-arend@broadcom.com> (sfid-20130206_184244_711022_44C2276F)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When supporting multiple netdevs it is usefull to log idx in netdev
related functions. This will be used for features like P2P.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   34 +++++++++++---------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 05cae37..a09c077 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -70,9 +70,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	u32 buflen;
 	s32 err;
 
-	brcmf_dbg(TRACE, "enter\n");
-
 	ifp = container_of(work, struct brcmf_if, multicast_work);
+
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+
 	ndev = ifp->ndev;
 
 	/* Determine initial value of allmulti flag */
@@ -129,9 +130,10 @@ _brcmf_set_mac_address(struct work_struct *work)
 	struct brcmf_if *ifp;
 	s32 err;
 
-	brcmf_dbg(TRACE, "enter\n");
-
 	ifp = container_of(work, struct brcmf_if, setmacaddr_work);
+
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+
 	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ifp->mac_addr,
 				       ETH_ALEN);
 	if (err < 0) {
@@ -168,7 +170,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
@@ -370,7 +372,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
 
 	return &ifp->stats;
 }
@@ -422,7 +424,7 @@ static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 	u32 toe_cmpnt, csum_dir;
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
 
 	/* all ethtool calls start with a cmd word */
 	if (copy_from_user(&cmd, uaddr, sizeof(u32)))
@@ -519,7 +521,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 
-	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifp->idx, cmd);
+	brcmf_dbg(TRACE, "Enter, bssidx=%d, cmd=0x%04x\n", ifp->idx, cmd);
 
 	if (!drvr->iflist[ifp->idx])
 		return -1;
@@ -532,7 +534,9 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
 
 	brcmf_cfg80211_down(ndev);
 
@@ -550,7 +554,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	u32 toe_ol;
 	s32 ret = 0;
 
-	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_DATA) {
@@ -602,7 +606,8 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
 
-	brcmf_dbg(TRACE, "ifidx %d mac %pM\n", ifp->idx, ifp->mac_addr);
+	brcmf_dbg(TRACE, "Enter, idx=%d mac=%pM\n", ifp->idx,
+		  ifp->mac_addr);
 	ndev = ifp->ndev;
 
 	/* set appropriate operations */
@@ -641,7 +646,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	struct net_device *ndev;
 	int i;
 
-	brcmf_dbg(TRACE, "idx %d\n", ifidx);
+	brcmf_dbg(TRACE, "Enter, bssidx=%d, ifidx=%d\n", bssidx, ifidx);
 
 	ifp = drvr->iflist[ifidx];
 	/*
@@ -695,13 +700,12 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_if *ifp;
 
-	brcmf_dbg(TRACE, "idx %d\n", ifidx);
-
 	ifp = drvr->iflist[ifidx];
 	if (!ifp) {
-		brcmf_err("Null interface\n");
+		brcmf_err("Null interface, idx=%d\n", ifidx);
 		return;
 	}
+	brcmf_dbg(TRACE, "Enter, idx=%d, bssidx=%d\n", ifidx, ifp->bssidx);
 	if (ifp->ndev) {
 		if (ifidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
-- 
1.7.10.4


