Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D42C11E2;
	Sun,  2 Aug 2026 06:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785653272; cv=none; b=R86eid5v03E5D6iXfQtnKtWKDH3L8pl3LreihdktbCd9KoiVhwR+cNqSsSZtm/QxBDk7UqikLLQGpr5P8Nv2N8TovDQMF4u3wNdgUO9VBja/uxjHmxIotmguLwVKJFtZb8pucLtegfW5bftIrPD4+3+7ZLVZtvhHhA7dhXk9x4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785653272; c=relaxed/simple;
	bh=SBQRFcrBpdAwXQXYx355w+v2AgYgQvanSpIEWH+ofl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KE8noeOpRw8BAmv88oRNA8h/OjYltljvHq92+OeUrn6mDTSyAhqaCjMvK4C/itbLXpwnkdfmLPh7S2ry/rPFGLCbFM0HnfSwWi7Ys6h6iqEKYEJhPiKi1c7IvKJ69YAxLH261SXNbLuvYL7Qoj53K+YQa/kIeOQzoWYkbP7t18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBg5ydY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBg5ydY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9D01F00AC4;
	Sun,  2 Aug 2026 06:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785653269;
	bh=d4tzf5OI2ty69S9e+u6dfdqhLKOYD2qDn1wkoiLc5Qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zBg5ydY1wX1rbPEx6zS4lr2WPZ2W6TAE2n5W74eqj8OznJjLOyuRL1cJ+Jk8PQPsA
	 z0ip5R0D3rD1ro6ziNgVNsWEcoSkdYcjRlOW4oa2+Nqe2M7xo/UVBitf0P1zVriEga
	 qrpPscuLwxtITkywEZWzQZNwwNUaHE++BFIW/LqM=
Date: Sun, 2 Aug 2026 08:46:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Jyri Sarha <jyri.sarha@iki.fi>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>, Lee Jones <lee@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jjohnson@kernel.org>,
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
	Stephen Boyd <sboyd@kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>,
	YC Hung <yc.hung@mediatek.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sean Wang <sean.wang@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, coresight@lists.linaro.org,
	linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org,
	linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	mfd@lists.linux.dev, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, linux-pm@vger.kernel.org,
	netdev@vger.kernel.org, linux-pwm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Correct white-space style
Message-ID: <2026080211-marauding-twerp-1f8f@gregkh>
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
>  .../bindings/mailbox/st,sti-mailbox.yaml      |  2 +-
>  .../bindings/mfd/maxim,max77620.yaml          |  2 +-
>  .../bindings/net/wireless/qcom,ath10k.yaml    | 34 +++----
>  .../devicetree/bindings/opp/opp-v2.yaml       | 28 +++---
>  .../pinctrl/mediatek,mt7988-pinctrl.yaml      |  2 +-
>  .../devicetree/bindings/ptp/fsl,ptp.yaml      | 12 +--
>  .../devicetree/bindings/pwm/pwm-sifive.yaml   |  2 +-
>  .../bindings/usb/ti,twl4030-usb.yaml          |  2 +-
>  18 files changed, 142 insertions(+), 142 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
