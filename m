Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4613 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117Ab1F2XtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:01 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 084/119] staging: brcm80211: rename function variables
Date: Wed, 29 Jun 2011 16:47:48 -0700
Message-ID: <1309391303-22741-85-git-send-email-frankyl@broadcom.com> (sfid-20110630_015140_641342_5F0D1887)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac driver uses dhd as variable name for the driver instance
in a number of functions. This has been changed to a more generic name
as the dhd is not meaningful (broadcom internal name).

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |  172 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |  713 ++++++++++++-----------
 2 files changed, 447 insertions(+), 438 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 44b8a25..244ea72 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -111,7 +111,7 @@ void brcmf_c_init(void)
 	brcmf_msg_level = DHD_ERROR_VAL;
 }
 
-static int brcmf_c_dump(dhd_pub_t *dhdp, char *buf, int buflen)
+static int brcmf_c_dump(dhd_pub_t *drvr, char *buf, int buflen)
 {
 	struct brcmu_strbuf b;
 	struct brcmu_strbuf *strbuf = &b;
@@ -122,54 +122,54 @@ static int brcmf_c_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	brcmu_bprintf(strbuf, "%s\n", brcmf_version);
 	brcmu_bprintf(strbuf, "\n");
 	brcmu_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
-		    dhdp->up, dhdp->txoff, dhdp->busstate);
+		    drvr->up, drvr->txoff, drvr->busstate);
 	brcmu_bprintf(strbuf, "pub.hdrlen %d pub.maxctl %d pub.rxsz %d\n",
-		    dhdp->hdrlen, dhdp->maxctl, dhdp->rxsz);
+		    drvr->hdrlen, drvr->maxctl, drvr->rxsz);
 	brcmu_bprintf(strbuf, "pub.iswl %d pub.drv_version %ld pub.mac %pM\n",
-		    dhdp->iswl, dhdp->drv_version, &dhdp->mac);
-	brcmu_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", dhdp->bcmerror,
-		    dhdp->tickcnt);
+		    drvr->iswl, drvr->drv_version, &drvr->mac);
+	brcmu_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", drvr->bcmerror,
+		    drvr->tickcnt);
 
 	brcmu_bprintf(strbuf, "dongle stats:\n");
 	brcmu_bprintf(strbuf,
 		    "tx_packets %ld tx_bytes %ld tx_errors %ld tx_dropped %ld\n",
-		    dhdp->dstats.tx_packets, dhdp->dstats.tx_bytes,
-		    dhdp->dstats.tx_errors, dhdp->dstats.tx_dropped);
+		    drvr->dstats.tx_packets, drvr->dstats.tx_bytes,
+		    drvr->dstats.tx_errors, drvr->dstats.tx_dropped);
 	brcmu_bprintf(strbuf,
 		    "rx_packets %ld rx_bytes %ld rx_errors %ld rx_dropped %ld\n",
-		    dhdp->dstats.rx_packets, dhdp->dstats.rx_bytes,
-		    dhdp->dstats.rx_errors, dhdp->dstats.rx_dropped);
-	brcmu_bprintf(strbuf, "multicast %ld\n", dhdp->dstats.multicast);
+		    drvr->dstats.rx_packets, drvr->dstats.rx_bytes,
+		    drvr->dstats.rx_errors, drvr->dstats.rx_dropped);
+	brcmu_bprintf(strbuf, "multicast %ld\n", drvr->dstats.multicast);
 
 	brcmu_bprintf(strbuf, "bus stats:\n");
 	brcmu_bprintf(strbuf, "tx_packets %ld tx_multicast %ld tx_errors %ld\n",
-		    dhdp->tx_packets, dhdp->tx_multicast, dhdp->tx_errors);
+		    drvr->tx_packets, drvr->tx_multicast, drvr->tx_errors);
 	brcmu_bprintf(strbuf, "tx_ctlpkts %ld tx_ctlerrs %ld\n",
-		    dhdp->tx_ctlpkts, dhdp->tx_ctlerrs);
+		    drvr->tx_ctlpkts, drvr->tx_ctlerrs);
 	brcmu_bprintf(strbuf, "rx_packets %ld rx_multicast %ld rx_errors %ld\n",
-		    dhdp->rx_packets, dhdp->rx_multicast, dhdp->rx_errors);
+		    drvr->rx_packets, drvr->rx_multicast, drvr->rx_errors);
 	brcmu_bprintf(strbuf,
 		    "rx_ctlpkts %ld rx_ctlerrs %ld rx_dropped %ld rx_flushed %ld\n",
-		    dhdp->rx_ctlpkts, dhdp->rx_ctlerrs, dhdp->rx_dropped,
-		    dhdp->rx_flushed);
+		    drvr->rx_ctlpkts, drvr->rx_ctlerrs, drvr->rx_dropped,
+		    drvr->rx_flushed);
 	brcmu_bprintf(strbuf,
 		    "rx_readahead_cnt %ld tx_realloc %ld fc_packets %ld\n",
-		    dhdp->rx_readahead_cnt, dhdp->tx_realloc, dhdp->fc_packets);
-	brcmu_bprintf(strbuf, "wd_dpc_sched %ld\n", dhdp->wd_dpc_sched);
+		    drvr->rx_readahead_cnt, drvr->tx_realloc, drvr->fc_packets);
+	brcmu_bprintf(strbuf, "wd_dpc_sched %ld\n", drvr->wd_dpc_sched);
 	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any prot info */
-	brcmf_proto_dump(dhdp, strbuf);
+	brcmf_proto_dump(drvr, strbuf);
 	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any bus info */
-	brcmf_sdbrcm_bus_dump(dhdp, strbuf);
+	brcmf_sdbrcm_bus_dump(drvr, strbuf);
 
 	return !strbuf->size ? -EOVERFLOW : 0;
 }
 
 static int
-brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
+brcmf_c_doiovar(dhd_pub_t *drvr, const struct brcmu_iovar *vi, u32 actionid,
 	    const char *name, void *params, int plen, void *arg, int len,
 	    int val_size)
 {
@@ -207,25 +207,25 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_BCMERROR):
-		int_val = (s32) dhd_pub->bcmerror;
+		int_val = (s32) drvr->bcmerror;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_DUMP):
-		bcmerror = brcmf_c_dump(dhd_pub, arg, len);
+		bcmerror = brcmf_c_dump(drvr, arg, len);
 		break;
 
 	case IOV_SVAL(IOV_CLEARCOUNTS):
-		dhd_pub->tx_packets = dhd_pub->rx_packets = 0;
-		dhd_pub->tx_errors = dhd_pub->rx_errors = 0;
-		dhd_pub->tx_ctlpkts = dhd_pub->rx_ctlpkts = 0;
-		dhd_pub->tx_ctlerrs = dhd_pub->rx_ctlerrs = 0;
-		dhd_pub->rx_dropped = 0;
-		dhd_pub->rx_readahead_cnt = 0;
-		dhd_pub->tx_realloc = 0;
-		dhd_pub->wd_dpc_sched = 0;
-		memset(&dhd_pub->dstats, 0, sizeof(dhd_pub->dstats));
-		dhd_bus_clearcounts(dhd_pub);
+		drvr->tx_packets = drvr->rx_packets = 0;
+		drvr->tx_errors = drvr->rx_errors = 0;
+		drvr->tx_ctlpkts = drvr->rx_ctlpkts = 0;
+		drvr->tx_ctlerrs = drvr->rx_ctlerrs = 0;
+		drvr->rx_dropped = 0;
+		drvr->rx_readahead_cnt = 0;
+		drvr->tx_realloc = 0;
+		drvr->wd_dpc_sched = 0;
+		memset(&drvr->dstats, 0, sizeof(drvr->dstats));
+		dhd_bus_clearcounts(drvr);
 		break;
 
 	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
@@ -252,7 +252,7 @@ exit:
 	return bcmerror;
 }
 
-bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
+bool brcmf_c_prec_enq(dhd_pub_t *drvr, struct pktq *q, struct sk_buff *pkt,
 		  int prec)
 {
 	struct sk_buff *p;
@@ -281,7 +281,7 @@ bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	if (eprec >= 0) {
 		/* Detect queueing to unconfigured precedence */
 		ASSERT(!pktq_pempty(q, eprec));
-		discard_oldest = AC_BITMAP_TST(dhdp->wme_dp, eprec);
+		discard_oldest = AC_BITMAP_TST(drvr->wme_dp, eprec);
 		if (eprec == prec && !discard_oldest)
 			return false;	/* refuse newer (incoming) packet */
 		/* Evict packet according to discard policy */
@@ -307,7 +307,7 @@ bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 }
 
 static int
-brcmf_c_iovar_op(dhd_pub_t *dhd_pub, const char *name,
+brcmf_c_iovar_op(dhd_pub_t *drvr, const char *name,
 	     void *params, int plen, void *arg, int len, bool set)
 {
 	int bcmerror = 0;
@@ -353,14 +353,14 @@ brcmf_c_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 
 	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
 	bcmerror =
-	    brcmf_c_doiovar(dhd_pub, vi, actionid, name, params, plen, arg, len,
+	    brcmf_c_doiovar(drvr, vi, actionid, name, params, plen, arg, len,
 			val_size);
 
 exit:
 	return bcmerror;
 }
 
-int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
+int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
 {
 	int bcmerror = 0;
 
@@ -404,23 +404,23 @@ int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 			/* call with the appropriate arguments */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror = brcmf_c_iovar_op(dhd_pub, buf, arg,
+				bcmerror = brcmf_c_iovar_op(drvr, buf, arg,
 						arglen, buf, buflen, IOV_GET);
 			else
 				bcmerror =
-				    brcmf_c_iovar_op(dhd_pub, buf, NULL, 0, arg,
+				    brcmf_c_iovar_op(drvr, buf, NULL, 0, arg,
 						     arglen, IOV_SET);
 			if (bcmerror != -ENOTSUPP)
 				break;
 
 			/* not in generic table, try protocol module */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror = brcmf_proto_iovar_op(dhd_pub, buf,
+				bcmerror = brcmf_proto_iovar_op(drvr, buf,
 								arg, arglen,
 								buf, buflen,
 								IOV_GET);
 			else
-				bcmerror = brcmf_proto_iovar_op(dhd_pub, buf,
+				bcmerror = brcmf_proto_iovar_op(drvr, buf,
 								NULL, 0, arg,
 								arglen,
 								IOV_SET);
@@ -429,11 +429,11 @@ int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 			/* if still not found, try bus module */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror = brcmf_sdbrcm_bus_iovar_op(dhd_pub,
+				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
 						buf, arg, arglen, buf, buflen,
 						IOV_GET);
 			else
-				bcmerror = brcmf_sdbrcm_bus_iovar_op(dhd_pub,
+				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
 						buf, NULL, 0, arg, arglen,
 						IOV_SET);
 
@@ -754,8 +754,8 @@ static void brcmf_c_show_host_event(brcmf_event_msg_t *event, void *event_data)
 #endif				/* SHOW_EVENTS */
 
 int
-brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
-	      brcmf_event_msg_t *event, void **data_ptr)
+brcmf_c_host_event(struct dhd_info *drvr_priv, int *ifidx, void *pktdata,
+		   brcmf_event_msg_t *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
 	brcmf_event_t *pvt_data = (brcmf_event_t *) pktdata;
@@ -796,13 +796,13 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 			if (ifevent->ifidx > 0 &&
 				 ifevent->ifidx < DHD_MAX_IFS) {
 				if (ifevent->action == BRCMF_E_IF_ADD)
-					brcmf_add_if(dhd, ifevent->ifidx,
+					brcmf_add_if(drvr_priv, ifevent->ifidx,
 						   NULL, event->ifname,
 						   pvt_data->eth.h_dest,
 						   ifevent->flags,
 						   ifevent->bssidx);
 				else
-					brcmf_del_if(dhd, ifevent->ifidx);
+					brcmf_del_if(drvr_priv, ifevent->ifidx);
 			} else {
 				DHD_ERROR(("%s: Invalid ifidx %d for %s\n",
 					   __func__, ifevent->ifidx,
@@ -810,9 +810,9 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 			}
 		}
 		/* send up the if event: btamp user needs it */
-		*ifidx = brcmf_ifname2idx(dhd, event->ifname);
+		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
 		/* push up to external supp/auth */
-		brcmf_event(dhd, (char *)pvt_data, evlen, *ifidx);
+		brcmf_event(drvr_priv, (char *)pvt_data, evlen, *ifidx);
 		break;
 
 		/* These are what external supplicant/authenticator wants */
@@ -824,9 +824,9 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	default:
 		/* Fall through: this should get _everything_  */
 
-		*ifidx = brcmf_ifname2idx(dhd, event->ifname);
+		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
 		/* push up to external supp/auth */
-		brcmf_event(dhd, (char *)pvt_data, evlen, *ifidx);
+		brcmf_event(drvr_priv, (char *)pvt_data, evlen, *ifidx);
 		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
 			   __func__, type, flags, status));
 
@@ -875,7 +875,7 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 }
 
 void
-brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
+brcmf_c_pktfilter_offload_enable(dhd_pub_t *drvr, char *arg, int enable,
 			     int master_mode)
 {
 	char *argv[8];
@@ -923,7 +923,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
 
 	/* Enable/disable the specified filter. */
-	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
@@ -935,7 +935,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
-	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf,
+	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf,
 				       sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
@@ -946,7 +946,7 @@ fail:
 	kfree(arg_org);
 }
 
-void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
+void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
 {
 	const char *str;
 	wl_pkt_filter_t pkt_filter;
@@ -1066,7 +1066,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	       &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
-	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
@@ -1082,13 +1082,13 @@ fail:
 	kfree(buf);
 }
 
-void brcmf_c_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
+void brcmf_c_arp_offload_set(dhd_pub_t *drvr, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
 
 	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1099,13 +1099,13 @@ void brcmf_c_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 			   __func__, arp_mode));
 }
 
-void brcmf_c_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
+void brcmf_c_arp_offload_enable(dhd_pub_t *drvr, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
 
 	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1116,7 +1116,7 @@ void brcmf_c_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 			   __func__, arp_enable));
 }
 
-int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
+int brcmf_c_preinit_ioctls(dhd_pub_t *drvr)
 {
 	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
@@ -1130,13 +1130,13 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	int scan_unassoc_time = 40;
 	int i;
 
-	brcmf_os_proto_block(dhd);
+	brcmf_os_proto_block(drvr);
 
 	/* Set Country code */
-	if (dhd->country_code[0] != 0) {
-		if (brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_COUNTRY,
-				     dhd->country_code,
-				     sizeof(dhd->country_code)) < 0) {
+	if (drvr->country_code[0] != 0) {
+		if (brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_COUNTRY,
+				     drvr->country_code,
+				     sizeof(drvr->country_code)) < 0) {
 			DHD_ERROR(("%s: country code setting failed\n",
 				   __func__));
 		}
@@ -1146,74 +1146,74 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
 	brcmu_mkiovar("ver", 0, 0, buf, sizeof(buf));
-	brcmf_proto_cdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
+	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	DHD_ERROR(("Firmware version = %s\n", buf));
 
 	/* Set PowerSave mode */
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM, (char *)&power_mode,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM, (char *)&power_mode,
 			 sizeof(power_mode));
 
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* disable glom option per default */
 	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
 	brcmu_mkiovar("roam_off", (char *)&brcmf_roam, 4,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Force STA UP */
 	if (brcmf_radio_up)
-		brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_UP, (char *)&up,
+		brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_UP, (char *)&up,
 					  sizeof(up));
 
 	/* Setup event_msgs */
-	brcmu_mkiovar("event_msgs", dhd->eventmask, WL_EVENTING_MASK_LEN,
+	brcmu_mkiovar("event_msgs", drvr->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
 	/* Set and enable ARP offload feature */
 	if (brcmf_arp_enable)
-		brcmf_c_arp_offload_set(dhd, brcmf_arp_mode);
-	brcmf_c_arp_offload_enable(dhd, brcmf_arp_enable);
+		brcmf_c_arp_offload_set(drvr, brcmf_arp_mode);
+	brcmf_c_arp_offload_enable(drvr, brcmf_arp_enable);
 
 	/* Set up pkt filter */
 	if (brcmf_pkt_filter_enable) {
-		for (i = 0; i < dhd->pktfilter_count; i++) {
-			brcmf_c_pktfilter_offload_set(dhd,
-						  dhd->pktfilter[i]);
-			brcmf_c_pktfilter_offload_enable(dhd,
-			     dhd->pktfilter[i],
+		for (i = 0; i < drvr->pktfilter_count; i++) {
+			brcmf_c_pktfilter_offload_set(drvr,
+						  drvr->pktfilter[i]);
+			brcmf_c_pktfilter_offload_enable(drvr,
+			     drvr->pktfilter[i],
 			     brcmf_pkt_filter_init,
 			     brcmf_master_mode);
 		}
 	}
 
-	brcmf_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(drvr);
 
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 4724414..04b4511 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -182,12 +182,12 @@ module_param(brcmf_pktgen_len, uint, 0);
 #define DHD_COMPILED
 #endif
 
-static int brcmf_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
-static int brcmf_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
-static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
+static int brcmf_toe_get(dhd_info_t *drvr_priv, int idx, u32 *toe_ol);
+static int brcmf_toe_set(dhd_info_t *drvr_priv, int idx, u32 toe_ol);
+static int brcmf_host_event(dhd_info_t *drvr_priv, int *ifidx, void *pktdata,
 			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
-static void brcmf_set_packet_filter(int value, dhd_pub_t *dhd)
+static void brcmf_set_packet_filter(int value, dhd_pub_t *drvr)
 {
 	DHD_TRACE(("%s: %d\n", __func__, value));
 	/* 1 - Enable packet filter, only allow unicast packet to send up */
@@ -195,16 +195,18 @@ static void brcmf_set_packet_filter(int value, dhd_pub_t *dhd)
 	if (brcmf_pkt_filter_enable) {
 		int i;
 
-		for (i = 0; i < dhd->pktfilter_count; i++) {
-			brcmf_c_pktfilter_offload_set(dhd, dhd->pktfilter[i]);
-			brcmf_c_pktfilter_offload_enable(dhd, dhd->pktfilter[i],
-						     value, brcmf_master_mode);
+		for (i = 0; i < drvr->pktfilter_count; i++) {
+			brcmf_c_pktfilter_offload_set(drvr, drvr->pktfilter[i]);
+			brcmf_c_pktfilter_offload_enable(drvr,
+							 drvr->pktfilter[i],
+							 value,
+							 brcmf_master_mode);
 		}
 	}
 }
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
+static int brcmf_set_suspend(int value, dhd_pub_t *drvr)
 {
 	int power_mode = PM_MAX;
 	/* wl_pkt_filter_enable_t       enable_parm; */
@@ -212,22 +214,22 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 	int bcn_li_dtim = 3;
 
 	DHD_TRACE(("%s: enter, value = %d in_suspend=%d\n",
-		   __func__, value, dhd->in_suspend));
+		   __func__, value, drvr->in_suspend));
 
-	if (dhd && dhd->up) {
-		if (value && dhd->in_suspend) {
+	if (drvr && drvr->up) {
+		if (value && drvr->in_suspend) {
 
 			/* Kernel suspended */
 			DHD_TRACE(("%s: force extra Suspend setting\n",
 				   __func__));
 
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
+			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM,
 					 (char *)&power_mode,
 					 sizeof(power_mode));
 
 			/* Enable packet filter, only allow unicast
 				 packet to send up */
-			brcmf_set_packet_filter(1, dhd);
+			brcmf_set_packet_filter(1, drvr);
 
 			/* if dtim skip setup as default force it
 			 * to wake each third dtim
@@ -235,13 +237,13 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 			 * Note that side effect is chance to miss BC/MC
 			 * packet
 			 */
-			if ((dhd->dtim_skip == 0) || (dhd->dtim_skip == 1))
+			if ((drvr->dtim_skip == 0) || (drvr->dtim_skip == 1))
 				bcn_li_dtim = 3;
 			else
-				bcn_li_dtim = dhd->dtim_skip;
+				bcn_li_dtim = drvr->dtim_skip;
 			brcmu_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
 				    4, iovbuf, sizeof(iovbuf));
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
 						  iovbuf, sizeof(iovbuf));
 		} else {
 
@@ -250,18 +252,18 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 				   __func__));
 
 			power_mode = PM_FAST;
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
-					 (char *)&power_mode,
-					 sizeof(power_mode));
+			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM,
+						  (char *)&power_mode,
+						  sizeof(power_mode));
 
 			/* disable pkt filter */
-			brcmf_set_packet_filter(0, dhd);
+			brcmf_set_packet_filter(0, drvr);
 
 			/* restore pre-suspend setting for dtim_skip */
-			brcmu_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
+			brcmu_mkiovar("bcn_li_dtim", (char *)&drvr->dtim_skip,
 				    4, iovbuf, sizeof(iovbuf));
 
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
 						  iovbuf, sizeof(iovbuf));
 		}
 	}
@@ -269,37 +271,39 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 	return 0;
 }
 
-static void brcmf_suspend_resume_helper(struct dhd_info *dhd, int val)
+static void brcmf_suspend_resume_helper(struct dhd_info *drvr_priv, int val)
 {
-	dhd_pub_t *dhdp = &dhd->pub;
+	dhd_pub_t *drvr = &drvr_priv->pub;
 
-	brcmf_os_proto_block(dhdp);
+	brcmf_os_proto_block(drvr);
 	/* Set flag when early suspend was called */
-	dhdp->in_suspend = val;
-	if (!dhdp->suspend_disable_flag)
-		brcmf_set_suspend(val, dhdp);
-	brcmf_os_proto_unblock(dhdp);
+	drvr->in_suspend = val;
+	if (!drvr->suspend_disable_flag)
+		brcmf_set_suspend(val, drvr);
+	brcmf_os_proto_unblock(drvr);
 }
 
 static void brcmf_early_suspend(struct early_suspend *h)
 {
-	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
+	struct dhd_info *drvr_priv =
+			container_of(h, struct dhd_info, early_suspend);
 
 	DHD_TRACE(("%s: enter\n", __func__));
 
-	if (dhd)
-		dhd_suspend_resume_helper(dhd, 1);
+	if (drvr_priv)
+		dhd_suspend_resume_helper(drvr_priv, 1);
 
 }
 
 static void brcmf_late_resume(struct early_suspend *h)
 {
-	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
+	struct dhd_info *drvr_priv =
+			container_of(h, struct dhd_info, early_suspend);
 
 	DHD_TRACE(("%s: enter\n", __func__));
 
-	if (dhd)
-		dhd_suspend_resume_helper(dhd, 0);
+	if (drvr_priv)
+		dhd_suspend_resume_helper(drvr_priv, 0);
 }
 #endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
 
@@ -361,13 +365,13 @@ int brcmf_timeout_expired(dhd_timeout_t *tmo)
 	return 0;
 }
 
-static int brcmf_net2idx(dhd_info_t *dhd, struct net_device *net)
+static int brcmf_net2idx(dhd_info_t *drvr_priv, struct net_device *net)
 {
 	int i = 0;
 
-	ASSERT(dhd);
+	ASSERT(drvr_priv);
 	while (i < DHD_MAX_IFS) {
-		if (dhd->iflist[i] && (dhd->iflist[i]->net == net))
+		if (drvr_priv->iflist[i] && (drvr_priv->iflist[i]->net == net))
 			return i;
 		i++;
 	}
@@ -375,18 +379,18 @@ static int brcmf_net2idx(dhd_info_t *dhd, struct net_device *net)
 	return DHD_BAD_IF;
 }
 
-int brcmf_ifname2idx(dhd_info_t *dhd, char *name)
+int brcmf_ifname2idx(dhd_info_t *drvr_priv, char *name)
 {
 	int i = DHD_MAX_IFS;
 
-	ASSERT(dhd);
+	ASSERT(drvr_priv);
 
 	if (name == NULL || *name == '\0')
 		return 0;
 
 	while (--i > 0)
-		if (dhd->iflist[i]
-		    && !strncmp(dhd->iflist[i]->name, name, IFNAMSIZ))
+		if (drvr_priv->iflist[i]
+		    && !strncmp(drvr_priv->iflist[i]->name, name, IFNAMSIZ))
 			break;
 
 	DHD_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
@@ -394,29 +398,29 @@ int brcmf_ifname2idx(dhd_info_t *dhd, char *name)
 	return i;		/* default - the primary interface */
 }
 
-char *brcmf_ifname(dhd_pub_t *dhdp, int ifidx)
+char *brcmf_ifname(dhd_pub_t *drvr, int ifidx)
 {
-	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
+	dhd_info_t *drvr_priv = drvr->info;
 
-	ASSERT(dhd);
+	ASSERT(drvr_priv);
 
 	if (ifidx < 0 || ifidx >= DHD_MAX_IFS) {
 		DHD_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
 		return "<if_bad>";
 	}
 
-	if (dhd->iflist[ifidx] == NULL) {
+	if (drvr_priv->iflist[ifidx] == NULL) {
 		DHD_ERROR(("%s: null i/f %d\n", __func__, ifidx));
 		return "<if_null>";
 	}
 
-	if (dhd->iflist[ifidx]->net)
-		return dhd->iflist[ifidx]->net->name;
+	if (drvr_priv->iflist[ifidx]->net)
+		return drvr_priv->iflist[ifidx]->net->name;
 
 	return "<if_none>";
 }
 
-static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
+static void _brcmf_set_multicast_list(dhd_info_t *drvr_priv, int ifidx)
 {
 	struct net_device *dev;
 	struct netdev_hw_addr *ha;
@@ -427,8 +431,8 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	uint buflen;
 	int ret;
 
-	ASSERT(dhd && dhd->iflist[ifidx]);
-	dev = dhd->iflist[ifidx]->net;
+	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
+	dev = drvr_priv->iflist[ifidx]->net;
 	cnt = netdev_mc_count(dev);
 
 	/* Determine initial value of allmulti flag */
@@ -440,7 +444,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
 		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
-			   brcmf_ifname(&dhd->pub, ifidx), cnt));
+			   brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
 		return;
 	}
 
@@ -465,10 +469,10 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set mcast_list failed, cnt %d\n",
-			   brcmf_ifname(&dhd->pub, ifidx), cnt));
+			   brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -483,7 +487,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
 		DHD_ERROR(("%s: out of memory for allmulti\n",
-			   brcmf_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&drvr_priv->pub, ifidx)));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
@@ -491,7 +495,7 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
 		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
-			"buflen %u\n", brcmf_ifname(&dhd->pub, ifidx),
+			"buflen %u\n", brcmf_ifname(&drvr_priv->pub, ifidx),
 			(int)sizeof(allmulti), buflen));
 		kfree(buf);
 		return;
@@ -503,10 +507,10 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set allmulti %d failed\n",
-			   brcmf_ifname(&dhd->pub, ifidx),
+			   brcmf_ifname(&drvr_priv->pub, ifidx),
 			   le32_to_cpu(allmulti)));
 	}
 
@@ -524,15 +528,15 @@ static void _brcmf_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = sizeof(allmulti);
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set promisc %d failed\n",
-			   brcmf_ifname(&dhd->pub, ifidx),
+			   brcmf_ifname(&drvr_priv->pub, ifidx),
 			   le32_to_cpu(allmulti)));
 	}
 }
 
-static int _brcmf_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
+static int _brcmf_set_mac_address(dhd_info_t *drvr_priv, int ifidx, u8 *addr)
 {
 	char buf[32];
 	wl_ioctl_t ioc;
@@ -542,7 +546,7 @@ static int _brcmf_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	if (!brcmu_mkiovar
 	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
 		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
-			   brcmf_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&drvr_priv->pub, ifidx)));
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
@@ -551,12 +555,12 @@ static int _brcmf_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	ioc.len = 32;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set cur_etheraddr failed\n",
-			   brcmf_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&drvr_priv->pub, ifidx)));
 	} else {
-		memcpy(dhd->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
+		memcpy(drvr_priv->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 	}
 
 	return ret;
@@ -568,12 +572,12 @@ extern struct net_device *ap_net_dev;
 
 static void brcmf_op_if(dhd_if_t *ifp)
 {
-	dhd_info_t *dhd;
+	dhd_info_t *drvr_priv;
 	int ret = 0, err = 0;
 
 	ASSERT(ifp && ifp->info && ifp->idx);	/* Virtual interfaces only */
 
-	dhd = ifp->info;
+	drvr_priv = ifp->info;
 
 	DHD_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
 
@@ -592,15 +596,15 @@ static void brcmf_op_if(dhd_if_t *ifp)
 			free_netdev(ifp->net);
 		}
 		/* Allocate etherdev, including space for private structure */
-		ifp->net = alloc_etherdev(sizeof(dhd));
+		ifp->net = alloc_etherdev(sizeof(drvr_priv));
 		if (!ifp->net) {
 			DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
 			strcpy(ifp->net->name, ifp->name);
-			memcpy(netdev_priv(ifp->net), &dhd, sizeof(dhd));
-			err = brcmf_net_attach(&dhd->pub, ifp->idx);
+			memcpy(netdev_priv(ifp->net), &drvr_priv, sizeof(drvr_priv));
+			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
 				DHD_ERROR(("%s: dhd_net_attach failed, "
 					"err %d\n",
@@ -646,7 +650,7 @@ static void brcmf_op_if(dhd_if_t *ifp)
 		if (ifp->net)
 			free_netdev(ifp->net);
 
-		dhd->iflist[ifp->idx] = NULL;
+		drvr_priv->iflist[ifp->idx] = NULL;
 		kfree(ifp);
 #ifdef SOFTAP
 		if (ifp->net == ap_net_dev)
@@ -658,7 +662,7 @@ static void brcmf_op_if(dhd_if_t *ifp)
 
 static int _brcmf_sysioc_thread(void *data)
 {
-	dhd_info_t *dhd = (dhd_info_t *) data;
+	dhd_info_t *drvr_priv = (dhd_info_t *) data;
 	int i;
 #ifdef SOFTAP
 	bool in_ap = false;
@@ -666,46 +670,48 @@ static int _brcmf_sysioc_thread(void *data)
 
 	allow_signal(SIGTERM);
 
-	while (down_interruptible(&dhd->sysioc_sem) == 0) {
+	while (down_interruptible(&drvr_priv->sysioc_sem) == 0) {
 		if (kthread_should_stop())
 			break;
 		for (i = 0; i < DHD_MAX_IFS; i++) {
-			if (dhd->iflist[i]) {
+			if (drvr_priv->iflist[i]) {
 #ifdef SOFTAP
 				in_ap = (ap_net_dev != NULL);
 #endif				/* SOFTAP */
-				if (dhd->iflist[i]->state)
-					brcmf_op_if(dhd->iflist[i]);
+				if (drvr_priv->iflist[i]->state)
+					brcmf_op_if(drvr_priv->iflist[i]);
 #ifdef SOFTAP
-				if (dhd->iflist[i] == NULL) {
+				if (drvr_priv->iflist[i] == NULL) {
 					DHD_TRACE(("\n\n %s: interface %d "
 						"removed!\n", __func__, i));
 					continue;
 				}
 
-				if (in_ap && dhd->set_macaddress) {
+				if (in_ap && drvr_priv->set_macaddress) {
 					DHD_TRACE(("attempt to set MAC for %s "
 						"in AP Mode," "blocked.\n",
-						dhd->iflist[i]->net->name));
-					dhd->set_macaddress = false;
+						drvr_priv->iflist[i]->net->name));
+					drvr_priv->set_macaddress = false;
 					continue;
 				}
 
-				if (in_ap && dhd->set_multicast) {
-					DHD_TRACE(("attempt to set MULTICAST list for %s" "in AP Mode, blocked.\n",
-						dhd->iflist[i]->net->name));
-					dhd->set_multicast = false;
+				if (in_ap && drvr_priv->set_multicast) {
+					DHD_TRACE(("attempt to set MULTICAST "
+						   "list for %s in AP Mode, "
+						   "blocked.\n",
+						   drvr_priv->iflist[i]->net->name));
+					drvr_priv->set_multicast = false;
 					continue;
 				}
 #endif				/* SOFTAP */
-				if (dhd->set_multicast) {
-					dhd->set_multicast = false;
-					_brcmf_set_multicast_list(dhd, i);
+				if (drvr_priv->set_multicast) {
+					drvr_priv->set_multicast = false;
+					_brcmf_set_multicast_list(drvr_priv, i);
 				}
-				if (dhd->set_macaddress) {
-					dhd->set_macaddress = false;
-					_brcmf_set_mac_address(dhd, i,
-							     dhd->macvalue);
+				if (drvr_priv->set_macaddress) {
+					drvr_priv->set_macaddress = false;
+					_brcmf_set_mac_address(drvr_priv, i,
+							     drvr_priv->macvalue);
 				}
 			}
 		}
@@ -717,42 +723,42 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
 
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int ifidx;
 
-	ifidx = brcmf_net2idx(dhd, dev);
+	ifidx = brcmf_net2idx(drvr_priv, dev);
 	if (ifidx == DHD_BAD_IF)
 		return -1;
 
-	ASSERT(dhd->sysioc_tsk);
-	memcpy(&dhd->macvalue, sa->sa_data, ETH_ALEN);
-	dhd->set_macaddress = true;
-	up(&dhd->sysioc_sem);
+	ASSERT(drvr_priv->sysioc_tsk);
+	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
+	drvr_priv->set_macaddress = true;
+	up(&drvr_priv->sysioc_sem);
 
 	return ret;
 }
 
 static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
 	int ifidx;
 
-	ifidx = brcmf_net2idx(dhd, dev);
+	ifidx = brcmf_net2idx(drvr_priv, dev);
 	if (ifidx == DHD_BAD_IF)
 		return;
 
-	ASSERT(dhd->sysioc_tsk);
-	dhd->set_multicast = true;
-	up(&dhd->sysioc_sem);
+	ASSERT(drvr_priv->sysioc_tsk);
+	drvr_priv->set_multicast = true;
+	up(&drvr_priv->sysioc_sem);
 }
 
-int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
+int brcmf_sendpkt(dhd_pub_t *drvr, int ifidx, struct sk_buff *pktbuf)
 {
-	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
+	dhd_info_t *drvr_priv = drvr->info;
 
 	/* Reject if down */
-	if (!dhdp->up || (dhdp->busstate == DHD_BUS_DOWN))
+	if (!drvr->up || (drvr->busstate == DHD_BUS_DOWN))
 		return -ENODEV;
 
 	/* Update multicast statistic */
@@ -761,35 +767,35 @@ int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 		struct ethhdr *eh = (struct ethhdr *)pktdata;
 
 		if (is_multicast_ether_addr(eh->h_dest))
-			dhdp->tx_multicast++;
+			drvr->tx_multicast++;
 		if (ntohs(eh->h_proto) == ETH_P_PAE)
-			atomic_inc(&dhd->pend_8021x_cnt);
+			atomic_inc(&drvr_priv->pend_8021x_cnt);
 	}
 
 	/* If the protocol uses a data header, apply it */
-	brcmf_proto_hdrpush(dhdp, ifidx, pktbuf);
+	brcmf_proto_hdrpush(drvr, ifidx, pktbuf);
 
 	/* Use bus module to send data frame */
-	return brcmf_sdbrcm_bus_txdata(dhdp->bus, pktbuf);
+	return brcmf_sdbrcm_bus_txdata(drvr->bus, pktbuf);
 }
 
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	int ret;
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 	int ifidx;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Reject if down */
-	if (!dhd->pub.up || (dhd->pub.busstate == DHD_BUS_DOWN)) {
+	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == DHD_BUS_DOWN)) {
 		DHD_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
-			   __func__, dhd->pub.up, dhd->pub.busstate));
+			   __func__, drvr_priv->pub.up, drvr_priv->pub.busstate));
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
 
-	ifidx = brcmf_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == DHD_BAD_IF) {
 		DHD_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
 		netif_stop_queue(net);
@@ -797,55 +803,55 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	}
 
 	/* Make sure there's enough room for any header */
-	if (skb_headroom(skb) < dhd->pub.hdrlen) {
+	if (skb_headroom(skb) < drvr_priv->pub.hdrlen) {
 		struct sk_buff *skb2;
 
 		DHD_INFO(("%s: insufficient headroom\n",
-			  brcmf_ifname(&dhd->pub, ifidx)));
-		dhd->pub.tx_realloc++;
-		skb2 = skb_realloc_headroom(skb, dhd->pub.hdrlen);
+			  brcmf_ifname(&drvr_priv->pub, ifidx)));
+		drvr_priv->pub.tx_realloc++;
+		skb2 = skb_realloc_headroom(skb, drvr_priv->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			DHD_ERROR(("%s: skb_realloc_headroom failed\n",
-				   brcmf_ifname(&dhd->pub, ifidx)));
+				   brcmf_ifname(&drvr_priv->pub, ifidx)));
 			ret = -ENOMEM;
 			goto done;
 		}
 	}
 
-	ret = brcmf_sendpkt(&dhd->pub, ifidx, skb);
+	ret = brcmf_sendpkt(&drvr_priv->pub, ifidx, skb);
 
 done:
 	if (ret)
-		dhd->pub.dstats.tx_dropped++;
+		drvr_priv->pub.dstats.tx_dropped++;
 	else
-		dhd->pub.tx_packets++;
+		drvr_priv->pub.tx_packets++;
 
 	/* Return ok: we always eat the packet */
 	return 0;
 }
 
-void brcmf_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
+void brcmf_txflowcontrol(dhd_pub_t *drvr, int ifidx, bool state)
 {
 	struct net_device *net;
-	dhd_info_t *dhd = dhdp->info;
+	dhd_info_t *drvr_priv = drvr->info;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	dhdp->txoff = state;
-	ASSERT(dhd && dhd->iflist[ifidx]);
-	net = dhd->iflist[ifidx]->net;
+	drvr->txoff = state;
+	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
+	net = drvr_priv->iflist[ifidx]->net;
 	if (state == ON)
 		netif_stop_queue(net);
 	else
 		netif_wake_queue(net);
 }
 
-void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
+void brcmf_rx_frame(dhd_pub_t *drvr, int ifidx, struct sk_buff *skb,
 		  int numpkt)
 {
-	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
+	dhd_info_t *drvr_priv = drvr->info;
 	unsigned char *eth;
 	uint len;
 	void *data;
@@ -878,16 +884,16 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 		eth = skb->data;
 		len = skb->len;
 
-		ifp = dhd->iflist[ifidx];
+		ifp = drvr_priv->iflist[ifidx];
 		if (ifp == NULL)
-			ifp = dhd->iflist[0];
+			ifp = drvr_priv->iflist[0];
 
 		ASSERT(ifp);
 		skb->dev = ifp->net;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
-			dhd->pub.rx_multicast++;
+			drvr_priv->pub.rx_multicast++;
 
 		skb->data = eth;
 		skb->len = len;
@@ -897,19 +903,20 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 
 		/* Process special event packets and then discard them */
 		if (ntohs(skb->protocol) == ETH_P_LINK_CTL)
-			brcmf_host_event(dhd, &ifidx,
+			brcmf_host_event(drvr_priv, &ifidx,
 					  skb_mac_header(skb),
 					  &event, &data);
 
-		ASSERT(ifidx < DHD_MAX_IFS && dhd->iflist[ifidx]);
-		if (dhd->iflist[ifidx] && !dhd->iflist[ifidx]->state)
-			ifp = dhd->iflist[ifidx];
+		ASSERT(ifidx < DHD_MAX_IFS && drvr_priv->iflist[ifidx]);
+		if (drvr_priv->iflist[ifidx] &&
+		    !drvr_priv->iflist[ifidx]->state)
+			ifp = drvr_priv->iflist[ifidx];
 
 		if (ifp->net)
 			ifp->net->last_rx = jiffies;
 
-		dhdp->dstats.rx_bytes += skb->len;
-		dhdp->rx_packets++;	/* Local count */
+		drvr->dstats.rx_bytes += skb->len;
+		drvr->rx_packets++;	/* Local count */
 
 		if (in_interrupt()) {
 			netif_rx(skb);
@@ -925,66 +932,66 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 	}
 }
 
-void brcmf_event(struct dhd_info *dhd, char *evpkt, int evlen, int ifidx)
+void brcmf_event(struct dhd_info *drvr_priv, char *evpkt, int evlen, int ifidx)
 {
 	/* Linux version has nothing to do */
 	return;
 }
 
-void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
+void brcmf_txcomplete(dhd_pub_t *drvr, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
-	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
+	dhd_info_t *drvr_priv = drvr->info;
 	struct ethhdr *eh;
 	u16 type;
 
-	brcmf_proto_hdrpull(dhdp, &ifidx, txp);
+	brcmf_proto_hdrpull(drvr, &ifidx, txp);
 
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE)
-		atomic_dec(&dhd->pend_8021x_cnt);
+		atomic_dec(&drvr_priv->pend_8021x_cnt);
 
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 	dhd_if_t *ifp;
 	int ifidx;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	ifidx = brcmf_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == DHD_BAD_IF)
 		return NULL;
 
-	ifp = dhd->iflist[ifidx];
-	ASSERT(dhd && ifp);
+	ifp = drvr_priv->iflist[ifidx];
+	ASSERT(drvr_priv && ifp);
 
-	if (dhd->pub.up) {
+	if (drvr_priv->pub.up) {
 		/* Use the protocol to get dongle stats */
-		brcmf_proto_dstats(&dhd->pub);
+		brcmf_proto_dstats(&drvr_priv->pub);
 	}
 
 	/* Copy dongle stats to net device stats */
-	ifp->stats.rx_packets = dhd->pub.dstats.rx_packets;
-	ifp->stats.tx_packets = dhd->pub.dstats.tx_packets;
-	ifp->stats.rx_bytes = dhd->pub.dstats.rx_bytes;
-	ifp->stats.tx_bytes = dhd->pub.dstats.tx_bytes;
-	ifp->stats.rx_errors = dhd->pub.dstats.rx_errors;
-	ifp->stats.tx_errors = dhd->pub.dstats.tx_errors;
-	ifp->stats.rx_dropped = dhd->pub.dstats.rx_dropped;
-	ifp->stats.tx_dropped = dhd->pub.dstats.tx_dropped;
-	ifp->stats.multicast = dhd->pub.dstats.multicast;
+	ifp->stats.rx_packets = drvr_priv->pub.dstats.rx_packets;
+	ifp->stats.tx_packets = drvr_priv->pub.dstats.tx_packets;
+	ifp->stats.rx_bytes = drvr_priv->pub.dstats.rx_bytes;
+	ifp->stats.tx_bytes = drvr_priv->pub.dstats.tx_bytes;
+	ifp->stats.rx_errors = drvr_priv->pub.dstats.rx_errors;
+	ifp->stats.tx_errors = drvr_priv->pub.dstats.tx_errors;
+	ifp->stats.rx_dropped = drvr_priv->pub.dstats.rx_dropped;
+	ifp->stats.tx_dropped = drvr_priv->pub.dstats.tx_dropped;
+	ifp->stats.multicast = drvr_priv->pub.dstats.multicast;
 
 	return &ifp->stats;
 }
 
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
-static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
+static int brcmf_toe_get(dhd_info_t *drvr_priv, int ifidx, u32 *toe_ol)
 {
 	wl_ioctl_t ioc;
 	char buf[32];
@@ -998,17 +1005,17 @@ static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 	ioc.set = false;
 
 	strcpy(buf, "toe_ol");
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
 			DHD_ERROR(("%s: toe not supported by device\n",
-				   brcmf_ifname(&dhd->pub, ifidx)));
+				   brcmf_ifname(&drvr_priv->pub, ifidx)));
 			return -EOPNOTSUPP;
 		}
 
 		DHD_INFO(("%s: could not get toe_ol: ret=%d\n",
-			  brcmf_ifname(&dhd->pub, ifidx), ret));
+			  brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1018,7 +1025,7 @@ static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 
 /* Set current toe component enables in toe_ol iovar,
 	 and set toe global enable iovar */
-static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
+static int brcmf_toe_set(dhd_info_t *drvr_priv, int ifidx, u32 toe_ol)
 {
 	wl_ioctl_t ioc;
 	char buf[32];
@@ -1036,10 +1043,10 @@ static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe_ol");
 	memcpy(&buf[sizeof("toe_ol")], &toe_ol, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe_ol: ret=%d\n",
-			   brcmf_ifname(&dhd->pub, ifidx), ret));
+			   brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1050,10 +1057,10 @@ static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe");
 	memcpy(&buf[sizeof("toe")], &toe, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe: ret=%d\n",
-			   brcmf_ifname(&dhd->pub, ifidx), ret));
+			   brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1063,10 +1070,10 @@ static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 				    struct ethtool_drvinfo *info)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 
 	sprintf(info->driver, KBUILD_MODNAME);
-	sprintf(info->version, "%lu", dhd->pub.drv_version);
+	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
 	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
 	sprintf(info->bus_info, "%s", dev_name(&wl_cfg80211_get_sdio_func()->dev));
 }
@@ -1075,7 +1082,7 @@ struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
-static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
+static int brcmf_ethtool(dhd_info_t *drvr_priv, void *uaddr)
 {
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
@@ -1109,18 +1116,18 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		}
 
 		/* otherwise, require dongle to be up */
-		else if (!dhd->pub.up) {
+		else if (!drvr_priv->pub.up) {
 			DHD_ERROR(("%s: dongle is not up\n", __func__));
 			return -ENODEV;
 		}
 
 		/* finally, report dongle driver type */
-		else if (dhd->pub.iswl)
+		else if (drvr_priv->pub.iswl)
 			sprintf(info.driver, "wl");
 		else
 			sprintf(info.driver, "xx");
 
-		sprintf(info.version, "%lu", dhd->pub.drv_version);
+		sprintf(info.version, "%lu", drvr_priv->pub.drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
 		DHD_CTL(("%s: given %*s, returning %s\n", __func__,
@@ -1130,7 +1137,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		/* Get toe offload components from dongle */
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
-		ret = brcmf_toe_get(dhd, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(drvr_priv, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -1151,7 +1158,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 			return -EFAULT;
 
 		/* Read the current settings, update and write back */
-		ret = brcmf_toe_get(dhd, 0, &toe_cmpnt);
+		ret = brcmf_toe_get(drvr_priv, 0, &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -1163,17 +1170,17 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		else
 			toe_cmpnt &= ~csum_dir;
 
-		ret = brcmf_toe_set(dhd, 0, toe_cmpnt);
+		ret = brcmf_toe_set(drvr_priv, 0, toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
 		/* If setting TX checksum mode, tell Linux the new mode */
 		if (cmd == ETHTOOL_STXCSUM) {
 			if (edata.data)
-				dhd->iflist[0]->net->features |=
+				drvr_priv->iflist[0]->net->features |=
 				    NETIF_F_IP_CSUM;
 			else
-				dhd->iflist[0]->net->features &=
+				drvr_priv->iflist[0]->net->features &=
 				    ~NETIF_F_IP_CSUM;
 		}
 
@@ -1189,7 +1196,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 				    int cmd)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 	dhd_ioctl_t ioc;
 	int bcmerror = 0;
 	int buflen = 0;
@@ -1198,14 +1205,14 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	int ifidx;
 	bool is_set_key_cmd;
 
-	ifidx = brcmf_net2idx(dhd, net);
+	ifidx = brcmf_net2idx(drvr_priv, net);
 	DHD_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
 
 	if (ifidx == DHD_BAD_IF)
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
-		return brcmf_ethtool(dhd, (void *)ifr->ifr_data);
+		return brcmf_ethtool(drvr_priv, (void *)ifr->ifr_data);
 
 	if (cmd != SIOCDEVPRIVATE)
 		return -EOPNOTSUPP;
@@ -1254,20 +1261,20 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 
 	/* check for local dhd ioctl and handle it */
 	if (driver == DHD_IOCTL_MAGIC) {
-		bcmerror = brcmf_c_ioctl((void *)&dhd->pub, &ioc, buf, buflen);
+		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc, buf, buflen);
 		if (bcmerror)
-			dhd->pub.bcmerror = bcmerror;
+			drvr_priv->pub.bcmerror = bcmerror;
 		goto done;
 	}
 
 	/* send to dongle (must be up, and wl) */
-	if ((dhd->pub.busstate != DHD_BUS_DATA)) {
+	if ((drvr_priv->pub.busstate != DHD_BUS_DATA)) {
 		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
 		bcmerror = -EIO;
 		goto done;
 	}
 
-	if (!dhd->pub.iswl) {
+	if (!drvr_priv->pub.iswl) {
 		bcmerror = -EIO;
 		goto done;
 	}
@@ -1285,7 +1292,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		brcmf_netdev_wait_pend8021x(net);
 
 	bcmerror =
-	    brcmf_proto_ioctl(&dhd->pub, ifidx, (wl_ioctl_t *)&ioc, buf,
+	    brcmf_proto_ioctl(&drvr_priv->pub, ifidx, (wl_ioctl_t *)&ioc, buf,
 			      buflen);
 
 done:
@@ -1305,15 +1312,15 @@ done:
 static int brcmf_netdev_stop(struct net_device *net)
 {
 #if !defined(IGNORE_ETH0_DOWN)
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 	wl_cfg80211_down();
-	if (dhd->pub.up == 0)
+	if (drvr_priv->pub.up == 0)
 		return 0;
 
 	/* Set state and stop OS transmissions */
-	dhd->pub.up = 0;
+	drvr_priv->pub.up = 0;
 	netif_stop_queue(net);
 #else
 	DHD_ERROR(("BYPASS %s:due to BRCM compilation : under investigation\n",
@@ -1325,9 +1332,9 @@ static int brcmf_netdev_stop(struct net_device *net)
 
 static int brcmf_netdev_open(struct net_device *net)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
 	u32 toe_ol;
-	int ifidx = brcmf_net2idx(dhd, net);
+	int ifidx = brcmf_net2idx(drvr_priv, net);
 	s32 ret = 0;
 
 	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
@@ -1335,25 +1342,25 @@ static int brcmf_netdev_open(struct net_device *net)
 	if (ifidx == 0) {	/* do it only for primary eth0 */
 
 		/* try to bring up bus */
-		ret = brcmf_bus_start(&dhd->pub);
+		ret = brcmf_bus_start(&drvr_priv->pub);
 		if (ret != 0) {
 			DHD_ERROR(("%s: failed with code %d\n", __func__, ret));
 			return -1;
 		}
-		atomic_set(&dhd->pend_8021x_cnt, 0);
+		atomic_set(&drvr_priv->pend_8021x_cnt, 0);
 
-		memcpy(net->dev_addr, dhd->pub.mac, ETH_ALEN);
+		memcpy(net->dev_addr, drvr_priv->pub.mac, ETH_ALEN);
 
 		/* Get current TOE mode from dongle */
-		if (brcmf_toe_get(dhd, ifidx, &toe_ol) >= 0
+		if (brcmf_toe_get(drvr_priv, ifidx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			dhd->iflist[ifidx]->net->features |= NETIF_F_IP_CSUM;
+			drvr_priv->iflist[ifidx]->net->features |= NETIF_F_IP_CSUM;
 		else
-			dhd->iflist[ifidx]->net->features &= ~NETIF_F_IP_CSUM;
+			drvr_priv->iflist[ifidx]->net->features &= ~NETIF_F_IP_CSUM;
 	}
 	/* Allow transmit calls */
 	netif_start_queue(net);
-	dhd->pub.up = 1;
+	drvr_priv->pub.up = 1;
 	if (unlikely(wl_cfg80211_up())) {
 		DHD_ERROR(("%s: failed to bring up cfg80211\n",
 			   __func__));
@@ -1364,16 +1371,16 @@ static int brcmf_netdev_open(struct net_device *net)
 }
 
 int
-brcmf_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
+brcmf_add_if(dhd_info_t *drvr_priv, int ifidx, void *handle, char *name,
 	   u8 *mac_addr, u32 flags, u8 bssidx)
 {
 	dhd_if_t *ifp;
 
 	DHD_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
 
-	ASSERT(dhd && (ifidx < DHD_MAX_IFS));
+	ASSERT(drvr_priv && (ifidx < DHD_MAX_IFS));
 
-	ifp = dhd->iflist[ifidx];
+	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC);
 		if (!ifp) {
@@ -1383,8 +1390,8 @@ brcmf_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	}
 
 	memset(ifp, 0, sizeof(dhd_if_t));
-	ifp->info = dhd;
-	dhd->iflist[ifidx] = ifp;
+	ifp->info = drvr_priv;
+	drvr_priv->iflist[ifidx] = ifp;
 	strlcpy(ifp->name, name, IFNAMSIZ);
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
@@ -1392,22 +1399,22 @@ brcmf_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	if (handle == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
-		ASSERT(dhd->sysioc_tsk);
-		up(&dhd->sysioc_sem);
+		ASSERT(drvr_priv->sysioc_tsk);
+		up(&drvr_priv->sysioc_sem);
 	} else
 		ifp->net = (struct net_device *)handle;
 
 	return 0;
 }
 
-void brcmf_del_if(dhd_info_t *dhd, int ifidx)
+void brcmf_del_if(dhd_info_t *drvr_priv, int ifidx)
 {
 	dhd_if_t *ifp;
 
 	DHD_TRACE(("%s: idx %d\n", __func__, ifidx));
 
-	ASSERT(dhd && ifidx && (ifidx < DHD_MAX_IFS));
-	ifp = dhd->iflist[ifidx];
+	ASSERT(drvr_priv && ifidx && (ifidx < DHD_MAX_IFS));
+	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		DHD_ERROR(("%s: Null interface\n", __func__));
 		return;
@@ -1415,27 +1422,27 @@ void brcmf_del_if(dhd_info_t *dhd, int ifidx)
 
 	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
-	ASSERT(dhd->sysioc_tsk);
-	up(&dhd->sysioc_sem);
+	ASSERT(drvr_priv->sysioc_tsk);
+	up(&drvr_priv->sysioc_sem);
 }
 
 dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 {
-	dhd_info_t *dhd = NULL;
+	dhd_info_t *drvr_priv = NULL;
 	struct net_device *net;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Allocate etherdev, including space for private structure */
-	net = alloc_etherdev(sizeof(dhd));
+	net = alloc_etherdev(sizeof(drvr_priv));
 	if (!net) {
 		DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
 		goto fail;
 	}
 
 	/* Allocate primary dhd_info */
-	dhd = kzalloc(sizeof(dhd_info_t), GFP_ATOMIC);
-	if (!dhd) {
+	drvr_priv = kzalloc(sizeof(dhd_info_t), GFP_ATOMIC);
+	if (!drvr_priv) {
 		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
 		goto fail;
 	}
@@ -1443,7 +1450,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/*
 	 * Save the dhd_info into the priv
 	 */
-	memcpy(netdev_priv(net), &dhd, sizeof(dhd));
+	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
 	/* Set network interface name if it was provided as module parameter */
 	if (iface_name[0]) {
@@ -1457,50 +1464,50 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 			strcat(net->name, "%d");
 	}
 
-	if (brcmf_add_if(dhd, 0, (void *)net, net->name, NULL, 0, 0) ==
+	if (brcmf_add_if(drvr_priv, 0, (void *)net, net->name, NULL, 0, 0) ==
 	    DHD_BAD_IF)
 		goto fail;
 
 	net->netdev_ops = NULL;
-	sema_init(&dhd->proto_sem, 1);
+	sema_init(&drvr_priv->proto_sem, 1);
 	/* Initialize other structure content */
-	init_waitqueue_head(&dhd->ioctl_resp_wait);
+	init_waitqueue_head(&drvr_priv->ioctl_resp_wait);
 
 	/* Link to info module */
-	dhd->pub.info = dhd;
+	drvr_priv->pub.info = drvr_priv;
 
 	/* Link to bus module */
-	dhd->pub.bus = bus;
-	dhd->pub.hdrlen = bus_hdrlen;
+	drvr_priv->pub.bus = bus;
+	drvr_priv->pub.hdrlen = bus_hdrlen;
 
 	/* Attach and link in the protocol */
-	if (brcmf_proto_attach(&dhd->pub) != 0) {
+	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
 		DHD_ERROR(("dhd_prot_attach failed\n"));
 		goto fail;
 	}
 
 	/* Attach and link in the cfg80211 */
-	if (unlikely(wl_cfg80211_attach(net, &dhd->pub))) {
+	if (unlikely(wl_cfg80211_attach(net, &drvr_priv->pub))) {
 		DHD_ERROR(("wl_cfg80211_attach failed\n"));
 		goto fail;
 	}
 
 	if (brcmf_sysioc) {
-		sema_init(&dhd->sysioc_sem, 0);
-		dhd->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, dhd,
+		sema_init(&drvr_priv->sysioc_sem, 0);
+		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, drvr_priv,
 						"_dhd_sysioc");
-		if (IS_ERR(dhd->sysioc_tsk)) {
+		if (IS_ERR(drvr_priv->sysioc_tsk)) {
 			printk(KERN_WARNING
 				"_dhd_sysioc thread failed to start\n");
-			dhd->sysioc_tsk = NULL;
+			drvr_priv->sysioc_tsk = NULL;
 		}
 	} else
-		dhd->sysioc_tsk = NULL;
+		drvr_priv->sysioc_tsk = NULL;
 
 	/*
 	 * Save the dhd_info into the priv
 	 */
-	memcpy(netdev_priv(net), &dhd, sizeof(dhd));
+	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 	g_bus = bus;
@@ -1511,36 +1518,36 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
 #ifdef CONFIG_HAS_EARLYSUSPEND
-	dhd->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
-	dhd->early_suspend.suspend = brcmf_early_suspend;
-	dhd->early_suspend.resume = brcmf_late_resume;
-	register_early_suspend(&dhd->early_suspend);
+	drvr_priv->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
+	drvr_priv->early_suspend.suspend = brcmf_early_suspend;
+	drvr_priv->early_suspend.resume = brcmf_late_resume;
+	register_early_suspend(&drvr_priv->early_suspend);
 #endif
 
-	return &dhd->pub;
+	return &drvr_priv->pub;
 
 fail:
 	if (net)
 		free_netdev(net);
-	if (dhd)
-		brcmf_detach(&dhd->pub);
+	if (drvr_priv)
+		brcmf_detach(&drvr_priv->pub);
 
 	return NULL;
 }
 
-int brcmf_bus_start(dhd_pub_t *dhdp)
+int brcmf_bus_start(dhd_pub_t *drvr)
 {
 	int ret = -1;
-	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
+	dhd_info_t *drvr_priv = drvr->info;
 	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
 						 '\0' + bitvec  */
 
-	ASSERT(dhd);
+	ASSERT(drvr_priv);
 
 	DHD_TRACE(("%s:\n", __func__));
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
+	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub, true);
 	if (ret != 0) {
 		DHD_ERROR(("%s, brcmf_sdbrcm_bus_init failed %d\n", __func__,
 			   ret));
@@ -1548,51 +1555,51 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 	}
 
 	/* If bus is not ready, can't come up */
-	if (dhd->pub.busstate != DHD_BUS_DATA) {
+	if (drvr_priv->pub.busstate != DHD_BUS_DATA) {
 		DHD_ERROR(("%s failed bus is not ready\n", __func__));
 		return -ENODEV;
 	}
 
-	brcmu_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN,
+	brcmu_mkiovar("event_msgs", drvr->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf,
+	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
 				    sizeof(iovbuf));
-	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
-
-	setbit(dhdp->eventmask, BRCMF_E_SET_SSID);
-	setbit(dhdp->eventmask, BRCMF_E_PRUNE);
-	setbit(dhdp->eventmask, BRCMF_E_AUTH);
-	setbit(dhdp->eventmask, BRCMF_E_REASSOC);
-	setbit(dhdp->eventmask, BRCMF_E_REASSOC_IND);
-	setbit(dhdp->eventmask, BRCMF_E_DEAUTH_IND);
-	setbit(dhdp->eventmask, BRCMF_E_DISASSOC_IND);
-	setbit(dhdp->eventmask, BRCMF_E_DISASSOC);
-	setbit(dhdp->eventmask, BRCMF_E_JOIN);
-	setbit(dhdp->eventmask, BRCMF_E_ASSOC_IND);
-	setbit(dhdp->eventmask, BRCMF_E_PSK_SUP);
-	setbit(dhdp->eventmask, BRCMF_E_LINK);
-	setbit(dhdp->eventmask, BRCMF_E_NDIS_LINK);
-	setbit(dhdp->eventmask, BRCMF_E_MIC_ERROR);
-	setbit(dhdp->eventmask, BRCMF_E_PMKID_CACHE);
-	setbit(dhdp->eventmask, BRCMF_E_TXFAIL);
-	setbit(dhdp->eventmask, BRCMF_E_JOIN_START);
-	setbit(dhdp->eventmask, BRCMF_E_SCAN_COMPLETE);
+	memcpy(drvr->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
+
+	setbit(drvr->eventmask, BRCMF_E_SET_SSID);
+	setbit(drvr->eventmask, BRCMF_E_PRUNE);
+	setbit(drvr->eventmask, BRCMF_E_AUTH);
+	setbit(drvr->eventmask, BRCMF_E_REASSOC);
+	setbit(drvr->eventmask, BRCMF_E_REASSOC_IND);
+	setbit(drvr->eventmask, BRCMF_E_DEAUTH_IND);
+	setbit(drvr->eventmask, BRCMF_E_DISASSOC_IND);
+	setbit(drvr->eventmask, BRCMF_E_DISASSOC);
+	setbit(drvr->eventmask, BRCMF_E_JOIN);
+	setbit(drvr->eventmask, BRCMF_E_ASSOC_IND);
+	setbit(drvr->eventmask, BRCMF_E_PSK_SUP);
+	setbit(drvr->eventmask, BRCMF_E_LINK);
+	setbit(drvr->eventmask, BRCMF_E_NDIS_LINK);
+	setbit(drvr->eventmask, BRCMF_E_MIC_ERROR);
+	setbit(drvr->eventmask, BRCMF_E_PMKID_CACHE);
+	setbit(drvr->eventmask, BRCMF_E_TXFAIL);
+	setbit(drvr->eventmask, BRCMF_E_JOIN_START);
+	setbit(drvr->eventmask, BRCMF_E_SCAN_COMPLETE);
 
 /* enable dongle roaming event */
 
-	dhdp->pktfilter_count = 1;
+	drvr->pktfilter_count = 1;
 	/* Setup filter to allow only unicast */
-	dhdp->pktfilter[0] = "100 0 0 0 0x01 0x00";
+	drvr->pktfilter[0] = "100 0 0 0 0x01 0x00";
 
 	/* Bus is ready, do any protocol initialization */
-	ret = brcmf_proto_init(&dhd->pub);
+	ret = brcmf_proto_init(&drvr_priv->pub);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int brcmf_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf,
+int brcmf_iovar(dhd_pub_t *drvr, int ifidx, char *name, char *cmd_buf,
 	  uint cmd_len, int set)
 {
 	char buf[strlen(name) + 1 + cmd_len];
@@ -1609,7 +1616,7 @@ int brcmf_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf,
 	ioc.len = len;
 	ioc.set = set;
 
-	ret = brcmf_proto_ioctl(pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(drvr, ifidx, &ioc, ioc.buf, ioc.len);
 	if (!set && ret >= 0)
 		memcpy(cmd_buf, buf, cmd_len);
 
@@ -1626,18 +1633,18 @@ static struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_multicast_list = brcmf_netdev_set_multicast_list
 };
 
-int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
+int brcmf_net_attach(dhd_pub_t *drvr, int ifidx)
 {
-	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
+	dhd_info_t *drvr_priv = drvr->info;
 	struct net_device *net;
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
 	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
 
-	ASSERT(dhd && dhd->iflist[ifidx]);
+	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
 
-	net = dhd->iflist[ifidx]->net;
+	net = drvr_priv->iflist[ifidx]->net;
 	ASSERT(net);
 
 	ASSERT(!net->netdev_ops);
@@ -1648,7 +1655,7 @@ int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
 	 */
 	if (ifidx != 0) {
 		/* for virtual interfaces use the primary MAC  */
-		memcpy(temp_addr, dhd->pub.mac, ETH_ALEN);
+		memcpy(temp_addr, drvr_priv->pub.mac, ETH_ALEN);
 
 	}
 
@@ -1659,10 +1666,11 @@ int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
 			 - Locally Administered address  */
 
 	}
-	net->hard_header_len = ETH_HLEN + dhd->pub.hdrlen;
+	net->hard_header_len = ETH_HLEN + drvr_priv->pub.hdrlen;
 	net->ethtool_ops = &brcmf_ethtool_ops;
 
-	dhd->pub.rxsz = net->mtu + net->hard_header_len + dhd->pub.hdrlen;
+	drvr_priv->pub.rxsz = net->mtu + net->hard_header_len +
+				drvr_priv->pub.hdrlen;
 
 	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
 
@@ -1681,69 +1689,70 @@ fail:
 	return -EBADE;
 }
 
-static void brcmf_bus_detach(dhd_pub_t *dhdp)
+static void brcmf_bus_detach(dhd_pub_t *drvr)
 {
-	dhd_info_t *dhd;
+	dhd_info_t *drvr_priv;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (dhdp) {
-		dhd = (dhd_info_t *) dhdp->info;
-		if (dhd) {
+	if (drvr) {
+		drvr_priv = drvr->info;
+		if (drvr_priv) {
 			/* Stop the protocol module */
-			brcmf_proto_stop(&dhd->pub);
+			brcmf_proto_stop(&drvr_priv->pub);
 
 			/* Stop the bus module */
-			brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
+			brcmf_sdbrcm_bus_stop(drvr_priv->pub.bus, true);
 		}
 	}
 }
 
-void brcmf_detach(dhd_pub_t *dhdp)
+void brcmf_detach(dhd_pub_t *drvr)
 {
-	dhd_info_t *dhd;
+	dhd_info_t *drvr_priv;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (dhdp) {
-		dhd = (dhd_info_t *) dhdp->info;
-		if (dhd) {
+	if (drvr) {
+		drvr_priv = drvr->info;
+		if (drvr_priv) {
 			dhd_if_t *ifp;
 			int i;
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-			if (dhd->early_suspend.suspend)
-				unregister_early_suspend(&dhd->early_suspend);
+			if (drvr_priv->early_suspend.suspend)
+				unregister_early_suspend(
+					&drvr_priv->early_suspend);
 #endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
 
 			for (i = 1; i < DHD_MAX_IFS; i++)
-				if (dhd->iflist[i])
-					brcmf_del_if(dhd, i);
+				if (drvr_priv->iflist[i])
+					brcmf_del_if(drvr_priv, i);
 
-			ifp = dhd->iflist[0];
+			ifp = drvr_priv->iflist[0];
 			ASSERT(ifp);
 			if (ifp->net->netdev_ops == &brcmf_netdev_ops_pri) {
 				brcmf_netdev_stop(ifp->net);
 				unregister_netdev(ifp->net);
 			}
 
-			if (dhd->sysioc_tsk) {
-				send_sig(SIGTERM, dhd->sysioc_tsk, 1);
-				kthread_stop(dhd->sysioc_tsk);
-				dhd->sysioc_tsk = NULL;
+			if (drvr_priv->sysioc_tsk) {
+				send_sig(SIGTERM, drvr_priv->sysioc_tsk, 1);
+				kthread_stop(drvr_priv->sysioc_tsk);
+				drvr_priv->sysioc_tsk = NULL;
 			}
 
-			brcmf_bus_detach(dhdp);
+			brcmf_bus_detach(drvr);
 
-			if (dhdp->prot)
-				brcmf_proto_detach(dhdp);
+			if (drvr->prot)
+				brcmf_proto_detach(drvr);
 
 			wl_cfg80211_detach();
 
 			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
 			kfree(ifp);
-			kfree(dhd);
+			kfree(drvr_priv);
 		}
 	}
 }
@@ -1779,23 +1788,23 @@ module_exit(brcmf_module_cleanup);
 /*
  * OS specific functions required to implement DHD driver in OS independent way
  */
-int brcmf_os_proto_block(dhd_pub_t *pub)
+int brcmf_os_proto_block(dhd_pub_t *drvr)
 {
-	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
+	dhd_info_t *drvr_priv = drvr->info;
 
-	if (dhd) {
-		down(&dhd->proto_sem);
+	if (drvr_priv) {
+		down(&drvr_priv->proto_sem);
 		return 1;
 	}
 	return 0;
 }
 
-int brcmf_os_proto_unblock(dhd_pub_t *pub)
+int brcmf_os_proto_unblock(dhd_pub_t *drvr)
 {
-	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
+	dhd_info_t *drvr_priv = drvr->info;
 
-	if (dhd) {
-		up(&dhd->proto_sem);
+	if (drvr_priv) {
+		up(&drvr_priv->proto_sem);
 		return 1;
 	}
 
@@ -1812,9 +1821,9 @@ void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
 	brcmf_ioctl_timeout_msec = (int)timeout_msec;
 }
 
-int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
+int brcmf_os_ioctl_resp_wait(dhd_pub_t *drvr, uint *condition, bool *pending)
 {
-	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
+	dhd_info_t *drvr_priv = drvr->info;
 	DECLARE_WAITQUEUE(wait, current);
 	int timeout = brcmf_ioctl_timeout_msec;
 
@@ -1822,7 +1831,7 @@ int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
 	timeout = timeout * HZ / 1000;
 
 	/* Wait until control frame is available */
-	add_wait_queue(&dhd->ioctl_resp_wait, &wait);
+	add_wait_queue(&drvr_priv->ioctl_resp_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!(*condition) && (!signal_pending(current) && timeout))
@@ -1832,57 +1841,57 @@ int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
 		*pending = true;
 
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&dhd->ioctl_resp_wait, &wait);
+	remove_wait_queue(&drvr_priv->ioctl_resp_wait, &wait);
 
 	return timeout;
 }
 
-int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub)
+int brcmf_os_ioctl_resp_wake(dhd_pub_t *drvr)
 {
-	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
+	dhd_info_t *drvr_priv = drvr->info;
 
-	if (waitqueue_active(&dhd->ioctl_resp_wait))
-		wake_up_interruptible(&dhd->ioctl_resp_wait);
+	if (waitqueue_active(&drvr_priv->ioctl_resp_wait))
+		wake_up_interruptible(&drvr_priv->ioctl_resp_wait);
 
 	return 0;
 }
 
-static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
+static int brcmf_host_event(dhd_info_t *drvr_priv, int *ifidx, void *pktdata,
 			    brcmf_event_msg_t *event, void **data)
 {
 	int bcmerror = 0;
 
-	ASSERT(dhd != NULL);
+	ASSERT(drvr_priv != NULL);
 
-	bcmerror = brcmf_c_host_event(dhd, ifidx, pktdata, event, data);
+	bcmerror = brcmf_c_host_event(drvr_priv, ifidx, pktdata, event, data);
 	if (bcmerror != 0)
 		return bcmerror;
 
-	ASSERT(dhd->iflist[*ifidx] != NULL);
-	ASSERT(dhd->iflist[*ifidx]->net != NULL);
-	if (dhd->iflist[*ifidx]->net)
-		wl_cfg80211_event(dhd->iflist[*ifidx]->net, event, *data);
+	ASSERT(drvr_priv->iflist[*ifidx] != NULL);
+	ASSERT(drvr_priv->iflist[*ifidx]->net != NULL);
+	if (drvr_priv->iflist[*ifidx]->net)
+		wl_cfg80211_event(drvr_priv->iflist[*ifidx]->net, event, *data);
 
 	return bcmerror;
 }
 
 int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
 
-	brcmf_bus_devreset(&dhd->pub, flag);
+	brcmf_bus_devreset(&drvr_priv->pub, flag);
 
 	return 1;
 }
 
 int brcmf_netdev_set_suspend_disable(struct net_device *dev, int val)
 {
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
 	int ret = 0;
 
-	if (dhd) {
-		ret = dhd->pub.suspend_disable_flag;
-		dhd->pub.suspend_disable_flag = val;
+	if (drvr_priv) {
+		ret = drvr_priv->pub.suspend_disable_flag;
+		drvr_priv->pub.suspend_disable_flag = val;
 	}
 	return ret;
 }
@@ -1891,12 +1900,12 @@ int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 {
 	int ret = 0;
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
 
-	if (dhd) {
-		brcmf_os_proto_block(&dhd->pub);
-		ret = brcmf_set_suspend(val, &dhd->pub);
-		brcmf_os_proto_unblock(&dhd->pub);
+	if (drvr_priv) {
+		brcmf_os_proto_block(&drvr_priv->pub);
+		ret = brcmf_set_suspend(val, &drvr_priv->pub);
+		brcmf_os_proto_unblock(&drvr_priv->pub);
 	}
 #endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
 	return ret;
@@ -1904,17 +1913,17 @@ int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 
 int brcmf_netdev_set_dtim_skip(struct net_device *dev, int val)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
 
-	if (dhd)
-		dhd->pub.dtim_skip = val;
+	if (drvr_priv)
+		drvr_priv->pub.dtim_skip = val;
 
 	return 0;
 }
 
 int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 {
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(dev);
 	int ret = 0;
 
 	/* Packet filtering is set only if we still in early-suspend and
@@ -1922,37 +1931,37 @@ int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 	 * We can always turn it OFF in case of early-suspend, but we turn it
 	 * back ON only if suspend_disable_flag was not set
 	 */
-	if (dhd && dhd->pub.up) {
-		brcmf_os_proto_block(&dhd->pub);
-		if (dhd->pub.in_suspend) {
-			if (!val || (val && !dhd->pub.suspend_disable_flag))
-				brcmf_set_packet_filter(val, &dhd->pub);
+	if (drvr_priv && drvr_priv->pub.up) {
+		brcmf_os_proto_block(&drvr_priv->pub);
+		if (drvr_priv->pub.in_suspend) {
+			if (!val || (val && !drvr_priv->pub.suspend_disable_flag))
+				brcmf_set_packet_filter(val, &drvr_priv->pub);
 		}
-		brcmf_os_proto_unblock(&dhd->pub);
+		brcmf_os_proto_unblock(&drvr_priv->pub);
 	}
 	return ret;
 }
 
 void brcmf_netdev_init_ioctl(struct net_device *dev)
 {
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
 
-	brcmf_c_preinit_ioctls(&dhd->pub);
+	brcmf_c_preinit_ioctls(&drvr_priv->pub);
 }
 
-static int brcmf_get_pend_8021x_cnt(dhd_info_t *dhd)
+static int brcmf_get_pend_8021x_cnt(dhd_info_t *drvr_priv)
 {
-	return atomic_read(&dhd->pend_8021x_cnt);
+	return atomic_read(&drvr_priv->pend_8021x_cnt);
 }
 
 #define MAX_WAIT_FOR_8021X_TX	10
 
 int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 {
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
+	dhd_info_t *drvr_priv = *(dhd_info_t **)netdev_priv(dev);
 	int timeout = 10 * HZ / 1000;
 	int ntimes = MAX_WAIT_FOR_8021X_TX;
-	int pend = brcmf_get_pend_8021x_cnt(dhd);
+	int pend = brcmf_get_pend_8021x_cnt(drvr_priv);
 
 	while (ntimes && pend) {
 		if (pend) {
@@ -1961,13 +1970,13 @@ int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 			set_current_state(TASK_RUNNING);
 			ntimes--;
 		}
-		pend = brcmf_get_pend_8021x_cnt(dhd);
+		pend = brcmf_get_pend_8021x_cnt(drvr_priv);
 	}
 	return pend;
 }
 
 #ifdef BCMDBG
-int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
+int brcmf_write_to_file(dhd_pub_t *drvr, u8 *buf, int size)
 {
 	int ret = 0;
 	struct file *fp;
-- 
1.7.1


