Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C8848CFC;
	Thu,  1 Oct 2026 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813016; cv=none; b=roQHniWQg+ylWygx1zcfuqj/xK5Yj9UM3X3c0XMD6n4Lx46QbBLq/uSGz+5hoNt6kimpgk2USAAH7X8QeTwmnFYL0ORQmAxIIqbsjwrFyMMGmKD9dOVtWvMWBBlngN0gfYrgd15/Hn70+bsS8YiFPx5vWPpO06k4lBVPI/uzwMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813016; c=relaxed/simple;
	bh=RjakY+Sfgqyqx+I+IIcb1cqRmq5Fp30xdXLz9TX/+Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpSVBEzb5I5FsAn53VFO3iwGUOmePYFNJZ6GbrouvCOZJvB2WqWvX+xRQsmrVfo5qhldJtOWLOd5mrSsSUi44t+zgHN8aljyXgN+jWYUGgbQ6pzFg1TMOS+pktxQdfh31Vvzi+/WKkqx1DTXowL2jDHccINl80iJJclkMfidoVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=ltSVp9si; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="ltSVp9si"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id BEC6D41021;
	Thu,  1 Oct 2026 10:03:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1790813001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=im9qEWZBQXjPIUy1EwElgEx5Dj7slNZCtZ9SKCkYp24=;
	b=ltSVp9siRQ3qtxjXUH+vJmPGCajR/5LtQqFiDF/kTDsjeCkZczKFTS6EWoIq13kCsEIvr2
	SB44IRmFCQzF/8c+ZtQuOGRvXS21HHITldHglPgFbvwNww8u6VFep8DcEVMOn04E6naFdD
	9PsToZafJu1Jrr3FV+3k5UJuBSvM9X8MoaO6mvacLquqj82kRI7PU4QQRUhI0gLWdlhQs/
	6cTabFjIwJoSloGrE2TUNPV8cmpqKjtoD7yb2Ve8aaps5LZN0Fu8f6P9YWPzf2+Pi/v34u
	w3YI0GYLPtP3+5YSrGutE53F1aQ+zn1pmQfurOKWrqrnc7KnzCi6eHEdXU8QhQ==
X-GPT-Reason: legitimate; This is a technical software patch for
	a Linux kernel wireless driver (rtw88) sent to a known personal/professional
	mailbox (alastair@d-silva.org) that matches the sender's identity
	(alastair@d-silva.org); the content is a standard "git-style" diff
	and technical explanation of interrupt service routine (ISR) optimization
	for 8051 and 3081 chips; there are no phishing indicators, no urgency,
	and the technical nature of the "rtw_sdio_rx_isr" discussion is
	consistent with professional engineering communication.
From: Alastair D'Silva <alastair@d-silva.org>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH v3 2/2] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants
Date: Thu,  1 Oct 2026 10:03:03 +1000
Message-ID: <20261001000303.3505264-3-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001000303.3505264-1-alastair@d-silva.org>
References: <20261001000303.3505264-1-alastair@d-silva.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the split of rtw_sdio_handle_interrupt(), the receive FIFO drain
loop in rtw_sdio_rx_isr() still contained a growing number of special
cases between 8051 and 3081 chips, evaluated twice per packet in the RX
hot path:

1. Register width: 8051 uses a 16-bit read of REG_SDIO_RX0_REQ_LEN,
   while 3081 uses a 32-bit read.
2. Loop termination: 8051 must re-read REG_SDIO_HISR on each iteration
   because the RX buffer may contain data while HW or FW is still filling
   it. Conversely, 3081 has improved HW/FW that can use rx_len
   unconditionally, previously requiring a synthetic assignment of
   hisr = REG_SDIO_HISR_RX_REQUEST to trick the loop condition into
   continuing.

To avoid accumulating further special cases and eliminate per-packet
branching in the RX hot path, split rtw_sdio_rx_isr() into separate
rtw_sdio_rx_isr_8051() and rtw_sdio_rx_isr_3081() functions.

This removes the artificial hisr assignment on 3081 and keeps the RX
processing logic cleanly separated by architecture.

Assisted-by: LLM
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
v3:
- New patch in v3.
- Split rtw_sdio_rx_isr into 8051 and 3081 variants following the dispatcher split.
- Eliminates per-packet wcpu branching in the RX hot path and removes artificial
  hisr assignments on 3081.
- Added Assisted-by tag per Documentation/process/coding-assistants.rst.

 drivers/net/wireless/realtek/rtw88/sdio.c | 54 ++++++++++++-----------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 63d62242ac1e..fbf67427b450 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1418,16 +1418,12 @@ static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
 	}
 }
 
-static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
+static void rtw_sdio_rx_isr_8051(struct rtw_dev *rtwdev)
 {
 	u32 rx_len, hisr, total_rx_bytes = 0;
 
 	do {
-		if (rtw_chip_wcpu_8051(rtwdev))
-			rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
-		else
-			rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
-
+		rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
 		if (!rx_len)
 			break;
 
@@ -1435,33 +1431,41 @@ static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
 
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
+		/* Stop if no more RX requests are pending, even if
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
+
+	do {
+		rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
+		if (!rx_len)
+			break;
+
+		rtw_sdio_rxfifo_recv(rtwdev, rx_len);
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
@@ -1483,7 +1487,7 @@ static void rtw_sdio_handle_interrupt_3081(struct rtw_dev *rtwdev, u32 hisr)
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST)
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_3081(rtwdev);
 
 	/* Unmasking HIMR re-asserts the IRQ line if new packets arrived */
 	rtw_sdio_enable_interrupt(rtwdev);
-- 
2.53.0

