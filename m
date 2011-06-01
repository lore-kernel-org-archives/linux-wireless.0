Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2349 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 66/83] staging: brcm80211: cleaned up prefix for utility
 functions
Date: Wed, 1 Jun 2011 13:45:51 +0200
Message-ID: <1306928768-7501-66-git-send-email-rvossen@broadcom.com> (sfid-20110601_134906_446416_A07CB751)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. 'bcm' replaced by 'brcmu_', which is shorthand for
'Broadcom Utilities' (the 'brcmutil.ko' library module).

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   20 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |  112 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   18 +-
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  180 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   39 +++--
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   31 ++--
 drivers/staging/brcm80211/brcmsmac/bcmdma.h        |    6 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    4 +-
 .../staging/brcm80211/brcmsmac/brcms_mac80211.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |   10 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   14 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   52 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |    2 +-
 drivers/staging/brcm80211/include/bcmutils.h       |  147 ++++++++---------
 drivers/staging/brcm80211/include/bcmwifi.h        |   12 +-
 drivers/staging/brcm80211/util/bcmutils.c          |  135 ++++++++-------
 drivers/staging/brcm80211/util/bcmwifi.c           |   12 +-
 25 files changed, 411 insertions(+), 411 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 3cea01f..1b15704 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -352,7 +352,7 @@ enum {
 	IOV_RXCHAIN
 };
 
-const bcm_iovar_t sdioh_iovars[] = {
+const struct brcmu_iovar sdioh_iovars[] = {
 	{"sd_msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0},
 	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
 								 size) */
@@ -369,7 +369,7 @@ int
 sdioh_iovar_op(sdioh_info_t *si, const char *name,
 	       void *params, int plen, void *arg, int len, bool set)
 {
-	const bcm_iovar_t *vi = NULL;
+	const struct brcmu_iovar *vi = NULL;
 	int bcmerror = 0;
 	int val_size;
 	s32 int_val = 0;
@@ -386,13 +386,13 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 	sd_trace(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
 		  name));
 
-	vi = bcm_iovar_lookup(sdioh_iovars, name);
+	vi = brcmu_iovar_lookup(sdioh_iovars, name);
 	if (vi == NULL) {
 		bcmerror = -ENOTSUPP;
 		goto exit;
 	}
 
-	bcmerror = bcm_iovar_lencheck(vi, arg, len, set);
+	bcmerror = brcmu_iovar_lencheck(vi, arg, len, set);
 	if (bcmerror != 0)
 		goto exit;
 
@@ -888,9 +888,9 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 	if (pkt == NULL) {
 		sd_data(("%s: Creating new %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", buflen_u));
-		mypkt = bcm_pkt_buf_get_skb(buflen_u);
+		mypkt = brcmu_pkt_buf_get_skb(buflen_u);
 		if (!mypkt) {
-			sd_err(("%s: bcm_pkt_buf_get_skb failed: len %d\n",
+			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
 				__func__, buflen_u));
 			return SDIOH_API_RC_FAIL;
 		}
@@ -906,7 +906,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			memcpy(buffer, mypkt->data, buflen_u);
 
-		bcm_pkt_buf_free_skb(mypkt);
+		brcmu_pkt_buf_free_skb(mypkt);
 	} else if (((u32) (pkt->data) & DMA_ALIGN_MASK) != 0) {
 		/* Case 2: We have a packet, but it is unaligned. */
 
@@ -915,9 +915,9 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 
 		sd_data(("%s: Creating aligned %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", pkt->len));
-		mypkt = bcm_pkt_buf_get_skb(pkt->len);
+		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
 		if (!mypkt) {
-			sd_err(("%s: bcm_pkt_buf_get_skb failed: len %d\n",
+			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
 				__func__, pkt->len));
 			return SDIOH_API_RC_FAIL;
 		}
@@ -933,7 +933,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			memcpy(pkt->data, mypkt->data, mypkt->len);
 
-		bcm_pkt_buf_free_skb(mypkt);
+		brcmu_pkt_buf_free_skb(mypkt);
 	} else {		/* case 3: We have a packet and
 				 it is aligned. */
 		sd_data(("%s: Aligned %s Packet, direct DMA\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 065f1ae..b1bb04f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -63,7 +63,7 @@ extern int dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 			    bool set);
 
 /* Add bus dump output to a buffer */
-extern void dhd_bus_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf);
+extern void dhd_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 
 /* Clear any bus counters */
 extern void dhd_bus_clearcounts(dhd_pub_t *dhdp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index f655322..759e899 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -366,9 +366,9 @@ dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
 	return -ENOTSUPP;
 }
 
-void dhd_prot_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
+void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 {
-	bcm_bprintf(strbuf, "Protocol CDC: reqid %d\n", dhdp->prot->reqid);
+	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", dhdp->prot->reqid);
 }
 
 void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 22e5efd..5b0554d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -89,7 +89,7 @@ enum {
 	IOV_LAST
 };
 
-const bcm_iovar_t dhd_iovars[] = {
+const struct brcmu_iovar dhd_iovars[] = {
 	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(dhd_version)}
 	,
 #ifdef DHD_DEBUG
@@ -160,54 +160,54 @@ void dhd_common_init(void)
 
 static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 {
-	struct bcmstrbuf b;
-	struct bcmstrbuf *strbuf = &b;
+	struct brcmu_strbuf b;
+	struct brcmu_strbuf *strbuf = &b;
 
-	bcm_binit(strbuf, buf, buflen);
+	brcmu_binit(strbuf, buf, buflen);
 
 	/* Base DHD info */
-	bcm_bprintf(strbuf, "%s\n", dhd_version);
-	bcm_bprintf(strbuf, "\n");
-	bcm_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
+	brcmu_bprintf(strbuf, "%s\n", dhd_version);
+	brcmu_bprintf(strbuf, "\n");
+	brcmu_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
 		    dhdp->up, dhdp->txoff, dhdp->busstate);
-	bcm_bprintf(strbuf, "pub.hdrlen %d pub.maxctl %d pub.rxsz %d\n",
+	brcmu_bprintf(strbuf, "pub.hdrlen %d pub.maxctl %d pub.rxsz %d\n",
 		    dhdp->hdrlen, dhdp->maxctl, dhdp->rxsz);
-	bcm_bprintf(strbuf, "pub.iswl %d pub.drv_version %ld pub.mac %pM\n",
+	brcmu_bprintf(strbuf, "pub.iswl %d pub.drv_version %ld pub.mac %pM\n",
 		    dhdp->iswl, dhdp->drv_version, &dhdp->mac);
-	bcm_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", dhdp->bcmerror,
+	brcmu_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", dhdp->bcmerror,
 		    dhdp->tickcnt);
 
-	bcm_bprintf(strbuf, "dongle stats:\n");
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf, "dongle stats:\n");
+	brcmu_bprintf(strbuf,
 		    "tx_packets %ld tx_bytes %ld tx_errors %ld tx_dropped %ld\n",
 		    dhdp->dstats.tx_packets, dhdp->dstats.tx_bytes,
 		    dhdp->dstats.tx_errors, dhdp->dstats.tx_dropped);
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf,
 		    "rx_packets %ld rx_bytes %ld rx_errors %ld rx_dropped %ld\n",
 		    dhdp->dstats.rx_packets, dhdp->dstats.rx_bytes,
 		    dhdp->dstats.rx_errors, dhdp->dstats.rx_dropped);
-	bcm_bprintf(strbuf, "multicast %ld\n", dhdp->dstats.multicast);
+	brcmu_bprintf(strbuf, "multicast %ld\n", dhdp->dstats.multicast);
 
-	bcm_bprintf(strbuf, "bus stats:\n");
-	bcm_bprintf(strbuf, "tx_packets %ld tx_multicast %ld tx_errors %ld\n",
+	brcmu_bprintf(strbuf, "bus stats:\n");
+	brcmu_bprintf(strbuf, "tx_packets %ld tx_multicast %ld tx_errors %ld\n",
 		    dhdp->tx_packets, dhdp->tx_multicast, dhdp->tx_errors);
-	bcm_bprintf(strbuf, "tx_ctlpkts %ld tx_ctlerrs %ld\n",
+	brcmu_bprintf(strbuf, "tx_ctlpkts %ld tx_ctlerrs %ld\n",
 		    dhdp->tx_ctlpkts, dhdp->tx_ctlerrs);
-	bcm_bprintf(strbuf, "rx_packets %ld rx_multicast %ld rx_errors %ld\n",
+	brcmu_bprintf(strbuf, "rx_packets %ld rx_multicast %ld rx_errors %ld\n",
 		    dhdp->rx_packets, dhdp->rx_multicast, dhdp->rx_errors);
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf,
 		    "rx_ctlpkts %ld rx_ctlerrs %ld rx_dropped %ld rx_flushed %ld\n",
 		    dhdp->rx_ctlpkts, dhdp->rx_ctlerrs, dhdp->rx_dropped,
 		    dhdp->rx_flushed);
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf,
 		    "rx_readahead_cnt %ld tx_realloc %ld fc_packets %ld\n",
 		    dhdp->rx_readahead_cnt, dhdp->tx_realloc, dhdp->fc_packets);
-	bcm_bprintf(strbuf, "wd_dpc_sched %ld\n", dhdp->wd_dpc_sched);
-	bcm_bprintf(strbuf, "\n");
+	brcmu_bprintf(strbuf, "wd_dpc_sched %ld\n", dhdp->wd_dpc_sched);
+	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any prot info */
 	dhd_prot_dump(dhdp, strbuf);
-	bcm_bprintf(strbuf, "\n");
+	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any bus info */
 	dhd_bus_dump(dhdp, strbuf);
@@ -216,7 +216,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 }
 
 static int
-dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
+dhd_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 	    const char *name, void *params, int plen, void *arg, int len,
 	    int val_size)
 {
@@ -225,7 +225,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	bcmerror = bcm_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
+	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
 		goto exit;
 
@@ -339,7 +339,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	 * exceeding total queue length
 	 */
 	if (!pktq_pfull(q, prec) && !pktq_full(q)) {
-		bcm_pktq_penq(q, prec, pkt);
+		brcmu_pktq_penq(q, prec, pkt);
 		return true;
 	}
 
@@ -347,7 +347,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	if (pktq_pfull(q, prec))
 		eprec = prec;
 	else if (pktq_full(q)) {
-		p = bcm_pktq_peek_tail(q, &eprec);
+		p = brcmu_pktq_peek_tail(q, &eprec);
 		ASSERT(p);
 		if (eprec > prec)
 			return false;
@@ -361,21 +361,21 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 		if (eprec == prec && !discard_oldest)
 			return false;	/* refuse newer (incoming) packet */
 		/* Evict packet according to discard policy */
-		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
-			bcm_pktq_pdeq_tail(q, eprec);
+		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
+			brcmu_pktq_pdeq_tail(q, eprec);
 		if (p == NULL) {
-			DHD_ERROR(("%s: bcm_pktq_penq() failed, oldest %d.",
+			DHD_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
 				   __func__, discard_oldest));
 			ASSERT(p);
 		}
 
-		bcm_pkt_buf_free_skb(p);
+		brcmu_pkt_buf_free_skb(p);
 	}
 
 	/* Enqueue */
-	p = bcm_pktq_penq(q, prec, pkt);
+	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL) {
-		DHD_ERROR(("%s: bcm_pktq_penq() failed.", __func__));
+		DHD_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
 		ASSERT(p);
 	}
 
@@ -388,7 +388,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 {
 	int bcmerror = 0;
 	int val_size;
-	const bcm_iovar_t *vi = NULL;
+	const struct brcmu_iovar *vi = NULL;
 	u32 actionid;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -402,7 +402,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 	/* Set does NOT take qualifiers */
 	ASSERT(!set || (!params && !plen));
 
-	vi = bcm_iovar_lookup(dhd_iovars, name);
+	vi = brcmu_iovar_lookup(dhd_iovars, name);
 	if (vi == NULL) {
 		bcmerror = -ENOTSUPP;
 		goto exit;
@@ -1013,7 +1013,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 			   __func__, arg));
 
 	/* Contorl the master mode */
-	bcm_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
+	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
 	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
@@ -1167,7 +1167,7 @@ void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 	char iovbuf[32];
 	int retcode;
 
-	bcm_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
 	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1183,7 +1183,7 @@ void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 	char iovbuf[32];
 	int retcode;
 
-	bcm_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
 	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -1222,7 +1222,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	 */
 	ret = dhd_custom_get_mac_address(ea_addr);
 	if (!ret) {
-		bcm_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
+		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 		if (ret < 0) {
@@ -1247,7 +1247,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
-	bcm_mkiovar("ver", 0, 0, buf, sizeof(buf));
+	brcmu_mkiovar("ver", 0, 0, buf, sizeof(buf));
 	dhdcdc_query_ioctl(dhd, 0, WLC_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
@@ -1258,23 +1258,23 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 			 sizeof(power_mode));
 
 	/* Match Host and Dongle rx alignment */
-	bcm_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
+	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* disable glom option per default */
-	bcm_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
-	bcm_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
+	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	bcm_mkiovar("roam_off", (char *)&dhd_roam, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("roam_off", (char *)&dhd_roam, 4, iovbuf, sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Force STA UP */
@@ -1282,8 +1282,8 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 		dhdcdc_set_ioctl(dhd, 0, WLC_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
-	bcm_mkiovar("event_msgs", dhd->eventmask, WL_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
+	brcmu_mkiovar("event_msgs", dhd->eventmask, WL_EVENTING_MASK_LEN,
+		      iovbuf, sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_SCAN_CHANNEL_TIME,
@@ -1647,7 +1647,7 @@ int dhd_iscan_request(void *dhdp, u16 action)
 	params.action = action;
 	params.scan_duration = 0;
 
-	bcm_mkiovar("iscan", (char *)&params, sizeof(wl_iscan_params_t), buf,
+	brcmu_mkiovar("iscan", (char *)&params, sizeof(wl_iscan_params_t), buf,
 		    WLC_IOCTL_SMLEN);
 	rc = dhd_wl_ioctl(dhdp, WLC_SET_VAR, buf, WLC_IOCTL_SMLEN);
 
@@ -1683,8 +1683,9 @@ static int dhd_iscan_get_partial_result(void *dhdp, uint *scan_count)
 
 	memset(&list, 0, sizeof(list));
 	list.results.buflen = WLC_IW_ISCAN_MAXLEN;
-	bcm_mkiovar("iscanresults", (char *)&list, WL_ISCAN_RESULTS_FIXED_SIZE,
-		    iscan_cur->iscan_buf, WLC_IW_ISCAN_MAXLEN);
+	brcmu_mkiovar("iscanresults", (char *)&list,
+		      WL_ISCAN_RESULTS_FIXED_SIZE,
+		      iscan_cur->iscan_buf, WLC_IW_ISCAN_MAXLEN);
 	rc = dhd_wl_ioctl(dhdp, WLC_GET_VAR, iscan_cur->iscan_buf,
 			  WLC_IW_ISCAN_MAXLEN);
 
@@ -1714,12 +1715,13 @@ int dhd_pno_clean(dhd_pub_t *dhd)
 	int ret;
 
 	/* Disable pfn */
-	iov_len =
-	    bcm_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf, sizeof(iovbuf));
+	iov_len = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
+				sizeof(iovbuf));
 	ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (ret >= 0) {
 		/* clear pfn */
-		iov_len = bcm_mkiovar("pfnclear", 0, 0, iovbuf, sizeof(iovbuf));
+		iov_len = brcmu_mkiovar("pfnclear", 0, 0, iovbuf,
+					sizeof(iovbuf));
 		if (iov_len) {
 			ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					iov_len);
@@ -1748,7 +1750,7 @@ int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
 	}
 
 	/* Enable/disable PNO */
-	ret = bcm_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
+	ret = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
 			sizeof(iovbuf));
 	if (ret > 0) {
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
@@ -1821,7 +1823,7 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 	if (scan_fr != 0)
 		pfn_param.scan_freq = scan_fr;
 
-	bcm_mkiovar("pfn_set", (char *)&pfn_param, sizeof(pfn_param), iovbuf,
+	brcmu_mkiovar("pfn_set", (char *)&pfn_param, sizeof(pfn_param), iovbuf,
 		    sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 
@@ -1838,7 +1840,7 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 		       ssids_local[i].SSID_len);
 		pfn_element.ssid.SSID_len = ssids_local[i].SSID_len;
 
-		err = bcm_mkiovar("pfn_add", (char *)&pfn_element,
+		err = brcmu_mkiovar("pfn_add", (char *)&pfn_element,
 				sizeof(pfn_element), iovbuf, sizeof(iovbuf));
 		if (err > 0) {
 			err = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6ba50bb..7f1cf8b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -485,7 +485,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 				bcn_li_dtim = 3;
 			else
 				bcn_li_dtim = dhd->dtim_skip;
-			bcm_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
+			brcmu_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
 				    4, iovbuf, sizeof(iovbuf));
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
@@ -493,7 +493,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			/* Disable build-in roaming to allowed \
 			 * supplicant to take of romaing
 			 */
-			bcm_mkiovar("roam_off", (char *)&roamvar, 4,
+			brcmu_mkiovar("roam_off", (char *)&roamvar, 4,
 				    iovbuf, sizeof(iovbuf));
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
@@ -513,14 +513,14 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			dhd_set_packet_filter(0, dhd);
 
 			/* restore pre-suspend setting for dtim_skip */
-			bcm_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
+			brcmu_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
 				    4, iovbuf, sizeof(iovbuf));
 
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
 #ifdef CUSTOMER_HW2
 			roamvar = 0;
-			bcm_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf,
+			brcmu_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf,
 				    sizeof(iovbuf));
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
@@ -750,7 +750,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	}
 	allmulti = cpu_to_le32(allmulti);
 
-	if (!bcm_mkiovar
+	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
 		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
 			"buflen %u\n", dhd_ifname(&dhd->pub, ifidx),
@@ -802,7 +802,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	int ret;
 
 	DHD_TRACE(("%s enter\n", __func__));
-	if (!bcm_mkiovar
+	if (!brcmu_mkiovar
 	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
 		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
 			   dhd_ifname(&dhd->pub, ifidx)));
@@ -2091,8 +2091,8 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 		return -ENODEV;
 	}
 #ifdef EMBEDDED_PLATFORM
-	bcm_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
+	brcmu_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN,
+		      iovbuf, sizeof(iovbuf));
 	dhdcdc_query_ioctl(dhdp, 0, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
 	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
@@ -2142,7 +2142,7 @@ dhd_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf, uint cmd_len,
 	wl_ioctl_t ioc;
 	int ret;
 
-	len = bcm_mkiovar(name, cmd_buf, cmd_len, buf, len);
+	len = brcmu_mkiovar(name, cmd_buf, cmd_len, buf, len);
 
 	memset(&ioc, 0, sizeof(ioc));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index d0c8321..188b588 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -61,7 +61,7 @@ extern int dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
 			     bool set);
 
 /* Add prot dump output to a buffer */
-extern void dhd_prot_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf);
+extern void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 
 /* Update local copy of dongle statistics */
 extern void dhd_prot_dstats(dhd_pub_t *dhdp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4a14688..44839e0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -765,7 +765,7 @@ static void dhdsdio_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
 {
 	dhd_os_sdlock_rxq(bus->dhd);
 	if ((bus->bus != SPI_BUS) || bus->usebufpool)
-		bcm_pkt_buf_free_skb(pkt);
+		brcmu_pkt_buf_free_skb(pkt);
 	dhd_os_sdunlock_rxq(bus->dhd);
 }
 
@@ -1165,7 +1165,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
 				  __func__, skb_headroom(pkt), pad));
 			bus->dhd->tx_realloc++;
-			new = bcm_pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
+			new = brcmu_pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
 			if (!new) {
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
 					"packet\n",
@@ -1177,7 +1177,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			PKTALIGN(new, pkt->len, DHD_SDALIGN);
 			memcpy(new->data, pkt->data, pkt->len);
 			if (free_pkt)
-				bcm_pkt_buf_free_skb(pkt);
+				brcmu_pkt_buf_free_skb(pkt);
 			/* free the pkt if canned one is not used */
 			free_pkt = true;
 			pkt = new;
@@ -1294,7 +1294,7 @@ done:
 	dhd_os_sdlock(bus->dhd);
 
 	if (free_pkt)
-		bcm_pkt_buf_free_skb(pkt);
+		brcmu_pkt_buf_free_skb(pkt);
 
 	return ret;
 }
@@ -1343,7 +1343,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		if (dhd_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
 			dhd_txcomplete(bus->dhd, pkt, false);
-			bcm_pkt_buf_free_skb(pkt);
+			brcmu_pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
 			ret = -ENOSR;
 		} else {
@@ -1416,7 +1416,7 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 	/* Send frames until the limit or some other event */
 	for (cnt = 0; (cnt < maxframes) && DATAOK(bus); cnt++) {
 		dhd_os_sdlock_txq(bus->dhd);
-		pkt = bcm_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
+		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
 		if (pkt == NULL) {
 			dhd_os_sdunlock_txq(bus->dhd);
 			break;
@@ -1702,7 +1702,7 @@ enum {
 	IOV_VARS
 };
 
-const bcm_iovar_t dhdsdio_iovars[] = {
+const struct brcmu_iovar dhdsdio_iovars[] = {
 	{"intr", IOV_INTR, 0, IOVT_BOOL, 0},
 	{"sleep", IOV_SLEEP, 0, IOVT_BOOL, 0},
 	{"pollrate", IOV_POLLRATE, 0, IOVT_UINT32, 0},
@@ -1752,50 +1752,51 @@ const bcm_iovar_t dhdsdio_iovars[] = {
 };
 
 static void
-dhd_dump_pct(struct bcmstrbuf *strbuf, char *desc, uint num, uint div)
+dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 {
 	uint q1, q2;
 
 	if (!div) {
-		bcm_bprintf(strbuf, "%s N/A", desc);
+		brcmu_bprintf(strbuf, "%s N/A", desc);
 	} else {
 		q1 = num / div;
 		q2 = (100 * (num - (q1 * div))) / div;
-		bcm_bprintf(strbuf, "%s %d.%02d", desc, q1, q2);
+		brcmu_bprintf(strbuf, "%s %d.%02d", desc, q1, q2);
 	}
 }
 
-void dhd_bus_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
+void dhd_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 {
 	dhd_bus_t *bus = dhdp->bus;
 
-	bcm_bprintf(strbuf, "Bus SDIO structure:\n");
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf, "Bus SDIO structure:\n");
+	brcmu_bprintf(strbuf,
 		    "hostintmask 0x%08x intstatus 0x%08x sdpcm_ver %d\n",
 		    bus->hostintmask, bus->intstatus, bus->sdpcm_ver);
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf,
 		    "fcstate %d qlen %d tx_seq %d, max %d, rxskip %d rxlen %d rx_seq %d\n",
 		    bus->fcstate, pktq_len(&bus->txq), bus->tx_seq, bus->tx_max,
 		    bus->rxskip, bus->rxlen, bus->rx_seq);
-	bcm_bprintf(strbuf, "intr %d intrcount %d lastintrs %d spurious %d\n",
+	brcmu_bprintf(strbuf, "intr %d intrcount %d lastintrs %d spurious %d\n",
 		    bus->intr, bus->intrcount, bus->lastintrs, bus->spurious);
-	bcm_bprintf(strbuf, "pollrate %d pollcnt %d regfails %d\n",
+	brcmu_bprintf(strbuf, "pollrate %d pollcnt %d regfails %d\n",
 		    bus->pollrate, bus->pollcnt, bus->regfails);
 
-	bcm_bprintf(strbuf, "\nAdditional counters:\n");
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf, "\nAdditional counters:\n");
+	brcmu_bprintf(strbuf,
 		    "tx_sderrs %d fcqueued %d rxrtx %d rx_toolong %d rxc_errors %d\n",
 		    bus->tx_sderrs, bus->fcqueued, bus->rxrtx, bus->rx_toolong,
 		    bus->rxc_errors);
-	bcm_bprintf(strbuf, "rx_hdrfail %d badhdr %d badseq %d\n",
+	brcmu_bprintf(strbuf, "rx_hdrfail %d badhdr %d badseq %d\n",
 		    bus->rx_hdrfail, bus->rx_badhdr, bus->rx_badseq);
-	bcm_bprintf(strbuf, "fc_rcvd %d, fc_xoff %d, fc_xon %d\n", bus->fc_rcvd,
-		    bus->fc_xoff, bus->fc_xon);
-	bcm_bprintf(strbuf, "rxglomfail %d, rxglomframes %d, rxglompkts %d\n",
+	brcmu_bprintf(strbuf, "fc_rcvd %d, fc_xoff %d, fc_xon %d\n",
+		      bus->fc_rcvd, bus->fc_xoff, bus->fc_xon);
+	brcmu_bprintf(strbuf, "rxglomfail %d, rxglomframes %d, rxglompkts %d\n",
 		    bus->rxglomfail, bus->rxglomframes, bus->rxglompkts);
-	bcm_bprintf(strbuf, "f2rx (hdrs/data) %d (%d/%d), f2tx %d f1regs %d\n",
-		    (bus->f2rxhdrs + bus->f2rxdata), bus->f2rxhdrs,
-		    bus->f2rxdata, bus->f2txdata, bus->f1regdata);
+	brcmu_bprintf(strbuf, "f2rx (hdrs/data) %d (%d/%d), f2tx %d f1regs"
+		      " %d\n",
+		      (bus->f2rxhdrs + bus->f2rxdata), bus->f2rxhdrs,
+		      bus->f2rxdata, bus->f2txdata, bus->f1regdata);
 	{
 		dhd_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->dhd->rx_packets,
 			     (bus->f2rxhdrs + bus->f2rxdata));
@@ -1805,13 +1806,13 @@ void dhd_bus_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
 			     (bus->f2rxhdrs + bus->f2rxdata + bus->f1regdata));
 		dhd_dump_pct(strbuf, ", pkts/int", bus->dhd->rx_packets,
 			     bus->intrcount);
-		bcm_bprintf(strbuf, "\n");
+		brcmu_bprintf(strbuf, "\n");
 
 		dhd_dump_pct(strbuf, "Rx: glom pct", (100 * bus->rxglompkts),
 			     bus->dhd->rx_packets);
 		dhd_dump_pct(strbuf, ", pkts/glom", bus->rxglompkts,
 			     bus->rxglomframes);
-		bcm_bprintf(strbuf, "\n");
+		brcmu_bprintf(strbuf, "\n");
 
 		dhd_dump_pct(strbuf, "Tx: pkts/f2wr", bus->dhd->tx_packets,
 			     bus->f2txdata);
@@ -1821,7 +1822,7 @@ void dhd_bus_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
 			     (bus->f2txdata + bus->f1regdata));
 		dhd_dump_pct(strbuf, ", pkts/int", bus->dhd->tx_packets,
 			     bus->intrcount);
-		bcm_bprintf(strbuf, "\n");
+		brcmu_bprintf(strbuf, "\n");
 
 		dhd_dump_pct(strbuf, "Total: pkts/f2rw",
 			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
@@ -1836,30 +1837,30 @@ void dhd_bus_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
 		dhd_dump_pct(strbuf, ", pkts/int",
 			     (bus->dhd->tx_packets + bus->dhd->rx_packets),
 			     bus->intrcount);
-		bcm_bprintf(strbuf, "\n\n");
+		brcmu_bprintf(strbuf, "\n\n");
 	}
 
 #ifdef SDTEST
 	if (bus->pktgen_count) {
-		bcm_bprintf(strbuf, "pktgen config and count:\n");
-		bcm_bprintf(strbuf,
+		brcmu_bprintf(strbuf, "pktgen config and count:\n");
+		brcmu_bprintf(strbuf,
 			    "freq %d count %d print %d total %d min %d len %d\n",
 			    bus->pktgen_freq, bus->pktgen_count,
 			    bus->pktgen_print, bus->pktgen_total,
 			    bus->pktgen_minlen, bus->pktgen_maxlen);
-		bcm_bprintf(strbuf, "send attempts %d rcvd %d fail %d\n",
+		brcmu_bprintf(strbuf, "send attempts %d rcvd %d fail %d\n",
 			    bus->pktgen_sent, bus->pktgen_rcvd,
 			    bus->pktgen_fail);
 	}
 #endif				/* SDTEST */
 #ifdef DHD_DEBUG
-	bcm_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
+	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
 		    bus->dpc_sched,
 		    (bcmsdh_intr_pending(bus->sdh) ? " " : " not "));
-	bcm_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
+	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
 		    bus->roundup);
 #endif				/* DHD_DEBUG */
-	bcm_bprintf(strbuf,
+	brcmu_bprintf(strbuf,
 		    "clkstate %d activity %d idletime %d idlecount %d sleeping %d\n",
 		    bus->clkstate, bus->activity, bus->idletime, bus->idlecount,
 		    bus->sleeping);
@@ -2054,7 +2055,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	char *str = NULL;
 	trap_t tr;
 	struct sdpcm_shared sdpcm_shared;
-	struct bcmstrbuf strbuf;
+	struct brcmu_strbuf strbuf;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -2084,9 +2085,9 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	if (bcmerror < 0)
 		goto done;
 
-	bcm_binit(&strbuf, data, size);
+	brcmu_binit(&strbuf, data, size);
 
-	bcm_bprintf(&strbuf,
+	brcmu_bprintf(&strbuf,
 		    "msgtrace address : 0x%08X\nconsole address  : 0x%08X\n",
 		    sdpcm_shared.msgtrace_addr, sdpcm_shared.console_addr);
 
@@ -2095,7 +2096,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		 * (Avoids conflict with real asserts for programmatic
 		 * parsing of output.)
 		 */
-		bcm_bprintf(&strbuf, "Assrt not built in dongle\n");
+		brcmu_bprintf(&strbuf, "Assrt not built in dongle\n");
 	}
 
 	if ((sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP)) ==
@@ -2104,13 +2105,13 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		 * (Avoids conflict with real asserts for programmatic
 		 * parsing of output.)
 		 */
-		bcm_bprintf(&strbuf, "No trap%s in dongle",
+		brcmu_bprintf(&strbuf, "No trap%s in dongle",
 			    (sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT)
 			    ? "/assrt" : "");
 	} else {
 		if (sdpcm_shared.flags & SDPCM_SHARED_ASSERT) {
 			/* Download assert */
-			bcm_bprintf(&strbuf, "Dongle assert");
+			brcmu_bprintf(&strbuf, "Dongle assert");
 			if (sdpcm_shared.assert_exp_addr != 0) {
 				str[0] = '\0';
 				bcmerror = dhdsdio_membytes(bus, false,
@@ -2120,7 +2121,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 					goto done;
 
 				str[maxstrlen - 1] = '\0';
-				bcm_bprintf(&strbuf, " expr \"%s\"", str);
+				brcmu_bprintf(&strbuf, " expr \"%s\"", str);
 			}
 
 			if (sdpcm_shared.assert_file_addr != 0) {
@@ -2132,10 +2133,10 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 					goto done;
 
 				str[maxstrlen - 1] = '\0';
-				bcm_bprintf(&strbuf, " file \"%s\"", str);
+				brcmu_bprintf(&strbuf, " file \"%s\"", str);
 			}
 
-			bcm_bprintf(&strbuf, " line %d ",
+			brcmu_bprintf(&strbuf, " line %d ",
 				    sdpcm_shared.assert_line);
 		}
 
@@ -2146,7 +2147,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 			if (bcmerror < 0)
 				goto done;
 
-			bcm_bprintf(&strbuf,
+			brcmu_bprintf(&strbuf,
 				    "Dongle trap type 0x%x @ epc 0x%x, cpsr 0x%x, spsr 0x%x, sp 0x%x,"
 				    "lp 0x%x, rpc 0x%x Trap offset 0x%x, "
 				    "r0 0x%x, r1 0x%x, r2 0x%x, r3 0x%x, r4 0x%x, r5 0x%x, r6 0x%x, r7 0x%x\n",
@@ -2333,7 +2334,7 @@ err:
 }
 
 static int
-dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
+dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		const char *name, void *params, int plen, void *arg, int len,
 		int val_size)
 {
@@ -2345,7 +2346,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		"len %d val_size %d\n",
 		__func__, actionid, name, params, plen, arg, len, val_size));
 
-	bcmerror = bcm_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
+	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
 		goto exit;
 
@@ -2889,7 +2890,7 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		 void *params, int plen, void *arg, int len, bool set)
 {
 	dhd_bus_t *bus = dhdp->bus;
-	const bcm_iovar_t *vi = NULL;
+	const struct brcmu_iovar *vi = NULL;
 	int bcmerror = 0;
 	int val_size;
 	u32 actionid;
@@ -2906,7 +2907,7 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 	ASSERT(!set || (!params && !plen));
 
 	/* Look up var locally; if not found pass to host driver */
-	vi = bcm_iovar_lookup(dhdsdio_iovars, name);
+	vi = brcmu_iovar_lookup(dhdsdio_iovars, name);
 	if (vi == NULL) {
 		dhd_os_sdlock(bus->dhd);
 
@@ -3025,14 +3026,14 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	dhdsdio_clkctl(bus, CLK_SDONLY, false);
 
 	/* Clear the data packet queues */
-	bcm_pktq_flush(&bus->txq, true, NULL, NULL);
+	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
 
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
-		bcm_pkt_buf_free_skb(bus->glomd);
+		brcmu_pkt_buf_free_skb(bus->glomd);
 
 	if (bus->glom)
-		bcm_pkt_buf_free_skb(bus->glom);
+		brcmu_pkt_buf_free_skb(bus->glom);
 
 	bus->glom = bus->glomd = NULL;
 
@@ -3384,7 +3385,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 
 			/* Allocate/chain packet for next subframe */
-			pnext = bcm_pkt_buf_get_skb(sublen + DHD_SDALIGN);
+			pnext = brcmu_pkt_buf_get_skb(sublen + DHD_SDALIGN);
 			if (pnext == NULL) {
 				DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
 					"num %d len %d\n", __func__,
@@ -3421,13 +3422,13 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			pfirst = pnext = NULL;
 		} else {
 			if (pfirst)
-				bcm_pkt_buf_free_skb(pfirst);
+				brcmu_pkt_buf_free_skb(pfirst);
 			bus->glom = NULL;
 			num = 0;
 		}
 
 		/* Done with descriptor packet */
-		bcm_pkt_buf_free_skb(bus->glomd);
+		brcmu_pkt_buf_free_skb(bus->glomd);
 		bus->glomd = NULL;
 		bus->nextlen = 0;
 
@@ -3448,7 +3449,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		}
 
 		pfirst = bus->glom;
-		dlen = (u16) bcm_pkttotlen(pfirst);
+		dlen = (u16) brcmu_pkttotlen(pfirst);
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
 		 * read directly into the chained packet, or allocate a large
@@ -3464,7 +3465,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
-			sublen = (u16) bcm_pktfrombuf(pfirst, 0, dlen,
+			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
 				DHD_ERROR(("%s: FAILED TO COPY, dlen %d sublen %d\n",
@@ -3492,7 +3493,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
 				dhd_os_sdlock_rxq(bus->dhd);
-				bcm_pkt_buf_free_skb(bus->glom);
+				brcmu_pkt_buf_free_skb(bus->glom);
 				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3625,7 +3626,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
 				dhd_os_sdlock_rxq(bus->dhd);
-				bcm_pkt_buf_free_skb(bus->glom);
+				brcmu_pkt_buf_free_skb(bus->glom);
 				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3676,7 +3677,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			skb_pull(pfirst, doff);
 
 			if (pfirst->len == 0) {
-				bcm_pkt_buf_free_skb(pfirst);
+				brcmu_pkt_buf_free_skb(pfirst);
 				if (plast) {
 					plast->next = pnext;
 				} else {
@@ -3689,7 +3690,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				DHD_ERROR(("%s: rx protocol error\n",
 					   __func__));
 				bus->dhd->rx_errors++;
-				bcm_pkt_buf_free_skb(pfirst);
+				brcmu_pkt_buf_free_skb(pfirst);
 				if (plast) {
 					plast->next = pnext;
 				} else {
@@ -3827,7 +3828,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			 */
 			/* Allocate a packet buffer */
 			dhd_os_sdlock_rxq(bus->dhd);
-			pkt = bcm_pkt_buf_get_skb(rdlen + DHD_SDALIGN);
+			pkt = brcmu_pkt_buf_get_skb(rdlen + DHD_SDALIGN);
 			if (!pkt) {
 				if (bus->bus == SPI_BUS) {
 					bus->usebufpool = false;
@@ -3871,7 +3872,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					/* Give up on data,
 					request rtx of events */
 					DHD_ERROR(("%s (nextlen): "
-						   "bcm_pkt_buf_get_skb failed:"
+						   "brcmu_pkt_buf_get_skb "
+						   "failed:"
 						   " len %d rdlen %d expected"
 						   " rxseq %d\n", __func__,
 						   len, rdlen, rxseq));
@@ -3899,7 +3901,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				if (sdret < 0) {
 					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
 						__func__, rdlen, sdret));
-					bcm_pkt_buf_free_skb(pkt);
+					brcmu_pkt_buf_free_skb(pkt);
 					bus->dhd->rx_errors++;
 					dhd_os_sdunlock_rxq(bus->dhd);
 					/* Force retry w/normal header read.
@@ -4212,11 +4214,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		}
 
 		dhd_os_sdlock_rxq(bus->dhd);
-		pkt = bcm_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
+		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed: rdlen %d "
-				"chan %d\n", __func__, rdlen, chan));
+			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
+				   " chan %d\n", __func__, rdlen, chan));
 			bus->dhd->rx_dropped++;
 			dhd_os_sdunlock_rxq(bus->dhd);
 			dhdsdio_rxfail(bus, false, RETRYCHAN(chan));
@@ -4247,7 +4249,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				       ? "data" : "test")),
 				   sdret));
 			dhd_os_sdlock_rxq(bus->dhd);
-			bcm_pkt_buf_free_skb(pkt);
+			brcmu_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			dhdsdio_rxfail(bus, true, RETRYCHAN(chan));
@@ -4306,13 +4308,13 @@ deliver:
 
 		if (pkt->len == 0) {
 			dhd_os_sdlock_rxq(bus->dhd);
-			bcm_pkt_buf_free_skb(pkt);
+			brcmu_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			continue;
 		} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
 			DHD_ERROR(("%s: rx protocol error\n", __func__));
 			dhd_os_sdlock_rxq(bus->dhd);
-			bcm_pkt_buf_free_skb(pkt);
+			brcmu_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			continue;
@@ -4633,7 +4635,7 @@ clkwait:
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
-		 bcm_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
+		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && DATAOK(bus)) {
 		framecnt = rxdone ? txlimit : min(txlimit, dhd_txminmax);
 		framecnt = dhdsdio_sendfromq(bus, framecnt);
@@ -4654,8 +4656,8 @@ clkwait:
 			"I_CHIPACTIVE interrupt\n", __func__));
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
-		(!bus->fcstate && bcm_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
-			DATAOK(bus)) || PKT_AVAILABLE()) {
+		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
+		 && DATAOK(bus)) || PKT_AVAILABLE()) {
 		resched = true;
 	}
 
@@ -4788,12 +4790,12 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 
 		/* Allocate an appropriate-sized packet */
 		len = bus->pktgen_len;
-		pkt = bcm_pkt_buf_get_skb(
+		pkt = brcmu_pkt_buf_get_skb(
 			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN),
 			true);
 		if (!pkt) {
-			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n",
-				__func__));
+			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
+				   __func__));
 			break;
 		}
 		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
@@ -4820,7 +4822,7 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 		default:
 			DHD_ERROR(("Unrecognized pktgen mode %d\n",
 				   bus->pktgen_mode));
-			bcm_pkt_buf_free_skb(pkt, true);
+			brcmu_pkt_buf_free_skb(pkt, true);
 			bus->pktgen_count = 0;
 			return;
 		}
@@ -4869,10 +4871,10 @@ static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start)
 	u8 *data;
 
 	/* Allocate the packet */
-	pkt = bcm_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
+	pkt = brcmu_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
 		DHD_SDALIGN, true);
 	if (!pkt) {
-		DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n", __func__));
+		DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n", __func__));
 		return;
 	}
 	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), DHD_SDALIGN);
@@ -4904,7 +4906,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	if (pktlen < SDPCM_TEST_HDRLEN) {
 		DHD_ERROR(("dhdsdio_restrcv: toss runt frame, pktlen %d\n",
 			   pktlen));
-		bcm_pkt_buf_free_skb(pkt, false);
+		brcmu_pkt_buf_free_skb(pkt, false);
 		return;
 	}
 
@@ -4922,7 +4924,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 			DHD_ERROR(("dhdsdio_testrcv: frame length mismatch, "
 				"pktlen %d seq %d" " cmd %d extra %d len %d\n",
 				pktlen, seq, cmd, extra, len));
-			bcm_pkt_buf_free_skb(pkt, false);
+			brcmu_pkt_buf_free_skb(pkt, false);
 			return;
 		}
 	}
@@ -4937,14 +4939,14 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 			bus->pktgen_sent++;
 		} else {
 			bus->pktgen_fail++;
-			bcm_pkt_buf_free_skb(pkt, false);
+			brcmu_pkt_buf_free_skb(pkt, false);
 		}
 		bus->pktgen_rcvd++;
 		break;
 
 	case SDPCM_TEST_ECHORSP:
 		if (bus->ext_loop) {
-			bcm_pkt_buf_free_skb(pkt, false);
+			brcmu_pkt_buf_free_skb(pkt, false);
 			bus->pktgen_rcvd++;
 			break;
 		}
@@ -4957,12 +4959,12 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 				break;
 			}
 		}
-		bcm_pkt_buf_free_skb(pkt, false);
+		brcmu_pkt_buf_free_skb(pkt, false);
 		bus->pktgen_rcvd++;
 		break;
 
 	case SDPCM_TEST_DISCARD:
-		bcm_pkt_buf_free_skb(pkt, false);
+		brcmu_pkt_buf_free_skb(pkt, false);
 		bus->pktgen_rcvd++;
 		break;
 
@@ -4972,7 +4974,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 		DHD_INFO(("dhdsdio_testrcv: unsupported or unknown command, "
 			"pktlen %d seq %d" " cmd %d extra %d len %d\n",
 			pktlen, seq, cmd, extra, len));
-		bcm_pkt_buf_free_skb(pkt, false);
+		brcmu_pkt_buf_free_skb(pkt, false);
 		break;
 	}
 
@@ -5133,7 +5135,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	/* Bump dongle by sending an empty event pkt.
 	 * sdpcm_sendup (RX) checks for virtual console input.
 	 */
-	pkt = bcm_pkt_buf_get_skb(4 + SDPCM_RESERVE);
+	pkt = brcmu_pkt_buf_get_skb(4 + SDPCM_RESERVE);
 	if ((pkt != NULL) && bus->clkstate == CLK_AVAIL)
 		dhdsdio_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
 
@@ -5385,7 +5387,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 	/* Set core control so an SDIO reset does a backplane reset */
 	OR_REG(&bus->regs->corecontrol, CC_BPRESEN);
 
-	bcm_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
+	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
 	/* Locate an appropriately-aligned portion of hdrbuf */
 	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], DHD_SDALIGN);
@@ -6315,7 +6317,7 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 	default:
 		DHD_ERROR(("No SDIO Drive strength init"
 			"done for chip %s rev %d pmurev %d\n",
-			bcm_chipname(bus->ci->chip, chn, 8),
+			brcmu_chipname(bus->ci->chip, chn, 8),
 			bus->ci->chiprev, bus->ci->pmurev));
 		break;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 7e642cd..260d12c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -645,7 +645,7 @@ wl_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 {
 	s32 iolen;
 
-	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
 	return wl_dev_ioctl(dev, WLC_SET_VAR, bufptr, iolen);
@@ -657,7 +657,7 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 {
 	s32 iolen;
 
-	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
 	return wl_dev_ioctl(dev, WLC_GET_VAR, bufptr, buflen);
@@ -845,7 +845,8 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 	s32 err = 0;
 
 	val = cpu_to_le32(val);
-	len = bcm_mkiovar(name, (char *)(&val), sizeof(val), buf, sizeof(buf));
+	len = brcmu_mkiovar(name, (char *)(&val), sizeof(val), buf,
+			    sizeof(buf));
 	BUG_ON(!len);
 
 	err = wl_dev_ioctl(dev, WLC_SET_VAR, buf, len);
@@ -867,7 +868,7 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	s32 err = 0;
 
 	len =
-	    bcm_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
+	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, &var, len);
@@ -1520,7 +1521,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 	else
 		txpwrmw = (u16) dbm;
 	err = wl_dev_intvar_set(ndev, "qtxpower",
-			(s32) (bcm_mw_to_qdbm(txpwrmw)));
+			(s32) (brcmu_mw_to_qdbm(txpwrmw)));
 	if (unlikely(err))
 		WL_ERR("qtxpower error (%d)\n", err);
 	wl->conf->tx_power = dbm;
@@ -1548,7 +1549,7 @@ static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	}
 
 	result = (u8) (txpwrdbm & ~WL_TXPWR_OVERRIDE);
-	*dbm = (s32) bcm_qdbm_to_mw(result);
+	*dbm = (s32) brcmu_qdbm_to_mw(result);
 
 done:
 	WL_TRACE("Exit\n");
@@ -2670,7 +2671,7 @@ wl_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 	struct wl_priv *wl = ndev_to_wl(dev);
 	u32 buflen;
 
-	buflen = bcm_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
+	buflen = brcmu_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!buflen);
 
 	return wl_dev_ioctl(dev, WLC_SET_VAR, wl->ioctl_buf, buflen);
@@ -2684,7 +2685,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 	u32 len;
 	s32 err = 0;
 
-	len = bcm_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
+	len = brcmu_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!len);
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, (void *)wl->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
@@ -2802,7 +2803,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 {
 	struct wl_bss_info *bi;
 	struct wlc_ssid *ssid;
-	struct bcm_tlv *tim;
+	struct brcmu_tlv *tim;
 	u16 beacon_interval;
 	u8 dtim_period;
 	size_t ie_len;
@@ -2832,7 +2833,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 	ie_len = bi->ie_length;
 	beacon_interval = cpu_to_le16(bi->beacon_period);
 
-	tim = bcm_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
+	tim = brcmu_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
 	if (tim)
 		dtim_period = tim->data[1];
 	else {
@@ -3683,7 +3684,7 @@ wl_dongle_glom(struct net_device *ndev, u32 glom, u32 dongle_align)
 	s32 err = 0;
 
 	/* Match Host and Dongle rx alignment */
-	bcm_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
+	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
@@ -3691,7 +3692,7 @@ wl_dongle_glom(struct net_device *ndev, u32 glom, u32 dongle_align)
 		goto dongle_glom_out;
 	}
 	/* disable glom option per default */
-	bcm_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("txglom error (%d)\n", err);
@@ -3709,7 +3710,7 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 	s32 err = 0;
 
 	/* Set ARP offload */
-	bcm_mkiovar("arpoe", (char *)&arpoe, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("arpoe", (char *)&arpoe, 4, iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3719,7 +3720,7 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 
 		goto dongle_offload_out;
 	}
-	bcm_mkiovar("arp_ol", (char *)&arp_ol, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("arp_ol", (char *)&arp_ol, 4, iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3832,7 +3833,7 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	}
 
 	/* set mode to allow pattern */
-	bcm_mkiovar("pkt_filter_mode", (char *)&filter_mode, 4, iovbuf,
+	brcmu_mkiovar("pkt_filter_mode", (char *)&filter_mode, 4, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
@@ -3859,7 +3860,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	WL_TRACE("Enter\n");
 
 	/* Setup event_msgs */
-	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
@@ -3888,7 +3889,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, WLC_E_JOIN_START);
 	setbit(eventmask, WLC_E_SCAN_COMPLETE);
 
-	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
@@ -3914,7 +3915,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * off to report link down
 	 */
 	if (roamvar) {
-		bcm_mkiovar("bcn_timeout", (char *)&bcn_timeout,
+		brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout,
 			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
 		err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 		if (unlikely(err)) {
@@ -3928,7 +3929,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * to take care of roaming
 	 */
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
-	bcm_mkiovar("roam_off", (char *)&roamvar,
+	brcmu_mkiovar("roam_off", (char *)&roamvar,
 				sizeof(roamvar), iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 974a6e0..99a49f9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -230,7 +230,8 @@ static int dev_wlc_intvar_set(struct net_device *dev, char *name, int val)
 	uint len;
 
 	val = cpu_to_le32(val);
-	len = bcm_mkiovar(name, (char *)(&val), sizeof(val), buf, sizeof(buf));
+	len = brcmu_mkiovar(name, (char *)(&val), sizeof(val), buf,
+			    sizeof(buf));
 	ASSERT(len);
 
 	return dev_wlc_ioctl(dev, WLC_SET_VAR, buf, len);
@@ -244,7 +245,7 @@ dev_iw_iovar_setbuf(struct net_device *dev,
 {
 	int iolen;
 
-	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	ASSERT(iolen);
 
 	if (iolen == 0)
@@ -260,7 +261,7 @@ dev_iw_iovar_getbuf(struct net_device *dev,
 {
 	int iolen;
 
-	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	ASSERT(iolen);
 
 	return dev_wlc_ioctl(dev, WLC_GET_VAR, bufptr, buflen);
@@ -274,7 +275,7 @@ dev_wlc_bufvar_set(struct net_device *dev, char *name, char *buf, int len)
 	static char ioctlbuf[MAX_WLIW_IOCTL_LEN];
 	uint buflen;
 
-	buflen = bcm_mkiovar(name, buf, len, ioctlbuf, sizeof(ioctlbuf));
+	buflen = brcmu_mkiovar(name, buf, len, ioctlbuf, sizeof(ioctlbuf));
 	ASSERT(buflen);
 
 	return dev_wlc_ioctl(dev, WLC_SET_VAR, ioctlbuf, buflen);
@@ -288,7 +289,7 @@ dev_wlc_bufvar_get(struct net_device *dev, char *name, char *buf, int buflen)
 	int error;
 	uint len;
 
-	len = bcm_mkiovar(name, NULL, 0, ioctlbuf, sizeof(ioctlbuf));
+	len = brcmu_mkiovar(name, NULL, 0, ioctlbuf, sizeof(ioctlbuf));
 	ASSERT(len);
 	error =
 	    dev_wlc_ioctl(dev, WLC_GET_VAR, (void *)ioctlbuf,
@@ -311,7 +312,7 @@ static int dev_wlc_intvar_get(struct net_device *dev, char *name, int *retval)
 	uint data_null;
 
 	len =
-	    bcm_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
+	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	ASSERT(len);
 	error = dev_wlc_ioctl(dev, WLC_GET_VAR, (void *)&var, len);
@@ -396,7 +397,7 @@ wl_iw_set_freq(struct net_device *dev,
 		if (fwrq->m > 4000 && fwrq->m < 5000)
 			sf = WF_CHAN_FACTOR_4_G;
 
-		chan = bcm_mhz2channel(fwrq->m, sf);
+		chan = brcmu_mhz2channel(fwrq->m, sf);
 	}
 	chan = cpu_to_le32(chan);
 
@@ -1447,11 +1448,11 @@ wl_iw_handle_scanresults_ies(char **event_p, char *end,
 
 	event = *event_p;
 	if (bi->ie_length) {
-		bcm_tlv_t *ie;
+		struct brcmu_tlv *ie;
 		u8 *ptr = ((u8 *) bi) + sizeof(wl_bss_info_t);
 		int ptr_len = bi->ie_length;
 
-		ie = bcm_parse_tlvs(ptr, ptr_len, DOT11_MNG_RSN_ID);
+		ie = brcmu_parse_tlvs(ptr, ptr_len, DOT11_MNG_RSN_ID);
 		if (ie) {
 			iwe.cmd = IWEVGENIE;
 			iwe.u.data.length = ie->len + 2;
@@ -1461,7 +1462,8 @@ wl_iw_handle_scanresults_ies(char **event_p, char *end,
 		}
 		ptr = ((u8 *) bi) + sizeof(wl_bss_info_t);
 
-		while ((ie = bcm_parse_tlvs(ptr, ptr_len, DOT11_MNG_WPA_ID))) {
+		while ((ie = brcmu_parse_tlvs(
+				ptr, ptr_len, DOT11_MNG_WPA_ID))) {
 			if (ie_is_wps_ie(((u8 **)&ie), &ptr, &ptr_len)) {
 				iwe.cmd = IWEVGENIE;
 				iwe.u.data.length = ie->len + 2;
@@ -1474,7 +1476,8 @@ wl_iw_handle_scanresults_ies(char **event_p, char *end,
 
 		ptr = ((u8 *) bi) + sizeof(wl_bss_info_t);
 		ptr_len = bi->ie_length;
-		while ((ie = bcm_parse_tlvs(ptr, ptr_len, DOT11_MNG_WPA_ID))) {
+		while ((ie = brcmu_parse_tlvs(
+				ptr, ptr_len, DOT11_MNG_WPA_ID))) {
 			if (ie_is_wpa_ie(((u8 **)&ie), &ptr, &ptr_len)) {
 				iwe.cmd = IWEVGENIE;
 				iwe.u.data.length = ie->len + 2;
@@ -2199,8 +2202,8 @@ wl_iw_set_txpow(struct net_device *dev,
 	else
 		txpwrmw = (u16) vwrq->value;
 
-	error =
-	    dev_wlc_intvar_set(dev, "qtxpower", (int)(bcm_mw_to_qdbm(txpwrmw)));
+	error = dev_wlc_intvar_set(dev, "qtxpower",
+				   (int)(brcmu_mw_to_qdbm(txpwrmw)));
 	return error;
 }
 
@@ -2224,7 +2227,7 @@ wl_iw_get_txpow(struct net_device *dev,
 
 	disable = le32_to_cpu(disable);
 	result = (u8) (txpwrdbm & ~WL_TXPWR_OVERRIDE);
-	vwrq->value = (s32) bcm_qdbm_to_mw(result);
+	vwrq->value = (s32) brcmu_qdbm_to_mw(result);
 	vwrq->fixed = 0;
 	vwrq->disabled =
 	    (disable & (WL_RADIO_SW_DISABLE | WL_RADIO_HW_DISABLE)) ? 1 : 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index dd55e29..0965801 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -103,11 +103,11 @@ typedef uint(*di_txactive_t) (struct dma_pub *dmah);
 typedef void (*di_txrotate_t) (struct dma_pub *dmah);
 typedef void (*di_counterreset_t) (struct dma_pub *dmah);
 typedef uint(*di_ctrlflags_t) (struct dma_pub *dmah, uint mask, uint flags);
-typedef char *(*di_dump_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
+typedef char *(*di_dump_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			    bool dumpring);
-typedef char *(*di_dumptx_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
+typedef char *(*di_dumptx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			      bool dumpring);
-typedef char *(*di_dumprx_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
+typedef char *(*di_dumprx_t) (struct dma_pub *dmah, struct brcmu_strbuf *b,
 			      bool dumpring);
 typedef uint(*di_rxactive_t) (struct dma_pub *dmah);
 typedef uint(*di_txpending_t) (struct dma_pub *dmah);
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 2946d06..59098b0 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -988,7 +988,7 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 
 		/* fixup the endianness so crc8 will pass */
 		htol16_buf(buf, nwords * 2);
-		if (bcm_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
+		if (brcmu_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
 		    CRC8_GOOD_VALUE) {
 			/* DBG only pci always read srom4 first, then srom8/9 */
 			err = 1;
@@ -1028,7 +1028,7 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
-	if (bcm_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
+	if (brcmu_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
 	    CRC8_GOOD_VALUE) {
 		err = 1;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index e80e12c..71acc4e 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -608,7 +608,7 @@ brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	wl->pub->global_ampdu = &(scb->scb_ampdu);
 	wl->pub->global_ampdu->scb = scb;
 	wl->pub->global_ampdu->max_pdu = 16;
-	bcm_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
+	brcmu_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
 		  AMPDU_MAX_SCB_TID * PKTQ_LEN_DEFAULT);
 
 	sta->ht_cap.ht_supported = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index a754cdd..ad389bc 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -923,7 +923,7 @@ static void *_dma_rx(dma_info_t *di)
 		if ((di->dma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
 			DMA_ERROR(("%s: dma_rx: bad frame length (%d)\n",
 				   di->name, len));
-			bcm_pkt_buf_free_skb(head);
+			brcmu_pkt_buf_free_skb(head);
 			di->dma.rxgiants++;
 			goto next_frame;
 		}
@@ -971,7 +971,7 @@ static bool _dma_rxfill(dma_info_t *di)
 		   size to be allocated
 		 */
 
-		p = bcm_pkt_buf_get_skb(di->rxbufsize + extra_offset);
+		p = brcmu_pkt_buf_get_skb(di->rxbufsize + extra_offset);
 
 		if (p == NULL) {
 			DMA_ERROR(("%s: dma_rxfill: out of rxbufs\n",
@@ -1069,7 +1069,7 @@ static void _dma_rxreclaim(dma_info_t *di)
 	DMA_TRACE(("%s: dma_rxreclaim\n", di->name));
 
 	while ((p = _dma_getnextrxp(di, true)))
-		bcm_pkt_buf_free_skb(p);
+		brcmu_pkt_buf_free_skb(p);
 }
 
 static void *_dma_getnextrxp(dma_info_t *di, bool forceall)
@@ -1303,7 +1303,7 @@ static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
 	while ((p = dma64_getnexttxp(di, range))) {
 		/* For unframed data, we don't have any packets to free */
 		if (!(di->dma.dmactrlflags & DMA_CTRL_UNFRAMED))
-			bcm_pkt_buf_free_skb(p);
+			brcmu_pkt_buf_free_skb(p);
 	}
 }
 
@@ -1640,7 +1640,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 
  outoftxd:
 	DMA_ERROR(("%s: dma_txfast: out of txds !!!\n", di->name));
-	bcm_pkt_buf_free_skb(p0);
+	brcmu_pkt_buf_free_skb(p0);
 	di->dma.txavail = 0;
 	di->dma.txnobuf++;
 	return -1;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 92064ba..43d0fe1 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -257,7 +257,7 @@ typedef enum {
 #define PHY_CHAIN_TX_DISABLE_TEMP	115
 #define PHY_HYSTERESIS_DELTATEMP	5
 
-#define PHY_BITSCNT(x)	bcm_bitcount((u8 *)&(x), sizeof(u8))
+#define PHY_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
 
 #define MOD_PHY_REG(pi, phy_type, reg_name, field, value) \
 	mod_phy_reg(pi, phy_type##_##reg_name, phy_type##_##reg_name##_##field##_MASK, \
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 7a00cac..e1920ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -591,7 +591,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		len = roundup(len, 4);
 		ampdu_len += (len + (ndelim + 1) * AMPDU_DELIMITER_LEN);
 
-		dma_len += (u16) bcm_pkttotlen(p);
+		dma_len += (u16) brcmu_pkttotlen(p);
 
 		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
 			" seg_cnt %d null delim %d\n",
@@ -686,8 +686,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
 			    ((u8) (p->priority) == tid)) {
 
-				plen =
-				    bcm_pkttotlen(p) + AMPDU_MAX_MPDU_OVERHEAD;
+				plen = brcmu_pkttotlen(p) +
+				       AMPDU_MAX_MPDU_OVERHEAD;
 				plen = max(scb_ampdu->min_len, plen);
 
 				if ((plen + ampdu_len) > maxlen) {
@@ -704,7 +704,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 					p = NULL;
 					continue;
 				}
-				p = bcm_pktq_pdeq(&qi->q, prec);
+				p = brcmu_pktq_pdeq(&qi->q, prec);
 			} else {
 				p = NULL;
 			}
@@ -864,7 +864,7 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			tx_info = IEEE80211_SKB_CB(p);
 			txh = (d11txh_t *) p->data;
 			mcl = le16_to_cpu(txh->MacTxControlLow);
-			bcm_pkt_buf_free_skb(p);
+			brcmu_pkt_buf_free_skb(p);
 			/* break out if last packet of ampdu */
 			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
 			    TXC_AMPDU_LAST)
@@ -993,7 +993,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				  txs->phyerr);
 
 			if (WL_ERROR_ON()) {
-				bcm_prpkt("txpkt (AMPDU)", p);
+				brcmu_prpkt("txpkt (AMPDU)", p);
 				wlc_print_txdesc((d11txh_t *) p->data);
 			}
 			wlc_print_txstatus(txs);
@@ -1239,7 +1239,7 @@ void wlc_ampdu_flush(struct wlc_info *wlc,
 	ampdu_pars.sta = sta;
 	ampdu_pars.tid = tid;
 	for (prec = 0; prec < pq->num_prec; prec++) {
-		bcm_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
+		brcmu_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
 			    (void *)&ampdu_pars);
 	}
 	wlc_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index caee8d9..fdd10ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -922,7 +922,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		err = 21;
 		goto fail;
 	}
-	bcm_ether_atoe(macaddr, wlc_hw->etheraddr);
+	brcmu_ether_atoe(macaddr, wlc_hw->etheraddr);
 	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr)) {
 		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: bad macaddr %s\n",
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index d1e764a..ac84ddc 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -1494,7 +1494,7 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 	u8 channel = CHSPEC_CHANNEL(chspec);
 
 	/* check the chanspec */
-	if (bcm_chspec_malformed(chspec)) {
+	if (brcmu_chspec_malformed(chspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: malformed chanspec 0x%x\n",
 			wlc->pub->unit, chspec);
 		return false;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 1a3af67..1e79031 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -704,8 +704,8 @@ static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc)
 
 	local = WLC_TXPWR_MAX;
 	if (wlc->pub->associated &&
-	    (bcm_chspec_ctlchan(wlc->chanspec) ==
-	     bcm_chspec_ctlchan(wlc->home_chanspec))) {
+	    (brcmu_chspec_ctlchan(wlc->chanspec) ==
+	     brcmu_chspec_ctlchan(wlc->home_chanspec))) {
 
 		/* get the local power constraint if we are on the AP's
 		 * channel [802.11h, 7.3.2.13]
@@ -2183,7 +2183,7 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		bcm_pktq_flush(&qi->q, true, NULL, NULL);
+		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
 	}
 
 	callbacks += wlc_bmac_down_finish(wlc->hw);
@@ -2985,16 +2985,16 @@ void wlc_print_txdesc(d11txh_t *txh)
 	printk(KERN_DEBUG "XtraFrameTypes: %04x ", xtraft);
 	printk(KERN_DEBUG "\n");
 
-	bcm_format_hex(hexbuf, iv, sizeof(txh->IV));
+	brcmu_format_hex(hexbuf, iv, sizeof(txh->IV));
 	printk(KERN_DEBUG "SecIV:       %s\n", hexbuf);
-	bcm_format_hex(hexbuf, ra, sizeof(txh->TxFrameRA));
+	brcmu_format_hex(hexbuf, ra, sizeof(txh->TxFrameRA));
 	printk(KERN_DEBUG "RA:          %s\n", hexbuf);
 
 	printk(KERN_DEBUG "Fb FES Time: %04x ", tfestfb);
-	bcm_format_hex(hexbuf, rtspfb, sizeof(txh->RTSPLCPFallback));
+	brcmu_format_hex(hexbuf, rtspfb, sizeof(txh->RTSPLCPFallback));
 	printk(KERN_DEBUG "RTS PLCP: %s ", hexbuf);
 	printk(KERN_DEBUG "RTS DUR: %04x ", rtsdfb);
-	bcm_format_hex(hexbuf, fragpfb, sizeof(txh->FragPLCPFallback));
+	brcmu_format_hex(hexbuf, fragpfb, sizeof(txh->FragPLCPFallback));
 	printk(KERN_DEBUG "PLCP: %s ", hexbuf);
 	printk(KERN_DEBUG "DUR: %04x", fragdfb);
 	printk(KERN_DEBUG "\n");
@@ -3010,9 +3010,9 @@ void wlc_print_txdesc(d11txh_t *txh)
 	printk(KERN_DEBUG "MaxAggbyte_fb:  %04x\n", mabyte_f);
 	printk(KERN_DEBUG "MinByte:     %04x\n", mmbyte);
 
-	bcm_format_hex(hexbuf, rtsph, sizeof(txh->RTSPhyHeader));
+	brcmu_format_hex(hexbuf, rtsph, sizeof(txh->RTSPhyHeader));
 	printk(KERN_DEBUG "RTS PLCP: %s ", hexbuf);
-	bcm_format_hex(hexbuf, (u8 *) &rts, sizeof(txh->rts_frame));
+	brcmu_format_hex(hexbuf, (u8 *) &rts, sizeof(txh->rts_frame));
 	printk(KERN_DEBUG "RTS Frame: %s", hexbuf);
 	printk(KERN_DEBUG "\n");
 }
@@ -3030,7 +3030,7 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 	u16 macstatus2 = rxh->RxStatus2;
 	char flagstr[64];
 	char lenbuf[20];
-	static const bcm_bit_desc_t macstat_flags[] = {
+	static const struct brcmu_bit_desc macstat_flags[] = {
 		{RXS_FCSERR, "FCSErr"},
 		{RXS_RESPFRAMETX, "Reply"},
 		{RXS_PBPRES, "PADDING"},
@@ -3043,7 +3043,7 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 	printk(KERN_DEBUG "Raw RxDesc:\n");
 	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh, sizeof(d11rxhdr_t));
 
-	bcm_format_flags(macstat_flags, macstatus1, flagstr, 64);
+	brcmu_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
 	snprintf(lenbuf, sizeof(lenbuf), "0x%x", len);
 
@@ -3091,7 +3091,7 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 	if (pktq_pfull(q, prec))
 		eprec = prec;
 	else if (pktq_full(q)) {
-		p = bcm_pktq_peek_tail(q, &eprec);
+		p = brcmu_pktq_peek_tail(q, &eprec);
 		if (eprec > prec) {
 			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
 				  "\n", __func__, eprec, prec);
@@ -3113,16 +3113,16 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		}
 
 		/* Evict packet according to discard policy */
-		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
-			bcm_pktq_pdeq_tail(q, eprec);
-		bcm_pkt_buf_free_skb(p);
+		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
+			brcmu_pktq_pdeq_tail(q, eprec);
+		brcmu_pkt_buf_free_skb(p);
 	}
 
 	/* Enqueue */
 	if (head)
-		p = bcm_pktq_penq_head(q, prec, pkt);
+		p = brcmu_pktq_penq_head(q, prec, pkt);
 	else
-		p = bcm_pktq_penq(q, prec, pkt);
+		p = brcmu_pktq_penq(q, prec, pkt);
 
 	return true;
 }
@@ -3147,7 +3147,7 @@ void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 		 * XXX we might hit this condtion in case
 		 * packet flooding from mac80211 stack
 		 */
-		bcm_pkt_buf_free_skb(sdu);
+		brcmu_pkt_buf_free_skb(sdu);
 	}
 
 	/* Check if flow control needs to be turned on after enqueuing the packet
@@ -3211,7 +3211,7 @@ void wlc_send_q(struct wlc_info *wlc)
 	/* Send all the enq'd pkts that we can.
 	 * Dequeue packets with precedence with empty HW fifo only
 	 */
-	while (prec_map && (pkt[0] = bcm_pktq_mdeq(q, prec_map, &prec))) {
+	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
 		tx_info = IEEE80211_SKB_CB(pkt[0]);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			err = wlc_sendampdu(wlc->ampdu, qi, pkt, prec);
@@ -3226,7 +3226,7 @@ void wlc_send_q(struct wlc_info *wlc)
 		}
 
 		if (err == -EBUSY) {
-			bcm_pktq_penq_head(q, prec, pkt[0]);
+			brcmu_pktq_penq_head(q, prec, pkt[0]);
 			/* If send failed due to any other reason than a change in
 			 * HW FIFO condition, quit. Otherwise, read the new prec_map!
 			 */
@@ -3649,7 +3649,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	qos = ieee80211_is_data_qos(h->frame_control);
 
 	/* compute length of frame in bytes for use in PLCP computations */
-	len = bcm_pkttotlen(p);
+	len = brcmu_pkttotlen(p);
 	phylen = len + FCS_LEN;
 
 	/* If WEP enabled, add room in phylen for the additional bytes of
@@ -4381,7 +4381,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	totlen = bcm_pkttotlen(p);
+	totlen = brcmu_pkttotlen(p);
 	free_pdu = true;
 
 	wlc_txfifo_complete(wlc, queue, 1);
@@ -4402,7 +4402,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
  fatal:
 	if (p)
-		bcm_pkt_buf_free_skb(p);
+		brcmu_pkt_buf_free_skb(p);
 
 	return true;
 
@@ -4700,7 +4700,7 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	return;
 
  toss:
-	bcm_pkt_buf_free_skb(p);
+	brcmu_pkt_buf_free_skb(p);
 }
 
 /* calculate frame duration for Mixed-mode L-SIG spoofing, return
@@ -5833,7 +5833,7 @@ static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
 		 * leave PS mode. The watermark for flowcontrol to OS packets
 		 * will remain the same
 		 */
-		bcm_pktq_init(&qi->q, WLC_PREC_COUNT,
+		brcmu_pktq_init(&qi->q, WLC_PREC_COUNT,
 			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
 			  + wlc->pub->psq_pkts_total);
 
@@ -5917,7 +5917,7 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 {
 	/* flush packet queue when requested */
 	if (drop)
-		bcm_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
+		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
 	/* wait for queue and DMA fifos to run dry */
 	while (!pktq_empty(&wlc->pkt_queue->q) ||
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 1dfa04b..88fab77 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -33,7 +33,7 @@
 #define EDCF_AIFSN_MIN               1
 #define FRAGNUM_MASK		0xF
 
-#define WLC_BITSCNT(x)	bcm_bitcount((u8 *)&(x), sizeof(u8))
+#define WLC_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
 
 /* Maximum wait time for a MAC suspend */
 #define	WLC_MAX_MAC_SUSPEND	83000	/* uS: 83mS is max packet time (64KB ampdu @ 6Mbps) */
@@ -355,7 +355,7 @@ struct pkt_cb {
 /* module control blocks */
 struct modulecb {
 	char name[32];		/* module name : NULL indicates empty array member */
-	const bcm_iovar_t *iovars;	/* iovar table */
+	const struct brcmu_iovar *iovars;	/* iovar table */
 	void *hdl;		/* handle passed when handler 'doiovar' is called */
 	watchdog_fn_t watchdog_fn;	/* watchdog handler */
 	iovar_fn_t iovar_fn;	/* iovar handler */
@@ -812,8 +812,8 @@ extern void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
 			       void (*dma_callback_fn));
 
 #if defined(BCMDBG)
-extern void wlc_dump_ie(struct wlc_info *wlc, bcm_tlv_t *ie,
-			struct bcmstrbuf *b);
+extern void wlc_dump_ie(struct wlc_info *wlc, struct brcmu_tlv *ie,
+			struct brcmu_strbuf *b);
 #endif
 
 extern void wlc_reprate_init(struct wlc_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index a0c170b..de32440 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -219,7 +219,7 @@ struct wlc_if;
 /* watchdog down and dump callback function proto's */
 typedef int (*watchdog_fn_t) (void *handle);
 typedef int (*down_fn_t) (void *handle);
-typedef int (*dump_fn_t) (void *handle, struct bcmstrbuf *b);
+typedef int (*dump_fn_t) (void *handle, struct brcmu_strbuf *b);
 
 /* IOVar handler
  *
@@ -234,7 +234,7 @@ typedef int (*dump_fn_t) (void *handle, struct bcmstrbuf *b);
  *
  * All pointers may point into the same buffer.
  */
-typedef int (*iovar_fn_t) (void *handle, const bcm_iovar_t *vi,
+typedef int (*iovar_fn_t) (void *handle, const struct brcmu_iovar *vi,
 			   u32 actionid, const char *name, void *params,
 			   uint plen, void *arg, int alen, int vsize,
 			   struct wlc_if *wlcif);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 383a747..3442d32 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -54,7 +54,7 @@ struct bmac_pmq;
 struct d11init;
 struct dma_pub;
 struct wlc_bsscfg;
-struct bcmstrbuf;
+struct brcmu_strbuf;
 struct si_pub;
 
 /* brcm_msg_level is a bit vector with defs in bcmdefs.h */
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 1a1c8ad..73854a4 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -14,15 +14,15 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmutils_h_
-#define	_bcmutils_h_
+#ifndef	_brcmutils_h_
+#define	_brcmutils_h_
 
 /* Buffer structure for collecting string-formatted data
-* using bcm_bprintf() API.
-* Use bcm_binit() to initialize before use
+* using brcmu_bprintf() API.
+* Use brcmu_binit() to initialize before use
 */
 
-	struct bcmstrbuf {
+	struct brcmu_strbuf {
 		char *buf;	/* pointer to current position in origbuf */
 		unsigned int size;	/* current (residual) size in bytes */
 		char *origbuf;	/* unmodified pointer to orignal buffer */
@@ -87,25 +87,25 @@ typedef bool(*ifpkt_cb_t) (struct sk_buff *, void *);
 #define pktq_ppeek(pq, prec)            ((pq)->q[prec].head)
 #define pktq_ppeek_tail(pq, prec)       ((pq)->q[prec].tail)
 
-extern struct sk_buff *bcm_pktq_penq(struct pktq *pq, int prec,
+extern struct sk_buff *brcmu_pktq_penq(struct pktq *pq, int prec,
 				 struct sk_buff *p);
-extern struct sk_buff *bcm_pktq_penq_head(struct pktq *pq, int prec,
+extern struct sk_buff *brcmu_pktq_penq_head(struct pktq *pq, int prec,
 				      struct sk_buff *p);
-extern struct sk_buff *bcm_pktq_pdeq(struct pktq *pq, int prec);
-extern struct sk_buff *bcm_pktq_pdeq_tail(struct pktq *pq, int prec);
+extern struct sk_buff *brcmu_pktq_pdeq(struct pktq *pq, int prec);
+extern struct sk_buff *brcmu_pktq_pdeq_tail(struct pktq *pq, int prec);
 
 /* packet primitives */
-extern struct sk_buff *bcm_pkt_buf_get_skb(uint len);
-extern void bcm_pkt_buf_free_skb(struct sk_buff *skb);
+extern struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
+extern void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
-extern void bcm_pktq_pflush(struct pktq *pq, int prec,
+extern void brcmu_pktq_pflush(struct pktq *pq, int prec,
 	bool dir, ifpkt_cb_t fn, void *arg);
 
 /* operations on a set of precedences in packet queue */
 
-extern int bcm_pktq_mlen(struct pktq *pq, uint prec_bmp);
-extern struct sk_buff *bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
+extern int brcmu_pktq_mlen(struct pktq *pq, uint prec_bmp);
+extern struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 	int *prec_out);
 
 /* operations on packet queue as a whole */
@@ -117,46 +117,37 @@ extern struct sk_buff *bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 #define pktq_empty(pq)                  ((pq)->len == 0)
 
 /* operations for single precedence queues */
-#define pktenq(pq, p)		bcm_pktq_penq(((struct pktq *)pq), 0, (p))
-#define pktenq_head(pq, p)	bcm_pktq_penq_head(((struct pktq *)pq), 0, (p))
-#define pktdeq(pq)		bcm_pktq_pdeq(((struct pktq *)pq), 0)
-#define pktdeq_tail(pq)		bcm_pktq_pdeq_tail(((struct pktq *)pq), 0)
-#define pktqinit(pq, len)	bcm_pktq_init(((struct pktq *)pq), 1, len)
-
-extern void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len);
+#define pktenq(pq, p)		brcmu_pktq_penq(((struct pktq *)pq), 0, (p))
+#define pktenq_head(pq, p)\
+	brcmu_pktq_penq_head(((struct pktq *)pq), 0, (p))
+#define pktdeq(pq)		brcmu_pktq_pdeq(((struct pktq *)pq), 0)
+#define pktdeq_tail(pq)		brcmu_pktq_pdeq_tail(((struct pktq *)pq), 0)
+#define pktqinit(pq, len)	brcmu_pktq_init(((struct pktq *)pq), 1, len)
+
+extern void brcmu_pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
-extern struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out);
-extern void bcm_pktq_flush(struct pktq *pq, bool dir,
+extern struct sk_buff *brcmu_pktq_peek_tail(struct pktq *pq, int *prec_out);
+extern void brcmu_pktq_flush(struct pktq *pq, bool dir,
 	ifpkt_cb_t fn, void *arg);
 
 /* externs */
 /* packet */
-extern uint bcm_pktfrombuf(struct sk_buff *p,
+extern uint brcmu_pktfrombuf(struct sk_buff *p,
 	uint offset, int len, unsigned char *buf);
-extern uint bcm_pkttotlen(struct sk_buff *p);
+extern uint brcmu_pkttotlen(struct sk_buff *p);
 
 /* ethernet address */
-extern int bcm_ether_atoe(char *p, u8 *ea);
+extern int brcmu_ether_atoe(char *p, u8 *ea);
 
 /* ip address */
 	struct ipv4_addr;
-	extern char *bcm_ip_ntoa(struct ipv4_addr *ia, char *buf);
 
 #ifdef BCMDBG
-extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
+extern void brcmu_prpkt(const char *msg, struct sk_buff *p0);
 #else
-#define bcm_prpkt(a, b)
+#define brcmu_prpkt(a, b)
 #endif				/* BCMDBG */
 
-#define bcm_perf_enable()
-#define	bcmlog(fmt, a1, a2)
-#define	bcmdumplog(buf, size)	(*buf = '\0')
-#define	bcmdumplogent(buf, idx)	-1
-
-#define bcmtslog(tstamp, fmt, a1, a2)
-#define bcmprinttslogs()
-#define bcmprinttstamp(us)
-
 /* Support for sharing code across in-driver iovar implementations.
  * The intent is that a driver use this structure to map iovar names
  * to its (private) iovar identifiers, and the lookup function to
@@ -165,13 +156,13 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
  */
 
 /* iovar structure */
-	typedef struct bcm_iovar {
-		const char *name;	/* name for lookup and display */
-		u16 varid;	/* id for switch */
-		u16 flags;	/* driver-specific flag bits */
-		u16 type;	/* base type of argument */
-		u16 minlen;	/* min length for buffer vars */
-	} bcm_iovar_t;
+struct brcmu_iovar {
+	const char *name;	/* name for lookup and display */
+	u16 varid;	/* id for switch */
+	u16 flags;	/* driver-specific flag bits */
+	u16 type;	/* base type of argument */
+	u16 minlen;	/* min length for buffer vars */
+};
 
 /* varid definitions are per-driver, may use these get/set bits */
 
@@ -185,12 +176,11 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #define IOV_ISSET(actionid)	((actionid & IOV_SET) == IOV_SET)
 #define IOV_ID(actionid)	(actionid >> 1)
 
-/* flags are per-driver based on driver attributes */
-
-	extern const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table,
-						   const char *name);
-	extern int bcm_iovar_lencheck(const bcm_iovar_t *table, void *arg,
-				      int len, bool set);
+extern const struct
+brcmu_iovar *brcmu_iovar_lookup(const struct brcmu_iovar *table,
+				const char *name);
+extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
+				int len, bool set);
 
 /* Base type definitions */
 #define IOVT_VOID	0	/* no value (implictly set only) */
@@ -424,21 +414,18 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #define CRC16_INIT_VALUE 0xffff	/* Initial CRC16 checksum value */
 #define CRC16_GOOD_VALUE 0xf0b8	/* Good final CRC16 checksum value */
 
-/* bcm_format_flags() bit description structure */
-	typedef struct bcm_bit_desc {
-		u32 bit;
-		const char *name;
-	} bcm_bit_desc_t;
+/* brcmu_format_flags() bit description structure */
+struct brcmu_bit_desc {
+	u32 bit;
+	const char *name;
+};
 
 /* tag_ID/length/value_buffer tuple */
-	typedef struct bcm_tlv {
-		u8 id;
-		u8 len;
-		u8 data[1];
-	} bcm_tlv_t;
-
-/* Check that bcm_tlv_t fits into the given buflen */
-#define bcm_valid_tlv(elt, buflen) ((buflen) >= 2 && (int)(buflen) >= (int)(2 + (elt)->len))
+struct brcmu_tlv {
+	u8 id;
+	u8 len;
+	u8 data[1];
+};
 
 #define ETHER_ADDR_STR_LEN	18	/* 18-bytes of Ethernet address buffer length */
 
@@ -476,17 +463,19 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 
 /* externs */
 /* crc */
-extern u8 bcm_crc8(u8 *p, uint nbytes, u8 crc);
+extern u8 brcmu_crc8(u8 *p, uint nbytes, u8 crc);
+
 /* format/print */
 #if defined(BCMDBG)
-	extern int bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags,
-				    char *buf, int len);
-	extern int bcm_format_hex(char *str, const void *bytes, int len);
+extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
+			      char *buf, int len);
+extern int brcmu_format_hex(char *str, const void *bytes, int len);
 #endif
-	extern char *bcm_chipname(uint chipid, char *buf, uint len);
 
-	extern bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen,
-						    uint key);
+extern char *brcmu_chipname(uint chipid, char *buf, uint len);
+
+extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
+					  uint key);
 
 /* multi-bool data type: set of bools, mbool is true if any is set */
 	typedef u32 mbool;
@@ -496,14 +485,14 @@ extern u8 bcm_crc8(u8 *p, uint nbytes, u8 crc);
 #define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
 
 /* power conversion */
-	extern u16 bcm_qdbm_to_mw(u8 qdbm);
-	extern u8 bcm_mw_to_qdbm(u16 mw);
+extern u16 brcmu_qdbm_to_mw(u8 qdbm);
+extern u8 brcmu_mw_to_qdbm(u16 mw);
 
-	extern void bcm_binit(struct bcmstrbuf *b, char *buf, uint size);
-	extern int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...);
+extern void brcmu_binit(struct brcmu_strbuf *b, char *buf, uint size);
+extern int brcmu_bprintf(struct brcmu_strbuf *b, const char *fmt, ...);
 
-	extern uint bcm_mkiovar(char *name, char *data, uint datalen, char *buf,
-				uint len);
-	extern uint bcm_bitcount(u8 *bitmap, uint bytelength);
+extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
+			  char *buf, uint len);
+extern uint brcmu_bitcount(u8 *bitmap, uint bytelength);
 
-#endif				/* _bcmutils_h_ */
+#endif				/* _brcmutils_h_ */
diff --git a/drivers/staging/brcm80211/include/bcmwifi.h b/drivers/staging/brcm80211/include/bcmwifi.h
index 60f404c..6b12c13 100644
--- a/drivers/staging/brcm80211/include/bcmwifi.h
+++ b/drivers/staging/brcm80211/include/bcmwifi.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmwifi_h_
-#define	_bcmwifi_h_
+#ifndef	_brcmu_wifi_h_
+#define	_brcmu_wifi_h_
 
 #include <linux/if_ether.h>		/* for ETH_ALEN */
 #include <linux/ieee80211.h>		/* for WLAN_PMKID_LEN */
@@ -141,14 +141,14 @@ typedef u16 chanspec_t;
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-extern bool bcm_chspec_malformed(chanspec_t chanspec);
+extern bool brcmu_chspec_malformed(chanspec_t chanspec);
 
 /*
  * This function returns the channel number that control traffic is being sent on, for legacy
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-extern u8 bcm_chspec_ctlchan(chanspec_t chspec);
+extern u8 brcmu_chspec_ctlchan(chanspec_t chspec);
 
 /*
  * Return the channel number for a given frequency and base frequency.
@@ -169,7 +169,7 @@ extern u8 bcm_chspec_ctlchan(chanspec_t chspec);
  *
  * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
  */
-extern int bcm_mhz2channel(uint freq, uint start_factor);
+extern int brcmu_mhz2channel(uint freq, uint start_factor);
 
 /* Enumerate crypto algorithms */
 #define	CRYPTO_ALGO_OFF			0
@@ -239,4 +239,4 @@ typedef struct _pmkid_cand_list {
 
 typedef u8 ac_bitmap_t;
 
-#endif				/* _bcmwifi_h_ */
+#endif				/* _brcmu_wifi_h_ */
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index c23e9b5..63e536a 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -31,7 +31,7 @@ MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-struct sk_buff *bcm_pkt_buf_get_skb(uint len)
+struct sk_buff *brcmu_pkt_buf_get_skb(uint len)
 {
 	struct sk_buff *skb;
 
@@ -43,10 +43,10 @@ struct sk_buff *bcm_pkt_buf_get_skb(uint len)
 
 	return skb;
 }
-EXPORT_SYMBOL(bcm_pkt_buf_get_skb);
+EXPORT_SYMBOL(brcmu_pkt_buf_get_skb);
 
 /* Free the driver packet. Free the tag if present */
-void bcm_pkt_buf_free_skb(struct sk_buff *skb)
+void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 	int nest = 0;
@@ -71,11 +71,11 @@ void bcm_pkt_buf_free_skb(struct sk_buff *skb)
 		skb = nskb;
 	}
 }
-EXPORT_SYMBOL(bcm_pkt_buf_free_skb);
+EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
 
 /* copy a buffer into a pkt buffer chain */
-uint bcm_pktfrombuf(struct sk_buff *p, uint offset, int len,
+uint brcmu_pktfrombuf(struct sk_buff *p, uint offset, int len,
 		unsigned char *buf)
 {
 	uint n, ret = 0;
@@ -102,10 +102,10 @@ uint bcm_pktfrombuf(struct sk_buff *p, uint offset, int len,
 
 	return ret;
 }
-EXPORT_SYMBOL(bcm_pktfrombuf);
+EXPORT_SYMBOL(brcmu_pktfrombuf);
 
 /* return total length of buffer chain */
-uint bcm_pkttotlen(struct sk_buff *p)
+uint brcmu_pkttotlen(struct sk_buff *p)
 {
 	uint total;
 
@@ -114,13 +114,13 @@ uint bcm_pkttotlen(struct sk_buff *p)
 		total += p->len;
 	return total;
 }
-EXPORT_SYMBOL(bcm_pkttotlen);
+EXPORT_SYMBOL(brcmu_pkttotlen);
 
 /*
  * osl multiple-precedence packet queue
  * hi_prec is always >= the number of the highest non-empty precedence
  */
-struct sk_buff *bcm_pktq_penq(struct pktq *pq, int prec,
+struct sk_buff *brcmu_pktq_penq(struct pktq *pq, int prec,
 				      struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -145,9 +145,9 @@ struct sk_buff *bcm_pktq_penq(struct pktq *pq, int prec,
 
 	return p;
 }
-EXPORT_SYMBOL(bcm_pktq_penq);
+EXPORT_SYMBOL(brcmu_pktq_penq);
 
-struct sk_buff *bcm_pktq_penq_head(struct pktq *pq, int prec,
+struct sk_buff *brcmu_pktq_penq_head(struct pktq *pq, int prec,
 					   struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -171,9 +171,9 @@ struct sk_buff *bcm_pktq_penq_head(struct pktq *pq, int prec,
 
 	return p;
 }
-EXPORT_SYMBOL(bcm_pktq_penq_head);
+EXPORT_SYMBOL(brcmu_pktq_penq_head);
 
-struct sk_buff *bcm_pktq_pdeq(struct pktq *pq, int prec)
+struct sk_buff *brcmu_pktq_pdeq(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p;
@@ -196,9 +196,9 @@ struct sk_buff *bcm_pktq_pdeq(struct pktq *pq, int prec)
 
 	return p;
 }
-EXPORT_SYMBOL(bcm_pktq_pdeq);
+EXPORT_SYMBOL(brcmu_pktq_pdeq);
 
-struct sk_buff *bcm_pktq_pdeq_tail(struct pktq *pq, int prec)
+struct sk_buff *brcmu_pktq_pdeq_tail(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev;
@@ -224,10 +224,10 @@ struct sk_buff *bcm_pktq_pdeq_tail(struct pktq *pq, int prec)
 
 	return p;
 }
-EXPORT_SYMBOL(bcm_pktq_pdeq_tail);
+EXPORT_SYMBOL(brcmu_pktq_pdeq_tail);
 
 void
-bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
+brcmu_pktq_pflush(struct pktq *pq, int prec, bool dir,
 	    ifpkt_cb_t fn, void *arg)
 {
 	struct pktq_prec *q;
@@ -243,7 +243,7 @@ bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
 			else
 				prev->prev = p->prev;
 			p->prev = NULL;
-			bcm_pkt_buf_free_skb(p);
+			brcmu_pkt_buf_free_skb(p);
 			q->len--;
 			pq->len--;
 			p = (head ? q->head : prev->prev);
@@ -257,18 +257,18 @@ bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
 		q->tail = NULL;
 	}
 }
-EXPORT_SYMBOL(bcm_pktq_pflush);
+EXPORT_SYMBOL(brcmu_pktq_pflush);
 
-void bcm_pktq_flush(struct pktq *pq, bool dir,
+void brcmu_pktq_flush(struct pktq *pq, bool dir,
 		ifpkt_cb_t fn, void *arg)
 {
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
-		bcm_pktq_pflush(pq, prec, dir, fn, arg);
+		brcmu_pktq_pflush(pq, prec, dir, fn, arg);
 }
-EXPORT_SYMBOL(bcm_pktq_flush);
+EXPORT_SYMBOL(brcmu_pktq_flush);
 
-void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len)
+void brcmu_pktq_init(struct pktq *pq, int num_prec, int max_len)
 {
 	int prec;
 
@@ -283,9 +283,9 @@ void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len)
 	for (prec = 0; prec < num_prec; prec++)
 		pq->q[prec].max = pq->max;
 }
-EXPORT_SYMBOL(bcm_pktq_init);
+EXPORT_SYMBOL(brcmu_pktq_init);
 
-struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out)
+struct sk_buff *brcmu_pktq_peek_tail(struct pktq *pq, int *prec_out)
 {
 	int prec;
 
@@ -301,10 +301,10 @@ struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out)
 
 	return pq->q[prec].tail;
 }
-EXPORT_SYMBOL(bcm_pktq_peek_tail);
+EXPORT_SYMBOL(brcmu_pktq_peek_tail);
 
 /* Return sum of lengths of a specific set of precedences */
-int bcm_pktq_mlen(struct pktq *pq, uint prec_bmp)
+int brcmu_pktq_mlen(struct pktq *pq, uint prec_bmp)
 {
 	int prec, len;
 
@@ -316,10 +316,10 @@ int bcm_pktq_mlen(struct pktq *pq, uint prec_bmp)
 
 	return len;
 }
-EXPORT_SYMBOL(bcm_pktq_mlen);
+EXPORT_SYMBOL(brcmu_pktq_mlen);
 
 /* Priority dequeue from a specific set of precedences */
-struct sk_buff *bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
+struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 				      int *prec_out)
 {
 	struct pktq_prec *q;
@@ -357,10 +357,10 @@ struct sk_buff *bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 
 	return p;
 }
-EXPORT_SYMBOL(bcm_pktq_mdeq);
+EXPORT_SYMBOL(brcmu_pktq_mdeq);
 
 /* parse a xx:xx:xx:xx:xx:xx format ethernet address */
-int bcm_ether_atoe(char *p, u8 *ea)
+int brcmu_ether_atoe(char *p, u8 *ea)
 {
 	int i = 0;
 
@@ -372,11 +372,11 @@ int bcm_ether_atoe(char *p, u8 *ea)
 
 	return i == 6;
 }
-EXPORT_SYMBOL(bcm_ether_atoe);
+EXPORT_SYMBOL(brcmu_ether_atoe);
 
 #if defined(BCMDBG)
 /* pretty hex print a pkt buffer chain */
-void bcm_prpkt(const char *msg, struct sk_buff *p0)
+void brcmu_prpkt(const char *msg, struct sk_buff *p0)
 {
 	struct sk_buff *p;
 
@@ -386,13 +386,14 @@ void bcm_prpkt(const char *msg, struct sk_buff *p0)
 	for (p = p0; p; p = p->next)
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, p->data, p->len);
 }
-EXPORT_SYMBOL(bcm_prpkt);
+EXPORT_SYMBOL(brcmu_prpkt);
 #endif				/* defined(BCMDBG) */
 
 /* iovar table lookup */
-const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table, const char *name)
+const struct brcmu_iovar *brcmu_iovar_lookup(const struct brcmu_iovar *table,
+					const char *name)
 {
-	const bcm_iovar_t *vi;
+	const struct brcmu_iovar *vi;
 	const char *lookup_name;
 
 	/* skip any ':' delimited option prefixes */
@@ -410,9 +411,10 @@ const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table, const char *name)
 
 	return NULL;		/* var name not found */
 }
-EXPORT_SYMBOL(bcm_iovar_lookup);
+EXPORT_SYMBOL(brcmu_iovar_lookup);
 
-int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
+int brcmu_iovar_lencheck(const struct brcmu_iovar *vi, void *arg, int len,
+			 bool set)
 {
 	int bcmerror = 0;
 
@@ -455,7 +457,7 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 
 	return bcmerror;
 }
-EXPORT_SYMBOL(bcm_iovar_lencheck);
+EXPORT_SYMBOL(brcmu_iovar_lencheck);
 
 /*******************************************************************************
  * crc8
@@ -514,7 +516,7 @@ static const u8 crc8_table[256] = {
 	0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F
 };
 
-u8 bcm_crc8(u8 *pdata,	/* pointer to array of data to process */
+u8 brcmu_crc8(u8 *pdata,	/* pointer to array of data to process */
 			 uint nbytes,	/* number of input data bytes to process */
 			 u8 crc	/* either CRC8_INIT_VALUE or previous return value */
     ) {
@@ -524,19 +526,19 @@ u8 bcm_crc8(u8 *pdata,	/* pointer to array of data to process */
 
 	return crc;
 }
-EXPORT_SYMBOL(bcm_crc8);
+EXPORT_SYMBOL(brcmu_crc8);
 
 /*
  * Traverse a string of 1-byte tag/1-byte length/variable-length value
  * triples, returning a pointer to the substring whose first element
  * matches tag
  */
-bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen, uint key)
+struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen, uint key)
 {
-	bcm_tlv_t *elt;
+	struct brcmu_tlv *elt;
 	int totlen;
 
-	elt = (bcm_tlv_t *) buf;
+	elt = (struct brcmu_tlv *) buf;
 	totlen = buflen;
 
 	/* find tagged parameter */
@@ -547,18 +549,19 @@ bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen, uint key)
 		if ((elt->id == key) && (totlen >= (len + 2)))
 			return elt;
 
-		elt = (bcm_tlv_t *) ((u8 *) elt + (len + 2));
+		elt = (struct brcmu_tlv *) ((u8 *) elt + (len + 2));
 		totlen -= (len + 2);
 	}
 
 	return NULL;
 }
-EXPORT_SYMBOL(bcm_parse_tlvs);
+EXPORT_SYMBOL(brcmu_parse_tlvs);
 
 
 #if defined(BCMDBG)
 int
-bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags, char *buf, int len)
+brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags, char *buf,
+		   int len)
 {
 	int i;
 	char *p = buf;
@@ -609,10 +612,10 @@ bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags, char *buf, int len)
 
 	return (int)(p - buf);
 }
-EXPORT_SYMBOL(bcm_format_flags);
+EXPORT_SYMBOL(brcmu_format_flags);
 
 /* print bytes formatted as hex to a string. return the resulting string length */
-int bcm_format_hex(char *str, const void *bytes, int len)
+int brcmu_format_hex(char *str, const void *bytes, int len)
 {
 	int i;
 	char *p = str;
@@ -624,10 +627,10 @@ int bcm_format_hex(char *str, const void *bytes, int len)
 	}
 	return (int)(p - str);
 }
-EXPORT_SYMBOL(bcm_format_hex);
+EXPORT_SYMBOL(brcmu_format_hex);
 #endif				/* defined(BCMDBG) */
 
-char *bcm_chipname(uint chipid, char *buf, uint len)
+char *brcmu_chipname(uint chipid, char *buf, uint len)
 {
 	const char *fmt;
 
@@ -635,9 +638,9 @@ char *bcm_chipname(uint chipid, char *buf, uint len)
 	snprintf(buf, len, fmt, chipid);
 	return buf;
 }
-EXPORT_SYMBOL(bcm_chipname);
+EXPORT_SYMBOL(brcmu_chipname);
 
-uint bcm_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
+uint brcmu_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 {
 	uint len;
 
@@ -654,7 +657,7 @@ uint bcm_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 
 	return len;
 }
-EXPORT_SYMBOL(bcm_mkiovar);
+EXPORT_SYMBOL(brcmu_mkiovar);
 
 /* Quarter dBm units to mW
  * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
@@ -686,7 +689,7 @@ static const u16 nqdBm_to_mW_map[QDBM_TABLE_LEN] = {
 /* 185: */ 42170, 44668, 47315, 50119, 53088, 56234, 59566, 63096
 };
 
-u16 bcm_qdbm_to_mw(u8 qdbm)
+u16 brcmu_qdbm_to_mw(u8 qdbm)
 {
 	uint factor = 1;
 	int idx = qdbm - QDBM_OFFSET;
@@ -709,9 +712,9 @@ u16 bcm_qdbm_to_mw(u8 qdbm)
 	 */
 	return (nqdBm_to_mW_map[idx] + factor / 2) / factor;
 }
-EXPORT_SYMBOL(bcm_qdbm_to_mw);
+EXPORT_SYMBOL(brcmu_qdbm_to_mw);
 
-u8 bcm_mw_to_qdbm(u16 mw)
+u8 brcmu_mw_to_qdbm(u16 mw)
 {
 	u8 qdbm;
 	int offset;
@@ -741,9 +744,9 @@ u8 bcm_mw_to_qdbm(u16 mw)
 
 	return qdbm;
 }
-EXPORT_SYMBOL(bcm_mw_to_qdbm);
+EXPORT_SYMBOL(brcmu_mw_to_qdbm);
 
-uint bcm_bitcount(u8 *bitmap, uint length)
+uint brcmu_bitcount(u8 *bitmap, uint length)
 {
 	uint bitcount = 0, i;
 	u8 tmp;
@@ -756,18 +759,18 @@ uint bcm_bitcount(u8 *bitmap, uint length)
 	}
 	return bitcount;
 }
-EXPORT_SYMBOL(bcm_bitcount);
+EXPORT_SYMBOL(brcmu_bitcount);
 
-/* Initialization of bcmstrbuf structure */
-void bcm_binit(struct bcmstrbuf *b, char *buf, uint size)
+/* Initialization of brcmu_strbuf structure */
+void brcmu_binit(struct brcmu_strbuf *b, char *buf, uint size)
 {
 	b->origsize = b->size = size;
 	b->origbuf = b->buf = buf;
 }
-EXPORT_SYMBOL(bcm_binit);
+EXPORT_SYMBOL(brcmu_binit);
 
 /* Buffer sprintf wrapper to guard against buffer overflow */
-int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
+int brcmu_bprintf(struct brcmu_strbuf *b, const char *fmt, ...)
 {
 	va_list ap;
 	int r;
@@ -777,7 +780,7 @@ int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
 
 	/* Non Ansi C99 compliant returns -1,
 	 * Ansi compliant return r >= b->size,
-	 * bcmstdlib returns 0, handle all
+	 * stdlib returns 0, handle all
 	 */
 	if ((r == -1) || (r >= (int)b->size) || (r == 0)) {
 		b->size = 0;
@@ -790,4 +793,4 @@ int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
 
 	return r;
 }
-EXPORT_SYMBOL(bcm_bprintf);
+EXPORT_SYMBOL(brcmu_bprintf);
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/util/bcmwifi.c
index 955a3ab..207cb8b 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/util/bcmwifi.c
@@ -26,7 +26,7 @@
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-bool bcm_chspec_malformed(chanspec_t chanspec)
+bool brcmu_chspec_malformed(chanspec_t chanspec)
 {
 	/* must be 2G or 5G band */
 	if (!CHSPEC_IS5G(chanspec) && !CHSPEC_IS2G(chanspec))
@@ -46,14 +46,14 @@ bool bcm_chspec_malformed(chanspec_t chanspec)
 
 	return false;
 }
-EXPORT_SYMBOL(bcm_chspec_malformed);
+EXPORT_SYMBOL(brcmu_chspec_malformed);
 
 /*
  * This function returns the channel number that control traffic is being sent on, for legacy
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-u8 bcm_chspec_ctlchan(chanspec_t chspec)
+u8 brcmu_chspec_ctlchan(chanspec_t chspec)
 {
 	u8 ctl_chan;
 
@@ -76,7 +76,7 @@ u8 bcm_chspec_ctlchan(chanspec_t chspec)
 
 	return ctl_chan;
 }
-EXPORT_SYMBOL(bcm_chspec_ctlchan);
+EXPORT_SYMBOL(brcmu_chspec_ctlchan);
 
 /*
  * Return the channel number for a given frequency and base frequency.
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(bcm_chspec_ctlchan);
  *
  * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
  */
-int bcm_mhz2channel(uint freq, uint start_factor)
+int brcmu_mhz2channel(uint freq, uint start_factor)
 {
 	int ch = -1;
 	uint base;
@@ -133,5 +133,5 @@ int bcm_mhz2channel(uint freq, uint start_factor)
 
 	return ch;
 }
-EXPORT_SYMBOL(bcm_mhz2channel);
+EXPORT_SYMBOL(brcmu_mhz2channel);
 
-- 
1.7.4.1


