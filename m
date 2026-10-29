Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281697;
	b=FHt2i18LqZCOPTeinQliz8RhX0bppzYIh/91qTmdZzzA2S/sTqWczV1yidGM0HKmMT3f
	 IICnKMrotuRgUy8g0gdtpddDLWndcDcyXKT1w8vulaJGi0rCVjyRF+uuduWn12tb3bbjE
	 vCsXpNhD2JgzsEgncQQgwmkWz2fMbLkAytLoYFD1M95RqohYjPizOraJNGeGdCA02fM6G
	 6Uz04ZRVTs+LRoiYn/RdejIoDqUnSN02tA6wk6HuwlzifxWeRG1TBAI+GzJymIVyQ9u6s
	 KBoFLduFxiUgqeI2lOLg3BpbD43VORfmW7D5p3n65iNQFlzcmcKHfGUfqzRlsto8LtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281697;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NXL6vjElIBUFhw/LojOyxWTnCZcMn1TFWYFnzECyeMw=;
	b=mbeib11LIjV6P3ZYDWHcSspSGj62Ch+KpxehPkFbtLutdaxd9RsutLTrXEy88YK13w3C
	 fM059FrvV9PTx4EJxrKoSVAkVokEb1EteybnjT/cuTc5BeX0Bnrk/TsW5V48ZQzEqUSbB
	 ATRI3n9pqoBKgi7XymudhB+Era0dNEih+e099Kk/mm44AqHn7zhuz8vJ7S1O7Fyb9gCxp
	 /9w5ah7BYk1Cy/DCHtPOfKsQJoJ38EAT6alMBd6JBvRn7w2p5CLn8iPMoPKe2gsJm+dqj
	 OnwdTRbuBoaYre2pRDy97UJFXQX0kdF2XRKsCI38mUAplu2DUdNerrTZIu8OA7EIHyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a884jTTU;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1564606A320
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1564606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a884jTTU
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdab9e9761cso1181601a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281696; x=1793886496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NXL6vjElIBUFhw/LojOyxWTnCZcMn1TFWYFnzECyeMw=;
        b=a884jTTUEvD+ABwLs5z/jf8Woh4SsmGgNuOf0jbegloAbG0YrMcjjKsqk1RB78KyUt
         dERHiRsFgWmd1f4lmIpMpiUkXisHD8BRvcnQ4uoETCe4qQ+ytRBkTfqWUALBHJSJse9u
         a3NKzODwY5xZKV42i5GZmau884LqD5K/UoCqUaRF5TgusztGxPGggp8jdJPX7s+mrnl0
         97okd9NkXnEi7FcGhbresGocp3KBOHIbBRogpfcBwdoePLHZg+YTSifwpPk3WAF1ygdv
         y79IAhxLU4JL8fuy2Wk/skcluVd0UMwgCcv3TuDNQrdhjH8HjKEwqrGDGJzP1pF0yLVJ
         VryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281696; x=1793886496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NXL6vjElIBUFhw/LojOyxWTnCZcMn1TFWYFnzECyeMw=;
        b=bk6cEldHQSOzxyzPudMFfHH/ftrGdQ58l0lwvrKynjilhPf1pfPJDMhy9ZIF6NRmCr
         Cmls3zRLx+qcWuw6HlS26Kc7lrRegoqHiXmYXWFB7VD2fRXynSn1M+M1RdzqOE5PMWxL
         S1RTtvb9rkTAENjiG++BEM+rQoi3raMvWJPVBHbQY9jeZdCsw8dVkbpNehBCU7FWy3+u
         UDiwCBvIVzirzXY0rmFXqXe0jeQh31Nw8eFy7JCXJ3b/04eY/COetY+PZUfPfdvzWW3N
         yqdADj82qzuZQ5NW6pGHzV9qiu3ujPd0613ySwgoYgZVjVnAbpN5e6jR04+PgmxpvvPg
         CMAA==
X-Gm-Message-State: AFq9FYJaJzBuwkolIqtAhRGoB/KD4E92EU9D3KNI8oZm0cMI9nBSwOQz
	wKolkbDxxK+bVNEUXNTf62fbJJp74tkXyU83Gt+mxMj0PxkvS8DlGyTnRcdLJBTr
X-Gm-Gg: AYBFou09kznSjym7y/SIRhguzrBphZNEmPGBzwmvwudLEaVS210yepT9WJe3P5dj+nH
	H2V6eYAt8PfL+kQZAN68Ej7LUApSRwI6ZpvjQNUWbcvNIVGqWjSMTWLqv3DKe396lhrUFNiniBG
	oe8sfbw1whw8WTUx9AdjeNZwrakoRcUmdh9Inir+nCcnLLCuR9wDp2RikRnqT0LrpGvluR0FH/X
	/SCv+cIVZnBB1YpXvckJ4Ynhjv76OHEUYEt71X4M+J7xO7t0y1uCMUH3CW1FuIV8OyLjdgEkjbI
	2dZl3gvHk+HrJeuOM3r5yrsn0F+rLEfnm67SoH2Zc5zv3HpgxvEGXFYk38aFVd0wIbeGFv450Ot
	bNbPGRuhl4wnIroLB3Y+aKU5Gf2Mp7fRWZXFxYJeBbdDfvC7HhsrkcGTTCgW52hMztwEecO/TMM
	E7NDRE1hcvZJif3FIcB1suUhL7wCMS19TR2k96Rue/l26ulmtPGSyutF+HEznrHgsuYKzLYGcpF
	PnK7UIpEauX4igTHOPdoGDlOyjlrcRs8aR30FY8oNkao0eVy3MQiRrUGBIFjNQsqFZnRdzdlICj
	L4PI0Yu2XDArta0E+WZhbjGF8/33oyBc18KYnuagmZ7khZs41pmbqpJTrsTbFhNLJ3D6J9kIJPu
	afaqb/zfV
X-Received: by 2002:a05:6a20:4327:b0:3e8:b7fd:6266 with SMTP id adf61e73a8af0-3e9023edab9mr4591304637.42.1793281695823;
        Thu, 29 Oct 2026 06:48:15 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:15 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next 0/8] wifi: rt2x00: improve the throughput of rt2800usb
Date: Thu, 29 Oct 2026 21:47:41 +0800
Message-ID: <20261029134752.1299130-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
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

This series improves the throughput of rt2800usb.

Implements
- Frequency offset calibration
- Better fallback rates
- Aggregation
- GRO

Tested on WNDA4100 RT3593, 5 GHz with perf3

  patch                          before        after
                                 TX    RX      TX    RX
  2 crystal calibration          27.7  31.6    28.5  69.7
  4 MCS16 to MCS8 TX status      27.0  70.0    29.4  70.0
  7 RX bulk aggregation          30.5  67.8    30.5  80.9
  8 threaded NAPI with GRO       30.5  80.9    30.5  161.7

RT3070 did not have any visible change for both TX and RX.

Ho Jie Feng (8):
  wifi: rt2x00: start the link tuner when an interface is added
  wifi: rt2800: calibrate the crystal of RT3593 with the beacons
  wifi: rt2800: use the 3SS fallback table of RT3883 on RT3593
  wifi: rt2800: report the MCS16 to MCS8 fallback of RT3593 in TX status
  wifi: rt2800: don't report an A-MPDU length to minstrel_ht
  wifi: rt2800: set the mac80211 fast-xmit and aggregation flags
  wifi: rt2800usb: enable RX bulk aggregation
  wifi: rt2x00usb: use a threaded NAPI with GRO for RX

 drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 115 +++++++++++++++++-
 .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
 .../net/wireless/ralink/rt2x00/rt2800usb.c    |  33 ++++-
 .../net/wireless/ralink/rt2x00/rt2800usb.h    |   6 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  16 ++-
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 105 ++++++++++++----
 .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
 .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
 .../net/wireless/ralink/rt2x00/rt2x00mac.c    |   6 +
 .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |   2 +-
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  52 ++++++--
 12 files changed, 307 insertions(+), 44 deletions(-)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0

