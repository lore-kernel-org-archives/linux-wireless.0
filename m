Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1405 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/31] staging: brcm80211: removed occurrences of 'dhd'
Date: Wed, 6 Jul 2011 00:02:29 +0200
Message-ID: <1309903378-29021-3-git-send-email-arend@broadcom.com> (sfid-20110706_000356_660291_B1115186)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

DHD is a Broadcom internal term and has been replaced by BRCMF.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   26 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h    |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |    7 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h    |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   45 +++----
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h  |   32 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |  158 +++++++++++------------
 8 files changed, 132 insertions(+), 154 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1540804..229a702 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -18,8 +18,8 @@
  * Common types *
  */
 
-#ifndef _dhd_h_
-#define _dhd_h_
+#ifndef _BRCMF_H_
+#define _BRCMF_H_
 
 #define BRCMF_VERSION_STR		"4.218.248.5"
 
@@ -310,10 +310,10 @@ struct brcmf_event {
 #define BRCMF_E_LINK_BSSCFG_DIS			4
 
 /* The level of bus communication with the dongle */
-enum dhd_bus_state {
-	DHD_BUS_DOWN,		/* Not ready for frame transfers */
-	DHD_BUS_LOAD,		/* Download access only (CPU reset) */
-	DHD_BUS_DATA		/* Ready for frame transfers */
+enum brcmf_bus_state {
+	BRCMF_BUS_DOWN,		/* Not ready for frame transfers */
+	BRCMF_BUS_LOAD,		/* Download access only (CPU reset) */
+	BRCMF_BUS_DATA		/* Ready for frame transfers */
 };
 
 /* Pattern matching filter. Specifies an offset within received packets to
@@ -533,12 +533,12 @@ struct brcmf_pub {
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
 
-	/* Internal dhd items */
+	/* Internal brcmf items */
 	bool up;		/* Driver up/down (to OS) */
 	bool txoff;		/* Transmit flow-controlled */
 	bool dongle_reset;	/* true = DEVRESET put dongle into reset */
-	enum dhd_bus_state busstate;
-	uint hdrlen;		/* Total DHD header length (proto + bus) */
+	enum brcmf_bus_state busstate;
+	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint maxctl;		/* Max size rxctl request from proto to bus */
 	uint rxsz;		/* Rx buffer size bus module should use */
 	u8 wme_dp;		/* wme discard priority */
@@ -564,7 +564,7 @@ struct brcmf_pub {
 	unsigned long rx_dropped;	/* Packets dropped locally (no memory) */
 	unsigned long rx_flushed;	/* Packets flushed due to
 				unscheduled sendup thread */
-	unsigned long wd_dpc_sched;	/* Number of times dhd dpc scheduled by
+	unsigned long wd_dpc_sched;	/* Number of times dpc scheduled by
 					 watchdog timer */
 
 	unsigned long rx_readahead_cnt;	/* Number of packets where header read-ahead
@@ -744,10 +744,6 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
 {
 }
 
-/*
- * Exported from dhd OS modules (dhd_linux/dhd_ndis)
- */
-
 /* Indication from bus module regarding presence/insertion of dongle.
  * Return struct brcmf_pub pointer, used as handle to OS module in later calls.
  * Returned structure should have bus and prot pointers filled in.
@@ -902,4 +898,4 @@ struct brcmf_pktgen {
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 				 when idle */
 
-#endif				/* _dhd_h_ */
+#endif				/* _BRCMF_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index a60aa41..a94152e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _dhd_bus_h_
-#define _dhd_bus_h_
+#ifndef _BRCMF_BUS_H_
+#define _BRCMF_BUS_H_
 
 /* Packet alignment for most efficient SDIO (can change based on platform) */
 #ifndef BRCMF_SDALIGN
@@ -26,7 +26,7 @@
 #endif
 
 /*
- * Exported from dhd bus module (dhd_usb, dhd_sdio)
+ * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
 /* Watchdog timer interval */
@@ -68,4 +68,4 @@ extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
-#endif				/* _dhd_bus_h_ */
+#endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index a1902f2..30c5d2d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -82,7 +82,6 @@ struct brcmf_proto_bdc_header {
 
 #define RETRIES 2	/* # of retries to retrieve matching ioctl response */
 #define BUS_HEADER_LEN	(16+BRCMF_SDALIGN) /* Must be atleast SDPCM_RESERVE
-					 * defined in dhd_sdio.c
 					 * (amount of header tha might be added)
 					 * plus any space that might be needed
 					 * for alignment padding.
@@ -176,8 +175,8 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
-		DHD_ERROR(("dhdcdc_query_ioctl: dhdcdc_msg failed w/status "
-			"%d\n", ret));
+		DHD_ERROR(("brcmf_proto_cdc_query_ioctl: brcmf_proto_cdc_msg "
+			   "failed w/status %d\n", ret));
 		goto done;
 	}
 
@@ -280,7 +279,7 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 	struct brcmf_proto *prot = drvr->prot;
 	int ret = -1;
 
-	if (drvr->busstate == DHD_BUS_DOWN) {
+	if (drvr->busstate == BRCMF_BUS_DOWN) {
 		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
 			   __func__));
 		return ret;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index ec6093e..aead274 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -118,7 +118,7 @@ static int brcmf_c_dump(struct brcmf_pub *drvr, char *buf, int buflen)
 
 	brcmu_binit(strbuf, buf, buflen);
 
-	/* Base DHD info */
+	/* Base info */
 	brcmu_bprintf(strbuf, "%s\n", brcmf_version);
 	brcmu_bprintf(strbuf, "\n");
 	brcmu_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
@@ -672,7 +672,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			if (hdr.version != MSGTRACE_VERSION) {
 				DHD_ERROR(
 				    ("\nMACEVENT: %s [unsupported version --> "
-				     "dhd version:%d dongle version:%d]\n",
+				     "brcmf version:%d dongle version:%d]\n",
 				     event_name, MSGTRACE_VERSION, hdr.version)
 				);
 				/* Reset datalen to avoid display below */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 4733de7..2b1ccca 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _dhd_dbg_
-#define _dhd_dbg_
+#ifndef _BRCMF_DBG_H_
+#define _BRCMF_DBG_H_
 
 #if defined(BCMDBG)
 
@@ -73,4 +73,4 @@
 
 extern int brcmf_msg_level;
 
-#endif				/* _dhd_dbg_ */
+#endif				/* _BRCMF_DBG_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a6dc346..f62a3c0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -50,7 +50,6 @@ u32 g_assert_type;
 #if defined(CONFIG_PM_SLEEP)
 #include <linux/suspend.h>
 atomic_t brcmf_mmc_suspend;
-DECLARE_WAIT_QUEUE_HEAD(dhd_dpc_wait);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 MODULE_AUTHOR("Broadcom Corporation");
@@ -175,13 +174,6 @@ uint brcmf_pktgen_len;
 module_param(brcmf_pktgen_len, uint, 0);
 #endif
 
-/* Version string to report */
-#ifdef BCMDBG
-#define DHD_COMPILED "\nCompiled in " SRCBASE
-#else
-#define DHD_COMPILED
-#endif
-
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
 static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
@@ -274,7 +266,7 @@ static void brcmf_early_suspend(struct early_suspend *h)
 	DHD_TRACE(("%s: enter\n", __func__));
 
 	if (drvr_priv)
-		dhd_suspend_resume_helper(drvr_priv, 1);
+		brcmf_suspend_resume_helper(drvr_priv, 1);
 
 }
 
@@ -286,7 +278,7 @@ static void brcmf_late_resume(struct early_suspend *h)
 	DHD_TRACE(("%s: enter\n", __func__));
 
 	if (drvr_priv)
-		dhd_suspend_resume_helper(drvr_priv, 0);
+		brcmf_suspend_resume_helper(drvr_priv, 0);
 }
 #endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
 
@@ -589,7 +581,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			memcpy(netdev_priv(ifp->net), &drvr_priv, sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
-				DHD_ERROR(("%s: dhd_net_attach failed, "
+				DHD_ERROR(("%s: brcmf_net_attach failed, "
 					"err %d\n",
 					__func__, err));
 				ret = -EOPNOTSUPP;
@@ -741,7 +733,7 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	/* Reject if down */
-	if (!drvr->up || (drvr->busstate == DHD_BUS_DOWN))
+	if (!drvr->up || (drvr->busstate == BRCMF_BUS_DOWN))
 		return -ENODEV;
 
 	/* Update multicast statistic */
@@ -771,7 +763,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Reject if down */
-	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == DHD_BUS_DOWN)) {
+	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == BRCMF_BUS_DOWN)) {
 		DHD_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
 			   __func__, drvr_priv->pub.up, drvr_priv->pub.busstate));
 		netif_stop_queue(net);
@@ -1087,7 +1079,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 		memset(&info, 0, sizeof(info));
 		info.cmd = cmd;
 
-		/* if dhd requested, identify ourselves */
+		/* if requested, identify ourselves */
 		if (strcmp(drvname, "?dhd") == 0) {
 			sprintf(info.driver, "dhd");
 			strcpy(info.version, BRCMF_VERSION_STR);
@@ -1225,7 +1217,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		}
 	}
 
-	/* To differentiate between wl and dhd read 4 more byes */
+	/* To differentiate read 4 more byes */
 	if ((copy_from_user(&driver, (char *)ifr->ifr_data +
 			    sizeof(struct brcmf_ioctl), sizeof(uint)) != 0)) {
 		bcmerror = -EINVAL;
@@ -1237,7 +1229,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		goto done;
 	}
 
-	/* check for local dhd ioctl and handle it */
+	/* check for local brcmf ioctl and handle it */
 	if (driver == BRCMF_IOCTL_MAGIC) {
 		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc, buf, buflen);
 		if (bcmerror)
@@ -1246,7 +1238,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	}
 
 	/* send to dongle (must be up, and wl) */
-	if ((drvr_priv->pub.busstate != DHD_BUS_DATA)) {
+	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
 		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
 		bcmerror = -EIO;
 		goto done;
@@ -1362,7 +1354,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
 		if (!ifp) {
-			DHD_ERROR(("%s: OOM - struct dhd_if\n", __func__));
+			DHD_ERROR(("%s: OOM - struct brcmf_if\n", __func__));
 			return -ENOMEM;
 		}
 	}
@@ -1421,7 +1413,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	/* Allocate primary brcmf_info */
 	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
 	if (!drvr_priv) {
-		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
+		DHD_ERROR(("%s: OOM - alloc brcmf_info\n", __func__));
 		goto fail;
 	}
 
@@ -1460,7 +1452,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	/* Attach and link in the protocol */
 	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
-		DHD_ERROR(("dhd_prot_attach failed\n"));
+		DHD_ERROR(("brcmf_proto_attach failed\n"));
 		goto fail;
 	}
 
@@ -1473,10 +1465,10 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	if (brcmf_sysioc) {
 		sema_init(&drvr_priv->sysioc_sem, 0);
 		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, drvr_priv,
-						"_dhd_sysioc");
+						"_brcmf_sysioc");
 		if (IS_ERR(drvr_priv->sysioc_tsk)) {
 			printk(KERN_WARNING
-				"_dhd_sysioc thread failed to start\n");
+				"_brcmf_sysioc thread failed to start\n");
 			drvr_priv->sysioc_tsk = NULL;
 		}
 	} else
@@ -1493,7 +1485,6 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 #if defined(CONFIG_PM_SLEEP)
 	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/* defined(CONFIG_PM_SLEEP) */
-	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	drvr_priv->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
@@ -1533,7 +1524,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	}
 
 	/* If bus is not ready, can't come up */
-	if (drvr_priv->pub.busstate != DHD_BUS_DATA) {
+	if (drvr_priv->pub.busstate != BRCMF_BUS_DATA) {
 		DHD_ERROR(("%s failed bus is not ready\n", __func__));
 		return -ENODEV;
 	}
@@ -1703,7 +1694,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 
 			brcmf_cfg80211_detach();
 
-			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
 			kfree(ifp);
 			kfree(drvr_priv);
@@ -1727,7 +1717,7 @@ static int __init brcmf_module_init(void)
 	error = brcmf_bus_register();
 
 	if (error) {
-		DHD_ERROR(("%s: dhd_bus_register failed\n", __func__));
+		DHD_ERROR(("%s: brcmf_bus_register failed\n", __func__));
 		goto failed;
 	}
 	return 0;
@@ -1739,9 +1729,6 @@ failed:
 module_init(brcmf_module_init);
 module_exit(brcmf_module_cleanup);
 
-/*
- * OS specific functions required to implement DHD driver in OS independent way
- */
 int brcmf_os_proto_block(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 0a76216..ff788b3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _dhd_proto_h_
-#define _dhd_proto_h_
+#ifndef _BRCMF_PROTO_H_
+#define _BRCMF_PROTO_H_
 
 #ifndef IOCTL_RESP_TIMEOUT
 #define IOCTL_RESP_TIMEOUT  2000	/* In milli second */
@@ -26,22 +26,22 @@
 #endif
 
 /*
- * Exported from the dhd protocol module (dhd_cdc, dhd_rndis)
+ * Exported from the brcmf protocol module (brcmf_cdc)
  */
 
 /* Linkage, sets prot link and updates hdrlen in pub */
-extern int brcmf_proto_attach(struct brcmf_pub *dhdp);
+extern int brcmf_proto_attach(struct brcmf_pub *drvr);
 
-/* Unlink, frees allocated protocol memory (including dhd_prot) */
-extern void brcmf_proto_detach(struct brcmf_pub *dhdp);
+/* Unlink, frees allocated protocol memory (including brcmf_proto) */
+extern void brcmf_proto_detach(struct brcmf_pub *drvr);
 
 /* Initialize protocol: sync w/dongle state.
  * Sets dongle media info (iswl, drv_version, mac address).
  */
-extern int brcmf_proto_init(struct brcmf_pub *dhdp);
+extern int brcmf_proto_init(struct brcmf_pub *drvr);
 
 /* Stop protocol: sync w/dongle state. */
-extern void brcmf_proto_stop(struct brcmf_pub *dhdp);
+extern void brcmf_proto_stop(struct brcmf_pub *drvr);
 
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
@@ -54,22 +54,22 @@ extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
 			       struct sk_buff *rxp);
 
 /* Use protocol to issue ioctl to dongle */
-extern int brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx,
+extern int brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx,
 			     struct brcmf_ioctl *ioc, void *buf, int len);
 
 /* Add prot dump output to a buffer */
-extern void brcmf_proto_dump(struct brcmf_pub *dhdp,
+extern void brcmf_proto_dump(struct brcmf_pub *drvr,
 			     struct brcmu_strbuf *strbuf);
 
 /* Update local copy of dongle statistics */
-extern void brcmf_proto_dstats(struct brcmf_pub *dhdp);
+extern void brcmf_proto_dstats(struct brcmf_pub *drvr);
 
-extern int brcmf_c_ioctl(struct brcmf_pub *dhd_pub, struct brcmf_c_ioctl *ioc,
+extern int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc,
 			 void *buf, uint buflen);
 
-extern int brcmf_c_preinit_ioctls(struct brcmf_pub *dhd);
+extern int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr);
 
-extern int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
-				     void *buf, uint len);
+extern int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx,
+				     uint cmd, void *buf, uint len);
 
-#endif				/* _dhd_proto_h_ */
+#endif				/* _BRCMF_PROTO_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 5e079b0..c5552f1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -167,17 +167,17 @@ struct rte_console {
 #define TXRETRIES	2	/* # of retries for tx frames */
 
 #if defined(CONFIG_MACH_SANDGATE2G)
-#define DHD_RXBOUND	250	/* Default for max rx frames in
+#define BRCMF_RXBOUND	250	/* Default for max rx frames in
 				 one scheduling */
 #else
-#define DHD_RXBOUND	50	/* Default for max rx frames in
+#define BRCMF_RXBOUND	50	/* Default for max rx frames in
 				 one scheduling */
 #endif				/* defined(CONFIG_MACH_SANDGATE2G) */
 
-#define DHD_TXBOUND	20	/* Default for max tx frames in
+#define BRCMF_TXBOUND	20	/* Default for max tx frames in
 				 one scheduling */
 
-#define DHD_TXMINMAX	1	/* Max tx frames if rx still pending */
+#define BRCMF_TXMINMAX	1	/* Max tx frames if rx still pending */
 
 #define MEMBLOCK	2048	/* Block size used for downloading
 				 of dongle image */
@@ -318,7 +318,7 @@ struct rte_console {
 #define MAX_RX_DATASZ	2048
 
 /* Maximum milliseconds to wait for F2 to come up */
-#define DHD_WAIT_F2RDY	3000
+#define BRCMF_WAIT_F2RDY	3000
 
 /* Bump up limit on waiting for HT to account for first startup;
  * if the image is doing a CRC calculation before programming the PMU
@@ -331,7 +331,7 @@ struct rte_console {
 #endif
 
 /* Value for ChipClockCSR during initial setup */
-#define DHD_INIT_CLKCTL1	(SBSDIO_FORCE_HW_CLKREQ_OFF |	\
+#define BRCMF_INIT_CLKCTL1	(SBSDIO_FORCE_HW_CLKREQ_OFF |	\
 					SBSDIO_ALP_AVAIL_REQ)
 
 /* Flags for SDH calls */
@@ -483,7 +483,7 @@ struct sdpcmd_regs {
 
 #ifdef BCMDBG
 /* Device console log buffer state */
-struct dhd_console {
+struct brcmf_console {
 	uint count;		/* Poll interval msec counter */
 	uint log_addr;		/* Log struct address (fixed) */
 	struct rte_log log;	/* Log struct (host copy) */
@@ -580,7 +580,7 @@ struct brcmf_bus {
 	uint pollcnt;		/* Count of active polls */
 
 #ifdef BCMDBG
-	struct dhd_console console;	/* Console output polling support */
+	struct brcmf_console console;	/* Console output polling support */
 	uint console_addr;	/* Console address from shared struct */
 #endif				/* BCMDBG */
 
@@ -592,7 +592,7 @@ struct brcmf_bus {
 	s32 idlecount;	/* Activity timeout counter */
 	s32 idleclock;	/* How to set bus driver when idle */
 	s32 sd_rxchain;
-	bool use_rxchain;	/* If dhd should use PKT chains */
+	bool use_rxchain;	/* If brcmf should use PKT chains */
 	bool sleeping;		/* Is SDIO bus sleeping? */
 	bool rxflow_mode;	/* Rx flow control mode */
 	bool rxflow;		/* Is rx flow control on */
@@ -716,7 +716,7 @@ struct sbconfig {
 #define CLK_PENDING	2	/* Not used yet */
 #define CLK_AVAIL	3
 
-#define DHD_NOPMU(dhd)	(false)
+#define BRCMF_NOPMU(brcmf)	(false)
 
 #ifdef BCMDBG
 static int qcount[NUMPRIO];
@@ -743,12 +743,12 @@ module_param(brcmf_dpc_prio, int, 0);
 /* Console poll interval */
 uint brcmf_console_ms;
 module_param(brcmf_console_ms, uint, 0);
-#endif		/* DHD_DEBUG */
+#endif		/* BCMDBG */
 
 /* Tx/Rx bounds */
 uint brcmf_txbound;
 uint brcmf_rxbound;
-uint dhd_txminmax;
+uint brcmf_txminmax;
 
 /* override the RAM size if possible */
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
@@ -832,7 +832,7 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 	}
 }
 
-#define DHD_BUS			SDIO_BUS
+#define BRCMF_BUS			SDIO_BUS
 
 #define PKT_AVAILABLE()		(intstatus & I_HMB_FRAME_IND)
 
@@ -1223,7 +1223,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		bus->sleeping = false;
 
 		/* Enable interrupts again */
-		if (bus->intr && (bus->drvr->busstate == DHD_BUS_DATA)) {
+		if (bus->intr && (bus->drvr->busstate == BRCMF_BUS_DATA)) {
 			bus->intdis = false;
 			brcmf_sdcard_intr_enable(bus->card);
 		}
@@ -1544,7 +1544,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (drvr->up && (drvr->busstate == DHD_BUS_DATA) &&
+	if (drvr->up && (drvr->busstate == BRCMF_BUS_DATA) &&
 	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
 		brcmf_txflowcontrol(drvr, 0, OFF);
 
@@ -1742,7 +1742,7 @@ int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msgle
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	} else if (pending == true) {
 		DHD_CTL(("%s: cancelled\n", __func__));
 		return -ERESTARTSYS;
@@ -1752,7 +1752,7 @@ int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msgle
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	}
 
 	if (rxlen)
@@ -1802,7 +1802,7 @@ enum {
 	IOV_VARS
 };
 
-const struct brcmu_iovar dhdsdio_iovars[] = {
+const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	{"intr", IOV_INTR, 0, IOVT_BOOL, 0},
 	{"sleep", IOV_SLEEP, 0, IOVT_BOOL, 0},
 	{"pollrate", IOV_POLLRATE, 0, IOVT_UINT32, 0},
@@ -1855,7 +1855,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 };
 
 static void
-dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
+brcmf_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 {
 	uint q1, q2;
 
@@ -1901,43 +1901,43 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 		      (bus->f2rxhdrs + bus->f2rxdata), bus->f2rxhdrs,
 		      bus->f2rxdata, bus->f2txdata, bus->f1regdata);
 	{
-		dhd_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->drvr->rx_packets,
+		brcmf_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->drvr->rx_packets,
 			     (bus->f2rxhdrs + bus->f2rxdata));
-		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->rx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->rx_packets,
 			     bus->f1regdata);
-		dhd_dump_pct(strbuf, ", pkts/sd", bus->drvr->rx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/sd", bus->drvr->rx_packets,
 			     (bus->f2rxhdrs + bus->f2rxdata + bus->f1regdata));
-		dhd_dump_pct(strbuf, ", pkts/int", bus->drvr->rx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/int", bus->drvr->rx_packets,
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n");
 
-		dhd_dump_pct(strbuf, "Rx: glom pct", (100 * bus->rxglompkts),
+		brcmf_dump_pct(strbuf, "Rx: glom pct", (100 * bus->rxglompkts),
 			     bus->drvr->rx_packets);
-		dhd_dump_pct(strbuf, ", pkts/glom", bus->rxglompkts,
+		brcmf_dump_pct(strbuf, ", pkts/glom", bus->rxglompkts,
 			     bus->rxglomframes);
 		brcmu_bprintf(strbuf, "\n");
 
-		dhd_dump_pct(strbuf, "Tx: pkts/f2wr", bus->drvr->tx_packets,
+		brcmf_dump_pct(strbuf, "Tx: pkts/f2wr", bus->drvr->tx_packets,
 			     bus->f2txdata);
-		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->tx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->tx_packets,
 			     bus->f1regdata);
-		dhd_dump_pct(strbuf, ", pkts/sd", bus->drvr->tx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/sd", bus->drvr->tx_packets,
 			     (bus->f2txdata + bus->f1regdata));
-		dhd_dump_pct(strbuf, ", pkts/int", bus->drvr->tx_packets,
+		brcmf_dump_pct(strbuf, ", pkts/int", bus->drvr->tx_packets,
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n");
 
-		dhd_dump_pct(strbuf, "Total: pkts/f2rw",
+		brcmf_dump_pct(strbuf, "Total: pkts/f2rw",
 			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata));
-		dhd_dump_pct(strbuf, ", pkts/f1sd",
+		brcmf_dump_pct(strbuf, ", pkts/f1sd",
 			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     bus->f1regdata);
-		dhd_dump_pct(strbuf, ", pkts/sd",
+		brcmf_dump_pct(strbuf, ", pkts/sd",
 			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata +
 			      bus->f1regdata));
-		dhd_dump_pct(strbuf, ", pkts/int",
+		brcmf_dump_pct(strbuf, ", pkts/int",
 			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n\n");
@@ -2140,7 +2140,7 @@ static int brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *s
 	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		DHD_ERROR(("%s: sdpcm_shared version %d in dhd "
+		DHD_ERROR(("%s: sdpcm_shared version %d in brcmf "
 			   "is different than sdpcm_shared version %d in dongle\n",
 			   __func__, SDPCM_SHARED_VERSION,
 			   sh->flags & SDPCM_SHARED_VERSION_MASK));
@@ -2330,7 +2330,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 
 static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
 {
-	struct dhd_console *c = &bus->console;
+	struct brcmf_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
 	u32 n, idx, addr;
 	int rv;
@@ -2803,12 +2803,12 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 		break;
 
 	case IOV_GVAL(IOV_TXMINMAX):
-		int_val = (s32) dhd_txminmax;
+		int_val = (s32) brcmf_txminmax;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_TXMINMAX):
-		dhd_txminmax = (uint) int_val;
+		brcmf_txminmax = (uint) int_val;
 		break;
 #endif				/* BCMDBG */
 
@@ -3017,7 +3017,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
-		bus->drvr->busstate = DHD_BUS_LOAD;
+		bus->drvr->busstate = BRCMF_BUS_LOAD;
 	}
 fail:
 	return bcmerror;
@@ -3045,7 +3045,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 	ASSERT(!set || (!params && !plen));
 
 	/* Look up var locally; if not found pass to host driver */
-	vi = brcmu_iovar_lookup(dhdsdio_iovars, name);
+	vi = brcmu_iovar_lookup(brcmf_sdio_iovars, name);
 	if (vi == NULL) {
 		brcmf_sdbrcm_sdlock(bus);
 
@@ -3148,7 +3148,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	bus->hostintmask = 0;
 
 	/* Change our idea of bus state */
-	bus->drvr->busstate = DHD_BUS_DOWN;
+	bus->drvr->busstate = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
@@ -3212,7 +3212,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* try to download image and nvram to the dongle */
-	if (drvr->busstate == DHD_BUS_DOWN) {
+	if (drvr->busstate == BRCMF_BUS_DOWN) {
 		if (!(brcmf_sdbrcm_download_firmware(bus, bus->card)))
 			return -1;
 	}
@@ -3257,7 +3257,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 			       NULL);
 
 	/* Give the dongle some time to do its thing and set IOR2 */
-	brcmf_timeout_start(&tmo, DHD_WAIT_F2RDY * 1000);
+	brcmf_timeout_start(&tmo, BRCMF_WAIT_F2RDY * 1000);
 
 	ready = 0;
 	while (ready != enable && !brcmf_timeout_expired(&tmo))
@@ -3278,7 +3278,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 				 (u8) watermark, &err);
 
 		/* Set bus state according to enable result */
-		drvr->busstate = DHD_BUS_DATA;
+		drvr->busstate = BRCMF_BUS_DATA;
 
 		bus->intdis = false;
 		if (bus->intr) {
@@ -3317,7 +3317,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 #endif		/* defined(OOB_INTR_ONLY) */
 
 	/* If we didn't come up, turn off backplane clock */
-	if (drvr->busstate != DHD_BUS_DATA)
+	if (drvr->busstate != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
@@ -3388,7 +3388,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 
 	/* If we can't reach the device, signal failure */
 	if (err || brcmf_sdcard_regfail(card))
-		bus->drvr->busstate = DHD_BUS_DOWN;
+		bus->drvr->busstate = BRCMF_BUS_DOWN;
 }
 
 static void
@@ -3474,7 +3474,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	if (sdret < 0) {
 		DHD_ERROR(("%s: read %d control bytes failed: %d\n",
 			   __func__, rdlen, sdret));
-		bus->rxc_errors++;	/* dhd.rx_ctlerrs is higher level */
+		bus->rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
 	}
@@ -3941,7 +3941,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	*finished = false;
 
 	for (rxseq = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && bus->drvr->busstate != DHD_BUS_DOWN;
+	     !bus->rxskip && rxleft && bus->drvr->busstate != BRCMF_BUS_DOWN;
 	     rxseq++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -4216,8 +4216,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				DHD_ERROR(("%s (nextlen): bad data offset %d: HW len %d min %d\n",
-					__func__, doff, len, SDPCM_HDRLEN));
+				DHD_ERROR(("%s (nextlen): bad data offset %d: "
+					   "HW len %d min %d\n",
+					   __func__, doff, len, SDPCM_HDRLEN));
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
@@ -4602,7 +4603,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		if (err) {
 			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 				   __func__, err));
-			bus->drvr->busstate = DHD_BUS_DOWN;
+			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		} else {
 			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
 		}
@@ -4614,7 +4615,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		if (err) {
 			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
 				   err));
-			bus->drvr->busstate = DHD_BUS_DOWN;
+			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		}
 
 		DHD_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n", devctl,
@@ -4626,7 +4627,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 			if (err) {
 				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 					   __func__, err));
-				bus->drvr->busstate = DHD_BUS_DOWN;
+				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
@@ -4634,7 +4635,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 			if (err) {
 				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
 					   __func__, err));
-				bus->drvr->busstate = DHD_BUS_DOWN;
+				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
 		} else {
@@ -4791,7 +4792,7 @@ clkwait:
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && DATAOK(bus)) {
-		framecnt = rxdone ? txlimit : min(txlimit, dhd_txminmax);
+		framecnt = rxdone ? txlimit : min(txlimit, brcmf_txminmax);
 		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
 	}
@@ -4800,12 +4801,12 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->drvr->busstate == DHD_BUS_DOWN) ||
+	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(card)) {
 		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
 			   "operation %d\n", __func__,
 			  brcmf_sdcard_regfail(card)));
-		bus->drvr->busstate = DHD_BUS_DOWN;
+		bus->drvr->busstate = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
 		DHD_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
@@ -4844,7 +4845,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	}
 	card = bus->card;
 
-	if (bus->drvr->busstate == DHD_BUS_DOWN) {
+	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
 		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
 			   __func__));
 		return;
@@ -5196,7 +5197,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	}
 #ifdef BCMDBG
 	/* Poll for console output periodically */
-	if (drvr->busstate == DHD_BUS_DATA && brcmf_console_ms != 0) {
+	if (drvr->busstate == BRCMF_BUS_DATA && brcmf_console_ms != 0) {
 		bus->console.count += brcmf_watchdog_ms;
 		if (bus->console.count >= brcmf_console_ms) {
 			bus->console.count -= brcmf_console_ms;
@@ -5329,14 +5330,14 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	 * first time that the driver is initialized vs subsequent
 	 * initializations.
 	 */
-	brcmf_txbound = DHD_TXBOUND;
-	brcmf_rxbound = DHD_RXBOUND;
+	brcmf_txbound = BRCMF_TXBOUND;
+	brcmf_rxbound = BRCMF_RXBOUND;
 	brcmf_alignctl = true;
 	sd1idle = true;
 	brcmf_readahead = true;
 	retrydata = false;
 	brcmf_dongle_memsize = 0;
-	dhd_txminmax = DHD_TXMINMAX;
+	brcmf_txminmax = BRCMF_TXMINMAX;
 
 	forcealign = true;
 
@@ -5400,7 +5401,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 	bus->card = card;
 	bus->cl_devid = (u16) devid;
-	bus->bus = DHD_BUS;
+	bus->bus = BRCMF_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
@@ -5446,10 +5447,10 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		/* Initialize DPC thread */
 		init_completion(&bus->dpc_wait);
 		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
-					   bus, "dhd_dpc");
+					   bus, "brcmf_dpc");
 		if (IS_ERR(bus->dpc_tsk)) {
 			printk(KERN_WARNING
-			       "dhd_dpc thread failed to start\n");
+			       "brcmf_dpc thread failed to start\n");
 			bus->dpc_tsk = NULL;
 		}
 	} else {
@@ -5458,10 +5459,10 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		bus->dpc_tsk = NULL;
 	}
 
-	/* Attach to the dhd/OS/network interface */
+	/* Attach to the brcmf/OS/network interface */
 	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->drvr) {
-		DHD_ERROR(("%s: dhd_attach failed\n", __func__));
+		DHD_ERROR(("%s: brcmf_attach failed\n", __func__));
 		goto fail;
 	}
 
@@ -5536,16 +5537,16 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 	 */
 
 	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			 DHD_INIT_CLKCTL1, &err);
+			 BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
 		clkctl =
 		    brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
-	if (err || ((clkctl & ~SBSDIO_AVBITS) != DHD_INIT_CLKCTL1)) {
+	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
 		DHD_ERROR(("brcmf_sdbrcm_probe: ChipClkCSR access: err %d wrote"
 			" 0x%02x read 0x%02x\n",
-			err, DHD_INIT_CLKCTL1, clkctl));
+			err, BRCMF_INIT_CLKCTL1, clkctl));
 		goto fail;
 	}
 
@@ -5563,7 +5564,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
 
 	/* Get info on the ARM and SOCRAM cores... */
-	if (!DHD_NOPMU(bus)) {
+	if (!BRCMF_NOPMU(bus)) {
 		brcmf_sdcard_reg_read(bus->card,
 			  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
 		bus->orig_ramsize = bus->ci->ramsize;
@@ -5657,7 +5658,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 	brcmf_sdcard_cfg_write(card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
-	bus->drvr->busstate = DHD_BUS_DOWN;
+	bus->drvr->busstate = BRCMF_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
 
@@ -5790,7 +5791,7 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
  * order to look for or await the device.
  */
 
-static struct brcmf_sdioh_driver dhd_sdio = {
+static struct brcmf_sdioh_driver brcmf_sdio = {
 	brcmf_sdbrcm_probe,
 	brcmf_sdbrcm_disconnect
 };
@@ -5814,7 +5815,7 @@ int brcmf_bus_register(void)
 		return -EINVAL;
 	} while (0);
 
-	return brcmf_sdio_register(&dhd_sdio);
+	return brcmf_sdio_register(&brcmf_sdio);
 }
 
 void brcmf_bus_unregister(void)
@@ -5995,11 +5996,6 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 		goto err;
 	}
 
-	/* EXAMPLE: nvram_array */
-	/* If a valid nvram_arry is specified as above, it can be passed
-		 down to dongle */
-	/* dhd_bus_set_nvram_params(bus, (char *)&nvram_array); */
-
 	/* External nvram takes precedence if specified */
 	if (brcmf_sdbrcm_download_nvram(bus)) {
 		DHD_ERROR(("%s: dongle nvram file download failed\n",
@@ -6566,7 +6562,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 	static uint save_ms;
 
 	/* don't start the wd until fw is loaded */
-	if (bus->drvr->busstate == DHD_BUS_DOWN)
+	if (bus->drvr->busstate == BRCMF_BUS_DOWN)
 		return;
 
 	/* Totally stop the timer */
@@ -6625,7 +6621,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
 			/* Call bus dpc unless it indicated down
 			(then clean stop) */
-			if (bus->drvr->busstate != DHD_BUS_DOWN) {
+			if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
@@ -6642,7 +6638,7 @@ static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
 	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
 	/* Call bus dpc unless it indicated down (then clean stop) */
-	if (bus->drvr->busstate != DHD_BUS_DOWN) {
+	if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
 		if (brcmf_sdbrcm_dpc(bus))
 			tasklet_schedule(&bus->tasklet);
 	} else
-- 
1.7.4.1


