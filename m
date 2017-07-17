Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50020 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbdGQQrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:47:37 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 29/29] brcmfmac: HACK - stabilise the value of ->sbwad in use for some xfer routines.
Date: Mon, 17 Jul 2017 17:16:37 +0100
Message-Id: <20170717161637.4652-30-ian@mnementh.co.uk> (sfid-20170717_184742_225192_B08149F9)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We probably need to look up the value in future, but this has to be
better for now.

During my cleanup I uncovered this. The value of ->sbwad is essentially
un-known in several functions, and this will lead to tears should the code
be modified in ways that *should* be OK, but in practice may move the IO
window.

Classic house-of-cards bug, by the look of it.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index ab015bad02f2..37fddc6e34ce 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -59,6 +59,11 @@
 
 #define BRCMF_DEFAULT_RXGLOM_SIZE	32  /* max rx frames in glom chain */
 
+/* This is a huge hack - we should look up this value and refer to that - who knows if it varies from chip to chip...
+ * however this has got to be better than just letting ->sbwad dangle after the last bit of IO during setup
+ */
+#define FIXME_CHIPCOMMON_BASE 0x18000000
+
 struct brcmf_sdiod_freezer {
 	atomic_t freezing;
 	atomic_t thread_count;
@@ -528,7 +533,7 @@ int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
@@ -551,7 +556,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 {
 	struct sk_buff *glom_skb = NULL;
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
@@ -592,7 +597,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -625,7 +630,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
-- 
2.11.0
