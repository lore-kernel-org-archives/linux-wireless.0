Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2330 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/30] brcm80211: fmac: unify common layer driver data
 structure
Date: Fri, 16 Dec 2011 18:36:51 -0800
Message-ID: <1324089440-8957-2-git-send-email-frankyl@broadcom.com> (sfid-20111217_033750_699231_C4127736)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to split data structure for common layer into brcmf_pub and
brcmf_info. Absorb brcmf_info into brcmf_pub to increase code
readability.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   19 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   10 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  363 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 4 files changed, 180 insertions(+), 214 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index ed60f4d..c87144c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -580,7 +580,6 @@ struct brcmf_bus {
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_sdio;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
-struct brcmf_info;	/* device driver info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
 
 /* Common structure for module and instance linkage */
@@ -589,7 +588,6 @@ struct brcmf_pub {
 	struct brcmf_sdio *bus;
 	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
-	struct brcmf_info *info;
 	struct brcmf_cfg80211_dev *config;
 	struct device *dev;		/* fullmac dongle device pointer */
 
@@ -663,6 +661,15 @@ struct brcmf_pub {
 
 	u8 country_code[BRCM_CNTRY_BUF_SZ];
 	char eventmask[BRCMF_EVENTING_MASK_LEN];
+
+	struct brcmf_if *iflist[BRCMF_MAX_IFS];
+
+	struct mutex proto_block;
+
+	struct work_struct setmacaddr_work;
+	struct work_struct multicast_work;
+	u8 macvalue[ETH_ALEN];
+	atomic_t pend_8021x_cnt;
 };
 
 struct brcmf_if_event {
@@ -734,14 +741,14 @@ extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
 extern int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size);
 #endif				/* BCMDBG */
 
-extern int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name);
-extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
+extern int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name);
+extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
-extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx,
+extern int brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
 			char *name, u8 *mac_addr);
-extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
+extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
 /* Send packet to dongle via data channel */
 extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 69f335a..228b7ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -431,7 +431,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 #endif				/* BCMDBG */
 
 int
-brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
+brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 		   struct brcmf_event_msg *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
@@ -473,18 +473,18 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 
 		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
 			if (ifevent->action == BRCMF_E_IF_ADD)
-				brcmf_add_if(drvr_priv, ifevent->ifidx,
+				brcmf_add_if(drvr, ifevent->ifidx,
 					     event->ifname,
 					     pvt_data->eth.h_dest);
 			else
-				brcmf_del_if(drvr_priv, ifevent->ifidx);
+				brcmf_del_if(drvr, ifevent->ifidx);
 		} else {
 			brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
 				  ifevent->ifidx, event->ifname);
 		}
 
 		/* send up the if event: btamp user needs it */
-		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
+		*ifidx = brcmf_ifname2idx(drvr, event->ifname);
 		break;
 
 		/* These are what external supplicant/authenticator wants */
@@ -496,7 +496,7 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 	default:
 		/* Fall through: this should get _everything_  */
 
-		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
+		*ifidx = brcmf_ifname2idx(drvr, event->ifname);
 		brcmf_dbg(TRACE, "MAC event %d, flags %x, status %x\n",
 			  type, flags, status);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 58d92bc..f9cc5f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -52,7 +52,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 /* Interface control information */
 struct brcmf_if {
-	struct brcmf_info *info;	/* back pointer to brcmf_info */
+	struct brcmf_pub *drvr;	/* back pointer to brcmf_pub */
 	/* OS/stack specifics */
 	struct net_device *ndev;
 	struct net_device_stats stats;
@@ -60,26 +60,11 @@ struct brcmf_if {
 	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
 };
 
-/* Local private structure (extension of pub) */
-struct brcmf_info {
-	struct brcmf_pub pub;
-
-	/* OS/stack specifics */
-	struct brcmf_if *iflist[BRCMF_MAX_IFS];
-
-	struct mutex proto_block;
-
-	struct work_struct setmacaddr_work;
-	struct work_struct multicast_work;
-	u8 macvalue[ETH_ALEN];
-	atomic_t pend_8021x_cnt;
-};
-
 /* Error bits */
 int brcmf_msg_level = BRCMF_ERROR_VAL;
 module_param(brcmf_msg_level, int, 0);
 
-int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
+int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name)
 {
 	int i = BRCMF_MAX_IFS;
 	struct brcmf_if *ifp;
@@ -88,7 +73,7 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 		return 0;
 
 	while (--i > 0) {
-		ifp = drvr_priv->iflist[i];
+		ifp = drvr->iflist[i];
 		if (ifp && !strncmp(ifp->ndev->name, name, IFNAMSIZ))
 			break;
 	}
@@ -100,20 +85,18 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 
 char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
-
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
 		brcmf_dbg(ERROR, "ifidx %d out of range\n", ifidx);
 		return "<if_bad>";
 	}
 
-	if (drvr_priv->iflist[ifidx] == NULL) {
+	if (drvr->iflist[ifidx] == NULL) {
 		brcmf_dbg(ERROR, "null i/f %d\n", ifidx);
 		return "<if_null>";
 	}
 
-	if (drvr_priv->iflist[ifidx]->ndev)
-		return drvr_priv->iflist[ifidx]->ndev->name;
+	if (drvr->iflist[ifidx]->ndev)
+		return drvr->iflist[ifidx]->ndev->name;
 
 	return "<if_none>";
 }
@@ -131,10 +114,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	uint buflen;
 	int ret;
 
-	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
+	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
 						    multicast_work);
 
-	ndev = drvr_priv->iflist[0]->ndev;
+	ndev = drvr->iflist[0]->ndev;
 	cnt = netdev_mc_count(ndev);
 
 	/* Determine initial value of allmulti flag */
@@ -168,10 +151,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	dcmd.len = buflen;
 	dcmd.set = true;
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
-			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
+			  brcmf_ifname(drvr, 0), cnt);
 		dcmd_value = cnt ? true : dcmd_value;
 	}
 
@@ -193,7 +176,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	    ("allmulti", (void *)&dcmd_le_value,
 	    sizeof(dcmd_le_value), buf, buflen)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
-			  brcmf_ifname(&drvr_priv->pub, 0),
+			  brcmf_ifname(drvr, 0),
 			  (int)sizeof(dcmd_value), buflen);
 		kfree(buf);
 		return;
@@ -205,10 +188,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	dcmd.len = buflen;
 	dcmd.set = true;
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
-			  brcmf_ifname(&drvr_priv->pub, 0),
+			  brcmf_ifname(drvr, 0),
 			  le32_to_cpu(dcmd_le_value));
 	}
 
@@ -226,10 +209,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	dcmd.len = sizeof(dcmd_le_value);
 	dcmd.set = true;
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
-			  brcmf_ifname(&drvr_priv->pub, 0),
+			  brcmf_ifname(drvr, 0),
 			  le32_to_cpu(dcmd_le_value));
 	}
 }
@@ -241,14 +224,14 @@ _brcmf_set_mac_address(struct work_struct *work)
 	struct brcmf_dcmd dcmd;
 	int ret;
 
-	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
+	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
 						    setmacaddr_work);
 
 	brcmf_dbg(TRACE, "enter\n");
-	if (!brcmf_c_mkiovar("cur_etheraddr", (char *)drvr_priv->macvalue,
+	if (!brcmf_c_mkiovar("cur_etheraddr", (char *)drvr->macvalue,
 			   ETH_ALEN, buf, 32)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
-			  brcmf_ifname(&drvr_priv->pub, 0));
+			  brcmf_ifname(drvr, 0));
 		return;
 	}
 	memset(&dcmd, 0, sizeof(dcmd));
@@ -257,13 +240,13 @@ _brcmf_set_mac_address(struct work_struct *work)
 	dcmd.len = 32;
 	dcmd.set = true;
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
 	if (ret < 0)
 		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
-			  brcmf_ifname(&drvr_priv->pub, 0));
+			  brcmf_ifname(drvr, 0));
 	else
-		memcpy(drvr_priv->iflist[0]->ndev->dev_addr,
-		       drvr_priv->macvalue, ETH_ALEN);
+		memcpy(drvr->iflist[0]->ndev->dev_addr,
+		       drvr->macvalue, ETH_ALEN);
 
 	return;
 }
@@ -271,26 +254,24 @@ _brcmf_set_mac_address(struct work_struct *work)
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct sockaddr *sa = (struct sockaddr *)addr;
 
-	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
-	schedule_work(&drvr_priv->setmacaddr_work);
+	memcpy(&drvr->macvalue, sa->sa_data, ETH_ALEN);
+	schedule_work(&drvr->setmacaddr_work);
 	return 0;
 }
 
 static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
-	schedule_work(&drvr_priv->multicast_work);
+	schedule_work(&drvr->multicast_work);
 }
 
 int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
-
 	/* Reject if down */
 	if (!drvr->up || (drvr->bus_if->state == BRCMF_BUS_DOWN))
 		return -ENODEV;
@@ -303,7 +284,7 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 		if (is_multicast_ether_addr(eh->h_dest))
 			drvr->tx_multicast++;
 		if (ntohs(eh->h_proto) == ETH_P_PAE)
-			atomic_inc(&drvr_priv->pend_8021x_cnt);
+			atomic_inc(&drvr->pend_8021x_cnt);
 	}
 
 	/* If the protocol uses a data header, apply it */
@@ -317,51 +298,51 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Reject if down */
-	if (!drvr_priv->pub.up ||
-	    (drvr_priv->pub.bus_if->state == BRCMF_BUS_DOWN)) {
+	if (!drvr->up ||
+	    (drvr->bus_if->state == BRCMF_BUS_DOWN)) {
 		brcmf_dbg(ERROR, "xmit rejected pub.up=%d state=%d\n",
-			  drvr_priv->pub.up,
-			  drvr_priv->pub.bus_if->state);
+			  drvr->up,
+			  drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
 
-	if (!drvr_priv->iflist[ifp->idx]) {
+	if (!drvr->iflist[ifp->idx]) {
 		brcmf_dbg(ERROR, "bad ifidx %d\n", ifp->idx);
 		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
 
 	/* Make sure there's enough room for any header */
-	if (skb_headroom(skb) < drvr_priv->pub.hdrlen) {
+	if (skb_headroom(skb) < drvr->hdrlen) {
 		struct sk_buff *skb2;
 
 		brcmf_dbg(INFO, "%s: insufficient headroom\n",
-			  brcmf_ifname(&drvr_priv->pub, ifp->idx));
-		drvr_priv->pub.tx_realloc++;
-		skb2 = skb_realloc_headroom(skb, drvr_priv->pub.hdrlen);
+			  brcmf_ifname(drvr, ifp->idx));
+		drvr->tx_realloc++;
+		skb2 = skb_realloc_headroom(skb, drvr->hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			brcmf_dbg(ERROR, "%s: skb_realloc_headroom failed\n",
-				  brcmf_ifname(&drvr_priv->pub, ifp->idx));
+				  brcmf_ifname(drvr, ifp->idx));
 			ret = -ENOMEM;
 			goto done;
 		}
 	}
 
-	ret = brcmf_sendpkt(&drvr_priv->pub, ifp->idx, skb);
+	ret = brcmf_sendpkt(drvr, ifp->idx, skb);
 
 done:
 	if (ret)
-		drvr_priv->pub.dstats.tx_dropped++;
+		drvr->dstats.tx_dropped++;
 	else
-		drvr_priv->pub.tx_packets++;
+		drvr->tx_packets++;
 
 	/* Return ok: we always eat the packet */
 	return 0;
@@ -370,30 +351,29 @@ done:
 void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 {
 	struct net_device *ndev;
-	struct brcmf_info *drvr_priv = drvr->info;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	drvr->txoff = state;
-	ndev = drvr_priv->iflist[ifidx]->ndev;
+	ndev = drvr->iflist[ifidx]->ndev;
 	if (state == ON)
 		netif_stop_queue(ndev);
 	else
 		netif_wake_queue(ndev);
 }
 
-static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
+static int brcmf_host_event(struct brcmf_pub *drvr, int *ifidx,
 			    void *pktdata, struct brcmf_event_msg *event,
 			    void **data)
 {
 	int bcmerror = 0;
 
-	bcmerror = brcmf_c_host_event(drvr_priv, ifidx, pktdata, event, data);
+	bcmerror = brcmf_c_host_event(drvr, ifidx, pktdata, event, data);
 	if (bcmerror != 0)
 		return bcmerror;
 
-	if (drvr_priv->iflist[*ifidx]->ndev)
-		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->ndev,
+	if (drvr->iflist[*ifidx]->ndev)
+		brcmf_cfg80211_event(drvr->iflist[*ifidx]->ndev,
 				     event, *data);
 
 	return bcmerror;
@@ -402,7 +382,6 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
 void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 		    struct sk_buff_head *skb_list)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
 	unsigned char *eth;
 	uint len;
 	void *data;
@@ -430,9 +409,9 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 		eth = skb->data;
 		len = skb->len;
 
-		ifp = drvr_priv->iflist[ifidx];
+		ifp = drvr->iflist[ifidx];
 		if (ifp == NULL)
-			ifp = drvr_priv->iflist[0];
+			ifp = drvr->iflist[0];
 
 		if (!ifp || !ifp->ndev ||
 		    ifp->ndev->reg_state != NETREG_REGISTERED) {
@@ -444,7 +423,7 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
-			drvr_priv->pub.rx_multicast++;
+			drvr->rx_multicast++;
 
 		skb->data = eth;
 		skb->len = len;
@@ -454,12 +433,12 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 
 		/* Process special event packets and then discard them */
 		if (ntohs(skb->protocol) == ETH_P_LINK_CTL)
-			brcmf_host_event(drvr_priv, &ifidx,
+			brcmf_host_event(drvr, &ifidx,
 					  skb_mac_header(skb),
 					  &event, &data);
 
-		if (drvr_priv->iflist[ifidx]) {
-			ifp = drvr_priv->iflist[ifidx];
+		if (drvr->iflist[ifidx]) {
+			ifp = drvr->iflist[ifidx];
 			ifp->ndev->last_rx = jiffies;
 		}
 
@@ -482,7 +461,6 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
-	struct brcmf_info *drvr_priv = drvr->info;
 	struct ethhdr *eh;
 	u16 type;
 
@@ -492,38 +470,38 @@ void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE)
-		atomic_dec(&drvr_priv->pend_8021x_cnt);
+		atomic_dec(&drvr->pend_8021x_cnt);
 
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (drvr_priv->pub.up)
+	if (drvr->up)
 		/* Use the protocol to get dongle stats */
-		brcmf_proto_dstats(&drvr_priv->pub);
+		brcmf_proto_dstats(drvr);
 
 	/* Copy dongle stats to net device stats */
-	ifp->stats.rx_packets = drvr_priv->pub.dstats.rx_packets;
-	ifp->stats.tx_packets = drvr_priv->pub.dstats.tx_packets;
-	ifp->stats.rx_bytes = drvr_priv->pub.dstats.rx_bytes;
-	ifp->stats.tx_bytes = drvr_priv->pub.dstats.tx_bytes;
-	ifp->stats.rx_errors = drvr_priv->pub.dstats.rx_errors;
-	ifp->stats.tx_errors = drvr_priv->pub.dstats.tx_errors;
-	ifp->stats.rx_dropped = drvr_priv->pub.dstats.rx_dropped;
-	ifp->stats.tx_dropped = drvr_priv->pub.dstats.tx_dropped;
-	ifp->stats.multicast = drvr_priv->pub.dstats.multicast;
+	ifp->stats.rx_packets = drvr->dstats.rx_packets;
+	ifp->stats.tx_packets = drvr->dstats.tx_packets;
+	ifp->stats.rx_bytes = drvr->dstats.rx_bytes;
+	ifp->stats.tx_bytes = drvr->dstats.tx_bytes;
+	ifp->stats.rx_errors = drvr->dstats.rx_errors;
+	ifp->stats.tx_errors = drvr->dstats.tx_errors;
+	ifp->stats.rx_dropped = drvr->dstats.rx_dropped;
+	ifp->stats.tx_dropped = drvr->dstats.tx_dropped;
+	ifp->stats.multicast = drvr->dstats.multicast;
 
 	return &ifp->stats;
 }
 
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
-static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
+static int brcmf_toe_get(struct brcmf_pub *drvr, int ifidx, u32 *toe_ol)
 {
 	struct brcmf_dcmd dcmd;
 	__le32 toe_le;
@@ -538,17 +516,17 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 	dcmd.set = false;
 
 	strcpy(buf, "toe_ol");
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
 			brcmf_dbg(ERROR, "%s: toe not supported by device\n",
-				  brcmf_ifname(&drvr_priv->pub, ifidx));
+				  brcmf_ifname(drvr, ifidx));
 			return -EOPNOTSUPP;
 		}
 
 		brcmf_dbg(INFO, "%s: could not get toe_ol: ret=%d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
+			  brcmf_ifname(drvr, ifidx), ret);
 		return ret;
 	}
 
@@ -559,7 +537,7 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 
 /* Set current toe component enables in toe_ol iovar,
 	 and set toe global enable iovar */
-static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
+static int brcmf_toe_set(struct brcmf_pub *drvr, int ifidx, u32 toe_ol)
 {
 	struct brcmf_dcmd dcmd;
 	char buf[32];
@@ -577,10 +555,10 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe_ol");
 	memcpy(&buf[sizeof("toe_ol")], &toe_le, sizeof(u32));
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
+			  brcmf_ifname(drvr, ifidx), ret);
 		return ret;
 	}
 
@@ -590,10 +568,10 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe");
 	memcpy(&buf[sizeof("toe")], &toe_le, sizeof(u32));
 
-	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
+	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe: ret=%d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
+			  brcmf_ifname(drvr, ifidx), ret);
 		return ret;
 	}
 
@@ -604,18 +582,18 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 				    struct ethtool_drvinfo *info)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	sprintf(info->driver, KBUILD_MODNAME);
-	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
-	sprintf(info->bus_info, "%s", dev_name(drvr_priv->pub.dev));
+	sprintf(info->version, "%lu", drvr->drv_version);
+	sprintf(info->bus_info, "%s", dev_name(drvr->dev));
 }
 
 static struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
-static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
+static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 {
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
@@ -649,18 +627,18 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 		}
 
 		/* otherwise, require dongle to be up */
-		else if (!drvr_priv->pub.up) {
+		else if (!drvr->up) {
 			brcmf_dbg(ERROR, "dongle is not up\n");
 			return -ENODEV;
 		}
 
 		/* finally, report dongle driver type */
-		else if (drvr_priv->pub.iswl)
+		else if (drvr->iswl)
 			sprintf(info.driver, "wl");
 		else
 			sprintf(info.driver, "xx");
 
-		sprintf(info.version, "%lu", drvr_priv->pub.drv_version);
+		sprintf(info.version, "%lu", drvr->drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
 		brcmf_dbg(CTL, "given %*s, returning %s\n",
@@ -670,7 +648,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 		/* Get toe offload components from dongle */
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
-		ret = brcmf_toe_get(drvr_priv, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(drvr, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -691,7 +669,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 			return -EFAULT;
 
 		/* Read the current settings, update and write back */
-		ret = brcmf_toe_get(drvr_priv, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(drvr, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -703,17 +681,17 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 		else
 			toe_cmpnt &= ~csum_dir;
 
-		ret = brcmf_toe_set(drvr_priv, 0, toe_cmpnt);
+		ret = brcmf_toe_set(drvr, 0, toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
 		/* If setting TX checksum mode, tell Linux the new mode */
 		if (cmd == ETHTOOL_STXCSUM) {
 			if (edata.data)
-				drvr_priv->iflist[0]->ndev->features |=
+				drvr->iflist[0]->ndev->features |=
 				    NETIF_F_IP_CSUM;
 			else
-				drvr_priv->iflist[0]->ndev->features &=
+				drvr->iflist[0]->ndev->features &=
 				    ~NETIF_F_IP_CSUM;
 		}
 
@@ -730,15 +708,15 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 				    int cmd)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifp->idx, cmd);
 
-	if (!drvr_priv->iflist[ifp->idx])
+	if (!drvr->iflist[ifp->idx])
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
-		return brcmf_ethtool(drvr_priv, ifr->ifr_data);
+		return brcmf_ethtool(drvr, ifr->ifr_data);
 
 	return -EOPNOTSUPP;
 }
@@ -751,7 +729,7 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 	int buflen = 0;
 	bool is_set_key_cmd;
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	memset(&dcmd, 0, sizeof(dcmd));
 	dcmd.cmd = cmd;
@@ -762,13 +740,13 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 		buflen = min_t(uint, dcmd.len, BRCMF_DCMD_MAXLEN);
 
 	/* send to dongle (must be up, and wl) */
-	if ((drvr_priv->pub.bus_if->state != BRCMF_BUS_DATA)) {
+	if ((drvr->bus_if->state != BRCMF_BUS_DATA)) {
 		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
 		err = -EIO;
 		goto done;
 	}
 
-	if (!drvr_priv->pub.iswl) {
+	if (!drvr->iswl) {
 		err = -EIO;
 		goto done;
 	}
@@ -785,7 +763,7 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(ndev);
 
-	err = brcmf_proto_dcmd(&drvr_priv->pub, ifp->idx, &dcmd, buflen);
+	err = brcmf_proto_dcmd(drvr, ifp->idx, &dcmd, buflen);
 
 done:
 	if (err > 0)
@@ -797,7 +775,7 @@ done:
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = &ifp->info->pub;
+	struct brcmf_pub *drvr = ifp->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down(drvr->config);
@@ -814,7 +792,7 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 static int brcmf_netdev_open(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 	u32 toe_ol;
 	s32 ret = 0;
 
@@ -822,28 +800,28 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	if (ifp->idx == 0) {	/* do it only for primary eth0 */
 		/* try to bring up bus */
-		ret = brcmf_bus_start(&drvr_priv->pub);
+		ret = brcmf_bus_start(drvr);
 		if (ret != 0) {
 			brcmf_dbg(ERROR, "failed with code %d\n", ret);
 			return -1;
 		}
-		atomic_set(&drvr_priv->pend_8021x_cnt, 0);
+		atomic_set(&drvr->pend_8021x_cnt, 0);
 
-		memcpy(ndev->dev_addr, drvr_priv->pub.mac, ETH_ALEN);
+		memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
 
 		/* Get current TOE mode from dongle */
-		if (brcmf_toe_get(drvr_priv, ifp->idx, &toe_ol) >= 0
+		if (brcmf_toe_get(drvr, ifp->idx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			drvr_priv->iflist[ifp->idx]->ndev->features |=
+			drvr->iflist[ifp->idx]->ndev->features |=
 				NETIF_F_IP_CSUM;
 		else
-			drvr_priv->iflist[ifp->idx]->ndev->features &=
+			drvr->iflist[ifp->idx]->ndev->features &=
 				~NETIF_F_IP_CSUM;
 	}
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
-	drvr_priv->pub.up = 1;
-	if (brcmf_cfg80211_up(drvr_priv->pub.config)) {
+	drvr->up = 1;
+	if (brcmf_cfg80211_up(drvr->config)) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
 	}
@@ -862,14 +840,14 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 };
 
 int
-brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
+brcmf_add_if(struct brcmf_pub *drvr, int ifidx, char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
-	ifp = drvr_priv->iflist[ifidx];
+	ifp = drvr->iflist[ifidx];
 	/*
 	 * Delete the existing interface before overwriting it
 	 * in case we missed the BRCMF_E_IF_DEL event.
@@ -880,7 +858,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 		netif_stop_queue(ifp->ndev);
 		unregister_netdev(ifp->ndev);
 		free_netdev(ifp->ndev);
-		drvr_priv->iflist[ifidx] = NULL;
+		drvr->iflist[ifidx] = NULL;
 	}
 
 	/* Allocate netdev, including space for private structure */
@@ -892,16 +870,16 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 
 	ifp = netdev_priv(ndev);
 	ifp->ndev = ndev;
-	ifp->info = drvr_priv;
-	drvr_priv->iflist[ifidx] = ifp;
+	ifp->drvr = drvr;
+	drvr->iflist[ifidx] = ifp;
 	ifp->idx = ifidx;
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	if (brcmf_net_attach(&drvr_priv->pub, ifp->idx)) {
+	if (brcmf_net_attach(drvr, ifp->idx)) {
 		brcmf_dbg(ERROR, "brcmf_net_attach failed");
 		free_netdev(ifp->ndev);
-		drvr_priv->iflist[ifidx] = NULL;
+		drvr->iflist[ifidx] = NULL;
 		return -EOPNOTSUPP;
 	}
 
@@ -911,13 +889,13 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 	return 0;
 }
 
-void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
+void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_if *ifp;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
-	ifp = drvr_priv->iflist[ifidx];
+	ifp = drvr->iflist[ifidx];
 	if (!ifp) {
 		brcmf_dbg(ERROR, "Null interface\n");
 		return;
@@ -934,9 +912,9 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 		}
 
 		unregister_netdev(ifp->ndev);
-		drvr_priv->iflist[ifidx] = NULL;
+		drvr->iflist[ifidx] = NULL;
 		if (ifidx == 0)
-			brcmf_cfg80211_detach(drvr_priv->pub.config);
+			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(ifp->ndev);
 	}
 }
@@ -944,40 +922,37 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 			       struct device *dev)
 {
-	struct brcmf_info *drvr_priv = NULL;
+	struct brcmf_pub *drvr = NULL;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Allocate primary brcmf_info */
-	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
-	if (!drvr_priv)
+	drvr = kzalloc(sizeof(struct brcmf_pub), GFP_ATOMIC);
+	if (!drvr)
 		goto fail;
 
-	mutex_init(&drvr_priv->proto_block);
-
-	/* Link to info module */
-	drvr_priv->pub.info = drvr_priv;
+	mutex_init(&drvr->proto_block);
 
 	/* Link to bus module */
-	drvr_priv->pub.bus = bus;
-	drvr_priv->pub.hdrlen = bus_hdrlen;
-	drvr_priv->pub.bus_if = dev_get_drvdata(dev);
-	drvr_priv->pub.dev = dev;
+	drvr->bus = bus;
+	drvr->hdrlen = bus_hdrlen;
+	drvr->bus_if = dev_get_drvdata(dev);
+	drvr->dev = dev;
 
 	/* Attach and link in the protocol */
-	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
+	if (brcmf_proto_attach(drvr) != 0) {
 		brcmf_dbg(ERROR, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
-	INIT_WORK(&drvr_priv->setmacaddr_work, _brcmf_set_mac_address);
-	INIT_WORK(&drvr_priv->multicast_work, _brcmf_set_multicast_list);
+	INIT_WORK(&drvr->setmacaddr_work, _brcmf_set_mac_address);
+	INIT_WORK(&drvr->multicast_work, _brcmf_set_multicast_list);
 
-	return &drvr_priv->pub;
+	return drvr;
 
 fail:
-	if (drvr_priv)
-		brcmf_detach(&drvr_priv->pub);
+	if (drvr)
+		brcmf_detach(drvr);
 
 	return NULL;
 }
@@ -985,21 +960,20 @@ fail:
 int brcmf_bus_start(struct brcmf_pub *drvr)
 {
 	int ret = -1;
-	struct brcmf_info *drvr_priv = drvr->info;
 	/* Room for "event_msgs" + '\0' + bitvec */
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(drvr_priv->pub.dev);
+	ret = brcmf_sdbrcm_bus_init(drvr->dev);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
 	}
 
 	/* If bus is not ready, can't come up */
-	if (drvr_priv->pub.bus_if->state != BRCMF_BUS_DATA) {
+	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
 		brcmf_dbg(ERROR, "failed bus is not ready\n");
 		return -ENODEV;
 	}
@@ -1036,7 +1010,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	drvr->pktfilter[0] = "100 0 0 0 0x01 0x00";
 
 	/* Bus is ready, do any protocol initialization */
-	ret = brcmf_proto_init(&drvr_priv->pub);
+	ret = brcmf_proto_init(drvr);
 	if (ret < 0)
 		return ret;
 
@@ -1045,14 +1019,13 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 
 int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
 	struct net_device *ndev;
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
 
-	ndev = drvr_priv->iflist[ifidx]->ndev;
+	ndev = drvr->iflist[ifidx]->ndev;
 	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
 	/*
@@ -1060,7 +1033,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	 */
 	if (ifidx != 0) {
 		/* for virtual interfaces use the primary MAC  */
-		memcpy(temp_addr, drvr_priv->pub.mac, ETH_ALEN);
+		memcpy(temp_addr, drvr->mac, ETH_ALEN);
 
 	}
 
@@ -1071,11 +1044,11 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 			 - Locally Administered address  */
 
 	}
-	ndev->hard_header_len = ETH_HLEN + drvr_priv->pub.hdrlen;
+	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
-	drvr_priv->pub.rxsz = ndev->mtu + ndev->hard_header_len +
-			      drvr_priv->pub.hdrlen;
+	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
+			      drvr->hdrlen;
 
 	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
 
@@ -1104,57 +1077,45 @@ fail:
 
 static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
-	struct brcmf_info *drvr_priv;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr) {
-		drvr_priv = drvr->info;
-		if (drvr_priv) {
-			/* Stop the protocol module */
-			brcmf_proto_stop(&drvr_priv->pub);
+		/* Stop the protocol module */
+		brcmf_proto_stop(drvr);
 
-			/* Stop the bus module */
-			brcmf_sdbrcm_bus_stop(drvr_priv->pub.dev);
-		}
+		/* Stop the bus module */
+		brcmf_sdbrcm_bus_stop(drvr->dev);
 	}
 }
 
 void brcmf_detach(struct brcmf_pub *drvr)
 {
-	struct brcmf_info *drvr_priv;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr) {
-		drvr_priv = drvr->info;
-		if (drvr_priv) {
-			int i;
+		int i;
 
-			/* make sure primary interface removed last */
-			for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-				if (drvr_priv->iflist[i])
-					brcmf_del_if(drvr_priv, i);
+		/* make sure primary interface removed last */
+		for (i = BRCMF_MAX_IFS-1; i > -1; i--)
+			if (drvr->iflist[i])
+				brcmf_del_if(drvr, i);
 
-			cancel_work_sync(&drvr_priv->setmacaddr_work);
-			cancel_work_sync(&drvr_priv->multicast_work);
+		cancel_work_sync(&drvr->setmacaddr_work);
+		cancel_work_sync(&drvr->multicast_work);
 
-			brcmf_bus_detach(drvr);
+		brcmf_bus_detach(drvr);
 
-			if (drvr->prot)
-				brcmf_proto_detach(drvr);
+		if (drvr->prot)
+			brcmf_proto_detach(drvr);
 
-			kfree(drvr_priv);
-		}
+		kfree(drvr);
 	}
 }
 
 int brcmf_os_proto_block(struct brcmf_pub *drvr)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
-
-	if (drvr_priv) {
-		mutex_lock(&drvr_priv->proto_block);
+	if (drvr) {
+		mutex_lock(&drvr->proto_block);
 		return 1;
 	}
 	return 0;
@@ -1162,19 +1123,17 @@ int brcmf_os_proto_block(struct brcmf_pub *drvr)
 
 int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 {
-	struct brcmf_info *drvr_priv = drvr->info;
-
-	if (drvr_priv) {
-		mutex_unlock(&drvr_priv->proto_block);
+	if (drvr) {
+		mutex_unlock(&drvr->proto_block);
 		return 1;
 	}
 
 	return 0;
 }
 
-static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
+static int brcmf_get_pend_8021x_cnt(struct brcmf_pub *drvr)
 {
-	return atomic_read(&drvr_priv->pend_8021x_cnt);
+	return atomic_read(&drvr->pend_8021x_cnt);
 }
 
 #define MAX_WAIT_FOR_8021X_TX	10
@@ -1182,10 +1141,10 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_info *drvr_priv = ifp->info;
+	struct brcmf_pub *drvr = ifp->drvr;
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
-	int pend = brcmf_get_pend_8021x_cnt(drvr_priv);
+	int pend = brcmf_get_pend_8021x_cnt(drvr);
 
 	while (ntimes && pend) {
 		if (pend) {
@@ -1194,7 +1153,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 			set_current_state(TASK_RUNNING);
 			ntimes--;
 		}
-		pend = brcmf_get_pend_8021x_cnt(drvr_priv);
+		pend = brcmf_get_pend_8021x_cnt(drvr);
 	}
 	return pend;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 43ba0dd..3096166 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3980,7 +3980,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* add interface and open for business */
-	if (brcmf_add_if((struct brcmf_info *)bus->drvr, 0, "wlan%d", NULL)) {
+	if (brcmf_add_if(bus->drvr, 0, "wlan%d", NULL)) {
 		brcmf_dbg(ERROR, "Add primary net device interface failed!!\n");
 		goto fail;
 	}
-- 
1.7.5.4


