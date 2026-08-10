Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3253E3BED30
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786361171; cv=none; b=qN8gbC1K/RIQLLd1vsGlSGHeODGTJUAa6vDS+HH/EDaOosMldNoACzsFOdBv5Sf3rMTzZx/kkMVNMes9omqVYbWlUi7aTIrtaZDEwDHPpV9pd9Ugo4gMf8aqR+E5CBg08Tl4HwTOxn71hwDhb/fQv6+V3llsnlUf7q8uwkMcj7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786361171; c=relaxed/simple;
	bh=QwVAnHRHiCemIeYxsEaRGiTsru4MY7geYHkt3gj+mPE=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQP2sWCyrvYlQe3acLA4IggtmDfzQ9sz/UU/WFT9XlALh+miE5+JMaJG7TT783w1OssHMmDYbjS3FDFwbcjbMGG7L5Am70WnIIAcW+IrbFTNWXVPFqlIwUy724UtoJEeAcVCLtF809jfUmbIh2I2beRd5OBnzckdfGfArp6wG5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMYGiQiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMYGiQiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E072D1F00A3E
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361169;
	bh=wZoyj/bcYqq2WaFoOPNolBM0q0on9gdK76aAsSvObhU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=TMYGiQiVyWdja3666tnZyi5AUbCLb4zbspLWjOIyDSld4bkZaB32jXvzVJ7y80nGE
	 bVdpTc4xyAyY5YkfK5HDTntoQwjnWA4qQQWhDeEqkzZZX5CROFNQ49SD0wQMAqpEcS
	 9DJKJ++Z8zhB9f1Wjs2x6/baRiIxyHJu9d++5Qv3KHKdIxWLIJ2mvLNfBRoiQntJ89
	 QgVzjtB2wMbEMcbgaAM1oDDDJWeHAFSRjxDNO+rMpBWAf6ZX5hHObx4k3el+FYth8s
	 NJe07b67fdpivNIpoH/OOSuxYErtLXYeg4QE/sCkYlILbJmWzAVROEJnKyim6UydhL
	 Oc0Tvomcx/orQ==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so1638579e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:26:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RplaIP6hDioQd06GZebnFVtWxFcqw3Zzu6lTfP36WBVSOWupKfW5yoDEQS4I8enlZRKGR0kqf9oJFG5KZ9vJw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi69dY1FY++0T6GryreJKrAF7yJnyrUFJM/2jYtIb/cQm6M3NE
	qrOTzSD1SOtYeiXhxD4ipz7OeehDTE5ldYcTeQ80bMzJdBa2cRjA9qEwLEmCXHqfwpZcnyWzafn
	ORnp40tDNU2jQPouGLnKfQU5coFAVO8dNNBA6E4OdUg==
X-Received: by 2002:ac2:4d18:0:b0:5b0:1b0f:7a60 with SMTP id
 2adb3069b0e04-5b2f4cc8da0mr3704106e87.32.1786361168649; Mon, 10 Aug 2026
 04:26:08 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 06:26:07 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 06:26:07 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 06:26:07 -0500
X-Gmail-Original-Message-ID: <CAMRc=MeiXHL-1i31q-+wuibK5qM1=xV+4qn0z+CWFXjt3CdrCQ@mail.gmail.com>
X-Gm-Features: AUfX_myd-9E67e5jDYYEWIDd_Fhka4yTI8ar0CZ3ucq5EUGNAu2R2AhAZ0we-FI
Message-ID: <CAMRc=MeiXHL-1i31q-+wuibK5qM1=xV+4qn0z+CWFXjt3CdrCQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Correct white-space style
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mike Leach <mike.leach@arm.com>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, Jyri Sarha <jyri.sarha@iki.fi>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Linus Walleij <linusw@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Patrice Chotard <patrice.chotard@foss.st.com>, 
	Andi Shyti <andi.shyti@kernel.org>, Jassi Brar <jassisinghbrar@gmail.com>, 
	Lee Jones <lee@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Richard Cochran <richardcochran@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>, 
	YC Hung <yc.hung@mediatek.com>, Svyatoslav Ryhel <clamor95@gmail.com>, 
	Sean Wang <sean.wang@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	coresight@lists.linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org, 
	linux-i2c@vger.kernel.org, mfd@lists.linux.dev, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-pm@vger.kernel.org, netdev@vger.kernel.org, linux-pwm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 1 Aug 2026 21:56:14 +0200, Krzysztof Kozlowski
<krzysztof.kozlowski@oss.qualcomm.com> said:
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
>

For GPIO:

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
