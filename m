Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4619 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112Ab1F2XtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:01 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 054/119] staging: brcm80211: rename static functions in
 dhd_linux.c
Date: Wed, 29 Jun 2011 16:47:18 -0700
Message-ID: <1309391303-22741-55-git-send-email-frankyl@broadcom.com> (sfid-20110630_015139_739792_DC5766B8)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

functions in dhd_linux.c are renamed according more consistent
naming convention.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |  121 ++++++++++++------------
 1 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index aa31bf0..fb5bef0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -363,17 +363,17 @@ module_param(brcmf_pktgen_len, uint, 0);
 #define DHD_COMPILED
 #endif
 
-static void dhd_dpc(unsigned long data);
+static void brcmf_dpc(unsigned long data);
 
 #ifdef TOE
-static int dhd_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
-static int dhd_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
+static int brcmf_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
+static int brcmf_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
 #endif				/* TOE */
 
-static int dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
+static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
-static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
+static void brcmf_set_packet_filter(int value, dhd_pub_t *dhd)
 {
 #ifdef PKT_FILTER_SUPPORT
 	DHD_TRACE(("%s: %d\n", __func__, value));
@@ -392,7 +392,7 @@ static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 }
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-static int dhd_set_suspend(int value, dhd_pub_t *dhd)
+static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 {
 	int power_mode = PM_MAX;
 	/* wl_pkt_filter_enable_t       enable_parm; */
@@ -418,7 +418,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 
 			/* Enable packet filter, only allow unicast
 				 packet to send up */
-			dhd_set_packet_filter(1, dhd);
+			brcmf_set_packet_filter(1, dhd);
 
 			/* if dtim skip setup as default force it
 			 * to wake each third dtim
@@ -455,7 +455,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 					 sizeof(power_mode));
 
 			/* disable pkt filter */
-			dhd_set_packet_filter(0, dhd);
+			brcmf_set_packet_filter(0, dhd);
 
 			/* restore pre-suspend setting for dtim_skip */
 			brcmu_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
@@ -476,7 +476,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 	return 0;
 }
 
-static void dhd_suspend_resume_helper(struct dhd_info *dhd, int val)
+static void brcmf_suspend_resume_helper(struct dhd_info *dhd, int val)
 {
 	dhd_pub_t *dhdp = &dhd->pub;
 
@@ -484,11 +484,11 @@ static void dhd_suspend_resume_helper(struct dhd_info *dhd, int val)
 	/* Set flag when early suspend was called */
 	dhdp->in_suspend = val;
 	if (!dhdp->suspend_disable_flag)
-		dhd_set_suspend(val, dhdp);
+		brcmf_set_suspend(val, dhdp);
 	brcmf_os_proto_unblock(dhdp);
 }
 
-static void dhd_early_suspend(struct early_suspend *h)
+static void brcmf_early_suspend(struct early_suspend *h)
 {
 	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
 
@@ -499,7 +499,7 @@ static void dhd_early_suspend(struct early_suspend *h)
 
 }
 
-static void dhd_late_resume(struct early_suspend *h)
+static void brcmf_late_resume(struct early_suspend *h)
 {
 	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
 
@@ -568,7 +568,7 @@ int brcmf_timeout_expired(dhd_timeout_t *tmo)
 	return 0;
 }
 
-static int dhd_net2idx(dhd_info_t *dhd, struct net_device *net)
+static int brcmf_net2idx(dhd_info_t *dhd, struct net_device *net)
 {
 	int i = 0;
 
@@ -623,7 +623,7 @@ char *brcmf_ifname(dhd_pub_t *dhdp, int ifidx)
 	return "<if_none>";
 }
 
-static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
+static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 {
 	struct net_device *dev;
 	struct netdev_hw_addr *ha;
@@ -739,8 +739,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	}
 }
 
-static int
-_dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
+static int _brcmf_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 {
 	char buf[32];
 	wl_ioctl_t ioc;
@@ -774,7 +773,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 extern struct net_device *ap_net_dev;
 #endif
 
-static void dhd_op_if(dhd_if_t *ifp)
+static void brcmf_op_if(dhd_if_t *ifp)
 {
 	dhd_info_t *dhd;
 	int ret = 0, err = 0;
@@ -864,7 +863,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 	}
 }
 
-static int _dhd_sysioc_thread(void *data)
+static int _brcmf_sysioc_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
 	int i;
@@ -883,7 +882,7 @@ static int _dhd_sysioc_thread(void *data)
 				in_ap = (ap_net_dev != NULL);
 #endif				/* SOFTAP */
 				if (dhd->iflist[i]->state)
-					dhd_op_if(dhd->iflist[i]);
+					brcmf_op_if(dhd->iflist[i]);
 #ifdef SOFTAP
 				if (dhd->iflist[i] == NULL) {
 					DHD_TRACE(("\n\n %s: interface %d "
@@ -908,11 +907,11 @@ static int _dhd_sysioc_thread(void *data)
 #endif				/* SOFTAP */
 				if (dhd->set_multicast) {
 					dhd->set_multicast = false;
-					_dhd_set_multicast_list(dhd, i);
+					_brcmf_set_multicast_list(dhd, i);
 				}
 				if (dhd->set_macaddress) {
 					dhd->set_macaddress = false;
-					_dhd_set_mac_address(dhd, i,
+					_brcmf_set_mac_address(dhd, i,
 							     dhd->macvalue);
 				}
 			}
@@ -929,7 +928,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int ifidx;
 
-	ifidx = dhd_net2idx(dhd, dev);
+	ifidx = brcmf_net2idx(dhd, dev);
 	if (ifidx == DHD_BAD_IF)
 		return -1;
 
@@ -946,7 +945,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
 	int ifidx;
 
-	ifidx = dhd_net2idx(dhd, dev);
+	ifidx = brcmf_net2idx(dhd, dev);
 	if (ifidx == DHD_BAD_IF)
 		return;
 
@@ -1004,7 +1003,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 		return -ENODEV;
 	}
 
-	ifidx = dhd_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(dhd, net);
 	if (ifidx == DHD_BAD_IF) {
 		DHD_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
 		netif_stop_queue(net);
@@ -1112,7 +1111,7 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 
 		/* Process special event packets and then discard them */
 		if (ntohs(skb->protocol) == ETH_P_BRCM)
-			dhd_wl_host_event(dhd, &ifidx,
+			brcmf_host_event(dhd, &ifidx,
 					  skb_mac_header(skb),
 					  &event, &data);
 
@@ -1171,7 +1170,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	ifidx = dhd_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(dhd, net);
 	if (ifidx == DHD_BAD_IF)
 		return NULL;
 
@@ -1197,7 +1196,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	return &ifp->stats;
 }
 
-static int dhd_watchdog_thread(void *data)
+static int brcmf_watchdog_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
 
@@ -1231,7 +1230,7 @@ static int dhd_watchdog_thread(void *data)
 	return 0;
 }
 
-static void dhd_watchdog(unsigned long data)
+static void brcmf_watchdog(unsigned long data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
 
@@ -1257,7 +1256,7 @@ static void dhd_watchdog(unsigned long data)
 		mod_timer(&dhd->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
 }
 
-static int dhd_dpc_thread(void *data)
+static int brcmf_dpc_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
 
@@ -1295,7 +1294,7 @@ static int dhd_dpc_thread(void *data)
 	return 0;
 }
 
-static void dhd_dpc(unsigned long data)
+static void brcmf_dpc(unsigned long data)
 {
 	dhd_info_t *dhd;
 
@@ -1325,7 +1324,7 @@ void brcmf_sched_dpc(dhd_pub_t *dhdp)
 #ifdef TOE
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
-static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
+static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 {
 	wl_ioctl_t ioc;
 	char buf[32];
@@ -1359,7 +1358,7 @@ static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 
 /* Set current toe component enables in toe_ol iovar,
 	 and set toe global enable iovar */
-static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
+static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 {
 	wl_ioctl_t ioc;
 	char buf[32];
@@ -1475,7 +1474,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		/* Get toe offload components from dongle */
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
-		ret = dhd_toe_get(dhd, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(dhd, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -1496,7 +1495,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 			return -EFAULT;
 
 		/* Read the current settings, update and write back */
-		ret = dhd_toe_get(dhd, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(dhd, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -1508,7 +1507,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		else
 			toe_cmpnt &= ~csum_dir;
 
-		ret = dhd_toe_set(dhd, 0, toe_cmpnt);
+		ret = brcmf_toe_set(dhd, 0, toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -1544,7 +1543,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	int ifidx;
 	bool is_set_key_cmd;
 
-	ifidx = dhd_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(dhd, net);
 	DHD_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
 
 	if (ifidx == DHD_BAD_IF)
@@ -1675,7 +1674,7 @@ static int brcmf_netdev_open(struct net_device *net)
 #ifdef TOE
 	u32 toe_ol;
 #endif
-	int ifidx = dhd_net2idx(dhd, net);
+	int ifidx = brcmf_net2idx(dhd, net);
 	s32 ret = 0;
 
 	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
@@ -1694,7 +1693,7 @@ static int brcmf_netdev_open(struct net_device *net)
 
 #ifdef TOE
 		/* Get current TOE mode from dongle */
-		if (dhd_toe_get(dhd, ifidx, &toe_ol) >= 0
+		if (brcmf_toe_get(dhd, ifidx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
 			dhd->iflist[ifidx]->net->features |= NETIF_F_IP_CSUM;
 		else
@@ -1852,7 +1851,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* Set up the watchdog timer */
 	init_timer(&dhd->timer);
 	dhd->timer.data = (unsigned long) dhd;
-	dhd->timer.function = dhd_watchdog;
+	dhd->timer.function = brcmf_watchdog;
 
 	/* Initialize thread based operation and lock */
 	sema_init(&dhd->sdsem, 1);
@@ -1864,7 +1863,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	if (dhd_dpc_prio >= 0) {
 		/* Initialize watchdog thread */
 		sema_init(&dhd->watchdog_sem, 0);
-		dhd->watchdog_tsk = kthread_run(dhd_watchdog_thread, dhd,
+		dhd->watchdog_tsk = kthread_run(brcmf_watchdog_thread, dhd,
 						"dhd_watchdog");
 		if (IS_ERR(dhd->watchdog_tsk)) {
 			printk(KERN_WARNING
@@ -1879,20 +1878,20 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	if (dhd_dpc_prio >= 0) {
 		/* Initialize DPC thread */
 		sema_init(&dhd->dpc_sem, 0);
-		dhd->dpc_tsk = kthread_run(dhd_dpc_thread, dhd, "dhd_dpc");
+		dhd->dpc_tsk = kthread_run(brcmf_dpc_thread, dhd, "dhd_dpc");
 		if (IS_ERR(dhd->dpc_tsk)) {
 			printk(KERN_WARNING
 				"dhd_dpc thread failed to start\n");
 			dhd->dpc_tsk = NULL;
 		}
 	} else {
-		tasklet_init(&dhd->tasklet, dhd_dpc, (unsigned long) dhd);
+		tasklet_init(&dhd->tasklet, brcmf_dpc, (unsigned long) dhd);
 		dhd->dpc_tsk = NULL;
 	}
 
 	if (dhd_sysioc) {
 		sema_init(&dhd->sysioc_sem, 0);
-		dhd->sysioc_tsk = kthread_run(_dhd_sysioc_thread, dhd,
+		dhd->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, dhd,
 						"_dhd_sysioc");
 		if (IS_ERR(dhd->sysioc_tsk)) {
 			printk(KERN_WARNING
@@ -1917,8 +1916,8 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* Init lock suspend to prevent kernel going to suspend */
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	dhd->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
-	dhd->early_suspend.suspend = dhd_early_suspend;
-	dhd->early_suspend.resume = dhd_late_resume;
+	dhd->early_suspend.suspend = brcmf_early_suspend;
+	dhd->early_suspend.resume = brcmf_late_resume;
 	register_early_suspend(&dhd->early_suspend);
 #endif
 
@@ -2032,9 +2031,8 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 	return 0;
 }
 
-int
-dhd_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf, uint cmd_len,
-	  int set)
+int brcmf_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf,
+	  uint cmd_len, int set)
 {
 	char buf[strlen(name) + 1 + cmd_len];
 	int len = sizeof(buf);
@@ -2122,7 +2120,7 @@ fail:
 	return -EBADE;
 }
 
-void dhd_bus_detach(dhd_pub_t *dhdp)
+static void brcmf_bus_detach(dhd_pub_t *dhdp)
 {
 	dhd_info_t *dhd;
 
@@ -2194,7 +2192,7 @@ void brcmf_detach(dhd_pub_t *dhdp)
 				dhd->sysioc_tsk = NULL;
 			}
 
-			dhd_bus_detach(dhdp);
+			brcmf_bus_detach(dhdp);
 
 			if (dhdp->prot)
 				brcmf_proto_detach(dhdp);
@@ -2209,7 +2207,7 @@ void brcmf_detach(dhd_pub_t *dhdp)
 	}
 }
 
-static void __exit dhd_module_cleanup(void)
+static void __exit brcmf_module_cleanup(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -2221,7 +2219,7 @@ static void __exit dhd_module_cleanup(void)
 	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
 }
 
-static int __init dhd_module_init(void)
+static int __init brcmf_module_init(void)
 {
 	int error;
 
@@ -2278,8 +2276,8 @@ failed:
 	return -EINVAL;
 }
 
-module_init(dhd_module_init);
-module_exit(dhd_module_cleanup);
+module_init(brcmf_module_init);
+module_exit(brcmf_module_cleanup);
 
 /*
  * OS specific functions required to implement DHD driver in OS independent way
@@ -2467,9 +2465,8 @@ void brcmf_os_sdunlock(dhd_pub_t *pub)
 		spin_unlock_bh(&dhd->sdlock);
 }
 
-static int
-dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
-		  brcmf_event_msg_t *event, void **data)
+static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
+			    brcmf_event_msg_t *event, void **data)
 {
 	int bcmerror = 0;
 
@@ -2543,7 +2540,7 @@ int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 
 	if (dhd) {
 		brcmf_os_proto_block(&dhd->pub);
-		ret = dhd_set_suspend(val, &dhd->pub);
+		ret = brcmf_set_suspend(val, &dhd->pub);
 		brcmf_os_proto_unblock(&dhd->pub);
 	}
 #endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
@@ -2574,7 +2571,7 @@ int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 		brcmf_os_proto_block(&dhd->pub);
 		if (dhd->pub.in_suspend) {
 			if (!val || (val && !dhd->pub.suspend_disable_flag))
-				dhd_set_packet_filter(val, &dhd->pub);
+				brcmf_set_packet_filter(val, &dhd->pub);
 		}
 		brcmf_os_proto_unblock(&dhd->pub);
 	}
@@ -2625,7 +2622,7 @@ int brcmf_netdev_get_pno_status(struct net_device *dev)
 
 #endif				/* PNO_SUPPORT */
 
-static int dhd_get_pend_8021x_cnt(dhd_info_t *dhd)
+static int brcmf_get_pend_8021x_cnt(dhd_info_t *dhd)
 {
 	return atomic_read(&dhd->pend_8021x_cnt);
 }
@@ -2637,7 +2634,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
-	int pend = dhd_get_pend_8021x_cnt(dhd);
+	int pend = brcmf_get_pend_8021x_cnt(dhd);
 
 	while (ntimes && pend) {
 		if (pend) {
@@ -2646,7 +2643,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 			set_current_state(TASK_RUNNING);
 			ntimes--;
 		}
-		pend = dhd_get_pend_8021x_cnt(dhd);
+		pend = brcmf_get_pend_8021x_cnt(dhd);
 	}
 	return pend;
 }
-- 
1.7.1


