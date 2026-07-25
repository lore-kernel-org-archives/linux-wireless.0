Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12014345CAE
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991909; cv=none; b=pNE3IfQtEmFJaYLA3aSAGexozJ+kMJEdFxm3WNdgRMiM6RK2F5e9D8Q2fuLzaoNMhhZHGEJdvLKW8vBlpNXLMvlRSPTHa3izuBY//DlipSlgE6592uW+UM0CLLe56qOu4Abc2nlLOuaFtEaebBfQcm3/eOjnCWRSFV4kNRAxep4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991909; c=relaxed/simple;
	bh=KZjssMWjhKolr0qlSoYD1ULlE8KxpqUGXabw1zpwiD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6I9IogdJSizUvPTd2Zvb0ixhsevuMtbpQKe2ifhdl2swiTwG54l2ebo8h4L2O7MeVP/EdVEiZJxxvV1DkAgpmMEBEhbMo+CjGYGu/+HeZYJ9bSJYfteySl9AzRGhbeFtdJejELzPujlmzbk5QLTT5bgBYVvKZH1ldM5kGzyzlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bkBzHZuy; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bkBzHZuy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQHtTtnkfC5xGecpFUdMe9qSlMNGk5kmnWeam6ws/ts=;
	b=bkBzHZuyBJT+e6bKA+t1jno1ILsgug/kVNbDk5eOrAi1Z+r5hpgSw6/jzuRcFps5ZuG0rl
	l1zhqqwRKEf2252G9glNWQT1/NpkTSY6UHVwHazYQndyDOpXX/7QnVB8S4mEv5KYF2EkhL
	W2ureqqruVbS6KWvsEAPb5vvIl4HgkE=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 08/11] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Sat, 25 Jul 2026 17:04:24 +0200
Message-ID: <20260725150427.93887-9-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Enable the existing RX aggregation setup for this chip and select the
larger DMA aggregation mode it needs. The RTL8723BS does not raise
CPWM1, so leave that source out of its interrupt mask, and set the SDIO
TX control bit the vendor driver uses to have transfers always
recognised.

The chip also keeps raising the interrupt after resume if undefined
status bits are written back when acknowledging, so acknowledge only the
defined and unmasked bits. That is scoped to this chip; the other SDIO
parts keep writing the status word back unchanged.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 28 ++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/sdio.h |  9 ++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index adf0b509e2cc..37d1d58fa55e 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -844,7 +844,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CPWM1;
+	if (rtw_is_8723bs(rtwdev))
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST;
+	else
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST |
+				       REG_SDIO_HIMR_CPWM1;
 }
 
 static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
@@ -852,6 +856,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 	u8 size, timeout;
 
 	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723B:
 	case RTW_CHIP_TYPE_8703B:
 	case RTW_CHIP_TYPE_8821A:
 	case RTW_CHIP_TYPE_8812A:
@@ -879,6 +884,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
 
 	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+	if (rtw_is_8723bs(rtwdev))
+		rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);
 }
 
 static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
@@ -947,9 +954,19 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
 
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	u32 clear;
+
 	rtw_sdio_8723bs_check_rqpn(rtwdev);
 	rtw_sdio_init_free_txpg(rtwdev);
 	rtw_sdio_enable_rx_aggregation(rtwdev);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		clear = rtw_read32(rtwdev, REG_SDIO_HISR) &
+			RTW_SDIO_HISR_CLEAR_MASK;
+		if (clear)
+			rtw_write32(rtwdev, REG_SDIO_HISR, clear);
+	}
+
 	rtw_sdio_enable_interrupt(rtwdev);
 
 	return 0;
@@ -1029,6 +1046,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 
 	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
 	val &= 0xfff8;
+	if (rtw_is_8723bs(rtwdev))
+		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
@@ -1293,6 +1312,13 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 		rtw_sdio_rx_isr(rtwdev);
 	}
 
+	/* RTL8723BS keeps raising the interrupt after resume if undefined
+	 * status bits are written back, so acknowledge only the bits that are
+	 * both defined and unmasked. Other chips keep the existing behaviour.
+	 */
+	if (rtw_is_8723bs(rtwdev))
+		hisr &= rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
+
 	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
 
 	rtwsdio->irq_thread = NULL;
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 12086f1aa280..541d4302ec6b 100644
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

