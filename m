Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab1F2XtE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:04 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 090/119] staging: brcm80211: rename structure
 definitions in dhd_linux.c
Date: Wed, 29 Jun 2011 16:47:54 -0700
Message-ID: <1309391303-22741-91-git-send-email-frankyl@broadcom.com> (sfid-20110630_015141_682931_27EAC8F2)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

renamed structures to consitent naming convention and removed the
structure type definitions.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   20 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |  140 +++++++++++-----------
 3 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index d69cee1..196b372 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -524,14 +524,14 @@ struct brcmf_ioctl {
 /* Forward decls for struct dhd_pub (see below) */
 struct dhd_bus;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
-struct dhd_info;	/* device driver info */
+struct brcmf_info;	/* device driver info */
 
 /* Common structure for module and instance linkage */
 typedef struct dhd_pub {
 	/* Linkage ponters */
 	struct dhd_bus *bus;
 	struct brcmf_proto *prot;
-	struct dhd_info *info;
+	struct brcmf_info *info;
 
 	/* Internal dhd items */
 	bool up;		/* Driver up/down (to OS) */
@@ -806,22 +806,22 @@ extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 extern void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec);
 extern int brcmf_timeout_expired(struct brcmf_timeout *tmo);
 
-extern int brcmf_ifname2idx(struct dhd_info *dhd, char *name);
-extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
+extern int brcmf_ifname2idx(struct brcmf_info *dhd, char *name);
+extern int brcmf_c_host_event(struct brcmf_info *dhd, int *idx, void *pktdata,
 			 brcmf_event_msg_t *, void **data_ptr);
 
 extern void brcmf_c_init(void);
 
-extern int brcmf_add_if(struct dhd_info *dhd, int ifidx, void *handle,
+extern int brcmf_add_if(struct brcmf_info *dhd, int ifidx, void *handle,
 		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
-extern void brcmf_del_if(struct dhd_info *dhd, int ifidx);
+extern void brcmf_del_if(struct brcmf_info *dhd, int ifidx);
 
-extern void brcmf_vif_add(struct dhd_info *dhd, int ifidx, char *name);
-extern void brcmf_vif_del(struct dhd_info *dhd, int ifidx);
+extern void brcmf_vif_add(struct brcmf_info *dhd, int ifidx, char *name);
+extern void brcmf_vif_del(struct brcmf_info *dhd, int ifidx);
 
-extern void brcmf_event(struct dhd_info *dhd, char *evpkt, int evlen,
+extern void brcmf_event(struct brcmf_info *dhd, char *evpkt, int evlen,
 			int ifidx);
-extern void brcmf_vif_sendup(struct dhd_info *dhd, int ifidx,
+extern void brcmf_vif_sendup(struct brcmf_info *dhd, int ifidx,
 			     unsigned char *cp, int len);
 
 /* Send packet to dongle via data channel */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index de07526..5c3a5cf 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -755,8 +755,8 @@ static void brcmf_c_show_host_event(brcmf_event_msg_t *event, void *event_data)
 #endif				/* SHOW_EVENTS */
 
 int
-brcmf_c_host_event(struct dhd_info *drvr_priv, int *ifidx, void *pktdata,
-		   brcmf_event_msg_t *event, void **data_ptr)
+brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
+	      brcmf_event_msg_t *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
 	brcmf_event_t *pvt_data = (brcmf_event_t *) pktdata;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 2705ec0..86a6adb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -60,8 +60,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 
 /* Interface control information */
-typedef struct dhd_if {
-	struct dhd_info *info;	/* back pointer to dhd_info */
+struct brcmf_if {
+	struct brcmf_info *info;	/* back pointer to brcmf_info */
 	/* OS/stack specifics */
 	struct net_device *net;
 	struct net_device_stats stats;
@@ -72,14 +72,14 @@ typedef struct dhd_if {
 	bool attached;		/* Delayed attachment when unset */
 	bool txflowcontrol;	/* Per interface flow control indicator */
 	char name[IFNAMSIZ];	/* linux interface name */
-} dhd_if_t;
+};
 
 /* Local private structure (extension of pub) */
-typedef struct dhd_info {
+struct brcmf_info {
 	dhd_pub_t pub;
 
 	/* OS/stack specifics */
-	dhd_if_t *iflist[BRCMF_MAX_IFS];
+	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct semaphore proto_sem;
 	wait_queue_head_t ioctl_resp_wait;
@@ -95,7 +95,7 @@ typedef struct dhd_info {
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	struct early_suspend early_suspend;
 #endif				/* CONFIG_HAS_EARLYSUSPEND */
-} dhd_info_t;
+};
 
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
@@ -182,9 +182,9 @@ module_param(brcmf_pktgen_len, uint, 0);
 #define DHD_COMPILED
 #endif
 
-static int brcmf_toe_get(dhd_info_t *drvr_priv, int idx, u32 *toe_ol);
-static int brcmf_toe_set(dhd_info_t *drvr_priv, int idx, u32 toe_ol);
-static int brcmf_host_event(dhd_info_t *drvr_priv, int *ifidx, void *pktdata,
+static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
+static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
+static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
 static void brcmf_set_packet_filter(int value, dhd_pub_t *drvr)
@@ -271,7 +271,7 @@ static int brcmf_set_suspend(int value, dhd_pub_t *drvr)
 	return 0;
 }
 
-static void brcmf_suspend_resume_helper(struct dhd_info *drvr_priv, int val)
+static void brcmf_suspend_resume_helper(struct brcmf_info *drvr_priv, int val)
 {
 	dhd_pub_t *drvr = &drvr_priv->pub;
 
@@ -285,8 +285,8 @@ static void brcmf_suspend_resume_helper(struct dhd_info *drvr_priv, int val)
 
 static void brcmf_early_suspend(struct early_suspend *h)
 {
-	struct dhd_info *drvr_priv =
-			container_of(h, struct dhd_info, early_suspend);
+	struct brcmf_info *drvr_priv =
+			container_of(h, struct brcmf_info, early_suspend);
 
 	DHD_TRACE(("%s: enter\n", __func__));
 
@@ -297,8 +297,8 @@ static void brcmf_early_suspend(struct early_suspend *h)
 
 static void brcmf_late_resume(struct early_suspend *h)
 {
-	struct dhd_info *drvr_priv =
-			container_of(h, struct dhd_info, early_suspend);
+	struct brcmf_info *drvr_priv =
+			container_of(h, struct brcmf_info, early_suspend);
 
 	DHD_TRACE(("%s: enter\n", __func__));
 
@@ -365,7 +365,7 @@ int brcmf_timeout_expired(struct brcmf_timeout *tmo)
 	return 0;
 }
 
-static int brcmf_net2idx(dhd_info_t *drvr_priv, struct net_device *net)
+static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
 {
 	int i = 0;
 
@@ -379,7 +379,7 @@ static int brcmf_net2idx(dhd_info_t *drvr_priv, struct net_device *net)
 	return BRCMF_BAD_IF;
 }
 
-int brcmf_ifname2idx(dhd_info_t *drvr_priv, char *name)
+int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 {
 	int i = BRCMF_MAX_IFS;
 
@@ -400,7 +400,7 @@ int brcmf_ifname2idx(dhd_info_t *drvr_priv, char *name)
 
 char *brcmf_ifname(dhd_pub_t *drvr, int ifidx)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	ASSERT(drvr_priv);
 
@@ -420,7 +420,7 @@ char *brcmf_ifname(dhd_pub_t *drvr, int ifidx)
 	return "<if_none>";
 }
 
-static void _brcmf_set_multicast_list(dhd_info_t *drvr_priv, int ifidx)
+static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 {
 	struct net_device *dev;
 	struct netdev_hw_addr *ha;
@@ -536,7 +536,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *drvr_priv, int ifidx)
 	}
 }
 
-static int _brcmf_set_mac_address(dhd_info_t *drvr_priv, int ifidx, u8 *addr)
+static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 {
 	char buf[32];
 	struct brcmf_ioctl ioc;
@@ -570,9 +570,9 @@ static int _brcmf_set_mac_address(dhd_info_t *drvr_priv, int ifidx, u8 *addr)
 extern struct net_device *ap_net_dev;
 #endif
 
-static void brcmf_op_if(dhd_if_t *ifp)
+static void brcmf_op_if(struct brcmf_if *ifp)
 {
-	dhd_info_t *drvr_priv;
+	struct brcmf_info *drvr_priv;
 	int ret = 0, err = 0;
 
 	ASSERT(ifp && ifp->info && ifp->idx);	/* Virtual interfaces only */
@@ -662,7 +662,7 @@ static void brcmf_op_if(dhd_if_t *ifp)
 
 static int _brcmf_sysioc_thread(void *data)
 {
-	dhd_info_t *drvr_priv = (dhd_info_t *) data;
+	struct brcmf_info *drvr_priv = (struct brcmf_info *) data;
 	int i;
 #ifdef SOFTAP
 	bool in_ap = false;
@@ -723,7 +723,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
 
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int ifidx;
 
@@ -741,7 +741,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 
 static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
 	int ifidx;
 
 	ifidx = brcmf_net2idx(drvr_priv, dev);
@@ -755,7 +755,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 
 int brcmf_sendpkt(dhd_pub_t *drvr, int ifidx, struct sk_buff *pktbuf)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	/* Reject if down */
 	if (!drvr->up || (drvr->busstate == DHD_BUS_DOWN))
@@ -782,7 +782,7 @@ int brcmf_sendpkt(dhd_pub_t *drvr, int ifidx, struct sk_buff *pktbuf)
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	int ret;
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	int ifidx;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -835,7 +835,7 @@ done:
 void brcmf_txflowcontrol(dhd_pub_t *drvr, int ifidx, bool state)
 {
 	struct net_device *net;
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -851,13 +851,13 @@ void brcmf_txflowcontrol(dhd_pub_t *drvr, int ifidx, bool state)
 void brcmf_rx_frame(dhd_pub_t *drvr, int ifidx, struct sk_buff *skb,
 		  int numpkt)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 	unsigned char *eth;
 	uint len;
 	void *data;
 	struct sk_buff *pnext, *save_pktbuf;
 	int i;
-	dhd_if_t *ifp;
+	struct brcmf_if *ifp;
 	brcmf_event_msg_t event;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -932,7 +932,7 @@ void brcmf_rx_frame(dhd_pub_t *drvr, int ifidx, struct sk_buff *skb,
 	}
 }
 
-void brcmf_event(struct dhd_info *drvr_priv, char *evpkt, int evlen, int ifidx)
+void brcmf_event(struct brcmf_info *drvr_priv, char *evpkt, int evlen, int ifidx)
 {
 	/* Linux version has nothing to do */
 	return;
@@ -941,7 +941,7 @@ void brcmf_event(struct dhd_info *drvr_priv, char *evpkt, int evlen, int ifidx)
 void brcmf_txcomplete(dhd_pub_t *drvr, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 	struct ethhdr *eh;
 	u16 type;
 
@@ -957,8 +957,8 @@ void brcmf_txcomplete(dhd_pub_t *drvr, struct sk_buff *txp, bool success)
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
-	dhd_if_t *ifp;
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_if *ifp;
 	int ifidx;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -991,7 +991,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
-static int brcmf_toe_get(dhd_info_t *drvr_priv, int ifidx, u32 *toe_ol)
+static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 {
 	struct brcmf_ioctl ioc;
 	char buf[32];
@@ -1025,7 +1025,7 @@ static int brcmf_toe_get(dhd_info_t *drvr_priv, int ifidx, u32 *toe_ol)
 
 /* Set current toe component enables in toe_ol iovar,
 	 and set toe global enable iovar */
-static int brcmf_toe_set(dhd_info_t *drvr_priv, int ifidx, u32 toe_ol)
+static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 {
 	struct brcmf_ioctl ioc;
 	char buf[32];
@@ -1070,7 +1070,7 @@ static int brcmf_toe_set(dhd_info_t *drvr_priv, int ifidx, u32 toe_ol)
 static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 				    struct ethtool_drvinfo *info)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
@@ -1082,7 +1082,7 @@ struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
-static int brcmf_ethtool(dhd_info_t *drvr_priv, void *uaddr)
+static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 {
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
@@ -1196,7 +1196,7 @@ static int brcmf_ethtool(dhd_info_t *drvr_priv, void *uaddr)
 static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 				    int cmd)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	struct brcmf_c_ioctl ioc;
 	int bcmerror = 0;
 	int buflen = 0;
@@ -1312,7 +1312,7 @@ done:
 static int brcmf_netdev_stop(struct net_device *net)
 {
 #if !defined(IGNORE_ETH0_DOWN)
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 	wl_cfg80211_down();
@@ -1332,7 +1332,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 
 static int brcmf_netdev_open(struct net_device *net)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	u32 toe_ol;
 	int ifidx = brcmf_net2idx(drvr_priv, net);
 	s32 ret = 0;
@@ -1371,10 +1371,10 @@ static int brcmf_netdev_open(struct net_device *net)
 }
 
 int
-brcmf_add_if(dhd_info_t *drvr_priv, int ifidx, void *handle, char *name,
+brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	   u8 *mac_addr, u32 flags, u8 bssidx)
 {
-	dhd_if_t *ifp;
+	struct brcmf_if *ifp;
 
 	DHD_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
 
@@ -1382,14 +1382,14 @@ brcmf_add_if(dhd_info_t *drvr_priv, int ifidx, void *handle, char *name,
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
-		ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC);
+		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
 		if (!ifp) {
-			DHD_ERROR(("%s: OOM - dhd_if_t\n", __func__));
+			DHD_ERROR(("%s: OOM - struct dhd_if\n", __func__));
 			return -ENOMEM;
 		}
 	}
 
-	memset(ifp, 0, sizeof(dhd_if_t));
+	memset(ifp, 0, sizeof(struct brcmf_if));
 	ifp->info = drvr_priv;
 	drvr_priv->iflist[ifidx] = ifp;
 	strlcpy(ifp->name, name, IFNAMSIZ);
@@ -1407,9 +1407,9 @@ brcmf_add_if(dhd_info_t *drvr_priv, int ifidx, void *handle, char *name,
 	return 0;
 }
 
-void brcmf_del_if(dhd_info_t *drvr_priv, int ifidx)
+void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 {
-	dhd_if_t *ifp;
+	struct brcmf_if *ifp;
 
 	DHD_TRACE(("%s: idx %d\n", __func__, ifidx));
 
@@ -1428,7 +1428,7 @@ void brcmf_del_if(dhd_info_t *drvr_priv, int ifidx)
 
 dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 {
-	dhd_info_t *drvr_priv = NULL;
+	struct brcmf_info *drvr_priv = NULL;
 	struct net_device *net;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -1440,15 +1440,15 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		goto fail;
 	}
 
-	/* Allocate primary dhd_info */
-	drvr_priv = kzalloc(sizeof(dhd_info_t), GFP_ATOMIC);
+	/* Allocate primary brcmf_info */
+	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
 	if (!drvr_priv) {
 		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
 		goto fail;
 	}
 
 	/*
-	 * Save the dhd_info into the priv
+	 * Save the brcmf_info into the priv
 	 */
 	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
@@ -1505,7 +1505,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		drvr_priv->sysioc_tsk = NULL;
 
 	/*
-	 * Save the dhd_info into the priv
+	 * Save the brcmf_info into the priv
 	 */
 	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
@@ -1538,7 +1538,7 @@ fail:
 int brcmf_bus_start(dhd_pub_t *drvr)
 {
 	int ret = -1;
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 	/* Room for "event_msgs" + '\0' + bitvec */
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 
@@ -1635,7 +1635,7 @@ static struct net_device_ops brcmf_netdev_ops_pri = {
 
 int brcmf_net_attach(dhd_pub_t *drvr, int ifidx)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 	struct net_device *net;
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
@@ -1691,7 +1691,7 @@ fail:
 
 static void brcmf_bus_detach(dhd_pub_t *drvr)
 {
-	dhd_info_t *drvr_priv;
+	struct brcmf_info *drvr_priv;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1709,14 +1709,14 @@ static void brcmf_bus_detach(dhd_pub_t *drvr)
 
 void brcmf_detach(dhd_pub_t *drvr)
 {
-	dhd_info_t *drvr_priv;
+	struct brcmf_info *drvr_priv;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (drvr) {
 		drvr_priv = drvr->info;
 		if (drvr_priv) {
-			dhd_if_t *ifp;
+			struct brcmf_if *ifp;
 			int i;
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
@@ -1790,7 +1790,7 @@ module_exit(brcmf_module_cleanup);
  */
 int brcmf_os_proto_block(dhd_pub_t *drvr)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
 		down(&drvr_priv->proto_sem);
@@ -1801,7 +1801,7 @@ int brcmf_os_proto_block(dhd_pub_t *drvr)
 
 int brcmf_os_proto_unblock(dhd_pub_t *drvr)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
 		up(&drvr_priv->proto_sem);
@@ -1823,7 +1823,7 @@ void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
 
 int brcmf_os_ioctl_resp_wait(dhd_pub_t *drvr, uint *condition, bool *pending)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 	DECLARE_WAITQUEUE(wait, current);
 	int timeout = brcmf_ioctl_timeout_msec;
 
@@ -1848,7 +1848,7 @@ int brcmf_os_ioctl_resp_wait(dhd_pub_t *drvr, uint *condition, bool *pending)
 
 int brcmf_os_ioctl_resp_wake(dhd_pub_t *drvr)
 {
-	dhd_info_t *drvr_priv = drvr->info;
+	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (waitqueue_active(&drvr_priv->ioctl_resp_wait))
 		wake_up_interruptible(&drvr_priv->ioctl_resp_wait);
@@ -1856,7 +1856,7 @@ int brcmf_os_ioctl_resp_wake(dhd_pub_t *drvr)
 	return 0;
 }
 
-static int brcmf_host_event(dhd_info_t *drvr_priv, int *ifidx, void *pktdata,
+static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 			    brcmf_event_msg_t *event, void **data)
 {
 	int bcmerror = 0;
@@ -1877,7 +1877,7 @@ static int brcmf_host_event(dhd_info_t *drvr_priv, int *ifidx, void *pktdata,
 
 int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
 
 	brcmf_bus_devreset(&drvr_priv->pub, flag);
 
@@ -1886,7 +1886,7 @@ int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 
 int brcmf_netdev_set_suspend_disable(struct net_device *dev, int val)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
 	int ret = 0;
 
 	if (drvr_priv) {
@@ -1900,7 +1900,7 @@ int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 {
 	int ret = 0;
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
 
 	if (drvr_priv) {
 		brcmf_os_proto_block(&drvr_priv->pub);
@@ -1913,7 +1913,7 @@ int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 
 int brcmf_netdev_set_dtim_skip(struct net_device *dev, int val)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
 
 	if (drvr_priv)
 		drvr_priv->pub.dtim_skip = val;
@@ -1923,7 +1923,7 @@ int brcmf_netdev_set_dtim_skip(struct net_device *dev, int val)
 
 int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
 	int ret = 0;
 
 	/* Packet filtering is set only if we still in early-suspend and
@@ -1944,12 +1944,12 @@ int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 
 void brcmf_netdev_init_ioctl(struct net_device *dev)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
 
 	brcmf_c_preinit_ioctls(&drvr_priv->pub);
 }
 
-static int brcmf_get_pend_8021x_cnt(dhd_info_t *drvr_priv)
+static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 {
 	return atomic_read(&drvr_priv->pend_8021x_cnt);
 }
@@ -1958,7 +1958,7 @@ static int brcmf_get_pend_8021x_cnt(dhd_info_t *drvr_priv)
 
 int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 {
-	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
+	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
 	int pend = brcmf_get_pend_8021x_cnt(drvr_priv);
-- 
1.7.1


