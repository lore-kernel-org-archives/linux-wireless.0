Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3689 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/20] staging: brcm80211: removed fullmac
 BRCMF_IOCTL_MAGIC support
Date: Mon, 12 Sep 2011 12:14:50 +0200
Message-ID: <1315822504-24210-7-git-send-email-rvossen@broadcom.com> (sfid-20110912_121605_749708_FF7775F9)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux will never call brcmf_netdev_ioctl_entry() with the value
BRCMF_IOCTL_MAGIC in a user space buffer. Thus, unused code could be
removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   33 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   33 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |   12 -
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |    5 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |  291 --------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    9 -
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    7 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  742 ---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   14 -
 10 files changed, 0 insertions(+), 1147 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 2490dde..4e8fe4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -235,39 +235,6 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		  fnc_num, addr, data);
 }
 
-int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
-			  uint length)
-{
-	int status;
-
-	u8 *tmp_buf, *tmp_ptr;
-	u8 *ptr;
-	bool ascii = func & ~0xf;
-	func &= 0x7;
-
-	status = brcmf_sdioh_cis_read(sdiodev, func, cis, length);
-
-	if (ascii) {
-		/* Move binary bits to tmp and format them
-			 into the provided buffer. */
-		tmp_buf = kmalloc(length, GFP_ATOMIC);
-		if (tmp_buf == NULL) {
-			brcmf_dbg(ERROR, "out of memory\n");
-			return -ENOMEM;
-		}
-		memcpy(tmp_buf, cis, length);
-		for (tmp_ptr = tmp_buf, ptr = cis; ptr < (cis + length - 4);
-		     tmp_ptr++) {
-			ptr += sprintf((char *)ptr, "%.2x ", *tmp_ptr & 0xff);
-			if ((((tmp_ptr - tmp_buf) + 1) & 0xf) == 0)
-				ptr += sprintf((char *)ptr, "\n");
-		}
-		kfree(tmp_buf);
-	}
-
-	return status;
-}
-
 int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 6adf5c0..b38e698 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -423,39 +423,6 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	return scratch;
 }
 
-int brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
-			 u8 *cisd, u32 length)
-{
-	u32 count;
-	int offset;
-	u32 foo;
-	u8 *cis = cisd;
-
-	brcmf_dbg(TRACE, "Func = %d\n", func);
-
-	if (!sdiodev->func_cis_ptr[func]) {
-		memset(cis, 0, length);
-		brcmf_dbg(ERROR, "no func_cis_ptr[%d]\n", func);
-		return -ENOTSUPP;
-	}
-
-	brcmf_dbg(ERROR, "func_cis_ptr[%d]=0x%04x\n",
-		  func, sdiodev->func_cis_ptr[func]);
-
-	for (count = 0; count < length; count++) {
-		offset = sdiodev->func_cis_ptr[func] + count;
-		if (brcmf_sdioh_card_regread(sdiodev, 0, offset, 1, &foo) < 0) {
-			brcmf_dbg(ERROR, "regread failed: Can't read CIS\n");
-			return -EIO;
-		}
-
-		*cis = (u8) (foo & 0xff);
-		cis++;
-	}
-
-	return 0;
-}
-
 static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a1262a6..add29c3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -789,7 +789,6 @@ struct brcmf_c_ioctl {
 #define	BRCMF_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
 
 /* common ioctl definitions */
-#define BRCMF_GET_MAGIC				0
 #define BRCMF_GET_VERSION				1
 #define BRCMF_GET_VAR				2
 #define BRCMF_SET_VAR				3
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 24f578a..3361e01 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -56,18 +56,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 extern int
 brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 
-/* Check for and handle local prot-specific iovar commands */
-extern int brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
-			    void *params, int plen, void *arg, int len,
-			    bool set);
-
-/* Add bus dump output to a buffer */
-extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr,
-				  struct brcmu_strbuf *strbuf);
-
-/* Clear any bus counters */
-extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
-
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index eacbe31..f8731c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -348,11 +348,6 @@ static void pkt_set_sum_good(struct sk_buff *skb, bool x)
 	skb->ip_summed = (x ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
 }
 
-void brcmf_proto_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
-{
-	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", drvr->prot->reqid);
-}
-
 void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 			 struct sk_buff *pktbuf)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index ba7a982..fd39998 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -48,41 +48,6 @@ static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR;
 #endif
 
-/* IOVar table */
-enum {
-	IOV_VERSION = 1,
-	IOV_MSGLEVEL,
-	IOV_BCMERRORSTR,
-	IOV_BCMERROR,
-	IOV_DUMP,
-	IOV_CLEARCOUNTS,
-	IOV_LOGDUMP,
-	IOV_LOGCAL,
-	IOV_LOGSTAMP,
-	IOV_GPIOOB,
-	IOV_LAST
-};
-
-static const struct brcmu_iovar brcmf_iovars[] = {
-	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(brcmf_version)}
-	,
-#ifdef BCMDBG
-	{"msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0}
-	,
-#endif				/* BCMDBG */
-	{"bcmerrorstr", IOV_BCMERRORSTR, 0, IOVT_BUFFER, BCME_STRLEN}
-	,
-	{"bcmerror", IOV_BCMERROR, 0, IOVT_INT8, 0}
-	,
-	{"dump", IOV_DUMP, 0, IOVT_BUFFER, BRCMF_IOCTL_MAXLEN}
-	,
-	{"clearcounts", IOV_CLEARCOUNTS, 0, IOVT_VOID, 0}
-	,
-	{"gpioob", IOV_GPIOOB, 0, IOVT_UINT32, 0}
-	,
-	{NULL, 0, 0, 0, 0}
-};
-
 /* Message trace header */
 struct msgtrace_hdr {
 	u8 version;
@@ -112,132 +77,6 @@ void brcmf_c_init(void)
 	brcmf_msg_level = BRCMF_ERROR_VAL;
 }
 
-static int brcmf_c_dump(struct brcmf_pub *drvr, char *buf, int buflen)
-{
-	struct brcmu_strbuf b;
-	struct brcmu_strbuf *strbuf = &b;
-
-	brcmu_binit(strbuf, buf, buflen);
-
-	/* Base info */
-	brcmu_bprintf(strbuf, "%s\n", brcmf_version);
-	brcmu_bprintf(strbuf, "\n");
-	brcmu_bprintf(strbuf, "pub.up %d pub.txoff %d pub.busstate %d\n",
-		    drvr->up, drvr->txoff, drvr->busstate);
-	brcmu_bprintf(strbuf, "pub.hdrlen %d pub.maxctl %d pub.rxsz %d\n",
-		    drvr->hdrlen, drvr->maxctl, drvr->rxsz);
-	brcmu_bprintf(strbuf, "pub.iswl %d pub.drv_version %ld pub.mac %pM\n",
-		    drvr->iswl, drvr->drv_version, &drvr->mac);
-	brcmu_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", drvr->bcmerror,
-		    drvr->tickcnt);
-
-	brcmu_bprintf(strbuf, "dongle stats:\n");
-	brcmu_bprintf(strbuf,
-		    "tx_packets %ld tx_bytes %ld tx_errors %ld tx_dropped %ld\n",
-		    drvr->dstats.tx_packets, drvr->dstats.tx_bytes,
-		    drvr->dstats.tx_errors, drvr->dstats.tx_dropped);
-	brcmu_bprintf(strbuf,
-		    "rx_packets %ld rx_bytes %ld rx_errors %ld rx_dropped %ld\n",
-		    drvr->dstats.rx_packets, drvr->dstats.rx_bytes,
-		    drvr->dstats.rx_errors, drvr->dstats.rx_dropped);
-	brcmu_bprintf(strbuf, "multicast %ld\n", drvr->dstats.multicast);
-
-	brcmu_bprintf(strbuf, "bus stats:\n");
-	brcmu_bprintf(strbuf, "tx_packets %ld tx_multicast %ld tx_errors %ld\n",
-		    drvr->tx_packets, drvr->tx_multicast, drvr->tx_errors);
-	brcmu_bprintf(strbuf, "tx_ctlpkts %ld tx_ctlerrs %ld\n",
-		    drvr->tx_ctlpkts, drvr->tx_ctlerrs);
-	brcmu_bprintf(strbuf, "rx_packets %ld rx_multicast %ld rx_errors %ld\n",
-		    drvr->rx_packets, drvr->rx_multicast, drvr->rx_errors);
-	brcmu_bprintf(strbuf,
-		    "rx_ctlpkts %ld rx_ctlerrs %ld rx_dropped %ld rx_flushed %ld\n",
-		    drvr->rx_ctlpkts, drvr->rx_ctlerrs, drvr->rx_dropped,
-		    drvr->rx_flushed);
-	brcmu_bprintf(strbuf,
-		    "rx_readahead_cnt %ld tx_realloc %ld fc_packets %ld\n",
-		    drvr->rx_readahead_cnt, drvr->tx_realloc, drvr->fc_packets);
-	brcmu_bprintf(strbuf, "wd_dpc_sched %ld\n", drvr->wd_dpc_sched);
-	brcmu_bprintf(strbuf, "\n");
-
-	/* Add any prot info */
-	brcmf_proto_dump(drvr, strbuf);
-	brcmu_bprintf(strbuf, "\n");
-
-	/* Add any bus info */
-	brcmf_sdbrcm_bus_dump(drvr, strbuf);
-
-	return !strbuf->size ? -EOVERFLOW : 0;
-}
-
-static int
-brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
-		u32 actionid, const char *name, void *params, int plen,
-		void *arg, int len, int val_size)
-{
-	int bcmerror = 0;
-	s32 int_val = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
-	if (bcmerror != 0)
-		goto exit;
-
-	if (plen >= (int)sizeof(int_val))
-		memcpy(&int_val, params, sizeof(int_val));
-
-	switch (actionid) {
-	case IOV_GVAL(IOV_VERSION):
-		/* Need to have checked buffer length */
-		strncpy((char *)arg, brcmf_version, len);
-		break;
-
-	case IOV_GVAL(IOV_MSGLEVEL):
-		int_val = (s32) brcmf_msg_level;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_MSGLEVEL):
-		brcmf_msg_level = int_val;
-		break;
-
-	case IOV_GVAL(IOV_BCMERRORSTR):
-		strncpy((char *)arg, "bcm_error",
-			BCME_STRLEN);
-		((char *)arg)[BCME_STRLEN - 1] = 0x00;
-		break;
-
-	case IOV_GVAL(IOV_BCMERROR):
-		int_val = (s32) drvr->bcmerror;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_GVAL(IOV_DUMP):
-		bcmerror = brcmf_c_dump(drvr, arg, len);
-		break;
-
-	case IOV_SVAL(IOV_CLEARCOUNTS):
-		drvr->tx_packets = drvr->rx_packets = 0;
-		drvr->tx_errors = drvr->rx_errors = 0;
-		drvr->tx_ctlpkts = drvr->rx_ctlpkts = 0;
-		drvr->tx_ctlerrs = drvr->rx_ctlerrs = 0;
-		drvr->rx_dropped = 0;
-		drvr->rx_readahead_cnt = 0;
-		drvr->tx_realloc = 0;
-		drvr->wd_dpc_sched = 0;
-		memset(&drvr->dstats, 0, sizeof(drvr->dstats));
-		brcmf_bus_clearcounts(drvr);
-		break;
-
-	default:
-		bcmerror = -ENOTSUPP;
-		break;
-	}
-
-exit:
-	return bcmerror;
-}
-
 bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
@@ -286,136 +125,6 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	return p != NULL;
 }
 
-static int
-brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
-	     void *params, int plen, void *arg, int len, bool set)
-{
-	int bcmerror = 0;
-	int val_size;
-	const struct brcmu_iovar *vi = NULL;
-	u32 actionid;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (name == NULL || len < 0)
-		return -EINVAL;
-
-	/* Set does not take qualifiers */
-	if (set && (params || plen))
-		return -EINVAL;
-
-	/* Get must have return space;*/
-	if (!set && !(arg && len))
-		return -EINVAL;
-
-	vi = brcmu_iovar_lookup(brcmf_iovars, name);
-	if (vi == NULL) {
-		bcmerror = -ENOTSUPP;
-		goto exit;
-	}
-
-	brcmf_dbg(CTL, "%s %s, len %d plen %d\n",
-		  name, set ? "set" : "get", len, plen);
-
-	/* set up 'params' pointer in case this is a set command so that
-	 * the convenience int and bool code can be common to set and get
-	 */
-	if (params == NULL) {
-		params = arg;
-		plen = len;
-	}
-
-	if (vi->type == IOVT_VOID)
-		val_size = 0;
-	else if (vi->type == IOVT_BUFFER)
-		val_size = len;
-	else
-		/* all other types are integer sized */
-		val_size = sizeof(int);
-
-	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-	bcmerror =
-	    brcmf_c_doiovar(drvr, vi, actionid, name, params, plen, arg, len,
-			val_size);
-
-exit:
-	return bcmerror;
-}
-
-int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
-		  uint buflen)
-{
-	int bcmerror = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (!buf)
-		return -EINVAL;
-
-	switch (ioc->cmd) {
-	case BRCMF_GET_MAGIC:
-		if (buflen < sizeof(int))
-			bcmerror = -EOVERFLOW;
-		else
-			*(int *)buf = BRCMF_IOCTL_MAGIC;
-		break;
-
-	case BRCMF_GET_VERSION:
-		if (buflen < sizeof(int))
-			bcmerror = -EOVERFLOW;
-		else
-			*(int *)buf = BRCMF_IOCTL_VERSION;
-		break;
-
-	case BRCMF_GET_VAR:
-	case BRCMF_SET_VAR:{
-			char *arg;
-			uint arglen;
-
-			/* scan past the name to any arguments */
-			for (arg = buf, arglen = buflen; *arg && arglen;
-			     arg++, arglen--)
-				;
-
-			if (*arg) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-
-			/* account for the NUL terminator */
-			arg++, arglen--;
-
-			/* call with the appropriate arguments */
-			if (ioc->cmd == BRCMF_GET_VAR)
-				bcmerror = brcmf_c_iovar_op(drvr, buf, arg,
-						arglen, buf, buflen, IOV_GET);
-			else
-				bcmerror =
-				    brcmf_c_iovar_op(drvr, buf, NULL, 0, arg,
-						     arglen, IOV_SET);
-			if (bcmerror != -ENOTSUPP)
-				break;
-
-			/* if still not found, try bus module */
-			if (ioc->cmd == BRCMF_GET_VAR)
-				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
-						buf, arg, arglen, buf, buflen,
-						IOV_GET);
-			else
-				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
-						buf, NULL, 0, arg, arglen,
-						IOV_SET);
-
-			break;
-		}
-
-	default:
-		bcmerror = -ENOTSUPP;
-	}
-
-	return bcmerror;
-}
-
 #ifdef BCMDBG
 static void
 brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index bb0f718..539a24d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1012,15 +1012,6 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		goto done;
 	}
 
-	/* check for local brcmf ioctl and handle it */
-	if (driver == BRCMF_IOCTL_MAGIC) {
-		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc,
-					 buf, buflen);
-		if (bcmerror)
-			drvr_priv->pub.bcmerror = bcmerror;
-		goto done;
-	}
-
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
 		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 2ce5fea..6686f4c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -52,16 +52,9 @@ extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
 extern int brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx,
 			     struct brcmf_ioctl *ioc, void *buf, int len);
 
-/* Add prot dump output to a buffer */
-extern void brcmf_proto_dump(struct brcmf_pub *drvr,
-			     struct brcmu_strbuf *strbuf);
-
 /* Update local copy of dongle statistics */
 extern void brcmf_proto_dstats(struct brcmf_pub *drvr);
 
-extern int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc,
-			 void *buf, uint buflen);
-
 extern int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr);
 
 extern int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index aadc5bb..3435124 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -855,8 +855,6 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
 #ifdef BCMDBG
-static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
-				       unsigned char *msg, uint msglen);
 static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size);
 static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus);
 #endif				/* BCMDBG  */
@@ -1712,196 +1710,6 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-/* IOVar table */
-enum {
-	IOV_INTR = 1,
-	IOV_POLLRATE,
-	IOV_SDREG,
-	IOV_SBREG,
-	IOV_SDCIS,
-	IOV_MEMBYTES,
-	IOV_MEMSIZE,
-#ifdef BCMDBG
-	IOV_CHECKDIED,
-	IOV_CONS,
-	IOV_DCONSOLE_POLL,
-#endif
-	IOV_DOWNLOAD,
-	IOV_FORCEEVEN,
-	IOV_SDIOD_DRIVE,
-	IOV_READAHEAD,
-	IOV_SDRXCHAIN,
-	IOV_ALIGNCTL,
-	IOV_SDALIGN,
-	IOV_DEVRESET,
-	IOV_TXBOUND,
-	IOV_RXBOUND,
-	IOV_TXMINMAX,
-	IOV_IDLETIME,
-	IOV_IDLECLOCK,
-	IOV_SLEEP,
-	IOV_WDTICK,
-	IOV_IOCTLTIMEOUT,
-	IOV_VARS
-};
-
-static const struct brcmu_iovar brcmf_sdio_iovars[] = {
-	{"intr", IOV_INTR, 0, IOVT_BOOL, 0},
-	{"sleep", IOV_SLEEP, 0, IOVT_BOOL, 0},
-	{"pollrate", IOV_POLLRATE, 0, IOVT_UINT32, 0},
-	{"idletime", IOV_IDLETIME, 0, IOVT_INT32, 0},
-	{"idleclock", IOV_IDLECLOCK, 0, IOVT_INT32, 0},
-	{"membytes", IOV_MEMBYTES, 0, IOVT_BUFFER, 2 * sizeof(int)},
-	{"memsize", IOV_MEMSIZE, 0, IOVT_UINT32, 0},
-	{"download", IOV_DOWNLOAD, 0, IOVT_BOOL, 0},
-	{"vars", IOV_VARS, 0, IOVT_BUFFER, 0},
-	{"sdiod_drive", IOV_SDIOD_DRIVE, 0, IOVT_UINT32, 0},
-	{"readahead", IOV_READAHEAD, 0, IOVT_BOOL, 0},
-	{"sdrxchain", IOV_SDRXCHAIN, 0, IOVT_BOOL, 0},
-	{"alignctl", IOV_ALIGNCTL, 0, IOVT_BOOL, 0},
-	{"sdalign", IOV_SDALIGN, 0, IOVT_BOOL, 0},
-	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
-	{"wdtick", IOV_WDTICK, 0, IOVT_UINT32, 0},
-	{"ioctl_timeout", IOV_IOCTLTIMEOUT, 0, IOVT_UINT32, 0},
-#ifdef BCMDBG
-	{"cons", IOV_CONS, 0, IOVT_BUFFER, 0}
-	,
-	{"dconpoll", IOV_DCONSOLE_POLL, 0, IOVT_UINT32, 0}
-	,
-	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
-	,
-	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
-	,
-	{"sd_cis", IOV_SDCIS, 0, IOVT_BUFFER, BRCMF_IOCTL_MAXLEN}
-	,
-	{"forcealign", IOV_FORCEEVEN, 0, IOVT_BOOL, 0}
-	,
-	{"txbound", IOV_TXBOUND, 0, IOVT_UINT32, 0}
-	,
-	{"rxbound", IOV_RXBOUND, 0, IOVT_UINT32, 0}
-	,
-	{"txminmax", IOV_TXMINMAX, 0, IOVT_UINT32, 0}
-	,
-	{"checkdied", IOV_CHECKDIED, 0, IOVT_BUFFER, 0}
-	,
-#endif				/* BCMDBG */
-
-	{NULL, 0, 0, 0, 0}
-};
-
-static void
-brcmf_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
-{
-	uint q1, q2;
-
-	if (!div) {
-		brcmu_bprintf(strbuf, "%s N/A", desc);
-	} else {
-		q1 = num / div;
-		q2 = (100 * (num - (q1 * div))) / div;
-		brcmu_bprintf(strbuf, "%s %d.%02d", desc, q1, q2);
-	}
-}
-
-void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
-{
-	struct brcmf_bus *bus = drvr->bus;
-
-	brcmu_bprintf(strbuf, "Bus SDIO structure:\n");
-	brcmu_bprintf(strbuf,
-		    "hostintmask 0x%08x intstatus 0x%08x sdpcm_ver %d\n",
-		    bus->hostintmask, bus->intstatus, bus->sdpcm_ver);
-	brcmu_bprintf(strbuf,
-		    "fcstate %d qlen %d tx_seq %d, max %d, rxskip %d rxlen %d rx_seq %d\n",
-		    bus->fcstate, pktq_len(&bus->txq), bus->tx_seq, bus->tx_max,
-		    bus->rxskip, bus->rxlen, bus->rx_seq);
-	brcmu_bprintf(strbuf, "intr %d intrcount %d lastintrs %d spurious %d\n",
-		    bus->intr, bus->intrcount, bus->lastintrs, bus->spurious);
-	brcmu_bprintf(strbuf, "pollrate %d pollcnt %d regfails %d\n",
-		    bus->pollrate, bus->pollcnt, bus->regfails);
-
-	brcmu_bprintf(strbuf, "\nAdditional counters:\n");
-	brcmu_bprintf(strbuf,
-		    "tx_sderrs %d fcqueued %d rxrtx %d rx_toolong %d rxc_errors %d\n",
-		    bus->tx_sderrs, bus->fcqueued, bus->rxrtx, bus->rx_toolong,
-		    bus->rxc_errors);
-	brcmu_bprintf(strbuf, "rx_hdrfail %d badhdr %d badseq %d\n",
-		    bus->rx_hdrfail, bus->rx_badhdr, bus->rx_badseq);
-	brcmu_bprintf(strbuf, "fc_rcvd %d, fc_xoff %d, fc_xon %d\n",
-		      bus->fc_rcvd, bus->fc_xoff, bus->fc_xon);
-	brcmu_bprintf(strbuf, "rxglomfail %d, rxglomframes %d, rxglompkts %d\n",
-		    bus->rxglomfail, bus->rxglomframes, bus->rxglompkts);
-	brcmu_bprintf(strbuf, "f2rx (hdrs/data) %d (%d/%d), f2tx %d f1regs"
-		      " %d\n",
-		      (bus->f2rxhdrs + bus->f2rxdata), bus->f2rxhdrs,
-		      bus->f2rxdata, bus->f2txdata, bus->f1regdata);
-	{
-		brcmf_dump_pct(strbuf, "\nRx: pkts/f2rd", bus->drvr->rx_packets,
-			     (bus->f2rxhdrs + bus->f2rxdata));
-		brcmf_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->rx_packets,
-			     bus->f1regdata);
-		brcmf_dump_pct(strbuf, ", pkts/sd", bus->drvr->rx_packets,
-			     (bus->f2rxhdrs + bus->f2rxdata + bus->f1regdata));
-		brcmf_dump_pct(strbuf, ", pkts/int", bus->drvr->rx_packets,
-			     bus->intrcount);
-		brcmu_bprintf(strbuf, "\n");
-
-		brcmf_dump_pct(strbuf, "Rx: glom pct", (100 * bus->rxglompkts),
-			     bus->drvr->rx_packets);
-		brcmf_dump_pct(strbuf, ", pkts/glom", bus->rxglompkts,
-			     bus->rxglomframes);
-		brcmu_bprintf(strbuf, "\n");
-
-		brcmf_dump_pct(strbuf, "Tx: pkts/f2wr", bus->drvr->tx_packets,
-			     bus->f2txdata);
-		brcmf_dump_pct(strbuf, ", pkts/f1sd", bus->drvr->tx_packets,
-			     bus->f1regdata);
-		brcmf_dump_pct(strbuf, ", pkts/sd", bus->drvr->tx_packets,
-			     (bus->f2txdata + bus->f1regdata));
-		brcmf_dump_pct(strbuf, ", pkts/int", bus->drvr->tx_packets,
-			     bus->intrcount);
-		brcmu_bprintf(strbuf, "\n");
-
-		brcmf_dump_pct(strbuf, "Total: pkts/f2rw",
-			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
-			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata));
-		brcmf_dump_pct(strbuf, ", pkts/f1sd",
-			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
-			     bus->f1regdata);
-		brcmf_dump_pct(strbuf, ", pkts/sd",
-			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
-			     (bus->f2txdata + bus->f2rxhdrs + bus->f2rxdata +
-			      bus->f1regdata));
-		brcmf_dump_pct(strbuf, ", pkts/int",
-			     (bus->drvr->tx_packets + bus->drvr->rx_packets),
-			     bus->intrcount);
-		brcmu_bprintf(strbuf, "\n\n");
-	}
-
-#ifdef BCMDBG
-	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
-		      bus->dpc_sched, " not ");
-	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
-		    bus->roundup);
-#endif				/* BCMDBG */
-	brcmu_bprintf(strbuf,
-		    "clkstate %d activity %d idletime %d idlecount %d sleeping %d\n",
-		    bus->clkstate, bus->activity, bus->idletime, bus->idlecount,
-		    bus->sleeping);
-}
-
-void brcmf_bus_clearcounts(struct brcmf_pub *drvr)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *) drvr->bus;
-
-	bus->intrcount = bus->lastintrs = bus->spurious = bus->regfails = 0;
-	bus->rxrtx = bus->rx_toolong = bus->rxc_errors = 0;
-	bus->rx_hdrfail = bus->rx_badhdr = bus->rx_badseq = 0;
-	bus->tx_sderrs = bus->fc_rcvd = bus->fc_xoff = bus->fc_xon = 0;
-	bus->rxglomfail = bus->rxglomframes = bus->rxglompkts = 0;
-	bus->f2rxhdrs = bus->f2rxdata = bus->f2txdata = bus->f1regdata = 0;
-}
-
 static int
 brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		 uint size)
@@ -2300,417 +2108,6 @@ err:
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
-				const struct brcmu_iovar *vi, u32 actionid,
-				const char *name, void *params, int plen,
-				void *arg, int len, int val_size)
-{
-	int bcmerror = 0;
-	s32 int_val = 0;
-	bool bool_val = 0;
-
-	brcmf_dbg(TRACE, "Enter, action %d name %s params %p plen %d arg %p len %d val_size %d\n",
-		  actionid, name, params, plen, arg, len, val_size);
-
-	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
-	if (bcmerror != 0)
-		goto exit;
-
-	if (plen >= (int)sizeof(int_val))
-		memcpy(&int_val, params, sizeof(int_val));
-
-	bool_val = (int_val != 0) ? true : false;
-
-	/* Some ioctls use the bus */
-	brcmf_sdbrcm_sdlock(bus);
-
-	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
-	if (bus->drvr->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
-					actionid == IOV_GVAL(IOV_DEVRESET))) {
-		bcmerror = -EPERM;
-		goto exit;
-	}
-
-	/* Handle sleep stuff before any clock mucking */
-	if (vi->varid == IOV_SLEEP) {
-		if (IOV_ISSET(actionid)) {
-			bcmerror = brcmf_sdbrcm_bussleep(bus, bool_val);
-		} else {
-			int_val = (s32) bus->sleeping;
-			memcpy(arg, &int_val, val_size);
-		}
-		goto exit;
-	}
-
-	/* Request clock to allow SDIO accesses */
-	if (!bus->drvr->dongle_reset) {
-		bus_wake(bus);
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-	}
-
-	switch (actionid) {
-	case IOV_GVAL(IOV_INTR):
-		int_val = (s32) bus->intr;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_INTR):
-		bus->intr = bool_val;
-		break;
-
-	case IOV_GVAL(IOV_POLLRATE):
-		int_val = (s32) bus->pollrate;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_POLLRATE):
-		bus->pollrate = (uint) int_val;
-		bus->poll = (bus->pollrate != 0);
-		break;
-
-	case IOV_GVAL(IOV_IDLETIME):
-		int_val = bus->idletime;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_IDLETIME):
-		if ((int_val < 0) && (int_val != BRCMF_IDLE_IMMEDIATE))
-			bcmerror = -EINVAL;
-		else
-			bus->idletime = int_val;
-		break;
-
-	case IOV_GVAL(IOV_IDLECLOCK):
-		int_val = (s32) bus->idleclock;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_IDLECLOCK):
-		bus->idleclock = int_val;
-		break;
-
-	case IOV_SVAL(IOV_MEMBYTES):
-	case IOV_GVAL(IOV_MEMBYTES):
-		{
-			u32 address;
-			uint size, dsize;
-			u8 *data;
-
-			bool set = (actionid == IOV_SVAL(IOV_MEMBYTES));
-
-			address = (u32) int_val;
-			memcpy(&int_val, (char *)params + sizeof(int_val),
-			       sizeof(int_val));
-			size = (uint) int_val;
-
-			/* Do some validation */
-			dsize = set ? plen - (2 * sizeof(int)) : len;
-			if (dsize < size) {
-				brcmf_dbg(ERROR, "error on %s membytes, addr 0x%08x size %d dsize %d\n",
-					  set ? "set" : "get",
-					  address, size, dsize);
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			brcmf_dbg(INFO, "Request to %s %d bytes at address 0x%08x\n",
-				  set ? "write" : "read", size, address);
-
-			/* If we know about SOCRAM, check for a fit */
-			if ((bus->orig_ramsize) &&
-			    ((address > bus->orig_ramsize)
-			     || (address + size > bus->orig_ramsize))) {
-				brcmf_dbg(ERROR, "ramsize 0x%08x doesn't have %d bytes at 0x%08x\n",
-					  bus->orig_ramsize, size, address);
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			/* Generate the actual data pointer */
-			data =
-			    set ? (u8 *) params +
-			    2 * sizeof(int) : (u8 *) arg;
-
-			/* Call to do the transfer */
-			bcmerror = brcmf_sdbrcm_membytes(bus, set, address,
-							 data, size);
-
-			break;
-		}
-
-	case IOV_GVAL(IOV_MEMSIZE):
-		int_val = (s32) bus->ramsize;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_GVAL(IOV_SDIOD_DRIVE):
-		int_val = (s32) brcmf_sdiod_drive_strength;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_SDIOD_DRIVE):
-		brcmf_sdiod_drive_strength = int_val;
-		brcmf_sdbrcm_sdiod_drive_strength_init(bus,
-					     brcmf_sdiod_drive_strength);
-		break;
-
-	case IOV_SVAL(IOV_DOWNLOAD):
-		bcmerror = brcmf_sdbrcm_download_state(bus, bool_val);
-		break;
-
-	case IOV_SVAL(IOV_VARS):
-		bcmerror = brcmf_sdbrcm_downloadvars(bus, arg, len);
-		break;
-
-	case IOV_GVAL(IOV_READAHEAD):
-		int_val = (s32) brcmf_readahead;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_READAHEAD):
-		if (bool_val && !brcmf_readahead)
-			bus->nextlen = 0;
-		brcmf_readahead = bool_val;
-		break;
-
-	case IOV_GVAL(IOV_SDRXCHAIN):
-		int_val = (s32) bus->use_rxchain;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_SDRXCHAIN):
-		if (bool_val && !bus->sd_rxchain)
-			bcmerror = -ENOTSUPP;
-		else
-			bus->use_rxchain = bool_val;
-		break;
-	case IOV_GVAL(IOV_ALIGNCTL):
-		int_val = (s32) brcmf_alignctl;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_ALIGNCTL):
-		brcmf_alignctl = bool_val;
-		break;
-
-	case IOV_GVAL(IOV_SDALIGN):
-		int_val = BRCMF_SDALIGN;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-#ifdef BCMDBG
-	case IOV_GVAL(IOV_VARS):
-		if (bus->varsz < (uint) len)
-			memcpy(arg, bus->vars, bus->varsz);
-		else
-			bcmerror = -EOVERFLOW;
-		break;
-#endif				/* BCMDBG */
-
-#ifdef BCMDBG
-	case IOV_GVAL(IOV_DCONSOLE_POLL):
-		int_val = (s32) brcmf_console_ms;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_DCONSOLE_POLL):
-		brcmf_console_ms = (uint) int_val;
-		break;
-
-	case IOV_SVAL(IOV_CONS):
-		if (len > 0)
-			bcmerror = brcmf_sdbrcm_bus_console_in(bus->drvr,
-							       arg, len - 1);
-		break;
-
-	case IOV_GVAL(IOV_SDREG):
-		{
-			struct brcmf_sdreg *sd_ptr;
-			u32 addr, size;
-
-			sd_ptr = (struct brcmf_sdreg *) params;
-
-			addr = bus->ci->buscorebase + sd_ptr->offset;
-			size = sd_ptr->func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->sdiodev,
-							      addr, size);
-			if (brcmf_sdcard_regfail(bus->sdiodev))
-				bcmerror = -EIO;
-			memcpy(arg, &int_val, sizeof(s32));
-			break;
-		}
-
-	case IOV_SVAL(IOV_SDREG):
-		{
-			struct brcmf_sdreg *sd_ptr;
-			u32 addr, size;
-
-			sd_ptr = (struct brcmf_sdreg *) params;
-
-			addr = bus->ci->buscorebase + sd_ptr->offset;
-			size = sd_ptr->func;
-			brcmf_sdcard_reg_write(bus->sdiodev, addr, size,
-					       sd_ptr->value);
-			if (brcmf_sdcard_regfail(bus->sdiodev))
-				bcmerror = -EIO;
-			break;
-		}
-
-		/* Same as above, but offset is not backplane
-		 (not SDIO core) */
-	case IOV_GVAL(IOV_SBREG):
-		{
-			struct brcmf_sdreg sdreg;
-			u32 addr, size;
-
-			memcpy(&sdreg, params, sizeof(sdreg));
-
-			addr = SI_ENUM_BASE + sdreg.offset;
-			size = sdreg.func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->sdiodev,
-							      addr, size);
-			if (brcmf_sdcard_regfail(bus->sdiodev))
-				bcmerror = -EIO;
-			memcpy(arg, &int_val, sizeof(s32));
-			break;
-		}
-
-	case IOV_SVAL(IOV_SBREG):
-		{
-			struct brcmf_sdreg sdreg;
-			u32 addr, size;
-
-			memcpy(&sdreg, params, sizeof(sdreg));
-
-			addr = SI_ENUM_BASE + sdreg.offset;
-			size = sdreg.func;
-			brcmf_sdcard_reg_write(bus->sdiodev, addr, size,
-					       sdreg.value);
-			if (brcmf_sdcard_regfail(bus->sdiodev))
-				bcmerror = -EIO;
-			break;
-		}
-
-	case IOV_GVAL(IOV_SDCIS):
-		{
-			*(char *)arg = 0;
-
-			strcat(arg, "\nFunc 0\n");
-			brcmf_sdcard_cis_read(bus->sdiodev, 0x10,
-					(u8 *) arg + strlen(arg),
-					SBSDIO_CIS_SIZE_LIMIT);
-			strcat(arg, "\nFunc 1\n");
-			brcmf_sdcard_cis_read(bus->sdiodev, 0x11,
-					(u8 *) arg + strlen(arg),
-					SBSDIO_CIS_SIZE_LIMIT);
-			strcat(arg, "\nFunc 2\n");
-			brcmf_sdcard_cis_read(bus->sdiodev, 0x12,
-					(u8 *) arg + strlen(arg),
-					SBSDIO_CIS_SIZE_LIMIT);
-			break;
-		}
-
-	case IOV_GVAL(IOV_FORCEEVEN):
-		int_val = (s32) forcealign;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_FORCEEVEN):
-		forcealign = bool_val;
-		break;
-
-	case IOV_GVAL(IOV_TXBOUND):
-		int_val = (s32) brcmf_txbound;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_TXBOUND):
-		brcmf_txbound = (uint) int_val;
-		break;
-
-	case IOV_GVAL(IOV_RXBOUND):
-		int_val = (s32) brcmf_rxbound;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_RXBOUND):
-		brcmf_rxbound = (uint) int_val;
-		break;
-
-	case IOV_GVAL(IOV_TXMINMAX):
-		int_val = (s32) brcmf_txminmax;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_TXMINMAX):
-		brcmf_txminmax = (uint) int_val;
-		break;
-#endif				/* BCMDBG */
-
-	case IOV_SVAL(IOV_DEVRESET):
-		brcmf_dbg(TRACE, "Called set IOV_DEVRESET=%d dongle_reset=%d busstate=%d\n",
-			  bool_val, bus->drvr->dongle_reset,
-			  bus->drvr->busstate);
-
-		brcmf_bus_devreset(bus->drvr, (u8) bool_val);
-
-		break;
-
-	case IOV_GVAL(IOV_DEVRESET):
-		brcmf_dbg(TRACE, "Called get IOV_DEVRESET\n");
-
-		/* Get its status */
-		int_val = (bool) bus->drvr->dongle_reset;
-		memcpy(arg, &int_val, val_size);
-
-		break;
-
-	case IOV_GVAL(IOV_WDTICK):
-		int_val = (s32) brcmf_watchdog_ms;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_WDTICK):
-		if (!bus->drvr->up) {
-			bcmerror = -ENOLINK;
-			break;
-		}
-		brcmf_sdbrcm_wd_timer(bus, (uint) int_val);
-		break;
-
-	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
-			int_val = brcmf_ioctl_timeout_msec;
-			memcpy(arg, &int_val, sizeof(int_val));
-			break;
-		}
-
-	case IOV_SVAL(IOV_IOCTLTIMEOUT):{
-			if (int_val <= 0)
-				bcmerror = -EINVAL;
-			else
-				brcmf_ioctl_timeout_msec = int_val;
-			break;
-		}
-
-	default:
-		bcmerror = -ENOTSUPP;
-		break;
-	}
-
-exit:
-	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
-		bus->activity = false;
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-	}
-
-	brcmf_sdbrcm_sdunlock(bus);
-
-	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
-		brcmf_c_preinit_ioctls(bus->drvr);
-
-	return bcmerror;
-}
-
 static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 {
 	int bcmerror = 0;
@@ -2851,79 +2248,6 @@ fail:
 	return bcmerror;
 }
 
-int
-brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
-			  void *params, int plen, void *arg, int len, bool set)
-{
-	struct brcmf_bus *bus = drvr->bus;
-	const struct brcmu_iovar *vi = NULL;
-	int bcmerror = 0;
-	int val_size;
-	u32 actionid;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (name == NULL || len < 0)
-		return -EINVAL;
-
-	/* Set does not take qualifiers */
-	if (set && (params || plen))
-		return -EINVAL;
-
-	/* Get must have return space;*/
-	if (!set && !(arg && len))
-		return -EINVAL;
-
-	/* Look up var locally; if not found pass to host driver */
-	vi = brcmu_iovar_lookup(brcmf_sdio_iovars, name);
-	if (vi == NULL) {
-		brcmf_sdbrcm_sdlock(bus);
-
-		bus_wake(bus);
-
-		/* Turn on clock in case SD command needs backplane */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-		bcmerror = brcmf_sdcard_iovar_op(bus->sdiodev, name, params,
-						 plen, arg, len, set);
-
-		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
-		    !bus->dpc_sched) {
-			bus->activity = false;
-			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-		}
-
-		brcmf_sdbrcm_sdunlock(bus);
-		goto exit;
-	}
-
-	brcmf_dbg(CTL, "%s %s, len %d plen %d\n",
-		  name, set ? "set" : "get", len, plen);
-
-	/* set up 'params' pointer in case this is a set command so that
-	 * the convenience int and bool code can be common to set and get
-	 */
-	if (params == NULL) {
-		params = arg;
-		plen = len;
-	}
-
-	if (vi->type == IOVT_VOID)
-		val_size = 0;
-	else if (vi->type == IOVT_BUFFER)
-		val_size = len;
-	else
-		/* all other types are integer sized */
-		val_size = sizeof(int);
-
-	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-	bcmerror = brcmf_sdbrcm_doiovar(bus, vi, actionid, name, params, plen,
-					arg, len, val_size);
-
-exit:
-	return bcmerror;
-}
-
 void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 {
 	u32 local_hostintmask;
@@ -4562,72 +3886,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	return bus->ipend;
 }
 
-#ifdef BCMDBG
-static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
-				       unsigned char *msg, uint msglen)
-{
-	struct brcmf_bus *bus = drvr->bus;
-	u32 addr, val;
-	int rv;
-	struct sk_buff *pkt;
-
-	/* Address could be zero if CONSOLE := 0 in dongle Makefile */
-	if (bus->console_addr == 0)
-		return -ENOTSUPP;
-
-	/* Exclusive bus access */
-	brcmf_sdbrcm_sdlock(bus);
-
-	/* Don't allow input if dongle is in reset */
-	if (bus->drvr->dongle_reset) {
-		brcmf_sdbrcm_sdunlock(bus);
-		return -EPERM;
-	}
-
-	/* Request clock to allow SDIO accesses */
-	bus_wake(bus);
-	/* No pend allowed since txpkt is called later, ht clk has to be on */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-	/* Zero cbuf_index */
-	addr = bus->console_addr + offsetof(struct rte_console, cbuf_idx);
-	val = cpu_to_le32(0);
-	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
-	if (rv < 0)
-		goto done;
-
-	/* Write message into cbuf */
-	addr = bus->console_addr + offsetof(struct rte_console, cbuf);
-	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)msg, msglen);
-	if (rv < 0)
-		goto done;
-
-	/* Write length into vcons_in */
-	addr = bus->console_addr + offsetof(struct rte_console, vcons_in);
-	val = cpu_to_le32(msglen);
-	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
-	if (rv < 0)
-		goto done;
-
-	/* Bump dongle by sending an empty event pkt.
-	 * sdpcm_sendup (RX) checks for virtual console input.
-	 */
-	pkt = brcmu_pkt_buf_get_skb(4 + SDPCM_RESERVE);
-	if ((pkt != NULL) && bus->clkstate == CLK_AVAIL)
-		brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
-
-done:
-	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
-		bus->activity = false;
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-	}
-
-	brcmf_sdbrcm_sdunlock(bus);
-
-	return rv;
-}
-#endif				/* BCMDBG */
-
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
 	if (chipid == BCM4329_CHIP_ID)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index ddb6656..aa177ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -149,16 +149,6 @@ extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint func,
 extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
 				   u32 addr, u8 data, int *err);
 
-/* Read CIS content for specified function.
- *   fn:     function whose CIS is being requested (0 is common CIS)
- *   cis:    pointer to memory location to place results
- *   length: number of bytes to read
- * Internally, this routine uses the values from the cis base regs (0x9-0xB)
- * to form an SDIO-space address to read the data from.
- */
-extern int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
-				 u8 *cis, uint length);
-
 /* Synchronous access to device (client) core registers via CMD53 to F1.
  *   addr: backplane address (i.e. >= regsva from attach)
  *   size: register width in bytes (2 or 4)
@@ -255,10 +245,6 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			   u32 addr, uint regwidth,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
 
-/* get cis data */
-extern int brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
-				u8 *cis, u32 length);
-
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
-- 
1.7.4.1


