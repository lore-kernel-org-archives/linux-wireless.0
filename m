Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E9388880
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787675638; cv=none; b=l2WDKyHt1Urt1qoPCRSLfv1g+BZyx8t/WDcNpO67W4eInlNmoBW78AzORIOfY/lfI2mKmA7rPMvXCgHko/I54TCy9aceOoh4v3+r/ifUhZ1ZQMzyuPTf1cMFWjdxclRBKKuf06amG7WLS1TV+kZiomYDdgaJZRc7p9SBk1H233A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787675638; c=relaxed/simple;
	bh=UOmCc6kudpz0VpxaSckJ6/HIqZ54tdgRP0kAR20HEGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2WiWO/UuZr9yJb97yougNSC8YQOAQcCOk2EMxGQi8nUYV8QsDVVUWxnaxXs/LTXODDZn36H33A8vJTO2jYla1G0YYgDz/zhcvMeTisNzbhGM42by8Z7Xo19Hd6XnF5tc1fOpyy3lFbzC+vO7KLfC4dXURBm8f8nw7wwcZ6M1pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EnQo31LA; arc=none smtp.client-ip=91.218.175.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EnQo31LA"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UOmCc6kudpz0VpxaSckJ6/HIqZ54tdgRP0kAR20HEGQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787675629; v=1; x=1788280429;
 b=EnQo31LAelzWu5jNKiYiM3I9zHru5+/i0mTsGXttzxxLRPAkT4j8M8qlNdER8QZBWLnX0jUz
 1xsIR57FmCabNYIsNjaIhB55tVyyPo+4UZaepsIpuGL6uCneF7GETBpKMkIhzTKseH1avron0PO
 IspD7rulJH1Tj60ln3OsFgWU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (109.165.152.75)
	by smtp.migadu.com with ESMTPS id 3652182ddab0362f;
	Tue, 25 Aug 2026 16:33:48 +0000
X-Mizu-Trace-ID: 3652182ddab0362f
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
Subject: [PATCH v8 4/6] wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
Date: Tue, 25 Aug 2026 16:33:12 +0000
Message-ID: <20260825163314.1590-5-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825163314.1590-1-luka.gejak@linux.dev>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
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
separately from the frame and zero the padding with __skb_pad(), which
also reallocates a cloned skb instead of writing into a buffer a clone
still shares.

The check, the output queue wait and the accounting are serialised by
a mutex. The TX worker and the H2C path reach this function
concurrently, and two writers that both pass the checks can otherwise
claim the same pages and output queue entry, after which the chip
silently discards whichever transfer arrives second. The vendor driver
avoids the same race by funnelling all transmission through one thread.

Measured on RTL8723BS hardware against an iperf3 server one hop behind
the AP, with the wlan0 byte counters as ground truth. On the generic
path the association completes but no data passes at all: TCP and UDP
both measure 0 bit/s in either direction. With this patch TCP is
25.3 Mbit/s up and 37.3 Mbit/s down, and UDP is 25.0 Mbit/s up at 0%
loss.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---

Notes:
    Changes in v8:
      - RTW_TX_QUEUE_VO is accounted against the normal page pool rather than
        the high one. rtw_sdio_get_tx_addr() writes it to the normal transmit
        FIFO, and that is the pool the chip charges: over a saturating VO
        flood the high pool never lost a single page while the public pool
        drained. The vendor maps VO to the high queue, but it also writes VO
        to the high FIFO, which rtw88 does not.
      - the output queue entry claimed before the transfer is handed back
        when the transfer fails, rather than staying claimed until the cache
        next resyncs from the chip.
      - mutex_destroy() for tx_credit_lock on teardown and on the init error
        path, matching rtw_core_deinit().
      - the comment on the cached page counters no longer explains the
        atomic_t by the several contexts that write them. Since v7 the
        transmit paths all update them under tx_credit_lock; what is left
        outside the lock is rtw_sdio_start() seeding them, and that is the
        reason they stay atomic_t.
      - the free page check, the output queue wait, the transfer and the
        accounting moved into rtw_sdio_8723bs_write_port(), which takes the
        lock with guard(mutex) as you suggested. The generic path is a short
        branch in rtw_sdio_write_port() that never touches the lock, and the
        transfer itself is shared as rtw_sdio_write_to_port().
      - lockdep_assert_held() added to rtw_sdio_8723bs_write_port(),
        rtw_sdio_8723bs_wait_tx_oqt() and rtw_sdio_8723bs_consume_txpg(),
        and checked on a kernel built with CONFIG_PROVE_LOCKING over
        bidirectional traffic and three module reloads: nothing fired.
      - the padding uses a pad_size local and the comment is down to the one
        point that matters, that __skb_pad() must not free the skb.
      - the comment above the lock is gone; the one at the declaration of
        tx_credit_lock covers it.
    Changes in v7:
      - the free page check, the output queue wait and the accounting after
        the transfer are serialised by a mutex. The TX worker and the H2C
        path run concurrently, and two writers that both passed the checks
        could claim the same pages and output queue entry; the OQT refill
        could also read the register while the other writer was between its
        claim and its transfer. The chip silently discards the overcommitted
        transfer, which for H2C means a lost firmware command.
      - the CMD53 address is computed from skb->len again, as upstream does.
        Passing the aligned size changed the encoded transfer length for
        every other SDIO chip whenever sdio_align_size() padded; for the
        RTL8723BS the two encodings are the same value.
      - the padding is applied with __skb_pad() and only on the RTL8723BS
        path. The open coded version wrote into a cloned skb's shared buffer
        when the tailroom happened to be large enough, and it also ran on
        the generic path, giving other chips a new allocation and failure
        mode. __skb_pad() does not move skb->len, so the trim on the way out
        is gone too. It must not free the skb on failure, since one caller
        requeues it and the other frees it.
    
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

 drivers/net/wireless/realtek/rtw88/sdio.c | 363 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |  12 +
 2 files changed, 356 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 5b40d74b16ee..1e5af37089f7 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -20,6 +20,7 @@
 #include "tx.h"
 
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
+#define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
@@ -548,12 +549,164 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwdev, u8 *buf, size_t count)
 	return ret;
 }
 
+/*
+ * The cached free page counters are a fast path hint only. The transmit
+ * paths read and update them under tx_credit_lock; rtw_sdio_start() seeds
+ * them outside it, so they are atomic_t. Whenever they claim there is not
+ * enough room they are resynchronised from the chip before the caller gives
+ * up, which also absorbs any drift.
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
+/*
+ * The pool a queue draws from follows the transmit FIFO that
+ * rtw_sdio_get_tx_addr() writes into, since that is the one the chip charges.
+ * RTW_TX_QUEUE_MGMT is the exception: it goes to the extra FIFO, which
+ * REG_SDIO_FREE_TXPG has no counter for and this chip allocates no pages to,
+ * so it is accounted against the high pool and served from the public one.
+ */
+static atomic_t *rtw_sdio_8723bs_free_txpg(struct rtw_dev *rtwdev, u8 queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_VI:
+	case RTW_TX_QUEUE_VO:
+		return &rtwsdio->free_pg_normal;
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		return &rtwsdio->free_pg_low;
+	case RTW_TX_QUEUE_BCN:
+	case RTW_TX_QUEUE_H2C:
+	case RTW_TX_QUEUE_HI0:
+	case RTW_TX_QUEUE_MGMT:
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
@@ -632,35 +785,67 @@ static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 	return 0;
 }
 
-static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
-			       enum rtw_tx_queue_type queue)
+static int rtw_sdio_8723bs_wait_tx_oqt(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
-	bool bus_claim;
-	size_t txsize;
-	u32 txaddr;
-	int ret;
+	unsigned long deadline;
+	u8 free;
 
-	txaddr = rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
-	if (!txaddr)
-		return -EINVAL;
+	lockdep_assert_held(&rtwsdio->tx_credit_lock);
 
-	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+	if (atomic_add_unless(&rtwsdio->tx_oqt_free, -1, 0))
+		return 0;
 
-	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
-	if (ret)
-		return ret;
+	deadline = jiffies + msecs_to_jiffies(RTW_SDIO_OQT_TIMEOUT_MS);
+	do {
+		free = rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG);
+		if (free) {
+			atomic_set(&rtwsdio->tx_oqt_free, free - 1);
+			return 0;
+		}
+		usleep_range(1000, 2000);
+	} while (time_before(jiffies, deadline));
 
-	if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN))
-		rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\n",
-			 __func__, queue);
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
+	lockdep_assert_held(&rtwsdio->tx_credit_lock);
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
+static int rtw_sdio_write_to_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
+				  u32 txaddr, size_t write_size)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool bus_claim;
+	int ret;
 
 	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
 
 	if (bus_claim)
 		sdio_claim_host(rtwsdio->sdio_func);
 
-	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data, txsize);
+	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data,
+			       write_size);
 
 	if (bus_claim)
 		sdio_release_host(rtwsdio->sdio_func);
@@ -668,11 +853,103 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	if (ret)
 		rtw_warn(rtwdev,
 			 "Failed to write %zu byte(s) to SDIO port 0x%08x",
-			 txsize, txaddr);
+			 write_size, txaddr);
 
 	return ret;
 }
 
+/*
+ * The free page check, the output queue wait and the accounting after the
+ * transfer have to be one unit, or two writers can both pass the checks and
+ * claim the same pages and output queue entry.
+ */
+static int rtw_sdio_8723bs_write_port(struct rtw_dev *rtwdev,
+				      struct sk_buff *skb,
+				      enum rtw_tx_queue_type queue, u32 txaddr,
+				      size_t txsize, size_t write_size)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	unsigned int pages;
+	int ret;
+
+	lockdep_assert_held(&rtwsdio->tx_credit_lock);
+
+	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
+	if (ret)
+		return ret;
+
+	ret = rtw_sdio_8723bs_wait_tx_oqt(rtwdev);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN))
+		rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\n",
+			 __func__, queue);
+
+	ret = rtw_sdio_write_to_port(rtwdev, skb, txaddr, write_size);
+	if (ret) {
+		/* nothing was queued, so hand the output queue entry back */
+		atomic_inc(&rtwsdio->tx_oqt_free);
+		return ret;
+	}
+
+	pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
+	rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
+
+	return 0;
+}
+
+static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
+			       enum rtw_tx_queue_type queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	size_t write_size;
+	size_t txsize;
+	u32 txaddr;
+	int ret;
+
+	txaddr = rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
+	if (!txaddr)
+		return -EINVAL;
+
+	if (!rtw_is_8723bs(rtwdev)) {
+		txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+
+		ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
+		if (ret)
+			return ret;
+
+		if (!IS_ALIGNED((unsigned long)skb->data,
+				RTW_SDIO_DATA_PTR_ALIGN))
+			rtw_warn(rtwdev,
+				 "Got unaligned SKB in %s() for queue %u\n",
+				 __func__, queue);
+
+		return rtw_sdio_write_to_port(rtwdev, skb, txaddr, txsize);
+	}
+
+	txsize = round_up(skb->len, 4);
+	write_size = txsize > RTW_SDIO_BLOCK_SIZE ?
+		     round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsize;
+
+	if (write_size > skb->len) {
+		size_t pad_size = write_size - skb->len;
+
+		/*
+		 * __skb_pad() must not free the skb on failure: both callers
+		 * still own it, one requeues it and the other frees it.
+		 */
+		ret = __skb_pad(skb, pad_size, false);
+		if (ret)
+			return ret;
+	}
+
+	guard(mutex)(&rtwsdio->tx_credit_lock);
+
+	return rtw_sdio_8723bs_write_port(rtwdev, skb, queue, txaddr, txsize,
+					  write_size);
+}
+
 static void rtw_sdio_init(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
@@ -749,8 +1026,51 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
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
 
@@ -1294,6 +1614,8 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 		return -ENOMEM;
 	}
 
+	mutex_init(&rtwsdio->tx_credit_lock);
+
 	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
 		skb_queue_head_init(&rtwsdio->tx_queue[i]);
 	rtwsdio->tx_handler_data = kmalloc_obj(*rtwsdio->tx_handler_data);
@@ -1306,6 +1628,7 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 	return 0;
 
 err_destroy_wq:
+	mutex_destroy(&rtwsdio->tx_credit_lock);
 	destroy_workqueue(rtwsdio->txwq);
 	return -ENOMEM;
 }
@@ -1320,6 +1643,8 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 
 	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
 		ieee80211_purge_tx_queue(rtwdev->hw, &rtwsdio->tx_queue[i]);
+
+	mutex_destroy(&rtwsdio->tx_credit_lock);
 }
 
 int rtw_sdio_probe(struct sdio_func *sdio_func,
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 457e8b02380e..f43f1c6309b7 100644
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
@@ -159,6 +163,14 @@ struct rtw_sdio {
 	struct workqueue_struct *txwq;
 	struct rtw_sdio_work_data *tx_handler_data;
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+
+	atomic_t free_pg_high;
+	atomic_t free_pg_normal;
+	atomic_t free_pg_low;
+	atomic_t free_pg_pub;
+	atomic_t tx_oqt_free;
+	/* one writer at a time between the credit check and the accounting */
+	struct mutex tx_credit_lock;
 };
 
 extern const struct dev_pm_ops rtw_sdio_pm_ops;
-- 
2.53.0

