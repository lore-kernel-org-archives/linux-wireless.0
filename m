Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A544E644
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917961; cv=none; b=ZOBAPS77TdKjg1JSOM2c2r7R7dQfsrVhpgRNPYUDzE1XYD2+0f44fzf8Sntv0YlgB0bzqbkeIR32SnTlIyiRxJjdzSC1nzF8fWCQnZB5j5TW2PqDJ/+I5BCRD/sC1wvtnBxQuBiK1/0sS3CyqyN+RdkC2fCQdods/vFpny4pmBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917961; c=relaxed/simple;
	bh=g9sTHqchJDIhDSzIH8uXCR6wH80Eux6kPxp0baQc8Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYxHN70vV5a4c3ophnqRDGfZ/wpUVtar5dzu9j10jyORP+QC2Jf6+VmcA03NmDYmHb7Ly6jwYotgYOR6jpkA1KvK/oRBvWcyZwS0rWfzv6YX6Nj3jhJ235Y0DC9p7oM+eoHvyH/bK7bTjq4tbmr0KxcmfQSFOgtwwiZlnEPVoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FEQ+Pipj; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FEQ+Pipj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LyYzjrKpkrOCVXLymw+xbAd6zjmUtij3BUfVB/WXIA=;
	b=FEQ+PipjMcqSoPpsqQMXtaMqmU1HlqhqqnxnXHFJqqWMt2AxgoLY2KjwOCQIq9tC+AJni1
	FbYgkH/RR6utpR33VEtlhonUaqfVyHbU3RKaMOg+Qo5LzlxfXG8KF2ygEm7AqjSJsR+xe4
	cyX01oOD2UBt/dnbCmFaGvu7wJC5OW0=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 12/19] wifi: rtw88: sdio: handle the RTL8723BS management TX path
Date: Fri, 24 Jul 2026 20:32:25 +0200
Message-ID: <20260724183225.196856-1-luka.gejak@linux.dev>
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

Management and beacon frames on this chip go to the high queue rather
than the extra one, and their descriptor has to sit at a fixed offset,
which means the skb payload must be aligned before the descriptor is
pushed instead of inserting padding after it. Doing the alignment can
fail, so the prepare path now reports an error rather than returning
void.

The vendor descriptor also leaves SW_DEFINE and the sequence number at
zero for management frames, so there is no key to match an asynchronous
C2H report against. Follow the vendor dump_mgntframe_and_wait() path and
report completion at DMA completion for those frames, leaving data
frames on the normal TX report queue. Record the descriptor offset per
frame so the skb is unwound correctly on completion.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 131 +++++++++++++++++-----
 drivers/net/wireless/realtek/rtw88/sdio.h |   2 +
 2 files changed, 104 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index adf0b509e2cc..fcbb0ee601c1 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -480,8 +480,14 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
 				    REG_SDIO_CMD_ADDR_TXFF_HIGH);
 		break;
-	case RTW_TX_QUEUE_VI:
 	case RTW_TX_QUEUE_VO:
+		if (rtw_is_8723bs(rtwdev)) {
+			txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+					    REG_SDIO_CMD_ADDR_TXFF_HIGH);
+			break;
+		}
+		fallthrough;
+	case RTW_TX_QUEUE_VI:
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
 				    REG_SDIO_CMD_ADDR_TXFF_NORMAL);
 		break;
@@ -492,6 +498,8 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
 		break;
 	case RTW_TX_QUEUE_MGMT:
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    rtw_is_8723bs(rtwdev) ?
+				    REG_SDIO_CMD_ADDR_TXFF_HIGH :
 				    REG_SDIO_CMD_ADDR_TXFF_EXTRA);
 		break;
 	default:
@@ -765,12 +773,24 @@ static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queue,
 	}
 }
 
+static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct rtw_sdio_tx_data) >
+		     sizeof(info->status.status_driver_data));
+
+	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
+}
+
 static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
 	unsigned int orig_len = skb->len;
 	bool rtl8723bs = rtw_is_8723bs(rtwdev);
+	bool quiet = rtl8723bs && tx_data->is_mgmt;
 	unsigned int pages;
 	bool bus_claim;
 	size_t txsize;
@@ -825,6 +845,8 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	if (bus_claim)
 		sdio_release_host(rtwsdio->sdio_func);
 
+	if (!ret && quiet)
+		usleep_range(1000, 2000);
 	if (!ret && rtl8723bs) {
 		pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
 		rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
@@ -1032,52 +1054,82 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
-static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
+static int rtw_sdio_align_tx_skb(struct sk_buff *skb, unsigned int headroom)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	unsigned int misalign, needed;
+	int ret;
 
-	BUILD_BUG_ON(sizeof(struct rtw_sdio_tx_data) >
-		     sizeof(info->status.status_driver_data));
+	misalign = (unsigned long)skb->data & (RTW_SDIO_DATA_PTR_ALIGN - 1);
+	if (!misalign)
+		return 0;
 
-	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
+	needed = headroom + RTW_SDIO_DATA_PTR_ALIGN - 1;
+	if (skb_headroom(skb) < needed) {
+		ret = pskb_expand_head(skb, needed - skb_headroom(skb), 0,
+				       GFP_KERNEL);
+		if (ret)
+			return ret;
+
+		misalign = (unsigned long)skb->data &
+			   (RTW_SDIO_DATA_PTR_ALIGN - 1);
+		if (!misalign)
+			return 0;
+	}
+
+	needed = headroom + misalign;
+	if (skb_headroom(skb) < needed)
+		return -ENOSPC;
+
+	skb_push(skb, misalign);
+	memmove(skb->data, skb->data + misalign, skb->len - misalign);
+	skb_trim(skb, skb->len - misalign);
+
+	return 0;
 }
 
-static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
-				    struct rtw_tx_pkt_info *pkt_info,
-				    struct sk_buff *skb,
-				    enum rtw_tx_queue_type queue)
+static int rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb,
+				   enum rtw_tx_queue_type queue)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	unsigned long data_addr, aligned_addr;
+	bool fixed_8723bs_offset;
 	size_t offset;
 	u8 *pkt_desc;
+	int ret;
+
+	fixed_8723bs_offset = rtw_is_8723bs(rtwdev) &&
+			      (queue == RTW_TX_QUEUE_MGMT ||
+			       queue == RTW_TX_QUEUE_BCN);
+
+	if (fixed_8723bs_offset) {
+		ret = rtw_sdio_align_tx_skb(skb, chip->tx_pkt_desc_sz);
+		if (ret)
+			return ret;
+	}
 
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 
 	data_addr = (unsigned long)pkt_desc;
 	aligned_addr = ALIGN(data_addr, RTW_SDIO_DATA_PTR_ALIGN);
 
-	if (data_addr != aligned_addr) {
+	if (!fixed_8723bs_offset && data_addr != aligned_addr) {
 		/* Ensure that the start of the pkt_desc is always aligned at
 		 * RTW_SDIO_DATA_PTR_ALIGN.
 		 */
 		offset = RTW_SDIO_DATA_PTR_ALIGN - (aligned_addr - data_addr);
-
 		pkt_desc = skb_push(skb, offset);
-
-		/* By inserting padding to align the start of the pkt_desc we
-		 * need to inform the firmware that the actual data starts at
-		 * a different offset than normal.
-		 */
 		pkt_info->offset += offset;
+		memset(pkt_desc + chip->tx_pkt_desc_sz, 0, offset);
 	}
 
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
-
 	pkt_info->qsel = rtw_sdio_get_tx_qsel(rtwdev, skb, queue);
-
 	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
+
+	return 0;
 }
 
 static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
@@ -1087,9 +1139,10 @@ static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
 {
 	int ret;
 
-	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
-
-	ret = rtw_sdio_write_port(rtwdev, skb, queue);
+	memset(rtw_sdio_get_tx_data(skb), 0, sizeof(struct rtw_sdio_tx_data));
+	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	if (!ret)
+		ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	dev_kfree_skb_any(skb);
 
 	return ret;
@@ -1127,11 +1180,22 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
 	struct rtw_sdio_tx_data *tx_data;
-
-	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	int ret;
 
 	tx_data = rtw_sdio_get_tx_data(skb);
+	memset(tx_data, 0, sizeof(*tx_data));
+	if (skb->len >= sizeof(struct ieee80211_hdr_3addr)) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+		tx_data->is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
+	}
+
+	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	if (ret)
+		return ret;
+
 	tx_data->sn = pkt_info->sn;
+	tx_data->tx_pkt_offset = pkt_info->offset;
 
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
@@ -1410,11 +1474,20 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = rtwdev->hw;
-
-	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
-
-	/* enqueue to wait for tx report */
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+	u8 tx_pkt_offset = tx_data->tx_pkt_offset;
+
+	if (!tx_pkt_offset)
+		tx_pkt_offset = rtwdev->chip->tx_pkt_desc_sz;
+	skb_pull(skb, tx_pkt_offset);
+
+	/* The RTL8723BS vendor descriptor uses SW_DEFINE/sn=0 for management
+	 * frames, so there is no unique key for matching asynchronous C2H TX
+	 * reports. Report completion at SDIO DMA completion, as the vendor
+	 * dump_mgntframe_and_wait() path does; data frames keep the normal C2H
+	 * report queue.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS &&
+	    !(rtw_is_8723bs(rtwdev) && tx_data->is_mgmt)) {
 		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
 		return;
 	}
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 12086f1aa280..aa088c512b9c 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -140,6 +140,8 @@ struct sdio_device_id;
 
 struct rtw_sdio_tx_data {
 	u8 sn;
+	u8 tx_pkt_offset;
+	bool is_mgmt;
 };
 
 struct rtw_sdio_work_data {
-- 
2.55.0

