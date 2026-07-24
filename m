Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A4B44E643
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917966; cv=none; b=BsF2NuSpgFk/fOBSvEyEaQOvWu36Hi1gagfFpCEU2CgK/18VYTByiV9/ZqSYN2RQg/58GZy+RTd+RmhEpyxp5Gvi2j44SLx297fulZiZdjOE+EOxqy6QjTsspaZWyIwAxIqEdNyNdTULY6MaC3YqERh1GJg5XhjklM8+61D+M/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917966; c=relaxed/simple;
	bh=bcl/dScNsx7K9EG2mmY4VMXPLGAiUG7Swoi46ivkTcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Coa9XcCqMcKDbk+iWyX6OooviRHOF7hIBTNGlCRAMt7txcUpQH1K/ag3eWoxCNeybmRctTqLWQzmN+Ynil9uFwV7S/o+D7yWoeLgj95eL/aXcgh7j4h7LjUJLd2z2B0PFwky4qupWQiIWape4sS3ZpUErabbEebya5jZZHur4KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E6JB5YuZ; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E6JB5YuZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LWAKDHcdbwJJBUkZBJGkHaNlipjTLwVpmvQh30UzOFk=;
	b=E6JB5YuZa6txE9K873MaD/LD239InJs3rV0BZ+tPx1YMHzoCdgBwGZ+KKWFzOEH1QLurXg
	zW4uwIDkN8FmHKGUnJa02xKgAi7PiWrxhcqEHyd/wcbB5xRwj+Q6bHX2LucdDDxJ5EQwvl
	b4c25oBAyF5Ta6/Nv83CvR8UkWy87e8=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Fri, 24 Jul 2026 20:32:35 +0200
Message-ID: <20260724183235.196908-1-luka.gejak@linux.dev>
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

Enable the existing RX aggregation setup for this chip and select the
larger DMA aggregation mode it needs. The RTL8723BS does not raise
CPWM1, so leave that source out of its interrupt mask, and set the SDIO
TX control bit the vendor driver uses to have transfers always
recognised.

Interrupt status is also acknowledged differently: write back only the
bits that are actually defined, and for this chip only those that are
unmasked, rather than writing the raw status word back. Writing back
undefined bits leaves the RTL8723BS raising a persistent interrupt after
resume. Note that restricting the acknowledgment to defined bits
applies to the other SDIO parts as well.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 29 +++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |  9 +++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index fcbb0ee601c1..1c2d8082f468 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -866,7 +866,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
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
@@ -874,6 +878,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 	u8 size, timeout;
 
 	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723B:
 	case RTW_CHIP_TYPE_8703B:
 	case RTW_CHIP_TYPE_8821A:
 	case RTW_CHIP_TYPE_8812A:
@@ -901,6 +906,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
 
 	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+	if (rtw_is_8723bs(rtwdev))
+		rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);
 }
 
 static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
@@ -969,9 +976,19 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
 
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
@@ -1051,6 +1068,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 
 	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
 	val &= 0xfff8;
+	if (rtw_is_8723bs(rtwdev))
+		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
@@ -1341,6 +1360,7 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
 	struct rtw_sdio *rtwsdio;
 	struct rtw_dev *rtwdev;
+	u32 clear;
 	u32 hisr;
 
 	rtwdev = hw->priv;
@@ -1357,7 +1377,12 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 		rtw_sdio_rx_isr(rtwdev);
 	}
 
-	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
+	if (rtw_is_8723bs(rtwdev))
+		clear = hisr & rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
+	else
+		clear = hisr & RTW_SDIO_HISR_CLEAR_MASK;
+	if (clear)
+		rtw_write32(rtwdev, REG_SDIO_HISR, clear);
 
 	rtwsdio->irq_thread = NULL;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index aa088c512b9c..208c91446f82 100644
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

