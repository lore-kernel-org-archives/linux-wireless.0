Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DA1435537;
	Fri, 24 Jul 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917162; cv=none; b=hc+IrcJ+NIEXXl9WftbY6V12KQboORvtM+ca6ALi7dykoajxQejYfsyOZdVM8DktXzhA529821Z5RZMqJ+qYyE7EMV0cOS28ff5yCwuq8joxrZQ6V2vQIpJLXNdJ/jRhpoy0dyrfDnve8R+nmserz4AolkLSWKZR4c7tJ1cFAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917162; c=relaxed/simple;
	bh=+W2lVUa7PgFSRFDQPY43rQcRA6Pwq2I8Pca7AoPtNFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXdPxEnU0hDotpe+DjK3pcydatyreYRAosg9z6f6emFdDQUpkr20OCO3y4ZuN6C4xYF174ZKnpdLYrDDRoEeylZPO96YpH4AutMfHy+9kzixO57GqHfg1ZqiBcMLV4mfkeH1/VR0WOMi1/lWNxPU7jwJr/9Km8D5efMHzFP6TzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O9MN9UvG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O9MN9UvG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JogREBoq/sSM9sKCE6Rr5Vh+8vTePhxztIc6s5eod+E=;
	b=O9MN9UvGHkE7UOYjxkZEz22vASY5noiy1L+46W858Usar5lnW5bIhzHjRtm2EjMGua89dY
	2yNc7YoDbt0Mjuw3AWbmvcOwCgdIjD8bDOIIamNrU13k6T0A92Xj2lbqYA9VVKj9jEY5HI
	1LLKFr98uv7QkUQDcbQNY+RmrmBSocw=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 08/19] wifi: rtw88: fw: fix the reserved page upload on RTL8723BS
Date: Fri, 24 Jul 2026 20:18:47 +0200
Message-ID: <20260724181858.192903-9-luka.gejak@linux.dev>
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
index b43ee5d951fd..20f196752381 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1595,10 +1595,14 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
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
@@ -1628,13 +1632,28 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
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
@@ -1655,11 +1674,13 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
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

