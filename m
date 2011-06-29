Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1910 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1F2XtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:19 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 091/119] staging: brcm80211: rename struct dhd_pub to
 struct brcmf_pub
Date: Wed, 29 Jun 2011 16:47:55 -0700
Message-ID: <1309391303-22741-92-git-send-email-frankyl@broadcom.com> (sfid-20110630_015227_696082_DCD7C607)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The structure dhd_pub has been renamed to have more consistent naming
in the fullmac driver. This also remove the type definition for this
structure.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   71 ++++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h    |    9 ++-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |   34 ++++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   26 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   41 +++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h  |   35 ++++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   32 ++++++-----
 7 files changed, 129 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 196b372..d063afb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -521,13 +521,13 @@ struct brcmf_ioctl {
 	uint needed;		/* bytes needed (optional) */
 };
 
-/* Forward decls for struct dhd_pub (see below) */
+/* Forward decls for struct brcmf_pub (see below) */
 struct dhd_bus;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_info;	/* device driver info */
 
 /* Common structure for module and instance linkage */
-typedef struct dhd_pub {
+struct brcmf_pub {
 	/* Linkage ponters */
 	struct dhd_bus *bus;
 	struct brcmf_proto *prot;
@@ -593,7 +593,7 @@ typedef struct dhd_pub {
 	u8 country_code[WLC_CNTRY_BUF_SZ];
 	char eventmask[BRCMF_EVENTING_MASK_LEN];
 
-} dhd_pub_t;
+};
 
 struct brcmf_if_event {
 	u8 ifidx;
@@ -708,27 +708,27 @@ extern const bcmevent_name_t bcmevent_names[];
 extern const int bcmevent_names_size;
 
 
-static inline void MUTEX_LOCK_INIT(dhd_pub_t *dhdp)
+static inline void MUTEX_LOCK_INIT(struct brcmf_pub *dhdp)
 {
 }
 
-static inline void MUTEX_LOCK(dhd_pub_t *dhdp)
+static inline void MUTEX_LOCK(struct brcmf_pub *dhdp)
 {
 }
 
-static inline void MUTEX_UNLOCK(dhd_pub_t *dhdp)
+static inline void MUTEX_UNLOCK(struct brcmf_pub *dhdp)
 {
 }
 
-static inline void MUTEX_LOCK_SOFTAP_SET_INIT(dhd_pub_t *dhdp)
+static inline void MUTEX_LOCK_SOFTAP_SET_INIT(struct brcmf_pub *dhdp)
 {
 }
 
-static inline void MUTEX_LOCK_SOFTAP_SET(dhd_pub_t *dhdp)
+static inline void MUTEX_LOCK_SOFTAP_SET(struct brcmf_pub *dhdp)
 {
 }
 
-static inline void MUTEX_UNLOCK_SOFTAP_SET(dhd_pub_t *dhdp)
+static inline void MUTEX_UNLOCK_SOFTAP_SET(struct brcmf_pub *dhdp)
 {
 }
 
@@ -749,58 +749,58 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
  */
 
 /* Indication from bus module regarding presence/insertion of dongle.
- * Return dhd_pub_t pointer, used as handle to OS module in later calls.
+ * Return struct brcmf_pub pointer, used as handle to OS module in later calls.
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern dhd_pub_t *brcmf_attach(struct dhd_bus *bus,
+extern struct brcmf_pub *brcmf_attach(struct dhd_bus *bus,
 				uint bus_hdrlen);
-extern int brcmf_net_attach(dhd_pub_t *dhdp, int idx);
+extern int brcmf_net_attach(struct brcmf_pub *dhdp, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
 
 /* Indication from bus module regarding removal/absence of dongle */
-extern void brcmf_detach(dhd_pub_t *dhdp);
+extern void brcmf_detach(struct brcmf_pub *dhdp);
 
 /* Indication from bus module to change flow-control state */
-extern void brcmf_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool on);
+extern void brcmf_txflowcontrol(struct brcmf_pub *dhdp, int ifidx, bool on);
 
-extern bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q,
+extern bool brcmf_c_prec_enq(struct brcmf_pub *dhdp, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx,
+extern void brcmf_rx_frame(struct brcmf_pub *dhdp, int ifidx,
 			 struct sk_buff *rxp, int numpkt);
 
 /* Return pointer to interface name */
-extern char *brcmf_ifname(dhd_pub_t *dhdp, int idx);
+extern char *brcmf_ifname(struct brcmf_pub *dhdp, int idx);
 
 /* Request scheduling of the bus dpc */
-extern void brcmf_sched_dpc(dhd_pub_t *dhdp);
+extern void brcmf_sched_dpc(struct brcmf_pub *dhdp);
 
 /* Notify tx completion */
-extern void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp,
+extern void brcmf_txcomplete(struct brcmf_pub *dhdp, struct sk_buff *txp,
 			     bool success);
 
 /* Query ioctl */
-extern int brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
-				       void *buf, uint len);
+extern int brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx,
+				       uint cmd, void *buf, uint len);
 
 /* OS independent layer functions */
-extern int brcmf_os_proto_block(dhd_pub_t *pub);
-extern int brcmf_os_proto_unblock(dhd_pub_t *pub);
-extern int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition,
+extern int brcmf_os_proto_block(struct brcmf_pub *pub);
+extern int brcmf_os_proto_unblock(struct brcmf_pub *pub);
+extern int brcmf_os_ioctl_resp_wait(struct brcmf_pub *pub, uint *condition,
 				  bool *pending);
-extern int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub);
+extern int brcmf_os_ioctl_resp_wake(struct brcmf_pub *pub);
 extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
 extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
-extern void brcmf_os_sdlock_sndup_rxq(dhd_pub_t *pub);
+extern void brcmf_os_sdlock_sndup_rxq(struct brcmf_pub *pub);
 extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
 extern int brcmf_custom_get_mac_address(unsigned char *buf);
-extern void brcmf_os_sdunlock_sndup_rxq(dhd_pub_t *pub);
-extern void brcmf_os_sdlock_eventq(dhd_pub_t *pub);
-extern void brcmf_os_sdunlock_eventq(dhd_pub_t *pub);
+extern void brcmf_os_sdunlock_sndup_rxq(struct brcmf_pub *pub);
+extern void brcmf_os_sdlock_eventq(struct brcmf_pub *pub);
+extern void brcmf_os_sdunlock_eventq(struct brcmf_pub *pub);
 #ifdef BCMDBG
-extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
+extern int brcmf_write_to_file(struct brcmf_pub *dhd, u8 *buf, int size);
 #endif				/* BCMDBG */
 
 extern void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec);
@@ -825,13 +825,14 @@ extern void brcmf_vif_sendup(struct brcmf_info *dhd, int ifidx,
 			     unsigned char *cp, int len);
 
 /* Send packet to dongle via data channel */
-extern int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
+extern int brcmf_sendpkt(struct brcmf_pub *dhdp, int ifidx,\
+			 struct sk_buff *pkt);
 
-extern int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag);
-extern int brcmf_bus_start(dhd_pub_t *dhdp);
+extern int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag);
+extern int brcmf_bus_start(struct brcmf_pub *dhdp);
 
-extern void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
-extern void brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg,
+extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *dhd, char *arg);
+extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *dhd, char *arg,
 					     int enable, int master_mode);
 
 #ifdef BCMDBG
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index c895b81..95fcef4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -40,7 +40,7 @@ extern void dhd_bus_unregister(void);
 extern void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
 
 /* Initialize bus module: prepare for communication w/dongle */
-extern int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex);
+extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
 extern int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *txp);
@@ -58,15 +58,16 @@ extern void dhd_bus_isr(bool *InterruptRecognized,
 			bool *QueueMiniportHandleInterrupt, void *arg);
 
 /* Check for and handle local prot-specific iovar commands */
-extern int brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
+extern int brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *dhdp, const char *name,
 			    void *params, int plen, void *arg, int len,
 			    bool set);
 
 /* Add bus dump output to a buffer */
-extern void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
+extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp,
+				  struct brcmu_strbuf *strbuf);
 
 /* Clear any bus counters */
-extern void dhd_bus_clearcounts(dhd_pub_t *dhdp);
+extern void dhd_bus_clearcounts(struct brcmf_pub *dhdp);
 
 /* return the dongle chipid */
 extern uint dhd_bus_chip(struct dhd_bus *bus);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index a336068..15c2904 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -100,7 +100,7 @@ struct brcmf_proto {
 	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
 };
 
-static int brcmf_proto_cdc_msg(dhd_pub_t *dhd)
+static int brcmf_proto_cdc_msg(struct brcmf_pub *dhd)
 {
 	struct brcmf_proto *prot = dhd->prot;
 	int len = le32_to_cpu(prot->msg.len) +
@@ -120,7 +120,7 @@ static int brcmf_proto_cdc_msg(dhd_pub_t *dhd)
 				      len);
 }
 
-static int brcmf_proto_cdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
+static int brcmf_proto_cdc_cmplt(struct brcmf_pub *dhd, u32 id, u32 len)
 {
 	int ret;
 	struct brcmf_proto *prot = dhd->prot;
@@ -139,8 +139,8 @@ static int brcmf_proto_cdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 }
 
 int
-brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			    uint len)
+brcmf_proto_cdc_query_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
+			    void *buf, uint len)
 {
 	struct brcmf_proto *prot = dhd->prot;
 	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
@@ -221,7 +221,7 @@ done:
 	return ret;
 }
 
-int brcmf_proto_cdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
+int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 			      void *buf, uint len)
 {
 	struct brcmf_proto *prot = dhd->prot;
@@ -275,8 +275,8 @@ done:
 
 extern int dhd_bus_interface(struct dhd_bus *bus, uint arg, void *arg2);
 int
-brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, struct brcmf_ioctl *ioc, void *buf,
-		  int len)
+brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx, struct brcmf_ioctl *ioc,
+		  void *buf, int len)
 {
 	struct brcmf_proto *prot = dhd->prot;
 	int ret = -1;
@@ -356,18 +356,19 @@ done:
 	skb->ip_summed is overloaded */
 
 int
-brcmf_proto_iovar_op(dhd_pub_t *dhdp, const char *name,
+brcmf_proto_iovar_op(struct brcmf_pub *dhdp, const char *name,
 		  void *params, int plen, void *arg, int len, bool set)
 {
 	return -ENOTSUPP;
 }
 
-void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_proto_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 {
 	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", dhdp->prot->reqid);
 }
 
-void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
+void brcmf_proto_hdrpush(struct brcmf_pub *dhd, int ifidx,
+			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
 
@@ -389,7 +390,8 @@ void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
+int brcmf_proto_hdrpull(struct brcmf_pub *dhd, int *ifidx,
+			struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
 
@@ -433,7 +435,7 @@ int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	return 0;
 }
 
-int brcmf_proto_attach(dhd_pub_t *dhd)
+int brcmf_proto_attach(struct brcmf_pub *dhd)
 {
 	struct brcmf_proto *cdc;
 
@@ -461,13 +463,13 @@ fail:
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
-void brcmf_proto_detach(dhd_pub_t *dhd)
+void brcmf_proto_detach(struct brcmf_pub *dhd)
 {
 	kfree(dhd->prot);
 	dhd->prot = NULL;
 }
 
-void brcmf_proto_dstats(dhd_pub_t *dhd)
+void brcmf_proto_dstats(struct brcmf_pub *dhd)
 {
 	/* No stats from dongle added yet, copy bus stats */
 	dhd->dstats.tx_packets = dhd->tx_packets;
@@ -479,7 +481,7 @@ void brcmf_proto_dstats(dhd_pub_t *dhd)
 	return;
 }
 
-int brcmf_proto_init(dhd_pub_t *dhd)
+int brcmf_proto_init(struct brcmf_pub *dhd)
 {
 	int ret = 0;
 	char buf[128];
@@ -508,7 +510,7 @@ int brcmf_proto_init(dhd_pub_t *dhd)
 	return ret;
 }
 
-void brcmf_proto_stop(dhd_pub_t *dhd)
+void brcmf_proto_stop(struct brcmf_pub *dhd)
 {
 	/* Nothing to do for CDC */
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5c3a5cf..fc361d1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -111,7 +111,7 @@ void brcmf_c_init(void)
 	brcmf_msg_level = BRCMF_ERROR_VAL;
 }
 
-static int brcmf_c_dump(dhd_pub_t *drvr, char *buf, int buflen)
+static int brcmf_c_dump(struct brcmf_pub *drvr, char *buf, int buflen)
 {
 	struct brcmu_strbuf b;
 	struct brcmu_strbuf *strbuf = &b;
@@ -169,9 +169,9 @@ static int brcmf_c_dump(dhd_pub_t *drvr, char *buf, int buflen)
 }
 
 static int
-brcmf_c_doiovar(dhd_pub_t *drvr, const struct brcmu_iovar *vi, u32 actionid,
-	    const char *name, void *params, int plen, void *arg, int len,
-	    int val_size)
+brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
+		u32 actionid, const char *name, void *params, int plen,
+		void *arg, int len, int val_size)
 {
 	int bcmerror = 0;
 	s32 int_val = 0;
@@ -252,8 +252,8 @@ exit:
 	return bcmerror;
 }
 
-bool brcmf_c_prec_enq(dhd_pub_t *drvr, struct pktq *q, struct sk_buff *pkt,
-		  int prec)
+bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
+		      struct sk_buff *pkt, int prec)
 {
 	struct sk_buff *p;
 	int eprec = -1;		/* precedence to evict from */
@@ -307,7 +307,7 @@ bool brcmf_c_prec_enq(dhd_pub_t *drvr, struct pktq *q, struct sk_buff *pkt,
 }
 
 static int
-brcmf_c_iovar_op(dhd_pub_t *drvr, const char *name,
+brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 	     void *params, int plen, void *arg, int len, bool set)
 {
 	int bcmerror = 0;
@@ -360,7 +360,7 @@ exit:
 	return bcmerror;
 }
 
-int brcmf_c_ioctl(dhd_pub_t *drvr, struct brcmf_c_ioctl *ioc, void *buf,
+int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 		  uint buflen)
 {
 	int bcmerror = 0;
@@ -877,7 +877,7 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 }
 
 void
-brcmf_c_pktfilter_offload_enable(dhd_pub_t *drvr, char *arg, int enable,
+brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 			     int master_mode)
 {
 	char *argv[8];
@@ -948,7 +948,7 @@ fail:
 	kfree(arg_org);
 }
 
-void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
+void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 {
 	const char *str;
 	struct brcmf_pkt_filter pkt_filter;
@@ -1084,7 +1084,7 @@ fail:
 	kfree(buf);
 }
 
-void brcmf_c_arp_offload_set(dhd_pub_t *drvr, int arp_mode)
+void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
@@ -1101,7 +1101,7 @@ void brcmf_c_arp_offload_set(dhd_pub_t *drvr, int arp_mode)
 			   __func__, arp_mode));
 }
 
-void brcmf_c_arp_offload_enable(dhd_pub_t *drvr, int arp_enable)
+void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
@@ -1118,7 +1118,7 @@ void brcmf_c_arp_offload_enable(dhd_pub_t *drvr, int arp_enable)
 			   __func__, arp_enable));
 }
 
-int brcmf_c_preinit_ioctls(dhd_pub_t *drvr)
+int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 {
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 86a6adb..29ed98a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -76,7 +76,7 @@ struct brcmf_if {
 
 /* Local private structure (extension of pub) */
 struct brcmf_info {
-	dhd_pub_t pub;
+	struct brcmf_pub pub;
 
 	/* OS/stack specifics */
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
@@ -187,7 +187,7 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
-static void brcmf_set_packet_filter(int value, dhd_pub_t *drvr)
+static void brcmf_set_packet_filter(int value, struct brcmf_pub *drvr)
 {
 	DHD_TRACE(("%s: %d\n", __func__, value));
 	/* 1 - Enable packet filter, only allow unicast packet to send up */
@@ -206,7 +206,7 @@ static void brcmf_set_packet_filter(int value, dhd_pub_t *drvr)
 }
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-static int brcmf_set_suspend(int value, dhd_pub_t *drvr)
+static int brcmf_set_suspend(int value, struct brcmf_pub *drvr)
 {
 	int power_mode = PM_MAX;
 	/* struct wl_pkt_filter_enable       enable_parm; */
@@ -273,7 +273,7 @@ static int brcmf_set_suspend(int value, dhd_pub_t *drvr)
 
 static void brcmf_suspend_resume_helper(struct brcmf_info *drvr_priv, int val)
 {
-	dhd_pub_t *drvr = &drvr_priv->pub;
+	struct brcmf_pub *drvr = &drvr_priv->pub;
 
 	brcmf_os_proto_block(drvr);
 	/* Set flag when early suspend was called */
@@ -398,7 +398,7 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 	return i;		/* default - the primary interface */
 }
 
-char *brcmf_ifname(dhd_pub_t *drvr, int ifidx)
+char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
@@ -753,7 +753,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 	up(&drvr_priv->sysioc_sem);
 }
 
-int brcmf_sendpkt(dhd_pub_t *drvr, int ifidx, struct sk_buff *pktbuf)
+int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
@@ -832,7 +832,7 @@ done:
 	return 0;
 }
 
-void brcmf_txflowcontrol(dhd_pub_t *drvr, int ifidx, bool state)
+void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 {
 	struct net_device *net;
 	struct brcmf_info *drvr_priv = drvr->info;
@@ -848,7 +848,7 @@ void brcmf_txflowcontrol(dhd_pub_t *drvr, int ifidx, bool state)
 		netif_wake_queue(net);
 }
 
-void brcmf_rx_frame(dhd_pub_t *drvr, int ifidx, struct sk_buff *skb,
+void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		  int numpkt)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
@@ -938,7 +938,7 @@ void brcmf_event(struct brcmf_info *drvr_priv, char *evpkt, int evlen, int ifidx
 	return;
 }
 
-void brcmf_txcomplete(dhd_pub_t *drvr, struct sk_buff *txp, bool success)
+void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
 	struct brcmf_info *drvr_priv = drvr->info;
@@ -1426,7 +1426,7 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 	up(&drvr_priv->sysioc_sem);
 }
 
-dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
+struct brcmf_pub *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 {
 	struct brcmf_info *drvr_priv = NULL;
 	struct net_device *net;
@@ -1535,7 +1535,7 @@ fail:
 	return NULL;
 }
 
-int brcmf_bus_start(dhd_pub_t *drvr)
+int brcmf_bus_start(struct brcmf_pub *drvr)
 {
 	int ret = -1;
 	struct brcmf_info *drvr_priv = drvr->info;
@@ -1599,7 +1599,7 @@ int brcmf_bus_start(dhd_pub_t *drvr)
 	return 0;
 }
 
-int brcmf_iovar(dhd_pub_t *drvr, int ifidx, char *name, char *cmd_buf,
+int brcmf_iovar(struct brcmf_pub *drvr, int ifidx, char *name, char *cmd_buf,
 	  uint cmd_len, int set)
 {
 	char buf[strlen(name) + 1 + cmd_len];
@@ -1633,7 +1633,7 @@ static struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_multicast_list = brcmf_netdev_set_multicast_list
 };
 
-int brcmf_net_attach(dhd_pub_t *drvr, int ifidx)
+int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 	struct net_device *net;
@@ -1689,7 +1689,7 @@ fail:
 	return -EBADE;
 }
 
-static void brcmf_bus_detach(dhd_pub_t *drvr)
+static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
@@ -1707,7 +1707,7 @@ static void brcmf_bus_detach(dhd_pub_t *drvr)
 	}
 }
 
-void brcmf_detach(dhd_pub_t *drvr)
+void brcmf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
@@ -1788,7 +1788,7 @@ module_exit(brcmf_module_cleanup);
 /*
  * OS specific functions required to implement DHD driver in OS independent way
  */
-int brcmf_os_proto_block(dhd_pub_t *drvr)
+int brcmf_os_proto_block(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
@@ -1799,7 +1799,7 @@ int brcmf_os_proto_block(dhd_pub_t *drvr)
 	return 0;
 }
 
-int brcmf_os_proto_unblock(dhd_pub_t *drvr)
+int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
@@ -1821,7 +1821,8 @@ void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
 	brcmf_ioctl_timeout_msec = (int)timeout_msec;
 }
 
-int brcmf_os_ioctl_resp_wait(dhd_pub_t *drvr, uint *condition, bool *pending)
+int brcmf_os_ioctl_resp_wait(struct brcmf_pub *drvr, uint *condition,
+			     bool *pending)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1846,7 +1847,7 @@ int brcmf_os_ioctl_resp_wait(dhd_pub_t *drvr, uint *condition, bool *pending)
 	return timeout;
 }
 
-int brcmf_os_ioctl_resp_wake(dhd_pub_t *drvr)
+int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 
@@ -1976,7 +1977,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 }
 
 #ifdef BCMDBG
-int brcmf_write_to_file(dhd_pub_t *drvr, u8 *buf, int size)
+int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size)
 {
 	int ret = 0;
 	struct file *fp;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index c78ae94..afec597 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -30,48 +30,51 @@
  */
 
 /* Linkage, sets prot link and updates hdrlen in pub */
-extern int brcmf_proto_attach(dhd_pub_t *dhdp);
+extern int brcmf_proto_attach(struct brcmf_pub *dhdp);
 
 /* Unlink, frees allocated protocol memory (including dhd_prot) */
-extern void brcmf_proto_detach(dhd_pub_t *dhdp);
+extern void brcmf_proto_detach(struct brcmf_pub *dhdp);
 
 /* Initialize protocol: sync w/dongle state.
  * Sets dongle media info (iswl, drv_version, mac address).
  */
-extern int brcmf_proto_init(dhd_pub_t *dhdp);
+extern int brcmf_proto_init(struct brcmf_pub *dhdp);
 
 /* Stop protocol: sync w/dongle state. */
-extern void brcmf_proto_stop(dhd_pub_t *dhdp);
+extern void brcmf_proto_stop(struct brcmf_pub *dhdp);
 
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
  */
-extern void brcmf_proto_hdrpush(dhd_pub_t *, int ifidx, struct sk_buff *txp);
+extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
+				struct sk_buff *txp);
 
 /* Remove any protocol-specific data header. */
-extern int brcmf_proto_hdrpull(dhd_pub_t *, int *ifidx, struct sk_buff *rxp);
+extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
+			       struct sk_buff *rxp);
 
 /* Use protocol to issue ioctl to dongle */
-extern int brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, struct brcmf_ioctl *ioc,
-			     void *buf, int len);
+extern int brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx,
+			     struct brcmf_ioctl *ioc, void *buf, int len);
 
 /* Check for and handle local prot-specific iovar commands */
-extern int brcmf_proto_iovar_op(dhd_pub_t *dhdp, const char *name,
-			     void *params, int plen, void *arg, int len,
-			     bool set);
+extern int brcmf_proto_iovar_op(struct brcmf_pub *dhdp, const char *name,
+				void *params, int plen, void *arg, int len,
+				bool set);
 
 /* Add prot dump output to a buffer */
-extern void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
+extern void brcmf_proto_dump(struct brcmf_pub *dhdp,
+			     struct brcmu_strbuf *strbuf);
 
 /* Update local copy of dongle statistics */
-extern void brcmf_proto_dstats(dhd_pub_t *dhdp);
+extern void brcmf_proto_dstats(struct brcmf_pub *dhdp);
 
-extern int brcmf_c_ioctl(dhd_pub_t *dhd_pub, struct brcmf_c_ioctl *ioc,
+extern int brcmf_c_ioctl(struct brcmf_pub *dhd_pub, struct brcmf_c_ioctl *ioc,
 			 void *buf, uint buflen);
 
-extern int brcmf_c_preinit_ioctls(dhd_pub_t *dhd);
+extern int brcmf_c_preinit_ioctls(struct brcmf_pub *dhd);
 
-extern int brcmf_proto_cdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
+extern int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *dhd, int ifidx, uint cmd,
 				     void *buf, uint len);
 
 #endif				/* _dhd_proto_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ab96d37..da5a2ff 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
+#include <linux/semaphore.h>
 #include <linux/firmware.h>
 #include <asm/unaligned.h>
 #include <defs.h>
@@ -455,7 +456,7 @@ struct chip_info {
 
 /* Private data for SDIO bus interaction */
 typedef struct dhd_bus {
-	dhd_pub_t *dhd;
+	struct brcmf_pub *dhd;
 
 	struct brcmf_sdio *sdh;	/* Handle for BCMSDH calls */
 	struct chip_info *ci;	/* Chip info struct */
@@ -782,8 +783,8 @@ static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start);
 #endif
 
 #ifdef BCMDBG
-static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
-				       uint msglen);
+static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
+				       unsigned char *msg, uint msglen);
 static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size);
 static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus);
 #endif				/* BCMDBG  */
@@ -1425,7 +1426,7 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 	uint datalen;
 	u8 tx_prec_map;
 
-	dhd_pub_t *dhd = bus->dhd;
+	struct brcmf_pub *dhd = bus->dhd;
 	struct sdpcmd_regs *regs = bus->regs;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -1792,7 +1793,7 @@ dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 	}
 }
 
-void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 {
 	dhd_bus_t *bus = dhdp->bus;
 
@@ -1893,7 +1894,7 @@ void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 		    bus->sleeping);
 }
 
-void dhd_bus_clearcounts(dhd_pub_t *dhdp)
+void dhd_bus_clearcounts(struct brcmf_pub *dhdp)
 {
 	dhd_bus_t *bus = (dhd_bus_t *) dhdp->bus;
 
@@ -2802,7 +2803,7 @@ exit:
 	brcmf_sdbrcm_sdunlock(bus);
 
 	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
-		brcmf_c_preinit_ioctls((dhd_pub_t *) bus->dhd);
+		brcmf_c_preinit_ioctls((struct brcmf_pub *) bus->dhd);
 
 	return bcmerror;
 }
@@ -2948,7 +2949,7 @@ fail:
 }
 
 int
-brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
+brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *dhdp, const char *name,
 			  void *params, int plen, void *arg, int len, bool set)
 {
 	dhd_bus_t *bus = dhdp->bus;
@@ -3127,7 +3128,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 #endif		/* defined(OOB_INTR_ONLY) */
 }
 
-int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
+int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 {
 	dhd_bus_t *bus = dhdp->bus;
 	struct brcmf_timeout tmo;
@@ -5059,7 +5060,7 @@ brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 }
 #endif				/* SDTEST */
 
-extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
+extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *dhdp)
 {
 	dhd_bus_t *bus;
 
@@ -5157,10 +5158,10 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 }
 
 #ifdef BCMDBG
-static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
-				       uint msglen)
+static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
+				       unsigned char *msg, uint msglen)
 {
-	dhd_bus_t *bus = dhdp->bus;
+	dhd_bus_t *bus = drvr->bus;
 	u32 addr, val;
 	int rv;
 	struct sk_buff *pkt;
@@ -5973,7 +5974,7 @@ uint dhd_bus_hdrlen(struct dhd_bus *bus)
 	return SDPCM_HDRLEN;
 }
 
-int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
+int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 {
 	int bcmerror = 0;
 	dhd_bus_t *bus;
@@ -6017,7 +6018,8 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 				if (brcmf_sdbrcm_probe_init(bus, bus->sdh)) {
 					/* Re-init bus, enable F2 transfer */
 					brcmf_sdbrcm_bus_init(
-						(dhd_pub_t *) bus->dhd, false);
+						(struct brcmf_pub *) bus->dhd,
+						false);
 
 					bus->dhd->dongle_reset = false;
 					bus->dhd->up = true;
-- 
1.7.1


