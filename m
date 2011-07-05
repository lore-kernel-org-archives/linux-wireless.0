Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1424 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/31] staging: brcm80211: removed asserts from
 dhd_linux.c
Date: Wed, 6 Jul 2011 00:02:35 +0200
Message-ID: <1309903378-29021-9-git-send-email-arend@broadcom.com> (sfid-20110706_000413_660331_38238AEF)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   33 +-----------------------
 1 files changed, 1 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index afb1e32..0ea8084 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -235,7 +235,6 @@ static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
 {
 	int i = 0;
 
-	ASSERT(drvr_priv);
 	while (i < BRCMF_MAX_IFS) {
 		if (drvr_priv->iflist[i] && (drvr_priv->iflist[i]->net == net))
 			return i;
@@ -249,8 +248,6 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 {
 	int i = BRCMF_MAX_IFS;
 
-	ASSERT(drvr_priv);
-
 	if (name == NULL || *name == '\0')
 		return 0;
 
@@ -268,8 +265,6 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
-	ASSERT(drvr_priv);
-
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
 		BRCMF_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
 		return "<if_bad>";
@@ -297,7 +292,6 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	uint buflen;
 	int ret;
 
-	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
 	dev = drvr_priv->iflist[ifidx]->net;
 	cnt = netdev_mc_count(dev);
 
@@ -437,13 +431,12 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 extern struct net_device *ap_net_dev;
 #endif
 
+/* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
 static void brcmf_op_if(struct brcmf_if *ifp)
 {
 	struct brcmf_info *drvr_priv;
 	int ret = 0, err = 0;
 
-	ASSERT(ifp && ifp->info && ifp->idx);	/* Virtual interfaces only */
-
 	drvr_priv = ifp->info;
 
 	BRCMF_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
@@ -509,7 +502,6 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		break;
 	default:
 		BRCMF_ERROR(("%s: bad op %d\n", __func__, ifp->state));
-		ASSERT(!ifp->state);
 		break;
 	}
 
@@ -601,7 +593,6 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 	if (ifidx == BRCMF_BAD_IF)
 		return -1;
 
-	ASSERT(drvr_priv->sysioc_tsk);
 	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
 	drvr_priv->set_macaddress = true;
 	up(&drvr_priv->sysioc_sem);
@@ -618,7 +609,6 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 	if (ifidx == BRCMF_BAD_IF)
 		return;
 
-	ASSERT(drvr_priv->sysioc_tsk);
 	drvr_priv->set_multicast = true;
 	up(&drvr_priv->sysioc_sem);
 }
@@ -711,7 +701,6 @@ void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	drvr->txoff = state;
-	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
 	net = drvr_priv->iflist[ifidx]->net;
 	if (state == ON)
 		netif_stop_queue(net);
@@ -759,7 +748,6 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		if (ifp == NULL)
 			ifp = drvr_priv->iflist[0];
 
-		ASSERT(ifp);
 		skb->dev = ifp->net;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
@@ -778,7 +766,6 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 					  skb_mac_header(skb),
 					  &event, &data);
 
-		ASSERT(ifidx < BRCMF_MAX_IFS && drvr_priv->iflist[ifidx]);
 		if (drvr_priv->iflist[ifidx] &&
 		    !drvr_priv->iflist[ifidx]->state)
 			ifp = drvr_priv->iflist[ifidx];
@@ -833,7 +820,6 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 		return NULL;
 
 	ifp = drvr_priv->iflist[ifidx];
-	ASSERT(drvr_priv && ifp);
 
 	if (drvr_priv->pub.up) {
 		/* Use the protocol to get dongle stats */
@@ -1247,8 +1233,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 
 	BRCMF_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
 
-	ASSERT(drvr_priv && (ifidx < BRCMF_MAX_IFS));
-
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
@@ -1268,7 +1252,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	if (handle == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
-		ASSERT(drvr_priv->sysioc_tsk);
 		up(&drvr_priv->sysioc_sem);
 	} else
 		ifp->net = (struct net_device *)handle;
@@ -1282,7 +1265,6 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 
 	BRCMF_TRACE(("%s: idx %d\n", __func__, ifidx));
 
-	ASSERT(drvr_priv && ifidx && (ifidx < BRCMF_MAX_IFS));
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		BRCMF_ERROR(("%s: Null interface\n", __func__));
@@ -1291,7 +1273,6 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 
 	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
-	ASSERT(drvr_priv->sysioc_tsk);
 	up(&drvr_priv->sysioc_sem);
 }
 
@@ -1399,8 +1380,6 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	/* Room for "event_msgs" + '\0' + bitvec */
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 
-	ASSERT(drvr_priv);
-
 	BRCMF_TRACE(("%s:\n", __func__));
 
 	/* Bring up the bus */
@@ -1475,12 +1454,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 
 	BRCMF_TRACE(("%s: ifidx %d\n", __func__, ifidx));
 
-	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
-
 	net = drvr_priv->iflist[ifidx]->net;
-	ASSERT(net);
-
-	ASSERT(!net->netdev_ops);
 	net->netdev_ops = &brcmf_netdev_ops_pri;
 
 	/*
@@ -1557,7 +1531,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 					brcmf_del_if(drvr_priv, i);
 
 			ifp = drvr_priv->iflist[0];
-			ASSERT(ifp);
 			if (ifp->net->netdev_ops == &brcmf_netdev_ops_pri) {
 				brcmf_netdev_stop(ifp->net);
 				unregister_netdev(ifp->net);
@@ -1685,14 +1658,10 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktd
 {
 	int bcmerror = 0;
 
-	ASSERT(drvr_priv != NULL);
-
 	bcmerror = brcmf_c_host_event(drvr_priv, ifidx, pktdata, event, data);
 	if (bcmerror != 0)
 		return bcmerror;
 
-	ASSERT(drvr_priv->iflist[*ifidx] != NULL);
-	ASSERT(drvr_priv->iflist[*ifidx]->net != NULL);
 	if (drvr_priv->iflist[*ifidx]->net)
 		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->net,
 				     event, *data);
-- 
1.7.4.1


