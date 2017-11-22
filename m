Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0101.outbound.protection.outlook.com ([104.47.38.101]:4849
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751867AbdKVJEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 04:04:49 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: transfer firmware error to Linux error code in fwil
Date: Wed, 22 Nov 2017 17:11:16 +0800
Message-Id: <1511341876-10198-1-git-send-email-wright.feng@cypress.com> (sfid-20171122_100717_870478_CB2EA2CC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fil_cmd_data_set and fil_cmd_data_get return proprietary error code
when getting error from firmware layer. The vendor tools or utilities
that uses libnl may stuck in some commands when wl is down.
For example, issue "scan" command after issuing "down" command, the
"scan" command will be the blocking call and stuck as no response from
libnl. It is caused by that firmware returns BCME_NOTUP(-4) when wl
is down, but the -4 is -EINTR in Linux kernel, so libnl catches the
error and not passes to upper layer.
Because of that, the fwil should return Linux error code instead of
the proprietary error code, and the tools or utilities should get the
real firmware error code by command "bcmerror" or "bcmerrorstr" after
receiving the error from libnl.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 12 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    | 80 ++++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 13 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   | 14 ++--
 4 files changed, 101 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 9f2d0b0..44faae4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -165,7 +165,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 static int
 brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			    void *buf, uint len)
+			    void *buf, uint len, bool *is_fwerr)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
@@ -212,8 +212,10 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	}
 
 	/* Check the ERROR flag */
-	if (flags & BCDC_DCMD_ERROR)
+	if (flags & BCDC_DCMD_ERROR) {
+		*is_fwerr = true;
 		ret = le32_to_cpu(msg->status);
+	}
 
 done:
 	return ret;
@@ -221,7 +223,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 static int
 brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			  void *buf, uint len)
+			  void *buf, uint len, bool *is_fwerr)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
@@ -250,8 +252,10 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	}
 
 	/* Check the ERROR flag */
-	if (flags & BCDC_DCMD_ERROR)
+	if (flags & BCDC_DCMD_ERROR) {
+		*is_fwerr = true;
 		ret = le32_to_cpu(msg->status);
+	}
 
 done:
 	return ret;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f6a2df9..1a1beaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -32,6 +32,70 @@
 
 #define MAX_HEX_DUMP_LEN	64
 
+static u32 brcmf_fil_errormap[] = {
+	0,		/* BCME_OK */
+	EIO,		/* BCME_ERROR */
+	EINVAL,		/* BCME_BADARG */
+	EINVAL,		/* BCME_BADOPTION */
+	ENETDOWN,	/* BCME_NOTUP */
+	EIO,		/* BCME_NOTDOWN */
+	EIO,		/* BCME_NOTAP */
+	EIO,		/* BCME_NOTSTA */
+	EINVAL,		/* BCME_BADKEYIDX */
+	EIO,		/* BCME_RADIOOFF */
+	EIO,		/* BCME_NOTBANDLOCKED */
+	EIO,		/* BCME_NOCLK */
+	EINVAL,		/* BCME_BADRATESET */
+	EINVAL,		/* BCME_BADBAND */
+	EINVAL,		/* BCME_BUFTOOSHORT */
+	EINVAL,		/* BCME_BUFTOOLONG */
+	EBUSY,		/* BCME_BUSY */
+	ENOTCONN,	/* BCME_NOTASSOCIATED */
+	EINVAL,		/* BCME_BADSSIDLEN */
+	EINVAL,		/* BCME_OUTOFRANGECHAN */
+	EINVAL,		/* BCME_BADCHAN */
+	EFAULT,		/* BCME_BADADDR */
+	ENOMEM,		/* BCME_NORESOURCE */
+	ENOTSUPP,	/* BCME_UNSUPPORTED */
+	EINVAL,		/* BCME_BADLEN */
+	EIO,		/* BCME_NOTREADY */
+	EPERM,		/* BCME_EPERM */
+	ENOMEM,		/* BCME_NOMEM */
+	ENOTCONN,	/* BCME_ASSOCIATED */
+	EINVAL,		/* BCME_RANGE */
+	ENXIO,		/* BCME_NOTFOUND */
+	EIO,		/* BCME_WME_NOT_ENABLED */
+	ENXIO,		/* BCME_TSPEC_NOTFOUND */
+	ENOTSUPP,	/* BCME_ACM_NOTSUPPORTED */
+	ENOTCONN,	/* BCME_NOT_WME_ASSOCIATION */
+	EIO,		/* BCME_SDIO_ERROR */
+	ENETDOWN,	/* BCME_DONGLE_DOWN */
+	EIO,		/* BCME_VERSION */
+	EIO,		/* BCME_TXFAIL */
+	EIO,		/* BCME_RXFAIL */
+	ENXIO,		/* BCME_NODEVICE */
+	EIO,		/* BCME_NMODE_DISABLED */
+	EIO,		/* BCME_NONRESIDENT */
+	EIO,		/* BCME_SCANREJECT */
+	EINVAL,		/* BCME_USAGE_ERROR */
+	EIO,		/* BCME_IOCTL_ERROR */
+	EIO,		/* BCME_SERIAL_PORT_ERR */
+	EIO,		/* BCME_DISABLED */
+	EIO,		/* BCME_DECERR */
+	EIO,		/* BCME_ENCERR */
+	EIO,		/* BCME_MICERR */
+	EIO,		/* BCME_REPLAY */
+	ENXIO,		/* BCME_IE_NOTFOUND */
+};
+
+static s32 brcmf_fil_transfer_linuxerr(s32 fw_err)
+{
+	if (-fw_err >= ARRAY_SIZE(brcmf_fil_errormap))
+		return -EIO;
+
+	return -brcmf_fil_errormap[-fw_err];
+}
+
 #ifdef DEBUG
 static const char * const brcmf_fil_errstr[] = {
 	"BCME_OK",
@@ -107,6 +171,7 @@ static const char *brcmf_fil_get_errstr(u32 err)
 brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	bool is_fwerr = false;
 	s32 err;
 
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
@@ -117,15 +182,22 @@ static const char *brcmf_fil_get_errstr(u32 err)
 	if (data != NULL)
 		len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
 	if (set)
-		err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd, data, len);
+		err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd, data, len,
+					   &is_fwerr);
 	else
-		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
+		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len,
+					     &is_fwerr);
 
 	if (err >= 0)
 		return 0;
 
-	brcmf_dbg(FIL, "Failed: %s (%d)\n",
-		  brcmf_fil_get_errstr((u32)(-err)), err);
+	if (is_fwerr) {
+		brcmf_dbg(FIL, "Failed: %s (%d)\n",
+			  brcmf_fil_get_errstr((u32)(-err)), err);
+		err = brcmf_fil_transfer_linuxerr(err);
+	} else {
+		brcmf_dbg(FIL, "Failed: err (%d)\n", err);
+	}
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index d2c834c..ce90871 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -477,7 +477,8 @@ static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
 
 
 static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
-				   uint cmd, void *buf, uint len)
+				   uint cmd, void *buf, uint len,
+				   bool *is_fwerr)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
@@ -508,14 +509,18 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 	}
 	brcmu_pkt_buf_free_skb(skb);
 
-	return msgbuf->ioctl_resp_status;
+	err = msgbuf->ioctl_resp_status;
+	if (err < 0)
+		*is_fwerr = true;
+
+	return err;
 }
 
 
 static int brcmf_msgbuf_set_dcmd(struct brcmf_pub *drvr, int ifidx,
-				 uint cmd, void *buf, uint len)
+				 uint cmd, void *buf, uint len, bool *is_fwerr)
 {
-	return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len);
+	return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len, is_fwerr);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 2404f8a..7bd0f63 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -30,9 +30,9 @@ struct brcmf_proto {
 	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
 		       struct sk_buff *skb, struct brcmf_if **ifp);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			  void *buf, uint len);
+			  void *buf, uint len, bool *is_fwerr);
 	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
-			uint len);
+			uint len, bool *is_fwerr);
 	int (*tx_queue_data)(struct brcmf_pub *drvr, int ifidx,
 			     struct sk_buff *skb);
 	int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
@@ -71,14 +71,16 @@ static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
 }
 static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int ifidx,
-					 uint cmd, void *buf, uint len)
+					 uint cmd, void *buf, uint len,
+					 bool *is_fwerr)
 {
-	return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len);
+	return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len, is_fwerr);
 }
 static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
-				       uint cmd, void *buf, uint len)
+				       uint cmd, void *buf, uint len,
+				       bool *is_fwerr)
 {
-	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
+	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len, is_fwerr);
 }
 
 static inline int brcmf_proto_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
-- 
1.9.1
