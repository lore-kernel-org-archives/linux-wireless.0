Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4552 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099Ab1F2Xtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 102/119] staging: brcm80211: rename function variables
Date: Wed, 29 Jun 2011 16:48:06 -0700
Message-ID: <1309391303-22741-103-git-send-email-frankyl@broadcom.com> (sfid-20110630_015242_538988_A37A6CAD)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This commit gets rid of variables whose name is a broadcom specific
acronym and not very meaningful.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h      |   79 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h  |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c  |  115 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  294 ++++++++++++-------------
 4 files changed, 246 insertions(+), 250 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index d063afb..9f627e5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -708,27 +708,27 @@ extern const bcmevent_name_t bcmevent_names[];
 extern const int bcmevent_names_size;
 
 
-static inline void MUTEX_LOCK_INIT(struct brcmf_pub *dhdp)
+static inline void MUTEX_LOCK_INIT(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_LOCK(struct brcmf_pub *dhdp)
+static inline void MUTEX_LOCK(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_UNLOCK(struct brcmf_pub *dhdp)
+static inline void MUTEX_UNLOCK(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_LOCK_SOFTAP_SET_INIT(struct brcmf_pub *dhdp)
+static inline void MUTEX_LOCK_SOFTAP_SET_INIT(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_LOCK_SOFTAP_SET(struct brcmf_pub *dhdp)
+static inline void MUTEX_LOCK_SOFTAP_SET(struct brcmf_pub *drvr)
 {
 }
 
-static inline void MUTEX_UNLOCK_SOFTAP_SET(struct brcmf_pub *dhdp)
+static inline void MUTEX_UNLOCK_SOFTAP_SET(struct brcmf_pub *drvr)
 {
 }
 
@@ -754,85 +754,86 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
  * bus_hdrlen specifies required headroom for bus module header.
  */
 extern struct brcmf_pub *brcmf_attach(struct dhd_bus *bus,
-				uint bus_hdrlen);
-extern int brcmf_net_attach(struct brcmf_pub *dhdp, int idx);
+				      uint bus_hdrlen);
+extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
 
 /* Indication from bus module regarding removal/absence of dongle */
-extern void brcmf_detach(struct brcmf_pub *dhdp);
+extern void brcmf_detach(struct brcmf_pub *drvr);
 
 /* Indication from bus module to change flow-control state */
-extern void brcmf_txflowcontrol(struct brcmf_pub *dhdp, int ifidx, bool on);
+extern void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool on);
 
-extern bool brcmf_c_prec_enq(struct brcmf_pub *dhdp, struct pktq *q,
+extern bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(struct brcmf_pub *dhdp, int ifidx,
+extern void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 			 struct sk_buff *rxp, int numpkt);
 
 /* Return pointer to interface name */
-extern char *brcmf_ifname(struct brcmf_pub *dhdp, int idx);
+extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
 /* Request scheduling of the bus dpc */
-extern void brcmf_sched_dpc(struct brcmf_pub *dhdp);
+extern void brcmf_sched_dpc(struct brcmf_pub *drvr);
 
 /* Notify tx completion */
-extern void brcmf_txcomplete(struct brcmf_pub *dhdp, struct sk_buff *txp,
+extern void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp,
 			     bool success);
 
 /* Query ioctl */
-extern int brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx,
+extern int brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
 
 /* OS independent layer functions */
-extern int brcmf_os_proto_block(struct brcmf_pub *pub);
-extern int brcmf_os_proto_unblock(struct brcmf_pub *pub);
-extern int brcmf_os_ioctl_resp_wait(struct brcmf_pub *pub, uint *condition,
+extern int brcmf_os_proto_block(struct brcmf_pub *drvr);
+extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
+extern int brcmf_os_ioctl_resp_wait(struct brcmf_pub *drvr, uint *condition,
 				  bool *pending);
-extern int brcmf_os_ioctl_resp_wake(struct brcmf_pub *pub);
+extern int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr);
 extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
 extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
-extern void brcmf_os_sdlock_sndup_rxq(struct brcmf_pub *pub);
+extern void brcmf_os_sdlock_sndup_rxq(struct brcmf_pub *drvr);
 extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
 extern int brcmf_custom_get_mac_address(unsigned char *buf);
-extern void brcmf_os_sdunlock_sndup_rxq(struct brcmf_pub *pub);
-extern void brcmf_os_sdlock_eventq(struct brcmf_pub *pub);
-extern void brcmf_os_sdunlock_eventq(struct brcmf_pub *pub);
+extern void brcmf_os_sdunlock_sndup_rxq(struct brcmf_pub *drvr);
+extern void brcmf_os_sdlock_eventq(struct brcmf_pub *drvr);
+extern void brcmf_os_sdunlock_eventq(struct brcmf_pub *drvr);
 #ifdef BCMDBG
-extern int brcmf_write_to_file(struct brcmf_pub *dhd, u8 *buf, int size);
+extern int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size);
 #endif				/* BCMDBG */
 
 extern void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec);
 extern int brcmf_timeout_expired(struct brcmf_timeout *tmo);
 
-extern int brcmf_ifname2idx(struct brcmf_info *dhd, char *name);
-extern int brcmf_c_host_event(struct brcmf_info *dhd, int *idx, void *pktdata,
-			 brcmf_event_msg_t *, void **data_ptr);
+extern int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name);
+extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
+			      void *pktdata, brcmf_event_msg_t *,
+			      void **data_ptr);
 
 extern void brcmf_c_init(void);
 
-extern int brcmf_add_if(struct brcmf_info *dhd, int ifidx, void *handle,
+extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle,
 		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
-extern void brcmf_del_if(struct brcmf_info *dhd, int ifidx);
+extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 
-extern void brcmf_vif_add(struct brcmf_info *dhd, int ifidx, char *name);
-extern void brcmf_vif_del(struct brcmf_info *dhd, int ifidx);
+extern void brcmf_vif_add(struct brcmf_info *drvr_priv, int ifidx, char *name);
+extern void brcmf_vif_del(struct brcmf_info *drvr_priv, int ifidx);
 
-extern void brcmf_event(struct brcmf_info *dhd, char *evpkt, int evlen,
+extern void brcmf_event(struct brcmf_info *drvr_priv, char *evpkt, int evlen,
 			int ifidx);
-extern void brcmf_vif_sendup(struct brcmf_info *dhd, int ifidx,
+extern void brcmf_vif_sendup(struct brcmf_info *drvr_priv, int ifidx,
 			     unsigned char *cp, int len);
 
 /* Send packet to dongle via data channel */
-extern int brcmf_sendpkt(struct brcmf_pub *dhdp, int ifidx,\
+extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
 			 struct sk_buff *pkt);
 
-extern int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag);
-extern int brcmf_bus_start(struct brcmf_pub *dhdp);
+extern int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag);
+extern int brcmf_bus_start(struct brcmf_pub *drvr);
 
-extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *dhd, char *arg);
-extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *dhd, char *arg,
+extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
+extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
 #ifdef BCMDBG
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 95fcef4..096d73c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -40,7 +40,7 @@ extern void dhd_bus_unregister(void);
 extern void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
 
 /* Initialize bus module: prepare for communication w/dongle */
-extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex);
+extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
 extern int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *txp);
@@ -58,16 +58,16 @@ extern void dhd_bus_isr(bool *InterruptRecognized,
 			bool *QueueMiniportHandleInterrupt, void *arg);
 
 /* Check for and handle local prot-specific iovar commands */
-extern int brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *dhdp, const char *name,
+extern int brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 			    void *params, int plen, void *arg, int len,
 			    bool set);
 
 /* Add bus dump output to a buffer */
-extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp,
+extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr,
 				  struct brcmu_strbuf *strbuf);
 
 /* Clear any bus counters */
-extern void dhd_bus_clearcounts(struct brcmf_pub *dhdp);
+extern void dhd_bus_clearcounts(struct brcmf_pub *drvr);
 
 /* return the dongle chipid */
 extern uint dhd_bus_chip(struct dhd_bus *bus);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index e28b727..d07860b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -100,9 +100,9 @@ struct brcmf_proto {
 	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
 };
 
-static int brcmf_proto_cdc_msg(struct brcmf_pub *dhd)
+static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 {
-	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto *prot = drvr->prot;
 	int len = le32_to_cpu(prot->msg.len) +
 			sizeof(struct brcmf_proto_cdc_ioctl);
 
@@ -116,19 +116,19 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *dhd)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return brcmf_sdbrcm_bus_txctl(dhd->bus, (unsigned char *)&prot->msg,
+	return brcmf_sdbrcm_bus_txctl(drvr->bus, (unsigned char *)&prot->msg,
 				      len);
 }
 
-static int brcmf_proto_cdc_cmplt(struct brcmf_pub *dhd, u32 id, u32 len)
+static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 {
 	int ret;
-	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto *prot = drvr->prot;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	do {
-		ret = brcmf_sdbrcm_bus_rxctl(dhd->bus,
+		ret = brcmf_sdbrcm_bus_rxctl(drvr->bus,
 				(unsigned char *)&prot->msg,
 				len + sizeof(struct brcmf_proto_cdc_ioctl));
 		if (ret < 0)
@@ -139,10 +139,10 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *dhd, u32 id, u32 len)
 }
 
 int
-brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
+brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			    void *buf, uint len)
 {
-	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto *prot = drvr->prot;
 	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 	void *info;
 	int ret = 0, retries = 0;
@@ -158,7 +158,7 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 				BCME_STRLEN);
 			goto done;
 		} else if (!strcmp((char *)buf, "bcmerror")) {
-			*(int *)buf = dhd->dongle_error;
+			*(int *)buf = drvr->dongle_error;
 			goto done;
 		}
 	}
@@ -174,7 +174,7 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 	if (buf)
 		memcpy(prot->buf, buf, len);
 
-	ret = brcmf_proto_cdc_msg(dhd);
+	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
 		DHD_ERROR(("dhdcdc_query_ioctl: dhdcdc_msg failed w/status "
 			"%d\n", ret));
@@ -183,7 +183,7 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 
 retry:
 	/* wait for interrupt and get first fragment */
-	ret = brcmf_proto_cdc_cmplt(dhd, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(drvr, prot->reqid, len);
 	if (ret < 0)
 		goto done;
 
@@ -194,7 +194,7 @@ retry:
 		goto retry;
 	if (id != prot->reqid) {
 		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   brcmf_ifname(dhd, ifidx), __func__, id,
+			   brcmf_ifname(drvr, ifidx), __func__, id,
 			   prot->reqid));
 		ret = -EINVAL;
 		goto done;
@@ -214,17 +214,17 @@ retry:
 	if (flags & CDCF_IOC_ERROR) {
 		ret = le32_to_cpu(msg->status);
 		/* Cache error from dongle */
-		dhd->dongle_error = ret;
+		drvr->dongle_error = ret;
 	}
 
 done:
 	return ret;
 }
 
-int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
+int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			      void *buf, uint len)
 {
-	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto *prot = drvr->prot;
 	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 	int ret = 0;
 	u32 flags, id;
@@ -243,11 +243,11 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 	if (buf)
 		memcpy(prot->buf, buf, len);
 
-	ret = brcmf_proto_cdc_msg(dhd);
+	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0)
 		goto done;
 
-	ret = brcmf_proto_cdc_cmplt(dhd, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(drvr, prot->reqid, len);
 	if (ret < 0)
 		goto done;
 
@@ -256,7 +256,7 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 
 	if (id != prot->reqid) {
 		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   brcmf_ifname(dhd, ifidx), __func__, id,
+			   brcmf_ifname(drvr, ifidx), __func__, id,
 			   prot->reqid));
 		ret = -EINVAL;
 		goto done;
@@ -266,7 +266,7 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 	if (flags & CDCF_IOC_ERROR) {
 		ret = le32_to_cpu(msg->status);
 		/* Cache error from dongle */
-		dhd->dongle_error = ret;
+		drvr->dongle_error = ret;
 	}
 
 done:
@@ -274,18 +274,18 @@ done:
 }
 
 int
-brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx, struct brcmf_ioctl *ioc,
+brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 		  void *buf, int len)
 {
-	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto *prot = drvr->prot;
 	int ret = -1;
 
-	if (dhd->busstate == DHD_BUS_DOWN) {
+	if (drvr->busstate == DHD_BUS_DOWN) {
 		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
 			   __func__));
 		return ret;
 	}
-	brcmf_os_proto_block(dhd);
+	brcmf_os_proto_block(drvr);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -309,9 +309,10 @@ brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx, struct brcmf_ioctl *ioc,
 	prot->pending = true;
 	prot->lastcmd = ioc->cmd;
 	if (ioc->set)
-		ret = brcmf_proto_cdc_set_ioctl(dhd, ifidx, ioc->cmd, buf, len);
+		ret = brcmf_proto_cdc_set_ioctl(drvr, ifidx, ioc->cmd,
+						buf, len);
 	else {
-		ret = brcmf_proto_cdc_query_ioctl(dhd, ifidx, ioc->cmd,
+		ret = brcmf_proto_cdc_query_ioctl(drvr, ifidx, ioc->cmd,
 						  buf, len);
 		if (ret > 0)
 			ioc->used = ret - sizeof(struct brcmf_proto_cdc_ioctl);
@@ -334,13 +335,13 @@ brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx, struct brcmf_ioctl *ioc,
 		slen = strlen("wme_dp") + 1;
 		if (len >= (int)(slen + sizeof(int)))
 			memcpy(&val, (char *)buf + slen, sizeof(int));
-		dhd->wme_dp = (u8) le32_to_cpu(val);
+		drvr->wme_dp = (u8) le32_to_cpu(val);
 	}
 
 	prot->pending = false;
 
 done:
-	brcmf_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(drvr);
 
 	return ret;
 }
@@ -355,18 +356,18 @@ done:
 	skb->ip_summed is overloaded */
 
 int
-brcmf_proto_iovar_op(struct brcmf_pub *dhdp, const char *name,
+brcmf_proto_iovar_op(struct brcmf_pub *drvr, const char *name,
 		  void *params, int plen, void *arg, int len, bool set)
 {
 	return -ENOTSUPP;
 }
 
-void brcmf_proto_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_proto_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 {
-	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", dhdp->prot->reqid);
+	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", drvr->prot->reqid);
 }
 
-void brcmf_proto_hdrpush(struct brcmf_pub *dhd, int ifidx,
+void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
@@ -389,7 +390,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *dhd, int ifidx,
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int brcmf_proto_hdrpull(struct brcmf_pub *dhd, int *ifidx,
+int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 			struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
@@ -416,14 +417,14 @@ int brcmf_proto_hdrpull(struct brcmf_pub *dhd, int *ifidx,
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
 		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
-			   brcmf_ifname(dhd, *ifidx), h->flags));
+			   brcmf_ifname(drvr, *ifidx), h->flags));
 		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
 		DHD_INFO(("%s: BDC packet received with good rx-csum, "
 			"flags 0x%x\n",
-			brcmf_ifname(dhd, *ifidx), h->flags));
+			brcmf_ifname(drvr, *ifidx), h->flags));
 		PKTSETSUMGOOD(pktbuf, true);
 	}
 
@@ -434,7 +435,7 @@ int brcmf_proto_hdrpull(struct brcmf_pub *dhd, int *ifidx,
 	return 0;
 }
 
-int brcmf_proto_attach(struct brcmf_pub *dhd)
+int brcmf_proto_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_proto *cdc;
 
@@ -450,9 +451,9 @@ int brcmf_proto_attach(struct brcmf_pub *dhd)
 		goto fail;
 	}
 
-	dhd->prot = cdc;
-	dhd->hdrlen += BDC_HEADER_LEN;
-	dhd->maxctl = BRCMF_C_IOCTL_MAXLEN +
+	drvr->prot = cdc;
+	drvr->hdrlen += BDC_HEADER_LEN;
+	drvr->maxctl = BRCMF_C_IOCTL_MAXLEN +
 			sizeof(struct brcmf_proto_cdc_ioctl) + ROUND_UP_MARGIN;
 	return 0;
 
@@ -462,54 +463,54 @@ fail:
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
-void brcmf_proto_detach(struct brcmf_pub *dhd)
+void brcmf_proto_detach(struct brcmf_pub *drvr)
 {
-	kfree(dhd->prot);
-	dhd->prot = NULL;
+	kfree(drvr->prot);
+	drvr->prot = NULL;
 }
 
-void brcmf_proto_dstats(struct brcmf_pub *dhd)
+void brcmf_proto_dstats(struct brcmf_pub *drvr)
 {
 	/* No stats from dongle added yet, copy bus stats */
-	dhd->dstats.tx_packets = dhd->tx_packets;
-	dhd->dstats.tx_errors = dhd->tx_errors;
-	dhd->dstats.rx_packets = dhd->rx_packets;
-	dhd->dstats.rx_errors = dhd->rx_errors;
-	dhd->dstats.rx_dropped = dhd->rx_dropped;
-	dhd->dstats.multicast = dhd->rx_multicast;
+	drvr->dstats.tx_packets = drvr->tx_packets;
+	drvr->dstats.tx_errors = drvr->tx_errors;
+	drvr->dstats.rx_packets = drvr->rx_packets;
+	drvr->dstats.rx_errors = drvr->rx_errors;
+	drvr->dstats.rx_dropped = drvr->rx_dropped;
+	drvr->dstats.multicast = drvr->rx_multicast;
 	return;
 }
 
-int brcmf_proto_init(struct brcmf_pub *dhd)
+int brcmf_proto_init(struct brcmf_pub *drvr)
 {
 	int ret = 0;
 	char buf[128];
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	brcmf_os_proto_block(dhd);
+	brcmf_os_proto_block(drvr);
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
-	ret = brcmf_proto_cdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR,
+	ret = brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR,
 					  buf, sizeof(buf));
 	if (ret < 0) {
-		brcmf_os_proto_unblock(dhd);
+		brcmf_os_proto_unblock(drvr);
 		return ret;
 	}
-	memcpy(dhd->mac, buf, ETH_ALEN);
+	memcpy(drvr->mac, buf, ETH_ALEN);
 
-	brcmf_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(drvr);
 
-	ret = brcmf_c_preinit_ioctls(dhd);
+	ret = brcmf_c_preinit_ioctls(drvr);
 
 	/* Always assumes wl for now */
-	dhd->iswl = true;
+	drvr->iswl = true;
 
 	return ret;
 }
 
-void brcmf_proto_stop(struct brcmf_pub *dhd)
+void brcmf_proto_stop(struct brcmf_pub *drvr)
 {
 	/* Nothing to do for CDC */
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index c9ec69b..a69791e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -543,7 +543,7 @@ struct chip_info {
 
 /* Private data for SDIO bus interaction */
 typedef struct dhd_bus {
-	struct brcmf_pub *dhd;
+	struct brcmf_pub *drvr;
 
 	struct brcmf_sdio_card *card;	/* Handle for sdio card calls */
 	struct chip_info *ci;	/* Chip info struct */
@@ -781,7 +781,7 @@ uint dhd_txminmax;
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
 int brcmf_dongle_memsize;
 
-static bool dhd_alignctl;
+static bool brcmf_alignctl;
 
 static bool sd1idle;
 
@@ -817,7 +817,7 @@ static bool forcealign;
 static const uint max_roundup = 512;
 
 /* Try doing readahead */
-static bool dhd_readahead;
+static bool brcmf_readahead;
 
 /* To check if there's window offered */
 #define DATAOK(bus) \
@@ -1242,7 +1242,7 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 		bus->sleeping = false;
 
 		/* Enable interrupts again */
-		if (bus->intr && (bus->dhd->busstate == DHD_BUS_DATA)) {
+		if (bus->intr && (bus->drvr->busstate == DHD_BUS_DATA)) {
 			bus->intdis = false;
 			brcmf_sdcard_intr_enable(bus->card);
 		}
@@ -1275,7 +1275,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 
 	card = bus->card;
 
-	if (bus->dhd->dongle_reset) {
+	if (bus->drvr->dongle_reset) {
 		ret = -EPERM;
 		goto done;
 	}
@@ -1288,7 +1288,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 		if (skb_headroom(pkt) < pad) {
 			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
 				  __func__, skb_headroom(pkt), pad));
-			bus->dhd->tx_realloc++;
+			bus->drvr->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
@@ -1402,7 +1402,7 @@ done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
 	brcmf_sdbrcm_sdunlock(bus);
-	brcmf_txcomplete(bus->dhd, pkt, ret != 0);
+	brcmf_txcomplete(bus->drvr, pkt, ret != 0);
 	brcmf_sdbrcm_sdlock(bus);
 
 	if (free_pkt)
@@ -1452,9 +1452,9 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 
 		/* Priority based enq */
 		spin_lock_bh(&bus->txqlock);
-		if (brcmf_c_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
+		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
-			brcmf_txcomplete(bus->dhd, pkt, false);
+			brcmf_txcomplete(bus->drvr, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
 			ret = -ENOSR;
@@ -1464,7 +1464,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		spin_unlock_bh(&bus->txqlock);
 
 		if (pktq_len(&bus->txq) >= TXHI)
-			brcmf_txflowcontrol(bus->dhd, 0, ON);
+			brcmf_txflowcontrol(bus->drvr, 0, ON);
 
 #ifdef BCMDBG
 		if (pktq_plen(&bus->txq, prec) > qcount[prec])
@@ -1493,9 +1493,9 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 				     SDPCM_DATA_CHANNEL), true);
 #endif
 		if (ret)
-			bus->dhd->tx_errors++;
+			bus->drvr->tx_errors++;
 		else
-			bus->dhd->dstats.tx_bytes += datalen;
+			bus->drvr->dstats.tx_bytes += datalen;
 
 		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
 		    !bus->dpc_sched) {
@@ -1519,7 +1519,7 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 	uint datalen;
 	u8 tx_prec_map;
 
-	struct brcmf_pub *dhd = bus->dhd;
+	struct brcmf_pub *drvr = bus->drvr;
 	struct sdpcmd_regs *regs = bus->regs;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -1545,9 +1545,9 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 				     SDPCM_DATA_CHANNEL), true);
 #endif
 		if (ret)
-			bus->dhd->tx_errors++;
+			bus->drvr->tx_errors++;
 		else
-			bus->dhd->dstats.tx_bytes += datalen;
+			bus->drvr->dstats.tx_bytes += datalen;
 
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
@@ -1562,9 +1562,9 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (dhd->up && (dhd->busstate == DHD_BUS_DATA) &&
-	    dhd->txoff && (pktq_len(&bus->txq) < TXLOW))
-		brcmf_txflowcontrol(dhd, 0, OFF);
+	if (drvr->up && (drvr->busstate == DHD_BUS_DATA) &&
+	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
+		brcmf_txflowcontrol(drvr, 0, OFF);
 
 	return cnt;
 }
@@ -1583,7 +1583,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (bus->dhd->dongle_reset)
+	if (bus->drvr->dongle_reset)
 		return -EIO;
 
 	/* Back the pointer to make a room for bus header */
@@ -1591,7 +1591,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	len = (msglen += SDPCM_HDRLEN);
 
 	/* Add alignment padding (optional for ctl frames) */
-	if (dhd_alignctl) {
+	if (brcmf_alignctl) {
 		doff = ((unsigned long)frame % BRCMF_SDALIGN);
 		if (doff) {
 			frame -= doff;
@@ -1724,9 +1724,9 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	brcmf_sdbrcm_sdunlock(bus);
 
 	if (ret)
-		bus->dhd->tx_ctlerrs++;
+		bus->drvr->tx_ctlerrs++;
 	else
-		bus->dhd->tx_ctlpkts++;
+		bus->drvr->tx_ctlpkts++;
 
 	return ret ? -EIO : 0;
 }
@@ -1739,11 +1739,11 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (bus->dhd->dongle_reset)
+	if (bus->drvr->dongle_reset)
 		return -EIO;
 
 	/* Wait until control frame is available */
-	timeleft = brcmf_os_ioctl_resp_wait(bus->dhd, &bus->rxlen, &pending);
+	timeleft = brcmf_os_ioctl_resp_wait(bus->drvr, &bus->rxlen, &pending);
 
 	brcmf_sdbrcm_sdlock(bus);
 	rxlen = bus->rxlen;
@@ -1774,9 +1774,9 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	}
 
 	if (rxlen)
-		bus->dhd->rx_ctlpkts++;
+		bus->drvr->rx_ctlpkts++;
 	else
-		bus->dhd->rx_ctlerrs++;
+		bus->drvr->rx_ctlerrs++;
 
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
@@ -1886,9 +1886,9 @@ dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 	}
 }
 
-void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 {
-	dhd_bus_t *bus = dhdp->bus;
+	dhd_bus_t *bus = drvr->bus;
 
 	brcmu_bprintf(strbuf, "Bus SDIO structure:\n");
 	brcmu_bprintf(strbuf,
@@ -1919,44 +1919,44 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 		      (bus->f2rxhdrs + bus->f2rxdata), bus->f2rxhdrs,
 		      bus->f2rxdata, bus->f2txdata, bus->f1regdata);
 	{
-		dhd_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->dhd->rx_packets,
+		dhd_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->drvr->rx_packets,
 			     (bus->f2rxhdrs + bus->f2rxdata));
-		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->dhd->rx_packets,
+		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->rx_packets,
 			     bus->f1regdata);
-		dhd_dump_pct(strbuf, ", pkts/sd", bus->dhd->rx_packets,
+		dhd_dump_pct(strbuf, ", pkts/sd", bus->drvr->rx_packets,
 			     (bus->f2rxhdrs + bus->f2rxdata + bus->f1regdata));
-		dhd_dump_pct(strbuf, ", pkts/int", bus->dhd->rx_packets,
+		dhd_dump_pct(strbuf, ", pkts/int", bus->drvr->rx_packets,
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n");
 
 		dhd_dump_pct(strbuf, "Rx: glom pct", (100 * bus->rxglompkts),
-			     bus->dhd->rx_packets);
+			     bus->drvr->rx_packets);
 		dhd_dump_pct(strbuf, ", pkts/glom", bus->rxglompkts,
 			     bus->rxglomframes);
 		brcmu_bprintf(strbuf, "\n");
 
-		dhd_dump_pct(strbuf, "Tx: pkts/f2wr", bus->dhd->tx_packets,
+		dhd_dump_pct(strbuf, "Tx: pkts/f2wr", bus->drvr->tx_packets,
 			     bus->f2txdata);
-		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->dhd->tx_packets,
+		dhd_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->tx_packets,
 			     bus->f1regdata);
-		dhd_dump_pct(strbuf, ", pkts/sd", bus->dhd->tx_packets,
+		dhd_dump_pct(strbuf, ", pkts/sd", bus->drvr->tx_packets,
 			     (bus->f2txdata + bus->f1regdata));
-		dhd_dump_pct(strbuf, ", pkts/int", bus->dhd->tx_packets,
+		dhd_dump_pct(strbuf, ", pkts/int", bus->drvr->tx_packets,
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n");
 
 		dhd_dump_pct(strbuf, "Total: pkts/f2rw",
-			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
+			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata));
 		dhd_dump_pct(strbuf, ", pkts/f1sd",
-			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
+			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     bus->f1regdata);
 		dhd_dump_pct(strbuf, ", pkts/sd",
-			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
+			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata +
 			      bus->f1regdata));
 		dhd_dump_pct(strbuf, ", pkts/int",
-			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
+			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
 			     bus->intrcount);
 		brcmu_bprintf(strbuf, "\n\n");
 	}
@@ -1986,9 +1986,9 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 		    bus->sleeping);
 }
 
-void dhd_bus_clearcounts(struct brcmf_pub *dhdp)
+void dhd_bus_clearcounts(struct brcmf_pub *drvr)
 {
-	dhd_bus_t *bus = (dhd_bus_t *) dhdp->bus;
+	dhd_bus_t *bus = (dhd_bus_t *) drvr->bus;
 
 	bus->intrcount = bus->lastintrs = bus->spurious = bus->regfails = 0;
 	bus->rxrtx = bus->rx_toolong = bus->rxc_errors = 0;
@@ -2335,7 +2335,7 @@ static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
 	printk(KERN_DEBUG "Done\n");
 
 	/* free buf before return !!! */
-	if (brcmf_write_to_file(bus->dhd, buf, bus->ramsize)) {
+	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
 		DHD_ERROR(("%s: Error writing to files\n", __func__));
 		return -1;
 	}
@@ -2430,7 +2430,7 @@ int brcmf_sdbrcm_downloadvars(dhd_bus_t *bus, void *arg, int len)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Basic sanity checks */
-	if (bus->dhd->up) {
+	if (bus->drvr->up) {
 		bcmerror = -EISCONN;
 		goto err;
 	}
@@ -2482,7 +2482,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	brcmf_sdbrcm_sdlock(bus);
 
 	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
-	if (bus->dhd->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
+	if (bus->drvr->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
 					actionid == IOV_GVAL(IOV_DEVRESET))) {
 		bcmerror = -EPERM;
 		goto exit;
@@ -2500,7 +2500,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	}
 
 	/* Request clock to allow SDIO accesses */
-	if (!bus->dhd->dongle_reset) {
+	if (!bus->drvr->dongle_reset) {
 		BUS_WAKE(bus);
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	}
@@ -2514,7 +2514,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	case IOV_SVAL(IOV_INTR):
 		bus->intr = bool_val;
 		bus->intdis = false;
-		if (bus->dhd->up) {
+		if (bus->drvr->up) {
 			if (bus->intr) {
 				DHD_INTR(("%s: enable SDIO device interrupts\n",
 					  __func__));
@@ -2646,14 +2646,14 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_READAHEAD):
-		int_val = (s32) dhd_readahead;
+		int_val = (s32) brcmf_readahead;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_READAHEAD):
-		if (bool_val && !dhd_readahead)
+		if (bool_val && !brcmf_readahead)
 			bus->nextlen = 0;
-		dhd_readahead = bool_val;
+		brcmf_readahead = bool_val;
 		break;
 
 	case IOV_GVAL(IOV_SDRXCHAIN):
@@ -2668,12 +2668,12 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			bus->use_rxchain = bool_val;
 		break;
 	case IOV_GVAL(IOV_ALIGNCTL):
-		int_val = (s32) dhd_alignctl;
+		int_val = (s32) brcmf_alignctl;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_ALIGNCTL):
-		dhd_alignctl = bool_val;
+		brcmf_alignctl = bool_val;
 		break;
 
 	case IOV_GVAL(IOV_SDALIGN):
@@ -2702,7 +2702,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_CONS):
 		if (len > 0)
-			bcmerror = brcmf_sdbrcm_bus_console_in(bus->dhd,
+			bcmerror = brcmf_sdbrcm_bus_console_in(bus->drvr,
 							       arg, len - 1);
 		break;
 
@@ -2852,10 +2852,10 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	case IOV_SVAL(IOV_DEVRESET):
 		DHD_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
 			"busstate=%d\n",
-			__func__, bool_val, bus->dhd->dongle_reset,
-			bus->dhd->busstate));
+			__func__, bool_val, bus->drvr->dongle_reset,
+			bus->drvr->busstate));
 
-		brcmf_bus_devreset(bus->dhd, (u8) bool_val);
+		brcmf_bus_devreset(bus->drvr, (u8) bool_val);
 
 		break;
 
@@ -2863,7 +2863,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		DHD_TRACE(("%s: Called get IOV_DEVRESET\n", __func__));
 
 		/* Get its status */
-		int_val = (bool) bus->dhd->dongle_reset;
+		int_val = (bool) bus->drvr->dongle_reset;
 		memcpy(arg, &int_val, val_size);
 
 		break;
@@ -2874,7 +2874,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_SVAL(IOV_WDTICK):
-		if (!bus->dhd->up) {
+		if (!bus->drvr->up) {
 			bcmerror = -ENOLINK;
 			break;
 		}
@@ -2895,7 +2895,7 @@ exit:
 	brcmf_sdbrcm_sdunlock(bus);
 
 	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
-		brcmf_c_preinit_ioctls((struct brcmf_pub *) bus->dhd);
+		brcmf_c_preinit_ioctls(bus->drvr);
 
 	return bcmerror;
 }
@@ -3034,17 +3034,17 @@ static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
-		bus->dhd->busstate = DHD_BUS_LOAD;
+		bus->drvr->busstate = DHD_BUS_LOAD;
 	}
 fail:
 	return bcmerror;
 }
 
 int
-brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *dhdp, const char *name,
+brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 			  void *params, int plen, void *arg, int len, bool set)
 {
-	dhd_bus_t *bus = dhdp->bus;
+	dhd_bus_t *bus = drvr->bus;
 	const struct brcmu_iovar *vi = NULL;
 	int bcmerror = 0;
 	int val_size;
@@ -3165,7 +3165,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	bus->hostintmask = 0;
 
 	/* Change our idea of bus state */
-	bus->dhd->busstate = DHD_BUS_DOWN;
+	bus->drvr->busstate = DHD_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
@@ -3206,7 +3206,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
-	brcmf_os_ioctl_resp_wake(bus->dhd);
+	brcmf_os_ioctl_resp_wake(bus->drvr);
 
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
@@ -3214,15 +3214,11 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	if (enforce_mutex)
 		brcmf_sdbrcm_sdunlock(bus);
-
-#if defined(OOB_INTR_ONLY)
-	brcmf_sdio_unregister_oob_intr();
-#endif		/* defined(OOB_INTR_ONLY) */
 }
 
-int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
+int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 {
-	dhd_bus_t *bus = dhdp->bus;
+	dhd_bus_t *bus = drvr->bus;
 	struct brcmf_timeout tmo;
 	uint retries = 0;
 	u8 ready, enable;
@@ -3232,17 +3228,17 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* try to download image and nvram to the dongle */
-	if (dhdp->busstate == DHD_BUS_DOWN) {
+	if (drvr->busstate == DHD_BUS_DOWN) {
 		if (!(brcmf_sdbrcm_download_firmware(bus, bus->card)))
 			return -1;
 	}
 
-	ASSERT(bus->dhd);
-	if (!bus->dhd)
+	ASSERT(bus->drvr);
+	if (!bus->drvr)
 		return 0;
 
 	/* Start the watchdog timer */
-	bus->dhd->tickcnt = 0;
+	bus->drvr->tickcnt = 0;
 	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 
 	if (enforce_mutex)
@@ -3299,7 +3295,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 				 (u8) watermark, &err);
 
 		/* Set bus state according to enable result */
-		dhdp->busstate = DHD_BUS_DATA;
+		drvr->busstate = DHD_BUS_DATA;
 
 		bus->intdis = false;
 		if (bus->intr) {
@@ -3338,7 +3334,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 #endif		/* defined(OOB_INTR_ONLY) */
 
 	/* If we didn't come up, turn off backplane clock */
-	if (dhdp->busstate != DHD_BUS_DATA)
+	if (drvr->busstate != DHD_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
@@ -3408,7 +3404,7 @@ static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 
 	/* If we can't reach the device, signal failure */
 	if (err || brcmf_sdcard_regfail(card))
-		bus->dhd->busstate = DHD_BUS_DOWN;
+		bus->drvr->busstate = DHD_BUS_DOWN;
 }
 
 static void
@@ -3428,7 +3424,7 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	ASSERT(bus->rxbuf);
 	/* Set rxctl for frame (w/optional alignment) */
 	bus->rxctl = bus->rxbuf;
-	if (dhd_alignctl) {
+	if (brcmf_alignctl) {
 		bus->rxctl += firstread;
 		pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
 		if (pad)
@@ -3453,7 +3449,7 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
 		pad = bus->blocksize - (rdlen % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-		    ((len + pad) < bus->dhd->maxctl))
+		    ((len + pad) < bus->drvr->maxctl))
 			rdlen += pad;
 	} else if (rdlen % BRCMF_SDALIGN) {
 		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
@@ -3464,19 +3460,19 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 		rdlen = roundup(rdlen, ALIGNMENT);
 
 	/* Drop if the read is too big or it exceeds our maximum */
-	if ((rdlen + firstread) > bus->dhd->maxctl) {
+	if ((rdlen + firstread) > bus->drvr->maxctl) {
 		DHD_ERROR(("%s: %d-byte control read exceeds %d-byte buffer\n",
-			   __func__, rdlen, bus->dhd->maxctl));
-		bus->dhd->rx_errors++;
+			   __func__, rdlen, bus->drvr->maxctl));
+		bus->drvr->rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
-	if ((len - doff) > bus->dhd->maxctl) {
+	if ((len - doff) > bus->drvr->maxctl) {
 		DHD_ERROR(("%s: %d-byte ctl frame (%d-byte ctl data) exceeds "
 			"%d-byte limit\n",
-			__func__, len, (len - doff), bus->dhd->maxctl));
-		bus->dhd->rx_errors++;
+			__func__, len, (len - doff), bus->drvr->maxctl));
+		bus->drvr->rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
@@ -3514,7 +3510,7 @@ gotpkt:
 
 done:
 	/* Awake any waiters */
-	brcmf_os_ioctl_resp_wake(bus->dhd);
+	brcmf_os_ioctl_resp_wake(bus->drvr);
 }
 
 static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
@@ -3677,7 +3673,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 		if (errcode < 0) {
 			DHD_ERROR(("%s: glom read of %d bytes failed: %d\n",
 				   __func__, dlen, errcode));
-			bus->dhd->rx_errors++;
+			bus->drvr->rx_errors++;
 
 			if (bus->glomerr++ < 3) {
 				brcmf_sdbrcm_rxfail(bus, true, true);
@@ -3872,11 +3868,11 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 					save_pfirst = pnext;
 				}
 				continue;
-			} else if (brcmf_proto_hdrpull(bus->dhd, &ifidx, pfirst)
+			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pfirst)
 					!= 0) {
 				DHD_ERROR(("%s: rx protocol error\n",
 					   __func__));
-				bus->dhd->rx_errors++;
+				bus->drvr->rx_errors++;
 				brcmu_pkt_buf_free_skb(pfirst);
 				if (plast) {
 					plast->next = pnext;
@@ -3908,7 +3904,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 		}
 		if (num) {
 			brcmf_sdbrcm_sdunlock(bus);
-			brcmf_rx_frame(bus->dhd, ifidx, save_pfirst, num);
+			brcmf_rx_frame(bus->drvr, ifidx, save_pfirst, num);
 			brcmf_sdbrcm_sdlock(bus);
 		}
 
@@ -3961,7 +3957,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 	*finished = false;
 
 	for (rxseq = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && bus->dhd->busstate != DHD_BUS_DOWN;
+	     !bus->rxskip && rxleft && bus->drvr->busstate != DHD_BUS_DOWN;
 	     rxseq++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -3977,7 +3973,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		}
 
 		/* Try doing single read if we can */
-		if (dhd_readahead && bus->nextlen) {
+		if (brcmf_readahead && bus->nextlen) {
 			u16 nextlen = bus->nextlen;
 			bus->nextlen = 0;
 
@@ -4019,7 +4015,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				if (bus->bus == SPI_BUS) {
 					bus->usebufpool = false;
 					bus->rxctl = bus->rxbuf;
-					if (dhd_alignctl) {
+					if (brcmf_alignctl) {
 						bus->rxctl += firstread;
 						pad = ((unsigned long)bus->rxctl %
 						      BRCMF_SDALIGN);
@@ -4084,7 +4080,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
 						__func__, rdlen, sdret));
 					brcmu_pkt_buf_free_skb(pkt);
-					bus->dhd->rx_errors++;
+					bus->drvr->rx_errors++;
 					/* Force retry w/normal header read.
 					 * Don't attempt NAK for
 					 * gSPI
@@ -4167,7 +4163,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				bus->nextlen = 0;
 			}
 
-			bus->dhd->rx_readahead_cnt++;
+			bus->drvr->rx_readahead_cnt++;
 
 			/* Handle Flow Control */
 			fcbits = SDPCM_FCMASK_VALUE(
@@ -4389,7 +4385,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			/* Too long -- skip this frame */
 			DHD_ERROR(("%s: too long: len %d rdlen %d\n",
 				   __func__, len, rdlen));
-			bus->dhd->rx_errors++;
+			bus->drvr->rx_errors++;
 			bus->rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -4400,7 +4396,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			/* Give up on data, request rtx of events */
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
 				   " chan %d\n", __func__, rdlen, chan));
-			bus->dhd->rx_dropped++;
+			bus->drvr->rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
 		}
@@ -4429,7 +4425,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				       ? "data" : "test")),
 				   sdret));
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->dhd->rx_errors++;
+			bus->drvr->rx_errors++;
 			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
 			continue;
 		}
@@ -4487,16 +4483,16 @@ deliver:
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
-		} else if (brcmf_proto_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
+		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
 			DHD_ERROR(("%s: rx protocol error\n", __func__));
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->dhd->rx_errors++;
+			bus->drvr->rx_errors++;
 			continue;
 		}
 
 		/* Unlock during rx call */
 		brcmf_sdbrcm_sdunlock(bus);
-		brcmf_rx_frame(bus->dhd, ifidx, pkt, 1);
+		brcmf_rx_frame(bus->drvr, ifidx, pkt, 1);
 		brcmf_sdbrcm_sdlock(bus);
 	}
 	rxcount = maxframes - rxleft;
@@ -4621,7 +4617,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 		if (err) {
 			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 				   __func__, err));
-			bus->dhd->busstate = DHD_BUS_DOWN;
+			bus->drvr->busstate = DHD_BUS_DOWN;
 		} else {
 			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
 		}
@@ -4633,7 +4629,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 		if (err) {
 			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
 				   err));
-			bus->dhd->busstate = DHD_BUS_DOWN;
+			bus->drvr->busstate = DHD_BUS_DOWN;
 		}
 
 		DHD_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n", devctl,
@@ -4645,7 +4641,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 			if (err) {
 				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 					   __func__, err));
-				bus->dhd->busstate = DHD_BUS_DOWN;
+				bus->drvr->busstate = DHD_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
@@ -4653,7 +4649,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 			if (err) {
 				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
 					   __func__, err));
-				bus->dhd->busstate = DHD_BUS_DOWN;
+				bus->drvr->busstate = DHD_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
 		} else {
@@ -4813,12 +4809,12 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->dhd->busstate == DHD_BUS_DOWN) ||
-	     brcmf_sdcard_regfail(card)) {
+	if ((bus->drvr->busstate == DHD_BUS_DOWN) ||
+	    brcmf_sdcard_regfail(card)) {
 		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
 			   "operation %d\n", __func__,
 			  brcmf_sdcard_regfail(card)));
-		bus->dhd->busstate = DHD_BUS_DOWN;
+		bus->drvr->busstate = DHD_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
 		DHD_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
@@ -4857,7 +4853,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	}
 	card = bus->card;
 
-	if (bus->dhd->busstate == DHD_BUS_DOWN) {
+	if (bus->drvr->busstate == DHD_BUS_DOWN) {
 		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
 			   __func__));
 		return;
@@ -5153,15 +5149,15 @@ brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 }
 #endif				/* SDTEST */
 
-extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *dhdp)
+extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
 	dhd_bus_t *bus;
 
 	DHD_TIMER(("%s: Enter\n", __func__));
 
-	bus = dhdp->bus;
+	bus = drvr->bus;
 
-	if (bus->dhd->dongle_reset)
+	if (bus->drvr->dongle_reset)
 		return false;
 
 	/* Ignore the timer if simulating bus down */
@@ -5209,7 +5205,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *dhdp)
 	}
 #ifdef BCMDBG
 	/* Poll for console output periodically */
-	if (dhdp->busstate == DHD_BUS_DATA && brcmf_console_ms != 0) {
+	if (drvr->busstate == DHD_BUS_DATA && brcmf_console_ms != 0) {
 		bus->console.count += brcmf_watchdog_ms;
 		if (bus->console.count >= brcmf_console_ms) {
 			bus->console.count -= brcmf_console_ms;
@@ -5267,7 +5263,7 @@ static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
 	brcmf_sdbrcm_sdlock(bus);
 
 	/* Don't allow input if dongle is in reset */
-	if (bus->dhd->dongle_reset) {
+	if (bus->drvr->dongle_reset) {
 		brcmf_sdbrcm_sdunlock(bus);
 		return -EPERM;
 	}
@@ -5344,9 +5340,9 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	 */
 	brcmf_txbound = DHD_TXBOUND;
 	brcmf_rxbound = DHD_RXBOUND;
-	dhd_alignctl = true;
+	brcmf_alignctl = true;
 	sd1idle = true;
-	dhd_readahead = true;
+	brcmf_readahead = true;
 	retrydata = false;
 	brcmf_dongle_memsize = 0;
 	dhd_txminmax = DHD_TXMINMAX;
@@ -5472,8 +5468,8 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	/* Attach to the dhd/OS/network interface */
-	bus->dhd = brcmf_attach(bus, SDPCM_RESERVE);
-	if (!bus->dhd) {
+	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
+	if (!bus->drvr) {
 		DHD_ERROR(("%s: dhd_attach failed\n", __func__));
 		goto fail;
 	}
@@ -5504,7 +5500,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	DHD_INFO(("%s: completed!!\n", __func__));
 
 	/* if firmware path present try to download and bring up bus */
-	ret = brcmf_bus_start(bus->dhd);
+	ret = brcmf_bus_start(bus->drvr);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
 			DHD_ERROR(("%s: dongle is not responding\n", __func__));
@@ -5512,7 +5508,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		}
 	}
 	/* Ok, have the per-port tell the stack we're open for business */
-	if (brcmf_net_attach(bus->dhd, 0) != 0) {
+	if (brcmf_net_attach(bus->drvr, 0) != 0) {
 		DHD_ERROR(("%s: Net attach failed!!\n", __func__));
 		goto fail;
 	}
@@ -5622,9 +5618,9 @@ static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *card)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (bus->dhd->maxctl) {
+	if (bus->drvr->maxctl) {
 		bus->rxblen =
-		    roundup((bus->dhd->maxctl + SDPCM_HDRLEN),
+		    roundup((bus->drvr->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
@@ -5672,7 +5668,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card)
 	brcmf_sdcard_cfg_write(card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
-	bus->dhd->busstate = DHD_BUS_DOWN;
+	bus->drvr->busstate = DHD_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
 	bus->prev_rxlim_hit = 0;
@@ -5739,10 +5735,10 @@ static void brcmf_sdbrcm_release(dhd_bus_t *bus)
 		brcmf_sdcard_intr_disable(bus->card);
 		brcmf_sdcard_intr_dereg(bus->card);
 
-		if (bus->dhd) {
-			brcmf_detach(bus->dhd);
+		if (bus->drvr) {
+			brcmf_detach(bus->drvr);
 			brcmf_sdbrcm_release_dongle(bus);
-			bus->dhd = NULL;
+			bus->drvr = NULL;
 		}
 
 		brcmf_sdbrcm_release_malloc(bus);
@@ -5757,7 +5753,7 @@ static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (bus->dhd && bus->dhd->dongle_reset)
+	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
 
 	kfree(bus->rxbuf);
@@ -5772,7 +5768,7 @@ static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (bus->dhd && bus->dhd->dongle_reset)
+	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
 
 	if (bus->ci) {
@@ -5794,7 +5790,7 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (bus) {
-		ASSERT(bus->dhd);
+		ASSERT(bus->drvr);
 		brcmf_sdbrcm_release(bus);
 	}
 
@@ -6054,7 +6050,7 @@ uint dhd_bus_chip(struct dhd_bus *bus)
 
 void *dhd_bus_pub(struct dhd_bus *bus)
 {
-	return bus->dhd;
+	return bus->drvr;
 }
 
 void *dhd_bus_txq(struct dhd_bus *bus)
@@ -6067,16 +6063,16 @@ uint dhd_bus_hdrlen(struct dhd_bus *bus)
 	return SDPCM_HDRLEN;
 }
 
-int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
+int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 {
 	int bcmerror = 0;
 	dhd_bus_t *bus;
 
-	bus = dhdp->bus;
+	bus = drvr->bus;
 
 	if (flag == true) {
 		brcmf_sdbrcm_wd_timer(bus, 0);
-		if (!bus->dhd->dongle_reset) {
+		if (!bus->drvr->dongle_reset) {
 			/* Expect app to have torn down any
 			 connection before calling */
 			/* Stop the bus, disable F2 */
@@ -6086,8 +6082,8 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 			 detach from the dongle */
 			brcmf_sdbrcm_release_dongle(bus);
 
-			bus->dhd->dongle_reset = true;
-			bus->dhd->up = false;
+			bus->drvr->dongle_reset = true;
+			bus->drvr->up = false;
 
 			DHD_TRACE(("%s:  WLAN OFF DONE\n", __func__));
 			/* App can now remove power from device */
@@ -6098,7 +6094,7 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 
 		DHD_TRACE(("\n\n%s: == WLAN ON ==\n", __func__));
 
-		if (bus->dhd->dongle_reset) {
+		if (bus->drvr->dongle_reset) {
 			/* Turn on WLAN */
 
 			/* Attempt to re-attach & download */
@@ -6108,12 +6104,10 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 				/* Attempt to download binary to the dongle */
 				if (brcmf_sdbrcm_probe_init(bus, bus->card)) {
 					/* Re-init bus, enable F2 transfer */
-					brcmf_sdbrcm_bus_init(
-						(struct brcmf_pub *) bus->dhd,
-						false);
+					brcmf_sdbrcm_bus_init(bus->drvr, false);
 
-					bus->dhd->dongle_reset = false;
-					bus->dhd->up = true;
+					bus->drvr->dongle_reset = false;
+					bus->drvr->up = true;
 
 					DHD_TRACE(("%s: WLAN ON DONE\n",
 						   __func__));
@@ -6565,10 +6559,10 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (kthread_should_stop())
 			break;
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
-			if (bus->dhd->dongle_reset == false)
-				brcmf_sdbrcm_bus_watchdog(bus->dhd);
+			if (bus->drvr->dongle_reset == false)
+				brcmf_sdbrcm_bus_watchdog(bus->drvr);
 			/* Count the tick for reference */
-			bus->dhd->tickcnt++;
+			bus->drvr->tickcnt++;
 		} else
 			break;
 	}
@@ -6586,10 +6580,10 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 		else
 			return;
 	} else {
-		brcmf_sdbrcm_bus_watchdog(bus->dhd);
+		brcmf_sdbrcm_bus_watchdog(bus->drvr);
 
 		/* Count the tick for reference */
-		bus->dhd->tickcnt++;
+		bus->drvr->tickcnt++;
 	}
 
 	/* Reschedule the watchdog */
@@ -6603,7 +6597,7 @@ brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick)
 	static uint save_ms;
 
 	/* don't start the wd until fw is loaded */
-	if (bus->dhd->busstate == DHD_BUS_DOWN)
+	if (bus->drvr->busstate == DHD_BUS_DOWN)
 		return;
 
 	/* Totally stop the timer */
@@ -6662,7 +6656,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
 			/* Call bus dpc unless it indicated down
 			(then clean stop) */
-			if (bus->dhd->busstate != DHD_BUS_DOWN) {
+			if (bus->drvr->busstate != DHD_BUS_DOWN) {
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
@@ -6679,7 +6673,7 @@ static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
 	dhd_bus_t *bus = (dhd_bus_t *) data;
 
 	/* Call bus dpc unless it indicated down (then clean stop) */
-	if (bus->dhd->busstate != DHD_BUS_DOWN) {
+	if (bus->drvr->busstate != DHD_BUS_DOWN) {
 		if (brcmf_sdbrcm_dpc(bus))
 			tasklet_schedule(&bus->tasklet);
 	} else
-- 
1.7.1


