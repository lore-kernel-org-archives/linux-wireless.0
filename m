Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792952377;
	b=1KRPt9eT1F1Fha8xp/w6dzWBuDS3EzkygB4g98DUgFXrpOBohXZFtmzsUwLNtNWye7eS
	 kjEXwR5O+toDNNMOi3KMC3UtwOgZzea7AqMIOfo0Vo9xvcMcP3oDznfQsgAFAIDQBOKry
	 G9eocta3NjX7/X/BfDzQ0c3SbsL0IipYCi1qxl/iMUvN0gXA/wmJFjODVEBWIGp1VYgAW
	 L+gz3uBo11QcfvcbzwUYd717MT0WKpeF6JmmlPHqNp9Im8W3YkekW7qHAdIcTlKU7Ex9w
	 r7nSWQAv1BJYKeu4TUMXuaYBanZLxdc6I12cIUdZapqBNfE+y2qhbVSgGusTxP8hTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792952377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xHkFulZhzfdcytD8jcm7yE8C0cb0+bXKg5xNAHor0g0=;
	b=1k0jtdJKso6c40RC8rlODlEqyRjePoSa8/Z0FsLN9xqsEJRpw/84PB6B/X7HDgykpb81
	 8Rmk6JErLLMJ1x+WOiCMCt1bo4a8ycwFFSmPMpiMqZ6NNy4d7AlavFqEWVo9+Z07QVz/1
	 CWaCGFIz8xp7TNA1Xg36FkuSqnSGQWhw1nYyU8yTN2QtIbTUSMh3n9W1ZbruRF9tEcuIh
	 MhULe+A5JCxwAk/2Cszf+I5CbEjq6Ac1DB8pLOgwsaOMoT9DbwWYjpjNO1/J1rMopvCj0
	 GgOkQBVHwIIQgFUnpE+/Qs5jfGzcp8PIlcAPuCoBqQoEwY9DJrjLlTzY892ggWAPeHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c3D17ued;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034FB606A31D
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 034FB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c3D17ued
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso18581555e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792952375; x=1793557175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xHkFulZhzfdcytD8jcm7yE8C0cb0+bXKg5xNAHor0g0=;
        b=c3D17uedB/11KdUwEGzKp59eVMgf3RY2OyN+Q0UK0ghWGfxp/v3Z8S2trNNM8sTub2
         /rXLNxmQ21QLKtnif7yjDkKDyyEaDBczbapqUnbrhi9nlvocrChT7laHS4wHqoOwEI3g
         Q/EUXL6NTVpWjocnKxsFTGCKX5jb4ko8BRyeB9v3YBSut5ij0P0vINLMywww3mczSmAN
         uSfpjcQWwLr9j9ZfvdoDYtyUua+3cMVu3xVXVshS4VQ/JZvBQcn5fWMBZBreUC4TgwRh
         l+3bRVhId6ErXkmQVD80gjzKfcrb6XQpDcypAQt2TOm4SJ0u+NZ5fzC7ZhOZgUMezeck
         g2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792952375; x=1793557175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHkFulZhzfdcytD8jcm7yE8C0cb0+bXKg5xNAHor0g0=;
        b=wihDw5tueycZ8tQ9lMqe7LwMYIXoC1vQ5sNHZYhalhJRlyBy9yNekiUO46R98rprsb
         BEuJ99pYxbfgi/At4/vrvYY9QDKzBdglRq391woBl9bgm/QVrn0oyS/eKvEptAa+8deA
         kzo/sfKdhZj6FajFTFkZC0kUdkmCf9zCoJluq4tilMFIoquQvw1igfJ/o9WGOZBL0xCq
         B1lgeqPZW65Vxt7kHteFHLAkRHCatLG4Igy5WVMxZdkra8aD3nuQI3jOYjk9gV6RTYIP
         s+xHQ2pTM3Taswml/rHAEeZdJ0/UUk0+CGDFXmnyAWrM0XQmyFq1cyzAjhH5vbHM+bhi
         mKYg==
X-Gm-Message-State: AFq9FYLDdUGDqf7B745kRrJOVsA5UTPgKbIFKek1R/ByQU/MXbgEPPxV
	NzyPP7gK6IVOzwIJ91sJyCvo9Jy7vsZaDJmI0keSNm1kF6V6yL3e6+s8Je/A
X-Gm-Gg: AYBFou0IOU8NIqaeihSwhFgQmdKUA0AWYcnbf7PZ63CsDTjVTK2bqi52LeE4bdsR2mU
	iYtVHcaKyZmRzBZtwQQhfin1rNiBJi8ll4P9ZNSDb887OaNQy4x3YTy0We6GKOSapN8HVlrhg3w
	tZkPolnBXsVg8HtdnsOIXG64brunzWhyyuIaNB+8evpjHbrWyLzIckSpx2KXuLzaSSEH5mdBuce
	cR1oKaLMGFr3PqTtekUdILiDqlZx9v6o1K05CcV8pHk9GSiN7XKU6FABom48k8OEe1MT4Ak2NZg
	aQ/i1Vpm8j/SGLLabUIJLX4LY29uQsyDZ1Isp0Eqnxh69hQ9MFr6NB+vyJSxD8RAgXGcTPYC2RQ
	YQNs+oKkNpM4bPuNCTu+qrJN7rGpjyY6JMfuPoYkrarQYpY95wr2xmFCaqr7jgNOj2hcYeBzzvv
	EzxwKBi1rStB3pWMr1aFBzuGJYRzBBFYVWYLsOBqCFRYSEUTCdNlhc+iVl5tVMIYcsZvPjbncQy
	6evmo1Fsb6L7k7+sbdH2t/tjszP6NSzNM+pvIA=
X-Received: by 2002:a05:600c:8b2c:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4a35acaa6d1mr86565045e9.27.1792952375238;
        Sun, 25 Oct 2026 11:19:35 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2c0458sm136103515e9.11.2026.10.25.11.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:19:34 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	ajay.kathat@microchip.com,
	claudiu.beznea@tuxon.dev
Subject: [PATCH wireless] wifi: wilc1000: zero-pad SDIO write buffer to block-aligned length
Date: Sun, 25 Oct 2026 18:19:33 +0000
Message-ID: <20261025181933.3775301-1-tristan@talencesecurity.com>
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

wilc_sdio_write() rounds up the transfer size to 4 bytes via
ALIGN(size, 4) before passing the buffer to the SDIO controller. When
the original size is not 4-byte aligned, the trailing bytes after the
payload are whatever data happens to occupy that memory, and they get
transmitted to the wireless device firmware.

Zero-pad the trailing bytes before the alignment so that no stale data
is sent over the SDIO bus.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 67dea1360f0a8..1a8c7ffcba496 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -441,6 +441,8 @@ static int wilc_sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.address = WILC_SDIO_F1_DATA_REG;
 	}
 
+	if (size & 3)
+		memset(buf + size, 0, ALIGN(size, 4) - size);
 	size = ALIGN(size, 4);
 	nblk = size / block_size;
 	nleft = size % block_size;
-- 
2.47.3

