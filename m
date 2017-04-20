Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:12534 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S970871AbdDTPrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 11:47:11 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3KFgaKa023645
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 16:47:09 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx07-00252a01.pphosted.com with ESMTP id 29wqp2rvhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 16:47:09 +0100
Received: by mail-wr0-f200.google.com with SMTP id 6so2642652wrt.20
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 08:47:09 -0700 (PDT)
From: James Hughes <james.hughes@raspberrypi.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: James Hughes <james.hughes@raspberrypi.org>
Subject: [PATCH] brcm80211: brcmfmac: Ensure header writes are on writable skb
Date: Thu, 20 Apr 2017 16:47:04 +0100
Message-Id: <20170420154704.32144-1-james.hughes@raspberrypi.org> (sfid-20170420_174723_074114_D49683F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver was writing to skb header area without ensuring it was
writable i.e. uncloned.

Used skb_cow_header to ensure that header buffer is large enough
and is uncloned.

Detected when, in combination with the smsc85xx driver, both drivers
attempted to write different headers to the same header buffer.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 038a960..b9d7d08 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -249,14 +249,19 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	return ret;
 }
 
-static void
+static int
 brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bcdc_header *h;
+	int err;
 
 	brcmf_dbg(BCDC, "Enter\n");
 
+	err = skb_cow_head(pktbuf, BCDC_HEADER_LEN);
+	if (err)
+		return err;
+
 	/* Push BDC header used to convey priority for buses that don't */
 	skb_push(pktbuf, BCDC_HEADER_LEN);
 
@@ -271,6 +276,8 @@ brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 	h->data_offset = offset;
 	BCDC_SET_IF_IDX(h, ifidx);
 	trace_brcmf_bcdchdr(pktbuf->data);
+
+	return 0;
 }
 
 static int
@@ -330,7 +337,11 @@ static int
 brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			struct sk_buff *pktbuf)
 {
-	brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
+	int err = brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
+
+	if (err)
+		return err;
+
 	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
 }
 
-- 
2.9.3
