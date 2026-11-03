Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699657;
	b=sE5pLL96cqw+5c3+DM3OrdXuBp5NeQflEyeXNWp0ew0lJoI8/X/w4WnLRnZn+7+BgJhE
	 7DY3Tfoz2NeAO4saNh5Cqcd1FBYFtMnYjx23mlJBPopbIMa5Co/HQxJur+qGDnlWZE2kj
	 +UAdhinsaYWRmP+PFsk1RwOdwIM7VIL2rQe3osrzaaYs0IXis3MR1wujCAzhJ0RZK9V+J
	 8nk8qCKu/DEWaHDU97urnXlTsUNJAB69wDSHOMZopkpdL4XFQgFEKBeeoImS+wz7ovN+X
	 zI8MLeZu1Y4hAioAIrCDAg6vLJNFtq56yJCCBzbIZIaeQ2483XwSB2td3kX2CPLGNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBNrZVHnb/IW5vTehwQYC43mSN9D38FsB90vjJdBW5I=;
	b=3DliUujPaq8zy5tP8bfGhJUAtt7alcOvEEP77KBg2Xqyl65RmcuPDGQs9tJXVSda2mzk
	 2xQsDYvx2y0EdOeN4jhS8gklvDvkJzFH+CvpOAWeXZQVXCsRUnDcHhk18Px0vaKyScCTR
	 /4ASOd0nsAbzjsqeF3AhAeVfvtLLTZZ2SXl7Wwu9XEmed0nRdsYmkTr3LFIB+VIbUPc2f
	 1srbqruZ5ZI+9ES6EHj7S6ZPaWGbQAHpUWxJ7NSU4MvYE8xqQJwZ44rKLVgZJqLEVzyFy
	 Glm2EH25iXTaqmEqn2+1peAygsV8PzkOx2kMEePPl41727jAVly5y25D7C3NKznU+LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PBUmCncp;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D354A6085081
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D354A6085081
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PBUmCncp
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b1ce85287aso1897021c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699656; x=1794304456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cBNrZVHnb/IW5vTehwQYC43mSN9D38FsB90vjJdBW5I=;
        b=PBUmCncp+DEH/lBUImAnwsLJgc1GzpOVc6My7UxsoceTaVrwHWR9YIsTJcFn6RPm2U
         h/Ve3vdmzdBeD6eJ/3MxADVtmovz5WbzVof883//JCIk3mbjFAToTNkGEcAcAt6j78qv
         xA1Y1zMgFa4jycLcJncJd3UNW659JMf5iTixg+wvv8TWP/hP87IurLwy3Nqm9HLXw4ZW
         eGsEoXgdw0847x2u9rIMy2zeewnjGvAUJl26FZ+aFLPWA7xuS5PZaW6pgrxLREJqnjzF
         HMuuDxeeVCLlovhTUEbUvZWX5u4IOSINkKvQDPTmN9Zq9ovV2E3zT3N2NcQ05EaZ6ixv
         j2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699656; x=1794304456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cBNrZVHnb/IW5vTehwQYC43mSN9D38FsB90vjJdBW5I=;
        b=Vos2UJdxxhAjGMii4xFTal+fXmYsEM413x0GJVL29kAxtwI1G953TGqQui1ljxLR2z
         8jt1zCK/wY7I3iW+dWJQAk+59M63pikR0GIrmEAfq8ZUGa3Ly954gSJWKzcYE4JStWhY
         acVZl3P25xPwkmwtwk4Zk6Isp5s2FdtpUgMEM1gGHYG4KSgVWPFF299yu9yvO1mRI5Sd
         LpWbTUzrwJ5zxUGeatUekoNrcdM/kvtXj73degJH7OyOASYBBIoj3vi38rsYy5N1KB96
         +68lcLbC2l+2N1uVxRLoiVQHgJ6ILl+aHzb5Qsz6UoDHzu3od925tOS40LTY6o4+vZlp
         SOsQ==
X-Forwarded-Encrypted: i=1; AKwUvByzHvFGBKXwqKRfMzJR47CQGzeTCbKq/EaorZR68YfLk0rHjjQZ0Mtcn8e5em8B6clXmMHEdGzqOZwT2z7PMg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9UE5W4kNGKSfsmFoAmT0DqRygQ8EOThnm7xUj4izbgJF4rr/L4
	d1GzlBfHrz3oqKxpnJtVzuDdWRismLWMvLLF1eY+jGNYPkL5FjQeGC3+iMWbpg==
X-Gm-Gg: AYBFou38PyA4t6yq7HpkYlvJDXpxpI+d/Pxn5XGFt4cznVYNfmSAaGZA4ZArj9kwSMP
	RuQRCm97Ms3bvyTTMazLAqQlWoEWXdoHWXDa+szoGMI7dpeybs9VqZx17/iYS77hlXsMlYCF48H
	WZD+deKr4weF54i80VBau77FYQPnLcxdsYadtbnQPmGvKkTlBWDcoKvER0XS7GkHnc9C3KM+EaZ
	CDCJQiNenhpR/vOnHb9N5q6I1VmTNz2K5cUvafGN3RmZI0hm+eCmL2HPg3LmNh6cnlUgz8BB/vj
	jbJAzU5TXazL7d2oWX15jkQJ1nZogp5DPWTmJWB6etwR8s9ayKK7PXohmpFRwc7Jcypk0Ossk39
	adFSoDt2ayZWAg0s0CjbNHP3wcbce2521GrFZrrR5BJPhVr553XEDVR/XB9YqfRMm3ZIdTCB2zi
	8ZZ4y85pC4YCjPRCfK6Rdm898J+tBe0q7B2/i5Z0zF5NQeJ9EAwLUf6lGLQFgWkLmdE4s8PUwPx
	WvFoB68VPJQ5mnENhny31p8BJoh5KSJjAq0UhwhmDg4WIbniZOmIbuenHlyE+mwNgqAFZM2UGZb
	D3ounPwcjU8gcstK+wqdoVfUFk84+sjws032HdUpYYdWeY8quUE1fy+v7OZqyLUU+6fZoitW5Vg
	mR2muHBWD
X-Received: by 2002:a05:7022:1706:b0:1ac:7044:2bad with SMTP id a92af1059eb24-1ac70442d69mr16257030c88.36.1793699655876;
        Tue, 03 Nov 2026 01:54:15 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:15 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next 4/5] wifi: rtlwifi: rtl8192du: enable USB RX aggregation
Date: Tue,  3 Nov 2026 17:52:53 +0800
Message-ID: <20261103095256.949327-5-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103095256.949327-1-hjf3108@gmail.com>
References: <20261103095256.949327-1-hjf3108@gmail.com>
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

Allow RX aggregation of up to 48 pages of 128 bytes or 24 with two MACs.

Test results (2.4 GHz):
   before after
TX 5.2    6.4
RX 27.1   32.0

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192d/reg.h   |  4 ++
 .../wireless/realtek/rtlwifi/rtl8192du/hw.c   | 18 +++++++-
 .../wireless/realtek/rtlwifi/rtl8192du/sw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192du/trx.c  | 45 +++++++++++++++++++
 .../wireless/realtek/rtlwifi/rtl8192du/trx.h  |  5 +++
 5 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
index 639aa0d92e05ef..7cc46f411af88b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
@@ -329,6 +329,7 @@
 
 #define REG_USB_Queue_Select_MAC0	0xFE44
 #define REG_USB_Queue_Select_MAC1	0xFE47
+#define REG_USB_DMA_AGG_TO		0xFE5B
 
 /* ----------------------------------------------------- */
 /*	Redifine 8192C register definition for compatibility */
@@ -940,6 +941,9 @@
 #define ENSWBCN					BIT(8)
 #define ENSEC					BIT(9)
 
+/* REG_TRXDMA_CTRL */
+#define RXDMA_AGG_EN				BIT(2)
+
 #define HQSEL_VOQ				BIT(0)
 #define HQSEL_VIQ				BIT(1)
 #define HQSEL_BEQ				BIT(2)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/hw.c
index ff458fb8514dae..3edd5bc432ff7c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/hw.c
@@ -489,6 +489,22 @@ static void _rtl92du_init_retry_function(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_ACKTO, 0x40);
 }
 
+static void _rtl92du_init_usb_aggregation(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 page_count = 48;
+
+	if (rtlpriv->rtlhal.macphymode != SINGLEMAC_SINGLEPHY)
+		page_count = 24;
+
+	rtl_write_byte(rtlpriv, REG_TRXDMA_CTRL,
+		       rtl_read_byte(rtlpriv, REG_TRXDMA_CTRL) | RXDMA_AGG_EN);
+	/* unit: 128 bytes */
+	rtl_write_byte(rtlpriv, REG_RXDMA_AGG_PG_TH, page_count);
+	/* A larger value is a shorter timeout. */
+	rtl_write_byte(rtlpriv, REG_USB_DMA_AGG_TO, 6);
+}
+
 static void _rtl92du_init_operation_mode(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -712,7 +728,7 @@ int rtl92du_hw_init(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, REG_RARFRC + 4, 0x08070605);
 
 	_rtl92du_init_retry_function(hw);
-	/* _InitUsbAggregationSetting(padapter); no aggregation for now */
+	_rtl92du_init_usb_aggregation(hw);
 	_rtl92du_init_operation_mode(hw);
 	_rtl92du_init_beacon_parameters(hw);
 	_rtl92du_init_ampdu_aggregation(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
index 88e8cc590c544b..6b90002b69f41a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
@@ -238,7 +238,7 @@ static const struct rtl_hal_usbint_cfg rtl92du_interface_cfg = {
 	.rx_urb_num = 8,
 	.rx_max_size = 15360,
 	.usb_rx_hdl = NULL,
-	.usb_rx_segregate_hdl = NULL,
+	.usb_rx_segregate_hdl = rtl92du_rx_segregate_hdl,
 	/* tx */
 	.usb_tx_cleanup = rtl92du_tx_cleanup,
 	.usb_tx_post_hdl = rtl92du_tx_post_hdl,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c
index c608c51f1b785c..13364cdc7fa367 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c
@@ -19,6 +19,51 @@ int rtl92du_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
 	return 0;
 }
 
+void rtl92du_rx_segregate_hdl(struct ieee80211_hw *hw, struct sk_buff *skb,
+			      struct sk_buff_head *queue)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	unsigned int offset = 0, pkt_size;
+	struct sk_buff *new_skb;
+	__le32 *rxdesc;
+
+	while (skb->len - offset >= RTL_RX_DESC_SIZE) {
+		rxdesc = (__le32 *)(skb->data + offset);
+		pkt_size = RTL_RX_DESC_SIZE +
+			   get_rx_desc_drv_info_size(rxdesc) *
+			   RX_DRV_INFO_SIZE_UNIT +
+			   get_rx_desc_shift(rxdesc) +
+			   get_rx_desc_pkt_len(rxdesc);
+
+		if (get_rx_desc_pkt_len(rxdesc) == 0 ||
+		    pkt_size > skb->len - offset) {
+			rtl_dbg(rtlpriv, COMP_RECV, DBG_WARNING,
+				"bad frame at %u of %u, size %u\n",
+				offset, skb->len, pkt_size);
+			break;
+		}
+
+		/* The last frame keeps the original skb. */
+		if (ALIGN(pkt_size, RTL92DU_RX_AGG_ALIGN) >= skb->len - offset) {
+			skb_pull(skb, offset);
+			skb_trim(skb, pkt_size);
+			__skb_queue_tail(queue, skb);
+			return;
+		}
+
+		new_skb = dev_alloc_skb(pkt_size + RTL92DU_RX_HEADROOM);
+		if (!new_skb)
+			break;
+		skb_reserve(new_skb, RTL92DU_RX_HEADROOM);
+		skb_put_data(new_skb, rxdesc, pkt_size);
+		__skb_queue_tail(queue, new_skb);
+
+		offset += ALIGN(pkt_size, RTL92DU_RX_AGG_ALIGN);
+	}
+
+	dev_kfree_skb_any(skb);
+}
+
 struct sk_buff *rtl92du_tx_aggregate_hdl(struct ieee80211_hw *hw,
 					 struct sk_buff_head *list)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.h
index 8c3d24622fa7ce..807245a91bbee3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.h
@@ -18,6 +18,9 @@
 
 #define WMM_NORMAL_TX_TOTAL_PAGE_NUMBER			0xF5
 
+#define RTL92DU_RX_HEADROOM				32
+#define RTL92DU_RX_AGG_ALIGN				128
+
 #define WMM_NORMAL_PAGE_NUM_PUBQ_92D			0x65
 #define WMM_NORMAL_PAGE_NUM_HPQ_92D			0x30
 #define WMM_NORMAL_PAGE_NUM_LPQ_92D			0x30
@@ -56,5 +59,7 @@ struct sk_buff *rtl92du_tx_aggregate_hdl(struct ieee80211_hw *hw,
 void rtl92du_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
 int rtl92du_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
 			struct sk_buff *skb);
+void rtl92du_rx_segregate_hdl(struct ieee80211_hw *hw, struct sk_buff *skb,
+			      struct sk_buff_head *queue);
 
 #endif
-- 
2.53.0

