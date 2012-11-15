Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3412 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab2KOCqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:38 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/19] brcmfmac: fix for multiple netdevice interface
 support
Date: Wed, 14 Nov 2012 18:46:09 -0800
Message-ID: <1352947583-25341-6-git-send-email-frankyl@broadcom.com> (sfid-20121115_041526_669413_D5F22580)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

virtual netdevice interface like P2P client and GO need
different callbacks for .open and .down. This patch adds
those.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  101 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   25 ++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +-
 4 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a41e1c6..499c5c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -513,8 +513,6 @@ struct brcmf_pub {
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
 
-	struct work_struct setmacaddr_work;
-	struct work_struct multicast_work;
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
 	wait_queue_head_t pend_8021x_wait;
@@ -556,6 +554,8 @@ struct brcmf_if {
 	struct brcmf_cfg80211_vif *vif;
 	struct net_device *ndev;
 	struct net_device_stats stats;
+	struct work_struct setmacaddr_work;
+	struct work_struct multicast_work;
 	int idx;
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f102034..32b7355 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -105,12 +105,10 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	char *buf, *bufp;
 	u32 buflen;
 	s32 err;
-	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
-						    multicast_work);
 
 	brcmf_dbg(TRACE, "enter\n");
 
-	ifp = drvr->iflist[0];
+	ifp = container_of(work, struct brcmf_if, multicast_work);
 	ndev = ifp->ndev;
 
 	/* Determine initial value of allmulti flag */
@@ -165,45 +163,37 @@ static void
 _brcmf_set_mac_address(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
-	struct net_device *ndev;
 	s32 err;
 
-	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
-						    setmacaddr_work);
-
 	brcmf_dbg(TRACE, "enter\n");
 
-	ifp = drvr->iflist[0];
-	ndev = ifp->ndev;
-
-	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", drvr->macvalue,
+	ifp = container_of(work, struct brcmf_if, setmacaddr_work);
+	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ifp->mac_addr,
 				       ETH_ALEN);
 	if (err < 0) {
 		brcmf_dbg(ERROR, "Setting cur_etheraddr failed, %d\n", err);
 	} else {
 		brcmf_dbg(TRACE, "MAC address updated to %pM\n",
-			  drvr->macvalue);
-		memcpy(ndev->dev_addr, drvr->macvalue, ETH_ALEN);
+			  ifp->mac_addr);
+		memcpy(ifp->ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 	}
 }
 
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
 	struct sockaddr *sa = (struct sockaddr *)addr;
 
-	memcpy(&drvr->macvalue, sa->sa_data, ETH_ALEN);
-	schedule_work(&drvr->setmacaddr_work);
+	memcpy(&ifp->mac_addr, sa->sa_data, ETH_ALEN);
+	schedule_work(&ifp->setmacaddr_work);
 	return 0;
 }
 
 static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
 
-	schedule_work(&drvr->multicast_work);
+	schedule_work(&ifp->multicast_work);
 }
 
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
@@ -582,7 +572,7 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 	if (drvr->bus_if->drvr_up == 0)
 		return 0;
 
-	brcmf_cfg80211_down(drvr->config);
+	brcmf_cfg80211_down(ndev);
 
 	/* Set state and stop OS transmissions */
 	drvr->bus_if->drvr_up = false;
@@ -601,26 +591,24 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
-	if (ifp->idx == 0) {	/* do it only for primary eth0 */
-		/* If bus is not ready, can't continue */
-		if (bus_if->state != BRCMF_BUS_DATA) {
-			brcmf_dbg(ERROR, "failed bus is not ready\n");
-			return -EAGAIN;
-		}
+	/* If bus is not ready, can't continue */
+	if (bus_if->state != BRCMF_BUS_DATA) {
+		brcmf_dbg(ERROR, "failed bus is not ready\n");
+		return -EAGAIN;
+	}
 
-		atomic_set(&drvr->pend_8021x_cnt, 0);
+	atomic_set(&drvr->pend_8021x_cnt, 0);
 
-		memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
+	memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
 
-		/* Get current TOE mode from dongle */
-		if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
-		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			drvr->iflist[ifp->idx]->ndev->features |=
-				NETIF_F_IP_CSUM;
-		else
-			drvr->iflist[ifp->idx]->ndev->features &=
-				~NETIF_F_IP_CSUM;
-	}
+	/* Get current TOE mode from dongle */
+	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
+	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
+		drvr->iflist[ifp->idx]->ndev->features |=
+			NETIF_F_IP_CSUM;
+	else
+		drvr->iflist[ifp->idx]->ndev->features &=
+			~NETIF_F_IP_CSUM;
 
 	/* make sure RF is ready for work */
 	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
@@ -628,7 +616,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
 	drvr->bus_if->drvr_up = true;
-	if (brcmf_cfg80211_up(drvr->config)) {
+	if (brcmf_cfg80211_up(ndev)) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
 	}
@@ -646,16 +634,30 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
+static const struct net_device_ops brcmf_netdev_ops_virt = {
+	.ndo_open = brcmf_cfg80211_up,
+	.ndo_stop = brcmf_cfg80211_down,
+	.ndo_get_stats = brcmf_netdev_get_stats,
+	.ndo_do_ioctl = brcmf_netdev_ioctl_entry,
+	.ndo_start_xmit = brcmf_netdev_start_xmit,
+	.ndo_set_mac_address = brcmf_netdev_set_mac_address,
+	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
+};
+
 int brcmf_net_attach(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
 	u8 temp_addr[ETH_ALEN];
 
-	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
+	brcmf_dbg(TRACE, "ifidx %d mac %pM\n", ifp->idx, ifp->mac_addr);
+	ndev = ifp->ndev;
 
-	ndev = drvr->iflist[ifp->idx]->ndev;
-	ndev->netdev_ops = &brcmf_netdev_ops_pri;
+	/* set appropriate operations */
+	if (!ifp->idx)
+		ndev->netdev_ops = &brcmf_netdev_ops_pri;
+	else
+		ndev->netdev_ops = &brcmf_netdev_ops_virt;
 
 	/*
 	 * determine mac address to use
@@ -665,13 +667,6 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	else
 		memcpy(temp_addr, drvr->mac, ETH_ALEN);
 
-	if (ifp->idx == 1) {
-		brcmf_dbg(TRACE, "ACCESS POINT MAC:\n");
-		/*  ACCESSPOINT INTERFACE CASE */
-		temp_addr[0] |= 0X02;	/* set bit 2 ,
-			 - Locally Administered address  */
-
-	}
 	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
@@ -729,6 +724,10 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	drvr->iflist[ifidx] = ifp;
 	ifp->idx = ifidx;
 	ifp->bssidx = bssidx;
+
+	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
+	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
+
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
@@ -760,6 +759,9 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 			netif_stop_queue(ifp->ndev);
 		}
 
+		cancel_work_sync(&ifp->setmacaddr_work);
+		cancel_work_sync(&ifp->multicast_work);
+
 		unregister_netdev(ifp->ndev);
 		drvr->iflist[ifidx] = NULL;
 		if (ifidx == 0)
@@ -801,9 +803,6 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	/* attach firmware event handler */
 	brcmf_fweh_attach(drvr);
 
-	INIT_WORK(&drvr->setmacaddr_work, _brcmf_set_mac_address);
-	INIT_WORK(&drvr->multicast_work, _brcmf_set_multicast_list);
-
 	INIT_LIST_HEAD(&drvr->bus_if->dcmd_list);
 
 	init_waitqueue_head(&drvr->pend_8021x_wait);
@@ -904,8 +903,6 @@ void brcmf_detach(struct device *dev)
 	brcmf_bus_detach(drvr);
 
 	if (drvr->prot) {
-		cancel_work_sync(&drvr->setmacaddr_work);
-		cancel_work_sync(&drvr->multicast_work);
 		brcmf_proto_detach(drvr);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b836722..be45893 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4524,19 +4524,18 @@ default_conf_out:
 
 }
 
-static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
+static s32 __brcmf_cfg80211_up(struct brcmf_if *ifp)
 {
-	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-
 	set_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
+	if (ifp->idx)
+		return 0;
 
-	return brcmf_config_dongle(cfg);
+	return brcmf_config_dongle(ifp->drvr->config);
 }
 
-static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
+static s32 __brcmf_cfg80211_down(struct brcmf_if *ifp)
 {
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 
 	/*
 	 * While going down, if associated with AP disassociate
@@ -4561,23 +4560,27 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 	return 0;
 }
 
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
+s32 brcmf_cfg80211_up(struct net_device *ndev)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 err = 0;
 
 	mutex_lock(&cfg->usr_sync);
-	err = __brcmf_cfg80211_up(cfg);
+	err = __brcmf_cfg80211_up(ifp);
 	mutex_unlock(&cfg->usr_sync);
 
 	return err;
 }
 
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
+s32 brcmf_cfg80211_down(struct net_device *ndev)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 err = 0;
 
 	mutex_lock(&cfg->usr_sync);
-	err = __brcmf_cfg80211_down(cfg);
+	err = __brcmf_cfg80211_down(ifp);
 	mutex_unlock(&cfg->usr_sync);
 
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 80ba2ea..e2ef851 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -455,7 +455,7 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg);
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg);
+s32 brcmf_cfg80211_up(struct net_device *ndev);
+s32 brcmf_cfg80211_down(struct net_device *ndev);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.9.5


