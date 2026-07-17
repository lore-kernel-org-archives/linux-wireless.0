Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737EB3C3C06
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286229; cv=none; b=Fmd/E07zj5po6VwhktyvBjCgpvVpqUg2KPxLtWbeopxqYm74qsY7BVqLv8Lnel6zFKj/u9cwBuWPaYKqP7SCZrNzKcU4FLJvInUrRv04E5AcyzbqUpgZ2DoxdOwo0iOCCO2muABVIM8THFhymd0kBeu/d6OHBIK6qhJUqGjFJ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286229; c=relaxed/simple;
	bh=jA79gpOkviouKGGXfJkuzjbm7sgvQfwwpHf05WgGl18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO/Kx++oNgH+C/wIV/rOX/8yETO0JCNZQcNmypFJAJaCVq08SeQNMuCyiRKDeZa31aGzEZN2Mk0sUtSwed7gFpawGO3aazObWFam3nj9axLYPgWUUZ09cNEi0QnUYkLbR2TVFoRk4KigZG57bWkF0Lr32uCLCEv+0zXSRkAFK7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nakYVP1/; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nakYVP1/"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e54f8c051so570337585a.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 04:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784286225; x=1784891025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJUH2+9UwKuoF8Z5sAeBhPd3xy/csT/L8ZRS5KSSWKw=;
        b=nakYVP1/U/lgDxRh8JSSbnhxgiKjpV+p7U5vb+K7bdoTTQqalJWNIlER3qnU7Q8nkt
         QRNRG5HEE2f/NDopB/Usatyaj9AbEPx0D62A5TjHBm++HpQph4RkZVOMrNqXEXstsaQp
         nE48xYF4DKZZDoi2w5pP91SAAy1XnE2qPk6clxd0J0TT31bEd7XA2tblX3HYho3n1x2D
         8ODV+V1o9Esj7uBznVsVem6+towFUnPF1/fYTWmMSY83jurLrotf9SDQJUBGAYv0OHvi
         P9hgpVyRgxemNoq71k4ea7/8TRvp0bFIFs2PGge12fW4vHtLxJxgoWQzTHQm7sgaZa1+
         49AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784286225; x=1784891025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJUH2+9UwKuoF8Z5sAeBhPd3xy/csT/L8ZRS5KSSWKw=;
        b=HYW/vvZp5R2xc743qqEh4usoy05bHBK6Ml6evm6LKVCJ1VXGh7SwrQCDkRcv4kYiWF
         3PpRaMJ0HqfrxQQMy9UcG4CylQJFsZ1LYWgeaL+3auLiNH1ynMFki8Vk2PoFTVFpszDf
         YjkosPFuIuh0J2IkwUCudeRPgAGzrj8516nCDOgLn0OJ3mSH40zjNT/Y4NIDVo20roKK
         m1QAjC2scHv9PEnQh9L/Kkto0E2msZc2u4/ju6XSPpVvOHV9eDBojyW20PaEc2fjDVuC
         gUGcG3KqgIv6qjJyPrpxPxYFNHYn+EiItge7QG/iH7prN3Weus9OQuneSMp/IK2uHg65
         IqQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp6V2H0m9BHnmGy0AbOVxNGWHPolawbsvoX70mzaN3MwZ4lNDzV4swHJHdg2ByFdNKcsN9Iw0AR6QM9BZ48Qw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZQvRCEY6Db43+MJGq/QXba1oK/0sni68orBm47q85wltwNtXf
	8w3b2tFlZe+USXHAcnigkkmViLrGDlshPx4ChD99uyE0hXABICt9pA49
X-Gm-Gg: AfdE7clxt2n9kc4Bl6lC9eJ72R+jPXe2BzHN5EO5iFwzyerUKl80V8sgPrF11gfFa0r
	s468ZiDRey63eCezHYA6+MjWjNi/HiDitSLWiKiOPOsIcFa6YoIPPrJ1wyvGpMkhrt4QTV4H8oj
	6wzg9vOUk0T/Y/gg9erFG5oeWn5Q5ujgUVzGhLyyHcN38LuscEfnofUDEGu/PKJJ4kqRR3yO/lh
	+7uUokPk2EVYhjFJEpDT2+hSZDaHktk0D48vDzAPXdbH2UxH3FJlkCcwRIV67/5Tacr6KK1n0la
	wj7HNBJb8bwFMYtWXrKFvjlBb7VegOE/JwbK24Rl8h267hsYJuF1djp+nQWVYoQDucA10QbSEHS
	Ry4XmojGlW9afAkZqhJSOkOgm8G6EIiA3dj1PxeS7lDaUPrjZO6OJZzcWsye3JkxlL+MQOZD99A
	HRs44GlxIZJ94b89Y+GSQhZ/V6V3pxmN2qRrRKLwcZ
X-Received: by 2002:a05:620a:4147:b0:92e:6a43:4768 with SMTP id af79cd13be357-930b3e4e844mr224517685a.11.1784286224683;
        Fri, 17 Jul 2026 04:03:44 -0700 (PDT)
Received: from mango-teamkim.. ([129.170.196.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b542d61dsm124744185a.24.2026.07.17.04.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 04:03:44 -0700 (PDT)
From: pip-izony <eeodqql09@gmail.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Kees Cook <kees@kernel.org>
Cc: Seungjin Bae <eeodqql09@gmail.com>,
	Kyungtae Kim <Kyungtae.Kim@dartmouth.edu>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: ar5523: validate rxlen against descriptor size and usblen in ar5523_data_rx_cb()
Date: Fri, 17 Jul 2026 07:02:21 -0400
Message-ID: <20260717110219.2392132-3-eeodqql09@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7bd71d11-d6f2-473d-b5ae-f5fbc972ef40@oss.qualcomm.com>
References: <7bd71d11-d6f2-473d-b5ae-f5fbc972ef40@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Seungjin Bae <eeodqql09@gmail.com>

In ar5523_data_rx_cb(), the `rxlen` variable is derived from desc->len,
which is provided by the USB device.

The function checks for an upper bound (rxlen > ar->rxbufsz) and for a
zero value (!rxlen), but it fails to check for a proper lower bound
against the size of the descriptor.

If a malicious device provides an `rxlen` value that is positive
but smaller than sizeof(struct ar5523_rx_desc), the subtraction in
the call to skb_put() will result in an integer underflow.

This passes a very large unsigned value to skb_put(), which then
triggers a kernel panic upon detecting the potential buffer overflow.

Fix this by adding a check to ensure `rxlen` is at least
sizeof(struct ar5523_rx_desc) before performing the subtraction.

Additionally, `rxlen` is not cross-checked against usblen (the number
of bytes actually received). Since the frame layout is
[ar5523_chunk][802.11 payload][ar5523_rx_desc] and `usblen` covers the
whole buffer, a valid rxlen cannot exceed `usblen - sizeof(chunk)`. A
device reporting a larger `rxlen` would cause skb_put() to expose
descriptor trailer bytes or uninitialized skb tail data as 802.11
payload to ieee80211_rx_irqsafe().

Add a check to reject such frames.

Fixes: b7d572e1871df ("ar5523: Add new driver")
Suggested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
---
 v1 -> v2: cross-check rxlen against usblen to prevent overreading past the received payload
 
 drivers/net/wireless/ath/ar5523/ar5523.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 66ac396858a5..3ee4b020f416 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -589,6 +589,18 @@ static void ar5523_data_rx_cb(struct urb *urb)
 		goto skip;
 	}
 
+	if (rxlen < sizeof(struct ar5523_rx_desc)) {
+		ar5523_dbg(ar, "RX: Bad descriptor (len=%u is too small)\n",
+			   rxlen);
+		goto skip;
+	}
+
+	if (rxlen > usblen - sizeof(struct ar5523_chunk)) {
+		ar5523_dbg(ar, "RX: rxlen too large (rxlen=%u usblen=%d)\n",
+			   rxlen, usblen);
+		goto skip;
+	}
+
 	skb_reserve(data->skb, sizeof(*chunk));
 	skb_put(data->skb, rxlen - sizeof(struct ar5523_rx_desc));
 
-- 
2.43.0

