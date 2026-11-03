Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712933;
	b=AlYVKka6qqRWrs+JFtPiJREnQ6Md9R2CMHG7eDHqv1/yn/yH4/XenvExAA0d29fOfCmF
	 Ocq3ou3Wuchf0hMPnxsvJyi3Rz0tn9cdTASJtRhuFIhJkpEo+/J3c0P4l6GApCLfzEu7W
	 QeTcJ40FDRTF0YLASpxXpDEd7tj3DFB0SVRd6Q5NWtoWgDJonduq6KJbi9cCvl6D50rKg
	 28Q5U+ZEY7a5D/a7fVyjNzEggH+N3ZURGY4dXKaMbli6mdrqjcD5GVwW4uMmpqxq3AEdT
	 lnZ9lAaaeKwOgBEAj+eM78mnxRwst7kP7VwBOzKzERTkLSaiTAWJc6v6G5Me+vt5Msw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zqqqt1bQikgmsTno5raObEPlIaVtYNiSxU2NrfmKzh8=;
	b=C7qspG/YFb4aVJwkg5JpGa90itMbma5CFcPRsWAXU5qQG6EcE53Vhx8BYkXCYIv3gO7l
	 x7kCdQ4ZAg21Ytu8+Yo1STRO4J63WN5aYqHiHEOFerU0pIBtGyr2fp0KPBguNSpXGGUj9
	 OxYRJOYch5xMbSdkSUC9P5G15vqRoUBcoAF63U0TYBqyetClEtXy4qat+f8qMrJ4SORk/
	 lt2hxQR/qnQ/vaKvRHwxHGu1vHOcU/IwUxFZvbBxSvVyhvqHTz2Mytup6CP8U/5rXrov2
	 +cvWm/p0Njjbs0jkLu0zip8ja6bgHe+RwAp3VhehtDzHhL3H731SCuH9TAKauLDUQnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmIombpa;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFF2606A32E
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EFF2606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmIombpa
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e0d1da913so582047f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793712931; x=1794317731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zqqqt1bQikgmsTno5raObEPlIaVtYNiSxU2NrfmKzh8=;
        b=ZmIombpa+vjIFomYPhSt7J+C3mIU2PimU68TMd3aqil20orO3pB047VhwxX/hMMleZ
         2OHBWhLWzVGW+cFSTuBIzTdRhcJHtnCH+V3fR3I4HPrIo18S2o50aVIzBPW3XsQwuqXd
         61OZe3wSLrkE4hdeCh/lz7Ql5hM8yjhVpjVWlB/3Key+jLNue6gjGkRLk/l7XM2BSr9B
         MFP3Kpd2TeXNAp4oHg02YdhgUQ6QtLPm1fnjQf9QtEvZdFGTnRhHJVezOW57SgCrus+3
         Zd5E+Pvvx2uNHCQRCFYCOeLSoO109TzZMMT9HfRRLc+u5VaNfHyK7Tg/HBZSfDEkhIEU
         k2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793712931; x=1794317731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zqqqt1bQikgmsTno5raObEPlIaVtYNiSxU2NrfmKzh8=;
        b=gUNpAwazZQPpUTTrqGWzAsz2BZmAux8ney/bexRFz+Gzu/Ke5OG6faP53rlQgVlOIb
         EI4tgbYdbpT0nZYU76/mzCb/0xvJEOIAlGD8J3YpecGQM215D+9nMfWLq5HIouSmXfLJ
         UwDpx9laglJjv7uzn40TAYMWEGedLzKz5THb4bdMOwv4rEZVA8255taW9pVV8XtLpNCq
         bMfiGI24k6svZWuH/s8Ysv4UiGLamv0gqrB2XqVSQ0u+0PMP7Lzh37ZZdWb32DruJLbm
         qbEV87DT+sJ4RWTA8RRBu2HmhmboVINBGf0443kOoQyGhozOhM79Sfa+MSHVQWnVe4Sv
         473Q==
X-Forwarded-Encrypted: i=1; AKwUvByob/SFj/e7VPTXJRLDV7H/Zt1FEUBzveP50hHclk7d4yYN0dzVL3naw5FdS8SvvmsJ3mTM9WtFH1iqx0Gm6Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z8rRV/Mwrzc+5XrUBeAMpFzVI9hAkV1Yo3bSRfmRYJFIVU1Ve3v
	Q48qXI5eHsQY3IXZOcpY2b6+dDiPpJ3B1SXdXzRUL5tn1PBZFzLTB9/U
X-Gm-Gg: AYBFou3RIWkZS55Fn0p+AeNQ4NgNl/i9h2zg5hEZZy69mcTdvSLTT0pKPDJ8u03pAE1
	nbgaTbz46m/s3KH7501iZO03NbnX0jIeTCCO0BpeOG6jYmALHWCGMEZZjVnqHGjcrA2k5jbLOKP
	Oe1O21U4m2NrPe0jspwZcvd7vHQoW2ni4+t2xoVSMHG2Lq9xk4E9nNhqN8n/xkjbGeWtkqEobht
	kHS1jhqnLPsBWjG79Sf0XuzVNom6mKQaep4xuzPOZ9/11z6dEud3Gij0aWFHstconJnXb9dLZAc
	wVUxx8JBqIInqxGzPdlyI2SJ0Y6yioFPOFVTyyW22bTXmClxV2f62Yhw6kQplDGWqtjhVFJDS0i
	YHUZ2x7AVW2TV+UIVecggymdZU/V+/g/ATbc5IRt+YWitHEX+wFUXridNEhwbj2bCD4SQltDLXK
	54QFNpMzJOlstNapMJFYxdvqdX6eXHL4e3E84GL6qcARm/tLr4KMKz+Y/rMYsAKt3pr9pKYgAzJ
	jB7OlPciuVwVlRSIdKtVTaQZd3u515NOikqLA1ZyTYBfj6T9soHwuDx/uJNvo7aHH2ylKL8c2Il
	oNE9MFUn4f+QU+J6Fx0511HEYHoHw1HW4e1RJdd5VCwQYrP9ryY3p7MlhGpzILKaA0an9AtPyRg
	9dkgz+TTTTZJdVzk+bYLXsPagkA83Ov/QPmZVv1JcfEF61qdp7wYHNnHSF2NAo606ug9VdkW01I
	Cgass+aMWMV+zC5sPEzgIf6uIAwHemBcSDBX8kJo2Y+Qpgp3dYwHVHOw==
X-Received: by 2002:a05:6000:250a:b0:48e:643e:de82 with SMTP id ffacd0b85a97d-48e6e2cb652mr30505104f8f.11.1793712931006;
        Tue, 03 Nov 2026 05:35:31 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-d09e-6586-7547-87ae.ipv6.o2.cz. [2a00:1028:8388:a84e:d09e:6586:7547:87ae])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80eb1sm26661746f8f.34.2026.11.03.05.35.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 05:35:30 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Allan Wang <allan.wang@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 0/2] wifi: mt76: mt7925: LED support for USB adapters
Date: Tue,  3 Nov 2026 14:35:26 +0100
Message-ID: <20261103133528.53197-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
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

MT7925 USB adapters such as the NETGEAR A9000 have a status LED on
GPIO 8 of the chip. MediaTek's Windows driver asks the firmware to
switch it with UNI command 0x2a, but the firmware in linux-firmware
does not act on that command [1].

This series drives the pin from the host instead. The layout of the
CBTOP GPIO block comes from the coda headers in MediaTek's gen4m driver
for MT6639, which uses the same CBTOP register map as MT7925. The first
patch lets the mt76 core register an LED that only provides
brightness_set_blocking, which a USB driver needs. The second patch
adds the LED to mt7925.

Tested on a Turris Omnia with an A9000 and firmware 20231227 over
several days. The LED follows the throughput trigger and manual
brightness changes, and turns off when the radio goes down.

Sean, JB, is it fine to drive these GPIO registers from the host, or
does the firmware rely on GPIO 8 staying in its default function?

[1] https://lore.kernel.org/linux-wireless/20261012125310.13917-1-pepe.schlehofer@gmail.com/

Josef Schlehofer (2):
  wifi: mt76: allow LEDs with only brightness_set_blocking
  wifi: mt76: mt7925: add LED support for USB adapters

 drivers/net/wireless/mediatek/mt76/mac80211.c | 12 ++++-
 .../net/wireless/mediatek/mt76/mt7925/init.c  | 51 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  2 +
 .../net/wireless/mediatek/mt76/mt7925/regs.h  |  8 +++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  2 +
 5 files changed, 73 insertions(+), 2 deletions(-)


base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2
-- 
2.54.0 (Apple Git-157)

