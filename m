Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793589884;
	b=P5qRaGkZ9hki9+DsadX2DR7B/jmJXB1stBWTj8BsR1VvzdDh2+5jsvdAPpMFciVHpae6
	 nn2bB0dUJQbgMjf1uxpUBTEZhXmgGgLH5tFW9E5D59B4Fr2N0v/UhAQDfUht3pv2CjKDX
	 OVh0Yis2myl0Xrrnyi0qhcsRTHTIqEt47TOmcudrLWUIpjo1JoKh5TLTuTGsU6CaRpRmM
	 Qvl1JzZiKCypVyQ+uVNTK0YTJKdNFRORioW+fXmU6oWlWoemu6aqB0CS/pvAwcLmhXENR
	 yZB+AJgiqWwrXQrPaB1bCESkhyA+0yE86gDEABfTLeybkURdHermjlXkjXyphVNv1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793589884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5Oyg7MidDkH2XnR8LERs6tT7rPX18G6kuPdnqFHnUfU=;
	b=KQGBwSGJhswI06R0CsViOGHaYOiZqjoIAJ/Vd0Qj2K1LggrNWCoLDR3YRolKKKMM+fuD
	 HUeditaDUVgT8IcCbLFXXLvtW/lPPtWJVVvPauQ9ALMrdWE0f9dlSO13GgPjdsgIwl503
	 BmoYwABM6/1+xG9TnMUtyFQdGNKx6ZGRv4XutRWmjem5Hg0kLE0QMERKQV63IlKGLYpCz
	 wPcBljdeCPCkQF5pi4NwM0cd6DmFDj93ElkbUA27JCrb3RxJDd5bo1aEwMlkbe+4MXLb2
	 ktRoDr+xaFzzjD+36QTdzRC7gcfgsejZ1RzkGBjGFJSq+Y51DUivqjwwKNwwzqMrwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xqC2vHhV;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B0606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 03:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 888B0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xqC2vHhV
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ea0efd636dso23252725ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 19:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793589884; x=1794194684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Oyg7MidDkH2XnR8LERs6tT7rPX18G6kuPdnqFHnUfU=;
        b=xqC2vHhVsxX6SVptTr/KXC/b0NnZcdD1e+gWluYRmb67gA6b3oN71/gF6ofaxo957E
         U6d2hA8N27/gmt+wr8UvkFpM8Rlof+c4kXYVx4UBreJUjAxlKU3SrgNEaBdLUzLK/Pr7
         JPHvylia3OGckBslOKygGlsRGraHmPmfK1jjcAUC71kpwe8ZaN2Xg+O6xDZg8GsMK4DS
         z4Cd47NuRrnJcuZySA76BHi8/fO0Qbh2NS7T4RcFzmpR3jkkOUf/d62ubjIxoVqJUkgE
         sLexWNPc9ILOkNUCnO1MxM21GplY5BAdzfBjePmySkOitJ1JICt0l3LQK0YHYdynzwcp
         /geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589884; x=1794194684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Oyg7MidDkH2XnR8LERs6tT7rPX18G6kuPdnqFHnUfU=;
        b=Q386ZeLR6i8bT13oaq8IBzi1wu1ctBj4pCIuW3W/XX5vF7vzqkYWcUqvE3f4agJIqM
         41tIYvEep2JNnd2jPJCrhbtkZTzmM1mLJrB8IrPKspMKAJVC79q68ALnpTsNnB4Et16B
         OFf2loo0m8aNeUaAty+ehPN1zjYW0Dr2Os5ElgN77QXtcmBeBFLqmTX1RbV1K2SLo2se
         GP9txGif53QrjRbBGdougXwYqggzebwxgDzDFZDlnqVZR2lXXiOVwfg/O57nwo0DSARO
         XRp+Ood7vAcnNkzlqbOg0UgRT6bxUodfIeASIU9zXdcbFzbgRXgpyn4VSxh3DGUVjg/d
         ospw==
X-Gm-Message-State: APuU4Z9/249OHGs9lSJktGfc1mZT6n4mUcmd9XuYpnnUsItuHsOGmxg5
	djKy33wTNHYcmHy3YAi1ikXYNZtaiGYhCG+hWv/FtY4uj7XUfeicZF+k
X-Gm-Gg: AYBFou1IpiWbmz7CI1zhpbDyO2VszNw3wRJ2ehHBBdA10mCpeACoa/SamUr5bs2Jg2I
	eMroAwh+905Ph8vjy/yM2erK95JnGAYn8CE3McZkDbkdptbtUFbtglPg7Bdm5vstlJqrbBrpCFh
	b/EKogi/F8QakCrm7AoZduCwMkzjxHlwfq5wkn22aXwwSl3DgZNfYtbtm3aewzlminVSEEYnG2U
	kVPLf4IMUcevT9UgXCWCXlNiu/bo5SBLabBYhZnNXgxeghQQZps43+DK5nQKSlxBCoKkWJLlEfV
	BEeIT4tL7tLf0Ru6XLy9+R/JFyzkQuDItO4PkJDM3JP7gIOJd5qmbP9gSR3z8fXVoEEKEcgMl+W
	CGVZa8q2I67QVOBIqPTj3ku7UryZ9wP9uxYesRK22ETCktOobEGaUhU9ViiXDDhimq92ykOYRxE
	8eVLbnFimKToiJvBAnHKZ6HlPs/UHO2ksmaulI80NuGFNy8bR5VZGvt1UsiKXRy0aaVgn06yObr
	3LmFPRDWkbyfTszhRwJz6YBaxkoM6NHmFj/haPrdcti4qyRTCjCyPa1ELj2+b2gAt3cUuhBaPDi
	2kIHEj7lf2Q4fuuCK9nCWC1RbsBR7e9VEHkCev8X951MMlbmyEJ2pKrZ9dBjevEM1n5i6pETpww
	3Qb3LBg==
X-Received: by 2002:a17:902:ec85:b0:2e9:a23b:643d with SMTP id d9443c01a7336-2eb364d253fmr80430915ad.35.1793589883793;
        Sun, 01 Nov 2026 19:24:43 -0800 (PST)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2eb392b15f0sm21822195ad.73.2026.11.01.19.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:24:43 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	neo_jou <neo_jou@realtek.com>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the aggregation buffer as a frame
Date: Mon,  2 Nov 2026 11:24:25 +0800
Message-ID: <20261102032425.8249-1-hjf3108@gmail.com>
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

In the case the ieee80211_purge_tx_queue is called, the frame is
passed to ieee80211_report_used_skb. Since it fulfills none of the
conditions within the function, the frame is freed as normal without
a TX status in that case too

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
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

