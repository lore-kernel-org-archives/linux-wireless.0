Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013716;
	b=sV+NB9ggsLqZTx54JJOwusJGDLz7AvWVH8EfPXlCrLzMw7CKq5QpIlsRdn9NJwXLNbum
	 uK0DnQnsac/8fgMFlGcFBe9cI1xlQ0oj2KJpuPeJIBJKgev3y9CX7ZWWT/5nL4RuI4+Y+
	 5DEOY8PotRrWEjK87V48oRbewcC5MK2Rg7Z5sAGUBNsw8/58rnnaCbGxC12PPclH9/7aP
	 9tIKMAfGvzYAY3sSnAJG/UwEsP7znuxjIlCYekC1pqpKN0Zdfvq8En+1WtsR38KgLjE9m
	 1kmN1ZmENx0kKXdK8nlKlzic9FxraBgeh5OGWU7iNpcxrOvaKmuL5IAlcCax0/CMjGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=y17TPOs7l11RYBnKZe+rGQQjDI+pkFbxrNsqaPiSHaw=;
	b=QVwawjniMEzjbcVHD/5rx+xgwXXlsZsusNc6JeHwVrhsiph/kByKSrHzJfTa0T4ZLw55
	 0gbyt3aHUDcGQ3nT9fZCDL3z6EB7gY0xRD2xXCRpFYcxI8tfJa8gylW3J+qbBff9Klrjt
	 ugEq7VZvbRK9NSV6SWrGbuj78Qky+A6UxvCgsV+IXWyS/A9skaD+pKBvYm8xijcHl78jL
	 bA+dyXdkgKHhacfoifAnVivWizWxwiTafw27maTS+Yok1PI9k9N25b31RtCmRciNqxiNa
	 zaW4OY9uFV9Ad2cZ/5M6Impi3FWyaUYEHGr2NT0O8cCioFbmVl3MWM7BEXcMRSHtI8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="F7l/I6Kh";
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D3606A320
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:21:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A00D3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F7l/I6Kh
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48afbd2c386so1673590f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 04:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013714; x=1793618514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y17TPOs7l11RYBnKZe+rGQQjDI+pkFbxrNsqaPiSHaw=;
        b=F7l/I6KhnzQvMYptnyBQ8lb8caC+lkU0v7RRGSHSH5jwOyFQUPcR+F74U8mKgLfdXj
         +TubIxKOrMcMreXQ2hrJ01mrwrvjg8VHxJsLd27xQnIUFrSqlNZeJKPvn7OoLRvgE6wa
         +bq928rrZA7RQjFugFTJ1dOyhEmkezoOIb/uP6NH8RvYQw6wt3C6o11zsjQdfo/BwyrN
         eUT/DAV59/QmjXvcaSe5wnH1TMk08i40thR5frnzqLcLT3puEpUDiOmekcngZTK9GP0M
         6CGkbrdU/D+NzXcKvmcp9q24uJFpjMUAwYRNPE7CDz0VVMw0yFS2Pk1t5m0LgZP03d4s
         6neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013714; x=1793618514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y17TPOs7l11RYBnKZe+rGQQjDI+pkFbxrNsqaPiSHaw=;
        b=D/q6aK6QcDeaSzG92G1Idu9f52BpzJ0b2IljA7uj5XwsQGICgo/kYUXKpPEIhDJEvq
         3wYvX5wYgHXWHn8r31Sk14R7CuyU0u56LrTp0xNzVaWZhVY7syZLyXluaH6WxfqWOwLx
         J3CUfLnZSTeUpTYvzNad68DZ4/tNGq5uOJATgMccYxauxyxhn4kGBJMvt81vahr7H3Os
         99hGm9X4idaq04UxPHoq/hUwYtPcNsl+RtiFRJLlXihZVbnTpmQ3g9G+yz9q/04bVAzx
         jDwIUJDGymNDTp56r+xN4h7tykv6mzhcA4/uL3SPX6Y+qsJjm+MNsSkUqxNd/TlSGSj1
         MzdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwH8jQTklq1oRM0FuN59omTfELISa4cej5oydUTILG1AGyJu3eRTHPiGhSHuZ/fKbVEmMqO6aUfcHCodYHVTw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKQDF5H6ZUlIxvIbYk3H3CGT6metuh3w+7oJXTeMG5OKhfKhbhs
	JInTFd95Cacjd8CJoVuOG1jGm4mxHdxysCIn4QqxD7GK+CO4HXfnPrA=
X-Gm-Gg: AYBFou1dSUrYxdHNrGzFd+V82IeUJbVbRC1TSpOI7Nspu3fuP8+evqswD+u2x7oXTX9
	rT+5ZqbsRFPS5jYfIkT8sFyqMj38XKXQ8xkSwW4YizK7dxY5+Hm7ODTnMNaPf9DibXg9gfj/5LG
	bc7VZFOdGGK1VO5boXHVIbrbdGUl7YJ52w7tkNxUqZCC7wcM5uleotjKINYFDqf0g0nfYGO5qeZ
	0Js/0hCmazHCm7k1CxPxNFejsrYbNi9c5XOMGwJqlXoKW8QzZ3xMMBTiI56YJWmcoba62Uj4VTX
	1sVLo1L9c6J9g/KZy8sgveu5M0T9hpaG36l6F20FHw2ozIah/3cxcZYah0TmHojUYLtYcXLxb6r
	C2PPjWHD9XFbrk2aEJ7ZeE3p6hR7PMbyvaXdQJDSuXQSL48PX1bT+lajZwo0x3lZEak3D7pGdDw
	SX7WN+KZVQuFfIM2lPCi41FG7lKiQxDsMhpHIPQZZBMR26S/lMmDvch9TyxxsAf5UxzV2DNX/YZ
	TCMjdQJTPNvirc44pgOfY/Q
X-Received: by 2002:a5d:4ccc:0:b0:48e:bf0:30f with SMTP id ffacd0b85a97d-48e3eb8b7fcmr9371908f8f.34.1793013713782;
        Mon, 26 Oct 2026 04:21:53 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdfd8dsm15048703f8f.56.2026.10.26.04.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:21:52 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/3] wifi: carl9170: fix IE parsing loop bounds check
Date: Mon, 26 Oct 2026 11:21:49 +0000
Message-ID: <20261026112151.2515228-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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

From: Tristan Madani <tristan@talencesecurity.com>

carl9170_find_ie() iterates over information elements using a loop
condition of while (pos < end). When only one byte remains
(pos == end - 1), the loop body accesses pos[1] which reads one byte
beyond the validated buffer boundary. The read happens in the bounds
check expression pos + 2 + pos[1] > end before the result of that
check can prevent the access.

Fix by tightening the loop condition to while (pos + 2 <= end),
which ensures that at least the IE id (pos[0]) and length (pos[1])
bytes are within bounds before any access.

Fixes: a84fab3cbfdc4 ("carl9170: 802.11 rx/tx processing and usb backend")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index fbe46a5e4e415..de3ee0abd5be2 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -497,7 +497,7 @@ static u8 *carl9170_find_ie(u8 *data, unsigned int len, u8 ie)
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = data + len;
-	while (pos < end) {
+	while (pos + 2 <= end) {
 		if (pos + 2 + pos[1] > end)
 			return NULL;
 
-- 
2.47.3

