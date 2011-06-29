Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2035 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab1F2Xs4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 039/119] staging: brcm80211: rename functions and
 variables in dhd_common.c
Date: Wed, 29 Jun 2011 16:47:03 -0700
Message-ID: <1309391303-22741-40-git-send-email-frankyl@broadcom.com> (sfid-20110630_015117_294990_536E19A4)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The naming convention of the drivers is to be made consistent. This
commit fixes the function in dhd_common.c and use the new names from
the calling code.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   16 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   90 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h    |   56 +++++++-------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   26 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h  |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |    8 +-
 7 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 4fcdf9d..b16ffc2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -875,8 +875,8 @@ extern uint dhd_pktgen_len;
 #define MAX_PKTGEN_LEN 1800
 #endif
 
-extern char fw_path[MOD_PARAM_PATHLEN];
-extern char nv_path[MOD_PARAM_PATHLEN];
+extern char brcmf_fw_path[MOD_PARAM_PATHLEN];
+extern char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
 extern u32 g_assert_type;
 extern const bcmevent_name_t bcmevent_names[];
@@ -938,7 +938,7 @@ extern void dhd_detach(dhd_pub_t *dhdp);
 /* Indication from bus module to change flow-control state */
 extern void dhd_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool on);
 
-extern bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q,
+extern bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
@@ -992,10 +992,10 @@ extern int dhd_timeout_expired(dhd_timeout_t *tmo);
 
 extern int dhd_ifname2idx(struct dhd_info *dhd, char *name);
 extern u8 *dhd_bssidx2bssid(dhd_pub_t *dhd, int idx);
-extern int wl_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
+extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
 			 wl_event_msg_t *, void **data_ptr);
 
-extern void dhd_common_init(void);
+extern void brcmf_c_init(void);
 
 extern int dhd_add_if(struct dhd_info *dhd, int ifidx, void *handle,
 		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
@@ -1022,9 +1022,9 @@ extern void dhd_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
 extern void dhd_wait_event_wakeup(dhd_pub_t *dhd);
 
 #ifdef PKT_FILTER_SUPPORT
-extern void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
-extern void dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
-					 int master_mode);
+extern void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
+extern void brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg,
+					     int enable, int master_mode);
 #endif
 
 #ifdef BCMDBG
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 1d94438..af78764 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -513,7 +513,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 	dhd_os_proto_unblock(dhd);
 
 #ifdef EMBEDDED_PLATFORM
-	ret = dhd_preinit_ioctls(dhd);
+	ret = brcmf_c_preinit_ioctls(dhd);
 #endif				/* EMBEDDED_PLATFORM */
 
 	/* Always assumes wl for now */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index cb7e455..849203c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -31,9 +31,9 @@
 #define DOT11_OUI_LEN			3
 #define BCMILCP_BCM_SUBTYPE_EVENT		1
 
-int dhd_msg_level;
-char fw_path[MOD_PARAM_PATHLEN];
-char nv_path[MOD_PARAM_PATHLEN];
+int brcmf_msg_level;
+char brcmf_fw_path[MOD_PARAM_PATHLEN];
+char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
 extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			    uint len);
@@ -54,11 +54,11 @@ void dhd_iscan_unlock(void);
 #define MSGTRACE_VERSION	1
 
 #ifdef DHD_DEBUG
-const char dhd_version[] =
+const char brcmf_version[] =
 "Dongle Host Driver, version " EPI_VERSION_STR "\nCompiled on " __DATE__
 " at " __TIME__;
 #else
-const char dhd_version[] = "Dongle Host Driver, version " EPI_VERSION_STR;
+const char brcmf_version[] = "Dongle Host Driver, version " EPI_VERSION_STR;
 #endif
 
 /* IOVar table */
@@ -82,8 +82,8 @@ enum {
 	IOV_LAST
 };
 
-const struct brcmu_iovar dhd_iovars[] = {
-	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(dhd_version)}
+const struct brcmu_iovar brcmf_iovars[] = {
+	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(brcmf_version)}
 	,
 #ifdef DHD_DEBUG
 	{"msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0}
@@ -128,7 +128,7 @@ struct msgtrace_hdr {
 				 because of trace overflow */
 } __packed;
 
-void dhd_common_init(void)
+void brcmf_c_init(void)
 {
 	/* Init global variables at run-time, not as part of the declaration.
 	 * This is required to support init/de-init of the driver.
@@ -138,20 +138,21 @@ void dhd_common_init(void)
 	 * first time that the driver is initialized vs subsequent
 	 * initializations.
 	 */
-	dhd_msg_level = DHD_ERROR_VAL;
+	brcmf_msg_level = DHD_ERROR_VAL;
 #ifdef CONFIG_BCM4329_FW_PATH
-	strncpy(fw_path, CONFIG_BCM4329_FW_PATH, MOD_PARAM_PATHLEN - 1);
+	strncpy(brcmf_fw_path, CONFIG_BCM4329_FW_PATH, MOD_PARAM_PATHLEN - 1);
 #else
-	fw_path[0] = '\0';
+	brcmf_fw_path[0] = '\0';
 #endif
 #ifdef CONFIG_BCM4329_NVRAM_PATH
-	strncpy(nv_path, CONFIG_BCM4329_NVRAM_PATH, MOD_PARAM_PATHLEN - 1);
+	strncpy(brcmf_nv_path,
+		CONFIG_BCM4329_NVRAM_PATH, MOD_PARAM_PATHLEN - 1);
 #else
-	nv_path[0] = '\0';
+	brcmf_nv_path[0] = '\0';
 #endif
 }
 
-static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
+static int brcmf_c_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 {
 	struct brcmu_strbuf b;
 	struct brcmu_strbuf *strbuf = &b;
@@ -159,7 +160,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	brcmu_binit(strbuf, buf, buflen);
 
 	/* Base DHD info */
-	brcmu_bprintf(strbuf, "%s\n", dhd_version);
+	brcmu_bprintf(strbuf, "%s\n", brcmf_version);
 	brcmu_bprintf(strbuf, "\n");
 	brcmu_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
 		    dhdp->up, dhdp->txoff, dhdp->busstate);
@@ -209,7 +210,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 }
 
 static int
-dhd_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
+brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 	    const char *name, void *params, int plen, void *arg, int len,
 	    int val_size)
 {
@@ -228,16 +229,16 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 	switch (actionid) {
 	case IOV_GVAL(IOV_VERSION):
 		/* Need to have checked buffer length */
-		strncpy((char *)arg, dhd_version, len);
+		strncpy((char *)arg, brcmf_version, len);
 		break;
 
 	case IOV_GVAL(IOV_MSGLEVEL):
-		int_val = (s32) dhd_msg_level;
+		int_val = (s32) brcmf_msg_level;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_MSGLEVEL):
-		dhd_msg_level = int_val;
+		brcmf_msg_level = int_val;
 		break;
 
 	case IOV_GVAL(IOV_BCMERRORSTR):
@@ -265,7 +266,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_DUMP):
-		bcmerror = dhd_dump(dhd_pub, arg, len);
+		bcmerror = brcmf_c_dump(dhd_pub, arg, len);
 		break;
 
 #ifdef DHD_DEBUG
@@ -322,7 +323,7 @@ exit:
 	return bcmerror;
 }
 
-bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
+bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 		  int prec)
 {
 	struct sk_buff *p;
@@ -377,7 +378,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 }
 
 static int
-dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
+brcmf_c_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 	     void *params, int plen, void *arg, int len, bool set)
 {
 	int bcmerror = 0;
@@ -396,7 +397,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 	/* Set does NOT take qualifiers */
 	ASSERT(!set || (!params && !plen));
 
-	vi = brcmu_iovar_lookup(dhd_iovars, name);
+	vi = brcmu_iovar_lookup(brcmf_iovars, name);
 	if (vi == NULL) {
 		bcmerror = -ENOTSUPP;
 		goto exit;
@@ -423,14 +424,14 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 
 	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
 	bcmerror =
-	    dhd_doiovar(dhd_pub, vi, actionid, name, params, plen, arg, len,
+	    brcmf_c_doiovar(dhd_pub, vi, actionid, name, params, plen, arg, len,
 			val_size);
 
 exit:
 	return bcmerror;
 }
 
-int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
+int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 {
 	int bcmerror = 0;
 
@@ -474,13 +475,12 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 			/* call with the appropriate arguments */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror =
-				    dhd_iovar_op(dhd_pub, buf, arg, arglen, buf,
-						 buflen, IOV_GET);
+				bcmerror = brcmf_c_iovar_op(dhd_pub, buf, arg,
+						arglen, buf, buflen, IOV_GET);
 			else
 				bcmerror =
-				    dhd_iovar_op(dhd_pub, buf, NULL, 0, arg,
-						 arglen, IOV_SET);
+				    brcmf_c_iovar_op(dhd_pub, buf, NULL, 0, arg,
+						     arglen, IOV_SET);
 			if (bcmerror != -ENOTSUPP)
 				break;
 
@@ -517,7 +517,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 }
 
 #ifdef SHOW_EVENTS
-static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
+static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 {
 	uint i, status, reason;
 	bool group = false, flush_txq = false, link = false;
@@ -823,7 +823,7 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 #endif				/* SHOW_EVENTS */
 
 int
-wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
+brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	      wl_event_msg_t *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
@@ -919,14 +919,14 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	}
 
 #ifdef SHOW_EVENTS
-	wl_show_host_event(event, event_data);
+	brcmf_c_show_host_event(event, event_data);
 #endif				/* SHOW_EVENTS */
 
 	return 0;
 }
 
 /* Convert user's input in hex pattern to byte-size mask */
-static int wl_pattern_atoh(char *src, char *dst)
+static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
@@ -949,7 +949,7 @@ static int wl_pattern_atoh(char *src, char *dst)
 }
 
 void
-dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
+brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 			     int master_mode)
 {
 	char *argv[8];
@@ -1019,7 +1019,7 @@ fail:
 	kfree(arg_org);
 }
 
-void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
+void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 {
 	const char *str;
 	wl_pkt_filter_t pkt_filter;
@@ -1108,7 +1108,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	/* Parse pattern filter mask. */
 	mask_size =
-	    wl_pattern_atoh
+	    brcmf_c_pattern_atoh
 		   (argv[i], (char *)pkt_filterp->u.pattern.mask_and_pattern);
 
 	if (NULL == argv[++i]) {
@@ -1118,7 +1118,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	/* Parse pattern filter pattern. */
 	pattern_size =
-	    wl_pattern_atoh(argv[i],
+	    brcmf_c_pattern_atoh(argv[i],
 				   (char *)&pkt_filterp->u.pattern.
 				   mask_and_pattern[mask_size]);
 
@@ -1156,7 +1156,7 @@ fail:
 	kfree(buf);
 }
 
-void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
+void brcmf_c_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
@@ -1173,7 +1173,7 @@ void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 			   __func__, arp_mode));
 }
 
-void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
+void brcmf_c_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
@@ -1190,7 +1190,7 @@ void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 			   __func__, arp_enable));
 }
 
-int dhd_preinit_ioctls(dhd_pub_t *dhd)
+int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 {
 	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
@@ -1291,8 +1291,8 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 #ifdef ARP_OFFLOAD_SUPPORT
 	/* Set and enable ARP offload feature */
 	if (dhd_arp_enable)
-		dhd_arp_offload_set(dhd, dhd_arp_mode);
-	dhd_arp_offload_enable(dhd, dhd_arp_enable);
+		brcmf_c_arp_offload_set(dhd, dhd_arp_mode);
+	brcmf_c_arp_offload_enable(dhd, dhd_arp_enable);
 #endif				/* ARP_OFFLOAD_SUPPORT */
 
 #ifdef PKT_FILTER_SUPPORT
@@ -1301,9 +1301,9 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 		/* Set up pkt filter */
 		if (dhd_pkt_filter_enable) {
 			for (i = 0; i < dhd->pktfilter_count; i++) {
-				dhd_pktfilter_offload_set(dhd,
+				brcmf_c_pktfilter_offload_set(dhd,
 							  dhd->pktfilter[i]);
-				dhd_pktfilter_offload_enable(dhd,
+				brcmf_c_pktfilter_offload_enable(dhd,
 				     dhd->pktfilter[i],
 				     dhd_pkt_filter_init,
 				     dhd_master_mode);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index d0fa231..2cbfb51 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -19,47 +19,47 @@
 
 #if defined(DHD_DEBUG)
 
-#define DHD_ERROR(args)	       \
-	do {if ((dhd_msg_level & DHD_ERROR_VAL) && (net_ratelimit())) \
+#define DHD_ERROR(args) \
+	do {if ((brcmf_msg_level & DHD_ERROR_VAL) && (net_ratelimit())) \
 		printk args; } while (0)
-#define DHD_TRACE(args)		do {if (dhd_msg_level & DHD_TRACE_VAL)	\
+#define DHD_TRACE(args)		do {if (brcmf_msg_level & DHD_TRACE_VAL) \
 					printk args; } while (0)
-#define DHD_INFO(args)		do {if (dhd_msg_level & DHD_INFO_VAL)	\
+#define DHD_INFO(args)		do {if (brcmf_msg_level & DHD_INFO_VAL) \
 					printk args; } while (0)
-#define DHD_DATA(args)		do {if (dhd_msg_level & DHD_DATA_VAL)	\
+#define DHD_DATA(args)		do {if (brcmf_msg_level & DHD_DATA_VAL) \
 					printk args; } while (0)
-#define DHD_CTL(args)		do {if (dhd_msg_level & DHD_CTL_VAL)	\
+#define DHD_CTL(args)		do {if (brcmf_msg_level & DHD_CTL_VAL) \
 					printk args; } while (0)
-#define DHD_TIMER(args)		do {if (dhd_msg_level & DHD_TIMER_VAL)	\
+#define DHD_TIMER(args)		do {if (brcmf_msg_level & DHD_TIMER_VAL) \
 					printk args; } while (0)
-#define DHD_HDRS(args)		do {if (dhd_msg_level & DHD_HDRS_VAL)	\
+#define DHD_HDRS(args)		do {if (brcmf_msg_level & DHD_HDRS_VAL) \
 					printk args; } while (0)
-#define DHD_BYTES(args)		do {if (dhd_msg_level & DHD_BYTES_VAL)	\
+#define DHD_BYTES(args)		do {if (brcmf_msg_level & DHD_BYTES_VAL) \
 					printk args; } while (0)
-#define DHD_INTR(args)		do {if (dhd_msg_level & DHD_INTR_VAL)	\
+#define DHD_INTR(args)		do {if (brcmf_msg_level & DHD_INTR_VAL)	\
 					printk args; } while (0)
-#define DHD_GLOM(args)		do {if (dhd_msg_level & DHD_GLOM_VAL)	\
+#define DHD_GLOM(args)		do {if (brcmf_msg_level & DHD_GLOM_VAL) \
 					printk args; } while (0)
-#define DHD_EVENT(args)		do {if (dhd_msg_level & DHD_EVENT_VAL)	\
+#define DHD_EVENT(args)		do {if (brcmf_msg_level & DHD_EVENT_VAL) \
 					printk args; } while (0)
-#define DHD_BTA(args)		do {if (dhd_msg_level & DHD_BTA_VAL)	\
+#define DHD_BTA(args)		do {if (brcmf_msg_level & DHD_BTA_VAL) \
 					printk args; } while (0)
-#define DHD_ISCAN(args)		do {if (dhd_msg_level & DHD_ISCAN_VAL)	\
+#define DHD_ISCAN(args)		do {if (brcmf_msg_level & DHD_ISCAN_VAL) \
 					printk args; } while (0)
 
-#define DHD_ERROR_ON()		(dhd_msg_level & DHD_ERROR_VAL)
-#define DHD_TRACE_ON()		(dhd_msg_level & DHD_TRACE_VAL)
-#define DHD_INFO_ON()		(dhd_msg_level & DHD_INFO_VAL)
-#define DHD_DATA_ON()		(dhd_msg_level & DHD_DATA_VAL)
-#define DHD_CTL_ON()		(dhd_msg_level & DHD_CTL_VAL)
-#define DHD_TIMER_ON()		(dhd_msg_level & DHD_TIMER_VAL)
-#define DHD_HDRS_ON()		(dhd_msg_level & DHD_HDRS_VAL)
-#define DHD_BYTES_ON()		(dhd_msg_level & DHD_BYTES_VAL)
-#define DHD_INTR_ON()		(dhd_msg_level & DHD_INTR_VAL)
-#define DHD_GLOM_ON()		(dhd_msg_level & DHD_GLOM_VAL)
-#define DHD_EVENT_ON()		(dhd_msg_level & DHD_EVENT_VAL)
-#define DHD_BTA_ON()		(dhd_msg_level & DHD_BTA_VAL)
-#define DHD_ISCAN_ON()		(dhd_msg_level & DHD_ISCAN_VAL)
+#define DHD_ERROR_ON()		(brcmf_msg_level & DHD_ERROR_VAL)
+#define DHD_TRACE_ON()		(brcmf_msg_level & DHD_TRACE_VAL)
+#define DHD_INFO_ON()		(brcmf_msg_level & DHD_INFO_VAL)
+#define DHD_DATA_ON()		(brcmf_msg_level & DHD_DATA_VAL)
+#define DHD_CTL_ON()		(brcmf_msg_level & DHD_CTL_VAL)
+#define DHD_TIMER_ON()		(brcmf_msg_level & DHD_TIMER_VAL)
+#define DHD_HDRS_ON()		(brcmf_msg_level & DHD_HDRS_VAL)
+#define DHD_BYTES_ON()		(brcmf_msg_level & DHD_BYTES_VAL)
+#define DHD_INTR_ON()		(brcmf_msg_level & DHD_INTR_VAL)
+#define DHD_GLOM_ON()		(brcmf_msg_level & DHD_GLOM_VAL)
+#define DHD_EVENT_ON()		(brcmf_msg_level & DHD_EVENT_VAL)
+#define DHD_BTA_ON()		(brcmf_msg_level & DHD_BTA_VAL)
+#define DHD_ISCAN_ON()		(brcmf_msg_level & DHD_ISCAN_VAL)
 
 #else	/* (defined BCMDBG) || (defined DHD_DEBUG) */
 
@@ -95,6 +95,6 @@
 #define DHD_LOG(args)
 
 #define DHD_NONE(args)
-extern int dhd_msg_level;
+extern int brcmf_msg_level;
 
 #endif				/* _dhd_dbg_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ed4a296..da39948 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -252,7 +252,7 @@ bool dhd_no_fw_req;
 module_param(dhd_no_fw_req, bool, 0);
 
 /* Error bits */
-module_param(dhd_msg_level, int, 0);
+module_param(brcmf_msg_level, int, 0);
 
 /* Spawn a thread for system ioctls (set mac, set mcast) */
 uint dhd_sysioc = true;
@@ -388,8 +388,8 @@ static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 		int i;
 
 		for (i = 0; i < dhd->pktfilter_count; i++) {
-			dhd_pktfilter_offload_set(dhd, dhd->pktfilter[i]);
-			dhd_pktfilter_offload_enable(dhd, dhd->pktfilter[i],
+			brcmf_c_pktfilter_offload_set(dhd, dhd->pktfilter[i]);
+			brcmf_c_pktfilter_offload_enable(dhd, dhd->pktfilter[i],
 						     value, dhd_master_mode);
 		}
 	}
@@ -1634,7 +1634,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 
 	/* check for local dhd ioctl and handle it */
 	if (driver == DHD_IOCTL_MAGIC) {
-		bcmerror = dhd_ioctl((void *)&dhd->pub, &ioc, buf, buflen);
+		bcmerror = brcmf_c_ioctl((void *)&dhd->pub, &ioc, buf, buflen);
 		if (bcmerror)
 			dhd->pub.bcmerror = bcmerror;
 		goto done;
@@ -1810,9 +1810,9 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* updates firmware nvram path if it was provided as module
 		 paramters */
 	if ((firmware_path != NULL) && (firmware_path[0] != '\0'))
-		strcpy(fw_path, firmware_path);
+		strcpy(brcmf_fw_path, firmware_path);
 	if ((nvram_path != NULL) && (nvram_path[0] != '\0'))
-		strcpy(nv_path, nvram_path);
+		strcpy(brcmf_nv_path, nvram_path);
 
 	/* Allocate etherdev, including space for private structure */
 	net = alloc_etherdev(sizeof(dhd));
@@ -1877,8 +1877,8 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		goto fail;
 	}
 	if (!dhd_no_fw_req) {
-		strcpy(fw_path, wl_cfg80211_get_fwname());
-		strcpy(nv_path, wl_cfg80211_get_nvramname());
+		strcpy(brcmf_fw_path, wl_cfg80211_get_fwname());
+		strcpy(brcmf_nv_path, wl_cfg80211_get_nvramname());
 	}
 
 	/* Set up the watchdog timer */
@@ -1980,11 +1980,11 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 
 	/* try to download image and nvram to the dongle */
 	if (dhd->pub.busstate == DHD_BUS_DOWN) {
-		if (!(dhd_bus_download_firmware(dhd->pub.bus,
-						fw_path, nv_path))) {
+		if (!(dhd_bus_download_firmware(dhd->pub.bus, brcmf_fw_path,
+						brcmf_nv_path))) {
 			DHD_ERROR(("%s: dhd_bus_download_firmware failed. "
 				"firmware = %s nvram = %s\n",
-				__func__, fw_path, nv_path));
+				__func__, brcmf_fw_path, brcmf_nv_path));
 			return -1;
 		}
 	}
@@ -2506,7 +2506,7 @@ dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 
 	ASSERT(dhd != NULL);
 
-	bcmerror = wl_host_event(dhd, ifidx, pktdata, event, data);
+	bcmerror = brcmf_c_host_event(dhd, ifidx, pktdata, event, data);
 	if (bcmerror != 0)
 		return bcmerror;
 
@@ -2625,7 +2625,7 @@ void dhd_dev_init_ioctl(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
-	dhd_preinit_ioctls(&dhd->pub);
+	brcmf_c_preinit_ioctls(&dhd->pub);
 }
 
 #ifdef PNO_SUPPORT
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index f75eb1c..fccd3dd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -66,10 +66,10 @@ extern void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 /* Update local copy of dongle statistics */
 extern void dhd_prot_dstats(dhd_pub_t *dhdp);
 
-extern int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf,
+extern int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf,
 		     uint buflen);
 
-extern int dhd_preinit_ioctls(dhd_pub_t *dhd);
+extern int brcmf_c_preinit_ioctls(dhd_pub_t *dhd);
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
 extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 19ac421..7e7d288 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1375,7 +1375,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 
 		/* Priority based enq */
 		spin_lock_bh(&bus->txqlock);
-		if (dhd_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
+		if (brcmf_c_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
 			dhd_txcomplete(bus->dhd, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
@@ -2784,7 +2784,7 @@ exit:
 	dhd_os_sdunlock(bus->dhd);
 
 	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
-		dhd_preinit_ioctls((dhd_pub_t *) bus->dhd);
+		brcmf_c_preinit_ioctls((dhd_pub_t *) bus->dhd);
 
 	return bcmerror;
 }
@@ -5213,7 +5213,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 
 	forcealign = true;
 
-	dhd_common_init();
+	brcmf_c_init();
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 	DHD_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
@@ -5660,7 +5660,7 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 	void *image = NULL;
 	u8 *memblock = NULL, *memptr;
 
-	DHD_INFO(("%s: download firmware %s\n", __func__, fw_path));
+	DHD_INFO(("%s: download firmware %s\n", __func__, brcmf_fw_path));
 
 	image = dhd_os_open_image(fw_path);
 	if (image == NULL)
-- 
1.7.1


