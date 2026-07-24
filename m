Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982D944E651
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917964; cv=none; b=fr4pKwqs4HnHKinZzK/HZhxhhkNoen6LXxuSaTd6j4jS/794WAZQRRtpAgfVxO3206tKopfE8qRBcmNXRLOh9R+kHkPp76gs8annojs7Y5sOxgiLIc1vhkW85BpmGvnYdeo266n/VpDSmVxssfb4BghovdKGRsH1wViZSQXxn2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917964; c=relaxed/simple;
	bh=OtnzTAZKEkxJmzWEu77kMZZQVH/ZPcuDVj+/YMLE8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl+e1y3xwhpEMVFv4nE3lP47CMqMHXIewVUJcRP5+6zzTR+Lsxc7UTirVHIhwBaxZTzWCqFh8XNXlmsy9STRhtadWL7UpxqVflTLkpw66F+qmX0XnIMQlaJul9fRaEJ9yKUZ9WBXjNzxtRoPjNyGqITc+G1sE3GWS0jvZEeeSgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HGG9Xjyr; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HGG9Xjyr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkXLADA7GRUH3r64ZNYI+CzLSRonxO60OH6UJEDCfrk=;
	b=HGG9Xjyr7ZkCZZxcnJ3hgLnVmCrWeayy6eEHNDua+OeQXJQQPWEE2jPTwvV1g/IIKWMGqD
	PjXVkphAesBJLtGh5qizwa0IbDdn5U7PInNeBhePsG5np4QBDHipDlmPi5uLBU/236jdJy
	CP72mtFU09V6vYbZnlPJ/irqfOPu908=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 11/19] wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
Date: Fri, 24 Jul 2026 20:32:15 +0200
Message-ID: <20260724183215.196800-1-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS reports free TX page counts that the generic 8051 path
reads back from the chip on every transfer, which is both slow over SDIO
and unreliable on this part: the register frequently reads back zero
while pages are in fact available. It also gates transmission on an
output queue token count that rtw88 does not track at all.

Mirror the vendor driver and keep the per-queue and public page counts
in software, seeded at start and resynchronised from the chip only when
the cached counts say there is not enough room. Wait for an OQT credit
before writing, and account for the pages consumed after a successful
transfer.

Transfers also have to be padded up to the SDIO block size for this
chip rather than using the generic alignment, so size the write
separately from the frame and trim the skb back afterwards.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 220 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |   6 +
 2 files changed, 215 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 5b40d74b16ee..adf0b509e2cc 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -20,6 +20,7 @@
 #include "tx.h"
 
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
+#define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
@@ -548,12 +549,91 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwdev, u8 *buf, size_t count)
 	return ret;
 }
 
+static void rtw_sdio_init_free_txpg(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	const struct rtw_page_table *pg_tbl;
+	u32 free_txpg;
+	u16 pubq_num;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	pg_tbl = &rtwdev->chip->page_table[0];
+	pubq_num = rtwdev->fifo.acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
+		   pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
+	free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+	if (free_txpg) {
+		atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
+		atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0xff);
+		atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xff);
+		atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xff);
+	} else {
+		atomic_set(&rtwsdio->free_pg_high, pg_tbl->hq_num);
+		atomic_set(&rtwsdio->free_pg_normal, pg_tbl->nq_num);
+		atomic_set(&rtwsdio->free_pg_low, pg_tbl->lq_num);
+		atomic_set(&rtwsdio->free_pg_pub, pubq_num);
+	}
+
+	atomic_set(&rtwsdio->tx_oqt_free,
+		   rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG));
+}
+
+static void rtw_sdio_sync_free_txpg(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u32 free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
+	if (!free_txpg)
+		return;
+
+	atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
+	atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0xff);
+	atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xff);
+	atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xff);
+}
+
+static int rtw_sdio_8723bs_free_txpg(struct rtw_dev *rtwdev, u8 queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_BCN:
+	case RTW_TX_QUEUE_H2C:
+	case RTW_TX_QUEUE_HI0:
+	case RTW_TX_QUEUE_MGMT:
+	case RTW_TX_QUEUE_VO:
+		return atomic_read(&rtwsdio->free_pg_high);
+	case RTW_TX_QUEUE_VI:
+		return atomic_read(&rtwsdio->free_pg_normal);
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		return atomic_read(&rtwsdio->free_pg_low);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 				    size_t count)
 {
 	unsigned int pages_free, pages_needed;
 
-	if (rtw_chip_wcpu_8051(rtwdev)) {
+	if (rtw_is_8723bs(rtwdev)) {
+		struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+		int dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
+
+		if (dedicated < 0)
+			return dedicated;
+		pages_free = dedicated + atomic_read(&rtwsdio->free_pg_pub);
+		pages_needed = DIV_ROUND_UP(count, rtwdev->chip->page_size);
+		if (pages_needed <= pages_free)
+			return 0;
+
+		rtw_sdio_sync_free_txpg(rtwdev);
+		dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
+		pages_free = dedicated + atomic_read(&rtwsdio->free_pg_pub);
+	} else if (rtw_chip_wcpu_8051(rtwdev)) {
 		u32 free_txpg;
 
 		free_txpg = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
@@ -632,44 +712,131 @@ static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 	return 0;
 }
 
+static int rtw_sdio_wait_tx_oqt(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int i;
+	u8 free;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return 0;
+
+	if (atomic_add_unless(&rtwsdio->tx_oqt_free, -1, 0))
+		return 0;
+
+	for (i = 0; i < RTW_SDIO_OQT_TIMEOUT_MS; i++) {
+		free = rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG);
+		if (free) {
+			atomic_set(&rtwsdio->tx_oqt_free, free - 1);
+			return 0;
+		}
+		usleep_range(1000, 2000);
+	}
+
+	return -EBUSY;
+}
+
+static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queue,
+					 unsigned int pages)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	atomic_t *dedicated;
+	int free;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_VI:
+		dedicated = &rtwsdio->free_pg_normal;
+		break;
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		dedicated = &rtwsdio->free_pg_low;
+		break;
+	default:
+		dedicated = &rtwsdio->free_pg_high;
+		break;
+	}
+
+	free = atomic_read(dedicated);
+	if (pages <= free) {
+		atomic_sub(pages, dedicated);
+	} else {
+		atomic_set(dedicated, 0);
+		atomic_sub(pages - free, &rtwsdio->free_pg_pub);
+	}
+}
+
 static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	unsigned int orig_len = skb->len;
+	bool rtl8723bs = rtw_is_8723bs(rtwdev);
+	unsigned int pages;
 	bool bus_claim;
 	size_t txsize;
+	size_t write_size;
 	u32 txaddr;
 	int ret;
 
-	txaddr = rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
-	if (!txaddr)
-		return -EINVAL;
+	if (rtl8723bs) {
+		txsize = round_up(orig_len, 4);
+		write_size = txsize > RTW_SDIO_BLOCK_SIZE ?
+			     round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsize;
+	} else {
+		txsize = sdio_align_size(rtwsdio->sdio_func, orig_len);
+		write_size = txsize;
+	}
+
+	if (write_size > orig_len) {
+		unsigned int padding = write_size - orig_len;
+
+		if (skb_tailroom(skb) < padding) {
+			ret = pskb_expand_head(skb, 0,
+					       padding - skb_tailroom(skb),
+					       GFP_KERNEL);
+			if (ret)
+				return ret;
+		}
+		skb_put_zero(skb, padding);
+	}
 
-	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+	txaddr = rtw_sdio_get_tx_addr(rtwdev, txsize, queue);
+	if (!txaddr) {
+		ret = -EINVAL;
+		goto out_trim;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-		return ret;
+		goto out_trim;
+	ret = rtw_sdio_wait_tx_oqt(rtwdev);
+	if (ret)
+		goto out_trim;
 
 	if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN))
 		rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\n",
 			 __func__, queue);
 
 	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
-
 	if (bus_claim)
 		sdio_claim_host(rtwsdio->sdio_func);
-
-	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data, txsize);
-
+	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data,
+			       write_size);
 	if (bus_claim)
 		sdio_release_host(rtwsdio->sdio_func);
 
+	if (!ret && rtl8723bs) {
+		pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
+		rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
+	}
 	if (ret)
 		rtw_warn(rtwdev,
 			 "Failed to write %zu byte(s) to SDIO port 0x%08x",
-			 txsize, txaddr);
+			 write_size, txaddr);
 
+out_trim:
+	if (write_size > orig_len)
+		skb_trim(skb, orig_len);
 	return ret;
 }
 
@@ -749,8 +916,39 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
 	return 0;
 }
 
+static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	const struct rtw_page_table *pg_tbl;
+	u32 free_txpg;
+	u16 pubq_num;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+	if (free_txpg || !fifo->acq_pg_num)
+		return;
+
+	pg_tbl = &chip->page_table[0];
+	if (fifo->acq_pg_num <= pg_tbl->hq_num + pg_tbl->lq_num +
+				    pg_tbl->nq_num + pg_tbl->exq_num +
+				    pg_tbl->gapq_num)
+		return;
+
+	pubq_num = fifo->acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
+		   pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
+	rtw_write32(rtwdev, REG_RQPN_NPQ,
+		    BIT_RQPN_NE(pg_tbl->nq_num, pg_tbl->exq_num));
+	rtw_write32(rtwdev, REG_RQPN,
+		    BIT_RQPN_HLP(pg_tbl->hq_num, pg_tbl->lq_num, pubq_num));
+}
+
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	rtw_sdio_8723bs_check_rqpn(rtwdev);
+	rtw_sdio_init_free_txpg(rtwdev);
 	rtw_sdio_enable_rx_aggregation(rtwdev);
 	rtw_sdio_enable_interrupt(rtwdev);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 457e8b02380e..12086f1aa280 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -159,6 +159,12 @@ struct rtw_sdio {
 	struct workqueue_struct *txwq;
 	struct rtw_sdio_work_data *tx_handler_data;
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+
+	atomic_t free_pg_high;
+	atomic_t free_pg_normal;
+	atomic_t free_pg_low;
+	atomic_t free_pg_pub;
+	atomic_t tx_oqt_free;
 };
 
 extern const struct dev_pm_ops rtw_sdio_pm_ops;
-- 
2.55.0

