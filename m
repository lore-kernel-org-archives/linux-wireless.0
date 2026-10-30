Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793332033;
	b=sxARGyFPIuh60QQlzLoY1InHtbnRcE9vRu+fsinVs2rCFbeST6O9PWJTioNgaTiFG1Nl
	 hr0zhMBGbL5xXDjiS/5VLrOAjXRB1dGBpL9k+v6givsmpOp3mH6L9jBdsw3Vfo14dhE2l
	 M0aQtHE8dmPkDb8sslPempAWXE9CuRfYbIITtnw54ECRvxYayBJCI+4zrWUsAKTrTqdxy
	 abAzQ4YUpWQ2d1TDqbK+ckZMLviY2g2YJkE58+5Z4FLxI68UAtnEoVrX9klrquj9gcYkh
	 cZUgAcdyGWPQdP0mfgWD15eRtVvFBbtuibjpQgGRyZjxN5bcCVp43IAZhDRosp2l2iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793332033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tLmGNIT9IaTeNDNZlYbjqo+wSUzAVTWlQnSozIZPBz0=;
	b=PaQntT5tGB5fEWVoK26cNJY8Mg3GZHprfZ8UU73cYl80HNulj/6acxr8rs0UTBJhXOUK
	 vD3k1ATE8Mq+UNANGvUsYcqrdVCY5IlFWO7s6XEeHyDdd+8bpR+Cd44iAUtZFpByx2nug
	 1NWenL7TSREnKlxWYHPNOKs8yf6nKZ8WIluWR0dvwEFV22PBPUcwACU4hPpuOd5zxUYxG
	 Iq8Ygi+XhZa9X/CEKEWooC4nAy9HnxmkDbAIoz1+GUwsgXiZI9Q74DqgK1u9V16nMge+E
	 hQ+7rtOikrGGbSEXqx8E1///1bBha6CqQB4scgjN485zSZIFmaDCSW1L0ujnlqFBtIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zpdBKLOn;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D144606A330
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 03:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D144606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zpdBKLOn
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso74548a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 20:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793332032; x=1793936832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tLmGNIT9IaTeNDNZlYbjqo+wSUzAVTWlQnSozIZPBz0=;
        b=zpdBKLOnlTxgFD1X5TQcddC2DgsC+Pn1Gzbam2yYUTYdTLsB3GCkIAXj76X9KUje/t
         Iut/UgX5JgtAsOfVTphpzqIWmPPdsFPpw62FpuTQAwpkoPp9j2TgNqaJ77bC3acTIGlI
         xfp/f3FbCf2HsMrzgl7mFc51qt3pLwCp35a2Z+Oe2+sKQ9FvVgnF/pWp9wiQIVhLb12/
         IxCGHC2vEG7HyPVP7X4OdIjA5A2sWTTA1ZIN2zptc44gAyAPVHLv33zsXf0SI4XpZW57
         m30P3WcCCBgVaFTsNyoxmfcjbJnBAkgA3EpRz1Bcf/Q79kPwyTCRgXC4ZJ1n75fLxTEJ
         6fJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793332032; x=1793936832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tLmGNIT9IaTeNDNZlYbjqo+wSUzAVTWlQnSozIZPBz0=;
        b=LRbFCl1IKVM6RdVRi0CHAwi+vIMvA7vunCIpgA0Yhc9El/qGxXfscJHiG5vMOMuTqy
         EAKZ8xILitBDbRHU0SLRlSKSPC4W9kQMK1+MxdZ6xblh2JhdzQWiHpi7W/Demh8Fkqmb
         DamN4m+8DPhhWtcIsdrUdr18x5X696tJxkIvCcKkiwTKvoB+4t7+wnTYbDBjlYoIq2Ic
         QIin8KiysTYfV8OjqYDmRnQ9/DisZ2mbr0LrZtoAcP2keX1mZyQevyxugil5w0VyzBbc
         flb1mqiFyXzAIKIkbZBgsG1Tp22qSjMQQiYYt155mHKy92ytO402hB5arXpt/VarEFS1
         RWqQ==
X-Gm-Message-State: AFq9FYJPSRuSdl2H6f4eM3jWo73VJ+aEIp3dH+73Fe08VXki/t59Zdnl
	gwgnEB2ibkSEwCV/YnHivAl79t01KXIqbneXEUXKyUDXhrEZKEbmDkks
X-Gm-Gg: AYBFou0qBgxbckvQMOaLM7bKtxUgvneKYwViS+ieEi38aHEcmjqAw4XcWmo46q/0RfN
	+GTv0I2jvOwSR1JDtLsFtTzNqWvK2vJijgPbXT9DSLGJKkrzoRp9OBRwLEj1w53i8dIF+xI4mDV
	PcgwEuFNRKrIC+KPcWU/+DKvnntZRtDbvoIaAefNkE8ApQFoopI17HIEwVtOTnucAAugW8UlQjg
	R3/x4n1ASomGG0aETZ8MqxfrCjB3q9bvEm8wb+sKxe9XrSMgrbioHTaE2WN45DPzJAkstJQiHj9
	b69E0IK+cDQj8VKQEuQ9tz4LWp2JfrEgScjsFz+nXyaXo0u4ULLyGdh+/K6pyOkOCi9R/D7iLka
	53btfJWTVmQqevO9gxWwN+LdzE/uX446qz8qY5x2Dki7u17sZ+YOsDRUKsCHBsNAVt2SW1SwOTS
	qI7iJRGVSBNsGqaAXXSJJ8y6OvPzaYC8DEDSDACBG4L1GH0Pt5gn/CxJCr/fc/nE6EFIYi95L2s
	1XaZGU/u/W8roRe1tsEvQ/kPmNm0wb/FGO6gPiQsGp84LYVOX2/W5sAR9rmJojT7AUU84OnZmB/
	Sd8z4XDBHPj21V5Pt2A1M8y09RPCM6Iz9FsOmzyP5+lK6WgNssQfzdrsgvkcCAeLCCL2y+hb3ol
	CIbj4
X-Received: by 2002:a17:90b:53c7:b0:3ac:7e3a:1033 with SMTP id 98e67ed59e1d1-3ae897c5e5dmr867247a91.59.1793332032143;
        Thu, 29 Oct 2026 20:47:12 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae880a46f1sm561699a91.3.2026.10.29.20.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 20:47:11 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	neo_jou <neo_jou@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2] wifi: rtw88: usb: don't report the aggregation buffer as a frame
Date: Fri, 30 Oct 2026 11:46:49 +0800
Message-ID: <20261030034649.300288-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
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

When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
into a new buffer. That buffer was also handed to mac80211, as one
additional TX completion.

Report TX status only for the original frames, and free the aggregate
buffer without passing it to mac80211.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/usb.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d92..d6ad0770657d7 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
 
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+		if (tx_data->drv_frame) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
 		/* enqueue to wait for tx report */
 		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
@@ -431,6 +436,9 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 		goto queue;
 	}
 
+	/* report TX status only for the original frames */
+	rtw_usb_get_tx_data(skb_head)->drv_frame = true;
+
 	while (skb_iter) {
 		unsigned long flags;
 
@@ -655,6 +663,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
 	tx_data = rtw_usb_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
+	tx_data->drv_frame = false;
 
 	skb_queue_tail(&rtwusb->tx_queue[ep], skb);
 
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 94ff21dd08463..e861e9a66ab22 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -59,6 +59,7 @@ struct rx_usb_ctrl_block {
 
 struct rtw_usb_tx_data {
 	u8 sn;
+	bool drv_frame;
 };
 
 struct rtw_usb {

base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

