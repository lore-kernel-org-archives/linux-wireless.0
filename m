Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58007 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751140AbeAVUqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 15:46:47 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: separate firmware errors from i/o errors
Date: Mon, 22 Jan 2018 21:46:40 +0100
Message-Id: <1516654000-25314-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180122_214653_001834_FC40E1C7)
In-Reply-To: <1516654000-25314-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1516654000-25314-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the firmware api it can fail simply because firmware does
not like the request or it fails due to issues in the host interface.
Currently, there is only a single error code which is confusing. So
adding a parameter to pass the firmware error separately and in case
of a firmware error always return -EBADE to user-space.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 11 ++++++-----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c  | 16 +++++++++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c    | 10 ++++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 14 ++++++++------
 4 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index bd6da05..2d3a5dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -165,7 +165,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 static int
 brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			    void *buf, uint len)
+			    void *buf, uint len, int *fwerr)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
@@ -175,6 +175,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
+	*fwerr = 0;
 	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
 	if (ret < 0) {
 		brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
@@ -215,15 +216,14 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 	/* Check the ERROR flag */
 	if (flags & BCDC_DCMD_ERROR)
-		ret = le32_to_cpu(msg->status);
-
+		*fwerr = le32_to_cpu(msg->status);
 done:
 	return ret;
 }
 
 static int
 brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			  void *buf, uint len)
+			  void *buf, uint len, int *fwerr)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
@@ -232,6 +232,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
+	*fwerr = 0;
 	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, true);
 	if (ret < 0)
 		goto done;
@@ -255,7 +256,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 
 	/* Check the ERROR flag */
 	if (flags & BCDC_DCMD_ERROR)
-		ret = le32_to_cpu(msg->status);
+		*fwerr = le32_to_cpu(msg->status);
 
 done:
 	return ret;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index d328aae..f2cfdd3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -107,7 +107,7 @@ static const char *brcmf_fil_get_errstr(u32 err)
 brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
-	s32 err;
+	s32 err, fwerr;
 
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
 		brcmf_err("bus is down. we have nothing to do.\n");
@@ -117,14 +117,20 @@ static const char *brcmf_fil_get_errstr(u32 err)
 	if (data != NULL)
 		len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
 	if (set)
-		err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd, data, len);
+		err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd,
+					   data, len, &fwerr);
 	else
-		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
+		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd,
+					     data, len, &fwerr);
 
-	if (err)
+	if (err) {
 		brcmf_dbg(FIL, "Failed: %s (%d)\n",
 			  brcmf_fil_get_errstr((u32)(-err)), err);
-
+	} else if (fwerr < 0) {
+		brcmf_dbg(FIL, "Firmware error: %s (%d)\n",
+			  brcmf_fil_get_errstr((u32)(-fwerr)), fwerr);
+		err = -EBADE;
+	}
 	return err;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index d2c834c..e212a79 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -477,7 +477,7 @@ static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
 
 
 static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
-				   uint cmd, void *buf, uint len)
+				   uint cmd, void *buf, uint len, int *fwerr)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
@@ -485,6 +485,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 	int err;
 
 	brcmf_dbg(MSGBUF, "ifidx=%d, cmd=%d, len=%d\n", ifidx, cmd, len);
+	*fwerr = 0;
 	msgbuf->ctl_completed = false;
 	err = brcmf_msgbuf_tx_ioctl(drvr, ifidx, cmd, buf, len);
 	if (err)
@@ -508,14 +509,15 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 	}
 	brcmu_pkt_buf_free_skb(skb);
 
-	return msgbuf->ioctl_resp_status;
+	*fwerr = msgbuf->ioctl_resp_status;
+	return 0;
 }
 
 
 static int brcmf_msgbuf_set_dcmd(struct brcmf_pub *drvr, int ifidx,
-				 uint cmd, void *buf, uint len)
+				 uint cmd, void *buf, uint len, int *fwerr)
 {
-	return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len);
+	return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len, fwerr);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 2404f8a..8a8e08f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -30,9 +30,9 @@ struct brcmf_proto {
 	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
 		       struct sk_buff *skb, struct brcmf_if **ifp);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			  void *buf, uint len);
+			  void *buf, uint len, int *fwerr);
 	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
-			uint len);
+			uint len, int *fwerr);
 	int (*tx_queue_data)(struct brcmf_pub *drvr, int ifidx,
 			     struct sk_buff *skb);
 	int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
@@ -71,14 +71,16 @@ static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
 }
 static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int ifidx,
-					 uint cmd, void *buf, uint len)
+					 uint cmd, void *buf, uint len,
+					 int *fwerr)
 {
-	return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len);
+	return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len,fwerr);
 }
 static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
-				       uint cmd, void *buf, uint len)
+				       uint cmd, void *buf, uint len,
+				       int *fwerr)
 {
-	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
+	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len, fwerr);
 }
 
 static inline int brcmf_proto_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
-- 
1.9.1
