Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430614;
	b=oeDxRfDNosGAxHRnsvJi/TLX6ampNcRH+pxLyNiCpxy4ZkvCCeO7TplMNeHPg/QRzUNw
	 WHeEytn9h/Sh8dH+BVkzL6h1cJ2BOZqBEh9bAiHiwCDuUxVYg0TcIvclt4d/ZAVjSt+Te
	 hgeLvYdo3oiyLN1ldbuVhXQASqehUxMo8IKum9pR309dKefVNXUtLMXTMaiXXl+2ftA1P
	 Y8qGM8BZjIDOCcn+WWlDEWKR80IWwqzOuX1D3lWAhnDBseRK2ipqZQuBTwFxGmnT0eJav
	 UHXN5k/xC7s6aykWeeODoFtuylrXyelt5bmmfSQdcSQlHyTN6EAtr1cNMSt5dX1oJZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430614;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=QI7b231Rt4XSgEEjFLLe+HgL1JDcd/InrpJCQqwg/vk=;
	b=xrxIMAax8IpRRsIonD65Yh85sDrnABnqPCAdxz7RkltZF60q+mwUETyde1l+cqUD84ki
	 VhFIK0h0dvUkzBhORyMb+b3RUp9Fqyog/6hynOMxr3DpdF5rRQpXNsO7Eod519k2+Y75Z
	 Uh4LmHsQgnF//9CvHj3PBgWljCCR5JuAFaJuJ4V4dWzd9Sz9F3Dr9ImwjGfqLglC8K6OF
	 H+OhogEP68XPrbKzePzGFrtaHbbYG4QIOxMpncvycfJsvTU9ILpNdWSkmBHqbeFw5/egd
	 KDD9uQOXrTRJL5wnWAt+GL/ERjKgShvz+dOs8l11xhhSuZC+f/CuOwgz1S9ESF/1Exw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umHfYLPL;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C1A606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3C1A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umHfYLPL
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3adc4590de4so1268399a91.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430613; x=1794035413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QI7b231Rt4XSgEEjFLLe+HgL1JDcd/InrpJCQqwg/vk=;
        b=umHfYLPLqLzUW3IFpKivsHtxeyVOT2FLHGSEYQPWx9t1pu/H0A3WPgMuxfG1M6cx3S
         y4j8oSkfk02kdYwP17P4Ts7Eja4zvK8f55sWY8Mue94WpzahFYucKSwIQqtnXoCx8E1F
         sBBaFdguVqVktgoz0XgWfi6VdQz5ZxrbLfN9ijeFZy2ZvIwujWSE/YWmrwYnlVaR3I8r
         tSP3ZovJa8k6Ffn1AG2zkPr3ceiiyr/oSnvYN4PRu4uwLbuckPb1hX+avvLFW1l+nL/c
         MMMyli04Vgmjqmznq73/LxApu/axhD6cvLwuEN9q0HxyxJ+fjpmKStQ0LCLuWXf4ZtSH
         o7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430613; x=1794035413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QI7b231Rt4XSgEEjFLLe+HgL1JDcd/InrpJCQqwg/vk=;
        b=dSzAqFgcGQ8meE4yJl2Nr8dhdwcx/ZBJST1+AEjjtfxDkE/qLPRYHpGoKnRUwNRx5F
         Ns9o/t+9G4R4NtIBH4u+Xr3HeFeRCQDQj2Bg2IT1rWntb8veHhhDtKdU+0m6EqkiRKSj
         s+GMNSVG9BqBnAqtKOiuyvrbirIEyN1uUfM9d176FMEIIZ8tXyYpwEdvcvzawP4EGG7t
         GRmiroMg03BO9/9q+AYuLH+RqAACAcOPIvwBx7ipwdm0MCi3Gtk2dSMXYIs54TKjG+Vo
         /93/iveN8boBMqOOxAjUfj0YXXMRulYSOJctkrpMgzBvgK03rE3i2ecld19Gxe6krhgP
         yfYw==
X-Gm-Message-State: AFq9FYLY0O//3u77T507C9YJAvo51B2PkAm2JZgoFsJzqqyjf+NuwGih
	XFGMaoVZRgWH8V1QBQx9y12d4cO0+TYLeNabudK6B7OiMZRZ7RR2SUVc
X-Gm-Gg: AYBFou3jt7GQ10xADj7FSqOrf0oIWpeskukjNSqYlGa284RuNgCme0hN8wsBBr3g5HA
	yuGVcxyeBN7rG5GTJysWREfG3hyMOv/ixSvuT/+Lj6eG+2ExsRZBpjRQCuNb3UwYlnfbgl8VM25
	UYkVp8bhrUCfdkctg6XJ/uLMh2npjLPGfQjK9mxH2m7sOfAKDQk764itFUdaiKk//rrfr5h2xJT
	SMaSF878/EDr9oOAQmBlvpZ2ikJ/MoVQJrFMFNYNjJPbNZqxBmZqCyDd8ZgwNZfpAzepNYyU6y0
	+zhQe1nMT2zsLk/pNioaMtTqwyZ0BH4Stfi2G5kfHi1czTJoU2Pd+7AR+SdBFdw4gg29mjM4zrC
	YaolC80Bzy0myiXXNKgQH7FLMFJ5UuZOLYAMOiQCR9Y0Zc0kwupE0flk7JGVd1K/NruXggMysiI
	gzt0pFq52i5xwnq0W86+xQ5eZaPS17VNwwxNmF+aW85lh5+UEkVnqhLHrXFd2XCwtioQCP1Qr4W
	ZrjY4ui5NklnH9sPimCdNDgxbM9BLFhsVtz6C2mAu1BwpmcixGIHTT3h1fxSa6SFJN8xEASfOom
	9U9Ue5gY8UJsE78WoqLZCx9vjTSIs8HaD3qSoKL2IX/Hj8Epa8hadER2Askpa4esMlQEPrMzI9i
	Vz9Pj
X-Received: by 2002:a17:90b:570c:b0:3ac:8897:7ba9 with SMTP id 98e67ed59e1d1-3ae8985d52dmr4026759a91.56.1793430613156;
        Sat, 31 Oct 2026 00:10:13 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:12 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH rtw-next v2 0/7] wifi: rtw88: extend 88xxA support
Date: Sat, 31 Oct 2026 15:09:40 +0800
Message-ID: <20261031070950.425176-1-hjf3108@gmail.com>
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

This series enables HT STBC transmission, VHT SU beamformed reception,
carrier-frequency-offset correction and adaptivity on supported
88xxA devices.

Tested on RTL8812AU together with the driver-frame series.
TX went from 136.0 to 144.2.
RX went from 215.5 to 249.2.

Ho Jie Feng (6):
  wifi: rtw88: 8812a, 8814a: enable STBC for HT transmissions
  wifi: rtw88: 88xxa: receive VHT SU beamformed transmissions
  wifi: rtw88: prepare frequency-offset correction for more chips
  wifi: rtw88: 88xxa: correct carrier-frequency offset
  wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
  wifi: rtw88: 8812a, 8821a: respect peer A-MPDU size limits

Jie Feng (1):
  wifi: rtw88: correctly expose beamformee capabilities

 drivers/net/wireless/realtek/rtw88/bf.h       |   2 +
 drivers/net/wireless/realtek/rtw88/main.c     |  14 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   1 +
 drivers/net/wireless/realtek/rtw88/phy.c      | 116 ++++++++-
 drivers/net/wireless/realtek/rtw88/phy.h      |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  25 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c |  68 ++++-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  24 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 100 +-------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 -
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 234 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   8 +
 13 files changed, 474 insertions(+), 124 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

