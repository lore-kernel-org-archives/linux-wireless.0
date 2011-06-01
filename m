Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2296 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 50/83] staging: brcm80211: absorb bcmcdc.h into
 dhd_cdc.c
Date: Wed, 1 Jun 2011 13:45:35 +0200
Message-ID: <1306928768-7501-50-git-send-email-rvossen@broadcom.com> (sfid-20110601_134708_128499_D6BD980B)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Merge bcmcdc.h into dhd_cdc.c in fullmac as it's only used by
dhd_cdc.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmcdc.h  |   98 --------------------------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c |   75 +++++++++++++++++---
 2 files changed, 64 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmcdc.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmcdc.h b/drivers/staging/brcm80211/brcmfmac/bcmcdc.h
deleted file mode 100644
index ed4c4a5..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmcdc.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#include <linux/if_ether.h>
-
-typedef struct cdc_ioctl {
-	u32 cmd;		/* ioctl command value */
-	u32 len;		/* lower 16: output buflen; upper 16:
-				 input buflen (excludes header) */
-	u32 flags;		/* flag defns given below */
-	u32 status;		/* status code returned from the device */
-} cdc_ioctl_t;
-
-/* Max valid buffer size that can be sent to the dongle */
-#define CDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
-
-/* len field is divided into input and output buffer lengths */
-#define CDCL_IOC_OUTLEN_MASK   0x0000FFFF	/* maximum or expected
-						 response length, */
-					   /* excluding IOCTL header */
-#define CDCL_IOC_OUTLEN_SHIFT  0
-#define CDCL_IOC_INLEN_MASK    0xFFFF0000	/* input buffer length,
-						 excluding IOCTL header */
-#define CDCL_IOC_INLEN_SHIFT   16
-
-/* CDC flag definitions */
-#define CDCF_IOC_ERROR		0x01	/* 0=success, 1=ioctl cmd failed */
-#define CDCF_IOC_SET		0x02	/* 0=get, 1=set cmd */
-#define CDCF_IOC_IF_MASK	0xF000	/* I/F index */
-#define CDCF_IOC_IF_SHIFT	12
-#define CDCF_IOC_ID_MASK	0xFFFF0000	/* used to uniquely id an ioctl
-						 req/resp pairing */
-#define CDCF_IOC_ID_SHIFT	16	/* # of bits of shift for ID Mask */
-
-#define CDC_IOC_IF_IDX(flags)	\
-	(((flags) & CDCF_IOC_IF_MASK) >> CDCF_IOC_IF_SHIFT)
-#define CDC_IOC_ID(flags)	\
-	(((flags) & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT)
-
-#define CDC_GET_IF_IDX(hdr) \
-	((int)((((hdr)->flags) & CDCF_IOC_IF_MASK) >> CDCF_IOC_IF_SHIFT))
-#define CDC_SET_IF_IDX(hdr, idx) \
-	((hdr)->flags = (((hdr)->flags & ~CDCF_IOC_IF_MASK) | \
-	((idx) << CDCF_IOC_IF_SHIFT)))
-
-/*
- * BDC header
- *
- *   The BDC header is used on data packets to convey priority across USB.
- */
-
-#define	BDC_HEADER_LEN		4
-
-#define BDC_PROTO_VER		1	/* Protocol version */
-
-#define BDC_FLAG_VER_MASK	0xf0	/* Protocol version mask */
-#define BDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
-
-#define BDC_FLAG__UNUSED	0x03	/* Unassigned */
-#define BDC_FLAG_SUM_GOOD	0x04	/* Dongle has verified good
-					 RX checksums */
-#define BDC_FLAG_SUM_NEEDED	0x08	/* Dongle needs to do TX checksums */
-
-#define BDC_PRIORITY_MASK	0x7
-
-#define BDC_FLAG2_FC_FLAG	0x10	/* flag to indicate if pkt contains */
-						/* FLOW CONTROL info only */
-#define BDC_PRIORITY_FC_SHIFT	4	/* flow control info shift */
-
-#define BDC_FLAG2_IF_MASK	0x0f	/* APSTA: interface on which the
-					 packet was received */
-#define BDC_FLAG2_IF_SHIFT	0
-
-#define BDC_GET_IF_IDX(hdr) \
-	((int)((((hdr)->flags2) & BDC_FLAG2_IF_MASK) >> BDC_FLAG2_IF_SHIFT))
-#define BDC_SET_IF_IDX(hdr, idx) \
-	((hdr)->flags2 = (((hdr)->flags2 & ~BDC_FLAG2_IF_MASK) | \
-	((idx) << BDC_FLAG2_IF_SHIFT)))
-
-struct bdc_header {
-	u8 flags;		/* Flags */
-	u8 priority;		/* 802.1d Priority 0:2 bits, 4:7 flow
-				 control info for usb */
-	u8 flags2;
-	u8 rssi;
-};
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index ba5a5cb..424eacb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -19,13 +19,65 @@
 #include <bcmdefs.h>
 
 #include <bcmutils.h>
-#include <bcmcdc.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhd_proto.h>
 #include <dhd_bus.h>
 #include <dhd_dbg.h>
+
+struct cdc_ioctl {
+	u32 cmd;	/* ioctl command value */
+	u32 len;	/* lower 16: output buflen;
+			 * upper 16: input buflen (excludes header) */
+	u32 flags;	/* flag defns given below */
+	u32 status;	/* status code returned from the device */
+};
+
+/* Max valid buffer size that can be sent to the dongle */
+#define CDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
+
+/* CDC flag definitions */
+#define CDCF_IOC_ERROR		0x01		/* 1=ioctl cmd failed */
+#define CDCF_IOC_SET		0x02		/* 0=get, 1=set cmd */
+#define CDCF_IOC_IF_MASK	0xF000		/* I/F index */
+#define CDCF_IOC_IF_SHIFT	12
+#define CDCF_IOC_ID_MASK	0xFFFF0000	/* id an ioctl pairing */
+#define CDCF_IOC_ID_SHIFT	16		/* ID Mask shift bits */
+#define CDC_IOC_ID(flags)	\
+	(((flags) & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT)
+#define CDC_SET_IF_IDX(hdr, idx) \
+	((hdr)->flags = (((hdr)->flags & ~CDCF_IOC_IF_MASK) | \
+	((idx) << CDCF_IOC_IF_SHIFT)))
+
+/*
+ * BDC header
+ * Used on data packets to convey priority across USB.
+ */
+#define	BDC_HEADER_LEN		4
+#define BDC_PROTO_VER		1	/* Protocol version */
+#define BDC_FLAG_VER_MASK	0xf0	/* Protocol version mask */
+#define BDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
+#define BDC_FLAG_SUM_GOOD	0x04	/* Good RX checksums */
+#define BDC_FLAG_SUM_NEEDED	0x08	/* Dongle needs to do TX checksums */
+#define BDC_PRIORITY_MASK	0x7
+#define BDC_FLAG2_IF_MASK	0x0f	/* packet rx interface in APSTA */
+#define BDC_FLAG2_IF_SHIFT	0
+
+#define BDC_GET_IF_IDX(hdr) \
+	((int)((((hdr)->flags2) & BDC_FLAG2_IF_MASK) >> BDC_FLAG2_IF_SHIFT))
+#define BDC_SET_IF_IDX(hdr, idx) \
+	((hdr)->flags2 = (((hdr)->flags2 & ~BDC_FLAG2_IF_MASK) | \
+	((idx) << BDC_FLAG2_IF_SHIFT)))
+
+struct bdc_header {
+	u8 flags;
+	u8 priority;	/* 802.1d Priority, 4:7 flow control info for usb */
+	u8 flags2;
+	u8 rssi;
+};
+
+
 #ifdef CUSTOMER_HW2
 int wifi_get_mac_addr(unsigned char *buf);
 #endif
@@ -56,14 +108,14 @@ typedef struct dhd_prot {
 	u8 pending;
 	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
-	cdc_ioctl_t msg;
+	struct cdc_ioctl msg;
 	unsigned char buf[WLC_IOCTL_MAXLEN + ROUND_UP_MARGIN];
 } dhd_prot_t;
 
 static int dhdcdc_msg(dhd_pub_t *dhd)
 {
 	dhd_prot_t *prot = dhd->prot;
-	int len = le32_to_cpu(prot->msg.len) + sizeof(cdc_ioctl_t);
+	int len = le32_to_cpu(prot->msg.len) + sizeof(struct cdc_ioctl);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -88,7 +140,7 @@ static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 	do {
 		ret =
 		    dhd_bus_rxctl(dhd->bus, (unsigned char *)&prot->msg,
-				  len + sizeof(cdc_ioctl_t));
+				  len + sizeof(struct cdc_ioctl));
 		if (ret < 0)
 			break;
 	} while (CDC_IOC_ID(le32_to_cpu(prot->msg.flags)) != id);
@@ -100,7 +152,7 @@ int
 dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 {
 	dhd_prot_t *prot = dhd->prot;
-	cdc_ioctl_t *msg = &prot->msg;
+	struct cdc_ioctl *msg = &prot->msg;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags = 0;
@@ -120,7 +172,7 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 		}
 	}
 
-	memset(msg, 0, sizeof(cdc_ioctl_t));
+	memset(msg, 0, sizeof(struct cdc_ioctl));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
@@ -180,14 +232,14 @@ done:
 int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 {
 	dhd_prot_t *prot = dhd->prot;
-	cdc_ioctl_t *msg = &prot->msg;
+	struct cdc_ioctl *msg = &prot->msg;
 	int ret = 0;
 	u32 flags, id;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
 
-	memset(msg, 0, sizeof(cdc_ioctl_t));
+	memset(msg, 0, sizeof(struct cdc_ioctl));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
@@ -266,14 +318,14 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 	else {
 		ret = dhdcdc_query_ioctl(dhd, ifidx, ioc->cmd, buf, len);
 		if (ret > 0)
-			ioc->used = ret - sizeof(cdc_ioctl_t);
+			ioc->used = ret - sizeof(struct cdc_ioctl);
 	}
 
 	/* Too many programs assume ioctl() returns 0 on success */
 	if (ret >= 0)
 		ret = 0;
 	else {
-		cdc_ioctl_t *msg = &prot->msg;
+		struct cdc_ioctl *msg = &prot->msg;
 		/* len == needed when set/query fails from dongle */
 		ioc->needed = le32_to_cpu(msg->len);
 	}
@@ -411,7 +463,8 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 #ifdef BDC
 	dhd->hdrlen += BDC_HEADER_LEN;
 #endif
-	dhd->maxctl = WLC_IOCTL_MAXLEN + sizeof(cdc_ioctl_t) + ROUND_UP_MARGIN;
+	dhd->maxctl =
+		WLC_IOCTL_MAXLEN + sizeof(struct cdc_ioctl) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
-- 
1.7.4.1


