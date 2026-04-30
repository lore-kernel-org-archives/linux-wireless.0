Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9332E2D7DF8
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777558761; cv=none; b=mYJyyaT6HXyg49Dx92xFAkOOFYtXNrW7f/ojZOqNnBBX8I0zBzsNqA9R4EWujpvFDoZJkaiJpY8X1G016S0YY8/jtCGaZ/ftxXEcNZaxQliVEmfqNoNGdDN0EXkqQF9UL11G0m+r9/nmGDcbam9vCm/Ekka/cRo0u0ekvmxjWpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777558761; c=relaxed/simple;
	bh=F/klmbLlHjty1gUUHqY2Dbg+r9lnLNSpnZBORzQfjJQ=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BIg1tIBwrBmnlbI7sAXGBYcKTQ8IVQjGqAzKoWt2byZk/1F/OZcULFbS2WbdlUSTVpYP60x/W3msFC+SoBvjuxrBHn7N+7E4aDb20dELWW0jYZKmpVvlxVR+kBKFUpGX0yV1It8Oz6H/DqNOwVjinIj2QerDZ/6WKT8T36LIKSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4P/LG7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4P/LG7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D98C2BCF7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558761;
	bh=F/klmbLlHjty1gUUHqY2Dbg+r9lnLNSpnZBORzQfjJQ=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=I4P/LG7tkJ62TA4BzqdV5EF2UiWWFowy2id1mu3WJfGMqtDHJ6CGzB8xg+DjTBfUx
	 inXNM5WQe+V6D/jPCfVPl5ILLXQmTIvGFx7hID3c3XT0BADAKicUNCVfheKbTczbIO
	 PNUBpb7TiNv2hz623mQEGrU/zjTtAYPUpdK92zUChqA95lVwllzBAU1v3PQF0m6AQF
	 ZVRQsq7Kkd6RDCTPyeveaeOH5V+cbiUsiroG5VGU+W4cC6SCy6h56gPq5H13IRsEbH
	 WQHZT2zVf+Q0Fba+E9f4kuYAcfqp6jTvQRUrlABUY3UojE7mOJN52qYH7cGQ+pdlgW
	 qac9vM6Gv/JKw==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a337552604so954100e87.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 07:19:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/i7OO39KhYJ1hTrXtbdJEjKQi2Bj/Zu1ODvJFFugMCnDK3ROEqGuOi75/Be6xBDaFriln6jla1TW3wFWh5sw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxqc9uLZcJw8mjYdi8eKPWJeCkbOCXQL6CKQffVrzD31RltgYk
	XiZNKrfNAvscfEcGy1wUsxz88LENz+1mTv8T3mRHRwukuBpm+R9wbVLES4fGEJsnV6b81mFZqNe
	6aLZNrC3/Vj41UBDgZa9asq6zEf6RjugHz12Q0vexWA==
X-Received: by 2002:a05:6512:2385:b0:5a4:18cb:884e with SMTP id
 2adb3069b0e04-5a8522d7f89mr1123970e87.26.1777558760093; Thu, 30 Apr 2026
 07:19:20 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Apr 2026 14:19:19 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Apr 2026 14:19:18 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260430081242.3686993-4-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430081242.3686993-1-arnd@kernel.org> <20260430081242.3686993-4-arnd@kernel.org>
Date: Thu, 30 Apr 2026 14:19:18 +0000
X-Gmail-Original-Message-ID: <CAMRc=MeYOxDdpS=AEMX7ChHcPTOsz1+DxuSNcNtV4PwOagwyUw@mail.gmail.com>
X-Gm-Features: AVHnY4IpV9J_wm_g1EdQYCGOE-gGqU5pWdF_TAuz210HOf5B8hJhqLIEur523_Q
Message-ID: <CAMRc=MeYOxDdpS=AEMX7ChHcPTOsz1+DxuSNcNtV4PwOagwyUw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3 omap] ARM: dts: omap2: add stlc4560 spi-wireless node
To: Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Bartosz Golaszewski <brgl@kernel.org>, 
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Felipe Balbi <balbi@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Johannes Berg <johannes@sipsolutions.net>, Kevin Hilman <khilman@baylibre.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Linus Walleij <linusw@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Rob Herring <robh+dt@kernel.org>, Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org, 
	Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Apr 2026 10:12:42 +0200, Arnd Bergmann <arnd@kernel.org> said:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Converted from the platform_device creation in board-n8x0.c.
>
> Link: https://lore.kernel.org/all/20230314163201.955689-1-arnd@kernel.org/
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
