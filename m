Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:47992 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:25 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 07/21] brcmfmac: Split buff_rw function up + cleanup annoying bcmerror variable
Date: Sun, 16 Jul 2017 12:21:15 +0100
Message-Id: <20170716112129.10206-8-ian@mnementh.co.uk> (sfid-20170716_134529_360352_2004FD1F)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 76 +++++++++++++++-------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 06e6a72245a7..0d5004e18cb0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -458,8 +458,8 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
-			     bool write, u32 addr, struct sk_buff *pkt)
+static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
+				u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
 	int err;
@@ -468,18 +468,36 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	if (write)
-		err = sdio_memcpy_toio(sdiodev->func[fn], addr,
-				       ((u8 *)(pkt->data)), req_sz);
-	else if (fn == 1)
-		err = sdio_memcpy_fromio(sdiodev->func[fn], ((u8 *)(pkt->data)),
-					 addr, req_sz);
+	if (fn == 1)
+		err = sdio_memcpy_fromio(sdiodev->func[fn],
+				((u8 *)(pkt->data)), addr, req_sz);
 	else
 		/* function 2 read is FIFO operation */
-		err = sdio_readsb(sdiodev->func[fn], ((u8 *)(pkt->data)), addr,
-				  req_sz);
+		err = sdio_readsb(sdiodev->func[fn],
+				((u8 *)(pkt->data)), addr, req_sz);
+
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+
+	return err;
+}
+
+static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
+				u32 addr, struct sk_buff *pkt)
+{
+	unsigned int req_sz;
+	int err;
+
+	/* Single skb use the standard mmc interface */
+	req_sz = pkt->len + 3;
+	req_sz &= (uint)~3;
+
+	err = sdio_memcpy_toio(sdiodev->func[fn], addr,
+			       ((u8 *)(pkt->data)), req_sz);
+
+	if (err == -ENOMEDIUM)
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+
 	return err;
 }
 
@@ -687,7 +705,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	if (err)
 		goto done;
 
-	err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr, pkt);
 
 done:
 	return err;
@@ -709,13 +727,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 		goto done;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
+		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
 					 pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
+		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
 					 glom_skb);
 		if (err) {
 			brcmu_pkt_buf_free_skb(glom_skb);
@@ -741,6 +759,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+
 	if (!mypkt) {
 		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
@@ -752,10 +771,10 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
-					 mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
+
 	return err;
 
 }
@@ -775,7 +794,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true,
+			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
 						 addr, skb);
 			if (err)
 				break;
@@ -791,7 +810,7 @@ int
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
-	int bcmerror = 0;
+	int err = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
@@ -815,9 +834,10 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	/* Do the transfer(s) */
 	while (size) {
+
 		/* Set the backplane window to include the start address */
-		bcmerror = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
-		if (bcmerror)
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		if (err)
 			break;
 
 		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
@@ -828,14 +848,22 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		sdaddr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 		skb_put(pkt, dsize);
-		if (write)
+
+		if (write) {
 			memcpy(pkt->data, data, dsize);
-		bcmerror = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
-					      sdaddr, pkt);
-		if (bcmerror) {
+			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_1,
+						      sdaddr, pkt);
+		}
+		else {
+			err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_1,
+						      sdaddr, pkt);
+		}
+
+		if (err) {
 			brcmf_err("membytes transfer failed\n");
 			break;
 		}
+
 		if (!write)
 			memcpy(data, pkt->data, dsize);
 		skb_trim(pkt, 0);
@@ -859,7 +887,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	sdio_release_host(sdiodev->func[1]);
 
-	return bcmerror;
+	return err;
 }
 
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
-- 
2.11.0
