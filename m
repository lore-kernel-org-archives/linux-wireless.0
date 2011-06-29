Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4642 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604Ab1F2XtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:09 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 049/119] staging: brcm80211: rename fullmac protocol
 related functions
Date: Wed, 29 Jun 2011 16:47:13 -0700
Message-ID: <1309391303-22741-50-git-send-email-frankyl@broadcom.com> (sfid-20110630_015148_920319_F6F83125)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac functions for firmware communication protocol handling
have been renamed to make naming more consistent.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |   49 ++++++++-------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   75 +++++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   56 +++++++++--------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h  |   26 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |    8 +--
 6 files changed, 115 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 3f1b757..2cde233 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -909,8 +909,8 @@ extern void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp,
 			     bool success);
 
 /* Query ioctl */
-extern int dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			      uint len);
+extern int brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
+				       void *buf, uint len);
 
 /* OS independent layer functions */
 extern int brcmf_os_proto_block(dhd_pub_t *pub);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 156abd6..9828ab1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -53,7 +53,7 @@ struct cdc_ioctl {
 	((idx) << CDCF_IOC_IF_SHIFT)))
 
 /*
- * BDC header
+ * BDC header - Broadcom specific extension of CDC.
  * Used on data packets to convey priority across USB.
  */
 #define	BDC_HEADER_LEN		4
@@ -112,7 +112,7 @@ typedef struct dhd_prot {
 	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
 } dhd_prot_t;
 
-static int dhdcdc_msg(dhd_pub_t *dhd)
+static int brcmf_proto_cdc_msg(dhd_pub_t *dhd)
 {
 	dhd_prot_t *prot = dhd->prot;
 	int len = le32_to_cpu(prot->msg.len) + sizeof(struct cdc_ioctl);
@@ -131,7 +131,7 @@ static int dhdcdc_msg(dhd_pub_t *dhd)
 				      len);
 }
 
-static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
+static int brcmf_proto_cdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 {
 	int ret;
 	dhd_prot_t *prot = dhd->prot;
@@ -150,7 +150,8 @@ static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 }
 
 int
-dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
+brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
+			    uint len)
 {
 	dhd_prot_t *prot = dhd->prot;
 	struct cdc_ioctl *msg = &prot->msg;
@@ -184,7 +185,7 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	if (buf)
 		memcpy(prot->buf, buf, len);
 
-	ret = dhdcdc_msg(dhd);
+	ret = brcmf_proto_cdc_msg(dhd);
 	if (ret < 0) {
 		DHD_ERROR(("dhdcdc_query_ioctl: dhdcdc_msg failed w/status "
 			"%d\n", ret));
@@ -193,7 +194,7 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 
 retry:
 	/* wait for interrupt and get first fragment */
-	ret = dhdcdc_cmplt(dhd, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(dhd, prot->reqid, len);
 	if (ret < 0)
 		goto done;
 
@@ -231,7 +232,8 @@ done:
 	return ret;
 }
 
-int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
+int brcmf_proto_cdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
+			      void *buf, uint len)
 {
 	dhd_prot_t *prot = dhd->prot;
 	struct cdc_ioctl *msg = &prot->msg;
@@ -252,11 +254,11 @@ int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	if (buf)
 		memcpy(prot->buf, buf, len);
 
-	ret = dhdcdc_msg(dhd);
+	ret = brcmf_proto_cdc_msg(dhd);
 	if (ret < 0)
 		goto done;
 
-	ret = dhdcdc_cmplt(dhd, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(dhd, prot->reqid, len);
 	if (ret < 0)
 		goto done;
 
@@ -284,7 +286,8 @@ done:
 
 extern int dhd_bus_interface(struct dhd_bus *bus, uint arg, void *arg2);
 int
-dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
+brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf,
+		  int len)
 {
 	dhd_prot_t *prot = dhd->prot;
 	int ret = -1;
@@ -318,9 +321,10 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 	prot->pending = true;
 	prot->lastcmd = ioc->cmd;
 	if (ioc->set)
-		ret = dhdcdc_set_ioctl(dhd, ifidx, ioc->cmd, buf, len);
+		ret = brcmf_proto_cdc_set_ioctl(dhd, ifidx, ioc->cmd, buf, len);
 	else {
-		ret = dhdcdc_query_ioctl(dhd, ifidx, ioc->cmd, buf, len);
+		ret = brcmf_proto_cdc_query_ioctl(dhd, ifidx, ioc->cmd,
+						  buf, len);
 		if (ret > 0)
 			ioc->used = ret - sizeof(struct cdc_ioctl);
 	}
@@ -363,18 +367,18 @@ done:
 	skb->ip_summed is overloaded */
 
 int
-dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
+brcmf_proto_iovar_op(dhd_pub_t *dhdp, const char *name,
 		  void *params, int plen, void *arg, int len, bool set)
 {
 	return -ENOTSUPP;
 }
 
-void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 {
 	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", dhdp->prot->reqid);
 }
 
-void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
+void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 {
 	struct bdc_header *h;
 
@@ -396,7 +400,7 @@ void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
+int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 {
 	struct bdc_header *h;
 
@@ -440,7 +444,7 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	return 0;
 }
 
-int dhd_prot_attach(dhd_pub_t *dhd)
+int brcmf_proto_attach(dhd_pub_t *dhd)
 {
 	dhd_prot_t *cdc;
 
@@ -468,13 +472,13 @@ fail:
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
-void dhd_prot_detach(dhd_pub_t *dhd)
+void brcmf_proto_detach(dhd_pub_t *dhd)
 {
 	kfree(dhd->prot);
 	dhd->prot = NULL;
 }
 
-void dhd_prot_dstats(dhd_pub_t *dhd)
+void brcmf_proto_dstats(dhd_pub_t *dhd)
 {
 	/* No stats from dongle added yet, copy bus stats */
 	dhd->dstats.tx_packets = dhd->tx_packets;
@@ -486,7 +490,7 @@ void dhd_prot_dstats(dhd_pub_t *dhd)
 	return;
 }
 
-int dhd_prot_init(dhd_pub_t *dhd)
+int brcmf_proto_init(dhd_pub_t *dhd)
 {
 	int ret = 0;
 	char buf[128];
@@ -497,7 +501,8 @@ int dhd_prot_init(dhd_pub_t *dhd)
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
-	ret = dhdcdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
+	ret = brcmf_proto_cdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR,
+					  buf, sizeof(buf));
 	if (ret < 0) {
 		brcmf_os_proto_unblock(dhd);
 		return ret;
@@ -516,7 +521,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 	return ret;
 }
 
-void dhd_prot_stop(dhd_pub_t *dhd)
+void brcmf_proto_stop(dhd_pub_t *dhd)
 {
 	/* Nothing to do for CDC */
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index e4680fb..70d2591 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -35,8 +35,6 @@ int brcmf_msg_level;
 char brcmf_fw_path[MOD_PARAM_PATHLEN];
 char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
-extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			    uint len);
 extern void dhd_ind_scan_confirm(void *h, bool status);
 extern int dhd_wl_ioctl(dhd_pub_t *dhd, uint cmd, char *buf, uint buflen);
 void dhd_iscan_lock(void);
@@ -200,7 +198,7 @@ static int brcmf_c_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any prot info */
-	dhd_prot_dump(dhdp, strbuf);
+	brcmf_proto_dump(dhdp, strbuf);
 	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any bus info */
@@ -486,13 +484,15 @@ int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 			/* not in generic table, try protocol module */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror = dhd_prot_iovar_op(dhd_pub, buf, arg,
-							     arglen, buf,
-							     buflen, IOV_GET);
+				bcmerror = brcmf_proto_iovar_op(dhd_pub, buf,
+								arg, arglen,
+								buf, buflen,
+								IOV_GET);
 			else
-				bcmerror = dhd_prot_iovar_op(dhd_pub, buf,
-							     NULL, 0, arg,
-							     arglen, IOV_SET);
+				bcmerror = brcmf_proto_iovar_op(dhd_pub, buf,
+								NULL, 0, arg,
+								arglen,
+								IOV_SET);
 			if (bcmerror != -ENOTSUPP)
 				break;
 
@@ -997,7 +997,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
 
 	/* Enable/disable the specified filter. */
-	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
@@ -1009,7 +1009,8 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
-	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, sizeof(buf));
+	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf,
+				       sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
@@ -1140,7 +1141,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	       &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
-	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
@@ -1162,7 +1163,7 @@ void brcmf_c_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 	int retcode;
 
 	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1179,7 +1180,7 @@ void brcmf_c_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 	int retcode;
 
 	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1220,7 +1221,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	if (!ret) {
 		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
-		ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+		ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
 				       buf, sizeof(buf));
 		if (ret < 0) {
 			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
@@ -1233,7 +1234,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 
 	/* Set Country code */
 	if (dhd->country_code[0] != 0) {
-		if (dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_COUNTRY,
+		if (brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_COUNTRY,
 				     dhd->country_code,
 				     sizeof(dhd->country_code)) < 0) {
 			DHD_ERROR(("%s: country code setting failed\n",
@@ -1245,48 +1246,54 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
 	brcmu_mkiovar("ver", 0, 0, buf, sizeof(buf));
-	dhdcdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
+	brcmf_proto_cdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	DHD_ERROR(("Firmware version = %s\n", buf));
 
 	/* Set PowerSave mode */
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM, (char *)&power_mode,
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM, (char *)&power_mode,
 			 sizeof(power_mode));
 
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
 	/* disable glom option per default */
 	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
 	brcmu_mkiovar("roam_off", (char *)&brcmf_roam, 4,
 		      iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
 	/* Force STA UP */
 	if (brcmf_radio_up)
-		dhdcdc_set_ioctl(dhd, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
+		brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_UP, (char *)&up,
+					  sizeof(up));
 
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", dhd->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
 #ifdef ARP_OFFLOAD_SUPPORT
@@ -1715,14 +1722,15 @@ int dhd_pno_clean(dhd_pub_t *dhd)
 	/* Disable pfn */
 	iov_len = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
 				sizeof(iovbuf));
-	ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+					sizeof(iovbuf));
 	if (ret >= 0) {
 		/* clear pfn */
 		iov_len = brcmu_mkiovar("pfnclear", 0, 0, iovbuf,
 					sizeof(iovbuf));
 		if (iov_len) {
-			ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					iov_len);
+			ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+							iovbuf, iov_len);
 			if (ret < 0) {
 				DHD_ERROR(("%s failed code %d\n", __func__,
 					   ret));
@@ -1751,7 +1759,7 @@ int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
 	ret = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
 			sizeof(iovbuf));
 	if (ret > 0) {
-		ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+		ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 				sizeof(iovbuf));
 		if (ret < 0) {
 			DHD_ERROR(("%s failed for error=%d\n", __func__, ret));
@@ -1823,7 +1831,8 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 
 	brcmu_mkiovar("pfn_set", (char *)&pfn_param, sizeof(pfn_param), iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
+				  sizeof(iovbuf));
 
 	/* set all pfn ssid */
 	for (i = 0; i < nssid; i++) {
@@ -1841,8 +1850,8 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 		err = brcmu_mkiovar("pfn_add", (char *)&pfn_element,
 				sizeof(pfn_element), iovbuf, sizeof(iovbuf));
 		if (err > 0) {
-			err = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					sizeof(iovbuf));
+			err = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+							iovbuf, sizeof(iovbuf));
 			if (err < 0) {
 				DHD_ERROR(("%s failed for i=%d error=%d\n",
 					   __func__, i, err));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f90a0be..006b642 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -414,7 +414,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			DHD_TRACE(("%s: force extra Suspend setting\n",
 				   __func__));
 
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
 					 (char *)&power_mode,
 					 sizeof(power_mode));
 
@@ -434,16 +434,16 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 				bcn_li_dtim = dhd->dtim_skip;
 			brcmu_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
 				    4, iovbuf, sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					 sizeof(iovbuf));
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+						  iovbuf, sizeof(iovbuf));
 #ifdef CUSTOMER_HW2
 			/* Disable build-in roaming to allowed \
 			 * supplicant to take of romaing
 			 */
 			brcmu_mkiovar("roam_off", (char *)&roamvar, 4,
 				    iovbuf, sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					 sizeof(iovbuf));
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+						  iovbuf, sizeof(iovbuf));
 #endif				/* CUSTOMER_HW2 */
 		} else {
 
@@ -452,7 +452,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 				   __func__));
 
 			power_mode = PM_FAST;
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
 					 (char *)&power_mode,
 					 sizeof(power_mode));
 
@@ -463,14 +463,14 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			brcmu_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
 				    4, iovbuf, sizeof(iovbuf));
 
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					 sizeof(iovbuf));
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+						  iovbuf, sizeof(iovbuf));
 #ifdef CUSTOMER_HW2
 			roamvar = 0;
 			brcmu_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf,
 				    sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					 sizeof(iovbuf));
+			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+						  iovbuf, sizeof(iovbuf));
 #endif				/* CUSTOMER_HW2 */
 		}
 	}
@@ -674,7 +674,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set mcast_list failed, cnt %d\n",
 			   brcmf_ifname(&dhd->pub, ifidx), cnt));
@@ -712,7 +712,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set allmulti %d failed\n",
 			   brcmf_ifname(&dhd->pub, ifidx),
@@ -733,7 +733,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ioc.len = sizeof(allmulti);
 	ioc.set = true;
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set promisc %d failed\n",
 			   brcmf_ifname(&dhd->pub, ifidx),
@@ -761,7 +761,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	ioc.len = 32;
 	ioc.set = true;
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set cur_etheraddr failed\n",
 			   brcmf_ifname(&dhd->pub, ifidx)));
@@ -978,7 +978,7 @@ int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 	}
 
 	/* If the protocol uses a data header, apply it */
-	dhd_prot_hdrpush(dhdp, ifidx, pktbuf);
+	brcmf_proto_hdrpush(dhdp, ifidx, pktbuf);
 
 	/* Use bus module to send data frame */
 #ifdef BCMDBUS
@@ -1185,7 +1185,7 @@ void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 	struct ethhdr *eh;
 	u16 type;
 
-	dhd_prot_hdrpull(dhdp, &ifidx, txp);
+	brcmf_proto_hdrpull(dhdp, &ifidx, txp);
 
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
@@ -1212,7 +1212,7 @@ static struct net_device_stats *dhd_get_stats(struct net_device *net)
 
 	if (dhd->pub.up) {
 		/* Use the protocol to get dongle stats */
-		dhd_prot_dstats(&dhd->pub);
+		brcmf_proto_dstats(&dhd->pub);
 	}
 
 	/* Copy dongle stats to net device stats */
@@ -1371,7 +1371,7 @@ static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 	ioc.set = false;
 
 	strcpy(buf, "toe_ol");
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
@@ -1409,7 +1409,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe_ol");
 	memcpy(&buf[sizeof("toe_ol")], &toe_ol, sizeof(u32));
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe_ol: ret=%d\n",
 			   brcmf_ifname(&dhd->pub, ifidx), ret));
@@ -1423,7 +1423,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe");
 	memcpy(&buf[sizeof("toe")], &toe, sizeof(u32));
 
-	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe: ret=%d\n",
 			   brcmf_ifname(&dhd->pub, ifidx), ret));
@@ -1662,7 +1662,8 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		dhd_wait_pend8021x(net);
 
 	bcmerror =
-	    dhd_prot_ioctl(&dhd->pub, ifidx, (wl_ioctl_t *)&ioc, buf, buflen);
+	    brcmf_proto_ioctl(&dhd->pub, ifidx, (wl_ioctl_t *)&ioc, buf,
+			      buflen);
 
 done:
 	if (!bcmerror && buf && ioc.buf) {
@@ -1864,7 +1865,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	dhd->pub.hdrlen = bus_hdrlen;
 
 	/* Attach and link in the protocol */
-	if (dhd_prot_attach(&dhd->pub) != 0) {
+	if (brcmf_proto_attach(&dhd->pub) != 0) {
 		DHD_ERROR(("dhd_prot_attach failed\n"));
 		goto fail;
 	}
@@ -2021,7 +2022,8 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 #ifdef EMBEDDED_PLATFORM
 	brcmu_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	dhdcdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
+	brcmf_proto_cdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf,
+				    sizeof(iovbuf));
 	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
 	setbit(dhdp->eventmask, BRCMF_E_SET_SSID);
@@ -2054,7 +2056,7 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 #endif				/* EMBEDDED_PLATFORM */
 
 	/* Bus is ready, do any protocol initialization */
-	ret = dhd_prot_init(&dhd->pub);
+	ret = brcmf_proto_init(&dhd->pub);
 	if (ret < 0)
 		return ret;
 
@@ -2079,7 +2081,7 @@ dhd_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf, uint cmd_len,
 	ioc.len = len;
 	ioc.set = set;
 
-	ret = dhd_prot_ioctl(pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (!set && ret >= 0)
 		memcpy(cmd_buf, buf, cmd_len);
 
@@ -2161,7 +2163,7 @@ void dhd_bus_detach(dhd_pub_t *dhdp)
 		dhd = (dhd_info_t *) dhdp->info;
 		if (dhd) {
 			/* Stop the protocol module */
-			dhd_prot_stop(&dhd->pub);
+			brcmf_proto_stop(&dhd->pub);
 
 			/* Stop the bus module */
 			brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
@@ -2226,7 +2228,7 @@ void brcmf_detach(dhd_pub_t *dhdp)
 			dhd_bus_detach(dhdp);
 
 			if (dhdp->prot)
-				dhd_prot_detach(dhdp);
+				brcmf_proto_detach(dhdp);
 
 			wl_cfg80211_detach();
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index b2ab3ea..f8ca781 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -30,50 +30,48 @@
  */
 
 /* Linkage, sets prot link and updates hdrlen in pub */
-extern int dhd_prot_attach(dhd_pub_t *dhdp);
+extern int brcmf_proto_attach(dhd_pub_t *dhdp);
 
 /* Unlink, frees allocated protocol memory (including dhd_prot) */
-extern void dhd_prot_detach(dhd_pub_t *dhdp);
+extern void brcmf_proto_detach(dhd_pub_t *dhdp);
 
 /* Initialize protocol: sync w/dongle state.
  * Sets dongle media info (iswl, drv_version, mac address).
  */
-extern int dhd_prot_init(dhd_pub_t *dhdp);
+extern int brcmf_proto_init(dhd_pub_t *dhdp);
 
 /* Stop protocol: sync w/dongle state. */
-extern void dhd_prot_stop(dhd_pub_t *dhdp);
+extern void brcmf_proto_stop(dhd_pub_t *dhdp);
 
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
  */
-extern void dhd_prot_hdrpush(dhd_pub_t *, int ifidx, struct sk_buff *txp);
+extern void brcmf_proto_hdrpush(dhd_pub_t *, int ifidx, struct sk_buff *txp);
 
 /* Remove any protocol-specific data header. */
-extern int dhd_prot_hdrpull(dhd_pub_t *, int *ifidx, struct sk_buff *rxp);
+extern int brcmf_proto_hdrpull(dhd_pub_t *, int *ifidx, struct sk_buff *rxp);
 
 /* Use protocol to issue ioctl to dongle */
-extern int dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc,
+extern int brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc,
 			  void *buf, int len);
 
 /* Check for and handle local prot-specific iovar commands */
-extern int dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
+extern int brcmf_proto_iovar_op(dhd_pub_t *dhdp, const char *name,
 			     void *params, int plen, void *arg, int len,
 			     bool set);
 
 /* Add prot dump output to a buffer */
-extern void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
+extern void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 
 /* Update local copy of dongle statistics */
-extern void dhd_prot_dstats(dhd_pub_t *dhdp);
+extern void brcmf_proto_dstats(dhd_pub_t *dhdp);
 
 extern int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf,
 		     uint buflen);
 
 extern int brcmf_c_preinit_ioctls(dhd_pub_t *dhd);
 
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			    uint len);
-#endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
+extern int brcmf_proto_cdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
+				     void *buf, uint len);
 
 #endif				/* _dhd_proto_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index cb389ae..905afbc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -408,8 +408,6 @@ typedef struct {
 	((prio^2)) : (prio))
 
 DHD_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
-extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			    uint len);
 
 /* Core reg address translation */
 #define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
@@ -3723,8 +3721,8 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 					save_pfirst = pnext;
 				}
 				continue;
-			} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pfirst) !=
-				   0) {
+			} else if (brcmf_proto_hdrpull(bus->dhd, &ifidx, pfirst)
+					!= 0) {
 				DHD_ERROR(("%s: rx protocol error\n",
 					   __func__));
 				bus->dhd->rx_errors++;
@@ -4336,7 +4334,7 @@ deliver:
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
-		} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
+		} else if (brcmf_proto_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
 			DHD_ERROR(("%s: rx protocol error\n", __func__));
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->dhd->rx_errors++;
-- 
1.7.1


