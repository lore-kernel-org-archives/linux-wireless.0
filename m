Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1138 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946238Ab3BHLGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 06:06:51 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: use brcmf_if::bssidx as index in
 interface list
Date: Fri, 8 Feb 2013 12:06:31 +0100
Message-ID: <1360321595-31722-2-git-send-email-arend@broadcom.com> (sfid-20130208_120838_903602_79D18B8F)
In-Reply-To: <1360321595-31722-1-git-send-email-arend@broadcom.com>
References: <1360321595-31722-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Upon receiving an IF event from the firmware the interface
was created and stored on a list using the interface index.
With upcoming P2P feature the firmware will send a IF event
in which two interfaces have the same interface index. To
uniquely locate them on the list the bss index is now used.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   10 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    8 +++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   72 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    9 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    5 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +
 6 files changed, 57 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index e17f68a..7c78131 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -512,7 +512,7 @@ struct brcmf_cfg80211_vif;
  * @vif: points to cfg80211 specific interface information.
  * @ndev: associated network device.
  * @stats: interface specific network statistics.
- * @idx: interface index in device firmware.
+ * @ifidx: interface index in device firmware.
  * @bssidx: index of bss associated with this interface.
  * @mac_addr: assigned mac address.
  * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
@@ -525,7 +525,7 @@ struct brcmf_if {
 	struct net_device_stats stats;
 	struct work_struct setmacaddr_work;
 	struct work_struct multicast_work;
-	int idx;
+	int ifidx;
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
@@ -549,9 +549,9 @@ extern int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 			       struct sk_buff *rxp);
 
 extern int brcmf_net_attach(struct brcmf_if *ifp);
-extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
-				     s32 bssidx, char *name, u8 *mac_addr);
-extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
+extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx,
+				     s32 ifidx, char *name, u8 *mac_addr);
+extern void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
 extern u32 brcmf_get_chip_info(struct brcmf_if *ifp);
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index bb454cd..a2354d9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -303,6 +303,14 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 		brcmf_err("rx data ifnum out of range (%d)\n", *ifidx);
 		return -EBADE;
 	}
+	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
+	 * events this is easy because it contains the bssidx which maps
+	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
+	 * bssidx 1 is used for p2p0 and no data can be received or
+	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
+	 */
+	if (*ifidx)
+		(*ifidx)++;
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6202ad2..db03d30 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -72,7 +72,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	ifp = container_of(work, struct brcmf_if, multicast_work);
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	ndev = ifp->ndev;
 
@@ -132,7 +132,7 @@ _brcmf_set_mac_address(struct work_struct *work)
 
 	ifp = container_of(work, struct brcmf_if, setmacaddr_work);
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ifp->mac_addr,
 				       ETH_ALEN);
@@ -170,7 +170,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
@@ -181,8 +181,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (!drvr->iflist[ifp->idx]) {
-		brcmf_err("bad ifidx %d\n", ifp->idx);
+	if (!drvr->iflist[ifp->bssidx]) {
+		brcmf_err("bad ifidx %d\n", ifp->bssidx);
 		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
 		ret = -ENODEV;
@@ -194,14 +194,14 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		struct sk_buff *skb2;
 
 		brcmf_dbg(INFO, "%s: insufficient headroom\n",
-			  brcmf_ifname(drvr, ifp->idx));
+			  brcmf_ifname(drvr, ifp->bssidx));
 		drvr->bus_if->tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr->hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			brcmf_err("%s: skb_realloc_headroom failed\n",
-				  brcmf_ifname(drvr, ifp->idx));
+				  brcmf_ifname(drvr, ifp->bssidx));
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -222,7 +222,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		atomic_inc(&ifp->pend_8021x_cnt);
 
 	/* If the protocol uses a data header, apply it */
-	brcmf_proto_hdrpush(drvr, ifp->idx, skb);
+	brcmf_proto_hdrpush(drvr, ifp->ifidx, skb);
 
 	/* Use bus module to send data frame */
 	ret =  brcmf_bus_txdata(drvr->bus_if, skb);
@@ -372,7 +372,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	return &ifp->stats;
 }
@@ -424,7 +424,7 @@ static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 	u32 toe_cmpnt, csum_dir;
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* all ethtool calls start with a cmd word */
 	if (copy_from_user(&cmd, uaddr, sizeof(u32)))
@@ -521,9 +521,9 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 
-	brcmf_dbg(TRACE, "Enter, bssidx=%d, cmd=0x%04x\n", ifp->idx, cmd);
+	brcmf_dbg(TRACE, "Enter, idx=%d, cmd=0x%04x\n", ifp->bssidx, cmd);
 
-	if (!drvr->iflist[ifp->idx])
+	if (!drvr->iflist[ifp->bssidx])
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
@@ -536,7 +536,7 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	brcmf_cfg80211_down(ndev);
 
@@ -554,7 +554,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	u32 toe_ol;
 	s32 ret = 0;
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->idx);
+	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_DATA) {
@@ -606,12 +606,12 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
 
-	brcmf_dbg(TRACE, "Enter, idx=%d mac=%pM\n", ifp->idx,
+	brcmf_dbg(TRACE, "Enter, idx=%d mac=%pM\n", ifp->bssidx,
 		  ifp->mac_addr);
 	ndev = ifp->ndev;
 
 	/* set appropriate operations */
-	if (!ifp->idx)
+	if (!ifp->bssidx)
 		ndev->netdev_ops = &brcmf_netdev_ops_pri;
 	else
 		ndev->netdev_ops = &brcmf_netdev_ops_virt;
@@ -639,16 +639,15 @@ fail:
 	return -EBADE;
 }
 
-struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
-			      char *name, u8 *addr_mask)
+struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
+			      char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
-	int i;
 
-	brcmf_dbg(TRACE, "Enter, bssidx=%d, ifidx=%d\n", bssidx, ifidx);
+	brcmf_dbg(TRACE, "Enter, idx=%d, ifidx=%d\n", bssidx, ifidx);
 
-	ifp = drvr->iflist[ifidx];
+	ifp = drvr->iflist[bssidx];
 	/*
 	 * Delete the existing interface before overwriting it
 	 * in case we missed the BRCMF_E_IF_DEL event.
@@ -656,11 +655,11 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	if (ifp) {
 		brcmf_err("ERROR: netdev:%s already exists\n",
 			  ifp->ndev->name);
-		if (ifidx) {
+		if (bssidx) {
 			netif_stop_queue(ifp->ndev);
 			unregister_netdev(ifp->ndev);
 			free_netdev(ifp->ndev);
-			drvr->iflist[ifidx] = NULL;
+			drvr->iflist[bssidx] = NULL;
 		} else {
 			brcmf_err("ignore IF event\n");
 			return ERR_PTR(-EINVAL);
@@ -677,8 +676,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	ifp = netdev_priv(ndev);
 	ifp->ndev = ndev;
 	ifp->drvr = drvr;
-	drvr->iflist[ifidx] = ifp;
-	ifp->idx = ifidx;
+	drvr->iflist[bssidx] = ifp;
+	ifp->ifidx = ifidx;
 	ifp->bssidx = bssidx;
 
 	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
@@ -686,9 +685,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 
 	init_waitqueue_head(&ifp->pend_8021x_wait);
 
-	if (addr_mask != NULL)
-		for (i = 0; i < ETH_ALEN; i++)
-			ifp->mac_addr[i] = drvr->mac[i] ^ addr_mask[i];
+	if (mac_addr != NULL)
+		memcpy(ifp->mac_addr, mac_addr, ETH_ALEN);
 
 	brcmf_dbg(TRACE, " ==== pid:%x, if:%s (%pM) created ===\n",
 		  current->pid, ifp->ndev->name, ifp->mac_addr);
@@ -696,18 +694,18 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	return ifp;
 }
 
-void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
+void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 {
 	struct brcmf_if *ifp;
 
-	ifp = drvr->iflist[ifidx];
+	ifp = drvr->iflist[bssidx];
 	if (!ifp) {
-		brcmf_err("Null interface, idx=%d\n", ifidx);
+		brcmf_err("Null interface, idx=%d\n", bssidx);
 		return;
 	}
-	brcmf_dbg(TRACE, "Enter, idx=%d, bssidx=%d\n", ifidx, ifp->bssidx);
+	brcmf_dbg(TRACE, "Enter, idx=%d, ifidx=%d\n", bssidx, ifp->ifidx);
 	if (ifp->ndev) {
-		if (ifidx == 0) {
+		if (bssidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
 				rtnl_lock();
 				brcmf_netdev_stop(ifp->ndev);
@@ -721,8 +719,8 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 		cancel_work_sync(&ifp->multicast_work);
 
 		unregister_netdev(ifp->ndev);
-		drvr->iflist[ifidx] = NULL;
-		if (ifidx == 0)
+		drvr->iflist[bssidx] = NULL;
+		if (bssidx == 0)
 			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(ifp->ndev);
 	}
@@ -815,7 +813,7 @@ fail:
 		brcmf_err("failed: %d\n", ret);
 		if (drvr->config)
 			brcmf_cfg80211_detach(drvr->config);
-		free_netdev(drvr->iflist[0]->ndev);
+		free_netdev(ifp->ndev);
 		drvr->iflist[0] = NULL;
 		return ret;
 	}
@@ -849,7 +847,7 @@ void brcmf_dev_reset(struct device *dev)
 
 void brcmf_detach(struct device *dev)
 {
-	int i;
+	s32 i;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index ba0b225..1fd29b0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -189,12 +189,12 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		return;
 	}
 
-	ifp = drvr->iflist[ifevent->ifidx];
+	ifp = drvr->iflist[ifevent->bssidx];
 
 	if (ifevent->action == BRCMF_E_IF_ADD) {
 		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
 			  emsg->addr);
-		ifp = brcmf_add_if(drvr, ifevent->ifidx, ifevent->bssidx,
+		ifp = brcmf_add_if(drvr, ifevent->bssidx, ifevent->ifidx,
 				   emsg->ifname, emsg->addr);
 		if (IS_ERR(ifp))
 			return;
@@ -206,7 +206,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
 	if (ifevent->action == BRCMF_E_IF_DEL)
-		brcmf_del_if(drvr, ifevent->ifidx);
+		brcmf_del_if(drvr, ifevent->bssidx);
 }
 
 /**
@@ -250,8 +250,6 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 	drvr = container_of(fweh, struct brcmf_pub, fweh);
 
 	while ((event = brcmf_fweh_dequeue_event(fweh))) {
-		ifp = drvr->iflist[event->ifidx];
-
 		brcmf_dbg(EVENT, "event %s (%u) ifidx %u bsscfg %u addr %pM\n",
 			  brcmf_fweh_event_name(event->code), event->code,
 			  event->emsg.ifidx, event->emsg.bsscfgidx,
@@ -283,6 +281,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			goto event_free;
 		}
 
+		ifp = drvr->iflist[emsg.bsscfgidx];
 		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
 						    event->data);
 		if (err) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index f6ffcf6..8d1def9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -45,9 +45,10 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	if (data != NULL)
 		len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
 	if (set)
-		err = brcmf_proto_cdc_set_dcmd(drvr, ifp->idx, cmd, data, len);
+		err = brcmf_proto_cdc_set_dcmd(drvr, ifp->ifidx, cmd, data,
+					       len);
 	else
-		err = brcmf_proto_cdc_query_dcmd(drvr, ifp->idx, cmd, data,
+		err = brcmf_proto_cdc_query_dcmd(drvr, ifp->ifidx, cmd, data,
 						 len);
 
 	if (err >= 0)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d47b274..d78f946 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3546,6 +3546,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	if (err < 0) {
 		brcmf_err("BRCMF_C_UP error (%d)\n", err);
 		goto exit;
+		brcmf_fil_iovar_int_set(ifp, "apsta", 0);
 	}
 
 	memset(&join_params, 0, sizeof(join_params));
@@ -4242,6 +4243,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 cfg80211_attach_out:
 	brcmf_free_vif(vif);
+	wiphy_free(wiphy);
 	return NULL;
 }
 
-- 
1.7.10.4


