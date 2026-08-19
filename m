Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E03D5C06
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124464; cv=none; b=fyD4Y60Q+ZfjWbAq0rdMIzB22/DzFD93ol/DiJfVC8LeuPpb9HwYevVkek0XsKv+1lPRBum0jcu15JxPbH+yw79toVsbnUutYvrFmHg0Tm/n/UvAJTzGzPHr0N8HjVHdVZN7dNGkn+GHT10W9w/60zEwm2weWXsbwXaRCgHMBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124464; c=relaxed/simple;
	bh=7lm6MMiCURs+xkkByNrjJKiOlU6vTnHof8M+7gjnN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFOCdmSlQXjVsyZ2OJdwWh39gCLrnVW9wZhf2vQEzMyctvWAr2/86NzBVyGO0GSlKolrZxaKf6stLzD4ylRUYt4MDtyBtBmrOMOuwyn7J+kIjVSv0tTF35JulVm2uvJTI0famaSCQKU9DOO8VsAxQ2LZ4N+2WwykMUEvz2XPuuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wGG266o3; arc=none smtp.client-ip=91.218.175.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wGG266o3"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7lm6MMiCURs+xkkByNrjJKiOlU6vTnHof8M+7gjnN4g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787124460; v=1; x=1787729260;
 b=wGG266o3z5L33m0eEtB/9I5poLAY7lOZCOATK1mEUxjpdHKJROCn6jkJMeDoIyWJgix48iUo
 rwvFvANl9r/alzeFhdPPMvw+ch5MMWQ0pia7oewfvSTut47zuSCW7mhQuVPyVORm0T5dM0UCR5O
 +sq/Z0/Ysu+u1jM9IGmQGQPs=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 2dee097aeccc0baf;
	Wed, 19 Aug 2026 07:27:40 +0000
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v6 4/6] wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
Date: Wed, 19 Aug 2026 07:27:15 +0000
Message-ID: <20260819072717.22648-5-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819072717.22648-1-luka.gejak@linux.dev>
References: <20260819072717.22648-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS reports free TX page counts that the generic 8051 path
reads back from the chip on every transfer, which is both slow over SDIO
and unreliable on this part: the register frequently reads back zero
while pages are in fact available. It also gates transmission on a free
count in the SDIO output queue, REG_SDIO_OQT_FREE_PG, which rtw88 does
not track at all. The vendor driver calls this the OQT free space and
never expands the acronym; the register holds the number of further
transfers the SDIO output queue can accept, and the chip discards
writes that arrive when it has run out.

Mirror the vendor driver and keep the per-queue and public page counts
in software, seeded at start and resynchronised from the chip only when
the cached counts say there is not enough room. Wait for a free output
queue entry before writing, and account for the pages consumed after a
successful transfer.

Transfers also have to be padded up to the SDIO block size for this
chip rather than using the generic alignment, so size the write
separately from the frame and trim the skb back afterwards.

Measured on RTL8723BS hardware against an iperf3 server one hop behind
the AP, with the wlan0 byte counters as ground truth. On the generic
path the association completes but no data passes at all: TCP and UDP
both measure 0 bit/s in either direction. With this patch TCP is
25.3 Mbit/s up and 37.3 Mbit/s down, and UDP is 25.0 Mbit/s up at 0%
loss.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v6: none.
    Changes in v5:
      - the commit message now says what OQT is, as far as the vendor driver
        reveals it.
      - rtw_sdio_8723bs_sync_free_txpg() returns whether the chip reported
        anything and is the only caller of _store_free_txpg(), and
        _init_free_txpg() returns an error rather than nothing. That found a
        real bug: the public pool size was acq_pg_num minus the reserved
        queues with no check, so a chip coming up with no transmit page
        allocation would underflow a u16 and leave about 65000 free pages.
        It is now rtw_sdio_8723bs_pubq_num(), shared with the queue page
        allocation repair path, and it fails cleanly.
      - the output queue wait is bounded by a jiffies deadline rather than a
        loop count, so RTW_SDIO_OQT_TIMEOUT_MS is really milliseconds.
      - rtw_sdio_8723bs_check_rqpn() returns an error instead of silently
        doing nothing when the pool cannot cover the reserved queues, and
        rtw_sdio_start() propagates it. Both early returns are explained.

 drivers/net/wireless/realtek/rtw88/sdio.c | 293 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/sdio.h |  10 +
 2 files changed, 291 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 5b40d74b16ee..a8209b9acefd 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -20,6 +20,7 @@
 #include "tx.h"
 
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
+#define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
@@ -548,12 +549,157 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwdev, u8 *buf, size_t count)
 	return ret;
 }
 
+/*
+ * The cached free page counters are a fast path hint only. They are written
+ * from the single threaded TX work and, for H2C and reserved page writes,
+ * from process context, so they are atomic_t; whenever they claim there is
+ * not enough room they are resynchronised from the chip before the caller
+ * gives up, which also absorbs a lost update.
+ */
+static void rtw_sdio_8723bs_store_free_txpg(struct rtw_dev *rtwdev,
+					    u32 free_txpg)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	atomic_set(&rtwsdio->free_pg_high,
+		   u32_get_bits(free_txpg, BIT_FREE_TXPG_HIGH));
+	atomic_set(&rtwsdio->free_pg_normal,
+		   u32_get_bits(free_txpg, BIT_FREE_TXPG_NORMAL));
+	atomic_set(&rtwsdio->free_pg_low,
+		   u32_get_bits(free_txpg, BIT_FREE_TXPG_LOW));
+	atomic_set(&rtwsdio->free_pg_pub,
+		   u32_get_bits(free_txpg, BIT_FREE_TXPG_PUB));
+}
+
+/*
+ * Refresh the cached counters from the chip. Returns false when the chip
+ * reports no free pages at all, which means the counts cannot be trusted
+ * and the caller has to decide what to do instead.
+ */
+static bool rtw_sdio_8723bs_sync_free_txpg(struct rtw_dev *rtwdev)
+{
+	u32 free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
+	if (!free_txpg)
+		return false;
+
+	rtw_sdio_8723bs_store_free_txpg(rtwdev, free_txpg);
+
+	return true;
+}
+
+/*
+ * Size of the public page pool: whatever the transmit page allocation has
+ * left once the per queue pools are taken out. Fails if the allocation
+ * cannot cover the reserved queues, since the remainder would underflow and
+ * there would be no sensible pool to hand out.
+ */
+static int rtw_sdio_8723bs_pubq_num(struct rtw_dev *rtwdev, u16 *pubq_num)
+{
+	const struct rtw_page_table *pg_tbl = &rtwdev->chip->page_table[0];
+	u16 acq_pg_num = rtwdev->fifo.acq_pg_num;
+	u16 reserved_num;
+
+	reserved_num = pg_tbl->hq_num + pg_tbl->lq_num + pg_tbl->nq_num +
+		       pg_tbl->exq_num + pg_tbl->gapq_num;
+	if (acq_pg_num <= reserved_num) {
+		rtw_err(rtwdev,
+			"no transmit pages left for the public queue: %u of %u reserved\n",
+			reserved_num, acq_pg_num);
+		return -EINVAL;
+	}
+
+	*pubq_num = acq_pg_num - reserved_num;
+
+	return 0;
+}
+
+static int rtw_sdio_8723bs_init_free_txpg(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	const struct rtw_page_table *pg_tbl;
+	u16 pubq_num;
+	int ret;
+
+	/* Seed from the page table when the chip has nothing to report yet. */
+	if (!rtw_sdio_8723bs_sync_free_txpg(rtwdev)) {
+		ret = rtw_sdio_8723bs_pubq_num(rtwdev, &pubq_num);
+		if (ret)
+			return ret;
+
+		pg_tbl = &rtwdev->chip->page_table[0];
+		atomic_set(&rtwsdio->free_pg_high, pg_tbl->hq_num);
+		atomic_set(&rtwsdio->free_pg_normal, pg_tbl->nq_num);
+		atomic_set(&rtwsdio->free_pg_low, pg_tbl->lq_num);
+		atomic_set(&rtwsdio->free_pg_pub, pubq_num);
+	}
+
+	atomic_set(&rtwsdio->tx_oqt_free,
+		   rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG));
+
+	return 0;
+}
+
+/*
+ * Sum of the queue's dedicated counter and the public pool, clamped at zero:
+ * a lost update between the check below and rtw_sdio_8723bs_consume_txpg()
+ * can briefly drive a counter negative, and letting that wrap would hide the
+ * shortage instead of triggering a resync from the chip.
+ */
+static unsigned int rtw_sdio_8723bs_pages_free(struct rtw_dev *rtwdev,
+					       atomic_t *dedicated)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int free;
+
+	free = atomic_read(dedicated) + atomic_read(&rtwsdio->free_pg_pub);
+
+	return free > 0 ? free : 0;
+}
+
+static atomic_t *rtw_sdio_8723bs_free_txpg(struct rtw_dev *rtwdev, u8 queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_VI:
+		return &rtwsdio->free_pg_normal;
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		return &rtwsdio->free_pg_low;
+	case RTW_TX_QUEUE_BCN:
+	case RTW_TX_QUEUE_H2C:
+	case RTW_TX_QUEUE_HI0:
+	case RTW_TX_QUEUE_MGMT:
+	case RTW_TX_QUEUE_VO:
+		return &rtwsdio->free_pg_high;
+	default:
+		return NULL;
+	}
+}
+
 static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 				    size_t count)
 {
 	unsigned int pages_free, pages_needed;
 
-	if (rtw_chip_wcpu_8051(rtwdev)) {
+	if (rtw_is_8723bs(rtwdev)) {
+		atomic_t *dedicated;
+
+		dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
+		if (!dedicated) {
+			rtw_warn(rtwdev, "Unknown mapping for queue %u\n", queue);
+			return -EINVAL;
+		}
+
+		pages_free = rtw_sdio_8723bs_pages_free(rtwdev, dedicated);
+		pages_needed = DIV_ROUND_UP(count, rtwdev->chip->page_size);
+		if (pages_needed <= pages_free)
+			return 0;
+
+		rtw_sdio_8723bs_sync_free_txpg(rtwdev);
+		pages_free = rtw_sdio_8723bs_pages_free(rtwdev, dedicated);
+	} else if (rtw_chip_wcpu_8051(rtwdev)) {
 		u32 free_txpg;
 
 		free_txpg = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
@@ -632,44 +778,124 @@ static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 	return 0;
 }
 
+static int rtw_sdio_8723bs_wait_tx_oqt(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	unsigned long deadline;
+	u8 free;
+
+	if (atomic_add_unless(&rtwsdio->tx_oqt_free, -1, 0))
+		return 0;
+
+	deadline = jiffies + msecs_to_jiffies(RTW_SDIO_OQT_TIMEOUT_MS);
+	do {
+		free = rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG);
+		if (free) {
+			atomic_set(&rtwsdio->tx_oqt_free, free - 1);
+			return 0;
+		}
+		usleep_range(1000, 2000);
+	} while (time_before(jiffies, deadline));
+
+	return -EBUSY;
+}
+
+static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queue,
+					 unsigned int pages)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	atomic_t *dedicated;
+	unsigned int taken;
+	int free;
+
+	dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
+	if (!dedicated)
+		return;
+
+	free = atomic_read(dedicated);
+	taken = min_t(unsigned int, pages, free > 0 ? free : 0);
+	atomic_sub(taken, dedicated);
+
+	pages -= taken;
+	if (pages && atomic_sub_return(pages, &rtwsdio->free_pg_pub) < 0)
+		atomic_set(&rtwsdio->free_pg_pub, 0);
+}
+
 static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool rtl8723bs = rtw_is_8723bs(rtwdev);
+	unsigned int orig_len = skb->len;
+	unsigned int pages;
+	size_t write_size;
 	bool bus_claim;
 	size_t txsize;
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
 
-	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
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
+
+	txaddr = rtw_sdio_get_tx_addr(rtwdev, txsize, queue);
+	if (!txaddr) {
+		ret = -EINVAL;
+		goto out_trim;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-		return ret;
+		goto out_trim;
+
+	if (rtl8723bs) {
+		ret = rtw_sdio_8723bs_wait_tx_oqt(rtwdev);
+		if (ret)
+			goto out_trim;
+	}
 
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
 
-	if (ret)
+	if (ret) {
 		rtw_warn(rtwdev,
 			 "Failed to write %zu byte(s) to SDIO port 0x%08x",
-			 txsize, txaddr);
+			 write_size, txaddr);
+	} else if (rtl8723bs) {
+		pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
+		rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
+	}
 
+out_trim:
+	if (write_size > orig_len)
+		skb_trim(skb, orig_len);
 	return ret;
 }
 
@@ -749,8 +975,51 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
 	return 0;
 }
 
+/*
+ * Reprogram the queue page allocation if the chip came up with none. This is
+ * a repair path, not part of the normal start sequence: a non-zero free page
+ * count means the allocation latched during power on and must be left alone,
+ * and without a transmit page pool there is nothing to divide up either.
+ */
+static int rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	const struct rtw_page_table *pg_tbl;
+	u32 free_txpg;
+	u16 pubq_num;
+	int ret;
+
+	free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+	if (free_txpg || !fifo->acq_pg_num)
+		return 0;
+
+	ret = rtw_sdio_8723bs_pubq_num(rtwdev, &pubq_num);
+	if (ret)
+		return ret;
+
+	pg_tbl = &chip->page_table[0];
+	rtw_write32(rtwdev, REG_RQPN_NPQ,
+		    BIT_RQPN_NE(pg_tbl->nq_num, pg_tbl->exq_num));
+	rtw_write32(rtwdev, REG_RQPN,
+		    BIT_RQPN_HLP(pg_tbl->hq_num, pg_tbl->lq_num, pubq_num));
+
+	return 0;
+}
+
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	if (rtw_is_8723bs(rtwdev)) {
+		int ret = rtw_sdio_8723bs_check_rqpn(rtwdev);
+
+		if (ret)
+			return ret;
+
+		ret = rtw_sdio_8723bs_init_free_txpg(rtwdev);
+		if (ret)
+			return ret;
+	}
+
 	rtw_sdio_enable_rx_aggregation(rtwdev);
 	rtw_sdio_enable_interrupt(rtwdev);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 457e8b02380e..5b000cb8fac2 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -86,6 +86,10 @@
 #define REG_SDIO_OQT_FREE_PG			(SDIO_LOCAL_OFFSET + 0x001E)
 /* Free Tx Buffer Page */
 #define REG_SDIO_FREE_TXPG			(SDIO_LOCAL_OFFSET + 0x0020)
+#define BIT_FREE_TXPG_HIGH			GENMASK(7, 0)
+#define BIT_FREE_TXPG_NORMAL			GENMASK(15, 8)
+#define BIT_FREE_TXPG_LOW			GENMASK(23, 16)
+#define BIT_FREE_TXPG_PUB			GENMASK(31, 24)
 /* HCI Current Power Mode 1 */
 #define REG_SDIO_HCPWM1				(SDIO_LOCAL_OFFSET + 0x0024)
 /* HCI Current Power Mode 2 */
@@ -159,6 +163,12 @@ struct rtw_sdio {
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
2.53.0

