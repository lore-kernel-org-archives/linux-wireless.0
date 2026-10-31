Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=119.15.109.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793417765;
	b=v7N7Lto6ygQPu2mhwVKLfmGp9M1/5ht8BBlcUh2llzn9mZmJ32yX35jTl6i+gsYW2xov
	 /qGDMEZmk6mB5ModaJMkSAn3CNJ0rWdsDQP8tWXNR25bILrUeFJcQ0ArpoJhfcRxTyDSX
	 lMQxh9Q55qPT5eNGpq8V0OSz+BqgZkLGzMhNgFC9OdlE39e/QAa5y+8GkUIvTtustrE9I
	 ueR9p9hr175ZNXI9YtM7sZX+GCZ6bZsBTKGyzhiOSwd6fR62w/7OQq7CEtJC9B7LCbpsn
	 g1CY4uUuY1+SKJWQ/FUu3xDLpwL9/JOtbL+2vA9ohCMC02B4Q++dhbdgS+/TMYQPDmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793417765;
	h=DMARC-Filter:Received:DKIM-Signature:X-GPT-Reason:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4Na50D0QOOyHfeH63Jpl8GSNXR3NkGq1Q86qFqEh1Nc=;
	b=eoZNCUzy7LyflJWsgpRTc0TLZ6uty0tTH+yb6svncmNpf9renUpX1SSTRJMHtlfBX4da
	 cNa4IidEHnNBaunvcWiYKydYvvMNgt2M+8s5ZagHVkplRoaEphDSZUISoXmEdZQnnWoj8
	 oOATetfizSbFRM/yzQebP+bPKzmEKq631QCGRKe7e7kDRuZzub1qlkXh3S1Q3jfN8q7og
	 fIE0TFlEQa3+YDnFtcuwJuNUNpykXadMQ2SzJegwzXWwZmKPVJsxCvSAXjGssMdtJerUS
	 QEE162WTfmM41xerJ7XHewREqkrIoJUtWVN1V7asvWam9BL/+fzcGZYtlUUiQ5abieA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=d-silva.org;
	spf=pass smtp.mailfrom=d-silva.org;
	dkim=pass header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=k7Wl3rFF;
	arc=none smtp.remote-ip=119.15.109.137
Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90998606A31D;
	Sat, 31 Oct 2026 03:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90998606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=k7Wl3rFF
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 656CC41404;
	Sat, 31 Oct 2026 14:35:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1793417756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Na50D0QOOyHfeH63Jpl8GSNXR3NkGq1Q86qFqEh1Nc=;
	b=k7Wl3rFFfZxN3NeXM6E2en27tCzGA+C7b5ZmEpgT2chsCqVAcWtrIx+GwasEkKzjLnL0pi
	VUVPo72KEsuQN1G3M23yZ5uQzUxkxMPCC6Lw7fy3aklQiS0jBpJbb7/fnzPzMOrdRhYYPg
	NFPIzgcQCCYeTkgmvQexevTwYjiBI5RpTR8GewfWvNtrSXnJ8nkJwhNhUExGuT2ArpKQAT
	fHP78GFBjzLGWE6ik3UlNBIqEJIeLFFxrqaS+Ry9gaM/94qgi/UigG5fCCRxm5it225rCn
	yNKX6OMTv37YWMvX9HmyHB4VIaKZ775triXbqJlnNvpu+xc6F8NHUB1M0rKqMA==
X-GPT-Reason: This email is classified as legitimate. It is a
	technical software patch submission (Linux kernel style) sent
	from a personal/professional domain (alastair@d-silva.org) that
	matches the "Signed-off-by" signature and the "From" header. The
	content is a specific refactoring of a Wi-Fi driver (rtw88) involving
	architectural differences between 8051 and 3081, and it contains
	no marketing, urgency, or suspicious links. The message follows
	standard open-source contribution patterns with clear technical
	details and acknowledgments from real-world entities like Realtek.
From: Alastair D'Silva <alastair@d-silva.org>
To: linux-wireless@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH rtw-next v7 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants
Date: Sat, 31 Oct 2026 14:35:26 +1100
Message-ID: <20261031033526.474710-5-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031033526.474710-1-alastair@d-silva.org>
References: <20261031033526.474710-1-alastair@d-silva.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split rtw_sdio_rx_isr() into separate 8051 and 3081 variants to be
clear. The two differences between the architectures are:
- Register size: REG_SDIO_RX0_REQ_LEN is 16-bit on 8051, 32-bit on 3081.
- HISR behavior: 8051 re-reads REG_SDIO_HISR on each iteration, while
  3081 drains based on rx_len without re-reading HISR.

This is a refactoring without any logic changes.

Assisted-by: LLM
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 58 +++++++++++++----------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 75a5f5a96169..352ebb380a3e 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1441,17 +1441,13 @@ static int rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
 	return 0;
 }
 
-static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
+static void rtw_sdio_rx_isr_8051(struct rtw_dev *rtwdev)
 {
 	u32 rx_len, hisr, total_rx_bytes = 0;
 	int ret;
 
 	do {
-		if (rtw_chip_wcpu_8051(rtwdev))
-			rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
-		else
-			rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
-
+		rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
 		if (!rx_len)
 			break;
 
@@ -1461,33 +1457,45 @@ static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
 
 		total_rx_bytes += rx_len;
 
-		if (rtw_chip_wcpu_8051(rtwdev)) {
-			/* Stop if no more RX requests are pending, even if
-			 * rx_len could be greater than zero in the next
-			 * iteration. This is needed because the RX buffer may
-			 * already contain data while either HW or FW are not
-			 * done filling that buffer yet. Still reading the
-			 * buffer can result in packets where
-			 * rtw_rx_pkt_stat.pkt_len is zero or points beyond the
-			 * end of the buffer.
-			 */
-			hisr = rtw_read32(rtwdev, REG_SDIO_HISR);
-		} else {
-			/* RTW_WCPU_3081 chips have improved hardware or
-			 * firmware and can use rx_len unconditionally.
-			 */
-			hisr = REG_SDIO_HISR_RX_REQUEST;
-		}
+		/*
+		 * Stop if no more RX requests are pending, even if
+		 * rx_len could be greater than zero in the next
+		 * iteration. This is needed because the RX buffer may
+		 * already contain data while either HW or FW are not
+		 * done filling that buffer yet. Still reading the
+		 * buffer can result in packets where
+		 * rtw_rx_pkt_stat.pkt_len is zero or points beyond the
+		 * end of the buffer.
+		 */
+		hisr = rtw_read32(rtwdev, REG_SDIO_HISR);
 	} while (total_rx_bytes < SZ_64K && hisr & REG_SDIO_HISR_RX_REQUEST);
 }
 
+static void rtw_sdio_rx_isr_3081(struct rtw_dev *rtwdev)
+{
+	u32 rx_len, total_rx_bytes = 0;
+	int ret;
+
+	do {
+		rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
+		if (!rx_len)
+			break;
+
+		ret = rtw_sdio_rxfifo_recv(rtwdev, rx_len);
+		if (ret)
+			break;
+
+		total_rx_bytes += rx_len;
+	} while (total_rx_bytes < SZ_64K);
+}
+
 static void rtw_sdio_handle_interrupt_8051(struct rtw_dev *rtwdev, u32 hisr)
 {
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST) {
 		hisr &= ~REG_SDIO_HISR_RX_REQUEST;
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_8051(rtwdev);
 	}
 
 	/*
@@ -1517,7 +1525,7 @@ static void rtw_sdio_handle_interrupt_3081(struct rtw_dev *rtwdev, u32 hisr)
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST)
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_3081(rtwdev);
 
 	/*
 	 * Unmasking HIMR re-asserts the IRQ line if new packets arrived or if
-- 
2.53.0

