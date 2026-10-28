Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197244;
	b=O5FOyniH0SNVUCgEHLP9xzYxGcRdpPiGtx39L9hKN1KE4cuKXVnEtvD3sCyaYAz7eMHx
	 c9CVP+XOI6IYTUD+d7o4pi5SD3cR0kG7U/9Je0syGThbhsZcHu/nUi7EBULGBvCbPH941
	 lkP0Y63x0dBIB1AuEMHJSrZKtBgcj8EXyPgG91QzNRJULWRT3sWdCc+w3JF7u5A2sRTf2
	 cQdW8qapQSoScJMHYHfvLeVbFr9ekjGFHjXgck3kHK8SkmZRpnKcN2oNtyIaFIexyU0WU
	 oKcjVN6aGDaRTEqO2ZCNu55pa0ef2m08AeVDDze69BmXfDNOWszHyaZpL7B33VXVg/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6n8IW/uLeuiPSehxbUOrC5l5QcKl9RaPrUD5nySkR/A=;
	b=ab6Xfysdm4kc5XKyjzpmD5GMqbLqSfOazjoLvwAXBpYZhL49rUuYesSViLrU1iPupm2l
	 SDe66MKV1+4ZxkWzh9i1HJB3em4MGg/tW5AqViHZIx7VCyfBApVM2eH8z9GF8TCFt+kwI
	 VhLQah0XVfLwtuoqba1KxVAsHooSDts3+GuRaSZmnGIkyMqvDHYV6UydsAZJtlS60WweY
	 5FhizS+Wp2x9WDawLi0nGrexw3dA80Tx/dQjDyWmAXZDbAwQMAdefSVXu9Jk0a9qO1S3X
	 TtfOGk3SIsyKnYDwxiaYKXIkJu3VJeoVf3I982/STGqTAWj3fKGwY0EqbD1vkQaSJFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="sjSmWs/L";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E9B606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5E9B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sjSmWs/L
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso487384a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197243; x=1793802043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6n8IW/uLeuiPSehxbUOrC5l5QcKl9RaPrUD5nySkR/A=;
        b=sjSmWs/LBhPuYyzDNDvi8REjdT7mYhQCsdWh6VwjVLKtvFc3gQXVaXNXV/msBoUS2k
         4OSrqCw/XHsCXZhVzfzBxrZnCv93DLDZ0pukBrTCBf6PC5TkrzMiWsWZGlU7rO4vGCga
         OTNfZjdfUYbD0Vi47ykpTv2wHSrOyeEwlrMytfCTrM+r2evVAFnm3EWxvLfjdZR4RsmH
         G0NlwvCqyEboxkYKLhlqbV4ZssD7/c8yBC3GsjZFu4hiO1bDUJAV6lN2XWMC6JIxMYfL
         8QRxCoKbOnReHNWQ3eK1pDC6wQ23bhjMJBG9tzXr9f84TQOEPK3pXbTFngacazjs8Sgc
         B6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197243; x=1793802043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6n8IW/uLeuiPSehxbUOrC5l5QcKl9RaPrUD5nySkR/A=;
        b=dOfodbAiA1gv3b6iqZxmIr6GsDqYLd9CGYmQLeI6RqddjGiUv6NsHB/UvUrgiYZH0z
         OSIdNh3hoTRE+J6fUxwkyICa8IMTBCQqEsr8sJJ4URgdvjlw9BmIMTJvWgpr1nPxl1y7
         /SzRNZfeCSYRkRZgGacTWn6hvFW9AtoEn+S7tK36gA4fr2+28EUd9wndwTHeaUiroQMk
         6fA5Ic03wZ3nEed4t4SrADc6sTzUW0iylZVQccpUS4Oo5RF2Iac+Y+xLwGRI28A3PG3l
         v3W+I+Vo6lfjkjYHld+zgzQfy+eqG2arZX3+XyURYLdDwkEjLV/Sl3FFvKuelhqPpT2w
         Ddeg==
X-Forwarded-Encrypted: i=1; AKwUvBzDfwN7TE6isil82+7MpcNjOhNuBJubAPHHzt3LAOKnwoPhJTK/24Emi1XDOrOsRQ5MfL1oC361vOLLMgLRcQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLJA56+ZyyQNyTb2CvZbSNSyfsiuFzQ9+YuE+xhslDue0wLULtr
	bN26xmVE8cjt06rA7GtvMFWKcSM3N4vH2/BnDZSdYYYy/EiBDHwVW/Ch
X-Gm-Gg: AYBFou0EeZwleT9rmzRjujBs1DAGzhGXCyYSicQh0R/+V3ztLgMR2qOlpWSaIw28ZV+
	ZsNaUNq4hxA3VxUvgpxpg21qCcN/79jlHnLjLRUITwUIoOKzp4ZZaA3768IcaaWAYisUbyD0HE/
	g2lTEX3B0Q09Uk3OSEFGMydSa9hFLYE0qQHbDBSZgS5uo7yJUVmVQfAH0zhMJ30eslsDnLOLrpm
	x5CZIUgX8qvsbA6fd8iEEvQDQ1CfH9REl1DUpA0GTXnRhLErwNbG25p3Z3rU+tGrE3mOz2NEFBm
	msbQk5iOmdzgI9/ZJS0ISrB9rG7p0puqRFWS3FtW8vF4kFk83sPN7xfSv0sDv1dQy8qKDf57/oc
	eGa5G1Jl6V8eDw0mevYVLBum78SCOqwxHk4wpLR5dOfxUMIyVtazpsmtiH4sjZ77NyOyVR1LAra
	UPWnG09MyKu2/kzG6w7DvefNBfBOmDNVSduRGadHSJSoZPdJRP4FvW1Jx23yRKElP4qUsPHvP5Q
	I2os/gLo9QfHPy2hLen9z1jPUsQbP9Qeui1mir3hldcWkzvg4raROR04jX9NuX85H/L17YFknve
	D11zDe8tjXENWdH7pyrohyIssCtI73lX/QEr7o5hZ596MKwZKauh4PyEKGu9gTTlj6oqhw==
X-Received: by 2002:a17:90b:574b:b0:3a4:acde:1e3b with SMTP id 98e67ed59e1d1-3ae57f637b8mr1772644a91.13.1793197242672;
        Wed, 28 Oct 2026 07:20:42 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a501083sm3765987a91.8.2026.10.28.07.20.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:20:42 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Stefan Hansson <newbyte@postmarketos.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Ville Nummela <ville.nummela@kempower.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Fariya Fatima <fariyaf@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <amit.karwar@redpinesignals.com>,
	Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
	Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: rsi: stop packet threads before bus teardown
Date: Wed, 28 Oct 2026 22:20:13 +0800
Message-ID: <20261028142015.10717-1-enderaoelyther@gmail.com>
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

Stop the WLAN RX and TX threads before mac80211 or bus teardown. Then
stop coexistence TX after HCI unregister and before USB reset or SDIO
chip reset and function disable. Probe failures are covered before
buffer freeing or function disable.

Patch 1 makes repeated thread stops safe and prevents the WLAN TX loop
from draining queued packets after a stop request. Patch 2 does the same
for coexistence TX without adding an exported core-to-bus wrapper.

The driver is orphaned and the series was not run on RS9113 or RS9116
hardware. Testing from device users would be helpful.
LLM assistance was used to review this series.

Zhao Li (2):
  wifi: rsi: stop WLAN threads before teardown
  wifi: rsi: stop coexistence TX before bus teardown

 drivers/net/wireless/rsi/rsi_91x_coex.c |  3 +++
 drivers/net/wireless/rsi/rsi_91x_core.c |  2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  5 +++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 15 +++++++++++----
 drivers/net/wireless/rsi/rsi_coex.h     | 12 ++++++++++++
 drivers/net/wireless/rsi/rsi_common.h   |  4 ++++
 6 files changed, 36 insertions(+), 5 deletions(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

