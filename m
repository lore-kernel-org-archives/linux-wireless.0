Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3106 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab1JUNzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/17] brcm80211: fmac: store brcmf_if in net device
 private data
Date: Fri, 21 Oct 2011 15:55:17 +0200
Message-ID: <1319205319-16891-16-git-send-email-arend@broadcom.com> (sfid-20111021_155556_816796_9A2215DA)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Make a proper use of private data area of net device by storing
interface related data structure instead of generic driver data

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  165 +++++++-------------
 2 files changed, 56 insertions(+), 110 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 2cf22e0..a96a91f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -123,7 +123,6 @@
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
 #define BRCMF_DEL_IF	-0xe
-#define BRCMF_BAD_IF	-0xf
 
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 14ac210..394577a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -80,20 +80,6 @@ struct brcmf_info {
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
-
-static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *ndev)
-{
-	int i = 0;
-
-	while (i < BRCMF_MAX_IFS) {
-		if (drvr_priv->iflist[i] && drvr_priv->iflist[i]->ndev == ndev)
-			return i;
-		i++;
-	}
-
-	return BRCMF_BAD_IF;
-}
-
 int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 {
 	int i = BRCMF_MAX_IFS;
@@ -285,14 +271,9 @@ _brcmf_set_mac_address(struct work_struct *work)
 
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 	struct sockaddr *sa = (struct sockaddr *)addr;
-	int ifidx;
-
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-	if (ifidx == BRCMF_BAD_IF)
-		return -1;
 
 	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
 	schedule_work(&drvr_priv->setmacaddr_work);
@@ -301,13 +282,8 @@ static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 
 static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
-	int ifidx;
-
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-	if (ifidx == BRCMF_BAD_IF)
-		return;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
 	schedule_work(&drvr_priv->multicast_work);
 }
@@ -341,9 +317,8 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int ret;
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
-	int ifidx;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -355,9 +330,8 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return -ENODEV;
 	}
 
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-	if (ifidx == BRCMF_BAD_IF) {
-		brcmf_dbg(ERROR, "bad ifidx %d\n", ifidx);
+	if (!drvr_priv->iflist[ifp->idx]) {
+		brcmf_dbg(ERROR, "bad ifidx %d\n", ifp->idx);
 		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
@@ -367,20 +341,20 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		struct sk_buff *skb2;
 
 		brcmf_dbg(INFO, "%s: insufficient headroom\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx));
+			  brcmf_ifname(&drvr_priv->pub, ifp->idx));
 		drvr_priv->pub.tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr_priv->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			brcmf_dbg(ERROR, "%s: skb_realloc_headroom failed\n",
-				  brcmf_ifname(&drvr_priv->pub, ifidx));
+				  brcmf_ifname(&drvr_priv->pub, ifp->idx));
 			ret = -ENOMEM;
 			goto done;
 		}
 	}
 
-	ret = brcmf_sendpkt(&drvr_priv->pub, ifidx, skb);
+	ret = brcmf_sendpkt(&drvr_priv->pub, ifp->idx, skb);
 
 done:
 	if (ret)
@@ -524,19 +498,11 @@ void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
-	struct brcmf_if *ifp;
-	int ifidx;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-	if (ifidx == BRCMF_BAD_IF)
-		return NULL;
-
-	ifp = drvr_priv->iflist[ifidx];
-
 	if (drvr_priv->pub.up)
 		/* Use the protocol to get dongle stats */
 		brcmf_proto_dstats(&drvr_priv->pub);
@@ -637,8 +603,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 				    struct ethtool_drvinfo *info)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
@@ -765,14 +731,12 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 				    int cmd)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
-	int ifidx;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifidx, cmd);
+	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifp->idx, cmd);
 
-	if (ifidx == BRCMF_BAD_IF)
+	if (!drvr_priv->iflist[ifp->idx])
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
@@ -788,17 +752,14 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 	s32 err = 0;
 	int buflen = 0;
 	bool is_set_key_cmd;
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
-	int ifidx;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 
 	memset(&dcmd, 0, sizeof(dcmd));
 	dcmd.cmd = cmd;
 	dcmd.buf = arg;
 	dcmd.len = len;
 
-	ifidx = brcmf_net2idx(drvr_priv, ndev);
-
 	if (dcmd.buf != NULL)
 		buflen = min_t(uint, dcmd.len, BRCMF_DCMD_MAXLEN);
 
@@ -826,7 +787,7 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(ndev);
 
-	err = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, buflen);
+	err = brcmf_proto_dcmd(&drvr_priv->pub, ifp->idx, &dcmd, buflen);
 
 done:
 	if (err > 0)
@@ -837,7 +798,8 @@ done:
 
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
-	struct brcmf_pub *drvr = *(struct brcmf_pub **) netdev_priv(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = &ifp->info->pub;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down(drvr->config);
@@ -853,16 +815,14 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 
 static int brcmf_netdev_open(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
-					netdev_priv(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 	u32 toe_ol;
-	int ifidx = brcmf_net2idx(drvr_priv, ndev);
 	s32 ret = 0;
 
-	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
-
-	if (ifidx == 0) {	/* do it only for primary eth0 */
+	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
+	if (ifp->idx == 0) {	/* do it only for primary eth0 */
 		/* try to bring up bus */
 		ret = brcmf_bus_start(&drvr_priv->pub);
 		if (ret != 0) {
@@ -874,12 +834,12 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		memcpy(ndev->dev_addr, drvr_priv->pub.mac, ETH_ALEN);
 
 		/* Get current TOE mode from dongle */
-		if (brcmf_toe_get(drvr_priv, ifidx, &toe_ol) >= 0
+		if (brcmf_toe_get(drvr_priv, ifp->idx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			drvr_priv->iflist[ifidx]->ndev->features |=
+			drvr_priv->iflist[ifp->idx]->ndev->features |=
 				NETIF_F_IP_CSUM;
 		else
-			drvr_priv->iflist[ifidx]->ndev->features &=
+			drvr_priv->iflist[ifp->idx]->ndev->features &=
 				~NETIF_F_IP_CSUM;
 	}
 	/* Allow transmit calls */
@@ -907,53 +867,45 @@ int
 brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
-	int err = 0;
+	struct net_device *ndev;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
 	ifp = drvr_priv->iflist[ifidx];
-	if (!ifp) {
-		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
-		if (!ifp)
-			return -ENOMEM;
-
-		drvr_priv->iflist[ifidx] = ifp;
-	} else {
-		/*
-		 * Delete the existing interface before overwriting it
-		 * in case we missed the BRCMF_E_IF_DEL event.
-		 */
-		if (ifp->ndev != NULL) {
-			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
-				  ifp->ndev->name);
-			netif_stop_queue(ifp->ndev);
-			unregister_netdev(ifp->ndev);
-			free_netdev(ifp->ndev);
-		}
+	/*
+	 * Delete the existing interface before overwriting it
+	 * in case we missed the BRCMF_E_IF_DEL event.
+	 */
+	if (ifp) {
+		brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
+			  ifp->ndev->name);
+		netif_stop_queue(ifp->ndev);
+		unregister_netdev(ifp->ndev);
+		free_netdev(ifp->ndev);
+		drvr_priv->iflist[ifidx] = NULL;
 	}
-	memset(ifp, 0, sizeof(struct brcmf_if));
-	ifp->info = drvr_priv;
-	drvr_priv->iflist[ifidx] = ifp;
-	ifp->state = BRCMF_E_IF_ADD;
-	ifp->idx = ifidx;
 
 	/* Allocate netdev, including space for private structure */
-	ifp->ndev = alloc_netdev(sizeof(drvr_priv), name, ether_setup);
-	if (!ifp->ndev) {
+	ndev = alloc_netdev(sizeof(struct brcmf_if), name, ether_setup);
+	if (!ndev) {
 		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
-		err = -ENOMEM;
-		goto errout;
+		return -ENOMEM;
 	}
 
+	ifp = netdev_priv(ndev);
+	ifp->ndev = ndev;
+	ifp->info = drvr_priv;
+	drvr_priv->iflist[ifidx] = ifp;
+	ifp->state = BRCMF_E_IF_ADD;
+	ifp->idx = ifidx;
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	memcpy(netdev_priv(ifp->ndev), &drvr_priv, sizeof(drvr_priv));
 	if (brcmf_net_attach(&drvr_priv->pub, ifp->idx)) {
 		brcmf_dbg(ERROR, "brcmf_net_attach failed");
 		free_netdev(ifp->ndev);
-		err = -EOPNOTSUPP;
-		goto errout;
+		drvr_priv->iflist[ifidx] = NULL;
+		return -EOPNOTSUPP;
 	}
 
 	brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
@@ -961,11 +913,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 	ifp->state = 0;
 
 	return 0;
-
-errout:
-	kfree(ifp);
-	drvr_priv->iflist[ifidx] = NULL;
-	return err;
 }
 
 void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
@@ -996,7 +943,6 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 		if (ifidx == 0)
 			brcmf_cfg80211_detach(drvr_priv->pub.config);
 		free_netdev(ifp->ndev);
-		kfree(ifp);
 	}
 }
 
@@ -1268,7 +1214,8 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 
 int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_info *drvr_priv = ifp->info;
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
 	int pend = brcmf_get_pend_8021x_cnt(drvr_priv);
-- 
1.7.4.1


