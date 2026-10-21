Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591163;
	b=dMpZrsscBz1CyXqB0sCyJfFJae8MkxCvmRgiDKUq/EEBqffRwbguZkX33+7sztd3z1Mw
	 E/Ia3LjxAKQlLBL+Ag+BTqdV+rDsQsmra/O43vs+THYws2CJFH9Ajxwsbi+EqLcW5rugX
	 Cn/TIvIx13GzCpLmOJ7+chth7Ju3TBU8Vo/IRMfQEMzklA8aSw5cXQp55pUFPgYt41KRx
	 et/jOF6WgP5CYDxMQL4cTO+r4m8cdTVHA0CxdPBjS9npjfsE1gl5NIx3hpSgFu2XLwZa1
	 QWT8WPnrEmSdSLzKb6ClinKRzyKlZYaOfmaOUxeb+RfmsW8TNIkgPDsfYbxDpEuFA0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591163;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-Originating-IP:X-CM-SenderInfo;
	bh=bDfx/4WCAv1rBJxAVMVdyCbWHjTx3I4G7h/ZOCRuQlo=;
	b=jz+8V5++O4n7Kgi7/C2iI35fItsWkkoSlVgS7QCa+1QnoqEmGHK1Uf7gexi61DHxK/qx
	 Y9WQZ2YiVC6je2inIsRf5I4OuHc+3PyQW0euYjTxdSneUGqlsoC0HkhHvs0MmX4Y/xT+a
	 xmwUX1zAKr8eBYdTbJj8l5QMx4HxoDF0Boc7IDTLMY6KDQ9mhk0r25Sy6hxVpvjtCl15l
	 99VGBGQYFVQur0P77S+SfLrof1Z5OCinRqJ/TXiqQTZaYpGhZe7KS8fxLZfPnPlMWk4TF
	 UEvzboeDANL4/As9wgPhoHALuX0WFFdzQlzmgiG+g4Rg9lRNWZsg2DadJ7pPLMIUwGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="NEx/AIBK";
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D69B606A320
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D69B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=NEx/AIBK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=bD
	fx/4WCAv1rBJxAVMVdyCbWHjTx3I4G7h/ZOCRuQlo=; b=NEx/AIBKwoFo8EHU7w
	Ucr9e1jnLBTE+lF6BzFq5Ekc969YUViez1O5CYxmWUcEeojHVE1KTmnmIIx06sz1
	mufsJObITwTA3ZcW4esRw9U4C6K3FvdYHKyg148g4RLA2KMpvW9Nlbb5I9gI84HR
	SDWUSiPVxi8ZBOdFd3d6pC2q4=
Received: from LAPTOP-137NTCJO (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3fxUvxdhq2hgEBw--.42856S3;
	Wed, 21 Oct 2026 21:59:17 +0800 (CST)
From: Jiaxin Li <18135327133@163.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 1/1] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
Date: Wed, 21 Oct 2026 21:59:06 +0800
Message-ID: <20261021135906.1493-2-18135327133@163.com>
X-Mailer: git-send-email 2.56.0.windows.2
In-Reply-To: <20261021135906.1493-1-18135327133@163.com>
References: <20261021135906.1493-1-18135327133@163.com>
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
X-CM-TRANSID:_____wD3fxUvxdhq2hgEBw--.42856S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4DtF1ruFWxXry8Gr4fAFb_yoW8WF48pF
	W5Ga1UAF1akF4xG3y8tw47Kr1Fgw48JasxCF4rZa43Ca98JF1FgF1kWayavrWrJF4xXF45
	JF1ktw43Cw13ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRVVbPUUUUU=
X-CM-SenderInfo: zpryijyvtsliitt6il2tof0z/xtbC6hVPEGrYxTWHKQAA3M

rtl8180_handle_rx() passes the 12-bit length field from the RX
descriptor to skb_put() without clamping it to MAX_RX_SIZE.  The skb was
allocated with dev_alloc_skb(MAX_RX_SIZE), so a descriptor length above
MAX_RX_SIZE extends the skb past its allocated tailroom.

Store the reported length in a local variable and drop the frame before
allocating the replacement RX skb when it exceeds MAX_RX_SIZE.

Signed-off-by: Jiaxin Li <18135327133@163.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 4a5989172..d82d54112 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -255,7 +255,13 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			goto done;
 		else {
 			struct ieee80211_rx_status rx_status = {0};
-			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
+			u32 rx_len = flags & 0xFFF;
+			struct sk_buff *new_skb;
+
+			if (unlikely(rx_len > MAX_RX_SIZE))
+				goto done;
+
+			new_skb = dev_alloc_skb(MAX_RX_SIZE);
 
 			if (unlikely(!new_skb))
 				goto done;
@@ -274,7 +280,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			dma_unmap_single(&priv->pdev->dev,
 					 *((dma_addr_t *)skb->cb),
 					 MAX_RX_SIZE, DMA_FROM_DEVICE);
-			skb_put(skb, flags & 0xFFF);
+			skb_put(skb, rx_len);
 
 			rx_status.antenna = (flags2 >> 15) & 1;
 			rx_status.rate_idx = (flags >> 20) & 0xF;
-- 
2.34.1

