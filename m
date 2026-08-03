Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7352B328B7F;
	Mon,  3 Aug 2026 20:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785790409; cv=none; b=pa4NkaWIWyXJQWwGzokLYGUoMHgjQwBsUM47ybrwQL9n5LyALCwIW0UZ66YQRpsY146Gbk5QQBqtIzcqwivSSJdD6Q7mRLLlbEE5T2Q7OMs3MQ+HyaItzKk2qffatFn3Tob+SBL71NMSp+4EpLGJXBotCAss+HMdopzTzY8Gv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785790409; c=relaxed/simple;
	bh=MDzfBwhETVtZ+aaDo4ix5KcYZIh3rn9zmcx1yyWNTp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fw1Z5Wg3z9t7SwTc1HP9s0Y+Ux2UVmhUK6TfXJ+t3WOKUioF4D/x91yP+YyhX0Xtbe89K3noFAAVYxeFLkuC9XRubZLUjOYyZqjgRhu4QQuPep6eP/+dx1svGbvYJVZTZ5vh0lhXgHZSHlLPT/UPw0V68my+lVxpzloLxglZ8B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcECJy5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcECJy5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3681F00A3A;
	Mon,  3 Aug 2026 20:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785790408;
	bh=42fMjfMmyKoxIac5xGfUWe0H4Hd5p40u1U7vZae7AME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcECJy5zwe3it57uD+HxHZblPLjWVcBNQ4VhRCHd+jKDvO2jXi+m1kaTmRCsRRtg2
	 QZv+SCD+KsaR3eZlvT0BW/ID679n01MbA83TiXwbEoW1L+W3NZwEyTU1zQpKDvOGCE
	 urFSI4Joboi6Hyiq5c2YqJ6nXTowsFtdF/4P6kZgUHmg/GSO7B+hNn4Hqlen68o8R/
	 q9bBSdE7BE92kMkNHFWafNdaz3b4KDwLwEOSwwtD5f8211u/yLgB7/tTHtKXWQzNHT
	 MQg75JSK1wxMkLL4SVfp7mSe+XGv74BCfS570fKjbcvIODC2S4wXYzjPPjvkQ2o8Q3
	 bLV42DdnxLicQ==
Date: Mon, 3 Aug 2026 22:53:24 +0200
From: Andi Shyti <andi.shyti@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@arm.com>, 
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Niklas Cassel <cassel@kernel.org>, Jyri Sarha <jyri.sarha@iki.fi>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Linus Walleij <linusw@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Patrice Chotard <patrice.chotard@foss.st.com>, 
	Jassi Brar <jassisinghbrar@gmail.com>, Lee Jones <lee@kernel.org>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Yangbo Lu <yangbo.lu@nxp.com>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Richard Cochran <richardcochran@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>, 
	YC Hung <yc.hung@mediatek.com>, Svyatoslav Ryhel <clamor95@gmail.com>, 
	Sean Wang <sean.wang@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, coresight@lists.linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org, 
	mfd@lists.linux.dev, linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-pm@vger.kernel.org, netdev@vger.kernel.org, linux-pwm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Correct white-space style
Message-ID: <anD_bci501e0J3q2@zenone.zhora.eu>
References: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>

Hi Krzysztof,

On Sat, Aug 01, 2026 at 09:56:14PM +0200, Krzysztof Kozlowski wrote:
> Correct a few white-space issues, like double space after '=' or before
> bracket '{' characters, which will be flagged by dt-check-style.  No
> functional changes.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> ---
> 
> Patch applies on Rob's for-next branch.
> ---
>  .../arm/firmware/linaro,optee-tz.yaml         |  8 +-
>  .../devicetree/bindings/arm/psci.yaml         | 18 ++--
>  .../bindings/arm/qcom,coresight-tnoc.yaml     |  2 +-
>  .../devicetree/bindings/ata/st,ahci.yaml      | 22 ++---
>  .../bindings/display/ti/ti,am65x-dss.yaml     | 12 +--
>  .../bindings/display/ti/ti,j721e-dss.yaml     | 96 +++++++++----------
>  .../bindings/display/ti/ti,k2g-dss.yaml       | 36 +++----
>  .../bindings/dsp/mediatek,mt8195-dsp.yaml     |  2 +-
>  .../bindings/gpio/st,nomadik-gpio.yaml        |  2 +-
>  .../devicetree/bindings/i2c/st,sti-i2c.yaml   |  2 +-

Yes, I had noticed this recent white space which slipped off my
review, but it looked too much hassle for a single patch removing
the white space.

Thanks!

Acked-by: Andi Shyti <andi.shyti@kernel.org>

Andi
