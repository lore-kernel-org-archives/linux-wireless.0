Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254183;
	b=Q4n7uBaQt3CvgAJrD0AuMZ7ABuDbNqrlYxhaAgG0WyTcE8oqFxN/pTEYwhgX8FR78HCf
	 9TN4o4sOcav4aLzPJZGtNtbDilqX0Y8g49f5hMMEryps6KBkoQvFQnScTzf0RPoO35CHB
	 bMhHui8G7o2vHnRo7GtXNyW/nPRXfAA2QYH8KpdAdekXVi8F/pxHggeQfZhNeKZE6hTLm
	 yxGwkWaFTgiz42N/S2bMtmu5iMdbFBU/16THqfI6Ulc9QSUTOnZJS1x8gGO+Tclj7VD63
	 L6zk5JA6aGuc0ujhZSMSLUS1/TWUJ9ckqeYZtDTbXS1AKvLDd8JC+6gEBfLRJfdMmEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254183;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SC2elIiktzsRzzpw5C8r5H1plfOjFayKw+uoorWLiSE=;
	b=Jescm7QTNUI7iq4MS4DnW3LQ5NhluuI8y2bxq4falKCHdMOc1T80PXs364JasDl17SIL
	 x0nVHuoEixFiSclpBgAr6LjWDdumWsaAYkbM29N7osMepqSrt7GzeCE+UFeEfNsluEsI6
	 JYEEi0Hsj1KbqHb3ojSPu5ya2dgEM/VHEMVo4VTjO9BZGqtgakGmXgMj6wjR8dvusfXtK
	 3g0EDf7ogr/pxJO/0L9mE8Hvr+mDCL6JoCpmAtIEhqdchCvxDU8rG7so9YcqOKpFLdRYy
	 mcPG67BJCI9QR5wPuF4ZlHKYS3r7BKfMQZNEqu3WczuvmRN7BF9y8Vt59qZdbBxwZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hbZQqtjN;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4628606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:09:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4628606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hbZQqtjN
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso633074a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793254182; x=1793858982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SC2elIiktzsRzzpw5C8r5H1plfOjFayKw+uoorWLiSE=;
        b=hbZQqtjNZVYgBXUF1R8HJT3A3EkYa/ox376lTYm6M/PNw2gguubk3ryfXH61ujtAFJ
         AZdN/2AuM24jjJxytffigJT0gTSi8pokLE0ocj4nUIESWhSviYmhh/WxZHCiBFA0veFB
         Z/pO9r083JbNm/9M1ZCw+V6ZTAUDgcbbqrlV4khoPMLHaglwM4hvmihyIKJYnIBE8vrw
         20oHgkdVw5PtOnTPkmR/6F6PbarHlNVFj6gW9flCyV8NkKy4YPCbNY6fqnRjsqgguykY
         JVdwZaZvzeY9+0ZrYkyOUmCq/n872PdS3RAFym7ZUveNv8GuLK7+b6NsdgvNJQ14VRmw
         UFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254182; x=1793858982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SC2elIiktzsRzzpw5C8r5H1plfOjFayKw+uoorWLiSE=;
        b=WQlNCnsRp3hzk4/h7p4DDGYeCmHArQj92O78UVaBqWB2EXYxl2h82IV30N06Qwph9n
         KqljFE2Pw77900Mhr7wQp6F8K8GQsLqSPi/xZla+91CS89RJUVwSyviU2WX9TXiP61i1
         gcYVYw+5j08ZbZXRTUGcaTduxho0OlNxAPffI9Ie1aZzpMBivK3dFHAHhMmX4AbuepJp
         F+rdHr01ujVB5xpRNMfcTpc/v4G1XvUhpy5brpLf2ysMeEq/UpI9/SYgo6zyLdvTxzEV
         jAGkxeJAuVQtsJyqJyBwSS/qVLrMkGdz0weE+O0jLB6x7oqsWdAl3GQzYNcw9zybtv0v
         6g4w==
X-Gm-Message-State: AFq9FYJoyF848iCNyFSDsF+YGlDMNLrqig3fzW6wJD0RzIUMrXnEpCjJ
	OA0R92Ly0jJ2H1NmmAya/rX3fGMrkeFOlfuGJMx8fj2RCIRje7m9u1yX
X-Gm-Gg: AYBFou0xTw2VZ11IFRNMaQmSnWErQvz5TzCCorIlJ8HGvzgfKPX4hA3+MTEX3cQKjJ+
	tJR62HElC+FdTpATQwLIBIbSIMRSPB5KE3xhDKKywcPorMuVVjV9OyOh0j6clS7SS0bx1WN5w8x
	FYJ2dF6h1Ot8HFbb99tXfD6bMXqouu346G/zB4mBJRCO2DItLFiqTgI2KfHCzUjLmUtzDpNYRnQ
	l1Rdye6cQ0oyW6j8Psmv2wtYHJKHuaLOznpgDS1Sm+vhZ1elOmH/KjVVER/ro2KGijpGbdQA256
	/PSwRh2PDx5on0oDugSFaUISYaWxjoPu4l4JQPaepLFAiVahIUFDl8ka8vQGITNI2GYG18nW3Uo
	U3qnzBjxnuhWVUD3U+SEOTqP9ahpXZJyJNNPfrPW6L1BqgdlQF074XjZnYafBIARRRXqfX8apE0
	i/mjecHtY6xShcBHAzo1kihU5cS65qpRka0UV2KApikdwhouMfn/Ym/8RdVVGTCuj/e1/FN5He4
	7n1wi6bBnaTP/BBYXkqOIm/sTAH3H/idur+uFJfCCkU94p5s4IAf4g07exlbID3xJYa5u4gonN3
	FFOLYj2chEpfJzEz9VtB947h9j0NfuEzNIw2pJz3+VnmsRuryxPT+ecU+9CZrAsPl4ln6NXurL1
	DElPw
X-Received: by 2002:a17:90b:5903:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3ae57e2b52amr3368886a91.6.1793254182033;
        Wed, 28 Oct 2026 23:09:42 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e83a4f1sm2697459a91.12.2026.10.28.23.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:09:41 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	neo_jou <neo_jou@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wifi: rtw88: usb: don't report the aggregation buffer as a frame
Date: Thu, 29 Oct 2026 14:08:57 +0800
Message-ID: <20261029060859.90002-3-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029060859.90002-1-hjf3108@gmail.com>
References: <20261029060859.90002-1-hjf3108@gmail.com>
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

Mark it as a driver frame, so that only the copied frames are reported.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index f03b00e517576..34379dddf7c71 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -436,6 +436,9 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 		goto queue;
 	}
 
+	/* report TX status only for the original frames */
+	rtw_usb_get_tx_data(skb_head)->drv_frame = true;
+
 	while (skb_iter) {
 		unsigned long flags;
 
-- 
2.55.0

