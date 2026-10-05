Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF240A95F;
	Mon,  5 Oct 2026 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190170; cv=none; b=X/vVwWlraQH/+HHrzWgzSH2cu0bVPdl28aBJ+Mkl3U8nudOjYUfQ/62WGhYp2hSQdvTjUEt3IWUmxn5/TGTVr/pszoPbTMxLaUOyMoVHD93epBH4dutGr8Yc6R8TAcL//neLxKABRSGg6HJEjhUkuZWqN7n3MGEO9VGr5+giDYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190170; c=relaxed/simple;
	bh=kawkzcMAtBLCtija+Jyr8gsMxXqYDt/q8ae3xcHWSFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XINVNkYe+IcNNyLPP/tynjCyUkiyQYUsHnp2h5gPTPajstJpWSbdjUTIyHCdeiV558zC5R6xwO6J+63WjbcjUpAAjgdpMTCZ8w2Glqk/lJ3RIuyiqlUnFVbZRF9oU+dhQ7P0ELezu1NB6PAsPIf6oyegZHSRSkSHz1AAmyyNIWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=mPmTzUBC; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="mPmTzUBC"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 6D19F42DAC;
	Mon,  5 Oct 2026 19:49:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1791190157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1XKMkJpYnvbxUlu+WxfAOsWKe8oWGBMCMFWNSNDQww=;
	b=mPmTzUBChZtZFn5ZOhdj03swICEzSVX5koxXt9jP6CdM5g5+RfseyHyWtRZWcUULIdyV9H
	l80qwZ1vq/D5QttDRJUo8LclQiBCVhmYhoxk8+Wn8cfcCVTO5OrbqcDsdC8B7AX+ocwm3C
	h8WE6JcXJDPi886dntxTtpiTcREzHlao4to5lqlub74B/MQqI3kDoYSRvN8HXHhL+HWtkV
	ZBoZgcS2h/MCdoGtxlg9K/mNKNnix/GDaG+RpH46uRcGa75mproVtjpwjWsPZo2XBH2y59
	qVAmS5bCx/2uMZunsNyyHEDsSoweWRxVby/z3hPK/kT24SCSlrNieuBGMcJUpw==
X-GPT-Reason: legitimate_transactional_personal_code_submission.
	The email is a technical patch submission for a Linux kernel driver
	(rtw88), which perfectly aligns with the personal/professional
	identity of the sender (alastair@d-silva.org). The content contains
	a standard "diff" format showing code refactoring for WiFi drivers,
	includes specific technical logic regarding register sizes (8051
	vs 3081), and lacks any phishing markers, urgency, or suspicious
	links. The mailbox is expected to receive such professional/technical
	correspondence.
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
Subject: [PATCH rtw-next v4 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants
Date: Mon,  5 Oct 2026 19:48:49 +1100
Message-ID: <20261005084849.3109337-5-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005084849.3109337-1-alastair@d-silva.org>
References: <20261005084849.3109337-1-alastair@d-silva.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split rtw_sdio_rx_isr() into separate 8051 and 3081 variants to be
clear. The two differences between the architectures are:
- Register size: REG_SDIO_RX0_REQ_LEN is 16-bit on 8051, 32-bit on 3081.
- HISR behavior: 8051 re-reads REG_SDIO_HISR on each iteration, while
  3081 drains based on rx_len without re-reading HISR.

This is a refactoring without any logic changes.

Assisted-by: LLM
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 57 +++++++++++++----------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index c74644bf14ba..8f4d18b03f68 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1426,17 +1426,13 @@ static int rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
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
 
@@ -1446,33 +1442,44 @@ static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
 
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
@@ -1496,7 +1503,7 @@ static void rtw_sdio_handle_interrupt_3081(struct rtw_dev *rtwdev, u32 hisr)
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST)
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_3081(rtwdev);
 
 	/* Unmasking HIMR re-asserts the IRQ line if new packets arrived */
 	if (rtwsdio->running)
-- 
2.53.0

