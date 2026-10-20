Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497589;
	b=4v4kN8FwiSi5KkUKGDmaQCifiCLI20aKjuGTagb5SoCY9nw/BSfRtqhpU+7AozmRM5bj
	 XK5EZeGiaIENPVDStEM7O0mIuZOdt2VbLlkkEmqvGXhuQMsBYtzaZ+W1lUjwjNPYm6UUz
	 eTdVDwuAYGkVOogKooltdIt8NEzEeccH30Qj5KQ6hfXF9intTiXv7VOx8r4ovl0CRgepk
	 6kPtWNGjSYq6MlLgAqHKIVdcbLNTzaFuuYB9CARdfwMcMaRRi5lhwlM2/m1gyah6gbRiT
	 HnnBShM4LZS5/mhQnye2wLxcPc6+ZmjamtUKjMyjOH6I9kNY+8Y8p08DXffzhUYivuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497589;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=IIc3DKzun1pG6SrMFT0BAk7s2ijhu7EMG+Da8jqWvQs=;
	b=oWZohj2aV+OyRd82jco35Basju1CyqovEpI0kSyAjXA3Pixi80lxMR1xeLC45TTRzBCY
	 xvdRZfPA8bS2Z/zoqtG5Jp5TiqypKaef6JRgjfITCzow7lHThtnfIiNpglwFduegnePeJ
	 MeR9QJFB4BJ6oV7+P98vF2mD1wuPERTEGOAP2lwrrZIwo4LjEDhmIiDozj72lp66hRLve
	 F5vsCZdMAw93gzUrPvSwDyoxbIUesMsxtVy8tspkBbJgh5ipw7mb42eJ/occ1dP2criEI
	 CDzKnxn0oq3UUfW6Kw0gW0LT9PARsrLSHvzDQJRHuGW44nDQ2wd16etHw5p8hX0KyrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FeJWogXh;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6F6606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 11:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E6F6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FeJWogXh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=II
	c3DKzun1pG6SrMFT0BAk7s2ijhu7EMG+Da8jqWvQs=; b=FeJWogXhhwxW2sp0Uu
	G+SYGyqngW28wX/JGLUDAw5I3ko2VSsRRpRHEFKedXI7L0S1kGN7rPW1ocnb62iI
	knLOVN4hiXkNbXljrr9HP4XdqQ0U8mzSZ8Tm94BM4bVouhEKielURE2wdG8QkN5N
	YJUaNvQxXLgK3+SN3/WMh5NKY=
Received: from LAPTOP-137NTCJO (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAXz6WtV9dqUvDzAw--.60866S2;
	Tue, 20 Oct 2026 19:59:43 +0800 (CST)
From: Jiaxin Li <18135327133@163.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
Date: Tue, 20 Oct 2026 19:59:38 +0800
Message-ID: <20261020115938.1433-1-18135327133@163.com>
X-Mailer: git-send-email 2.56.0.windows.2
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
X-CM-TRANSID:QCgvCgAXz6WtV9dqUvDzAw--.60866S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4DtF1ruFWxXry8Gr4fAFb_yoW8ArWDpF
	W5Ga1jyF1ayF4xG3yIqa1IkF1Sga1rJasxCF4rZa43Ca98JF1FgF1kWayavFWrJFWxXa15
	Xr1kt3y3Ca1aya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR4CJJUUUUU=
X-CM-SenderInfo: zpryijyvtsliitt6il2tof0z/xtbC6RCSU2rXV7BOhwAA3r

rtl8180_handle_rx() passes the 12-bit length field from the RX
descriptor to skb_put() without clamping it to MAX_RX_SIZE.  The skb was
allocated with dev_alloc_skb(MAX_RX_SIZE), so a descriptor length above
MAX_RX_SIZE extends the skb past its allocated tailroom.

Store the reported length in a local variable and drop the frame before
allocating the replacement RX skb when it exceeds MAX_RX_SIZE.

Signed-off-by: Jiaxin Li <18135327133@163.com>
---
Changes in v2:
- Store the descriptor length in rx_len and reuse it in skb_put(),
  as suggested in review.

 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 4a5989172..24e96b356 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -255,7 +255,13 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			goto done;
 		else {
 			struct ieee80211_rx_status rx_status = {0};
-			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
+			struct sk_buff *new_skb;
+			u32 rx_len = flags & 0xFFF;
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

