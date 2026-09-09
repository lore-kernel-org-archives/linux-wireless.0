Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEC3B993F
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939995; cv=none; b=i8YOTygo2I5vyfHKc2ayriX6k3ZPgGSD9f99kdK4sjeyFrQb/Z1GvGil9xh8iQcauZF2yZoAtS/A+qeevsVWvHBY8xrEbLlmWG28P5veVmHlple4jBmhxk1ezEHY960scrRt6m+FMOv6UzrKVsELPDjsOpJIaeWCzIZXxTSJAY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939995; c=relaxed/simple;
	bh=NRktDEvvt1oTgFWR9U0NuWU2MAog1XCHMm9cG7ZpJIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inFsdNUJNxbW+7qLD3dpAuorHbJvrsMH+RXyrQAUjUaUXpQET44ycXrT7oLrnElTW9JrxR6sHcSKt9XFJ7zDknhZo90tBh7GF+MgoDWN9MM9FgZ+pb0TJr3o62FCnFdq5YtJP6PgSMxGmmPL5KGJPXhc6VzSa6ziW+AhF1ChIPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IO1EmDgN; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IO1EmDgN"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NRktDEvvt1oTgFWR9U0NuWU2MAog1XCHMm9cG7ZpJIM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788939989; v=1; x=1789544789;
 b=IO1EmDgNk/LNxWKfI/4MGnbh3eCVwOyT1sY2UjBDrkLbkMi9iWuYWvDrDQJRpj1PokQUhGh6
 pm5yHfoa3oW1dovUkj3JrVgcQjha9QChMbQwN51R+P+RgO+ClK0u+o3lAyHnQRa48yb6TaOPd5n
 6m6RRCyTJejEMhj6aJO8kAUc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 58eb08d609964b64;
	Wed, 09 Sep 2026 07:46:29 +0000
X-Mizu-Trace-ID: 58eb08d609964b64
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v11 6/7] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Wed,  9 Sep 2026 09:45:55 +0200
Message-ID: <20260909074556.55709-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909074556.55709-1-luka.gejak@linux.dev>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

Enable the existing RX aggregation setup for this chip and select the
larger DMA burst count it needs. The RTL8723BS does not raise CPWM1, so
leave that source out of its interrupt mask, and set the SDIO TX control
bit the vendor driver uses to have transfers always recognised.

The chip was also seen to keep raising the interrupt after resume when
undefined status bits were written back on acknowledgment, so
acknowledge only the bits this driver defines. That observation dates
from bring up and I cannot re-measure it: the test machine only offers
s2idle and does not reliably return from it, so the resume path is not
exercised here. The change is scoped to this chip; the other SDIO parts
keep writing the status word back unchanged.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v11: none.
    Changes in v10: none.
    Changes in v9: none.
    Changes in v8: none.
    Changes in v7: none.
    Changes in v6: none.
    Changes in v5: fixed the interrupt acknowledgment. It masked the status
    word with both irq_mask and RTW_SDIO_HISR_CLEAR_MASK, but for this chip
    irq_mask is REG_SDIO_HIMR_RX_REQUEST alone and that bit is not in the
    clear mask, so the two had no bits in common and the driver acknowledged
    nothing at all. It now masks with the defined bits only, which is what
    the comment described. The commit message also no longer presents the
    resume behaviour as re-measured, because it is not.

 drivers/net/wireless/realtek/rtw88/sdio.c | 28 ++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/sdio.h |  9 ++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 0dc1277619f6..696cd203919e 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -936,7 +936,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CPWM1;
+	if (rtw_is_8723bs(rtwdev))
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST;
+	else
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST |
+				    REG_SDIO_HIMR_CPWM1;
 }
 
 static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
@@ -944,6 +948,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 	u8 size, timeout;
 
 	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723B:
 	case RTW_CHIP_TYPE_8703B:
 	case RTW_CHIP_TYPE_8821A:
 	case RTW_CHIP_TYPE_8812A:
@@ -971,6 +976,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
 
 	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+	if (rtw_is_8723bs(rtwdev))
+		rtw_write8_mask(rtwdev, REG_RXDMA_MODE, BIT_DMA_BURST_CNT, 0x3);
 }
 
 static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
@@ -1042,6 +1049,8 @@ static int rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
 
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	u32 clear;
+
 	if (rtw_is_8723bs(rtwdev)) {
 		int ret = rtw_sdio_8723bs_check_rqpn(rtwdev);
 
@@ -1054,6 +1063,13 @@ static int rtw_sdio_start(struct rtw_dev *rtwdev)
 	}
 
 	rtw_sdio_enable_rx_aggregation(rtwdev);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		clear = rtw_read32(rtwdev, REG_SDIO_HISR) & RTW_SDIO_HISR_CLEAR_MASK;
+		if (clear)
+			rtw_write32(rtwdev, REG_SDIO_HISR, clear);
+	}
+
 	rtw_sdio_enable_interrupt(rtwdev);
 
 	return 0;
@@ -1133,6 +1149,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 
 	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
 	val &= 0xfff8;
+	if (rtw_is_8723bs(rtwdev))
+		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
@@ -1397,6 +1415,14 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 		rtw_sdio_rx_isr(rtwdev);
 	}
 
+	/*
+	 * RTL8723BS keeps raising the interrupt after resume if undefined
+	 * status bits are written back, so acknowledge only the bits this
+	 * driver defines. Other chips keep the existing behaviour.
+	 */
+	if (rtw_is_8723bs(rtwdev))
+		hisr &= RTW_SDIO_HISR_CLEAR_MASK;
+
 	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
 
 	rtwsdio->irq_thread = NULL;
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index f43f1c6309b7..634c0b1339bb 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -22,6 +22,7 @@
 
 /* SDIO Tx Control */
 #define REG_SDIO_TX_CTRL			(SDIO_LOCAL_OFFSET + 0x0000)
+#define BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE	BIT(4)
 
 /*SDIO status timeout*/
 #define REG_SDIO_TIMEOUT			(SDIO_LOCAL_OFFSET + 0x0002)
@@ -77,6 +78,14 @@
 /* the following two are RTL8188 SDIO Specific */
 #define REG_SDIO_HISR_MCU_ERR			BIT(28)
 #define REG_SDIO_HISR_TSF_BIT32_TOGGLE		BIT(29)
+#define RTW_SDIO_HISR_CLEAR_MASK		\
+	(REG_SDIO_HISR_TXERR | REG_SDIO_HISR_RXERR | \
+	 REG_SDIO_HISR_TXFOVW | REG_SDIO_HISR_RXFOVW | \
+	 REG_SDIO_HISR_TXBCNOK | REG_SDIO_HISR_TXBCNERR | \
+	 REG_SDIO_HISR_C2HCMD | REG_SDIO_HISR_CPWM1 | \
+	 REG_SDIO_HISR_CPWM2 | REG_SDIO_HISR_HSISR_IND | \
+	 REG_SDIO_HISR_GTINT3_IND | REG_SDIO_HISR_GTINT4_IND | \
+	 REG_SDIO_HISR_PSTIMEOUT | REG_SDIO_HISR_OCPINT)
 
 /* HCI Current Power Mode */
 #define REG_SDIO_HCPWM				(SDIO_LOCAL_OFFSET + 0x0019)
-- 
2.55.0

