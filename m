Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796427;
	b=24+TP4SbENnBqQ3ggTirQN8qMAVcs0DfNXG70ytjEhJz4rHyhNcB2p4kOcMVqHuZZcbF
	 upO2evHZmHPk2fHi09zv/mk0Hjd1NInVXFjoS4JF5Zpn+t28/zHRKR2IBsUfwjIYKUHtl
	 Ikzf0p88RFFg3lgB9OTTOeaA3EVdi+M2cTfPSUPOMJ8lleYi1xiCqsGtrfz0GWyBbMOwz
	 qAMupuUQbA8cZgkTiYx42cekcVa0TW1rBlTaSuFAP+yskBpVBL/6ZaXAR3ielA7E7DZH+
	 eLyp7zrkz+pGWTtM1PmA9r08dFsdZ40oRj/CgNZ3+iFazo2QK4UMJ92S1mM0B6qBP9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796427;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=S3Jeh70+ic8OpQA+7kcV7KiSFvtoQYOC+EJkjcuEgm8=;
	b=q0kXSDyfMYpKSkASs8waR9IlO5O+Vqf8kkZ1Uuuu0JocTzFCaaEycb5+DpgHu0lIwUf0
	 V4w77p5jzW3Ybfv1lR3XF2AlpfKDoZlvLBOuf9A0UBf2lUxkCGhZdYktnT4PUqaavkZ9A
	 slZZ0JZvA5ENt6Ee48mTIxndkXWgLrJeBbX1/PKbyqGwTYNFIb2IFUBAgAn/51RqW5RBu
	 RzDmyOBJhTPaydtoY9XkudjlO/EgAKbGygK50EqYR4euvUGWb0VLjV3BQOYwJ7tgCOhwe
	 Ca/pPd2WDkiIVg5X1I4s3pCLy8KzXDi3Enx7yUreZmNBi5iLwN7ZW9Aqne/lfBwzI9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="WcKv8/mv";
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D21606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 23:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04D21606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WcKv8/mv
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48b042c0759so896974f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796425; x=1793401225; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S3Jeh70+ic8OpQA+7kcV7KiSFvtoQYOC+EJkjcuEgm8=;
        b=WcKv8/mvCuMPO4fJYYrN4scTjbdSx885sUmK1SdvpwlmuS2P9xpjYausd2ttV3odPT
         +Wpjo8Gxf7oz3b++SJhRW/71mirByLeUTr5ZoNW6503x2PcY4Wthi3O6VAq8rNUnNdv5
         zy5LT+d0U+lzlFIcQqo6nu1A8VWR6mXdjTgfxqo/EuixgRsjvwCHYToPYJiCjZyQs3md
         iq8kYXFn/bSCfyKvvSi0PYMja5ZZa32Ps9Odf+d6c3qpK6GAjNdTSdQ8QB5S7DG2S1is
         4zdM0HTpP2l2xrmi7Z1CNJwjGo1wyICssXuQ9A7vxomXynovH6YHZa2CtdmSVBcjJCwg
         doGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796425; x=1793401225;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S3Jeh70+ic8OpQA+7kcV7KiSFvtoQYOC+EJkjcuEgm8=;
        b=LI2Zkwbtw3XSO3Gh0ZG+T3XiaFBY3UI0lOfxMn3OvIQfAnriWDr460BKG7ttRJSTY6
         82IP5LPnsUOc7hDCblhEpcr8hsZ8xv0seq31sgOdHqByMHQlMKEl9C02dJtWWaJHfoR6
         9tNMuUl8BTLUJdzGzg/x6F+rDNjrMzr/5DuZ+C+4bGLIBRS1QueKEoSfC3fx474ug1XW
         A9bx9+oL7SJf93IlxDUyEdPwdJPaBH68Zthn1OXHjAtr8uqYww34eMrgMIgMlrXUjP3C
         8DVCtULH7mR/JOFpkMRddXTYNJWKOzLnLQ97uYvdXqiyvsZdoP4KUd+35SU1CLXPmfMB
         ia7w==
X-Gm-Message-State: AFq9FYKmV/y0Qh2EzDJ6WrbOHgbAYhyYL3hHOXSuSG1Wn/dZyU4sm2Hg
	CiCTz/BRYdpmFYQEW7HC2B7o2eiFmT3/+r4SCTOCpn8W1p6D7dPRf8aC7Bp0fg==
X-Gm-Gg: AYBFou1HoaeikPAU9R2wADP7kOY38+XaHFIZyhfFoww/r9g7dE+rX/Xa4uiTg9gKogX
	C/aELjEXvSZW0ekwr7GuuUyz+GWBTH0XBmzs9SByoM8PAY+YPZ8ZW8e17qdnTJX7Fo5CFf95D3H
	wswVQxs7j6Kl7Gdthpep2k2/J1mbsWYa/ZTTz+TF/+xA92CcI9rOrKWldid+XoLi5cMK3AQtEtq
	msml7PgVlFIOnqr77h/X0GeTnRFklGwtoYD43cK6BPbprY/jedcUGwPgwMX+p3hPEYLgKmqac4Q
	P6Jt54at0W8j4OUyyz5nYOTRa/MXLwj5WMb9tmYMPUMeD7eh8xBmpT6nqlw1iwknsXkxOeRFEAK
	1ZMsVnGBLKiK8zsJoquJP41pBhG40fGy2kAF9vweGAGUFvP9a3jdh4I9R7n59NdH6KfmP4/LxPt
	6gPYYxaztJ/YC5tmInOSAXy5u5VpsFdBEGpG7N2XSWTNks5EvV516zmngLQwYIaYXlfwRLPuY/T
	QhSTwj3n07OC/rYkvS6NvbxhoQcbJd7j11MYhmzkwdmsXzYmX3eTmknt4iOoe4=
X-Received: by 2002:a05:600c:8708:b0:4a2:fe11:9a75 with SMTP id 5b1f17b1804b1-4a35aae43b4mr5631335e9.0.1792796425184;
        Fri, 23 Oct 2026 16:00:25 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a59d238sm11489515e9.14.2026.10.23.16.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 16:00:23 -0700 (PDT)
Message-ID: <572b1037-c5f6-447b-94de-21fc62565303@gmail.com>
Date: Sat, 24 Oct 2026 02:00:22 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH rtw-next 2/5] wifi: rtw88: Pass TX descriptor to
 rtw_tx_fill_tx_desc()
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Language: en-US
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The current code assumes the TX descriptor is in the same buffer as
the 802.11 frame, but that's not true for the RTL8821AE. It uses an
older design which keeps the TX descriptor in the TX ring.

In order to support the RTL8821AE (PCIe) give rtw_tx_fill_tx_desc() a
pointer to struct rtw_tx_desc instead of struct sk_buff.

Also pass the TX descriptor to rtw_tx_fill_txdesc_checksum() as
pointer to struct rtw_tx_desc instead of u8.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c       |  4 ++--
 drivers/net/wireless/realtek/rtw88/main.h     |  3 ++-
 drivers/net/wireless/realtek/rtw88/pci.c      |  4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8723b.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.h |  4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  2 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     |  4 ++--
 drivers/net/wireless/realtek/rtw88/tx.c       |  4 ++--
 drivers/net/wireless/realtek/rtw88/tx.h       | 10 +++++-----
 drivers/net/wireless/realtek/rtw88/usb.c      | 17 +++++++++--------
 16 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..3a9e1325a519 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1302,12 +1302,12 @@ static void rtw_fill_rsvd_page_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 {
 	struct rtw_tx_pkt_info pkt_info = {0};
 	const struct rtw_chip_info *chip = rtwdev->chip;
-	u8 *pkt_desc;
+	struct rtw_tx_desc *pkt_desc;
 
 	rtw_tx_rsvd_page_pkt_info_update(rtwdev, &pkt_info, skb, type);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
-	rtw_tx_fill_tx_desc(rtwdev, &pkt_info, skb);
+	rtw_tx_fill_tx_desc(rtwdev, &pkt_info, pkt_desc);
 }
 
 static inline u8 rtw_len_to_page(unsigned int len, u16 page_size)
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..6287994f9b31 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -51,6 +51,7 @@ extern const struct ieee80211_ops rtw_ops;
 
 struct rtw_dev;
 struct rtw_debugfs;
+struct rtw_tx_desc;
 
 enum rtw_hci_type {
 	RTW_HCI_TYPE_PCIE,
@@ -913,7 +914,7 @@ struct rtw_chip_ops {
 	/* for USB/SDIO only */
 	void (*fill_txdesc_checksum)(struct rtw_dev *rtwdev,
 				     struct rtw_tx_pkt_info *pkt_info,
-				     u8 *txdesc);
+				     struct rtw_tx_desc *txdesc);
 
 	/* for coex */
 	void (*coex_set_init)(struct rtw_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index c2d6d3a939cd..d8c5c11bf728 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -811,7 +811,7 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 	u32 tx_buf_desc_sz = chip->tx_buf_desc_sz;
 	u32 size;
 	u32 psb_len;
-	u8 *pkt_desc;
+	struct rtw_tx_desc *pkt_desc;
 	struct rtw_pci_tx_buffer_desc *buf_desc;
 
 	ring = &rtwpci->tx_rings[queue];
@@ -826,7 +826,7 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, tx_pkt_desc_sz);
 	pkt_info->qsel = rtw_pci_get_tx_qsel(skb, queue);
-	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
+	rtw_tx_fill_tx_desc(rtwdev, pkt_info, pkt_desc);
 	dma = dma_map_single(&rtwpci->pdev->dev, skb->data, skb->len,
 			     DMA_TO_DEVICE);
 	if (dma_mapping_error(&rtwpci->pdev->dev, dma))
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..af78277fcb17 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -2343,7 +2343,7 @@ static void rtw8723b_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 
 static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	/* Unlike the shared 8723x helper, the checksum is not inverted here. */
 	fill_txdesc_checksum_common(txdesc, 16);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.c b/drivers/net/wireless/realtek/rtw88/rtw8723x.c
index 97e6f6a62c0d..9a039cd5c299 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.c
@@ -681,7 +681,7 @@ void __rtw8723x_pwrtrack_set_xtal(struct rtw_dev *rtwdev, u8 therm_path,
 static
 void __rtw8723x_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 				     struct rtw_tx_pkt_info *pkt_info,
-				     u8 *txdesc)
+				     struct rtw_tx_desc *txdesc)
 {
 	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
 	__le16 chksum = 0;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.h b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
index e07b6ca99b3d..5e674784dfb1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
@@ -154,7 +154,7 @@ struct rtw8723x_common {
 	void (*coex_cfg_init)(struct rtw_dev *rtwdev);
 	void (*fill_txdesc_checksum)(struct rtw_dev *rtwdev,
 				     struct rtw_tx_pkt_info *pkt_info,
-				     u8 *txdesc);
+				     struct rtw_tx_desc *txdesc);
 	void (*debug_txpwr_limit)(struct rtw_dev *rtwdev,
 				  struct rtw_txpwr_idx *table,
 				  int tx_path_count);
@@ -510,7 +510,7 @@ static inline void rtw8723x_coex_cfg_init(struct rtw_dev *rtwdev)
 static inline
 void rtw8723x_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 				   struct rtw_tx_pkt_info *pkt_info,
-				   u8 *txdesc)
+				   struct rtw_tx_desc *txdesc)
 {
 	rtw8723x_common.fill_txdesc_checksum(rtwdev, pkt_info, txdesc);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index 781b66ccde67..61afaa02b857 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -886,7 +886,7 @@ static void rtw8812a_led_set(struct led_classdev *led,
 
 static void rtw8812a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	fill_txdesc_checksum_common(txdesc, 16);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
index fa02aa299b5e..fac69e8fb222 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
@@ -2041,7 +2041,7 @@ static void rtw8814a_led_set(struct led_classdev *led,
 
 static void rtw8814a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index 6096d3b8e41b..f0987196caee 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -733,7 +733,7 @@ static void rtw8821a_led_set(struct led_classdev *led,
 
 static void rtw8821a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	fill_txdesc_checksum_common(txdesc, 16);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index ee689fa3d87f..da67a6845fd5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -1230,7 +1230,7 @@ static void rtw8821c_led_set(struct led_classdev *led,
 
 static void rtw8821c_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	fill_txdesc_checksum_common(txdesc, 16);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index a56c8befa077..a33ed11b2a63 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1593,7 +1593,7 @@ static void rtw8822b_led_set(struct led_classdev *led,
 
 static void rtw8822b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 32d9709f2c24..d2d98ae98e33 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -4562,7 +4562,7 @@ static void rtw8822c_led_set(struct led_classdev *led,
 
 static void rtw8822c_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
-					  u8 *txdesc)
+					  struct rtw_tx_desc *txdesc)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	size_t words;
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 2f0a6739df41..d9a73d30b7f5 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1180,8 +1180,8 @@ static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	unsigned long data_addr, aligned_addr;
+	struct rtw_tx_desc *pkt_desc;
 	size_t offset;
-	u8 *pkt_desc;
 
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 
@@ -1207,7 +1207,7 @@ static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
 
 	pkt_info->qsel = rtw_sdio_get_tx_qsel(rtwdev, skb, queue);
 
-	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
+	rtw_tx_fill_tx_desc(rtwdev, pkt_info, pkt_desc);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 701ed7c4f3f7..49ce16352334 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -33,9 +33,9 @@ void rtw_tx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 }
 
 void rtw_tx_fill_tx_desc(struct rtw_dev *rtwdev,
-			 struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb)
+			 struct rtw_tx_pkt_info *pkt_info,
+			 struct rtw_tx_desc *tx_desc)
 {
-	struct rtw_tx_desc *tx_desc = (struct rtw_tx_desc *)skb->data;
 	bool more_data = false;
 
 	if (pkt_info->qsel == TX_DESC_QSEL_HIGH)
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index 168f48e87853..af031c02b4b7 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -97,7 +97,8 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
 			    struct ieee80211_sta *sta,
 			    struct sk_buff *skb);
 void rtw_tx_fill_tx_desc(struct rtw_dev *rtwdev,
-			 struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
+			 struct rtw_tx_pkt_info *pkt_info,
+			 struct rtw_tx_desc *tx_desc);
 void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn);
 void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb, int src);
 void rtw_tx_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
@@ -117,11 +118,10 @@ enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac);
 enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb);
 
 static inline
-void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
+void fill_txdesc_checksum_common(struct rtw_tx_desc *tx_desc, size_t words)
 {
 	__le16 chksum = 0;
-	__le16 *data = (__le16 *)(txdesc);
-	struct rtw_tx_desc *tx_desc = (struct rtw_tx_desc *)txdesc;
+	__le16 *data = (__le16 *)(tx_desc);
 
 	le32p_replace_bits(&tx_desc->w7, 0, RTW_TX_DESC_W7_TXDESC_CHECKSUM);
 
@@ -134,7 +134,7 @@ void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
 
 static inline void rtw_tx_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					       struct rtw_tx_pkt_info *pkt_info,
-					       u8 *txdesc)
+					       struct rtw_tx_desc *txdesc)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index a1b58061eb46..599e80650c65 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -38,7 +38,7 @@ static void rtw_usb_fill_tx_checksum(struct rtw_usb *rtwusb,
 
 	le32p_replace_bits(&tx_desc->w7, agg_num, RTW_TX_DESC_W7_DMA_TXAGG_NUM);
 	pkt_info.pkt_offset = le32_get_bits(tx_desc->w1, RTW_TX_DESC_W1_PKT_OFFSET);
-	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, skb->data);
+	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, tx_desc);
 }
 
 static void rtw_usb_reg_sec(struct rtw_dev *rtwdev, u32 addr, __le32 *data)
@@ -511,6 +511,7 @@ static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 			      u8 *buf)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_tx_desc *pkt_desc;
 	struct sk_buff *skb;
 	unsigned int size;
 	u8 qsel;
@@ -525,10 +526,10 @@ static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 
 	skb_reserve(skb, chip->tx_pkt_desc_sz);
 	skb_put_data(skb, buf, size);
-	skb_push(skb, chip->tx_pkt_desc_sz);
-	memset(skb->data, 0, chip->tx_pkt_desc_sz);
-	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
-	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
+	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
+	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
+	rtw_tx_fill_tx_desc(rtwdev, pkt_info, pkt_desc);
+	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
 
 	ret = rtw_usb_write_port(rtwdev, qsel, skb,
 				 rtw_usb_write_port_complete, skb);
@@ -644,15 +645,15 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_usb_tx_data *tx_data;
-	u8 *pkt_desc;
+	struct rtw_tx_desc *pkt_desc;
 	int ep;
 
 	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwusb, skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
-	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
-	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
+	rtw_tx_fill_tx_desc(rtwdev, pkt_info, pkt_desc);
+	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
 	tx_data = rtw_usb_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
 
-- 
2.55.0

