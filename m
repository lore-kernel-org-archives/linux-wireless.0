Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3480 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/19] staging: brcm80211: remove _brcmf_sysioc_thread
 in fullmac
Date: Fri, 16 Sep 2011 12:28:02 -0700
Message-ID: <1316201288-29635-14-git-send-email-frankyl@broadcom.com> (sfid-20110916_212845_664619_7DB58CC9)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_brcmf_sysioc_thread is handling deferred jobs from 4 callers. Use
work queue to handle set_mac_address/set_multicast_list requests.
brcmf_add_if/brcmf_del_if never run in atomic context and can call
brcmf_op_if directly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |  159 ++++++------------------
 1 files changed, 39 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ca42883..3b2d500 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -73,11 +73,8 @@ struct brcmf_info {
 
 	struct mutex proto_block;
 
-	/* Thread to issue ioctl for multicast */
-	struct task_struct *sysioc_tsk;
-	wait_queue_head_t sysioc_waitq;
-	bool set_multicast;
-	bool set_macaddress;
+	struct work_struct setmacaddr_work;
+	struct work_struct multicast_work;
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
 };
@@ -85,10 +82,6 @@ struct brcmf_info {
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
-/* Spawn a thread for system ioctls (set mac, set mcast) */
-uint brcmf_sysioc = true;
-module_param(brcmf_sysioc, uint, 0);
-
 /* ARP offload agent mode : Enable ARP Host Auto-Reply
 and ARP Peer Auto-Reply */
 uint brcmf_arp_mode = 0xb;
@@ -152,7 +145,7 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 	return "<if_none>";
 }
 
-static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
+static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct net_device *dev;
 	struct netdev_hw_addr *ha;
@@ -163,7 +156,10 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	uint buflen;
 	int ret;
 
-	dev = drvr_priv->iflist[ifidx]->net;
+	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
+						    multicast_work);
+
+	dev = drvr_priv->iflist[0]->net;
 	cnt = netdev_mc_count(dev);
 
 	/* Determine initial value of allmulti flag */
@@ -175,7 +171,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
 		brcmf_dbg(ERROR, "%s: out of memory for mcast_list, cnt %d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), cnt);
+			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
 		return;
 	}
 
@@ -200,10 +196,10 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), cnt);
+			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -218,7 +214,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
 		brcmf_dbg(ERROR, "%s: out of memory for allmulti\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx));
+			  brcmf_ifname(&drvr_priv->pub, 0));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
@@ -226,7 +222,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  brcmf_ifname(&drvr_priv->pub, 0),
 			  (int)sizeof(allmulti), buflen);
 		kfree(buf);
 		return;
@@ -238,10 +234,10 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  brcmf_ifname(&drvr_priv->pub, 0),
 			  le32_to_cpu(allmulti));
 	}
 
@@ -259,26 +255,30 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = sizeof(allmulti);
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  brcmf_ifname(&drvr_priv->pub, 0),
 			  le32_to_cpu(allmulti));
 	}
 }
 
-static int
-_brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
+static void
+_brcmf_set_mac_address(struct work_struct *work)
 {
 	char buf[32];
 	struct brcmf_ioctl ioc;
 	int ret;
 
+	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
+						    setmacaddr_work);
+
 	brcmf_dbg(TRACE, "enter\n");
-	if (!brcmu_mkiovar("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
+	if (!brcmu_mkiovar("cur_etheraddr", (char *)drvr_priv->macvalue,
+			   ETH_ALEN, buf, 32)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx));
-		return -1;
+			  brcmf_ifname(&drvr_priv->pub, 0));
+		return;
 	}
 	memset(&ioc, 0, sizeof(ioc));
 	ioc.cmd = BRCMF_C_SET_VAR;
@@ -286,14 +286,15 @@ _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 	ioc.len = 32;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
 	if (ret < 0)
 		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx));
+			  brcmf_ifname(&drvr_priv->pub, 0));
 	else
-		memcpy(drvr_priv->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
+		memcpy(drvr_priv->iflist[0]->net->dev_addr,
+		       drvr_priv->macvalue, ETH_ALEN);
 
-	return ret;
+	return;
 }
 
 /* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
@@ -364,76 +365,8 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 	}
 }
 
-static int _brcmf_sysioc_thread(void *data)
-{
-	struct brcmf_info *drvr_priv = (struct brcmf_info *) data;
-	int i;
-#ifdef SOFTAP
-	bool in_ap = false;
-#endif
-	DECLARE_WAITQUEUE(wait, current);
-	allow_signal(SIGTERM);
-
-	add_wait_queue(&drvr_priv->sysioc_waitq, &wait);
-	while (1) {
-		prepare_to_wait(&drvr_priv->sysioc_waitq, &wait,
-				TASK_INTERRUPTIBLE);
-
-		/* wait for event */
-		schedule();
-
-		if (kthread_should_stop())
-			break;
-
-		for (i = 0; i < BRCMF_MAX_IFS; i++) {
-			struct brcmf_if *ifentry = drvr_priv->iflist[i];
-			if (ifentry) {
-#ifdef SOFTAP
-				in_ap = (ap_net_dev != NULL);
-#endif				/* SOFTAP */
-				if (ifentry->state)
-					brcmf_op_if(ifentry);
-#ifdef SOFTAP
-				if (drvr_priv->iflist[i] == NULL) {
-					brcmf_dbg(TRACE, "interface %d removed!\n",
-						  i);
-					continue;
-				}
-
-				if (in_ap && drvr_priv->set_macaddress) {
-					brcmf_dbg(TRACE, "attempt to set MAC for %s in AP Mode, blocked.\n",
-						  ifentry->net->name);
-					drvr_priv->set_macaddress = false;
-					continue;
-				}
-
-				if (in_ap && drvr_priv->set_multicast) {
-					brcmf_dbg(TRACE, "attempt to set MULTICAST list for %s in AP Mode, blocked.\n",
-						  ifentry->net->name);
-					drvr_priv->set_multicast = false;
-					continue;
-				}
-#endif				/* SOFTAP */
-				if (drvr_priv->set_multicast) {
-					drvr_priv->set_multicast = false;
-					_brcmf_set_multicast_list(drvr_priv, i);
-				}
-				if (drvr_priv->set_macaddress) {
-					drvr_priv->set_macaddress = false;
-					_brcmf_set_mac_address(drvr_priv, i,
-						drvr_priv->macvalue);
-				}
-			}
-		}
-	}
-	finish_wait(&drvr_priv->sysioc_waitq, &wait);
-	return 0;
-}
-
 static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 {
-	int ret = 0;
-
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int ifidx;
@@ -443,9 +376,8 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 		return -1;
 
 	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
-	drvr_priv->set_macaddress = true;
-	wake_up(&drvr_priv->sysioc_waitq);
-	return ret;
+	schedule_work(&drvr_priv->setmacaddr_work);
+	return 0;
 }
 
 static void brcmf_netdev_set_multicast_list(struct net_device *dev)
@@ -457,8 +389,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 	if (ifidx == BRCMF_BAD_IF)
 		return;
 
-	drvr_priv->set_multicast = true;
-	wake_up(&drvr_priv->sysioc_waitq);
+	schedule_work(&drvr_priv->multicast_work);
 }
 
 int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
@@ -1056,7 +987,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
 	if (net == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
-		wake_up(&drvr_priv->sysioc_waitq);
+		brcmf_op_if(ifp);
 	} else
 		ifp->net = net;
 
@@ -1077,7 +1008,7 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 
 	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
-	wake_up(&drvr_priv->sysioc_waitq);
+	brcmf_op_if(ifp);
 }
 
 struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
@@ -1148,17 +1079,8 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 		goto fail;
 	}
 
-	if (brcmf_sysioc) {
-		init_waitqueue_head(&drvr_priv->sysioc_waitq);
-		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread,
-						    drvr_priv, "_brcmf_sysioc");
-		if (IS_ERR(drvr_priv->sysioc_tsk)) {
-			printk(KERN_WARNING
-				"_brcmf_sysioc thread failed to start\n");
-			drvr_priv->sysioc_tsk = NULL;
-		}
-	} else
-		drvr_priv->sysioc_tsk = NULL;
+	INIT_WORK(&drvr_priv->setmacaddr_work, _brcmf_set_mac_address);
+	INIT_WORK(&drvr_priv->multicast_work, _brcmf_set_multicast_list);
 
 	/*
 	 * Save the brcmf_info into the priv
@@ -1337,11 +1259,8 @@ void brcmf_detach(struct brcmf_pub *drvr)
 				unregister_netdev(ifp->net);
 			}
 
-			if (drvr_priv->sysioc_tsk) {
-				send_sig(SIGTERM, drvr_priv->sysioc_tsk, 1);
-				kthread_stop(drvr_priv->sysioc_tsk);
-				drvr_priv->sysioc_tsk = NULL;
-			}
+			cancel_work_sync(&drvr_priv->setmacaddr_work);
+			cancel_work_sync(&drvr_priv->multicast_work);
 
 			brcmf_bus_detach(drvr);
 
-- 
1.7.1


