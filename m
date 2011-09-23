Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2371 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/19] staging: brcm80211: sparse endianness warnings
 for struct brcmf_proto_cdc_ioctl
Date: Thu, 22 Sep 2011 17:07:40 -0700
Message-ID: <1316736476-23725-4-git-send-email-frankyl@broadcom.com> (sfid-20110923_020822_099017_6A94DDA5)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structure that is send/received to/from dongle has been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 6f65683..28bdf9e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -28,11 +28,11 @@
 #include "dhd_dbg.h"
 
 struct brcmf_proto_cdc_ioctl {
-	u32 cmd;	/* ioctl command value */
-	u32 len;	/* lower 16: output buflen;
+	__le32 cmd;	/* ioctl command value */
+	__le32 len;	/* lower 16: output buflen;
 			 * upper 16: input buflen (excludes header) */
-	u32 flags;	/* flag defns given below */
-	u32 status;	/* status code returned from the device */
+	__le32 flags;	/* flag defns given below */
+	__le32 status;	/* status code returned from the device */
 };
 
 /* Max valid buffer size that can be sent to the dongle */
@@ -47,9 +47,6 @@ struct brcmf_proto_cdc_ioctl {
 #define CDCF_IOC_ID_SHIFT	16		/* ID Mask shift bits */
 #define CDC_IOC_ID(flags)	\
 	(((flags) & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT)
-#define CDC_SET_IF_IDX(hdr, idx) \
-	((hdr)->flags = (((hdr)->flags & ~CDCF_IOC_IF_MASK) | \
-	((idx) << CDCF_IOC_IF_SHIFT)))
 
 /*
  * BDC header - Broadcom specific extension of CDC.
@@ -144,7 +141,7 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
 	void *info;
 	int ret = 0, retries = 0;
-	u32 id, flags = 0;
+	u32 id, flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
@@ -165,9 +162,9 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	msg->flags = (++prot->reqid << CDCF_IOC_ID_SHIFT);
-	CDC_SET_IF_IDX(msg, ifidx);
-	msg->flags = cpu_to_le32(msg->flags);
+	flags = (++prot->reqid << CDCF_IOC_ID_SHIFT);
+	flags = (flags & ~CDCF_IOC_IF_MASK) | (ifidx << CDCF_IOC_IF_SHIFT);
+	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
 		memcpy(prot->buf, buf, len);
@@ -233,9 +230,9 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	msg->flags = (++prot->reqid << CDCF_IOC_ID_SHIFT) | CDCF_IOC_SET;
-	CDC_SET_IF_IDX(msg, ifidx);
-	msg->flags = cpu_to_le32(msg->flags);
+	flags = (++prot->reqid << CDCF_IOC_ID_SHIFT) | CDCF_IOC_SET;
+	flags = (flags & ~CDCF_IOC_IF_MASK) | (ifidx << CDCF_IOC_IF_SHIFT);
+	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
 		memcpy(prot->buf, buf, len);
-- 
1.7.1


