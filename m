Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B7641D136
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 06:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826524; cv=none; b=I4GXmyxFe4E9stQsgfTsEexP6bJCtIJx6A4zs9rnAgdrRr7KRzT1CLLWcRvSUgYCSEQcn11fMVmO+o46+8wOcviOACT1YUHumi0Y5PpP54TNCEYkRtfDc7KTKOySlFtUWcWatzbXhmnEkxxdmnN9Ahm7xZmguA4iv/+ezvfvC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826524; c=relaxed/simple;
	bh=rEE4gqZFJf29ue+t4EEcM52kwqIY0z6FhdUzrC6NT1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww8OHTP2oWJKOnWLub7XUE6x1T9QF8E/zI9TlK0lgHZRU5KjTw1cpgHvvM3+0OZ3x1Y2Oal5NI8NTdcd2XONH+b6t6i2vjhBP+2D7R1cy0lTmI9iWvDvViQBFXisuYvskY3sRN4U/mUNttvhbTGc0ZoxOtBE6rb3JhynFErwHjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oy6o8iSh; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oy6o8iSh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785826520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7MJtAjQAOaOAkraoSS6YFuQZnoQa2WjaghOUTADB+M=;
	b=Oy6o8iShJs0nIEETtVss5BHZhyPBlWlVKNMTMH/c9QRRHVAFWo+jM2wzDJgpps3uWzVpfv
	+PGXLG5dqhkov6XYbUbORjV13q2S3iYQyJhxuEgAua/a+tz/e8T5pIRhK/ZN9IAHZaAtAW
	2reo4MTt1wVnhx7Ev+QCaLCRzlCYVBE=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v3 4/5] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Tue,  4 Aug 2026 06:54:24 +0000
Message-ID: <20260804065425.17364-5-luka.gejak@linux.dev>
In-Reply-To: <20260804065425.17364-1-luka.gejak@linux.dev>
References: <20260804065425.17364-1-luka.gejak@linux.dev>
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
larger DMA burst count it needs. The RTL8723BS does not raise CPWM1, so
leave that source out of its interrupt mask, and set the SDIO TX control
bit the vendor driver uses to have transfers always recognised.

The chip also keeps raising the interrupt after resume if undefined
status bits are written back when acknowledging, so acknowledge only the
defined and unmasked bits. That is scoped to this chip; the other SDIO
parts keep writing the status word back unchanged.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 29 ++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/sdio.h |  9 +++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 493eda559607..e9f0d23113f3 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -867,7 +867,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
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
@@ -875,6 +879,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 	u8 size, timeout;
 
 	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723B:
 	case RTW_CHIP_TYPE_8703B:
 	case RTW_CHIP_TYPE_8821A:
 	case RTW_CHIP_TYPE_8812A:
@@ -902,6 +907,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
 
 	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+	if (rtw_is_8723bs(rtwdev))
+		rtw_write8_mask(rtwdev, REG_RXDMA_MODE, BIT_DMA_BURST_CNT, 0x3);
 }
 
 static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
@@ -967,12 +974,22 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
 
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	u32 clear;
+
 	if (rtw_is_8723bs(rtwdev)) {
 		rtw_sdio_8723bs_check_rqpn(rtwdev);
 		rtw_sdio_8723bs_init_free_txpg(rtwdev);
 	}
 
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
@@ -1052,6 +1069,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 
 	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
 	val &= 0xfff8;
+	if (rtw_is_8723bs(rtwdev))
+		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
@@ -1316,6 +1335,14 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 		rtw_sdio_rx_isr(rtwdev);
 	}
 
+	/*
+	 * RTL8723BS keeps raising the interrupt after resume if undefined
+	 * status bits are written back, so acknowledge only the bits that are
+	 * both defined and unmasked. Other chips keep the existing behaviour.
+	 */
+	if (rtw_is_8723bs(rtwdev))
+		hisr &= rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
+
 	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
 
 	rtwsdio->irq_thread = NULL;
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 5b000cb8fac2..7474a7511811 100644
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
2.53.0

