Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51778 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3LLK7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:20 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/18] brcmfmac: Move common BCDC code in single function.
Date: Thu, 12 Dec 2013 11:59:00 +0100
Message-ID: <1386845946-9859-13-git-send-email-arend@broadcom.com> (sfid-20131212_122459_985395_BDE2553A)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The BCDC functions query_dcmd and set_dcmd both create a msgbuf to
be sent to dongle this code is very similar and for optimisation
best put in a function.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c |   68 +++++++++---------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 06848e4..ee86142 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -101,35 +101,41 @@ struct brcmf_proto_bcdc_header {
 					 * plus any space that might be needed
 					 * for bus alignment padding.
 					 */
-#define ROUND_UP_MARGIN	2048	/* Biggest bus block size possible for
-				 * round off at the end of buffer
-				 * Currently is SDIO
-				 */
-
 struct brcmf_bcdc {
 	u16 reqid;
 	u8 bus_header[BUS_HEADER_LEN];
 	struct brcmf_proto_bcdc_dcmd msg;
-	unsigned char buf[BRCMF_DCMD_MAXLEN + ROUND_UP_MARGIN];
+	unsigned char buf[BRCMF_DCMD_MAXLEN];
 };
 
-static int brcmf_proto_bcdc_msg(struct brcmf_pub *drvr)
+
+static int
+brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
+		     uint len, bool set)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
-	int len = le32_to_cpu(bcdc->msg.len) +
-			sizeof(struct brcmf_proto_bcdc_dcmd);
+	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
+	u32 flags;
 
 	brcmf_dbg(BCDC, "Enter\n");
 
-	/* NOTE : bcdc->msg.len holds the desired length of the buffer to be
-	 *        returned. Only up to BCDC_MAX_MSG_SIZE of this buffer area
-	 *        is actually sent to the dongle
-	 */
-	if (len > BCDC_MAX_MSG_SIZE)
-		len = BCDC_MAX_MSG_SIZE;
+	memset(msg, 0, sizeof(struct brcmf_proto_bcdc_dcmd));
+
+	msg->cmd = cpu_to_le32(cmd);
+	msg->len = cpu_to_le32(len);
+	flags = (++bcdc->reqid << BCDC_DCMD_ID_SHIFT);
+	if (set)
+		flags |= BCDC_DCMD_SET;
+	flags = (flags & ~BCDC_DCMD_IF_MASK) |
+		(ifidx << BCDC_DCMD_IF_SHIFT);
+	msg->flags = cpu_to_le32(flags);
+
+	if (buf)
+		memcpy(bcdc->buf, buf, len);
 
 	/* Send request */
-	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
+	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg,
+			       len + sizeof(struct brcmf_proto_bcdc_dcmd));
 }
 
 static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
@@ -161,19 +167,7 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
-	memset(msg, 0, sizeof(struct brcmf_proto_bcdc_dcmd));
-
-	msg->cmd = cpu_to_le32(cmd);
-	msg->len = cpu_to_le32(len);
-	flags = (++bcdc->reqid << BCDC_DCMD_ID_SHIFT);
-	flags = (flags & ~BCDC_DCMD_IF_MASK) |
-		(ifidx << BCDC_DCMD_IF_SHIFT);
-	msg->flags = cpu_to_le32(flags);
-
-	if (buf)
-		memcpy(bcdc->buf, buf, len);
-
-	ret = brcmf_proto_bcdc_msg(drvr);
+	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
 	if (ret < 0) {
 		brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
 			  ret);
@@ -227,19 +221,7 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
-	memset(msg, 0, sizeof(struct brcmf_proto_bcdc_dcmd));
-
-	msg->cmd = cpu_to_le32(cmd);
-	msg->len = cpu_to_le32(len);
-	flags = (++bcdc->reqid << BCDC_DCMD_ID_SHIFT) | BCDC_DCMD_SET;
-	flags = (flags & ~BCDC_DCMD_IF_MASK) |
-		(ifidx << BCDC_DCMD_IF_SHIFT);
-	msg->flags = cpu_to_le32(flags);
-
-	if (buf)
-		memcpy(bcdc->buf, buf, len);
-
-	ret = brcmf_proto_bcdc_msg(drvr);
+	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, true);
 	if (ret < 0)
 		goto done;
 
@@ -369,7 +351,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
 	drvr->bus_if->maxctl = BRCMF_DCMD_MAXLEN +
-			sizeof(struct brcmf_proto_bcdc_dcmd) + ROUND_UP_MARGIN;
+			sizeof(struct brcmf_proto_bcdc_dcmd);
 	return 0;
 
 fail:
-- 
1.7.10.4

