Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379312;
	b=M3pS2+x7kE7bk8sVshwx3eB1Wgl9OGv67Pcqi4y8l/WRoF9dLHO2g1fG4XVRyU1CKknM
	 BjOOBTz9oIsGrPIZRN9Ni+4qYiDn6Tsnc3W6IsyLxdgktVRX0/dg/WUH2lZYVDFjLcYid
	 LyniDja1zSMFZYhWFmyiMr7lHlh45xSzgay0D7QlpMgGenBeaCLsnvXfG488jfqIyA8SP
	 X8ZezMQrm+5h5+8ah5Mx03dol5/uyf5rN3l2VEfHL67N+SLsoIPGwnoaAqDtQOK34gbOT
	 pF/lxsiM20boUYvhXqb8UTwc3RD0FaqrC5TypNF0CEZggJiFXHti7SNQdlYKAY6zlWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379312;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=GctUwbYvSK3roB7Vn59UFzSO9QPBJxnr3dgZFkrkbz0=;
	b=q71xrvxJO/9yGKcyt5UEHvUKTqmZ0BsNo6vErXzrnCe+qGxj2txrsQ44WKYtrSnJfM/H
	 VhYCOms91SxfNqIT5ZFLsQAtK7uxL9mItjGoR4Wk1shAr3TAwMEp2Zb0qN1cyptQJ4em8
	 /Z8qzUA15NCcWJtG04MbmRGtfV9qfeyod8dTBwTjs/ZMkW1dUOZWvOD7j7tyR4t4v19sN
	 PEeLaqMAz75cAva7KqeJaN96IMcZ/txheijOzBmb3DOfe1m1CstGJnPiomzCnxt3Q+Gn7
	 Rtg7ZJp8OFQdk5TJ29AloRp202zaNLuT/NWisX+0xiszt8cV3mFCFAV0UAqsFT4BIng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aIK1O+sA;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886D260A3818
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 16:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 886D260A3818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aIK1O+sA
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-89d6bd67045so588896b3a.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793379312; x=1793984112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GctUwbYvSK3roB7Vn59UFzSO9QPBJxnr3dgZFkrkbz0=;
        b=aIK1O+sAVUXAbQJ39O4mLW7XWKjeuGi69KLNSqe7baImJ641MkuB5xHEj4vC2xQ3RM
         CvkIF0XU3kPDe+1UrmUZEVjvV/vKFn16F1awRkok93DTriChkXpHosIe+fS+1DpHmPEq
         Ij3l3NffXixugYs1KPAYf+h10uE/Kr1YulcKhVy69X3pV7KweOpsQdBBEouG51MQCzIv
         e2Uv0VdIN01ktblRX2xMic4Aqo2hWKRJNKnt4M7d20YW1zxUcYEmsQSBOBwkMIH9Q6+d
         T/2YCthH2KyLvgfQ6iBQnYjEZyym6z7K/7aHZWJ/Kdj9c3l4+OsH6ikBGs0vQYFK4Pki
         l5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793379312; x=1793984112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GctUwbYvSK3roB7Vn59UFzSO9QPBJxnr3dgZFkrkbz0=;
        b=oBotd52Il1fiTELdjZBiQF4qm+GTkKtaalFv1P6IkQchbRJxT9KrsUdcKQdN6m6bX5
         EHWgBmsNTCK19IDLHWUf7xjV1EjXfNmFRAyMq29qJwhrYZj0qMLy5lTTZr07djEt6Rmn
         i+KLbzIbtI1GesYjDiYRsYFKCIP4gDhsMYZhsJzDeB5y9JQOTilxLx0Mdt7f8ZZIOpON
         uWAPorr0wS50A5EG9AJIB5qjx/iwubk2a1S0DWqkBk7QGIjQM1Iz6UCqw40vwc6+YcuA
         QDGorFNDCzkaNau4mkdbHom1TKWersW5gBA84ReSWfUczQRWuQqGEgB3o+L+7bvReS5f
         xVvA==
X-Gm-Message-State: AFq9FYLMpcIFWiq3RxjkwwqeCVf0BllBBItRTBu/6umulLgkdGF8MA30
	wacYs4oboTCSrfwBD7+kFSKLoeGpqDVjR4JSCp+SXTlZqHcYolUPyZnm
X-Gm-Gg: AYBFou2cj3XuAQtlvV9Rh5a7dZ8atCGG+DFkequ6E3AtZxBDDgJDa+hcJM0tyaHUYUl
	Fe02CgGjXr7A4u4P2TyH8+2ngdqY3wJuM0gY1H/hTBkrnP+DqhFrKz+K4l0Tw/Lq5zXi5G47yTb
	9GoBgEDpppcfkn52Th8t43enM3TWKwhx/QOk99w+4OK+EfQHrxE6ENQY8MB1ADtRmXbtfxlcPXH
	yCzTFmvgSAGGWEihOmi3LYUf0ZOYz9Q8T3AQ9ry4n6Q1Cwh+Krf8gRfvk3jRURN3zNoHF+ArL5m
	pHVdMCuFY3nrNOFgDHrLGgSqETpIa9ahtR9EoVKiTjXxUaUen1qYEDrTt7bGcLRYfCiRpm3vc4D
	UZknDvbgkFOUD8nf4eN3we5HpoGSvzB9Uyj+fKxjVlbWazzYTcQVnt/9V9d6uC/nMhoYyU5ZKm3
	Xu46iApyWsfjmfhcbiKSefKEFONqiSGQxXkuvhltl7A9tgMf25GQVa7HLrnGDSIqctGpHjldki0
	1y+doaxAyxa2vS+beVw4HyXYftFtAUb7jWrkYTSWg9Jq94Bwqb/2eAH/eS0N2xItocsZ9okkm8T
	r++0S9uqNtCEulf5uwP4BlNZc0vP1YSA2QSf+rvg92E0ESxR9xK4chomXsyHA5pf4X3KcfOfzN2
	syhpvrQ==
X-Received: by 2002:a05:6a00:2906:b0:886:5eb6:dea4 with SMTP id d2e1a72fcca58-8a8317dd93amr4216703b3a.17.1793379311688;
        Fri, 30 Oct 2026 09:55:11 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8aad963d6acsm272873b3a.18.2026.10.30.09.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:55:11 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	neo_jou <neo_jou@realtek.com>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the aggregation buffer as a frame
Date: Sat, 31 Oct 2026 00:54:50 +0800
Message-ID: <20261030165451.365591-1-hjf3108@gmail.com>
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
Changes in v3:
- Change to dev_consume_skb_any from a suggestion by Luka Gejak
Changes in v2:
- Remove unused drv_frame members in structs

 drivers/net/wireless/realtek/rtw88/usb.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/usb.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d92..10f6d3bea0dfd 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
 
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+		if (tx_data->drv_frame) {
+			dev_consume_skb_any(skb);
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

