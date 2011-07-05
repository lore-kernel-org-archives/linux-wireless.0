Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1397 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/31] staging: brcm80211: rename macros in dhd_dbg.h
Date: Wed, 6 Jul 2011 00:02:31 +0200
Message-ID: <1309903378-29021-5-git-send-email-arend@broadcom.com> (sfid-20110706_000353_353707_E8D7EEAB)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The header file dhd_dbg.h contains several macros used throughout
the code starting with DHD_. These have been renamed to get rid
of this broadcom specific acronym.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |   72 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |  218 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h    |   62 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |  224 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   | 1018 ++++++++++++-----------
 5 files changed, 815 insertions(+), 779 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 30c5d2d..4b8eb9c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -105,7 +105,7 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 	int len = le32_to_cpu(prot->msg.len) +
 			sizeof(struct brcmf_proto_cdc_ioctl);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* NOTE : cdc->msg.len holds the desired length of the buffer to be
 	 *        returned. Only up to CDC_MAX_MSG_SIZE of this buffer area
@@ -124,7 +124,7 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	int ret;
 	struct brcmf_proto *prot = drvr->prot;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	do {
 		ret = brcmf_sdbrcm_bus_rxctl(drvr->bus,
@@ -147,8 +147,8 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0, retries = 0;
 	u32 id, flags = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
+	BRCMF_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
 
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
 	if (cmd == BRCMF_C_GET_VAR && buf) {
@@ -175,8 +175,8 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
-		DHD_ERROR(("brcmf_proto_cdc_query_ioctl: brcmf_proto_cdc_msg "
-			   "failed w/status %d\n", ret));
+		BRCMF_ERROR(("brcmf_proto_cdc_query_ioctl: brcmf_proto_cdc_msg "
+			     "failed w/status %d\n", ret));
 		goto done;
 	}
 
@@ -192,9 +192,9 @@ retry:
 	if ((id < prot->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != prot->reqid) {
-		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   brcmf_ifname(drvr, ifidx), __func__, id,
-			   prot->reqid));
+		BRCMF_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
+			     brcmf_ifname(drvr, ifidx), __func__, id,
+			     prot->reqid));
 		ret = -EINVAL;
 		goto done;
 	}
@@ -228,8 +228,8 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0;
 	u32 flags, id;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
+	BRCMF_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
 
 	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
 
@@ -254,9 +254,9 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	id = (flags & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT;
 
 	if (id != prot->reqid) {
-		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   brcmf_ifname(drvr, ifidx), __func__, id,
-			   prot->reqid));
+		BRCMF_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
+			     brcmf_ifname(drvr, ifidx), __func__, id,
+			     prot->reqid));
 		ret = -EINVAL;
 		goto done;
 	}
@@ -280,13 +280,13 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 	int ret = -1;
 
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
-		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
-			   __func__));
+		BRCMF_ERROR(("%s : bus is down. we have nothing to do\n",
+			     __func__));
 		return ret;
 	}
 	brcmf_os_proto_block(drvr);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	ASSERT(len <= BRCMF_C_IOCTL_MAXLEN);
 
@@ -294,13 +294,13 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 		goto done;
 
 	if (prot->pending == true) {
-		DHD_TRACE(("CDC packet is pending!!!! cmd=0x%x (%lu) "
-			"lastcmd=0x%x (%lu)\n",
-			ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
-			(unsigned long)prot->lastcmd));
+		BRCMF_TRACE(("CDC packet is pending!!!! cmd=0x%x (%lu) "
+			     "lastcmd=0x%x (%lu)\n",
+			     ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
+			     (unsigned long)prot->lastcmd));
 		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
 		    (ioc->cmd == BRCMF_C_GET_VAR))
-			DHD_TRACE(("iovar cmd=%s\n", (char *)buf));
+			BRCMF_TRACE(("iovar cmd=%s\n", (char *)buf));
 
 		goto done;
 	}
@@ -361,7 +361,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Push BDC header used to convey priority for buses that don't */
 
@@ -384,13 +384,13 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Pop BDC header used to convey priority for buses that don't */
 
 	if (pktbuf->len < BDC_HEADER_LEN) {
-		DHD_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
-			   pktbuf->len, BDC_HEADER_LEN));
+		BRCMF_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
+			     pktbuf->len, BDC_HEADER_LEN));
 		return -EBADE;
 	}
 
@@ -398,22 +398,22 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 
 	*ifidx = BDC_GET_IF_IDX(h);
 	if (*ifidx >= BRCMF_MAX_IFS) {
-		DHD_ERROR(("%s: rx data ifnum out of range (%d)\n",
-			   __func__, *ifidx));
+		BRCMF_ERROR(("%s: rx data ifnum out of range (%d)\n",
+			     __func__, *ifidx));
 		return -EBADE;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
-		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
-			   brcmf_ifname(drvr, *ifidx), h->flags));
+		BRCMF_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
+			     brcmf_ifname(drvr, *ifidx), h->flags));
 		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		DHD_INFO(("%s: BDC packet received with good rx-csum, "
-			"flags 0x%x\n",
-			brcmf_ifname(drvr, *ifidx), h->flags));
+		BRCMF_INFO(("%s: BDC packet received with good rx-csum, "
+			    "flags 0x%x\n",
+			    brcmf_ifname(drvr, *ifidx), h->flags));
 		PKTSETSUMGOOD(pktbuf, true);
 	}
 
@@ -430,13 +430,13 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	cdc = kzalloc(sizeof(struct brcmf_proto), GFP_ATOMIC);
 	if (!cdc) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		DHD_ERROR(("struct brcmf_proto is not correctly defined\n"));
+		BRCMF_ERROR(("struct brcmf_proto is not correctly defined\n"));
 		goto fail;
 	}
 
@@ -475,7 +475,7 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 	int ret = 0;
 	char buf[128];
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	brcmf_os_proto_block(drvr);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index aead274..12cb90d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -176,7 +176,7 @@ brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
 	int bcmerror = 0;
 	s32 int_val = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -288,8 +288,8 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
 			brcmu_pktq_pdeq_tail(q, eprec);
 		if (p == NULL) {
-			DHD_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
-				   __func__, discard_oldest));
+			BRCMF_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
+				     __func__, discard_oldest));
 			ASSERT(p);
 		}
 
@@ -299,7 +299,7 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	/* Enqueue */
 	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL) {
-		DHD_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
+		BRCMF_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
 		ASSERT(p);
 	}
 
@@ -315,7 +315,7 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 	const struct brcmu_iovar *vi = NULL;
 	u32 actionid;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	ASSERT(name);
 	ASSERT(len >= 0);
@@ -332,8 +332,8 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 		goto exit;
 	}
 
-	DHD_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		 name, (set ? "set" : "get"), len, plen));
+	BRCMF_CTL(("%s: %s %s, len %d plen %d\n", __func__,
+		   name, (set ? "set" : "get"), len, plen));
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -365,7 +365,7 @@ int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 {
 	int bcmerror = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (!buf)
 		return -EINVAL;
@@ -521,9 +521,9 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			event_name = event_names[i].event_name;
 	}
 
-	DHD_EVENT(("EVENT: %s, event ID = %d\n", event_name, event_type));
-	DHD_EVENT(("flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
-				flags, status, reason, auth_type, eabuf));
+	BRCMF_EVENT(("EVENT: %s, event ID = %d\n", event_name, event_type));
+	BRCMF_EVENT(("flags 0x%04x, status %d, reason %d, auth_type %d"
+		     " MAC %s\n", flags, status, reason, auth_type, eabuf));
 
 	if (flags & BRCMF_EVENT_MSG_LINK)
 		link = true;
@@ -536,35 +536,36 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	case BRCMF_E_START:
 	case BRCMF_E_DEAUTH:
 	case BRCMF_E_DISASSOC:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
 	case BRCMF_E_ASSOC_IND:
 	case BRCMF_E_REASSOC_IND:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
 	case BRCMF_E_ASSOC:
 	case BRCMF_E_REASSOC:
 		if (status == BRCMF_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
-				   event_name, eabuf));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
+				     event_name, eabuf));
 		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
-				   event_name, eabuf));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
+				     event_name, eabuf));
 		} else if (status == BRCMF_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
-				   event_name, eabuf, (int)reason));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, FAILURE,"
+				     " reason %d\n", event_name, eabuf,
+				     (int)reason));
 		} else {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, unexpected status "
-				"%d\n", event_name, eabuf, (int)status));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, unexpected status "
+				     "%d\n", event_name, eabuf, (int)status));
 		}
 		break;
 
 	case BRCMF_E_DEAUTH_IND:
 	case BRCMF_E_DISASSOC_IND:
-		DHD_EVENT(("MACEVENT: %s, MAC %s, reason %d\n", event_name,
-			   eabuf, (int)reason));
+		BRCMF_EVENT(("MACEVENT: %s, MAC %s, reason %d\n", event_name,
+			     eabuf, (int)reason));
 		break;
 
 	case BRCMF_E_AUTH:
@@ -578,18 +579,18 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			auth_str = err_msg;
 		}
 		if (event_type == BRCMF_E_AUTH_IND) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
-				   eabuf, auth_str));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
+				     eabuf, auth_str));
 		} else if (status == BRCMF_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
-				   event_name, eabuf, auth_str));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
+				     event_name, eabuf, auth_str));
 		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
-				   event_name, eabuf, auth_str));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
+				     event_name, eabuf, auth_str));
 		} else if (status == BRCMF_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
-				"reason %d\n",
-				event_name, eabuf, auth_str, (int)reason));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
+				     "reason %d\n",
+				     event_name, eabuf, auth_str, (int)reason));
 		}
 
 		break;
@@ -598,64 +599,64 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	case BRCMF_E_ROAM:
 	case BRCMF_E_SET_SSID:
 		if (status == BRCMF_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
-				   eabuf));
+			BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
+				     eabuf));
 		} else if (status == BRCMF_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, failed\n", event_name));
+			BRCMF_EVENT(("MACEVENT: %s, failed\n", event_name));
 		} else if (status == BRCMF_E_STATUS_NO_NETWORKS) {
-			DHD_EVENT(("MACEVENT: %s, no networks found\n",
-				   event_name));
+			BRCMF_EVENT(("MACEVENT: %s, no networks found\n",
+				     event_name));
 		} else {
-			DHD_EVENT(("MACEVENT: %s, unexpected status %d\n",
-				   event_name, (int)status));
+			BRCMF_EVENT(("MACEVENT: %s, unexpected status %d\n",
+				     event_name, (int)status));
 		}
 		break;
 
 	case BRCMF_E_BEACON_RX:
 		if (status == BRCMF_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
+			BRCMF_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
 		} else if (status == BRCMF_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, FAIL\n", event_name));
+			BRCMF_EVENT(("MACEVENT: %s, FAIL\n", event_name));
 		} else {
-			DHD_EVENT(("MACEVENT: %s, status %d\n", event_name,
-				   status));
+			BRCMF_EVENT(("MACEVENT: %s, status %d\n", event_name,
+				     status));
 		}
 		break;
 
 	case BRCMF_E_LINK:
-		DHD_EVENT(("MACEVENT: %s %s\n", event_name,
-			   link ? "UP" : "DOWN"));
+		BRCMF_EVENT(("MACEVENT: %s %s\n", event_name,
+			     link ? "UP" : "DOWN"));
 		break;
 
 	case BRCMF_E_MIC_ERROR:
-		DHD_EVENT(("MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
-			   event_name, eabuf, group, flush_txq));
+		BRCMF_EVENT(("MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
+			     event_name, eabuf, group, flush_txq));
 		break;
 
 	case BRCMF_E_ICV_ERROR:
 	case BRCMF_E_UNICAST_DECODE_ERROR:
 	case BRCMF_E_MULTICAST_DECODE_ERROR:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
 	case BRCMF_E_TXFAIL:
-		DHD_EVENT(("MACEVENT: %s, RA %s\n", event_name, eabuf));
+		BRCMF_EVENT(("MACEVENT: %s, RA %s\n", event_name, eabuf));
 		break;
 
 	case BRCMF_E_SCAN_COMPLETE:
 	case BRCMF_E_PMKID_CACHE:
-		DHD_EVENT(("MACEVENT: %s\n", event_name));
+		BRCMF_EVENT(("MACEVENT: %s\n", event_name));
 		break;
 
 	case BRCMF_E_PFN_NET_FOUND:
 	case BRCMF_E_PFN_NET_LOST:
 	case BRCMF_E_PFN_SCAN_COMPLETE:
-		DHD_EVENT(("PNOEVENT: %s\n", event_name));
+		BRCMF_EVENT(("PNOEVENT: %s\n", event_name));
 		break;
 
 	case BRCMF_E_PSK_SUP:
 	case BRCMF_E_PRUNE:
-		DHD_EVENT(("MACEVENT: %s, status %d, reason %d\n",
+		BRCMF_EVENT(("MACEVENT: %s, status %d, reason %d\n",
 			   event_name, (int)status, (int)reason));
 		break;
 
@@ -670,7 +671,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
 
 			if (hdr.version != MSGTRACE_VERSION) {
-				DHD_ERROR(
+				BRCMF_ERROR(
 				    ("\nMACEVENT: %s [unsupported version --> "
 				     "brcmf version:%d dongle version:%d]\n",
 				     event_name, MSGTRACE_VERSION, hdr.version)
@@ -686,7 +687,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 
 			if (be32_to_cpu(hdr.discarded_bytes)
 			    || be32_to_cpu(hdr.discarded_printf)) {
-				DHD_ERROR(
+				BRCMF_ERROR(
 				    ("\nWLC_E_TRACE: [Discarded traces in dongle -->"
 				     "discarded_bytes %d discarded_printf %d]\n",
 				     be32_to_cpu(hdr.discarded_bytes),
@@ -695,7 +696,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 
 			nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
 			if (nblost > 0) {
-				DHD_ERROR(
+				BRCMF_ERROR(
 				    ("\nWLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
 				     be32_to_cpu(hdr.seqnum), nblost));
 			}
@@ -719,24 +720,24 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		break;
 
 	case BRCMF_E_RSSI:
-		DHD_EVENT(("MACEVENT: %s %d\n", event_name,
-			   be32_to_cpu(*((int *)event_data))));
+		BRCMF_EVENT(("MACEVENT: %s %d\n", event_name,
+			     be32_to_cpu(*((int *)event_data))));
 		break;
 
 	default:
-		DHD_EVENT(("MACEVENT: %s %d, MAC %s, status %d, reason %d, "
-			"auth %d\n", event_name, event_type, eabuf,
-			(int)status, (int)reason, (int)auth_type));
+		BRCMF_EVENT(("MACEVENT: %s %d, MAC %s, status %d, reason %d, "
+			     "auth %d\n", event_name, event_type, eabuf,
+			     (int)status, (int)reason, (int)auth_type));
 		break;
 	}
 
 	/* show any appended data */
 	if (datalen) {
 		buf = (unsigned char *) event_data;
-		DHD_EVENT((" data (%d) : ", datalen));
+		BRCMF_EVENT((" data (%d) : ", datalen));
 		for (i = 0; i < datalen; i++)
-			DHD_EVENT((" 0x%02x ", *buf++));
-		DHD_EVENT(("\n"));
+			BRCMF_EVENT((" 0x%02x ", *buf++));
+		BRCMF_EVENT(("\n"));
 	}
 }
 #endif				/* SHOW_EVENTS */
@@ -753,14 +754,14 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 	int evlen;
 
 	if (memcmp(BRCM_OUI, &pvt_data->hdr.oui[0], DOT11_OUI_LEN)) {
-		DHD_ERROR(("%s: mismatched OUI, bailing\n", __func__));
+		BRCMF_ERROR(("%s: mismatched OUI, bailing\n", __func__));
 		return -EBADE;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
 	if (get_unaligned_be16(&pvt_data->hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
-		DHD_ERROR(("%s: mismatched subtype, bailing\n", __func__));
+		BRCMF_ERROR(("%s: mismatched subtype, bailing\n", __func__));
 		return -EBADE;
 	}
 
@@ -781,7 +782,7 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		{
 			struct brcmf_if_event *ifevent =
 					(struct brcmf_if_event *) event_data;
-			DHD_TRACE(("%s: if event\n", __func__));
+			BRCMF_TRACE(("%s: if event\n", __func__));
 
 			if (ifevent->ifidx > 0 &&
 				 ifevent->ifidx < BRCMF_MAX_IFS) {
@@ -794,9 +795,9 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 				else
 					brcmf_del_if(drvr_priv, ifevent->ifidx);
 			} else {
-				DHD_ERROR(("%s: Invalid ifidx %d for %s\n",
-					   __func__, ifevent->ifidx,
-					   event->ifname));
+				BRCMF_ERROR(("%s: Invalid ifidx %d for %s\n",
+					     __func__, ifevent->ifidx,
+					     event->ifname));
 			}
 		}
 		/* send up the if event: btamp user needs it */
@@ -813,15 +814,16 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		/* Fall through: this should get _everything_  */
 
 		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
-		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
-			   __func__, type, flags, status));
+		BRCMF_TRACE(("%s: MAC event %d, flags %x, status %x\n",
+			     __func__, type, flags, status));
 
 		/* put it back to BRCMF_E_NDIS_LINK */
 		if (type == BRCMF_E_NDIS_LINK) {
 			u32 temp;
 
 			temp = get_unaligned_be32(&event->event_type);
-			DHD_TRACE(("Converted to WLC_E_LINK type %d\n", temp));
+			BRCMF_TRACE(("Converted to WLC_E_LINK type %d\n",
+				     temp));
 
 			temp = be32_to_cpu(BRCMF_E_NDIS_LINK);
 			memcpy((void *)(&pvt_data->msg.event_type), &temp,
@@ -842,12 +844,12 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		DHD_ERROR(("Mask invalid format. Needs to start with 0x\n"));
+		BRCMF_ERROR(("Mask invalid format. Needs to start with 0x\n"));
 		return -1;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
-		DHD_ERROR(("Mask invalid format. Length must be even.\n"));
+		BRCMF_ERROR(("Mask invalid format. Length must be even.\n"));
 		return -1;
 	}
 	for (i = 0; *src != '\0'; i++) {
@@ -877,7 +879,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
 	arg_org = arg_save;
@@ -887,7 +889,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 
 	i = 0;
 	if (NULL == argv[i]) {
-		DHD_ERROR(("No args provided\n"));
+		BRCMF_ERROR(("No args provided\n"));
 		goto fail;
 	}
 
@@ -912,11 +914,11 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
+			     __func__, arg, rc));
 	else
-		DHD_TRACE(("%s: successfully added pktfilter %s\n",
-			   __func__, arg));
+		BRCMF_TRACE(("%s: successfully added pktfilter %s\n",
+			     __func__, arg));
 
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
@@ -925,8 +927,8 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 				       sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
+			     __func__, arg, rc));
 
 fail:
 	kfree(arg_org);
@@ -948,7 +950,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
 
@@ -956,15 +958,15 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	buf = kmalloc(PKTFILTER_BUF_SIZE, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
 
 	memcpy(arg_save, arg, strlen(arg) + 1);
 
 	if (strlen(arg) > PKTFILTER_BUF_SIZE) {
-		DHD_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
-			   (int)sizeof(buf)));
+		BRCMF_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
+			     (int)sizeof(buf)));
 		goto fail;
 	}
 
@@ -974,7 +976,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	i = 0;
 	if (NULL == argv[i]) {
-		DHD_ERROR(("No args provided\n"));
+		BRCMF_ERROR(("No args provided\n"));
 		goto fail;
 	}
 
@@ -990,7 +992,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	pkt_filter.id = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Polarity not provided\n"));
+		BRCMF_ERROR(("Polarity not provided\n"));
 		goto fail;
 	}
 
@@ -998,7 +1000,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	pkt_filter.negate_match = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Filter type not provided\n"));
+		BRCMF_ERROR(("Filter type not provided\n"));
 		goto fail;
 	}
 
@@ -1006,7 +1008,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	pkt_filter.type = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Offset not provided\n"));
+		BRCMF_ERROR(("Offset not provided\n"));
 		goto fail;
 	}
 
@@ -1014,7 +1016,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	pkt_filter.u.pattern.offset = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Bitmask not provided\n"));
+		BRCMF_ERROR(("Bitmask not provided\n"));
 		goto fail;
 	}
 
@@ -1024,7 +1026,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		   (argv[i], (char *)pkt_filterp->u.pattern.mask_and_pattern);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Pattern not provided\n"));
+		BRCMF_ERROR(("Pattern not provided\n"));
 		goto fail;
 	}
 
@@ -1035,7 +1037,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 				   mask_and_pattern[mask_size]);
 
 	if (mask_size != pattern_size) {
-		DHD_ERROR(("Mask and pattern not the same size\n"));
+		BRCMF_ERROR(("Mask and pattern not the same size\n"));
 		goto fail;
 	}
 
@@ -1056,11 +1058,11 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
+			     __func__, arg, rc));
 	else
-		DHD_TRACE(("%s: successfully added pktfilter %s\n",
-			   __func__, arg));
+		BRCMF_TRACE(("%s: successfully added pktfilter %s\n",
+			     __func__, arg));
 
 fail:
 	kfree(arg_org);
@@ -1078,11 +1080,11 @@ void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		DHD_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
-			"retcode = %d\n", __func__, arp_mode, retcode));
+		BRCMF_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
+			     "retcode = %d\n", __func__, arp_mode, retcode));
 	else
-		DHD_TRACE(("%s: successfully set ARP offload mode to 0x%x\n",
-			   __func__, arp_mode));
+		BRCMF_TRACE(("%s: successfully set ARP offload mode to 0x%x\n",
+			     __func__, arp_mode));
 }
 
 void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
@@ -1095,11 +1097,11 @@ void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		DHD_TRACE(("%s: failed to enabe ARP offload to %d, "
-			"retcode = %d\n", __func__, arp_enable, retcode));
+		BRCMF_TRACE(("%s: failed to enabe ARP offload to %d, "
+			     "retcode = %d\n", __func__, arp_enable, retcode));
 	else
-		DHD_TRACE(("%s: successfully enabed ARP offload to %d\n",
-			   __func__, arp_enable));
+		BRCMF_TRACE(("%s: successfully enabed ARP offload to %d\n",
+			     __func__, arp_enable));
 }
 
 int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
@@ -1123,8 +1125,8 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 		if (brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_COUNTRY,
 				     drvr->country_code,
 				     sizeof(drvr->country_code)) < 0) {
-			DHD_ERROR(("%s: country code setting failed\n",
-				   __func__));
+			BRCMF_ERROR(("%s: country code setting failed\n",
+				     __func__));
 		}
 	}
 
@@ -1135,7 +1137,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
-	DHD_ERROR(("Firmware version = %s\n", buf));
+	BRCMF_ERROR(("Firmware version = %s\n", buf));
 
 	/* Set PowerSave mode */
 	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM, (char *)&power_mode,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 2b1ccca..5be4d7a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -19,55 +19,49 @@
 
 #if defined(BCMDBG)
 
-#define DHD_ERROR(args) \
+#define BRCMF_ERROR(args) \
 	do {if ((brcmf_msg_level & BRCMF_ERROR_VAL) && (net_ratelimit())) \
 		printk args; } while (0)
-#define DHD_TRACE(args)		do {if (brcmf_msg_level & BRCMF_TRACE_VAL) \
+#define BRCMF_TRACE(args)	do {if (brcmf_msg_level & BRCMF_TRACE_VAL) \
 					printk args; } while (0)
-#define DHD_INFO(args)		do {if (brcmf_msg_level & BRCMF_INFO_VAL) \
+#define BRCMF_INFO(args)	do {if (brcmf_msg_level & BRCMF_INFO_VAL) \
 					printk args; } while (0)
-#define DHD_DATA(args)		do {if (brcmf_msg_level & BRCMF_DATA_VAL) \
+#define BRCMF_DATA(args)	do {if (brcmf_msg_level & BRCMF_DATA_VAL) \
 					printk args; } while (0)
-#define DHD_CTL(args)		do {if (brcmf_msg_level & BRCMF_CTL_VAL) \
+#define BRCMF_CTL(args)		do {if (brcmf_msg_level & BRCMF_CTL_VAL) \
 					printk args; } while (0)
-#define DHD_TIMER(args)		do {if (brcmf_msg_level & BRCMF_TIMER_VAL) \
+#define BRCMF_TIMER(args)	do {if (brcmf_msg_level & BRCMF_TIMER_VAL) \
 					printk args; } while (0)
-#define DHD_HDRS(args)		do {if (brcmf_msg_level & BRCMF_HDRS_VAL) \
+#define BRCMF_INTR(args)	do {if (brcmf_msg_level & BRCMF_INTR_VAL) \
 					printk args; } while (0)
-#define DHD_BYTES(args)		do {if (brcmf_msg_level & BRCMF_BYTES_VAL) \
+#define BRCMF_GLOM(args)	do {if (brcmf_msg_level & BRCMF_GLOM_VAL) \
 					printk args; } while (0)
-#define DHD_INTR(args)		do {if (brcmf_msg_level & BRCMF_INTR_VAL) \
-					printk args; } while (0)
-#define DHD_GLOM(args)		do {if (brcmf_msg_level & BRCMF_GLOM_VAL) \
-					printk args; } while (0)
-#define DHD_EVENT(args)		do {if (brcmf_msg_level & BRCMF_EVENT_VAL) \
+#define BRCMF_EVENT(args)	do {if (brcmf_msg_level & BRCMF_EVENT_VAL) \
 					printk args; } while (0)
 
-#define DHD_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
-#define DHD_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
-#define DHD_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
-#define DHD_BYTES_ON()		(brcmf_msg_level & BRCMF_BYTES_VAL)
-#define DHD_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
+#define BRCMF_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
+#define BRCMF_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
+#define BRCMF_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
+#define BRCMF_BYTES_ON()	(brcmf_msg_level & BRCMF_BYTES_VAL)
+#define BRCMF_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
 
 #else	/* (defined BCMDBG) || (defined BCMDBG) */
 
-#define DHD_ERROR(args)  do {if (net_ratelimit()) printk args; } while (0)
-#define DHD_TRACE(args)
-#define DHD_INFO(args)
-#define DHD_DATA(args)
-#define DHD_CTL(args)
-#define DHD_TIMER(args)
-#define DHD_HDRS(args)
-#define DHD_BYTES(args)
-#define DHD_INTR(args)
-#define DHD_GLOM(args)
-#define DHD_EVENT(args)
+#define BRCMF_ERROR(args)  do {if (net_ratelimit()) printk args; } while (0)
+#define BRCMF_TRACE(args)
+#define BRCMF_INFO(args)
+#define BRCMF_DATA(args)
+#define BRCMF_CTL(args)
+#define BRCMF_TIMER(args)
+#define BRCMF_INTR(args)
+#define BRCMF_GLOM(args)
+#define BRCMF_EVENT(args)
 
-#define DHD_DATA_ON()		0
-#define DHD_CTL_ON()		0
-#define DHD_HDRS_ON()		0
-#define DHD_BYTES_ON()		0
-#define DHD_GLOM_ON()		0
+#define BRCMF_DATA_ON()		0
+#define BRCMF_CTL_ON()		0
+#define BRCMF_HDRS_ON()		0
+#define BRCMF_BYTES_ON()		0
+#define BRCMF_GLOM_ON()		0
 
 #endif				/* defined(BCMDBG) */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 423d5da..afb1e32 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -259,7 +259,7 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 		    && !strncmp(drvr_priv->iflist[i]->name, name, IFNAMSIZ))
 			break;
 
-	DHD_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
+	BRCMF_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
 
 	return i;		/* default - the primary interface */
 }
@@ -271,12 +271,12 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 	ASSERT(drvr_priv);
 
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		DHD_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
+		BRCMF_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
 		return "<if_bad>";
 	}
 
 	if (drvr_priv->iflist[ifidx] == NULL) {
-		DHD_ERROR(("%s: null i/f %d\n", __func__, ifidx));
+		BRCMF_ERROR(("%s: null i/f %d\n", __func__, ifidx));
 		return "<if_null>";
 	}
 
@@ -309,8 +309,8 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
-		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
+		BRCMF_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
 		return;
 	}
 
@@ -337,8 +337,8 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set mcast_list failed, cnt %d\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
+		BRCMF_ERROR(("%s: set mcast_list failed, cnt %d\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -352,17 +352,18 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	buflen = sizeof("allmulti") + sizeof(allmulti);
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: out of memory for allmulti\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx)));
+		BRCMF_ERROR(("%s: out of memory for allmulti\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx)));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
 
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
-		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
-			"buflen %u\n", brcmf_ifname(&drvr_priv->pub, ifidx),
-			(int)sizeof(allmulti), buflen));
+		BRCMF_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
+			     "buflen %u\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx),
+			     (int)sizeof(allmulti), buflen));
 		kfree(buf);
 		return;
 	}
@@ -375,9 +376,9 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set allmulti %d failed\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx),
-			   le32_to_cpu(allmulti)));
+		BRCMF_ERROR(("%s: set allmulti %d failed\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx),
+			     le32_to_cpu(allmulti)));
 	}
 
 	kfree(buf);
@@ -396,9 +397,9 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set promisc %d failed\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx),
-			   le32_to_cpu(allmulti)));
+		BRCMF_ERROR(("%s: set promisc %d failed\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx),
+			     le32_to_cpu(allmulti)));
 	}
 }
 
@@ -408,11 +409,11 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 	struct brcmf_ioctl ioc;
 	int ret;
 
-	DHD_TRACE(("%s enter\n", __func__));
+	BRCMF_TRACE(("%s enter\n", __func__));
 	if (!brcmu_mkiovar
 	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
-		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx)));
+		BRCMF_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx)));
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
@@ -423,8 +424,8 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set cur_etheraddr failed\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx)));
+		BRCMF_ERROR(("%s: set cur_etheraddr failed\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx)));
 	} else {
 		memcpy(drvr_priv->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 	}
@@ -445,7 +446,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 
 	drvr_priv = ifp->info;
 
-	DHD_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
+	BRCMF_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
 
 	switch (ifp->state) {
 	case BRCMF_E_IF_ADD:
@@ -454,9 +455,9 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		 * in case we missed the BRCMF_E_IF_DEL event.
 		 */
 		if (ifp->net != NULL) {
-			DHD_ERROR(("%s: ERROR: netdev:%s already exists, "
-			"try free & unregister\n",
-			__func__, ifp->net->name));
+			BRCMF_ERROR(("%s: ERROR: netdev:%s already exists, "
+				     "try free & unregister\n",
+				     __func__, ifp->net->name));
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			free_netdev(ifp->net);
@@ -464,7 +465,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		/* Allocate etherdev, including space for private structure */
 		ifp->net = alloc_etherdev(sizeof(drvr_priv));
 		if (!ifp->net) {
-			DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+			BRCMF_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
@@ -472,9 +473,9 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			memcpy(netdev_priv(ifp->net), &drvr_priv, sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
-				DHD_ERROR(("%s: brcmf_net_attach failed, "
-					"err %d\n",
-					__func__, err));
+				BRCMF_ERROR(("%s: brcmf_net_attach failed, "
+					     "err %d\n",
+					     __func__, err));
 				ret = -EOPNOTSUPP;
 			} else {
 #ifdef SOFTAP
@@ -489,17 +490,17 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 					 wl0.1 is ready */
 				up(&ap_eth_sema);
 #endif
-				DHD_TRACE(("\n ==== pid:%x, net_device for "
-					"if:%s created ===\n\n",
-					current->pid, ifp->net->name));
+				BRCMF_TRACE(("\n ==== pid:%x, net_device for "
+					     "if:%s created ===\n\n",
+					     current->pid, ifp->net->name));
 				ifp->state = 0;
 			}
 		}
 		break;
 	case BRCMF_E_IF_DEL:
 		if (ifp->net != NULL) {
-			DHD_TRACE(("\n%s: got 'WLC_E_IF_DEL' state\n",
-				   __func__));
+			BRCMF_TRACE(("\n%s: got 'WLC_E_IF_DEL' state\n",
+				     __func__));
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			ret = BRCMF_DEL_IF;	/* Make sure the free_netdev()
@@ -507,7 +508,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		}
 		break;
 	default:
-		DHD_ERROR(("%s: bad op %d\n", __func__, ifp->state));
+		BRCMF_ERROR(("%s: bad op %d\n", __func__, ifp->state));
 		ASSERT(!ifp->state);
 		break;
 	}
@@ -540,32 +541,35 @@ static int _brcmf_sysioc_thread(void *data)
 		if (kthread_should_stop())
 			break;
 		for (i = 0; i < BRCMF_MAX_IFS; i++) {
-			if (drvr_priv->iflist[i]) {
+			struct brcmf_if *ifentry = drvr_priv->iflist[i];
+			if (ifentry) {
 #ifdef SOFTAP
 				in_ap = (ap_net_dev != NULL);
 #endif				/* SOFTAP */
-				if (drvr_priv->iflist[i]->state)
-					brcmf_op_if(drvr_priv->iflist[i]);
+				if (ifentry->state)
+					brcmf_op_if(ifentry);
 #ifdef SOFTAP
 				if (drvr_priv->iflist[i] == NULL) {
-					DHD_TRACE(("\n\n %s: interface %d "
-						"removed!\n", __func__, i));
+					BRCMF_TRACE(("\n\n %s: interface %d "
+						     "removed!\n", __func__,
+						     i));
 					continue;
 				}
 
 				if (in_ap && drvr_priv->set_macaddress) {
-					DHD_TRACE(("attempt to set MAC for %s "
-						"in AP Mode," "blocked.\n",
-						drvr_priv->iflist[i]->net->name));
+					BRCMF_TRACE(("attempt to set MAC for"
+						     " %s in AP Mode,"
+						     " blocked.\n",
+						     ifentry->net->name));
 					drvr_priv->set_macaddress = false;
 					continue;
 				}
 
 				if (in_ap && drvr_priv->set_multicast) {
-					DHD_TRACE(("attempt to set MULTICAST "
-						   "list for %s in AP Mode, "
-						   "blocked.\n",
-						   drvr_priv->iflist[i]->net->name));
+					BRCMF_TRACE(("attempt to set MULTICAST "
+						     "list for %s in AP Mode, "
+						     "blocked.\n",
+						     ifentry->net->name));
 					drvr_priv->set_multicast = false;
 					continue;
 				}
@@ -577,7 +581,7 @@ static int _brcmf_sysioc_thread(void *data)
 				if (drvr_priv->set_macaddress) {
 					drvr_priv->set_macaddress = false;
 					_brcmf_set_mac_address(drvr_priv, i,
-							     drvr_priv->macvalue);
+						drvr_priv->macvalue);
 				}
 			}
 		}
@@ -651,19 +655,20 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	int ifidx;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Reject if down */
 	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == BRCMF_BUS_DOWN)) {
-		DHD_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
-			   __func__, drvr_priv->pub.up, drvr_priv->pub.busstate));
+		BRCMF_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
+			     __func__, drvr_priv->pub.up,
+			     drvr_priv->pub.busstate));
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == BRCMF_BAD_IF) {
-		DHD_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
+		BRCMF_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
@@ -672,15 +677,15 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	if (skb_headroom(skb) < drvr_priv->pub.hdrlen) {
 		struct sk_buff *skb2;
 
-		DHD_INFO(("%s: insufficient headroom\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx)));
+		BRCMF_INFO(("%s: insufficient headroom\n",
+			    brcmf_ifname(&drvr_priv->pub, ifidx)));
 		drvr_priv->pub.tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr_priv->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			DHD_ERROR(("%s: skb_realloc_headroom failed\n",
-				   brcmf_ifname(&drvr_priv->pub, ifidx)));
+			BRCMF_ERROR(("%s: skb_realloc_headroom failed\n",
+				     brcmf_ifname(&drvr_priv->pub, ifidx)));
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -703,7 +708,7 @@ void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 	struct net_device *net;
 	struct brcmf_info *drvr_priv = drvr->info;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	drvr->txoff = state;
 	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
@@ -726,7 +731,7 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 	struct brcmf_if *ifp;
 	struct brcmf_event_msg event;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	save_pktbuf = skb;
 
@@ -821,7 +826,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	struct brcmf_if *ifp;
 	int ifidx;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == BRCMF_BAD_IF)
@@ -869,13 +874,13 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
-			DHD_ERROR(("%s: toe not supported by device\n",
-				   brcmf_ifname(&drvr_priv->pub, ifidx)));
+			BRCMF_ERROR(("%s: toe not supported by device\n",
+				     brcmf_ifname(&drvr_priv->pub, ifidx)));
 			return -EOPNOTSUPP;
 		}
 
-		DHD_INFO(("%s: could not get toe_ol: ret=%d\n",
-			  brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		BRCMF_INFO(("%s: could not get toe_ol: ret=%d\n",
+			    brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -905,8 +910,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: could not set toe_ol: ret=%d\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		BRCMF_ERROR(("%s: could not set toe_ol: ret=%d\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -919,8 +924,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: could not set toe: ret=%d\n",
-			   brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		BRCMF_ERROR(("%s: could not set toe: ret=%d\n",
+			     brcmf_ifname(&drvr_priv->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -952,7 +957,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 	u32 toe_cmpnt, csum_dir;
 	int ret;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* all ethtool calls start with a cmd word */
 	if (copy_from_user(&cmd, uaddr, sizeof(u32)))
@@ -978,7 +983,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 
 		/* otherwise, require dongle to be up */
 		else if (!drvr_priv->pub.up) {
-			DHD_ERROR(("%s: dongle is not up\n", __func__));
+			BRCMF_ERROR(("%s: dongle is not up\n", __func__));
 			return -ENODEV;
 		}
 
@@ -991,8 +996,8 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 		sprintf(info.version, "%lu", drvr_priv->pub.drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
-		DHD_CTL(("%s: given %*s, returning %s\n", __func__,
-			 (int)sizeof(drvname), drvname, info.driver));
+		BRCMF_CTL(("%s: given %*s, returning %s\n", __func__,
+			   (int)sizeof(drvname), drvname, info.driver));
 		break;
 
 		/* Get toe offload components from dongle */
@@ -1067,7 +1072,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	bool is_set_key_cmd;
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
-	DHD_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
+	BRCMF_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
 
 	if (ifidx == BRCMF_BAD_IF)
 		return -1;
@@ -1130,7 +1135,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
-		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
+		BRCMF_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
 		bcmerror = -EIO;
 		goto done;
 	}
@@ -1175,7 +1180,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 #if !defined(IGNORE_ETH0_DOWN)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 	brcmf_cfg80211_down();
 	if (drvr_priv->pub.up == 0)
 		return 0;
@@ -1184,8 +1189,8 @@ static int brcmf_netdev_stop(struct net_device *net)
 	drvr_priv->pub.up = 0;
 	netif_stop_queue(net);
 #else
-	DHD_ERROR(("BYPASS %s:due to BRCM compilation : under investigation\n",
-		__func__));
+	BRCMF_ERROR(("BYPASS %s:due to BRCM compilation: under investigation\n",
+		     __func__));
 #endif				/* !defined(IGNORE_ETH0_DOWN) */
 
 	return 0;
@@ -1198,14 +1203,15 @@ static int brcmf_netdev_open(struct net_device *net)
 	int ifidx = brcmf_net2idx(drvr_priv, net);
 	s32 ret = 0;
 
-	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	BRCMF_TRACE(("%s: ifidx %d\n", __func__, ifidx));
 
 	if (ifidx == 0) {	/* do it only for primary eth0 */
 
 		/* try to bring up bus */
 		ret = brcmf_bus_start(&drvr_priv->pub);
 		if (ret != 0) {
-			DHD_ERROR(("%s: failed with code %d\n", __func__, ret));
+			BRCMF_ERROR(("%s: failed with code %d\n",
+				     __func__, ret));
 			return -1;
 		}
 		atomic_set(&drvr_priv->pend_8021x_cnt, 0);
@@ -1215,16 +1221,18 @@ static int brcmf_netdev_open(struct net_device *net)
 		/* Get current TOE mode from dongle */
 		if (brcmf_toe_get(drvr_priv, ifidx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-			drvr_priv->iflist[ifidx]->net->features |= NETIF_F_IP_CSUM;
+			drvr_priv->iflist[ifidx]->net->features |=
+				NETIF_F_IP_CSUM;
 		else
-			drvr_priv->iflist[ifidx]->net->features &= ~NETIF_F_IP_CSUM;
+			drvr_priv->iflist[ifidx]->net->features &=
+				~NETIF_F_IP_CSUM;
 	}
 	/* Allow transmit calls */
 	netif_start_queue(net);
 	drvr_priv->pub.up = 1;
 	if (unlikely(brcmf_cfg80211_up())) {
-		DHD_ERROR(("%s: failed to bring up cfg80211\n",
-			   __func__));
+		BRCMF_ERROR(("%s: failed to bring up cfg80211\n",
+			     __func__));
 		return -1;
 	}
 
@@ -1237,7 +1245,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 {
 	struct brcmf_if *ifp;
 
-	DHD_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
+	BRCMF_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
 
 	ASSERT(drvr_priv && (ifidx < BRCMF_MAX_IFS));
 
@@ -1245,7 +1253,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
 		if (!ifp) {
-			DHD_ERROR(("%s: OOM - struct brcmf_if\n", __func__));
+			BRCMF_ERROR(("%s: OOM - struct brcmf_if\n", __func__));
 			return -ENOMEM;
 		}
 	}
@@ -1272,12 +1280,12 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 {
 	struct brcmf_if *ifp;
 
-	DHD_TRACE(("%s: idx %d\n", __func__, ifidx));
+	BRCMF_TRACE(("%s: idx %d\n", __func__, ifidx));
 
 	ASSERT(drvr_priv && ifidx && (ifidx < BRCMF_MAX_IFS));
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
-		DHD_ERROR(("%s: Null interface\n", __func__));
+		BRCMF_ERROR(("%s: Null interface\n", __func__));
 		return;
 	}
 
@@ -1292,19 +1300,19 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	struct brcmf_info *drvr_priv = NULL;
 	struct net_device *net;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Allocate etherdev, including space for private structure */
 	net = alloc_etherdev(sizeof(drvr_priv));
 	if (!net) {
-		DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+		BRCMF_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
 		goto fail;
 	}
 
 	/* Allocate primary brcmf_info */
 	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
 	if (!drvr_priv) {
-		DHD_ERROR(("%s: OOM - alloc brcmf_info\n", __func__));
+		BRCMF_ERROR(("%s: OOM - alloc brcmf_info\n", __func__));
 		goto fail;
 	}
 
@@ -1343,13 +1351,13 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	/* Attach and link in the protocol */
 	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
-		DHD_ERROR(("brcmf_proto_attach failed\n"));
+		BRCMF_ERROR(("brcmf_prot_attach failed\n"));
 		goto fail;
 	}
 
 	/* Attach and link in the cfg80211 */
 	if (unlikely(brcmf_cfg80211_attach(net, &drvr_priv->pub))) {
-		DHD_ERROR(("wl_cfg80211_attach failed\n"));
+		BRCMF_ERROR(("wl_cfg80211_attach failed\n"));
 		goto fail;
 	}
 
@@ -1393,19 +1401,19 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 
 	ASSERT(drvr_priv);
 
-	DHD_TRACE(("%s:\n", __func__));
+	BRCMF_TRACE(("%s:\n", __func__));
 
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub, true);
 	if (ret != 0) {
-		DHD_ERROR(("%s, brcmf_sdbrcm_bus_init failed %d\n", __func__,
-			   ret));
+		BRCMF_ERROR(("%s, brcmf_sdbrcm_bus_init failed %d\n", __func__,
+			     ret));
 		return ret;
 	}
 
 	/* If bus is not ready, can't come up */
 	if (drvr_priv->pub.busstate != BRCMF_BUS_DATA) {
-		DHD_ERROR(("%s failed bus is not ready\n", __func__));
+		BRCMF_ERROR(("%s failed bus is not ready\n", __func__));
 		return -ENODEV;
 	}
 
@@ -1465,7 +1473,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
-	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	BRCMF_TRACE(("%s: ifidx %d\n", __func__, ifidx));
 
 	ASSERT(drvr_priv && drvr_priv->iflist[ifidx]);
 
@@ -1485,7 +1493,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	}
 
 	if (ifidx == 1) {
-		DHD_TRACE(("%s ACCESS POINT MAC:\n", __func__));
+		BRCMF_TRACE(("%s ACCESS POINT MAC:\n", __func__));
 		/*  ACCESSPOINT INTERFACE CASE */
 		temp_addr[0] |= 0X02;	/* set bit 2 ,
 			 - Locally Administered address  */
@@ -1500,12 +1508,12 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
 
 	if (register_netdev(net) != 0) {
-		DHD_ERROR(("%s: couldn't register the net device\n",
-			__func__));
+		BRCMF_ERROR(("%s: couldn't register the net device\n",
+			     __func__));
 		goto fail;
 	}
 
-	DHD_INFO(("%s: Broadcom Dongle Host Driver\n", net->name));
+	BRCMF_INFO(("%s: Broadcom Dongle Host Driver\n", net->name));
 
 	return 0;
 
@@ -1518,7 +1526,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (drvr) {
 		drvr_priv = drvr->info;
@@ -1536,7 +1544,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (drvr) {
 		drvr_priv = drvr->info;
@@ -1577,7 +1585,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 
 static void __exit brcmf_module_cleanup(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	brcmf_bus_unregister();
 }
@@ -1586,12 +1594,12 @@ static int __init brcmf_module_init(void)
 {
 	int error;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	error = brcmf_bus_register();
 
 	if (error) {
-		DHD_ERROR(("%s: brcmf_bus_register failed\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_bus_register failed\n", __func__));
 		goto failed;
 	}
 	return 0;
@@ -1742,7 +1750,7 @@ int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size)
 	/* open file to write */
 	fp = filp_open("/tmp/mem_dump", O_WRONLY | O_CREAT, 0640);
 	if (!fp) {
-		DHD_ERROR(("%s: open file error\n", __func__));
+		BRCMF_ERROR(("%s: open file error\n", __func__));
 		ret = -1;
 		goto exit;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4c801e7..2ed770d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -805,7 +805,7 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit) {
-			DHD_ERROR(("FAILED READ %Xh\n", reg_offset));
+			BRCMF_ERROR(("FAILED READ %Xh\n", reg_offset));
 			*regvar = 0;
 		}
 	}
@@ -823,7 +823,8 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit)
-			DHD_ERROR(("FAILED REGISTER WRITE %Xh\n", reg_offset));
+			BRCMF_ERROR(("FAILED REGISTER WRITE"
+				     " %Xh\n", reg_offset));
 	}
 }
 
@@ -907,8 +908,8 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 {
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
-	DHD_ERROR(("user: Restrict the dongle ram size to %d, min %d\n",
-		brcmf_dongle_memsize, min_size));
+	BRCMF_ERROR(("user: Restrict the dongle ram size to %d, min %d\n",
+		     brcmf_dongle_memsize, min_size));
 	if ((brcmf_dongle_memsize > min_size) &&
 	    (brcmf_dongle_memsize < (s32) bus->orig_ramsize))
 		bus->ramsize = brcmf_dongle_memsize;
@@ -938,7 +939,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 	u8 clkctl, clkreq, devctl;
 	struct brcmf_sdio_card *card;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	clkctl = 0;
 	card = bus->card;
@@ -955,8 +956,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
-			DHD_ERROR(("%s: HT Avail request error: %d\n",
-				   __func__, err));
+			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
+				     __func__, err));
 			return -EBADE;
 		}
 
@@ -972,8 +973,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			DHD_ERROR(("%s: HT Avail read error: %d\n",
-				   __func__, err));
+			BRCMF_ERROR(("%s: HT Avail read error: %d\n",
+				     __func__, err));
 			return -EBADE;
 		}
 
@@ -983,15 +984,15 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
-					__func__, err));
+				BRCMF_ERROR(("%s: Devctl error setting CA:"
+					     " %d\n", __func__, err));
 				return -EBADE;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, devctl, &err);
-			DHD_INFO(("CLKCTL: set PENDING\n"));
+			BRCMF_INFO(("CLKCTL: set PENDING\n"));
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
@@ -1016,25 +1017,26 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			       PMU_MAX_TRANSITION_DLY);
 		}
 		if (err) {
-			DHD_ERROR(("%s: HT Avail request error: %d\n",
-				   __func__, err));
+			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
+				     __func__, err));
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			DHD_ERROR(("%s: HT Avail timeout (%d): clkctl 0x%02x\n",
-				   __func__, PMU_MAX_TRANSITION_DLY, clkctl));
+			BRCMF_ERROR(("%s: HT Avail timeout (%d): "
+				     "clkctl 0x%02x\n", __func__,
+				     PMU_MAX_TRANSITION_DLY, clkctl));
 			return -EBADE;
 		}
 
 		/* Mark clock available */
 		bus->clkstate = CLK_AVAIL;
-		DHD_INFO(("CLKCTL: turned ON\n"));
+		BRCMF_INFO(("CLKCTL: turned ON\n"));
 
 #if defined(BCMDBG)
 		if (bus->alp_only != true) {
 			if (SBSDIO_ALPONLY(clkctl)) {
-				DHD_ERROR(("%s: HT Clock should be on.\n",
-					   __func__));
+				BRCMF_ERROR(("%s: HT Clock should be on.\n",
+					     __func__));
 			}
 		}
 #endif				/* defined (BCMDBG) */
@@ -1055,10 +1057,10 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		bus->clkstate = CLK_SDONLY;
 		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
-		DHD_INFO(("CLKCTL: turned OFF\n"));
+		BRCMF_INFO(("CLKCTL: turned OFF\n"));
 		if (err) {
-			DHD_ERROR(("%s: Failed access turning clock off: %d\n",
-				   __func__, err));
+			BRCMF_ERROR(("%s: Failed access turning clock off:"
+				     " %d\n", __func__, err));
 			return -EBADE;
 		}
 	}
@@ -1068,7 +1070,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 /* Change idle/active SD state */
 static int brcmf_sdbrcm_sdclk(struct brcmf_bus *bus, bool on)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (on)
 		bus->clkstate = CLK_SDONLY;
@@ -1085,7 +1087,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 	uint oldstate = bus->clkstate;
 #endif				/* BCMDBG */
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
@@ -1114,8 +1116,8 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 		else if (bus->clkstate == CLK_AVAIL)
 			brcmf_sdbrcm_htclk(bus, false, false);
 		else
-			DHD_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
-				   "\n", bus->clkstate, target));
+			BRCMF_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
+				     "\n", bus->clkstate, target));
 		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 		break;
 
@@ -1129,7 +1131,8 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 		break;
 	}
 #ifdef BCMDBG
-	DHD_INFO(("brcmf_sdbrcm_clkctl: %d -> %d\n", oldstate, bus->clkstate));
+	BRCMF_INFO(("brcmf_sdbrcm_clkctl: %d -> %d\n",
+		    oldstate, bus->clkstate));
 #endif				/* BCMDBG */
 
 	return 0;
@@ -1140,9 +1143,9 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 	struct brcmf_sdio_card *card = bus->card;
 	uint retries = 0;
 
-	DHD_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
-		  (sleep ? "SLEEP" : "WAKE"),
-		  (bus->sleeping ? "SLEEP" : "WAKE")));
+	BRCMF_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
+		    (sleep ? "SLEEP" : "WAKE"),
+		    (bus->sleeping ? "SLEEP" : "WAKE")));
 
 	/* Done if we're already in the requested state */
 	if (sleep == bus->sleeping)
@@ -1164,7 +1167,8 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		w_sdreg32(bus, SMB_USE_OOB,
 			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
+			BRCMF_ERROR(("CANNOT SIGNAL CHIP, "
+				     "WILL NOT WAKE UP!!\n"));
 
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1209,7 +1213,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 				  &retries);
 
 		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
+			BRCMF_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
 
 		/* Make sure we have SD bus access */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1247,7 +1251,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 	struct sk_buff *new;
 	int i;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	card = bus->card;
 
@@ -1262,14 +1266,14 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 	pad = ((unsigned long)frame % BRCMF_SDALIGN);
 	if (pad) {
 		if (skb_headroom(pkt) < pad) {
-			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
-				  __func__, skb_headroom(pkt), pad));
+			BRCMF_INFO(("%s: insufficient headroom %d for %d pad\n",
+				    __func__, skb_headroom(pkt), pad));
 			bus->drvr->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
-				DHD_ERROR(("%s: couldn't allocate new %d-byte "
-					"packet\n",
-					__func__, pkt->len + BRCMF_SDALIGN));
+				BRCMF_ERROR(("%s: couldn't allocate new "
+					     "%d-byte packet\n", __func__,
+					     pkt->len + BRCMF_SDALIGN));
 				ret = -ENOMEM;
 				goto done;
 			}
@@ -1310,12 +1314,12 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 
 #ifdef BCMDBG
 	tx_packets[pkt->priority]++;
-	if (DHD_BYTES_ON() &&
-	    (((DHD_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
-	      (DHD_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
+	if (BRCMF_BYTES_ON() &&
+	    (((BRCMF_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
+	      (BRCMF_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
 		printk(KERN_DEBUG "Tx Frame:\n");
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, frame, len);
-	} else if (DHD_HDRS_ON()) {
+	} else if (BRCMF_HDRS_ON()) {
 		printk(KERN_DEBUG "TxHdr:\n");
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 				     frame, min_t(u16, len, 16));
@@ -1345,8 +1349,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 		if (ret < 0) {
 			/* On failure, abort the command
 			 and terminate the frame */
-			DHD_INFO(("%s: sdio error %d, abort command and "
-				"terminate frame.\n", __func__, ret));
+			BRCMF_INFO(("%s: sdio error %d, abort command and "
+				    "terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
 			brcmf_sdcard_abort(card, SDIO_FUNC_2);
@@ -1392,7 +1396,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	int ret = -EBADE;
 	uint datalen, prec;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	datalen = pkt->len;
 
@@ -1422,8 +1426,8 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	    || bus->dpc_sched || (!DATAOK(bus))
 	    || (bus->flowcontrol & NBITVAL(prec))
 	    || (bus->clkstate != CLK_AVAIL)) {
-		DHD_TRACE(("%s: deferring pktq len %d\n", __func__,
-			   pktq_len(&bus->txq)));
+		BRCMF_TRACE(("%s: deferring pktq len %d\n", __func__,
+			     pktq_len(&bus->txq)));
 		bus->fcqueued++;
 
 		/* Priority based enq */
@@ -1432,7 +1436,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 			skb_pull(pkt, SDPCM_HDRLEN);
 			brcmf_txcomplete(bus->drvr, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
-			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
+			BRCMF_ERROR(("%s: out of bus->txq !!!\n", __func__));
 			ret = -ENOSR;
 		} else {
 			ret = 0;
@@ -1461,7 +1465,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
 #ifndef SDTEST
-		DHD_TRACE(("%s: calling txpkt\n", __func__));
+		BRCMF_TRACE(("%s: calling txpkt\n", __func__));
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 #else
 		ret = brcmf_sdbrcm_txpkt(bus, pkt,
@@ -1497,7 +1501,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 
 	struct brcmf_pub *drvr = bus->drvr;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	tx_prec_map = ~bus->flowcontrol;
 
@@ -1558,7 +1562,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	int ret = -1;
 	int i;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus->drvr->dongle_reset)
 		return -EIO;
@@ -1617,8 +1621,9 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
 	if (!DATAOK(bus)) {
-		DHD_INFO(("%s: No bus credit bus->tx_max %d, bus->tx_seq %d\n",
-			  __func__, bus->tx_max, bus->tx_seq));
+		BRCMF_INFO(("%s: No bus credit bus->tx_max %d,"
+			    " bus->tx_seq %d\n", __func__,
+			    bus->tx_max, bus->tx_seq));
 		bus->ctrl_frame_stat = true;
 		/* Send from dpc */
 		bus->ctrl_frame_buf = frame;
@@ -1627,21 +1632,22 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
-			DHD_INFO(("%s: ctrl_frame_stat == false\n", __func__));
+			BRCMF_INFO(("%s: ctrl_frame_stat == false\n",
+				    __func__));
 			ret = 0;
 		} else {
-			DHD_INFO(("%s: ctrl_frame_stat == true\n", __func__));
+			BRCMF_INFO(("%s: ctrl_frame_stat == true\n", __func__));
 			ret = -1;
 		}
 	}
 
 	if (ret == -1) {
 #ifdef BCMDBG
-		if (DHD_BYTES_ON() && DHD_CTL_ON()) {
+		if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
 			printk(KERN_DEBUG "Tx Frame:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 					     frame, len);
-		} else if (DHD_HDRS_ON()) {
+		} else if (BRCMF_HDRS_ON()) {
 			printk(KERN_DEBUG "TxHdr:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 					     frame, min_t(u16, len, 16));
@@ -1659,8 +1665,9 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			if (ret < 0) {
 				/* On failure, abort the command and
 				 terminate the frame */
-				DHD_INFO(("%s: sdio error %d, abort command and terminate frame.\n",
-					__func__, ret));
+				BRCMF_INFO(("%s: sdio error %d, abort command "
+					    "and terminate frame.\n",
+					    __func__, ret));
 				bus->tx_sderrs++;
 
 				brcmf_sdcard_abort(card, SDIO_FUNC_2);
@@ -1714,7 +1721,7 @@ int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msgle
 	uint rxlen = 0;
 	bool pending;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus->drvr->dongle_reset)
 		return -EIO;
@@ -1729,20 +1736,20 @@ int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msgle
 	brcmf_sdbrcm_sdunlock(bus);
 
 	if (rxlen) {
-		DHD_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
-			 __func__, rxlen, msglen));
+		BRCMF_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
+			   __func__, rxlen, msglen));
 	} else if (timeleft == 0) {
-		DHD_ERROR(("%s: resumed on timeout\n", __func__));
+		BRCMF_ERROR(("%s: resumed on timeout\n", __func__));
 #ifdef BCMDBG
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_sdbrcm_sdunlock(bus);
 #endif				/* BCMDBG */
 	} else if (pending == true) {
-		DHD_CTL(("%s: cancelled\n", __func__));
+		BRCMF_CTL(("%s: cancelled\n", __func__));
 		return -ERESTARTSYS;
 	} else {
-		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
+		BRCMF_CTL(("%s: resumed for unknown reason?\n", __func__));
 #ifdef BCMDBG
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
@@ -2049,19 +2056,20 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 	/* Set the backplane window to include the start address */
 	bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 	if (bcmerror) {
-		DHD_ERROR(("%s: window change failed\n", __func__));
+		BRCMF_ERROR(("%s: window change failed\n", __func__));
 		goto xfer_done;
 	}
 
 	/* Do the transfer(s) */
 	while (size) {
-		DHD_INFO(("%s: %s %d bytes at offset 0x%08x in window 0x%08x\n",
-			  __func__, (write ? "write" : "read"), dsize,
-			  sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
+		BRCMF_INFO(("%s: %s %d bytes at offset 0x%08x in window"
+			    " 0x%08x\n", __func__, (write ? "write" : "read"),
+			    dsize, sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
 		bcmerror =
 		     brcmf_sdcard_rwdata(bus->card, write, sdaddr, data, dsize);
 		if (bcmerror) {
-			DHD_ERROR(("%s: membytes transfer failed\n", __func__));
+			BRCMF_ERROR(("%s: membytes transfer failed\n",
+				     __func__));
 			break;
 		}
 
@@ -2072,8 +2080,8 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 			address += dsize;
 			bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 			if (bcmerror) {
-				DHD_ERROR(("%s: window change failed\n",
-					   __func__));
+				BRCMF_ERROR(("%s: window change failed\n",
+					     __func__));
 				break;
 			}
 			sdaddr = 0;
@@ -2085,8 +2093,8 @@ xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus,
 					   brcmf_sdcard_cur_sbwad(bus->card))) {
-		DHD_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			   __func__, brcmf_sdcard_cur_sbwad(bus->card)));
+		BRCMF_ERROR(("%s: FAILED to set window back to 0x%x\n",
+			     __func__, brcmf_sdcard_cur_sbwad(bus->card)));
 	}
 
 	return bcmerror;
@@ -2107,15 +2115,15 @@ static int brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *s
 
 	addr = le32_to_cpu(addr);
 
-	DHD_INFO(("sdpcm_shared address 0x%08X\n", addr));
+	BRCMF_INFO(("sdpcm_shared address 0x%08X\n", addr));
 
 	/*
 	 * Check if addr is valid.
 	 * NVRAM length at the end of memory should have been overwritten.
 	 */
 	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
-		DHD_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
-			   __func__, addr));
+		BRCMF_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
+			     __func__, addr));
 		return -EBADE;
 	}
 
@@ -2135,10 +2143,10 @@ static int brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *s
 	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		DHD_ERROR(("%s: sdpcm_shared version %d in brcmf "
-			   "is different than sdpcm_shared version %d in dongle\n",
-			   __func__, SDPCM_SHARED_VERSION,
-			   sh->flags & SDPCM_SHARED_VERSION_MASK));
+		BRCMF_ERROR(("%s: sdpcm_shared version %d in brcmf "
+			     "is different than sdpcm_shared version %d in dongle\n",
+			     __func__, SDPCM_SHARED_VERSION,
+			     sh->flags & SDPCM_SHARED_VERSION_MASK));
 		return -EBADE;
 	}
 
@@ -2156,7 +2164,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 	struct sdpcm_shared sdpcm_shared;
 	struct brcmu_strbuf strbuf;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (data == NULL) {
 		/*
@@ -2166,8 +2174,8 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 		size = msize;
 		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
 		if (mbuffer == NULL) {
-			DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__,
-				   msize));
+			BRCMF_ERROR(("%s: kmalloc(%d) failed\n", __func__,
+				     msize));
 			bcmerror = -ENOMEM;
 			goto done;
 		}
@@ -2175,7 +2183,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
-		DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
+		BRCMF_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
 		bcmerror = -ENOMEM;
 		goto done;
 	}
@@ -2258,7 +2266,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 	}
 
 	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
-		DHD_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
+		BRCMF_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
 
 #ifdef BCMDBG
 	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
@@ -2286,7 +2294,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 	size = bus->ramsize;
 	buf = kmalloc(size, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: Out of memory (%d bytes)\n", __func__, size));
+		BRCMF_ERROR(("%s: Out of memory (%d bytes)\n", __func__, size));
 		return -1;
 	}
 
@@ -2298,7 +2306,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
 					  read_size);
 		if (ret) {
-			DHD_ERROR(("%s: Error membytes %d\n", __func__, ret));
+			BRCMF_ERROR(("%s: Error membytes %d\n", __func__, ret));
 			kfree(buf);
 			return -1;
 		}
@@ -2313,7 +2321,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 
 	/* free buf before return !!! */
 	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
-		DHD_ERROR(("%s: Error writing to files\n", __func__));
+		BRCMF_ERROR(("%s: Error writing to files\n", __func__));
 		return -1;
 	}
 
@@ -2404,7 +2412,7 @@ int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Basic sanity checks */
 	if (bus->drvr->up) {
@@ -2442,9 +2450,9 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 	s32 int_val = 0;
 	bool bool_val = 0;
 
-	DHD_TRACE(("%s: Enter, action %d name %s params %p plen %d arg %p "
-		"len %d val_size %d\n",
-		__func__, actionid, name, params, plen, arg, len, val_size));
+	BRCMF_TRACE(("%s: Enter, action %d name %s params %p plen %d arg %p "
+		     "len %d val_size %d\n", __func__, actionid, name, params,
+		     plen, arg, len, val_size));
 
 	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -2492,13 +2500,11 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 		bus->intr = bool_val;
 		bus->intdis = false;
 		if (bus->drvr->up) {
+			BRCMF_INTR(("%s: %s SDIO interrupts\n", __func__,
+				    bus->intr ? "enable" : "disable"));
 			if (bus->intr) {
-				DHD_INTR(("%s: enable SDIO device interrupts\n",
-					  __func__));
 				brcmf_sdcard_intr_enable(bus->card);
 			} else {
-				DHD_INTR(("%s: disable SDIO interrupts\n",
-					  __func__));
 				brcmf_sdcard_intr_disable(bus->card);
 			}
 		}
@@ -2563,25 +2569,25 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 			/* Do some validation */
 			dsize = set ? plen - (2 * sizeof(int)) : len;
 			if (dsize < size) {
-				DHD_ERROR(("%s: error on %s membytes, addr "
-				"0x%08x size %d dsize %d\n",
-				__func__, (set ? "set" : "get"),
-				address, size, dsize));
+				BRCMF_ERROR(("%s: error on %s membytes, addr "
+					     "0x%08x size %d dsize %d\n",
+					     __func__, (set ? "set" : "get"),
+					     address, size, dsize));
 				bcmerror = -EINVAL;
 				break;
 			}
 
-			DHD_INFO(("%s: Request to %s %d bytes at address "
-			"0x%08x\n",
-			__func__, (set ? "write" : "read"), size, address));
+			BRCMF_INFO(("%s: Request to %s %d bytes at address "
+				    "0x%08x\n", __func__,
+				    (set ? "write" : "read"), size, address));
 
 			/* If we know about SOCRAM, check for a fit */
 			if ((bus->orig_ramsize) &&
 			    ((address > bus->orig_ramsize)
 			     || (address + size > bus->orig_ramsize))) {
-				DHD_ERROR(("%s: ramsize 0x%08x doesn't have %d "
-				"bytes at 0x%08x\n",
-				__func__, bus->orig_ramsize, size, address));
+				BRCMF_ERROR(("%s: ramsize 0x%08x doesn't have"
+					     " %d bytes at 0x%08x\n", __func__,
+					     bus->orig_ramsize, size, address));
 				bcmerror = -EINVAL;
 				break;
 			}
@@ -2827,17 +2833,17 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 #endif				/* SDTEST */
 
 	case IOV_SVAL(IOV_DEVRESET):
-		DHD_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
-			"busstate=%d\n",
-			__func__, bool_val, bus->drvr->dongle_reset,
-			bus->drvr->busstate));
+		BRCMF_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
+			     "busstate=%d\n",
+			     __func__, bool_val, bus->drvr->dongle_reset,
+			     bus->drvr->busstate));
 
 		brcmf_bus_devreset(bus->drvr, (u8) bool_val);
 
 		break;
 
 	case IOV_GVAL(IOV_DEVRESET):
-		DHD_TRACE(("%s: Called get IOV_DEVRESET\n", __func__));
+		BRCMF_TRACE(("%s: Called get IOV_DEVRESET\n", __func__));
 
 		/* Get its status */
 		int_val = (bool) bus->drvr->dongle_reset;
@@ -2905,7 +2911,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
 #ifdef BCMDBG
 		/* Verify NVRAM bytes */
-		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
+		BRCMF_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
 			return -ENOMEM;
@@ -2918,16 +2924,17 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
 				     varsize);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on reading %d nvram bytes at "
-			"0x%08x\n", __func__, bcmerror, varsize, varaddr));
+			BRCMF_ERROR(("%s: error %d on reading %d nvram bytes"
+				     " at 0x%08x\n", __func__, bcmerror,
+				     varsize, varaddr));
 		}
 		/* Compare the org NVRAM with the one read from RAM */
 		if (memcmp(vbuffer, nvram_ularray, varsize)) {
-			DHD_ERROR(("%s: Downloaded NVRAM image is corrupted.\n",
-				   __func__));
+			BRCMF_ERROR(("%s: Downloaded NVRAM image is "
+				     "corrupted.\n", __func__));
 		} else
-			DHD_ERROR(("%s: Download/Upload/Compare of NVRAM ok.\n",
-				__func__));
+			BRCMF_ERROR(("%s: Download/Upload/Compare of"
+				     " NVRAM ok.\n", __func__));
 
 		kfree(nvram_ularray);
 #endif				/* BCMDBG */
@@ -2936,9 +2943,9 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	}
 
 	/* adjust to the user specified RAM */
-	DHD_INFO(("Physical memory size: %d, usable memory size: %d\n",
-		  bus->orig_ramsize, bus->ramsize));
-	DHD_INFO(("Vars are at %d, orig varsize is %d\n", varaddr, varsize));
+	BRCMF_INFO(("Physical memory size: %d, usable memory size: %d\n",
+		    bus->orig_ramsize, bus->ramsize));
+	BRCMF_INFO(("Vars are at %d, orig varsize is %d\n", varaddr, varsize));
 	varsize = ((bus->orig_ramsize - 4) - varaddr);
 
 	/*
@@ -2954,8 +2961,8 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		varsizew = cpu_to_le32(varsizew);
 	}
 
-	DHD_INFO(("New varsize is %d, length token=0x%08x\n", varsize,
-		  varsizew));
+	BRCMF_INFO(("New varsize is %d, length token=0x%08x\n", varsize,
+		    varsizew));
 
 	/* Write the length token to the last word */
 	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
@@ -2992,15 +2999,15 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
-			DHD_ERROR(("%s: SOCRAM core is down after reset?\n",
-				   __func__));
+			BRCMF_ERROR(("%s: SOCRAM core is down after reset?\n",
+				     __func__));
 			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		bcmerror = brcmf_sdbrcm_write_vars(bus);
 		if (bcmerror) {
-			DHD_ERROR(("%s: no vars written to RAM\n", __func__));
+			BRCMF_ERROR(("%s: no vars written to RAM\n", __func__));
 			bcmerror = 0;
 		}
 
@@ -3028,7 +3035,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 	int val_size;
 	u32 actionid;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	ASSERT(name);
 	ASSERT(len >= 0);
@@ -3060,12 +3067,12 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 			     &bus->blocksize, sizeof(s32),
 			     false) != 0) {
 				bus->blocksize = 0;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   "sd_blocksize"));
+				BRCMF_ERROR(("%s: fail on %s get\n", __func__,
+					     "sd_blocksize"));
 			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, "sd_blocksize",
-					  bus->blocksize));
+				BRCMF_INFO(("%s: noted sd_blocksize update,"
+					    " value now %d\n", __func__,
+					    bus->blocksize));
 			}
 		}
 		bus->roundup = min(max_roundup, bus->blocksize);
@@ -3080,8 +3087,8 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 		goto exit;
 	}
 
-	DHD_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		 name, (set ? "set" : "get"), len, plen));
+	BRCMF_CTL(("%s: %s %s, len %d plen %d\n", __func__,
+		   name, (set ? "set" : "get"), len, plen));
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -3114,7 +3121,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	uint retries;
 	int err;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (enforce_mutex)
 		brcmf_sdbrcm_sdlock(bus);
@@ -3154,12 +3161,12 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			   __func__, err));
+		BRCMF_ERROR(("%s: Failed to force clock for F2: err %d\n",
+			     __func__, err));
 	}
 
 	/* Turn off the bus (F2), free any pending packets */
-	DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+	BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
 	brcmf_sdcard_intr_disable(bus->card);
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
@@ -3204,7 +3211,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	int err, ret = 0;
 	u8 saveclk;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* try to download image and nvram to the dongle */
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
@@ -3238,8 +3245,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			   __func__, err));
+		BRCMF_ERROR(("%s: Failed to force clock for F2: err %d\n",
+			     __func__, err));
 		goto exit;
 	}
 
@@ -3259,8 +3266,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		ready = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_0,
 					      SDIO_CCCR_IORx, NULL);
 
-	DHD_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
-		  __func__, enable, ready, tmo.elapsed));
+	BRCMF_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
+		    __func__, enable, ready, tmo.elapsed));
 
 	/* If F2 successfully enabled, set core and enable interrupts */
 	if (ready == enable) {
@@ -3277,11 +3284,11 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 		bus->intdis = false;
 		if (bus->intr) {
-			DHD_INTR(("%s: enable SDIO device interrupts\n",
-				  __func__));
+			BRCMF_INTR(("%s: enable SDIO device interrupts\n",
+				    __func__));
 			brcmf_sdcard_intr_enable(bus->card);
 		} else {
-			DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+			BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
 			brcmf_sdcard_intr_disable(bus->card);
 		}
 
@@ -3302,7 +3309,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	/* Host registration for OOB interrupt */
 	if (brcmf_sdio_register_oob_intr(bus->dhd)) {
 		brcmf_sdbrcm_wd_timer(bus, 0);
-		DHD_ERROR(("%s Host failed to resgister for OOB\n", __func__));
+		BRCMF_ERROR(("%s Host failed to resgister for OOB\n",
+			     __func__));
 		ret = -ENODEV;
 		goto exit;
 	}
@@ -3330,9 +3338,9 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 	u8 hi, lo;
 	int err;
 
-	DHD_ERROR(("%s: %sterminate frame%s\n", __func__,
-		   (abort ? "abort command, " : ""),
-		   (rtx ? ", send NAK" : "")));
+	BRCMF_ERROR(("%s: %sterminate frame%s\n", __func__,
+		     (abort ? "abort command, " : ""),
+		     (rtx ? ", send NAK" : "")));
 
 	if (abort)
 		brcmf_sdcard_abort(card, SDIO_FUNC_2);
@@ -3353,19 +3361,19 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			DHD_ERROR(("%s: count growing: last 0x%04x now "
-				"0x%04x\n",
-				__func__, lastrbc, ((hi << 8) + lo)));
+			BRCMF_ERROR(("%s: count growing: last 0x%04x now "
+				     "0x%04x\n",
+				     __func__, lastrbc, ((hi << 8) + lo)));
 		}
 		lastrbc = (hi << 8) + lo;
 	}
 
 	if (!retries) {
-		DHD_ERROR(("%s: count never zeroed: last 0x%04x\n",
-			   __func__, lastrbc));
+		BRCMF_ERROR(("%s: count never zeroed: last 0x%04x\n",
+			     __func__, lastrbc));
 	} else {
-		DHD_INFO(("%s: flush took %d iterations\n", __func__,
-			  (0xffff - retries)));
+		BRCMF_INFO(("%s: flush took %d iterations\n", __func__,
+			    (0xffff - retries)));
 	}
 
 	if (rtx) {
@@ -3394,7 +3402,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	int sdret;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Control data already received in aligned rxctl */
 	if ((bus->bus == SPI_BUS) && (!bus->usebufpool))
@@ -3440,17 +3448,17 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + firstread) > bus->drvr->maxctl) {
-		DHD_ERROR(("%s: %d-byte control read exceeds %d-byte buffer\n",
-			   __func__, rdlen, bus->drvr->maxctl));
+		BRCMF_ERROR(("%s: %d-byte control read exceeds %d-byte"
+			     " buffer\n", __func__, rdlen, bus->drvr->maxctl));
 		bus->drvr->rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
 	if ((len - doff) > bus->drvr->maxctl) {
-		DHD_ERROR(("%s: %d-byte ctl frame (%d-byte ctl data) exceeds "
-			"%d-byte limit\n",
-			__func__, len, (len - doff), bus->drvr->maxctl));
+		BRCMF_ERROR(("%s: %d-byte ctl frame (%d-byte ctl data) exceeds "
+			     "%d-byte limit\n",
+			     __func__, len, (len - doff), bus->drvr->maxctl));
 		bus->drvr->rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
@@ -3467,8 +3475,8 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
-		DHD_ERROR(("%s: read %d control bytes failed: %d\n",
-			   __func__, rdlen, sdret));
+		BRCMF_ERROR(("%s: read %d control bytes failed: %d\n",
+			     __func__, rdlen, sdret));
 		bus->rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
@@ -3477,7 +3485,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 gotpkt:
 
 #ifdef BCMDBG
-	if (DHD_BYTES_ON() && DHD_CTL_ON()) {
+	if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
 		printk(KERN_DEBUG "RxCtrl:\n");
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, bus->rxctl, len);
 	}
@@ -3510,8 +3518,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	DHD_TRACE(("brcmf_sdbrcm_rxglom: start: glomd %p glom %p\n", bus->glomd,
-		   bus->glom));
+	BRCMF_TRACE(("brcmf_sdbrcm_rxglom: start: glomd %p glom %p\n",
+		     bus->glomd, bus->glom));
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
@@ -3519,8 +3527,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			DHD_ERROR(("%s: bad glomd len(%d), ignore descriptor\n",
-			__func__, dlen));
+			BRCMF_ERROR(("%s: bad glomd len(%d),"
+				     " ignore descriptor\n",
+				     __func__, dlen));
 			dlen = 0;
 		}
 
@@ -3531,14 +3540,15 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			dptr += sizeof(u16);
 			if ((sublen < SDPCM_HDRLEN) ||
 			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				DHD_ERROR(("%s: descriptor len %d bad: %d\n",
-					   __func__, num, sublen));
+				BRCMF_ERROR(("%s: descriptor len %d bad: %d\n",
+					     __func__, num, sublen));
 				pnext = NULL;
 				break;
 			}
 			if (sublen % BRCMF_SDALIGN) {
-				DHD_ERROR(("%s: sublen %d not multiple of %d\n",
-				__func__, sublen, BRCMF_SDALIGN));
+				BRCMF_ERROR(("%s: sublen %d not multiple of"
+					     " %d\n", __func__, sublen,
+					     BRCMF_SDALIGN));
 				usechain = false;
 			}
 			totlen += sublen;
@@ -3554,9 +3564,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
 			if (pnext == NULL) {
-				DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
-					"num %d len %d\n", __func__,
-					num, sublen));
+				BRCMF_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
+					     "num %d len %d\n", __func__,
+					     num, sublen));
 				break;
 			}
 			ASSERT(!(pnext->prev));
@@ -3576,13 +3586,15 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		/* If all allocations succeeded, save packet chain
 			 in bus structure */
 		if (pnext) {
-			DHD_GLOM(("%s: allocated %d-byte packet chain for %d "
-				"subframes\n", __func__, totlen, num));
-			if (DHD_GLOM_ON() && bus->nextlen) {
+			BRCMF_GLOM(("%s: allocated %d-byte packet chain for %d "
+				    "subframes\n", __func__, totlen, num));
+			if (BRCMF_GLOM_ON() && bus->nextlen) {
 				if (totlen != bus->nextlen) {
-					DHD_GLOM(("%s: glomdesc mismatch: nextlen %d glomdesc %d " "rxseq %d\n",
-						__func__, bus->nextlen,
-						totlen, rxseq));
+					BRCMF_GLOM(("%s: glomdesc mismatch: "
+						    "nextlen %d glomdesc %d "
+						    "rxseq %d\n", __func__,
+						    bus->nextlen,
+						    totlen, rxseq));
 				}
 			}
 			bus->glom = pfirst;
@@ -3603,13 +3615,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	/* Ok -- either we just generated a packet chain,
 		 or had one from before */
 	if (bus->glom) {
-		if (DHD_GLOM_ON()) {
-			DHD_GLOM(("%s: try superframe read, packet chain:\n",
-				__func__));
+		if (BRCMF_GLOM_ON()) {
+			BRCMF_GLOM(("%s: try superframe read, packet chain:\n",
+				    __func__));
 			for (pnext = bus->glom; pnext; pnext = pnext->next) {
-				DHD_GLOM(("    %p: %p len 0x%04x (%d)\n",
-					  pnext, (u8 *) (pnext->data),
-					  pnext->len, pnext->len));
+				BRCMF_GLOM(("    %p: %p len 0x%04x (%d)\n",
+					    pnext, (u8 *) (pnext->data),
+					    pnext->len, pnext->len));
 			}
 		}
 
@@ -3635,14 +3647,15 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
-				DHD_ERROR(("%s: FAILED TO COPY, dlen %d sublen %d\n",
-					__func__, dlen, sublen));
+				BRCMF_ERROR(("%s: FAILED TO COPY, dlen %d "
+					     "sublen %d\n",
+					     __func__, dlen, sublen));
 				errcode = -1;
 			}
 			pnext = NULL;
 		} else {
-			DHD_ERROR(("COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
-				dlen));
+			BRCMF_ERROR(("COULDN'T ALLOC %d-BYTE GLOM, "
+				     "FORCE FAILURE\n", dlen));
 			errcode = -1;
 		}
 		bus->f2rxdata++;
@@ -3650,8 +3663,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
-			DHD_ERROR(("%s: glom read of %d bytes failed: %d\n",
-				   __func__, dlen, errcode));
+			BRCMF_ERROR(("%s: glom read of %d bytes failed: %d\n",
+				     __func__, dlen, errcode));
 			bus->drvr->rx_errors++;
 
 			if (bus->glomerr++ < 3) {
@@ -3666,7 +3679,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			return 0;
 		}
 #ifdef BCMDBG
-		if (DHD_GLOM_ON()) {
+		if (BRCMF_GLOM_ON()) {
 			printk(KERN_DEBUG "SUPERFRAME:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 				pfirst->data, min_t(int, pfirst->len, 48));
@@ -3682,8 +3695,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			DHD_INFO(("%s: nextlen too large (%d) seq %d\n",
-				__func__, bus->nextlen, seq));
+			BRCMF_INFO(("%s: nextlen too large (%d) seq %d\n",
+				    __func__, bus->nextlen, seq));
 			bus->nextlen = 0;
 		}
 		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
@@ -3691,47 +3704,48 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 		errcode = 0;
 		if ((u16)~(sublen ^ check)) {
-			DHD_ERROR(("%s (superframe): HW hdr error: len/check "
-				"0x%04x/0x%04x\n", __func__, sublen, check));
+			BRCMF_ERROR(("%s (superframe): HW hdr error: len/check "
+				     "0x%04x/0x%04x\n", __func__, sublen,
+				     check));
 			errcode = -1;
 		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			DHD_ERROR(("%s (superframe): len 0x%04x, rounded "
-				"0x%04x, expect 0x%04x\n",
-				__func__, sublen,
-				roundup(sublen, bus->blocksize), dlen));
+			BRCMF_ERROR(("%s (superframe): len 0x%04x, rounded "
+				     "0x%04x, expect 0x%04x\n",
+				     __func__, sublen,
+				     roundup(sublen, bus->blocksize), dlen));
 			errcode = -1;
 		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
 			   SDPCM_GLOM_CHANNEL) {
-			DHD_ERROR(("%s (superframe): bad channel %d\n",
+			BRCMF_ERROR(("%s (superframe): bad channel %d\n",
 				   __func__,
 				   SDPCM_PACKET_CHANNEL(&dptr
 							[SDPCM_FRAMETAG_LEN])));
 			errcode = -1;
 		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
-			DHD_ERROR(("%s (superframe): got second descriptor?\n",
-				   __func__));
+			BRCMF_ERROR(("%s (superframe): got 2nd descriptor?\n",
+				     __func__));
 			errcode = -1;
 		} else if ((doff < SDPCM_HDRLEN) ||
 			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			DHD_ERROR(("%s (superframe): Bad data offset %d: HW %d "
-				"pkt %d min %d\n",
-				__func__, doff, sublen,
-				pfirst->len, SDPCM_HDRLEN));
+			BRCMF_ERROR(("%s (superframe): Bad data offset %d: "
+				     "HW %d pkt %d min %d\n",
+				     __func__, doff, sublen,
+				     pfirst->len, SDPCM_HDRLEN));
 			errcode = -1;
 		}
 
 		/* Check sequence number of superframe SW header */
 		if (rxseq != seq) {
-			DHD_INFO(("%s: (superframe) rx_seq %d, expected %d\n",
-				  __func__, seq, rxseq));
+			BRCMF_INFO(("%s: (superframe) rx_seq %d, expected %d\n",
+				    __func__, seq, rxseq));
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			DHD_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				__func__, txmax, bus->tx_seq));
+			BRCMF_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
+				     __func__, txmax, bus->tx_seq));
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -3750,7 +3764,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 #ifdef BCMDBG
-			if (DHD_GLOM_ON()) {
+			if (BRCMF_GLOM_ON()) {
 				printk(KERN_DEBUG "subframe:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						     dptr, 32);
@@ -3758,24 +3772,25 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 #endif
 
 			if ((u16)~(sublen ^ check)) {
-				DHD_ERROR(("%s (subframe %d): HW hdr error: "
-					   "len/check 0x%04x/0x%04x\n",
-					   __func__, num, sublen, check));
+				BRCMF_ERROR(("%s (subframe %d): HW hdr error: "
+					     "len/check 0x%04x/0x%04x\n",
+					     __func__, num, sublen, check));
 				errcode = -1;
 			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				DHD_ERROR(("%s (subframe %d): length mismatch: "
-					   "len 0x%04x, expect 0x%04x\n",
-					   __func__, num, sublen, dlen));
+				BRCMF_ERROR(("%s (subframe %d): length mismatch"
+					     ": len 0x%04x, expect 0x%04x\n",
+					     __func__, num, sublen, dlen));
 				errcode = -1;
 			} else if ((chan != SDPCM_DATA_CHANNEL) &&
 				   (chan != SDPCM_EVENT_CHANNEL)) {
-				DHD_ERROR(("%s (subframe %d): bad channel %d\n",
-					   __func__, num, chan));
+				BRCMF_ERROR(("%s (subframe %d): bad channel"
+					     " %d\n", __func__, num, chan));
 				errcode = -1;
 			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				DHD_ERROR(("%s (subframe %d): Bad data offset %d: HW %d min %d\n",
-					__func__, num, doff, sublen,
-					SDPCM_HDRLEN));
+				BRCMF_ERROR(("%s (subframe %d): Bad data offset"
+					     " %d: HW %d min %d\n",
+					     __func__, num, doff, sublen,
+					     SDPCM_HDRLEN));
 				errcode = -1;
 			}
 		}
@@ -3813,22 +3828,22 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-			DHD_GLOM(("%s: Get subframe %d, %p(%p/%d), sublen %d "
-				"chan %d seq %d\n",
-				__func__, num, pfirst, pfirst->data,
-				pfirst->len, sublen, chan, seq));
+			BRCMF_GLOM(("%s: Get subframe %d, %p(%p/%d), sublen %d "
+				    "chan %d seq %d\n",
+				    __func__, num, pfirst, pfirst->data,
+				    pfirst->len, sublen, chan, seq));
 
 			ASSERT((chan == SDPCM_DATA_CHANNEL)
 			       || (chan == SDPCM_EVENT_CHANNEL));
 
 			if (rxseq != seq) {
-				DHD_GLOM(("%s: rx_seq %d, expected %d\n",
-					  __func__, seq, rxseq));
+				BRCMF_GLOM(("%s: rx_seq %d, expected %d\n",
+					    __func__, seq, rxseq));
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
 #ifdef BCMDBG
-			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
 				printk(KERN_DEBUG "Rx Subframe Data:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						     dptr, dlen);
@@ -3849,8 +3864,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				continue;
 			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pfirst)
 					!= 0) {
-				DHD_ERROR(("%s: rx protocol error\n",
-					   __func__));
+				BRCMF_ERROR(("%s: rx protocol error\n",
+					     __func__));
 				bus->drvr->rx_errors++;
 				brcmu_pkt_buf_free_skb(pfirst);
 				if (plast) {
@@ -3869,12 +3884,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			num++;
 
 #ifdef BCMDBG
-			if (DHD_GLOM_ON()) {
-				DHD_GLOM(("%s subframe %d to stack, %p(%p/%d) "
-				"nxt/lnk %p/%p\n",
-				__func__, num, pfirst, pfirst->data,
-				pfirst->len, pfirst->next,
-				pfirst->prev));
+			if (BRCMF_GLOM_ON()) {
+				BRCMF_GLOM(("%s subframe %d to stack, %p"
+					    "(%p/%d) nxt/lnk %p/%p\n",
+					    __func__, num, pfirst, pfirst->data,
+					    pfirst->len, pfirst->next,
+					    pfirst->prev));
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						pfirst->data,
 						min_t(int, pfirst->len, 32));
@@ -3920,7 +3935,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	bool sdtest = false;	/* To limit message spew from test mode */
 #endif
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	ASSERT(maxframes);
 
@@ -3942,10 +3957,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		/* Handle glomming separately */
 		if (bus->glom || bus->glomd) {
 			u8 cnt;
-			DHD_GLOM(("%s: calling rxglom: glomd %p, glom %p\n",
-				  __func__, bus->glomd, bus->glom));
+			BRCMF_GLOM(("%s: calling rxglom: glomd %p, glom %p\n",
+				    __func__, bus->glomd, bus->glom));
 			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
-			DHD_GLOM(("%s: rxglom returned %d\n", __func__, cnt));
+			BRCMF_GLOM(("%s: rxglom returned %d\n", __func__, cnt));
 			rxseq += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
 			continue;
@@ -4017,9 +4032,11 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					/* Control frame failures need
 					 retransmission */
 					if (sdret < 0) {
-						DHD_ERROR(("%s: read %d control bytes failed: %d\n",
-							__func__,
-							rdlen, sdret));
+						BRCMF_ERROR(("%s: read %d "
+							     "control bytes "
+							     "failed: %d\n",
+							     __func__,
+							     rdlen, sdret));
 						/* dhd.rx_ctlerrs is higher */
 						bus->rxc_errors++;
 						brcmf_sdbrcm_rxfail(bus, true,
@@ -4031,12 +4048,12 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				} else {
 					/* Give up on data,
 					request rtx of events */
-					DHD_ERROR(("%s (nextlen): "
-						   "brcmu_pkt_buf_get_skb "
-						   "failed:"
-						   " len %d rdlen %d expected"
-						   " rxseq %d\n", __func__,
-						   len, rdlen, rxseq));
+					BRCMF_ERROR(("%s (nextlen): "
+						     "brcmu_pkt_buf_get_skb "
+						     "failed:"
+						     " len %d rdlen %d expected"
+						     " rxseq %d\n", __func__,
+						     len, rdlen, rxseq));
 					continue;
 				}
 			} else {
@@ -4056,8 +4073,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				ASSERT(sdret != -BCME_PENDING);
 
 				if (sdret < 0) {
-					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
-						__func__, rdlen, sdret));
+					BRCMF_ERROR(("%s (nextlen): read %d"
+						     " bytes failed: %d\n",
+						     __func__, rdlen, sdret));
 					brcmu_pkt_buf_free_skb(pkt);
 					bus->drvr->rx_errors++;
 					/* Force retry w/normal header read.
@@ -4081,18 +4099,18 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* All zeros means readahead info was bad */
 			if (!(len | check)) {
-				DHD_INFO(("%s (nextlen): read zeros in HW "
-					"header???\n", __func__));
+				BRCMF_INFO(("%s (nextlen): read zeros in HW "
+					    "header???\n", __func__));
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
 			/* Validate check bytes */
 			if ((u16)~(len ^ check)) {
-				DHD_ERROR(("%s (nextlen): HW hdr error:"
-					" nextlen/len/check"
-					" 0x%04x/0x%04x/0x%04x\n",
-					__func__, nextlen, len, check));
+				BRCMF_ERROR(("%s (nextlen): HW hdr error:"
+					     " nextlen/len/check"
+					     " 0x%04x/0x%04x/0x%04x\n",
+					     __func__, nextlen, len, check));
 				bus->rx_badhdr++;
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
@@ -4101,8 +4119,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate frame length */
 			if (len < SDPCM_HDRLEN) {
-				DHD_ERROR(("%s (nextlen): HW hdr length "
-					"invalid: %d\n", __func__, len));
+				BRCMF_ERROR(("%s (nextlen): HW hdr length "
+					     "invalid: %d\n", __func__, len));
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
@@ -4112,11 +4130,11 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			if (len_consistent) {
 				/* Mismatch, force retry w/normal
 					header (may be >4K) */
-				DHD_ERROR(("%s (nextlen): mismatch, "
-					"nextlen %d len %d rnd %d; "
-					"expected rxseq %d\n",
-					__func__, nextlen,
-					len, roundup(len, 16), rxseq));
+				BRCMF_ERROR(("%s (nextlen): mismatch, "
+					     "nextlen %d len %d rnd %d; "
+					     "expected rxseq %d\n",
+					     __func__, nextlen,
+					     len, roundup(len, 16), rxseq));
 				brcmf_sdbrcm_rxfail(bus, true,
 						  bus->bus != SPI_BUS);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
@@ -4137,8 +4155,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
 				       SDPCM_NEXTLEN_OFFSET];
 			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				DHD_INFO(("%s (nextlen): got frame w/nextlen too large" " (%d), seq %d\n",
-					__func__, bus->nextlen, seq));
+				BRCMF_INFO(("%s (nextlen): got frame w/nextlen"
+					    " too large (%d), seq %d\n",
+					    __func__, bus->nextlen, seq));
 				bus->nextlen = 0;
 			}
 
@@ -4161,27 +4180,27 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Check and update sequence number */
 			if (rxseq != seq) {
-				DHD_INFO(("%s (nextlen): rx_seq %d, expected "
-					"%d\n", __func__, seq, rxseq));
+				BRCMF_INFO(("%s (nextlen): rx_seq %d, expected "
+					    "%d\n", __func__, seq, rxseq));
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
 
 			/* Check window for sanity */
 			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				DHD_ERROR(("%s: got unlikely tx max %d with "
-					"tx_seq %d\n",
-					__func__, txmax, bus->tx_seq));
+				BRCMF_ERROR(("%s: got unlikely tx max %d with "
+					     "tx_seq %d\n",
+					     __func__, txmax, bus->tx_seq));
 				txmax = bus->tx_seq + 2;
 			}
 			bus->tx_max = txmax;
 
 #ifdef BCMDBG
-			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
 				printk(KERN_DEBUG "Rx Data:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						     rxbuf, len);
-			} else if (DHD_HDRS_ON()) {
+			} else if (BRCMF_HDRS_ON()) {
 				printk(KERN_DEBUG "RxHdr:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						     bus->rxhdr, SDPCM_HDRLEN);
@@ -4193,8 +4212,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					brcmf_sdbrcm_read_control(bus, rxbuf,
 								  len, doff);
 				} else {
-					DHD_ERROR(("%s (nextlen): readahead on control" " packet %d?\n",
-						__func__, seq));
+					BRCMF_ERROR(("%s (nextlen): readahead"
+						     " on control packet %d?\n",
+						     __func__, seq));
 					/* Force retry w/normal header read */
 					bus->nextlen = 0;
 					brcmf_sdbrcm_rxfail(bus, false, true);
@@ -4204,16 +4224,18 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			}
 
 			if ((bus->bus == SPI_BUS) && !bus->usebufpool) {
-				DHD_ERROR(("Received %d bytes on %d channel. Running out of " "rx pktbuf's or not yet malloced.\n",
-					len, chan));
+				BRCMF_ERROR(("Received %d bytes on %d channel."
+					     " Running out of " "rx pktbuf's or"
+					     " not yet malloced.\n",
+					     len, chan));
 				continue;
 			}
 
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				DHD_ERROR(("%s (nextlen): bad data offset %d: "
-					   "HW len %d min %d\n",
-					   __func__, doff, len, SDPCM_HDRLEN));
+				BRCMF_ERROR(("%s (nextlen): bad data offset %d:"
+					     " HW len %d min %d\n", __func__,
+					     doff, len, SDPCM_HDRLEN));
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
@@ -4235,14 +4257,14 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
-			DHD_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
-				   sdret));
+			BRCMF_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
+				     sdret));
 			bus->rx_hdrfail++;
 			brcmf_sdbrcm_rxfail(bus, true, true);
 			continue;
 		}
 #ifdef BCMDBG
-		if (DHD_BYTES_ON() || DHD_HDRS_ON()) {
+		if (BRCMF_BYTES_ON() || BRCMF_HDRS_ON()) {
 			printk(KERN_DEBUG "RxHdr:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 					     bus->rxhdr, SDPCM_HDRLEN);
@@ -4261,8 +4283,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate check bytes */
 		if ((u16) ~(len ^ check)) {
-			DHD_ERROR(("%s: HW hdr err: len/check 0x%04x/0x%04x\n",
-				__func__, len, check));
+			BRCMF_ERROR(("%s: HW hdr err: len/check "
+				     "0x%04x/0x%04x\n", __func__, len, check));
 			bus->rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -4270,8 +4292,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate frame length */
 		if (len < SDPCM_HDRLEN) {
-			DHD_ERROR(("%s: HW hdr length invalid: %d\n",
-				   __func__, len));
+			BRCMF_ERROR(("%s: HW hdr length invalid: %d\n",
+				     __func__, len));
 			continue;
 		}
 
@@ -4283,9 +4305,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate data offset */
 		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			DHD_ERROR(("%s: Bad data offset %d: HW len %d, min %d "
-				"seq %d\n",
-				__func__, doff, len, SDPCM_HDRLEN, seq));
+			BRCMF_ERROR(("%s: Bad data offset %d: HW len %d,"
+				     " min %d seq %d\n", __func__, doff,
+				     len, SDPCM_HDRLEN, seq));
 			bus->rx_badhdr++;
 			ASSERT(0);
 			brcmf_sdbrcm_rxfail(bus, false, false);
@@ -4296,9 +4318,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		bus->nextlen =
 		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			DHD_INFO(("%s (nextlen): got frame w/nextlen too large "
-				"(%d), seq %d\n",
-				__func__, bus->nextlen, seq));
+			BRCMF_INFO(("%s (nextlen): got frame w/nextlen too"
+				    " large (%d), seq %d\n",
+				    __func__, bus->nextlen, seq));
 			bus->nextlen = 0;
 		}
 
@@ -4318,16 +4340,16 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Check and update sequence number */
 		if (rxseq != seq) {
-			DHD_INFO(("%s: rx_seq %d, expected %d\n", __func__,
-				  seq, rxseq));
+			BRCMF_INFO(("%s: rx_seq %d, expected %d\n", __func__,
+				    seq, rxseq));
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			DHD_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				__func__, txmax, bus->tx_seq));
+			BRCMF_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
+				     __func__, txmax, bus->tx_seq));
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -4363,8 +4385,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		if ((rdlen + firstread) > MAX_RX_DATASZ) {
 			/* Too long -- skip this frame */
-			DHD_ERROR(("%s: too long: len %d rdlen %d\n",
-				   __func__, len, rdlen));
+			BRCMF_ERROR(("%s: too long: len %d rdlen %d\n",
+				     __func__, len, rdlen));
 			bus->drvr->rx_errors++;
 			bus->rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
@@ -4374,8 +4396,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
-				   " chan %d\n", __func__, rdlen, chan));
+			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed:"
+				     " rdlen %d chan %d\n", __func__, rdlen,
+				     chan));
 			bus->drvr->rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
@@ -4397,13 +4420,11 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
-			DHD_ERROR(("%s: read %d %s bytes failed: %d\n",
-				   __func__, rdlen,
-				   ((chan ==
-				     SDPCM_EVENT_CHANNEL) ? "event" : ((chan ==
-					SDPCM_DATA_CHANNEL)
-				       ? "data" : "test")),
-				   sdret));
+			BRCMF_ERROR(("%s: read %d %s bytes failed: %d\n",
+				     __func__, rdlen,
+				     ((chan == SDPCM_EVENT_CHANNEL) ? "event"
+				     : ((chan == SDPCM_DATA_CHANNEL) ? "data"
+				     : "test")), sdret));
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->drvr->rx_errors++;
 			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
@@ -4415,7 +4436,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		memcpy(pkt->data, bus->rxhdr, firstread);
 
 #ifdef BCMDBG
-		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
 			printk(KERN_DEBUG "Rx Data:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 					     pkt->data, len);
@@ -4426,10 +4447,10 @@ deliver:
 		/* Save superframe descriptor and allocate packet frame */
 		if (chan == SDPCM_GLOM_CHANNEL) {
 			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
-				DHD_GLOM(("%s: glom descriptor, %d bytes:\n",
-					__func__, len));
+				BRCMF_GLOM(("%s: glom descriptor, %d bytes:\n",
+					    __func__, len));
 #ifdef BCMDBG
-				if (DHD_GLOM_ON()) {
+				if (BRCMF_GLOM_ON()) {
 					printk(KERN_DEBUG "Glom Data:\n");
 					print_hex_dump_bytes("",
 							     DUMP_PREFIX_OFFSET,
@@ -4441,8 +4462,8 @@ deliver:
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
-				DHD_ERROR(("%s: glom superframe w/o "
-					"descriptor!\n", __func__));
+				BRCMF_ERROR(("%s: glom superframe w/o "
+					     "descriptor!\n", __func__));
 				brcmf_sdbrcm_rxfail(bus, false, false);
 			}
 			continue;
@@ -4464,7 +4485,7 @@ deliver:
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
 		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
-			DHD_ERROR(("%s: rx protocol error\n", __func__));
+			BRCMF_ERROR(("%s: rx protocol error\n", __func__));
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->drvr->rx_errors++;
 			continue;
@@ -4479,11 +4500,11 @@ deliver:
 #ifdef BCMDBG
 	/* Message if we hit the limit */
 	if (!rxleft && !sdtest)
-		DHD_DATA(("%s: hit rx limit of %d frames\n", __func__,
-			  maxframes));
+		BRCMF_DATA(("%s: hit rx limit of %d frames\n", __func__,
+			    maxframes));
 	else
 #endif				/* BCMDBG */
-		DHD_DATA(("%s: processed %d frames\n", __func__, rxcount));
+		BRCMF_DATA(("%s: processed %d frames\n", __func__, rxcount));
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
 		rxseq--;
@@ -4499,7 +4520,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 	u8 fcbits;
 	uint retries = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Read mailbox data and ack that we did so */
 	r_sdreg32(bus, &hmb_data,
@@ -4512,10 +4533,10 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		DHD_INFO(("Dongle reports NAK handled, expect rtx of %d\n",
-			  bus->rx_seq));
+		BRCMF_INFO(("Dongle reports NAK handled, expect rtx of %d\n",
+			    bus->rx_seq));
 		if (!bus->rxskip)
-			DHD_ERROR(("%s: unexpected NAKHANDLED!\n", __func__));
+			BRCMF_ERROR(("%s: unexpected NAKHANDLED!\n", __func__));
 
 		bus->rxskip = false;
 		intstatus |= I_HMB_FRAME_IND;
@@ -4529,12 +4550,12 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 		    (hmb_data & HMB_DATA_VERSION_MASK) >>
 		    HMB_DATA_VERSION_SHIFT;
 		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			DHD_ERROR(("Version mismatch, dongle reports %d, "
-				"expecting %d\n",
-				bus->sdpcm_ver, SDPCM_PROT_VERSION));
+			BRCMF_ERROR(("Version mismatch, dongle reports %d, "
+				     "expecting %d\n",
+				     bus->sdpcm_ver, SDPCM_PROT_VERSION));
 		else
-			DHD_INFO(("Dongle ready, protocol version %d\n",
-				  bus->sdpcm_ver));
+			BRCMF_INFO(("Dongle ready, protocol version %d\n",
+				    bus->sdpcm_ver));
 	}
 
 	/*
@@ -4562,7 +4583,8 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK)) {
-		DHD_ERROR(("Unknown mailbox data content: 0x%02x\n", hmb_data));
+		BRCMF_ERROR(("Unknown mailbox data content: 0x%02x\n",
+			     hmb_data));
 	}
 
 	return intstatus;
@@ -4579,7 +4601,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
@@ -4596,8 +4618,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
-			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
-				   __func__, err));
+			BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
+				     __func__, err));
 			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		} else {
 			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
@@ -4608,28 +4630,28 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
-				   err));
+			BRCMF_ERROR(("%s: error reading CSR: %d\n", __func__,
+				     err));
 			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		}
 
-		DHD_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n", devctl,
-			  clkctl));
+		BRCMF_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
+			    devctl, clkctl));
 
 		if (SBSDIO_HTAV(clkctl)) {
 			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						       SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
-					   __func__, err));
+				BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
+					     __func__, err));
 				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 			if (err) {
-				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
-					   __func__, err));
+				BRCMF_ERROR(("%s: error writing DEVCTL: %d\n",
+					     __func__, err));
 				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
@@ -4692,23 +4714,23 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
-		DHD_ERROR(("Dongle reports WR_OOSYNC\n"));
+		BRCMF_ERROR(("Dongle reports WR_OOSYNC\n"));
 		intstatus &= ~I_WR_OOSYNC;
 	}
 
 	if (intstatus & I_RD_OOSYNC) {
-		DHD_ERROR(("Dongle reports RD_OOSYNC\n"));
+		BRCMF_ERROR(("Dongle reports RD_OOSYNC\n"));
 		intstatus &= ~I_RD_OOSYNC;
 	}
 
 	if (intstatus & I_SBINT) {
-		DHD_ERROR(("Dongle reports SBINT\n"));
+		BRCMF_ERROR(("Dongle reports SBINT\n"));
 		intstatus &= ~I_SBINT;
 	}
 
 	/* Would be active due to wake-wlan in gSPI */
 	if (intstatus & I_CHIPACTIVE) {
-		DHD_INFO(("Dongle reports CHIPACTIVE\n"));
+		BRCMF_INFO(("Dongle reports CHIPACTIVE\n"));
 		intstatus &= ~I_CHIPACTIVE;
 	}
 
@@ -4733,8 +4755,8 @@ clkwait:
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
 	 */
 	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(card)) {
-		DHD_INTR(("%s: enable SDIO interrupts, rxdone %d framecnt %d\n",
-			  __func__, rxdone, framecnt));
+		BRCMF_INTR(("%s: enable SDIO interrupts, rxdone %d"
+			    " framecnt %d\n", __func__, rxdone, framecnt));
 		bus->intdis = false;
 		brcmf_sdcard_intr_enable(card);
 	}
@@ -4751,8 +4773,8 @@ clkwait:
 		if (ret < 0) {
 			/* On failure, abort the command and
 				terminate the frame */
-			DHD_INFO(("%s: sdio error %d, abort command and "
-				"terminate frame.\n", __func__, ret));
+			BRCMF_INFO(("%s: sdio error %d, abort command and "
+				    "terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
 			brcmf_sdcard_abort(card, SDIO_FUNC_2);
@@ -4779,7 +4801,7 @@ clkwait:
 		if (ret == 0)
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-		DHD_INFO(("Return_dpc value is : %d\n", ret));
+		BRCMF_INFO(("Return_dpc value is : %d\n", ret));
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -4798,14 +4820,14 @@ clkwait:
 		 no resched or interrupts */
 	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(card)) {
-		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
-			   "operation %d\n", __func__,
-			  brcmf_sdcard_regfail(card)));
+		BRCMF_ERROR(("%s: failed backplane access over SDIO, halting "
+			     "operation %d\n", __func__,
+			     brcmf_sdcard_regfail(card)));
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
-		DHD_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
-			"I_CHIPACTIVE interrupt\n", __func__));
+		BRCMF_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
+			    "I_CHIPACTIVE interrupt\n", __func__));
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
@@ -4832,16 +4854,16 @@ void brcmf_sdbrcm_isr(void *arg)
 	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
 	struct brcmf_sdio_card *card;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (!bus) {
-		DHD_ERROR(("%s : bus is null pointer , exit\n", __func__));
+		BRCMF_ERROR(("%s : bus is null pointer , exit\n", __func__));
 		return;
 	}
 	card = bus->card;
 
 	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
-		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
+		BRCMF_ERROR(("%s : bus is down. we have nothing to do\n",
 			   __func__));
 		return;
 	}
@@ -4851,21 +4873,21 @@ void brcmf_sdbrcm_isr(void *arg)
 
 	/* Shouldn't get this interrupt if we're sleeping? */
 	if (bus->sleeping) {
-		DHD_ERROR(("INTERRUPT WHILE SLEEPING??\n"));
+		BRCMF_ERROR(("INTERRUPT WHILE SLEEPING??\n"));
 		return;
 	}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (bus->intr)
-		DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+		BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
 	else
-		DHD_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
+		BRCMF_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
 
 	brcmf_sdcard_intr_disable(card);
 	bus->intdis = true;
 
 #if defined(SDIO_ISR_THREAD)
-	DHD_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
+	BRCMF_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
 	while (brcmf_sdbrcm_dpc(bus))
 		;
 #else
@@ -4936,8 +4958,8 @@ static void brcmf_sdbrcm_pktgen(struct brcmf_bus *bus)
 			len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN,
 			true);
 		if (!pkt) {
-			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
-				   __func__));
+			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
+				     __func__));
 			break;
 		}
 		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
@@ -4962,8 +4984,8 @@ static void brcmf_sdbrcm_pktgen(struct brcmf_bus *bus)
 			break;
 
 		default:
-			DHD_ERROR(("Unrecognized pktgen mode %d\n",
-				   bus->pktgen_mode));
+			BRCMF_ERROR(("Unrecognized pktgen mode %d\n",
+				     bus->pktgen_mode));
 			brcmu_pkt_buf_free_skb(pkt, true);
 			bus->pktgen_count = 0;
 			return;
@@ -4980,7 +5002,7 @@ static void brcmf_sdbrcm_pktgen(struct brcmf_bus *bus)
 			    SDPCM_TEST_FILL(fillbyte, (u8) bus->pktgen_sent);
 
 #ifdef BCMDBG
-		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
 			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
 			printk(KERN_DEBUG "brcmf_sdbrcm_pktgen: Tx Data:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data,
@@ -5016,7 +5038,7 @@ static void brcmf_sdbrcm_sdtest_set(struct brcmf_bus *bus, bool start)
 	pkt = brcmu_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
 		BRCMF_SDALIGN, true);
 	if (!pkt) {
-		DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n", __func__));
+		BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n", __func__));
 		return;
 	}
 	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), BRCMF_SDALIGN);
@@ -5047,8 +5069,8 @@ brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
 	/* Check for min length */
 	pktlen = pkt->len;
 	if (pktlen < SDPCM_TEST_HDRLEN) {
-		DHD_ERROR(("brcmf_sdbrcm_checkdied: toss runt frame, pktlen "
-			   "%d\n", pktlen));
+		BRCMF_ERROR(("brcmf_sdbrcm_checkdied: toss runt frame, pktlen "
+			     "%d\n", pktlen));
 		brcmu_pkt_buf_free_skb(pkt, false);
 		return;
 	}
@@ -5064,10 +5086,10 @@ brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
 	if (cmd == SDPCM_TEST_DISCARD || cmd == SDPCM_TEST_ECHOREQ
 	    || cmd == SDPCM_TEST_ECHORSP) {
 		if (pktlen != len + SDPCM_TEST_HDRLEN) {
-			DHD_ERROR(("brcmf_sdbrcm_checkdied: frame length "
-				"mismatch, pktlen %d seq %d" " cmd %d extra %d "
-				"len %d\n",
-				pktlen, seq, cmd, extra, len));
+			BRCMF_ERROR(("brcmf_sdbrcm_checkdied: frame length "
+				     "mismatch, pktlen %d seq %d"
+				     " cmd %d extra %d len %d\n",
+				     pktlen, seq, cmd, extra, len));
 			brcmu_pkt_buf_free_skb(pkt, false);
 			return;
 		}
@@ -5097,12 +5119,13 @@ brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
 
 		for (offset = 0; offset < len; offset++, data++) {
 			if (*data != SDPCM_TEST_FILL(offset, extra)) {
-				DHD_ERROR(("brcmf_sdbrcm_checkdied: echo data "
-					   "mismatch: " "offset %d (len %d) "
-					   "expect 0x%02x rcvd 0x%02x\n",
-					   offset, len,
-					   SDPCM_TEST_FILL(offset, extra),
-					   *data));
+				BRCMF_ERROR(("brcmf_sdbrcm_checkdied: echo"
+					     " data mismatch: "
+					     "offset %d (len %d) "
+					     "expect 0x%02x rcvd 0x%02x\n",
+					     offset, len,
+					     SDPCM_TEST_FILL(offset, extra),
+					     *data));
 				break;
 			}
 		}
@@ -5118,9 +5141,9 @@ brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
 	case SDPCM_TEST_BURST:
 	case SDPCM_TEST_SEND:
 	default:
-		DHD_INFO(("brcmf_sdbrcm_checkdied: unsupported or unknown "
-			"command, pktlen %d seq %d" " cmd %d extra %d len %d\n",
-			pktlen, seq, cmd, extra, len));
+		BRCMF_INFO(("brcmf_sdbrcm_checkdied: unsupported or unknown "
+			    "command, pktlen %d seq %d" " cmd %d extra %d"
+			    " len %d\n", pktlen, seq, cmd, extra, len));
 		brcmu_pkt_buf_free_skb(pkt, false);
 		break;
 	}
@@ -5140,7 +5163,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus *bus;
 
-	DHD_TIMER(("%s: Enter\n", __func__));
+	BRCMF_TIMER(("%s: Enter\n", __func__));
 
 	bus = drvr->bus;
 
@@ -5338,8 +5361,8 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 
 	brcmf_c_init();
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
+	BRCMF_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
 
 	/* We make assumptions about address window mappings */
 	ASSERT(regsva == SI_ENUM_BASE);
@@ -5355,7 +5378,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	case PCI_VENDOR_ID_BROADCOM:
 		break;
 	default:
-		DHD_ERROR(("%s: unknown vendor: 0x%04x\n", __func__, venid));
+		BRCMF_ERROR(("%s: unknown vendor: 0x%04x\n", __func__, venid));
 		return NULL;
 	}
 
@@ -5364,34 +5387,35 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	case BCM4325_D11DUAL_ID:	/* 4325 802.11a/g id */
 	case BCM4325_D11G_ID:	/* 4325 802.11g 2.4Ghz band id */
 	case BCM4325_D11A_ID:	/* 4325 802.11a 5Ghz band id */
-		DHD_INFO(("%s: found 4325 Dongle\n", __func__));
+		BRCMF_INFO(("%s: found 4325 Dongle\n", __func__));
 		break;
 	case BCM4329_D11NDUAL_ID:	/* 4329 802.11n dualband device */
 	case BCM4329_D11N2G_ID:	/* 4329 802.11n 2.4G device */
 	case BCM4329_D11N5G_ID:	/* 4329 802.11n 5G device */
 	case 0x4329:
-		DHD_INFO(("%s: found 4329 Dongle\n", __func__));
+		BRCMF_INFO(("%s: found 4329 Dongle\n", __func__));
 		break;
 	case BCM4319_D11N_ID:	/* 4319 802.11n id */
 	case BCM4319_D11N2G_ID:	/* 4319 802.11n2g id */
 	case BCM4319_D11N5G_ID:	/* 4319 802.11n5g id */
-		DHD_INFO(("%s: found 4319 Dongle\n", __func__));
+		BRCMF_INFO(("%s: found 4319 Dongle\n", __func__));
 		break;
 	case 0:
-		DHD_INFO(("%s: allow device id 0, will check chip internals\n",
-			  __func__));
+		BRCMF_INFO(("%s: allow device id 0, will check chip"
+			    " internals\n", __func__));
 		break;
 
 	default:
-		DHD_ERROR(("%s: skipping 0x%04x/0x%04x, not a dongle\n",
-			   __func__, venid, devid));
+		BRCMF_ERROR(("%s: skipping 0x%04x/0x%04x, not a dongle\n",
+			     __func__, venid, devid));
 		return NULL;
 	}
 
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
 	if (!bus) {
-		DHD_ERROR(("%s: kmalloc of struct dhd_bus failed\n", __func__));
+		BRCMF_ERROR(("%s: kmalloc of struct dhd_bus failed\n",
+			     __func__));
 		goto fail;
 	}
 	bus->card = card;
@@ -5403,7 +5427,8 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, card, regsva, devid))) {
-		DHD_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n",
+			     __func__));
 		goto fail;
 	}
 
@@ -5457,46 +5482,48 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	/* Attach to the brcmf/OS/network interface */
 	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->drvr) {
-		DHD_ERROR(("%s: brcmf_attach failed\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_attach failed\n", __func__));
 		goto fail;
 	}
 
 	/* Allocate buffers */
 	if (!(brcmf_sdbrcm_probe_malloc(bus, card))) {
-		DHD_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n",
+			     __func__));
 		goto fail;
 	}
 
 	if (!(brcmf_sdbrcm_probe_init(bus, card))) {
-		DHD_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
 		goto fail;
 	}
 
 	/* Register interrupt callback, but mask it (not operational yet). */
-	DHD_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
-		  __func__));
+	BRCMF_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
+		    __func__));
 	brcmf_sdcard_intr_disable(card);
 	ret = brcmf_sdcard_intr_reg(card, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
-		DHD_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
-			   __func__, ret));
+		BRCMF_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
+			     __func__, ret));
 		goto fail;
 	}
-	DHD_INTR(("%s: registered SDIO interrupt function ok\n", __func__));
+	BRCMF_INTR(("%s: registered SDIO interrupt function ok\n", __func__));
 
-	DHD_INFO(("%s: completed!!\n", __func__));
+	BRCMF_INFO(("%s: completed!!\n", __func__));
 
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->drvr);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
-			DHD_ERROR(("%s: dongle is not responding\n", __func__));
+			BRCMF_ERROR(("%s: dongle is not responding\n",
+				     __func__));
 			goto fail;
 		}
 	}
 	/* Ok, have the per-port tell the stack we're open for business */
 	if (brcmf_net_attach(bus->drvr, 0) != 0) {
-		DHD_ERROR(("%s: Net attach failed!!\n", __func__));
+		BRCMF_ERROR(("%s: Net attach failed!!\n", __func__));
 		goto fail;
 	}
 
@@ -5518,7 +5545,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus, SI_ENUM_BASE))
-		DHD_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n", __func__));
+		BRCMF_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n",
+			     __func__));
 
 #ifdef BCMDBG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
@@ -5539,20 +5567,21 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		DHD_ERROR(("brcmf_sdbrcm_probe: ChipClkCSR access: err %d wrote"
-			" 0x%02x read 0x%02x\n",
-			err, BRCMF_INIT_CLKCTL1, clkctl));
+		BRCMF_ERROR(("brcmf_sdbrcm_probe: ChipClkCSR access: err %d"
+			     " wrote 0x%02x read 0x%02x\n",
+			     err, BRCMF_INIT_CLKCTL1, clkctl));
 		goto fail;
 	}
 
 	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
-		DHD_ERROR(("%s: brcmf_sdbrcm_chip_attach failed!\n", __func__));
+		BRCMF_ERROR(("%s: brcmf_sdbrcm_chip_attach failed!\n",
+			     __func__));
 		goto fail;
 	}
 
 	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
-		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
-			   __func__, bus->ci->chip));
+		BRCMF_ERROR(("%s: unsupported chip: 0x%04x\n",
+			     __func__, bus->ci->chip));
 		goto fail;
 	}
 
@@ -5564,16 +5593,16 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 			  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
-			DHD_ERROR(("%s: failed to find SOCRAM memory!\n",
-				   __func__));
+			BRCMF_ERROR(("%s: failed to find SOCRAM memory!\n",
+				     __func__));
 			goto fail;
 		}
 		bus->ramsize = bus->orig_ramsize;
 		if (brcmf_dongle_memsize)
 			brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
 
-		DHD_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
-			   bus->ramsize, bus->orig_ramsize));
+		BRCMF_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
+			     bus->ramsize, bus->orig_ramsize));
 	}
 
 	/* Set core control so an SDIO reset does a backplane reset */
@@ -5601,7 +5630,7 @@ fail:
 
 static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus->drvr->maxctl) {
 		bus->rxblen =
@@ -5609,8 +5638,8 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card)
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
-			DHD_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
-				   __func__, bus->rxblen));
+			BRCMF_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
+				     __func__, bus->rxblen));
 			goto fail;
 		}
 	}
@@ -5618,8 +5647,8 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card)
 	/* Allocate buffer to receive glomed packet */
 	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
 	if (!(bus->databuf)) {
-		DHD_ERROR(("%s: kmalloc of %d-byte databuf failed\n",
-			   __func__, MAX_DATA_BUF));
+		BRCMF_ERROR(("%s: kmalloc of %d-byte databuf failed\n",
+			     __func__, MAX_DATA_BUF));
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
 			kfree(bus->rxbuf);
@@ -5643,7 +5672,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 {
 	s32 fnum;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 #ifdef SDTEST
 	brcmf_sdbrcm_pktgen_init(bus);
@@ -5671,10 +5700,10 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 	if (brcmf_sdcard_iovar_op(card, "sd_blocksize", &fnum, sizeof(s32),
 			    &bus->blocksize, sizeof(s32), false) != 0) {
 		bus->blocksize = 0;
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
+		BRCMF_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
 	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_blocksize", bus->blocksize));
+		BRCMF_INFO(("%s: Initial value for %s is %d\n",
+			    __func__, "sd_blocksize", bus->blocksize));
 	}
 	bus->roundup = min(max_roundup, bus->blocksize);
 
@@ -5685,9 +5714,9 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 			    false) != 0) {
 		bus->sd_rxchain = false;
 	} else {
-		DHD_INFO(("%s: bus module (through sdiocard API) %s chaining\n",
-			  __func__,
-			  (bus->sd_rxchain ? "supports" : "does not support")));
+		BRCMF_INFO(("%s: bus module (through sdiocard API) %s"
+			    " chaining\n", __func__, bus->sd_rxchain
+			    ? "supports" : "does not support"));
 	}
 	bus->use_rxchain = (bool) bus->sd_rxchain;
 
@@ -5712,7 +5741,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card)
 /* Detach and free everything */
 static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus) {
 		/* De-register interrupt handler */
@@ -5730,12 +5759,12 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 		kfree(bus);
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
 
 static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
@@ -5750,7 +5779,7 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
@@ -5764,21 +5793,21 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 		bus->vars = NULL;
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
 
 static void brcmf_sdbrcm_disconnect(void *ptr)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus) {
 		ASSERT(bus->drvr);
 		brcmf_sdbrcm_release(bus);
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
 
 /* Register/Unregister functions are called by the main DHD entry
@@ -5793,7 +5822,7 @@ static struct brcmf_sdioh_driver brcmf_sdio = {
 
 int brcmf_bus_register(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* Sanity check on the module parameters */
 	do {
@@ -5806,7 +5835,7 @@ int brcmf_bus_register(void)
 		    && brcmf_deferred_tx)
 			break;
 
-		DHD_ERROR(("Invalid module parameters.\n"));
+		BRCMF_ERROR(("Invalid module parameters.\n"));
 		return -EINVAL;
 	} while (0);
 
@@ -5815,7 +5844,7 @@ int brcmf_bus_register(void)
 
 void brcmf_bus_unregister(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	brcmf_sdio_unregister();
 }
@@ -5827,21 +5856,22 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 	u8 *memblock = NULL, *memptr;
 	int ret;
 
-	DHD_INFO(("%s: Enter\n", __func__));
+	BRCMF_INFO(("%s: Enter\n", __func__));
 
 	bus->fw_name = BCM4329_FW_NAME;
 	ret = request_firmware(&bus->firmware, bus->fw_name,
 			       &gInstance->func[2]->dev);
 	if (ret) {
-		DHD_ERROR(("%s: Fail to request firmware %d\n", __func__, ret));
+		BRCMF_ERROR(("%s: Fail to request firmware %d\n",
+			     __func__, ret));
 		return ret;
 	}
 	bus->fw_ptr = 0;
 
 	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
-		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			   __func__, MEMBLOCK));
+		BRCMF_ERROR(("%s: Failed to allocate memory %d bytes\n",
+			     __func__, MEMBLOCK));
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -5854,8 +5884,9 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
 		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
 		if (ret) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-			"0x%08x\n", __func__, ret, MEMBLOCK, offset));
+			BRCMF_ERROR(("%s: error %d on writing %d membytes at "
+				     "0x%08x\n", __func__, ret, MEMBLOCK,
+				     offset));
 			goto err;
 		}
 
@@ -5933,15 +5964,15 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 	ret = request_firmware(&bus->firmware, bus->nv_name,
 			       &gInstance->func[2]->dev);
 	if (ret) {
-		DHD_ERROR(("%s: Fail to request nvram %d\n", __func__, ret));
+		BRCMF_ERROR(("%s: Fail to request nvram %d\n", __func__, ret));
 		return ret;
 	}
 	bus->fw_ptr = 0;
 
 	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
-		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			   __func__, MEMBLOCK));
+		BRCMF_ERROR(("%s: Failed to allocate memory %d bytes\n",
+			     __func__, MEMBLOCK));
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -5957,11 +5988,11 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 		if (len)
 			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
 		if (ret)
-			DHD_ERROR(("%s: error downloading vars: %d\n",
-				   __func__, ret));
+			BRCMF_ERROR(("%s: error downloading vars: %d\n",
+				     __func__, ret));
 	} else {
-		DHD_ERROR(("%s: error reading nvram file: %d\n",
-			   __func__, len));
+		BRCMF_ERROR(("%s: error reading nvram file: %d\n",
+			     __func__, len));
 		ret = -EIO;
 	}
 
@@ -5980,27 +6011,28 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 
 	/* Keep arm in reset */
 	if (brcmf_sdbrcm_download_state(bus, true)) {
-		DHD_ERROR(("%s: error placing ARM core in reset\n", __func__));
+		BRCMF_ERROR(("%s: error placing ARM core in reset\n",
+			     __func__));
 		goto err;
 	}
 
 	/* External image takes precedence if specified */
 	if (brcmf_sdbrcm_download_code_file(bus)) {
-		DHD_ERROR(("%s: dongle image file download failed\n",
-			  __func__));
+		BRCMF_ERROR(("%s: dongle image file download failed\n",
+			     __func__));
 		goto err;
 	}
 
 	/* External nvram takes precedence if specified */
 	if (brcmf_sdbrcm_download_nvram(bus)) {
-		DHD_ERROR(("%s: dongle nvram file download failed\n",
-			   __func__));
+		BRCMF_ERROR(("%s: dongle nvram file download failed\n",
+			     __func__));
 	}
 
 	/* Take arm out of reset */
 	if (brcmf_sdbrcm_download_state(bus, false)) {
-		DHD_ERROR(("%s: error getting out of ARM core reset\n",
-			   __func__));
+		BRCMF_ERROR(("%s: error getting out of ARM core reset\n",
+			     __func__));
 		goto err;
 	}
 
@@ -6045,14 +6077,14 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 			bus->drvr->dongle_reset = true;
 			bus->drvr->up = false;
 
-			DHD_TRACE(("%s:  WLAN OFF DONE\n", __func__));
+			BRCMF_TRACE(("%s:  WLAN OFF DONE\n", __func__));
 			/* App can now remove power from device */
 		} else
 			bcmerror = -EIO;
 	} else {
 		/* App must have restored power to device before calling */
 
-		DHD_TRACE(("\n\n%s: == WLAN ON ==\n", __func__));
+		BRCMF_TRACE(("\n\n%s: == WLAN ON ==\n", __func__));
 
 		if (bus->drvr->dongle_reset) {
 			/* Turn on WLAN */
@@ -6069,16 +6101,16 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 					bus->drvr->dongle_reset = false;
 					bus->drvr->up = true;
 
-					DHD_TRACE(("%s: WLAN ON DONE\n",
-						   __func__));
+					BRCMF_TRACE(("%s: WLAN ON DONE\n",
+						     __func__));
 				} else
 					bcmerror = -EIO;
 			} else
 				bcmerror = -EIO;
 		} else {
 			bcmerror = -EISCONN;
-			DHD_ERROR(("%s: Set DEVRESET=false invoked when device "
-				"is on\n", __func__));
+			BRCMF_ERROR(("%s: Set DEVRESET=false invoked when"
+				     " device is on\n", __func__));
 			bcmerror = -EIO;
 		}
 		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
@@ -6104,8 +6136,8 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
-	DHD_INFO(("%s: chipid=0x%x chiprev=%d\n",
-		__func__, ci->chip, ci->chiprev));
+	BRCMF_INFO(("%s: chipid=0x%x chiprev=%d\n",
+		    __func__, ci->chip, ci->chiprev));
 
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
@@ -6116,8 +6148,8 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	default:
-		DHD_ERROR(("%s: chipid 0x%x is not supported\n",
-			__func__, ci->chip));
+		BRCMF_ERROR(("%s: chipid 0x%x is not supported\n",
+			     __func__, ci->chip));
 		return -ENODEV;
 	}
 
@@ -6134,9 +6166,9 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
-	DHD_INFO(("%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		__func__, ci->ccrev, ci->pmurev,
-		ci->buscorerev, ci->buscoretype));
+	BRCMF_INFO(("%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		    __func__, ci->ccrev, ci->pmurev,
+		    ci->buscorerev, ci->buscoretype));
 
 	/* get chipcommon capabilites */
 	ci->cccaps = brcmf_sdcard_reg_read(card,
@@ -6177,7 +6209,7 @@ brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase)
 		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
-			DHD_ERROR(("%s: ARM core still busy\n", __func__));
+			BRCMF_ERROR(("%s: ARM core still busy\n", __func__));
 
 		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbidlow), 4);
@@ -6231,12 +6263,12 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	int err;
 	u8 clkval, clkset;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* alloc chip_info_t */
 	ci = kmalloc(sizeof(struct chip_info), GFP_ATOMIC);
 	if (NULL == ci) {
-		DHD_ERROR(("%s: malloc failed!\n", __func__));
+		BRCMF_ERROR(("%s: malloc failed!\n", __func__));
 		return -ENOMEM;
 	}
 
@@ -6248,7 +6280,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			clkset, &err);
 	if (err) {
-		DHD_ERROR(("%s: error writing for HT off\n", __func__));
+		BRCMF_ERROR(("%s: error writing for HT off\n", __func__));
 		goto fail;
 	}
 
@@ -6264,8 +6296,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				!SBSDIO_ALPAV(clkval)),
 				PMU_MAX_TRANSITION_DLY);
 		if (!SBSDIO_ALPAV(clkval)) {
-			DHD_ERROR(("%s: timeout on ALPAV wait, clkval 0x%02x\n",
-				__func__, clkval));
+			BRCMF_ERROR(("%s: timeout on ALPAV wait,"
+				     " clkval 0x%02x\n", __func__, clkval));
 			err = -EBUSY;
 			goto fail;
 		}
@@ -6276,8 +6308,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				clkset, &err);
 		udelay(65);
 	} else {
-		DHD_ERROR(("%s: ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
-			__func__, clkset, clkval));
+		BRCMF_ERROR(("%s: ChipClkCSR access: wrote 0x%02x"
+			     " read 0x%02x\n", __func__, clkset, clkval));
 		err = -EACCES;
 		goto fail;
 	}
@@ -6435,10 +6467,10 @@ brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus, u32 drivestrength)
 		str_shift = 11;
 		break;
 	default:
-		DHD_ERROR(("No SDIO Drive strength init"
-			"done for chip %s rev %d pmurev %d\n",
-			brcmu_chipname(bus->ci->chip, chn, 8),
-			bus->ci->chiprev, bus->ci->pmurev));
+		BRCMF_ERROR(("No SDIO Drive strength init"
+			     "done for chip %s rev %d pmurev %d\n",
+			     brcmu_chipname(bus->ci->chip, chn, 8),
+			     bus->ci->chiprev, bus->ci->pmurev));
 		break;
 	}
 
@@ -6466,15 +6498,15 @@ brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus, u32 drivestrength)
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
-		DHD_INFO(("SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			drivestrength, cc_data_temp));
+		BRCMF_INFO(("SDIO: %dmA drive strength selected, "
+			    "set to 0x%08x\n", drivestrength, cc_data_temp));
 	}
 }
 
 static void
 brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	kfree(bus->ci);
 	bus->ci = NULL;
-- 
1.7.4.1


