Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab1F2Xth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 051/119] staging: brcm80211: rename dhd_prot and get rid
 of dhd_prot_t typedef
Date: Wed, 29 Jun 2011 16:47:15 -0700
Message-ID: <1309391303-22741-52-git-send-email-frankyl@broadcom.com> (sfid-20110630_015254_992509_1A3A7B65)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The structure dhd_prot has been renamed to brcmf_proto to align with
fullmac naming convention and removed structure typedef dhd_prot_t.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h     |   16 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c |   55 +++++++++++++-------------
 2 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 2cde233..8736e6f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -21,11 +21,6 @@
 #ifndef _dhd_h_
 #define _dhd_h_
 
-/* Forward decls */
-struct dhd_bus;
-struct dhd_prot;
-struct dhd_info;
-
 #define	BRCMF_C_IOCTL_SMLEN	256	/* "small" ioctl buffer required */
 #define BRCMF_C_IOCTL_MEDLEN	1536	/* "med" ioctl buffer required */
 #define	BRCMF_C_IOCTL_MAXLEN	8192
@@ -633,12 +628,17 @@ typedef struct wl_ioctl {
 	uint needed;		/* bytes needed (optional) */
 } wl_ioctl_t;
 
+/* Forward decls for struct dhd_pub (see below) */
+struct dhd_bus;		/* device bus info */
+struct brcmf_proto;	/* device communication protocol info */
+struct dhd_info;	/* device driver info */
+
 /* Common structure for module and instance linkage */
 typedef struct dhd_pub {
 	/* Linkage ponters */
-	struct dhd_bus *bus;	/* Bus module handle */
-	struct dhd_prot *prot;	/* Protocol module handle */
-	struct dhd_info *info;	/* Info module handle */
+	struct dhd_bus *bus;
+	struct brcmf_proto *prot;
+	struct dhd_info *info;
 
 	/* Internal dhd items */
 	bool up;		/* Driver up/down (to OS) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 9828ab1..c544cbf 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -28,7 +28,7 @@
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 
-struct cdc_ioctl {
+struct brcmf_proto_cdc_ioctl {
 	u32 cmd;	/* ioctl command value */
 	u32 len;	/* lower 16: output buflen;
 			 * upper 16: input buflen (excludes header) */
@@ -72,7 +72,7 @@ struct cdc_ioctl {
 	((hdr)->flags2 = (((hdr)->flags2 & ~BDC_FLAG2_IF_MASK) | \
 	((idx) << BDC_FLAG2_IF_SHIFT)))
 
-struct bdc_header {
+struct brcmf_proto_bdc_header {
 	u8 flags;
 	u8 priority;	/* 802.1d Priority, 4:7 flow control info for usb */
 	u8 flags2;
@@ -103,19 +103,20 @@ int wifi_get_mac_addr(unsigned char *buf);
 				 * round off at the end of buffer
 				 */
 
-typedef struct dhd_prot {
+struct brcmf_proto {
 	u16 reqid;
 	u8 pending;
 	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
-	struct cdc_ioctl msg;
+	struct brcmf_proto_cdc_ioctl msg;
 	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
-} dhd_prot_t;
+};
 
 static int brcmf_proto_cdc_msg(dhd_pub_t *dhd)
 {
-	dhd_prot_t *prot = dhd->prot;
-	int len = le32_to_cpu(prot->msg.len) + sizeof(struct cdc_ioctl);
+	struct brcmf_proto *prot = dhd->prot;
+	int len = le32_to_cpu(prot->msg.len) +
+			sizeof(struct brcmf_proto_cdc_ioctl);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -134,14 +135,14 @@ static int brcmf_proto_cdc_msg(dhd_pub_t *dhd)
 static int brcmf_proto_cdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 {
 	int ret;
-	dhd_prot_t *prot = dhd->prot;
+	struct brcmf_proto *prot = dhd->prot;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	do {
 		ret = brcmf_sdbrcm_bus_rxctl(dhd->bus,
-					     (unsigned char *)&prot->msg,
-					     len + sizeof(struct cdc_ioctl));
+				(unsigned char *)&prot->msg,
+				len + sizeof(struct brcmf_proto_cdc_ioctl));
 		if (ret < 0)
 			break;
 	} while (CDC_IOC_ID(le32_to_cpu(prot->msg.flags)) != id);
@@ -153,8 +154,8 @@ int
 brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			    uint len)
 {
-	dhd_prot_t *prot = dhd->prot;
-	struct cdc_ioctl *msg = &prot->msg;
+	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags = 0;
@@ -174,7 +175,7 @@ brcmf_proto_cdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 		}
 	}
 
-	memset(msg, 0, sizeof(struct cdc_ioctl));
+	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
@@ -235,15 +236,15 @@ done:
 int brcmf_proto_cdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd,
 			      void *buf, uint len)
 {
-	dhd_prot_t *prot = dhd->prot;
-	struct cdc_ioctl *msg = &prot->msg;
+	struct brcmf_proto *prot = dhd->prot;
+	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 	int ret = 0;
 	u32 flags, id;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
 
-	memset(msg, 0, sizeof(struct cdc_ioctl));
+	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
@@ -289,7 +290,7 @@ int
 brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf,
 		  int len)
 {
-	dhd_prot_t *prot = dhd->prot;
+	struct brcmf_proto *prot = dhd->prot;
 	int ret = -1;
 
 	if (dhd->busstate == DHD_BUS_DOWN) {
@@ -326,14 +327,14 @@ brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf,
 		ret = brcmf_proto_cdc_query_ioctl(dhd, ifidx, ioc->cmd,
 						  buf, len);
 		if (ret > 0)
-			ioc->used = ret - sizeof(struct cdc_ioctl);
+			ioc->used = ret - sizeof(struct brcmf_proto_cdc_ioctl);
 	}
 
 	/* Too many programs assume ioctl() returns 0 on success */
 	if (ret >= 0)
 		ret = 0;
 	else {
-		struct cdc_ioctl *msg = &prot->msg;
+		struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 		/* len == needed when set/query fails from dongle */
 		ioc->needed = le32_to_cpu(msg->len);
 	}
@@ -380,7 +381,7 @@ void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 
 void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 {
-	struct bdc_header *h;
+	struct brcmf_proto_bdc_header *h;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -388,7 +389,7 @@ void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 
 	skb_push(pktbuf, BDC_HEADER_LEN);
 
-	h = (struct bdc_header *)(pktbuf->data);
+	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
 
 	h->flags = (BDC_PROTO_VER << BDC_FLAG_VER_SHIFT);
 	if (PKTSUMNEEDED(pktbuf))
@@ -402,7 +403,7 @@ void brcmf_proto_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 
 int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 {
-	struct bdc_header *h;
+	struct brcmf_proto_bdc_header *h;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -414,7 +415,7 @@ int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 		return -EBADE;
 	}
 
-	h = (struct bdc_header *)(pktbuf->data);
+	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
 
 	*ifidx = BDC_GET_IF_IDX(h);
 	if (*ifidx >= DHD_MAX_IFS) {
@@ -446,9 +447,9 @@ int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 
 int brcmf_proto_attach(dhd_pub_t *dhd)
 {
-	dhd_prot_t *cdc;
+	struct brcmf_proto *cdc;
 
-	cdc = kzalloc(sizeof(dhd_prot_t), GFP_ATOMIC);
+	cdc = kzalloc(sizeof(struct brcmf_proto), GFP_ATOMIC);
 	if (!cdc) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -456,14 +457,14 @@ int brcmf_proto_attach(dhd_pub_t *dhd)
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		DHD_ERROR(("dhd_prot_t is not correctly defined\n"));
+		DHD_ERROR(("struct brcmf_proto is not correctly defined\n"));
 		goto fail;
 	}
 
 	dhd->prot = cdc;
 	dhd->hdrlen += BDC_HEADER_LEN;
 	dhd->maxctl = BRCMF_C_IOCTL_MAXLEN +
-				sizeof(struct cdc_ioctl) + ROUND_UP_MARGIN;
+			sizeof(struct brcmf_proto_cdc_ioctl) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
-- 
1.7.1


