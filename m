Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053918;
	b=ZDr1WYa/JL6JgjwcWPMzgEZ/VahsVsi7tZPi7/7P7NtEIYz4uzTfMhk6FHwAOZr3Ivpy
	 M1cf0c+oy1J/51o+RRmM3y/udDAvjAbdx4TcweTQCV3ibl43z/1CnJJ6nvTRpaA7p0a04
	 Bpzc/PYnFbal1tk12rBQ5qK1ckXAEpZg1wCBkIaRHvx9Cw/pLsLHF2/I0B9GZ0/Pz2GeP
	 8DpVFoDvYpPKTMI7FFk/p5OQ/16LqtyVvi6UyRtZpf19Eoi0SND3qf0vtE1NkHgboZSj3
	 qo4+t9T3tkWPFFg1wIRSsXcm7Y7SLQKeQxb0JSFch4z9+Pqix9DyPvKVTKZew9DmTWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i66KXUTXEbPZ+43dRja9tAwpUa6R3X+N03pd/C5xTMU=;
	b=EICOzeaIb9p0sWdfEmcZRgE99dVsP5OFdSKzvC7yCZ5ZTgSZHA4aZVU7OL+nABSjWOUt
	 YbY8RnKG26GnnC7iE7QdcBE36V7mXIiSc5uvB2vjmErdR4KRK/NgTJHWvyFN11QpXPwzN
	 HCo5H4azyQkZihr1CfTrCmIjvJx4S51ifSaPN84Ldg7OZQ9iuKQekgKZInsOscWPDLMD+
	 XU47HP9V/mrwsqBql5c6uS2MViwNSoNuQNoKN4Cj32nh0jMxSFBpGVvdU6UThpe8Fdi2n
	 dnEbX4wXsCGYEHAQplIaqhMt0DwEQ9r56Px2yq47wVte/UZg77kAWUmnOkQRXWwolqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d0xMsaaB;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F33606A320
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28F33606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d0xMsaaB
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so23229295e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793053915; x=1793658715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i66KXUTXEbPZ+43dRja9tAwpUa6R3X+N03pd/C5xTMU=;
        b=d0xMsaaB4WGjhMGrkqJN3tX6vRJtYGRSPRYoGoe7IZO7UV4g1DmJdKOBC8MC0hTe9b
         M3dc8+Z6enUQtR4ba2NqVaQYFK+jToBuneUNHPAWzRyjufMRUUn7X8OAuPFaMViZacY5
         tGEeiCjn4N/mOuI8HmFE8f6psJFG15ukXejnByOU+7as89+1MJyIkdg8wVNmO/fkqaC+
         wMbr55l9WYeD5beBpoGhc+H5K6r22JrkwutGP69iz2rfdCfDuSors96/KLnr6vzWKuE2
         0dhNi2/o8cgV2Lyzyv5DWV3FwPeiIPdjANz9T/0C6n8lR2IHxr/u4l3wn57uy2rUtA5y
         9m9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053915; x=1793658715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i66KXUTXEbPZ+43dRja9tAwpUa6R3X+N03pd/C5xTMU=;
        b=02HvF1qRUlOGN7Fp4MLli263zNjmJxU8svT9wvh0yPpOXD5e/uskj4mv2XqQFKmdCw
         JePp/B5d2vGBbFJC36VyuciCsOYENgns9OgqlrvWSySXdq6/LeGN2DtY28MjIBG+RyBx
         6LOLDDhYnzV42SoIeiv1+ixU+sbnU2vUm6SpEyf3aFAkHui92X5GAKhBJi0L/594dRbF
         By0KF5ipgaTcbwG8o0eS3pDwwVtsV1HqduU0O+1X0kTD5+PqxeNL51zAkd+XuX3PQVVH
         Gj8OLw2rEvcYVqq7PY7k89dgnjY2BEAoDF81A+PiAG5hjyn5QFMzEQhje1T+/wh0q4gg
         gj9g==
X-Forwarded-Encrypted: i=1; AKwUvBx8Qu01tZgFslGNvECylOoBHezZNYHtBOelR7rbWjm2e1aubNTZOoV4YUkTqlbhePhL6knbyFeyR+UM/6pWNA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIffstIXTAmumR+Iqe+1bmZdAzDr+RvPM2YbJG4w/PWcASrKx+x
	sRVr3NlWzt38p9+2Uh/RGS+eZWCUdNpK8MqPZKSasTbR1J3vHvz6t1s=
X-Gm-Gg: AYBFou0ueevTux07Zmv3OyOgB6kElF6YY1GNWPnDV8iDQFtiKlL6lA2eQxuY1FapMGT
	ZzrC+wJCGd2o8bU+aK7HF+GJ+JUPjowUqrgOn87JUWYPGRq/Je9EGfcXlBK8Mfg09nG5cRdCoiS
	sLDza0YZM1lFTOJEROYFne68YGJWsTVERYAbQOOX3P4uTBc8FUimHDCOlSCytVDRU+l8FxIi//M
	z5j2G/gFhMMWs6nm5uAIviJuFLWe/FHPJINA4ITtP1Rz0BH+H+jL/qLj74cd9lVbuoIL5GfcIfy
	g582EZkpbqiPpYNn/frhjh5rsKZpFeZtkOTvfOc5vBRVooSmSZhhFHVG3G4MsEAbrw3mCOG4ZZK
	2+Z4RlPKRaWCViOHYsy5PWC5eVnYauAWJ3qu15NocXLXBlYyJJQyKOTWEis4BvvGKJU/mePsWXs
	9Wse5VWveYpDmfMk11F1fylHXps5gyLcwmBGL2yS51TxTuoZOnAlkWA+SacZdaHAO8ho4jgGiil
	nDrWoaQDqntJ2rsX/T8CIF7ES9HPn29m1aCnA==
X-Received: by 2002:a05:600c:a00c:b0:4a2:133:45e1 with SMTP id 5b1f17b1804b1-4a35acd56d8mr145273565e9.24.1793053915397;
        Mon, 26 Oct 2026 15:31:55 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ae28sm229743655e9.2.2026.10.26.15.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:31:54 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	tristan@talencesecurity.com
Subject: [PATCH v2 wireless 0/3] wifi: replace open-coded IE searches with cfg80211_find_ie()
Date: Mon, 26 Oct 2026 22:31:52 +0000
Message-ID: <20261026223153.2087218-1-tristan@talencesecurity.com>
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

Three wireless drivers (carl9170, rt2x00, p54) each hand-roll their own
TIM IE search function.  Replace them with cfg80211_find_ie(), which
already provides a correct and well-tested IE search.

Changes in v2:
  - Replace the entire open-coded functions with cfg80211_find_ie()
    instead of only tightening the loop condition, per Johannes Berg.
  - Add pre-subtraction length guards in p54 to prevent unsigned
    underflow on truncated beacon frames.

Tristan Madani (3):
  wifi: carl9170: replace open-coded IE search with cfg80211_find_ie()
  wifi: rt2x00: replace open-coded IE search with cfg80211_find_ie()
  wifi: p54: replace open-coded IE search with cfg80211_find_ie()

 drivers/net/wireless/ath/carl9170/rx.c        | 27 ++++-------------
 drivers/net/wireless/intersil/p54/lmac.h      |  3 --
 drivers/net/wireless/intersil/p54/main.c      | 30 +++++--------------
 drivers/net/wireless/intersil/p54/txrx.c      | 12 ++++++--
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 30 +++++--------------
 5 files changed, 29 insertions(+), 73 deletions(-)

-- 
2.47.3

