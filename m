Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55375 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdDEHLd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:11:33 -0400
Subject: [PATCH 5/7] ath10k: add ath10k_sdio_readsb()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:07:22 +0300
Message-ID: <149137604232.4898.8026652026499451988.stgit@potku.adurom.net> (sfid-20170405_091136_655466_EE0699E4)
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c |   34 +++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index beb1749672f0..301355228cfa 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -396,6 +396,33 @@ static int ath10k_sdio_write(struct ath10k *ar, u32 addr, const void *buf, size_
 	return ret;
 }
 
+static int ath10k_sdio_readsb(struct ath10k *ar, u32 addr, void *buf, size_t len)
+{
+	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	int ret;
+
+	sdio_claim_host(func);
+
+	len = round_down(len, ar_sdio->mbox_info.block_size);
+
+	ret = sdio_readsb(func, buf, addr, len);
+	if (ret) {
+		ath10k_warn(ar, "failed to read from fixed (sb) address 0x%x: %d\n",
+			    addr, ret);
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio readsb addr 0x%x buf 0x%p len %zu\n",
+		   addr, buf, len);
+	ath10k_dbg_dump(ar, ATH10K_DBG_SDIO_DUMP, NULL, "sdio readsb ", buf, len);
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
 /* HIF mbox functions */
 
 static int ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
@@ -645,11 +672,8 @@ static int ath10k_sdio_mbox_rx_packet(struct ath10k *ar,
 	struct sk_buff *skb = pkt->skb;
 	int ret;
 
-	ret = ath10k_sdio_read_write_sync(ar,
-					  ar_sdio->mbox_info.htc_addr,
-					  skb->data, pkt->alloc_len,
-					  HIF_RD_SYNC_BLOCK_FIX);
-
+	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
+				 skb->data, pkt->alloc_len);
 	pkt->status = ret;
 	if (!ret)
 		skb_put(skb, pkt->act_len);
