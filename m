Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4568 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/20] staging: brcm80211: consistent naming of struct
 net_device *ndev
Date: Mon, 19 Sep 2011 14:26:06 -0700
Message-ID: <1316467568-27683-19-git-send-email-frankyl@broadcom.com> (sfid-20110919_232820_082916_16A8D4D6)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Various names (ndev, net, dev) were used for the
same structure. Settled for 'ndev'.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |  214 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  219 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 4 files changed, 225 insertions(+), 216 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 7ab45d9..a16f731 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -722,9 +722,9 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
 extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 				      uint bus_hdrlen);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
-extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
+extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
-extern int brcmf_netdev_ioctl_priv(struct net_device *net,
+extern int brcmf_netdev_ioctl_priv(struct net_device *ndev,
 				   struct brcmf_ioctl *ioc);
 
 /* Indication from bus module regarding removal/absence of dongle */
@@ -766,7 +766,7 @@ extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
 extern void brcmf_c_init(void);
 
 extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx,
-			struct net_device *net, char *name, u8 *mac_addr,
+			struct net_device *ndev, char *name, u8 *mac_addr,
 			u32 flags, u8 bssidx);
 extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 659a9c2..827022e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -53,7 +53,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 struct brcmf_if {
 	struct brcmf_info *info;	/* back pointer to brcmf_info */
 	/* OS/stack specifics */
-	struct net_device *net;
+	struct net_device *ndev;
 	struct net_device_stats stats;
 	int idx;		/* iface idx in dongle */
 	int state;		/* interface state */
@@ -83,12 +83,12 @@ struct brcmf_info {
 module_param(brcmf_msg_level, int, 0);
 
 
-static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
+static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *ndev)
 {
 	int i = 0;
 
 	while (i < BRCMF_MAX_IFS) {
-		if (drvr_priv->iflist[i] && (drvr_priv->iflist[i]->net == net))
+		if (drvr_priv->iflist[i] && drvr_priv->iflist[i]->ndev == ndev)
 			return i;
 		i++;
 	}
@@ -127,15 +127,15 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 		return "<if_null>";
 	}
 
-	if (drvr_priv->iflist[ifidx]->net)
-		return drvr_priv->iflist[ifidx]->net->name;
+	if (drvr_priv->iflist[ifidx]->ndev)
+		return drvr_priv->iflist[ifidx]->ndev->name;
 
 	return "<if_none>";
 }
 
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
-	struct net_device *dev;
+	struct net_device *ndev;
 	struct netdev_hw_addr *ha;
 	u32 allmulti, cnt;
 	__le32 cnt_le;
@@ -149,11 +149,11 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
 						    multicast_work);
 
-	dev = drvr_priv->iflist[0]->net;
-	cnt = netdev_mc_count(dev);
+	ndev = drvr_priv->iflist[0]->ndev;
+	cnt = netdev_mc_count(ndev);
 
 	/* Determine initial value of allmulti flag */
-	allmulti = (dev->flags & IFF_ALLMULTI) ? true : false;
+	allmulti = (ndev->flags & IFF_ALLMULTI) ? true : false;
 
 	/* Send down the multicast list first. */
 
@@ -169,7 +169,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	memcpy(bufp, &cnt_le, sizeof(cnt));
 	bufp += sizeof(cnt_le);
 
-	netdev_for_each_mc_addr(ha, dev) {
+	netdev_for_each_mc_addr(ha, ndev) {
 		if (!cnt)
 			break;
 		memcpy(bufp, ha->addr, ETH_ALEN);
@@ -232,7 +232,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	/* Finally, pick up the PROMISC flag as well, like the NIC
 		 driver does */
 
-	allmulti = (dev->flags & IFF_PROMISC) ? true : false;
+	allmulti = (ndev->flags & IFF_PROMISC) ? true : false;
 	allmulti_le = cpu_to_le32(allmulti);
 
 	memset(&ioc, 0, sizeof(ioc));
@@ -277,7 +277,7 @@ _brcmf_set_mac_address(struct work_struct *work)
 		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0));
 	else
-		memcpy(drvr_priv->iflist[0]->net->dev_addr,
+		memcpy(drvr_priv->iflist[0]->ndev->dev_addr,
 		       drvr_priv->macvalue, ETH_ALEN);
 
 	return;
@@ -299,23 +299,23 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		 * Delete the existing interface before overwriting it
 		 * in case we missed the BRCMF_E_IF_DEL event.
 		 */
-		if (ifp->net != NULL) {
+		if (ifp->ndev != NULL) {
 			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
-				  ifp->net->name);
-			netif_stop_queue(ifp->net);
-			unregister_netdev(ifp->net);
-			free_netdev(ifp->net);
+				  ifp->ndev->name);
+			netif_stop_queue(ifp->ndev);
+			unregister_netdev(ifp->ndev);
+			free_netdev(ifp->ndev);
 		}
 		/* Allocate netdev, including space for private structure */
-		ifp->net = alloc_netdev(sizeof(drvr_priv), "wlan%d",
-					ether_setup);
-		if (!ifp->net) {
+		ifp->ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d",
+					 ether_setup);
+		if (!ifp->ndev) {
 			brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
-			strcpy(ifp->net->name, ifp->name);
-			memcpy(netdev_priv(ifp->net), &drvr_priv,
+			strcpy(ifp->ndev->name, ifp->name);
+			memcpy(netdev_priv(ifp->ndev), &drvr_priv,
 			       sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
@@ -324,16 +324,16 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 				ret = -EOPNOTSUPP;
 			} else {
 				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
-					  current->pid, ifp->net->name);
+					  current->pid, ifp->ndev->name);
 				ifp->state = 0;
 			}
 		}
 		break;
 	case BRCMF_E_IF_DEL:
-		if (ifp->net != NULL) {
+		if (ifp->ndev != NULL) {
 			brcmf_dbg(TRACE, "got 'WLC_E_IF_DEL' state\n");
-			netif_stop_queue(ifp->net);
-			unregister_netdev(ifp->net);
+			netif_stop_queue(ifp->ndev);
+			unregister_netdev(ifp->ndev);
 			ret = BRCMF_DEL_IF;	/* Make sure the free_netdev()
 							 is called */
 		}
@@ -344,21 +344,22 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 	}
 
 	if (ret < 0) {
-		if (ifp->net)
-			free_netdev(ifp->net);
+		if (ifp->ndev)
+			free_netdev(ifp->ndev);
 
 		drvr_priv->iflist[ifp->idx] = NULL;
 		kfree(ifp);
 	}
 }
 
-static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
+static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int ifidx;
 
-	ifidx = brcmf_net2idx(drvr_priv, dev);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 	if (ifidx == BRCMF_BAD_IF)
 		return -1;
 
@@ -367,12 +368,13 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 	return 0;
 }
 
-static void brcmf_netdev_set_multicast_list(struct net_device *dev)
+static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	int ifidx;
 
-	ifidx = brcmf_net2idx(drvr_priv, dev);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 	if (ifidx == BRCMF_BAD_IF)
 		return;
 
@@ -405,10 +407,11 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 	return brcmf_sdbrcm_bus_txdata(drvr->bus, pktbuf);
 }
 
-static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
+static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int ret;
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	int ifidx;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -417,14 +420,14 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == BRCMF_BUS_DOWN)) {
 		brcmf_dbg(ERROR, "xmit rejected pub.up=%d busstate=%d\n",
 			  drvr_priv->pub.up, drvr_priv->pub.busstate);
-		netif_stop_queue(net);
+		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
 
-	ifidx = brcmf_net2idx(drvr_priv, net);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 	if (ifidx == BRCMF_BAD_IF) {
 		brcmf_dbg(ERROR, "bad ifidx %d\n", ifidx);
-		netif_stop_queue(net);
+		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
 
@@ -460,17 +463,17 @@ done:
 
 void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 {
-	struct net_device *net;
+	struct net_device *ndev;
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	drvr->txoff = state;
-	net = drvr_priv->iflist[ifidx]->net;
+	ndev = drvr_priv->iflist[ifidx]->ndev;
 	if (state == ON)
-		netif_stop_queue(net);
+		netif_stop_queue(ndev);
 	else
-		netif_wake_queue(net);
+		netif_wake_queue(ndev);
 }
 
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
@@ -483,8 +486,8 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
 	if (bcmerror != 0)
 		return bcmerror;
 
-	if (drvr_priv->iflist[*ifidx]->net)
-		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->net,
+	if (drvr_priv->iflist[*ifidx]->ndev)
+		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->ndev,
 				     event, *data);
 
 	return bcmerror;
@@ -530,7 +533,7 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		if (ifp == NULL)
 			ifp = drvr_priv->iflist[0];
 
-		skb->dev = ifp->net;
+		skb->dev = ifp->ndev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
@@ -552,8 +555,8 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		    !drvr_priv->iflist[ifidx]->state)
 			ifp = drvr_priv->iflist[ifidx];
 
-		if (ifp->net)
-			ifp->net->last_rx = jiffies;
+		if (ifp->ndev)
+			ifp->ndev->last_rx = jiffies;
 
 		drvr->dstats.rx_bytes += skb->len;
 		drvr->rx_packets++;	/* Local count */
@@ -588,15 +591,16 @@ void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 
 }
 
-static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
+static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	struct brcmf_if *ifp;
 	int ifidx;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	ifidx = brcmf_net2idx(drvr_priv, net);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 	if (ifidx == BRCMF_BAD_IF)
 		return NULL;
 
@@ -698,10 +702,11 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	return 0;
 }
 
-static void brcmf_ethtool_get_drvinfo(struct net_device *net,
+static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 				    struct ethtool_drvinfo *info)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
@@ -809,10 +814,10 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 		/* If setting TX checksum mode, tell Linux the new mode */
 		if (cmd == ETHTOOL_STXCSUM) {
 			if (edata.data)
-				drvr_priv->iflist[0]->net->features |=
+				drvr_priv->iflist[0]->ndev->features |=
 				    NETIF_F_IP_CSUM;
 			else
-				drvr_priv->iflist[0]->net->features &=
+				drvr_priv->iflist[0]->ndev->features &=
 				    ~NETIF_F_IP_CSUM;
 		}
 
@@ -825,13 +830,14 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void __user *uaddr)
 	return 0;
 }
 
-static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
+static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 				    int cmd)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	int ifidx;
 
-	ifidx = brcmf_net2idx(drvr_priv, net);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifidx, cmd);
 
 	if (ifidx == BRCMF_BAD_IF)
@@ -844,15 +850,16 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 }
 
 /* called only from within this driver */
-int brcmf_netdev_ioctl_priv(struct net_device *net, struct brcmf_ioctl *ioc)
+int brcmf_netdev_ioctl_priv(struct net_device *ndev, struct brcmf_ioctl *ioc)
 {
 	int bcmerror = 0;
 	int buflen = 0;
 	bool is_set_key_cmd;
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+			  netdev_priv(ndev);
 	int ifidx;
 
-	ifidx = brcmf_net2idx(drvr_priv, net);
+	ifidx = brcmf_net2idx(drvr_priv, ndev);
 
 	if (ioc->buf != NULL)
 		buflen = min_t(uint, ioc->len, BRCMF_IOCTL_MAXLEN);
@@ -879,7 +886,7 @@ int brcmf_netdev_ioctl_priv(struct net_device *net, struct brcmf_ioctl *ioc)
 			  ((ioc->cmd == BRCMF_C_SET_VAR) &&
 			   !(strncmp("bsscfg:wsec_key", ioc->buf, 15))));
 	if (is_set_key_cmd)
-		brcmf_netdev_wait_pend8021x(net);
+		brcmf_netdev_wait_pend8021x(ndev);
 
 	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, ioc, buflen);
 
@@ -890,9 +897,9 @@ done:
 	return bcmerror;
 }
 
-static int brcmf_netdev_stop(struct net_device *net)
+static int brcmf_netdev_stop(struct net_device *ndev)
 {
-	struct brcmf_pub *drvr = *(struct brcmf_pub **) netdev_priv(net);
+	struct brcmf_pub *drvr = *(struct brcmf_pub **) netdev_priv(ndev);
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down(drvr->config);
@@ -901,16 +908,17 @@ static int brcmf_netdev_stop(struct net_device *net)
 
 	/* Set state and stop OS transmissions */
 	drvr->up = 0;
-	netif_stop_queue(net);
+	netif_stop_queue(ndev);
 
 	return 0;
 }
 
-static int brcmf_netdev_open(struct net_device *net)
+static int brcmf_netdev_open(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
+					netdev_priv(ndev);
 	u32 toe_ol;
-	int ifidx = brcmf_net2idx(drvr_priv, net);
+	int ifidx = brcmf_net2idx(drvr_priv, ndev);
 	s32 ret = 0;
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
@@ -925,19 +933,19 @@ static int brcmf_netdev_open(struct net_device *net)
 		}
 		atomic_set(&drvr_priv->pend_8021x_cnt, 0);
 
-		memcpy(net->dev_addr, drvr_priv->pub.mac, ETH_ALEN);
+		memcpy(ndev->dev_addr, drvr_priv->pub.mac, ETH_ALEN);
 
 		/* Get current TOE mode from dongle */
 		if (brcmf_toe_get(drvr_priv, ifidx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			drvr_priv->iflist[ifidx]->net->features |=
+			drvr_priv->iflist[ifidx]->ndev->features |=
 				NETIF_F_IP_CSUM;
 		else
-			drvr_priv->iflist[ifidx]->net->features &=
+			drvr_priv->iflist[ifidx]->ndev->features &=
 				~NETIF_F_IP_CSUM;
 	}
 	/* Allow transmit calls */
-	netif_start_queue(net);
+	netif_start_queue(ndev);
 	drvr_priv->pub.up = 1;
 	if (brcmf_cfg80211_up(drvr_priv->pub.config)) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
@@ -948,12 +956,12 @@ static int brcmf_netdev_open(struct net_device *net)
 }
 
 int
-brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
+brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 	     char *name, u8 *mac_addr, u32 flags, u8 bssidx)
 {
 	struct brcmf_if *ifp;
 
-	brcmf_dbg(TRACE, "idx %d, handle->%p\n", ifidx, net);
+	brcmf_dbg(TRACE, "idx %d, handle->%p\n", ifidx, ndev);
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
@@ -969,12 +977,12 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	if (net == NULL) {
+	if (ndev == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
 		brcmf_op_if(ifp);
 	} else
-		ifp->net = net;
+		ifp->ndev = ndev;
 
 	return 0;
 }
@@ -999,13 +1007,13 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 {
 	struct brcmf_info *drvr_priv = NULL;
-	struct net_device *net;
+	struct net_device *ndev;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Allocate netdev, including space for private structure */
-	net = alloc_netdev(sizeof(drvr_priv), "wlan%d", ether_setup);
-	if (!net) {
+	ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d", ether_setup);
+	if (!ndev) {
 		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
 		goto fail;
 	}
@@ -1018,13 +1026,13 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	/*
 	 * Save the brcmf_info into the priv
 	 */
-	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
+	memcpy(netdev_priv(ndev), &drvr_priv, sizeof(drvr_priv));
 
-	if (brcmf_add_if(drvr_priv, 0, net, net->name, NULL, 0, 0) ==
+	if (brcmf_add_if(drvr_priv, 0, ndev, ndev->name, NULL, 0, 0) ==
 	    BRCMF_BAD_IF)
 		goto fail;
 
-	net->netdev_ops = NULL;
+	ndev->netdev_ops = NULL;
 	mutex_init(&drvr_priv->proto_block);
 
 	/* Link to info module */
@@ -1042,7 +1050,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	/* Attach and link in the cfg80211 */
 	drvr_priv->pub.config =
-			brcmf_cfg80211_attach(net,
+			brcmf_cfg80211_attach(ndev,
 					      brcmf_bus_get_device(bus),
 					      &drvr_priv->pub);
 	if (drvr_priv->pub.config == NULL) {
@@ -1056,13 +1064,13 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	/*
 	 * Save the brcmf_info into the priv
 	 */
-	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
+	memcpy(netdev_priv(ndev), &drvr_priv, sizeof(drvr_priv));
 
 	return &drvr_priv->pub;
 
 fail:
-	if (net)
-		free_netdev(net);
+	if (ndev)
+		free_netdev(ndev);
 	if (drvr_priv)
 		brcmf_detach(&drvr_priv->pub);
 
@@ -1143,14 +1151,14 @@ static struct net_device_ops brcmf_netdev_ops_pri = {
 int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
-	struct net_device *net;
+	struct net_device *ndev;
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
 
-	net = drvr_priv->iflist[ifidx]->net;
-	net->netdev_ops = &brcmf_netdev_ops_pri;
+	ndev = drvr_priv->iflist[ifidx]->ndev;
+	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
 	/*
 	 * We have to use the primary MAC for virtual interfaces
@@ -1168,25 +1176,25 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 			 - Locally Administered address  */
 
 	}
-	net->hard_header_len = ETH_HLEN + drvr_priv->pub.hdrlen;
-	net->ethtool_ops = &brcmf_ethtool_ops;
+	ndev->hard_header_len = ETH_HLEN + drvr_priv->pub.hdrlen;
+	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
-	drvr_priv->pub.rxsz = net->mtu + net->hard_header_len +
-				drvr_priv->pub.hdrlen;
+	drvr_priv->pub.rxsz = ndev->mtu + ndev->hard_header_len +
+			      drvr_priv->pub.hdrlen;
 
-	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
+	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
 
-	if (register_netdev(net) != 0) {
+	if (register_netdev(ndev) != 0) {
 		brcmf_dbg(ERROR, "couldn't register the net device\n");
 		goto fail;
 	}
 
-	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", net->name);
+	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
 
 	return 0;
 
 fail:
-	net->netdev_ops = NULL;
+	ndev->netdev_ops = NULL;
 	return -EBADE;
 }
 
@@ -1225,9 +1233,9 @@ void brcmf_detach(struct brcmf_pub *drvr)
 					brcmf_del_if(drvr_priv, i);
 
 			ifp = drvr_priv->iflist[0];
-			if (ifp->net->netdev_ops == &brcmf_netdev_ops_pri) {
-				brcmf_netdev_stop(ifp->net);
-				unregister_netdev(ifp->net);
+			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+				brcmf_netdev_stop(ifp->ndev);
+				unregister_netdev(ifp->ndev);
 			}
 
 			cancel_work_sync(&drvr_priv->setmacaddr_work);
@@ -1240,7 +1248,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 
 			brcmf_cfg80211_detach(drvr->config);
 
-			free_netdev(ifp->net);
+			free_netdev(ifp->ndev);
 			kfree(ifp);
 			kfree(drvr_priv);
 		}
@@ -1305,9 +1313,9 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 
 #define MAX_WAIT_FOR_8021X_TX	10
 
-int brcmf_netdev_wait_pend8021x(struct net_device *dev)
+int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(ndev);
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
 	int pend = brcmf_get_pend_8021x_cnt(drvr_priv);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 45c9e78..b707bc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -267,12 +267,12 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 
 /* function for reading/writing a single u32 from/to the dongle */
 static int
-brcmf_dev_ioctl_u32(struct net_device *dev, u32 cmd, u32 *par)
+brcmf_dev_ioctl_u32(struct net_device *ndev, u32 cmd, u32 *par)
 {
 	int err;
 	__le32 par_le = cpu_to_le32(*par);
 
-	err = brcmf_dev_ioctl(dev, cmd, &par_le, sizeof(__le32));
+	err = brcmf_dev_ioctl(ndev, cmd, &par_le, sizeof(__le32));
 	*par = le32_to_cpu(par_le);
 
 	return err;
@@ -292,14 +292,14 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 	memcpy(key_le->ea, key->ea, sizeof(key->ea));
 }
 
-static int send_key_to_dongle(struct net_device *dev,
+static int send_key_to_dongle(struct net_device *ndev,
 			      struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
 	convert_key_from_CPU(key, &key_le);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key_le, sizeof(key_le));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_KEY, &key_le, sizeof(key_le));
 	if (err)
 		WL_ERR("WLC_SET_KEY error (%d)\n", err);
 	return err;
@@ -356,7 +356,7 @@ done:
 	return err;
 }
 
-static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
+static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
 {
 	s8 buf[BRCMF_C_IOCTL_SMLEN];
 	u32 len;
@@ -368,7 +368,7 @@ static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 			    sizeof(buf));
 	BUG_ON(!len);
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, buf, len);
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -376,7 +376,7 @@ static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 }
 
 static s32
-brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
+brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
 {
 	union {
 		s8 buf[BRCMF_C_IOCTL_SMLEN];
@@ -390,7 +390,7 @@ brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, &var, len);
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -430,7 +430,7 @@ static void wl_iscan_prep(struct brcmf_scan_params_le *params_le,
 }
 
 static s32
-brcmf_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
+brcmf_dev_iovar_setbuf(struct net_device *ndev, s8 * iovar, void *param,
 		    s32 paramlen, void *bufptr, s32 buflen)
 {
 	s32 iolen;
@@ -438,11 +438,11 @@ brcmf_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, bufptr, iolen);
+	return brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, bufptr, iolen);
 }
 
 static s32
-brcmf_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
+brcmf_dev_iovar_getbuf(struct net_device *ndev, s8 * iovar, void *param,
 		    s32 paramlen, void *bufptr, s32 buflen)
 {
 	s32 iolen;
@@ -450,7 +450,7 @@ brcmf_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, bufptr, buflen);
+	return brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, bufptr, buflen);
 }
 
 static s32
@@ -475,8 +475,8 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
-	err = brcmf_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
-				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
+	err = brcmf_dev_iovar_setbuf(iscan->ndev, "iscan", params, params_size,
+				     iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
@@ -634,34 +634,34 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
-static s32 brcmf_set_rts(struct net_device *dev, u32 rts_threshold)
+static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_dev_intvar_set(dev, "rtsthresh", rts_threshold);
+	err = brcmf_dev_intvar_set(ndev, "rtsthresh", rts_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
 }
 
-static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold)
+static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_dev_intvar_set(dev, "fragthresh", frag_threshold);
+	err = brcmf_dev_intvar_set(ndev, "fragthresh", frag_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
 }
 
-static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
+static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 {
 	s32 err = 0;
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
-	err = brcmf_dev_ioctl_u32(dev, cmd, &retry);
+	err = brcmf_dev_ioctl_u32(ndev, cmd, &retry);
 	if (err) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -802,15 +802,15 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 
 static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct net_device *dev = NULL;
+	struct net_device *ndev = NULL;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
 	if (cfg_priv->link_up) {
-		dev = cfg_to_ndev(cfg_priv);
+		ndev = cfg_to_ndev(cfg_priv);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		cfg_priv->link_up = false;
@@ -819,7 +819,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 }
 
 static s32
-brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -884,7 +884,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	if (params->privacy)
 		wsec |= WEP_ENABLED;
 
-	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(ndev, "wsec", wsec);
 	if (err) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
@@ -896,7 +896,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_dev_ioctl_u32(dev, BRCM_SET_BCNPRD, &bcnprd);
+	err = brcmf_dev_ioctl_u32(ndev, BRCM_SET_BCNPRD, &bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -940,7 +940,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 		/* set channel for starter */
 		target_channel = cfg_priv->channel;
-		err = brcmf_dev_ioctl_u32(dev, BRCM_SET_CHANNEL,
+		err = brcmf_dev_ioctl_u32(ndev, BRCM_SET_CHANNEL,
 					  &target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -952,7 +952,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	cfg_priv->ibss_starter = false;
 
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -967,7 +967,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	s32 err = 0;
@@ -983,10 +983,10 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return err;
 }
 
-static s32 brcmf_set_wpa_version(struct net_device *dev,
+static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -998,7 +998,7 @@ static s32 brcmf_set_wpa_version(struct net_device *dev,
 	else
 		val = WPA_AUTH_DISABLED;
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
-	err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
+	err = brcmf_dev_intvar_set(ndev, "wpa_auth", val);
 	if (err) {
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
@@ -1008,10 +1008,10 @@ static s32 brcmf_set_wpa_version(struct net_device *dev,
 	return err;
 }
 
-static s32
-brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
+static s32 brcmf_set_auth_type(struct net_device *ndev,
+			       struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1037,7 +1037,7 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 		break;
 	}
 
-	err = brcmf_dev_intvar_set(dev, "auth", val);
+	err = brcmf_dev_intvar_set(ndev, "auth", val);
 	if (err) {
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
@@ -1048,10 +1048,10 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 }
 
 static s32
-brcmf_set_set_cipher(struct net_device *dev,
+brcmf_set_set_cipher(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1101,7 +1101,7 @@ brcmf_set_set_cipher(struct net_device *dev,
 	}
 
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
-	err = brcmf_dev_intvar_set(dev, "wsec", pval | gval);
+	err = brcmf_dev_intvar_set(ndev, "wsec", pval | gval);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -1115,15 +1115,15 @@ brcmf_set_set_cipher(struct net_device *dev,
 }
 
 static s32
-brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
 
 	if (sme->crypto.n_akm_suites) {
-		err = brcmf_dev_intvar_get(dev, "wpa_auth", &val);
+		err = brcmf_dev_intvar_get(ndev, "wpa_auth", &val);
 		if (err) {
 			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
@@ -1157,7 +1157,7 @@ brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 		}
 
 		WL_CONN("setting wpa_auth to %d\n", val);
-		err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
+		err = brcmf_dev_intvar_set(ndev, "wpa_auth", val);
 		if (err) {
 			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
@@ -1170,10 +1170,10 @@ brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 }
 
 static s32
-brcmf_set_set_sharedkey(struct net_device *dev,
+brcmf_set_set_sharedkey(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1214,14 +1214,14 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 			WL_CONN("key length (%d) key index (%d) algo (%d)\n",
 			       key.len, key.index, key.algo);
 			WL_CONN("key \"%s\"\n", key.data);
-			err = send_key_to_dongle(dev, &key);
+			err = send_key_to_dongle(ndev, &key);
 			if (err)
 				return err;
 
 			if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
 				WL_CONN("set auth_type to shared key\n");
 				val = 1;	/* shared key */
-				err = brcmf_dev_intvar_set(dev, "auth", val);
+				err = brcmf_dev_intvar_set(ndev, "auth", val);
 				if (err) {
 					WL_ERR("set auth failed (%d)\n", err);
 					return err;
@@ -1233,7 +1233,7 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 }
 
 static s32
-brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -1265,31 +1265,31 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
-	err = brcmf_set_wpa_version(dev, sme);
+	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
 		WL_ERR("wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
-	err = brcmf_set_auth_type(dev, sme);
+	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
 		WL_ERR("wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
-	err = brcmf_set_set_cipher(dev, sme);
+	err = brcmf_set_set_cipher(ndev, sme);
 	if (err) {
 		WL_ERR("wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
-	err = brcmf_set_key_mgmt(dev, sme);
+	err = brcmf_set_key_mgmt(ndev, sme);
 	if (err) {
 		WL_ERR("wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
-	err = brcmf_set_set_sharedkey(dev, sme);
+	err = brcmf_set_set_sharedkey(ndev, sme);
 	if (err) {
 		WL_ERR("wl_set_set_sharedkey failed (%d)\n", err);
 		goto done;
@@ -1312,7 +1312,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	brcmf_ch_to_chanspec(cfg_priv->channel,
 			     &join_params, &join_params_size);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1325,7 +1325,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -1340,7 +1340,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 
 	memcpy(&scbval.ea, brcmf_read_prof(cfg_priv, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_DISASSOC, &scbval,
 			      sizeof(struct brcmf_scb_val_le));
 	if (err)
 		WL_ERR("error (%d)\n", err);
@@ -1432,7 +1432,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
 	u32 index;
@@ -1444,7 +1444,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1453,7 +1453,8 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
 		index = key_idx;
-		err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_KEY_PRIMARY, &index);
+		err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_KEY_PRIMARY,
+					  &index);
 		if (err)
 			WL_ERR("error (%d)\n", err);
 	}
@@ -1463,7 +1464,7 @@ done:
 }
 
 static s32
-brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
+brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
 	struct brcmf_wsec_key key;
@@ -1480,7 +1481,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		err = send_key_to_dongle(dev, &key);
+		err = send_key_to_dongle(ndev, &key);
 		if (err)
 			return err;
 	} else {
@@ -1537,8 +1538,8 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		}
 		convert_key_from_CPU(&key, &key_le);
 
-		brcmf_netdev_wait_pend8021x(dev);
-		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key_le,
+		brcmf_netdev_wait_pend8021x(ndev);
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_KEY, &key_le,
 				      sizeof(key_le));
 		if (err) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -1549,7 +1550,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static s32
-brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
@@ -1566,7 +1567,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	if (mac_addr) {
 		WL_TRACE("Exit");
-		return brcmf_add_keyext(wiphy, dev, key_idx, mac_addr, params);
+		return brcmf_add_keyext(wiphy, ndev, key_idx, mac_addr, params);
 	}
 	memset(&key, 0, sizeof(key));
 
@@ -1611,26 +1612,26 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	err = send_key_to_dongle(dev, &key); /* Set the new key/index */
+	err = send_key_to_dongle(ndev, &key); /* Set the new key/index */
 	if (err)
 		goto done;
 
 	val = WEP_ENABLED;
-	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
+	err = brcmf_dev_intvar_get(ndev, "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
-	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(ndev, "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
 	}
 
 	val = 1;		/* assume shared key. otherwise 0 */
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_AUTH, &val);
 	if (err)
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
@@ -1639,7 +1640,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct brcmf_wsec_key key;
@@ -1660,7 +1661,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	WL_CONN("key index (%d)\n", key_idx);
 
 	/* Set the new key/index */
-	err = send_key_to_dongle(dev, &key);
+	err = send_key_to_dongle(ndev, &key);
 	if (err) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
@@ -1673,7 +1674,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	val = 0;
-	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
+	err = brcmf_dev_intvar_get(ndev, "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1682,7 +1683,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
-	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(ndev, "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1691,7 +1692,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	val = 0;		/* assume open key. otherwise 1 */
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_AUTH, &val);
 	if (err) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1703,7 +1704,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr, void *cookie,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
@@ -1720,7 +1721,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	memset(&params, 0, sizeof(params));
 
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1760,7 +1761,7 @@ done:
 
 static s32
 brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
-				    struct net_device *dev, u8 key_idx)
+				    struct net_device *ndev, u8 key_idx)
 {
 	WL_INFO("Not supported\n");
 
@@ -1768,7 +1769,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 }
 
 static s32
-brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -1793,7 +1794,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Report the current tx rate */
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_RATE, &rate);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_RATE, &rate);
 	if (err) {
 		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
@@ -1804,7 +1805,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
 		scb_val.val = cpu_to_le32(0);
-		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_RSSI, &scb_val,
 				      sizeof(struct brcmf_scb_val_le));
 		if (err)
 			WL_ERR("Could not get rssi (%d)\n", err);
@@ -1821,7 +1822,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 			   bool enabled, s32 timeout)
 {
 	s32 pm;
@@ -1848,7 +1849,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	pm = enabled ? PM_FAST : PM_OFF;
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_PM, &pm);
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_PM, &pm);
 	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -1861,7 +1862,7 @@ done:
 }
 
 static s32
-brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 			     const u8 *addr,
 			     const struct cfg80211_bitrate_mask *mask)
 {
@@ -1879,7 +1880,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_dev_ioctl(dev, BRCM_GET_CURR_RATESET, &rateset_le,
+	err = brcmf_dev_ioctl(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
 			      sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -1907,8 +1908,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	 *      Set rate override,
 	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
 	 */
-	err_bg = brcmf_dev_intvar_set(dev, "bg_rate", rate);
-	err_a = brcmf_dev_intvar_set(dev, "a_rate", rate);
+	err_bg = brcmf_dev_intvar_set(ndev, "bg_rate", rate);
+	err_a = brcmf_dev_intvar_set(ndev, "a_rate", rate);
 	if (err_bg && err_a) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
@@ -2004,7 +2005,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 }
 
 static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
-			  struct net_device *dev, const u8 *bssid)
+			  struct net_device *ndev, const u8 *bssid)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
@@ -2031,7 +2032,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
 	if (err) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2214,9 +2215,9 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 
 	memset(&list, 0, sizeof(list));
 	list.results_le.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
-	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
-				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
-				WL_ISCAN_BUF_MAX);
+	err = brcmf_dev_iovar_getbuf(iscan->ndev, "iscanresults", &list,
+				     BRCMF_ISCAN_RESULTS_FIXED_SIZE,
+				     iscan->scan_buf, WL_ISCAN_BUF_MAX);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -2352,7 +2353,7 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	int err = 0;
 
 	if (cfg_priv->iscan_on) {
-		iscan->dev = cfg_to_ndev(cfg_priv);
+		iscan->ndev = cfg_to_ndev(cfg_priv);
 		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
 		init_timer(&iscan->timer);
@@ -2454,32 +2455,32 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 }
 
 static __used s32
-brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
+brcmf_dev_bufvar_set(struct net_device *ndev, s8 *name, s8 *buf, s32 len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	u32 buflen;
 
 	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
 			       WL_IOCTL_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
+	return brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
 			       buflen);
 }
 
 static s32
-brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
+brcmf_dev_bufvar_get(struct net_device *ndev, s8 *name, s8 *buf,
 		  s32 buf_len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	u32 len;
 	s32 err = 0;
 
 	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->ioctl_buf,
 			    WL_IOCTL_LEN_MAX);
 	BUG_ON(!len);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)cfg_priv->ioctl_buf,
-			WL_IOCTL_LEN_MAX);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, cfg_priv->ioctl_buf,
+			      WL_IOCTL_LEN_MAX);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -2490,7 +2491,7 @@ brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 }
 
 static __used s32
-brcmf_update_pmklist(struct net_device *dev,
+brcmf_update_pmklist(struct net_device *ndev,
 		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
 {
 	int i, j;
@@ -2504,14 +2505,14 @@ brcmf_update_pmklist(struct net_device *dev,
 	}
 
 	if (!err)
-		brcmf_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
+		brcmf_dev_bufvar_set(ndev, "pmkid_info", (char *)pmk_list,
 					sizeof(*pmk_list));
 
 	return err;
 }
 
 static s32
-brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -2539,14 +2540,14 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
 		WL_CONN("%02x\n", pmkids->pmkid[pmkids->npmkid].PMKID[i]);
 
-	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
+	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
 }
 
 static s32
-brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -2588,7 +2589,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	} else
 		err = -EINVAL;
 
-	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
+	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2596,7 +2597,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static s32
-brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
+brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	s32 err = 0;
@@ -2606,7 +2607,7 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 		return -EIO;
 
 	memset(cfg_priv->pmk_list, 0, sizeof(*cfg_priv->pmk_list));
-	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
+	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2655,7 +2656,7 @@ static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
 }
 
 static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
-					  struct device *dev)
+					  struct device *ndev)
 {
 	struct wireless_dev *wdev;
 	s32 err = 0;
@@ -2672,7 +2673,7 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 		err = -ENOMEM;
 		goto wiphy_new_out;
 	}
-	set_wiphy_dev(wdev->wiphy, dev);
+	set_wiphy_dev(wdev->wiphy, ndev);
 	wdev->wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
 	wdev->wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
 	wdev->wiphy->interface_modes =
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 14a32e1..afc60d9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -243,7 +243,7 @@ struct brcmf_cfg80211_iscan_eloop {
 
 /* dongle iscan controller */
 struct brcmf_cfg80211_iscan_ctrl {
-	struct net_device *dev;
+	struct net_device *ndev;
 	struct timer_list timer;
 	u32 timer_ms;
 	u32 timer_on;
-- 
1.7.1


