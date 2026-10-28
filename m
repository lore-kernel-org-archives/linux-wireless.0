Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197191;
	b=TNWArl/0/ehdQuJ7rZOwOXqJLmLEU9KasC3pKz34fYNOX1EeCBdS9JRQUctL+e9WE+dz
	 X8bpYD7z8azbDiVqQE+qIlSEv7Ko7XMYl2C4s8Lu9LzYlzlSEeyiWGjIw2Ha/0n96mLp0
	 BZbj7QINhwYLF3e+K5x/nIa3oQr/Xey6HGhT2pRiQDpTDAnu9eFcdCtA561wQUq5K4h7c
	 /lF8BsLQ/KOJYOgYOkbe+kPZ5Ua9L7jHABGPJaqbmQG2Xu/qevuQdh/mIQ+x0Pnlpw0K8
	 l1JvrpyNIbvAPhAys9EpAtHv99ONJ5t4Z4yjAW9Vy2C1ycxQI8dwfWs1XBuSdT+5Xhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kMi186sipMCPPAOY1m8cGHv9pOpCV2aOI05mfiXBJnE=;
	b=Be+R+gJR28VaagryeY81HjZk24DucMrq9aZaXDRb8QnSmMt1xyfCLmECRH/5lYh4IwIY
	 Ru2QxfMZTfFZR1+Ix+rxapPtk/Y8/QuNEo2JKpTYpfqh750PW09ygNA6NRkXS2Jdw08fu
	 dbBHQ/bxT6+lcndvKHJC7NxhyI0btF0kOV1YlIMjGiFHUJlHRsyELfuZGEyXk7zanAPAs
	 mtu5kfcDny14IF8jYqgZNT6WTGEbleII1WDqny47y/Cwpu4SbBxlLx8Mg7ICKzANU68TU
	 RznfzrtBOkdEFR9GOC74xSaGihs8WG6QwFiMgBtlvUsLZbH3WeSg/OQJsQumo74Q9PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wRjSWJOZ;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF7C60A260A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CF7C60A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wRjSWJOZ
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so1147912a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197191; x=1793801991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kMi186sipMCPPAOY1m8cGHv9pOpCV2aOI05mfiXBJnE=;
        b=wRjSWJOZYZPdAY+OE4XZV6r4KDrZeBQGkQPzFoJKC6gyoSpl4N13146XbZQieY+k/R
         rMLaJVOE0sNqZvjZm3LFL7LK3LyjWYNLJaLsgnUNSBy6N9oZXzKSPQCaUatNy66mHwP5
         eU6sctMtl8WYVOiM4R81RiQSdr0nYddco0kRuwRExbcR3oqJ06t4tKqoDf6Oyja3DxB6
         8yx7khBA5WHLVJ97nkIU9oUx/L4BLX5swZJfK8GPIpZ8lLsV0/haKR8SKwAO2pbaQdHK
         jYHOzz7UWZJE6IMQ3SIQ/bVUgU0UOqYuRdHMrhyFyIQ9huonKkcbZaE22jN5qilj7st4
         ee4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197191; x=1793801991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kMi186sipMCPPAOY1m8cGHv9pOpCV2aOI05mfiXBJnE=;
        b=TSG0YzW+7/lQkuwjSh0iTsVXJriW5iW1YxtTGrL3j6qXh+8ZsUA4z7vv5BYStmUIuU
         vBMXe31CTQjWnWVUjqOaXfOwJ0Nju9iLpphLm6iBTwjG8OiV5HR0Tiv17drbmoOEWTqQ
         5uD8EXG8K9EcmDINOisxgkyJu2IMrqm4fC5Es7byFvSMiH83iOQ7FFfcGW1bCMEizE2b
         DfTNnrWlqYMZ8SthY5lmNGpFx7LtEoXZkyVo83MMjC5v8ddrmCiOy/Q7ix3yOCOwWUAp
         rPMV25if9kPGKg0tMCi1BfU5F9Z6dbg87qMCdJuOGKHCfcTIiOk3nLzXmnAaUt9iIXdv
         3Tcg==
X-Forwarded-Encrypted: i=1; AKwUvBwrUXjT4fAqP3aZ+6pyoEGZRc/F/cTRZM1MiXXEikG8kvoypTilvs0/6OB4m/kEx7TZQYw4kIHEZdkh80cAdw==@vger.kernel.org
X-Gm-Message-State: AFq9FYL2xK+NL65dHeqTJGBVQjAAA5L7m3cJhpKc7TMOuoHsYo9CshYT
	wUrgLh3vHCeGG/JBD0X+IKgV2G93Xlb3KBNeREM6NfIKwx8hWAOYzfUG
X-Gm-Gg: AYBFou3d/GYigzmvLzz+JINadX46KHAbbk77+A3kOBnmo5OG54iBJ28+l0Z1I0DyUrY
	wZkzR8J8P2mAlREIhXx8VcUj8F3TNwbPyucnnLMhVHXNHyu60BFZh+dDzL///TY+suqYSdifuAc
	qWlJrJL+YuS4bL8Nd6b2RkN/iFMSrQ55WyoADPFQLQ/9thwvUMceuj7RGD0o35TKPduSKkUzul+
	2BxSe8uqOn5vjOViPGLGyh/tM1pn0NiZ2a5Xi1EHm8uI1vNZciQM14+ZNEBv5Vl5ZuhVludUju0
	XE0AzVURjI9Us7NckSmAQqIT8MA5suZ2t7AKr0GdtbccO2Y8spqtOs1ZO/WilkJjcYMcQSqJoYz
	s6b1K69Fje2qzUBwgvH00d7Pa97WOOixmsuihLFhISTbw5PUju3M2Kvd1OS1mFQOWwjaFylfvws
	/aaeULtER+0MuyTBKZsYPSG07GsBW4aCOM1ht/zXZ8KICFoG0EbtF6BYqE+ZXZoEb7SrRuuR3rT
	k2I/bT/Re14eDaU365AH2vHsq58XL+XgFqcWyKRTyye6roAofCjDZ+OYdhycAdFyjJ1pc+u4M6r
	PolSVq6LJfdUJ/pnN3hQsJPu/7SICyQNyv0E4QYd3ZFAmEhrYzKYCjVmmvrOqFP0/GfK1R8BFiE
	C20qZ57iDKjOSWg==
X-Received: by 2002:a17:90b:3944:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3ae580d0513mr1943943a91.37.1793197190592;
        Wed, 28 Oct 2026 07:19:50 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f286fsm3290141a91.15.2026.10.28.07.19.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:19:50 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Ville Nummela <ville.nummela@kempower.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Marek Vasut <marex@nabladev.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Stefan Hansson <newbyte@postmarketos.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
	Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] wifi: rsi: fix background scan result and state lifetime
Date: Wed, 28 Oct 2026 22:19:24 +0800
Message-ID: <20261028141927.9306-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Initialize background-scan results and report cancellation as aborted.
Report command-preparation failures instead of leaving mac80211 waiting
for a completion, then serialize the saved request with cancellation and
firmware completion.

The patches are ordered. Patch 2 clears the saved request on every failed
start; patch 3 relies on that invariant when it treats bgscan_en and
hwscan as one state protected by scan_mutex.

The driver is orphaned and this series was not run on RS9113 or RS9116
hardware. Testing from device users would be helpful.
LLM assistance was used to review this series.

---
The series applies without source changes to the retained 6.1.y, 6.6.y,
6.12.y, 6.18.y, 7.2.10, and v7.3 trees. The retained 5.10.y and 5.15.y
trees need a context adaptation in patch 2.

Zhao Li (3):
  wifi: rsi: initialize background scan completion data
  wifi: rsi: report background scan start failures
  wifi: rsi: serialize background scan state

 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 50 ++++++++++++++-------
 drivers/net/wireless/rsi/rsi_91x_main.c     |  1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 30 ++++++++-----
 drivers/net/wireless/rsi/rsi_main.h         |  2 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 +-
 5 files changed, 56 insertions(+), 30 deletions(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

