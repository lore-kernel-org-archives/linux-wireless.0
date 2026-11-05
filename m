Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=119.15.109.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793847457;
	b=4ey9XuYcHupBe4Q3B42ZEqzclW4SrbRS2pk4oQf8CKlT/N9nd4edu2q/b2NT5NjB/Oj5
	 rxqcsH0MMJuST2iSruWAU6Qf2JAZBNGVStvgNS6hFXJpyZGL8zP16jJEUDM07lCP2oS6E
	 Q/FZ/qE9l1vZz7c8Zc2egp8QmDFQDpov987C4tdC8ebGY366zReKWZms3YqTkCwlsUqPL
	 KYLpyHXB6ioXwdw9OeEmgoqGsG+rXHnNOi5kkQKy+Yzu+CdSQZpYTVWgiPvBOr3R4L7Td
	 UG9cRvailS639umbDOQuNlLqoEysxNdrBtzHh+f8ac6qToO9IR0iG4oEq49z2UlA9Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793847457;
	h=DMARC-Filter:Received:DKIM-Signature:X-GPT-Reason:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GHVzZzSaSALrH85AAvCPrCKNFWtUKfUMPlV5DCMbabU=;
	b=QV06X2vSNe3c2AQIK5FeYl+bSIYP/JO74NZQif5qsAvzKsYLYWWmqoa7i/RbLVDqbNVp
	 kgeYl4EBR8Ionch3rLSy0OEtDz6ZZVZiKF46roAb9bw5BiR+f5Q8jhrNjNcKIMsf/eHBY
	 8IzGn/nK+RshVP2chKEzcfa41G2BqvqNbVpMu6frsDZGHHSPHtI3hxEbACKlavOVzoyOU
	 X0YKyBb0cnnWkFYVxER4kW1dcYzsMcNA1eqD1hF6x+uj08nn5jBM3DLTx6d3WmctFhYsG
	 IRKzF5WFHKQf16WBHXUAenHFjp9miux+u7Ru46ZhO24f2xYRq1TFnqS1O5YoFsISTcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=d-silva.org;
	spf=pass smtp.mailfrom=d-silva.org;
	dkim=pass header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=hWAJVVP2;
	arc=none smtp.remote-ip=119.15.109.137
Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68852606A33A;
	Thu,  5 Nov 2026 02:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68852606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=hWAJVVP2
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 2A94B41A53;
	Thu,  5 Nov 2026 13:57:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1793847449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHVzZzSaSALrH85AAvCPrCKNFWtUKfUMPlV5DCMbabU=;
	b=hWAJVVP24JIwgcu1UZ6lnVK37J+8N2MBiWjw7HErrMpqknma72wbXgHBSmZ6qyyxVNrqDr
	/NnknnNJQN+Qxw84MnMZcUaWNa4KOBsXnQjCce1MmCcQUDsZspeVADLmIuMXPO/yRzCp8e
	lY5tj7OjGt5s2J9cegHoPsaMubsoOpl+2rnDlJ/0C3cOKI0zRXyAmZKAqyE1zp4Vc4FwLd
	dOMvhsiSBSJXJbyercvLvtnzqiaEf6BP3ZrHOClwhwqncY5n1xMM9ri5cfHiUarEUSboP1
	jB+JAPSzluqw5iODNOg9pbpGPmtn9TMQeOHW4IjTOrW+IgIR4PPRDYfnogXE0g==
X-GPT-Reason: This is a legitimate technical communication regarding
	a Linux kernel patch. The message content perfectly aligns with
	the personal mailbox of alastair@d-silva.org, follows standard
	open-source development formatting (signed-off-by, acked-by, and
	specific technical refactoring details), and contains no marketing,
	phishing, or scam indicators. The sender domain matches the recipient
	domain, and there are no suspicious links or urgency tactics.
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
Subject: [PATCH rtw-next v8 4/4] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants
Date: Thu,  5 Nov 2026 13:57:00 +1100
Message-ID: <20261105025700.1655219-5-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105025700.1655219-1-alastair@d-silva.org>
References: <20261105025700.1655219-1-alastair@d-silva.org>
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
index eb1b60a517fb4..64d9f6a41660a 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1459,17 +1459,13 @@ static int rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
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
 
@@ -1479,33 +1475,45 @@ static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
 
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
@@ -1535,7 +1543,7 @@ static void rtw_sdio_handle_interrupt_3081(struct rtw_dev *rtwdev, u32 hisr)
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST)
-		rtw_sdio_rx_isr(rtwdev);
+		rtw_sdio_rx_isr_3081(rtwdev);
 
 	/*
 	 * Unmasking HIMR re-asserts the IRQ line if new packets arrived or if
-- 
2.53.0

