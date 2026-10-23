Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796479;
	b=MdYqqp8K7oIA+qLxjBVUYB7ycXXrtvRP7yiOKnfYAMWIEDEznnSlFbNPLVkEGHeLm63M
	 8F28+oRZ0kr2u1oLvmnEBtOjgmlwkUDYuy8645XEIZ9hqgk9mO0Jsd0zGHpEzOHPTTO/X
	 vvxWp5ZGFCcId5+GbYrKwPDZB7liSfQrshA4BZS15vRxNO02qkpC9DVglP2lllNtySCzF
	 5yF0cMPnaIGfxbTvnVn3/a5aNRMROZEHcJ/KXXAXItVF/fyGNOAXr5rAyW1KeH7iU73i8
	 Ra5TDPijjuFCX4oGJVFvYGU/kw8rTmLDwhCOctWv1aMehyaH+GAvM1vCeTtlWhLXZDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=tTSDRkaddFN6NJuzDVU53nSBAXWOWOdDfoviQEOmVmA=;
	b=iCBE43JPg9S276paVaLxrgad5wGkYaCOU6MiZwVljhipj8tSiL+pyoxaQTxZMIZeMn0W
	 Bcqge3rViwf1dLebeE+1uDFgOfrdxMyoImN80sfQyvg83uglUFg55DixVXwrIvey4Aq3Y
	 3pfhTwKQ6aUcC7DgC5d7A9i7VK9o6Z2j5iVCg+PXrVWeLd69peQZ/5ALoP2ntSbuQ/sC+
	 0+2NKd4d31rcS4gBWCSHdoxtPdZLbe5MFIL5qxWDLqYA9tySBq8XDu6l90yJQI4pbEAmM
	 kHf1XCDHjlSfWD/Adhovg1hliykzkh42JJstG+T2f9ebzuDo2YKE1ttkfP7lowqiWJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kkIp0YTd;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B446E606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 23:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B446E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kkIp0YTd
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so6623645e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796477; x=1793401277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tTSDRkaddFN6NJuzDVU53nSBAXWOWOdDfoviQEOmVmA=;
        b=kkIp0YTd/Y3qvfZ+t3+Qb6o4nIzeT0JkwJA9Pwn6dpiLVujACex3WxNRZptRD+UHnf
         VcKSLM1gOFb1QSPUnyKboZ9mUzFwMujKcZDP65546mGYO/W2+HfKeIyD1YU5BUmjFw5n
         jUitCYkqEbaBbN7Lc0XvunJ8ig/ih6CXw8rH3EO0TWvXhvwFVtdPiEdqRyjsUdQ9SQ/4
         LI3hh2kTEW2tUJeiQMWs76fVkB6PGb65Vl/OpedOXI7YIevyug1yJ7FVeoMxCm/Gq4Qs
         7xpOJTyiZ9Epp0WLkIJWpxQJfZk573xVFhv7wWPXadBKwU9uVgpjYtyboNN/FQf7/ipt
         SSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796477; x=1793401277;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTSDRkaddFN6NJuzDVU53nSBAXWOWOdDfoviQEOmVmA=;
        b=sYjTJos8FpCijn58YF+qp0IbuTNVNXhiWjHB38skeRoOJmuIOL0+NJVQYt2n4K7wOE
         5JvlujpqV+dwvlC39z4Kcp+mdPpNt6CDyNdHf+SRdTiB+IoRjbvq1hMlUB3LCbHLT8kU
         U04dNh5BArRKi3rfFsZJ3ifbH5BvGwMHprUthXeB64sDUfMF8sO7vej0f6q7/tUwC1Ap
         6I+C6ugBi4GsBMPDZwG1jfMjviPe5hS2zFbVi1D91LJmE8w4AVAMpeQhx+iPjJ0ZKkRz
         7rm2Q7L8jFl9N1xD206IUg0u6RmYkOdB53bRNmI5j+DL7rz1eSrU6G2AiHogAqNzjED0
         5z4Q==
X-Gm-Message-State: AFq9FYI87cKsG/edxYpJvkSPORYc+NYog8x2QVt9W3mdVqxcmi400gj+
	pu/1KvuOCx2FPXTt4Po2HzQc+quYHpiaKIZ6ki59AQpDYrbrAOgGZC4uqwCVdQ==
X-Gm-Gg: AYBFou3kfamTnBWt3q0BNRhj03LZwYy3WESaeeA1OX9TpyjEC+gHEGpMFCiPVXsE70g
	DFTRzxZuwwLXilCdoeYUMCfVr8RniRXDcrHHBJTz05d54d6eONnBogKCN8xmYZHJ1PY4l+9icWN
	1LqVz6exKbHr4NHf1nFJcjDAJa8wkmb6WI/TNuAdDndIBhnzvGnshai9pwVlCih6KFopV1blL66
	l2dGR7HWjoYzd4xsfQJZPvOT9v/CpqpwCMZMCMvEVbLDFC7UJ5/pDMBI/f2AwI2hlxCJ7RTOXoD
	U9hnygR4sKuZ37LI4d4q1KI92ZPN5NkbDJMJ/cSYE0+47JMPaU2UyJb/cKnLZptixvcSmRa5t9t
	9V/PqUHGwsksmN0e31gbWFnyhWV3Y+55jPTdSVAEMwP9lhPYIbvgEINKDi5js0ACDgu87dRLfyB
	D7qvimFP+83Hx7MMpWiAhCnnzADB4AW+2XFxX8b/YExNirC09cO/X9xKtbkGx7WMxjVI6lIN5zo
	hQd1mqeXBrlLY77Ub+voNh3PyKOaxuRBjB9s4Pxzeh5afv8wm7hgKFbFubxhJ4=
X-Received: by 2002:a05:600c:4e87:b0:49f:c199:e1e2 with SMTP id 5b1f17b1804b1-4a35acbea9amr5691605e9.28.1792796476835;
        Fri, 23 Oct 2026 16:01:16 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0aa097sm14944355e9.3.2026.10.23.16.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 16:01:16 -0700 (PDT)
Message-ID: <fc308de1-a470-4890-a86a-d8936e093bd5@gmail.com>
Date: Sat, 24 Oct 2026 02:01:15 +0300
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
Subject: [PATCH rtw-next 3/5] wifi: rtw88: pci: Introduce struct rtw_pci_gen
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Language: en-US
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Move a few functions into a new struct rtw_pci_gen in order to add
support for RTL8821AE and RTL8812AE. That is an older generation of
chips which handle the PCI communications differently.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c      | 109 ++++++++++++------
 drivers/net/wireless/realtek/rtw88/pci.h      |  35 ++++++
 .../net/wireless/realtek/rtw88/rtw8723de.c    |   7 +-
 .../net/wireless/realtek/rtw88/rtw8814ae.c    |   7 +-
 .../net/wireless/realtek/rtw88/rtw8821ce.c    |   9 +-
 .../net/wireless/realtek/rtw88/rtw8822be.c    |   7 +-
 .../net/wireless/realtek/rtw88/rtw8822ce.c    |   9 +-
 7 files changed, 143 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index d8c5c11bf728..c51ad15cfba7 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -254,6 +254,8 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				struct rtw_pci_rx_ring *rx_ring,
 				u8 desc_size, u32 len)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
 	struct sk_buff *skb = NULL;
 	dma_addr_t dma;
@@ -269,6 +271,11 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		return -ENOMEM;
 	}
 	rx_ring->r.head = head;
+	rx_ring->r.dma = dma;
+	rx_ring->r.len = len;
+	rx_ring->r.desc_size = desc_size;
+	rx_ring->r.wp = 0;
+	rx_ring->r.rp = 0;
 
 	for (i = 0; i < len; i++) {
 		skb = dev_alloc_skb(buf_sz);
@@ -280,7 +287,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 
 		memset(skb->data, 0, buf_sz);
 		rx_ring->buf[i] = skb;
-		ret = rtw_pci_reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
+		ret = pci_gen->reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
 		if (ret) {
 			allocated = i;
 			dev_kfree_skb_any(skb);
@@ -288,12 +295,6 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		}
 	}
 
-	rx_ring->r.dma = dma;
-	rx_ring->r.len = len;
-	rx_ring->r.desc_size = desc_size;
-	rx_ring->r.wp = 0;
-	rx_ring->r.rp = 0;
-
 	return 0;
 
 err_out:
@@ -316,6 +317,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 static int rtw_pci_init_trx_ring(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	struct rtw_pci_tx_ring *tx_ring;
 	struct rtw_pci_rx_ring *rx_ring;
 	const struct rtw_chip_info *chip = rtwdev->chip;
@@ -329,7 +331,7 @@ static int rtw_pci_init_trx_ring(struct rtw_dev *rtwdev)
 	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
 		tx_ring = &rtwpci->tx_rings[i];
 		len = max_num_of_tx_queue(i);
-		ret = rtw_pci_init_tx_ring(rtwdev, tx_ring, tx_desc_size, len);
+		ret = pci_gen->init_tx_ring(rtwdev, tx_ring, tx_desc_size, len);
 		if (ret)
 			goto out;
 	}
@@ -525,7 +527,7 @@ static void rtw_pci_dma_reset(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci)
 	rtwpci->rx_tag = 0;
 }
 
-static int rtw_pci_setup(struct rtw_dev *rtwdev)
+static int rtw_pci_reset(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 
@@ -535,6 +537,14 @@ static int rtw_pci_setup(struct rtw_dev *rtwdev)
 	return 0;
 }
 
+static int rtw_pci_setup(struct rtw_dev *rtwdev)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
+
+	return pci_gen->reset(rtwdev);
+}
+
 static void rtw_pci_dma_release(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci)
 {
 	struct rtw_pci_tx_ring *tx_ring;
@@ -710,7 +720,7 @@ static u32 __pci_get_hw_tx_ring_rp(struct rtw_dev *rtwdev, u8 pci_q)
 	return FIELD_GET(TRX_BD_IDX_MASK, bd_idx);
 }
 
-static void __pci_flush_queue(struct rtw_dev *rtwdev, u8 pci_q, bool drop)
+static void rtw_pci_flush_queue(struct rtw_dev *rtwdev, u8 pci_q, bool drop)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring = &rtwpci->tx_rings[pci_q];
@@ -738,6 +748,9 @@ static void __pci_flush_queue(struct rtw_dev *rtwdev, u8 pci_q, bool drop)
 static void __rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 pci_queues,
 				   bool drop)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
+
 	u8 q;
 
 	for (q = 0; q < RTK_MAX_TX_QUEUE_NUM; q++) {
@@ -747,7 +760,7 @@ static void __rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 pci_queues,
 			continue;
 
 		if (pci_queues & BIT(q))
-			__pci_flush_queue(rtwdev, q, drop);
+			pci_gen->flush_queue(rtwdev, q, drop);
 	}
 }
 
@@ -790,11 +803,12 @@ static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev,
 static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	enum rtw_tx_queue_type queue;
 
 	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++)
 		if (test_and_clear_bit(queue, rtwpci->tx_queued))
-			rtw_pci_tx_kick_off_queue(rtwdev, queue);
+			pci_gen->tx_kick_off_queue(rtwdev, queue);
 }
 
 static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
@@ -867,28 +881,32 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 	return 0;
 }
 
+static void rtw_pci_kick_beacon_queue(struct rtw_dev *rtwdev)
+{
+	rtw_write8_set(rtwdev, RTK_PCI_TXBD_BCN_WORK, BIT_PCI_BCNQ_FLAG);
+}
+
 static int rtw_pci_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 					u32 size)
 {
-	struct sk_buff *skb;
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	struct rtw_tx_pkt_info pkt_info = {0};
-	u8 reg_bcn_work;
+	struct sk_buff *skb;
 	int ret;
 
 	skb = rtw_tx_write_data_rsvd_page_get(rtwdev, &pkt_info, buf, size);
 	if (!skb)
 		return -ENOMEM;
 
-	ret = rtw_pci_tx_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_BCN);
+	ret = pci_gen->tx_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_BCN);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write rsvd page data\n");
 		return ret;
 	}
 
 	/* reserved pages go through beacon queue */
-	reg_bcn_work = rtw_read8(rtwdev, RTK_PCI_TXBD_BCN_WORK);
-	reg_bcn_work |= BIT_PCI_BCNQ_FLAG;
-	rtw_write8(rtwdev, RTK_PCI_TXBD_BCN_WORK, reg_bcn_work);
+	pci_gen->kick_beacon_queue(rtwdev);
 
 	return 0;
 }
@@ -920,10 +938,11 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
 {
 	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	struct rtw_pci_tx_ring *ring;
 	int ret;
 
-	ret = rtw_pci_tx_write_data(rtwdev, pkt_info, skb, queue);
+	ret = pci_gen->tx_write_data(rtwdev, pkt_info, skb, queue);
 	if (ret)
 		return ret;
 
@@ -1174,6 +1193,7 @@ static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
 {
 	struct rtw_dev *rtwdev = dev;
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	u32 irq_status[4];
 	bool rx = false;
 
@@ -1181,19 +1201,19 @@ static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
 	rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
 
 	if (irq_status[0] & IMR_MGNTDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_MGMT);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_MGMT);
 	if (irq_status[0] & IMR_HIGHDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_HI0);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_HI0);
 	if (irq_status[0] & IMR_BEDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_BE);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_BE);
 	if (irq_status[0] & IMR_BKDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_BK);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_BK);
 	if (irq_status[0] & IMR_VODOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_VO);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_VO);
 	if (irq_status[0] & IMR_VIDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_VI);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_VI);
 	if (irq_status[3] & IMR_H2CDOK)
-		rtw_pci_tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_H2C);
+		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_H2C);
 	if (irq_status[0] & IMR_ROK) {
 		rtw_pci_rx_isr(rtwdev);
 		rx = true;
@@ -1385,6 +1405,7 @@ static void rtw_pci_aspm_set(struct rtw_dev *rtwdev, bool enable)
 static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 
 	/* Like CLKREQ, ASPM is also implemented by two HW modules, and can
 	 * only be enabled when host supports it.
@@ -1401,13 +1422,14 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 
 	if ((enter && atomic_dec_if_positive(&rtwpci->link_usage) == 0) ||
 	    (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
-		rtw_pci_aspm_set(rtwdev, enter);
+		pci_gen->aspm_set(rtwdev, enter);
 }
 
 static void rtw_pci_link_cfg(struct rtw_dev *rtwdev)
 {
-	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
+	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct pci_dev *pdev = rtwpci->pdev;
 	u16 link_ctrl;
 	int ret;
@@ -1441,7 +1463,7 @@ static void rtw_pci_link_cfg(struct rtw_dev *rtwdev)
 	}
 
 	if (link_ctrl & PCI_EXP_LNKCTL_CLKREQ_EN)
-		rtw_pci_clkreq_set(rtwdev, true);
+		pci_gen->clkreq_set(rtwdev, true);
 
 	rtwpci->link_ctrl = link_ctrl;
 }
@@ -1664,6 +1686,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 	struct rtw_pci *rtwpci = container_of(napi, struct rtw_pci, napi);
 	struct rtw_dev *rtwdev = container_of((void *)rtwpci, struct rtw_dev,
 					      priv);
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	int work_done = 0;
 
 	if (rtwpci->rx_no_aspm)
@@ -1672,8 +1695,9 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 	while (work_done < budget) {
 		u32 work_done_once;
 
-		work_done_once = rtw_pci_rx_napi(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU,
-						 budget - work_done);
+		work_done_once = pci_gen->rx_napi(rtwdev, rtwpci,
+						  RTW_RX_QUEUE_MPDU,
+						  budget - work_done);
 		if (work_done_once == 0)
 			break;
 		work_done += work_done_once;
@@ -1689,7 +1713,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 		 * not be processed immediately. Check whether dma ring is
 		 * empty and perform napi_schedule accordingly.
 		 */
-		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
+		if (pci_gen->get_hw_rx_ring_nr(rtwdev, rtwpci))
 			napi_schedule(napi);
 	}
 	if (rtwpci->rx_no_aspm)
@@ -1826,6 +1850,7 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
+	struct rtw_pci_info *pci_info = (struct rtw_pci_info *)id->driver_data;
 	struct pci_dev *bridge = pci_upstream_bridge(pdev);
 	struct ieee80211_hw *hw;
 	struct rtw_dev *rtwdev;
@@ -1843,13 +1868,15 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	rtwdev = hw->priv;
 	rtwdev->hw = hw;
 	rtwdev->dev = &pdev->dev;
-	rtwdev->chip = (struct rtw_chip_info *)id->driver_data;
+	rtwdev->chip = pci_info->chip_info;
 	rtwdev->hci.ops = &rtw_pci_ops;
 	rtwdev->hci.type = RTW_HCI_TYPE_PCIE;
 
 	rtwpci = (struct rtw_pci *)rtwdev->priv;
 	atomic_set(&rtwpci->link_usage, 1);
 
+	rtwpci->gen = pci_info->pci_gen;
+
 	dmi_check_system(rtw_pci_quirks);
 
 	ret = rtw_core_init(rtwdev);
@@ -1966,6 +1993,22 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(rtw_pci_shutdown);
 
+const struct rtw_pci_gen rtw_pci_gen_new = {
+	.init_tx_ring = rtw_pci_init_tx_ring,
+	.reset_rx_desc = rtw_pci_reset_rx_desc,
+	.reset = rtw_pci_reset,
+	.flush_queue = rtw_pci_flush_queue,
+	.tx_kick_off_queue = rtw_pci_tx_kick_off_queue,
+	.tx_write_data = rtw_pci_tx_write_data,
+	.kick_beacon_queue = rtw_pci_kick_beacon_queue,
+	.tx_isr = rtw_pci_tx_isr,
+	.get_hw_rx_ring_nr = rtw_pci_get_hw_rx_ring_nr,
+	.rx_napi = rtw_pci_rx_napi,
+	.clkreq_set = rtw_pci_clkreq_set,
+	.aspm_set = rtw_pci_aspm_set,
+};
+EXPORT_SYMBOL(rtw_pci_gen_new);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek PCI 802.11ac wireless driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 8ffdea11378f..5ab78ba3255d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -203,8 +203,37 @@ struct rtw_pci_rx_ring {
 
 #define RX_TAG_MAX	8192
 
+struct rtw_pci;
+
+struct rtw_pci_gen {
+	int (*init_tx_ring)(struct rtw_dev *rtwdev,
+			    struct rtw_pci_tx_ring *tx_ring,
+			    u8 desc_size, u32 len);
+	int (*reset_rx_desc)(struct rtw_dev *rtwdev, struct sk_buff *skb,
+			     struct rtw_pci_rx_ring *rx_ring, u32 idx,
+			     u32 desc_sz);
+	int (*reset)(struct rtw_dev *rtwdev);
+	void (*flush_queue)(struct rtw_dev *rtwdev, u8 pci_q, bool drop);
+	void (*tx_kick_off_queue)(struct rtw_dev *rtwdev,
+				  enum rtw_tx_queue_type queue);
+	int (*tx_write_data)(struct rtw_dev *rtwdev,
+			     struct rtw_tx_pkt_info *pkt_info,
+			     struct sk_buff *skb,
+			     enum rtw_tx_queue_type queue);
+	void (*kick_beacon_queue)(struct rtw_dev *rtwdev);
+	void (*tx_isr)(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
+		       u8 hw_queue);
+	int (*get_hw_rx_ring_nr)(struct rtw_dev *rtwdev,
+				 struct rtw_pci *rtwpci);
+	u32 (*rx_napi)(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
+		       u8 hw_queue, u32 limit);
+	void (*clkreq_set)(struct rtw_dev *rtwdev, bool enable);
+	void (*aspm_set)(struct rtw_dev *rtwdev, bool enable);
+};
+
 struct rtw_pci {
 	struct pci_dev *pdev;
+	const struct rtw_pci_gen *gen;
 
 	/* Used for PCI interrupt. */
 	spinlock_t hwirq_lock;
@@ -230,8 +259,14 @@ struct rtw_pci {
 	void __iomem *mmap;
 };
 
+struct rtw_pci_info {
+	const struct rtw_chip_info *chip_info;
+	const struct rtw_pci_gen *pci_gen;
+};
+
 extern const struct dev_pm_ops rtw_pm_ops;
 extern const struct pci_error_handlers rtw_pci_err_handler;
+extern const struct rtw_pci_gen rtw_pci_gen_new;
 
 int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 void rtw_pci_remove(struct pci_dev *pdev);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723de.c b/drivers/net/wireless/realtek/rtw88/rtw8723de.c
index c6d0c88e5d81..894b6639ac98 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723de.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723de.c
@@ -7,10 +7,15 @@
 #include "pci.h"
 #include "rtw8723d.h"
 
+static const struct rtw_pci_info rtw_8723de_pci_info = {
+	.chip_info = &rtw8723d_hw_spec,
+	.pci_gen = &rtw_pci_gen_new,
+};
+
 static const struct pci_device_id rtw_8723de_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xD723),
-		.driver_data = (kernel_ulong_t)&rtw8723d_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8723de_pci_info
 	},
 	{}
 };
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814ae.c b/drivers/net/wireless/realtek/rtw88/rtw8814ae.c
index c7436f1c8d40..bfcf4c073a39 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814ae.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814ae.c
@@ -7,10 +7,15 @@
 #include "pci.h"
 #include "rtw8814a.h"
 
+static const struct rtw_pci_info rtw_8814ae_pci_info = {
+	.chip_info = &rtw8814a_hw_spec,
+	.pci_gen = &rtw_pci_gen_new,
+};
+
 static const struct pci_device_id rtw_8814ae_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8813),
-		.driver_data = (kernel_ulong_t)&rtw8814a_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8814ae_pci_info
 	},
 	{}
 };
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821ce.c b/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
index 52a19cb17daa..b696a83eeb33 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
@@ -7,14 +7,19 @@
 #include "pci.h"
 #include "rtw8821c.h"
 
+static const struct rtw_pci_info rtw_8821ce_pci_info = {
+	.chip_info = &rtw8821c_hw_spec,
+	.pci_gen = &rtw_pci_gen_new,
+};
+
 static const struct pci_device_id rtw_8821ce_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xB821),
-		.driver_data = (kernel_ulong_t)&rtw8821c_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8821ce_pci_info
 	},
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC821),
-		.driver_data = (kernel_ulong_t)&rtw8821c_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8821ce_pci_info
 	},
 	{}
 };
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822be.c b/drivers/net/wireless/realtek/rtw88/rtw8822be.c
index dda597d73219..b6ff59820bc5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822be.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822be.c
@@ -7,10 +7,15 @@
 #include "pci.h"
 #include "rtw8822b.h"
 
+static const struct rtw_pci_info rtw_8822be_pci_info = {
+	.chip_info = &rtw8822b_hw_spec,
+	.pci_gen = &rtw_pci_gen_new,
+};
+
 static const struct pci_device_id rtw_8822be_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xB822),
-		.driver_data = (kernel_ulong_t)&rtw8822b_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8822be_pci_info
 	},
 	{}
 };
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 7ae95415c224..96ec95582bc8 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
@@ -7,14 +7,19 @@
 #include "pci.h"
 #include "rtw8822c.h"
 
+static const struct rtw_pci_info rtw_8822ce_pci_info = {
+	.chip_info = &rtw8822c_hw_spec,
+	.pci_gen = &rtw_pci_gen_new,
+};
+
 static const struct pci_device_id rtw_8822ce_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC822),
-		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8822ce_pci_info
 	},
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC82F),
-		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec
+		.driver_data = (kernel_ulong_t)&rtw_8822ce_pci_info
 	},
 	{}
 };
-- 
2.55.0

