Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48092 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbdGPLpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:33 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 13/21] brcmfmac: HACK - stabilise the value of ->sbwad in use for some xfer routines.
Date: Sun, 16 Jul 2017 12:21:21 +0100
Message-Id: <20170716112129.10206-14-ian@mnementh.co.uk> (sfid-20170716_140043_866771_7CED9DDB)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We probably need to look up the value in future, but this has to be better for now.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 5214556465d1..5324068a945d 100644
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
@@ -557,7 +562,7 @@ int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
@@ -577,7 +582,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 {
 	struct sk_buff *glom_skb;
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
@@ -616,7 +621,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -644,7 +649,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = FIXME_CHIPCOMMON_BASE;
 	int err;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
-- 
2.11.0
