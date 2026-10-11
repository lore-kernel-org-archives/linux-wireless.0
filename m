Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE5C44A730;
	Sun, 11 Oct 2026 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756516; cv=none; b=D9lTACULkBcVKUjbFssBB4wORFzTJrMaFoobia3SIzI589SNZBzNE42wG5+hKpDFDTEGPTL1754ZY6s14ghQVfet+NQjXF97Xa8k935QwQI3gCgqwsQcfK1idi3JbDGCMV8Q5OiJpPvdSRgJIqAz4zyyS1OafmpL9NGWhAaqf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756516; c=relaxed/simple;
	bh=x6qG7hpwEQcpd0zUIpGu4OMPJxt7xQZPvLAuAbVEKFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6Z4bfPgUmRy/Imr87PXbeCa72E2san66HySYNC7FvLVH6jBJ8xgIR+xQIB9Hi0uF5HTWYeP3ExzaZtIQn+1ZMrpiwAm92wedzFVbo3WgwdG8DrcxuJ7erlBJDiHx3CKJX8vRklIC0BhdQSP4L5iE4AVYfmTlDkkXTMwMRZlvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=cxlORspD; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="cxlORspD"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 608DB4341F;
	Mon, 12 Oct 2026 09:08:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1791756506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QhpHHaSSaHYwPOL8Q03+A+jFMK/sgqQ8AaTiTUfQ1xU=;
	b=cxlORspD+CcdtdS98SIopvAfzIpTqRZjrt924URstAfs9cgEco3jJeT/jfcJaK27PRediY
	h0pTY7RL1RfdWvDYInr26mmyPcnSzCM1bG68T+l300nb2+v7IXj6Ab4oHIiJycDEtZOinZ
	+xJiJEfP4l+qCmiB2Me1J7uk+RNNzAv29gkrFs3ZsaHJtvqENsl8N1OYSNlGcprGCWniAa
	B5Xh3gsTtc80bOuFZd/30yxljN9SC3RMG2Qx7I1ijWU1UEP2JKHFKGCw+LVTKK6j2NHAIg
	FD8JNylBfHtei1Yhwu5LY2MXgE9T6Y/862u24Ig7266zbB7FSzw4vdc5mMGzyA==
X-GPT-Reason: legitimate; the email is a technical software patch
	submission containing a code diff for a Linux kernel driver (rtw88),
	which is a standard workflow for open-source development; the sender
	(alastair@d-silva.org) is consistent with the "Signed-off-by" field
	and the technical content aligns perfectly with the mailbox's
	likely role in receiving technical/developer communications; no
	phishing markers, urgency, or suspicious URLs were identified.
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
Subject: [PATCH rtw-next v5 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants
Date: Mon, 12 Oct 2026 09:07:55 +1100
Message-ID: <20261011220755.1673367-5-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261011220755.1673367-1-alastair@d-silva.org>
References: <20261011220755.1673367-1-alastair@d-silva.org>
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
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 58 +++++++++++++----------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 9fbd7654ada4..a9312d0d7299 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1446,17 +1446,13 @@ static int rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
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
 
@@ -1466,33 +1462,45 @@ static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
 
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
@@ -1516,7 +1524,7 @@ static void rtw_sdio_handle_interrupt_3081(struct rtw_dev *rtwdev, u32 hisr)
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST)
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_3081(rtwdev);
 
 	/* Unmasking HIMR re-asserts the IRQ line if new packets arrived */
 	scoped_guard(mutex, &rtwsdio->irq_lock) {
-- 
2.53.0

