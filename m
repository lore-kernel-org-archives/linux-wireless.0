Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55B33C18B
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991902; cv=none; b=f/G1QKEoIE/7yjqz73ImMZRNtRR2AeSm6hx42+cUQKQOD34d6lKdi1eSspbj4sMnXnOYbf2KkD9hP+KZF3D6xLGZUZVVCaELYRcQHz+jC2FlI0qdMfpeq51P7jomJTv77blNv+i2X3u1Rp3jY7TjxEiJ1HFkJrR3x1dhJinHpuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991902; c=relaxed/simple;
	bh=HovpTk5Bd/7RbMMa3eBO9O9XlQvB3x5wL4BHlEIzExo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYGZH31K7RAQQl/r1xfZE+/v44VIMGdeRa2u7/OHRIHmUeIJ5RwNxE50tSwJo8l0NKLxf7QE5bVdkge7sEtX0cAN0LR4UudG2e8vvFRixGuymfhmCXb4rX/AOyHzQ5ZosLgtpqHVYBNdDQ8Tj5XTqAiK3fpQpXqdDgDSrGbVD8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rQKAnOkK; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rQKAnOkK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PQmOEcz7TX5uTzpc7Tqt5megUozqqBLXP326ZduEJU=;
	b=rQKAnOkK3tmwAJtiCWPpGTRe6bnQDrKIzN29JQiCwvPf1QNHiGzIQ1GQ6Wp6vRQ3DUfrVU
	xcJnPHdPWcWYD3YPzlp8mN1MuIVeYuh2Y5/b2TGyfEURkWi3cske3hUSydqBCePg3M1k62
	d9Bv8wU5UN57cS1gKlkcbQUITt3cY9E=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 04/11] wifi: rtw88: fw: fix the reserved page upload on RTL8723BS
Date: Sat, 25 Jul 2026 17:04:20 +0200
Message-ID: <20260725150427.93887-5-luka.gejak@linux.dev>
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

Two things stop the reserved page handshake from completing on this
chip. BIT_EN_BCNQ_DL has to be cleared so the upload is not treated as
a real beacon, which rtw88 only does for PCIe while the vendor driver
does it unconditionally. The software beacon download path also has to
be pointed at port 0. Without either, BIT_BCN_VALID is never asserted
and the upload reports a timeout.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 27 ++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index dd6595b8175e..7c17086cac32 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1477,10 +1477,14 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 	rtw_add_rsvd_page(rtwdev, rtwvif, RSVD_LPS_PG_INFO, true);
 }
 
+/* REG_DWBCN1_CTRL bit 20 (SW_BCN_SEL for port 0), relative to byte +2 */
+#define BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0	(20 - 16)
+
 int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 				u8 *buf, u32 size)
 {
-	u8 bckp[3];
+	const bool is_8723bs_sdio = rtw_is_8723bs(rtwdev);
+	u8 bckp[4];
 	u8 val;
 	u16 rsvd_pg_head;
 	u32 bcn_valid_addr;
@@ -1510,13 +1514,28 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	rtw_write8(rtwdev, REG_BCN_CTRL,
 		   (bckp[2] & ~BIT_EN_BCN_FUNCTION) | BIT_DIS_TSF_UDT);
 
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
+	/* Clear BIT_EN_BCNQ_DL so the chip does not treat the reserved-page
+	 * upload as a real beacon; otherwise BIT_BCN_VALID never asserts. The
+	 * vendor rtl8723bs driver does this unconditionally; rtw88 only did it
+	 * for PCIe, which left 8723BS SDIO's BCN_VALID handshake failing.
+	 */
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE || is_8723bs_sdio) {
 		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
 		bckp[1] = val;
 		val &= ~(BIT_EN_BCNQ_DL >> 16);
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
 	}
 
+	/* 8723BS SDIO: point the SW beacon download path at port 0, else
+	 * BIT_BCN_VALID is never asserted after the SDIO upload completes.
+	 */
+	if (is_8723bs_sdio) {
+		val = rtw_read8(rtwdev, REG_DWBCN1_CTRL + 2);
+		bckp[3] = val;
+		val &= ~BIT(BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0);
+		rtw_write8(rtwdev, REG_DWBCN1_CTRL + 2, val);
+	}
+
 	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write data to rsvd page\n");
@@ -1537,11 +1556,13 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	}
 
 restore:
+	if (is_8723bs_sdio)
+		rtw_write8(rtwdev, REG_DWBCN1_CTRL + 2, bckp[3]);
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
 	rtw_write8(rtwdev, REG_BCN_CTRL, bckp[2]);
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE || is_8723bs_sdio)
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
 
-- 
2.55.0

