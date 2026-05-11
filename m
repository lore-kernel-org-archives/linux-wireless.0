Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BB372675
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499063; cv=none; b=toij2R9JYAitRhkg9yZbdBDMXC6ccZIoUGbSHf27TQOVdtddN2SV+djnA+DLjQBGrdyxlJs02KOT2ukf7TimFDX9YC9exRvimJuo0dgSEyPY9Q77bcbqOwt8pxaJ1uUPfxylG2JjFEW+ffMcBOWOQ9l8kV/gGtQC225k+y3ulMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499063; c=relaxed/simple;
	bh=EKKfwmDWueuzuiwLmDiqHwAUuKDTiRg25fPDMxAtu3I=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVfqOl9hpy0o/l8VI4qiG6nZ8slEM+EN6SLf+bmtGwlnSHjY47OXlgDBT//whivKkxFm4Iu3GZYxOEbn7TVM41AsZpc2H0KavSymtgGGux29PCNYySdShENi2LhBo2+fd3grNIscV5JojfPj4fK4zoKcuEayswi3I53+T+/gsCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ndaf6Okb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ndaf6Okb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F58C4AF0C
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778499063;
	bh=EKKfwmDWueuzuiwLmDiqHwAUuKDTiRg25fPDMxAtu3I=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=Ndaf6Okb8sk0A8O7VL3aBsk0ONkOoBV714yHk6/dZQl1jlV/1eKAE9dRNOp9cBaRE
	 oSicQNFzSi63gMWcQjyBj7ALHHOsKMQNy/DkmJBrk84C5kXsKd4iHdpoMiDNfEQR6m
	 9T5ynO9CX+A67VySvl/YM891b+6++c0Cz3sDZc2ZZ/O8tbjI0h4kiBTJofBhkZuFvx
	 zJcCXgj7y+afgvWRIKGS7D34JC29RgLIPoVv5TTP7rW6QNTfotzWaeBj8zkdteLjUN
	 OegFcEWhkCYBg0KEZ6qCvAuruUlzQgbG7d19IO11CR5mBfMdoLVWiN/nAhSW1Q2TJ3
	 eS3xMcJM1t8hw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a860667fabso3769075e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 04:31:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Yvz0h2Onl5arQbAObda+Zr/CZeL9jHanOlVAgwgC5VupHglCqQQgk0SXa1ZauLzDn2QNCVk7CVqyilk3ywg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAq6q/DRsNKwJJKLuKBi9ioVFMDn8CONuSvOBUjPASRdGHOGkJ
	I6XR+sFR1lFuPs4+PtQo8KYecsHeqImuwCMch8x9QODbqAHTOxz1WTa+LV1xIf9IBtfDEgxJa19
	cSXAwJgRPVokPjB525mPDHD7B0rGy2r/an2jCBSyiuw==
X-Received: by 2002:a05:6512:8013:20b0:5a8:9909:50a3 with SMTP id
 2adb3069b0e04-5a8a94c1fc3mr3003771e87.32.1778499061711; Mon, 11 May 2026
 04:31:01 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:31:00 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:30:59 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260507212451.3333185-3-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507212451.3333185-1-arnd@kernel.org> <20260507212451.3333185-3-arnd@kernel.org>
Date: Mon, 11 May 2026 04:30:59 -0700
X-Gmail-Original-Message-ID: <CAMRc=McjwW-LfB8+jAF7zGkThCzSWgWWbgRR8_4UFCZLGjrGGA@mail.gmail.com>
X-Gm-Features: AVHnY4JxFqpXMEt4_ocDaPjTOBgIpI7Eah18wC4y2ej7QetMh_kqZpgwKUVhjKE
Message-ID: <CAMRc=McjwW-LfB8+jAF7zGkThCzSWgWWbgRR8_4UFCZLGjrGGA@mail.gmail.com>
Subject: Re: [PATCH 2/3] [v5 net-next] p54spi: convert to devicetree
To: Arnd Bergmann <arnd@kernel.org>
Cc: netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Aaro Koskinen <aaro.koskinen@iki.fi>, Andreas Kemnade <andreas@kemnade.info>, 
	Bartosz Golaszewski <brgl@kernel.org>, =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Felipe Balbi <balbi@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Johannes Berg <johannes@sipsolutions.net>, Kevin Hilman <khilman@baylibre.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Linus Walleij <linusw@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Rob Herring <robh+dt@kernel.org>, Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org, 
	Christian Lamparter <chunkeey@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 7 May 2026 23:24:50 +0200, Arnd Bergmann <arnd@kernel.org> said:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The Prism54 SPI driver hardcodes GPIO numbers and expects users to
> pass them as module parameters, apparently a relic from its life as a
> staging driver. This works because there is only one user, the Nokia
> N8x0 tablet.
>
> Convert this to the gpio descriptor interface and DT based probing
> to improve this and simplify the code at the same time.
>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Reviewed-by: Linus Walleij <linusw@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
