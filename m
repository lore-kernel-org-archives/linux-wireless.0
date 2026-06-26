Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E937C935;
	Fri, 26 Jun 2026 10:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782470880; cv=none; b=sWRwQ2Lm32UCUhpU+juQzB4ieVVshWpU0SdbV8yVjoUtJ4/ydWqfxVzVfjLk+Wbm1+yRyiyeQaheBu88mVwyG7lG+JXBHK4XKtV5vB/1mKKzYBsmlTz5EoZ4c3xz0xbodaZp7ArDAcQc249RdkujobZnSiaTEmNnG0GPOdG2vag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782470880; c=relaxed/simple;
	bh=vP2IdaVPbSZOk1XpzpIw7n5ZLCjv5/AMwDD8kEjAC3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwUQ1BuHAVwruyRTMzVUYCJcNJbS74/IIL44/5aFhtCBjKfr3TqM9/cFBEp/O0oFjxYVBwvDhkT3AKJoJ3HDeQ12+XqilAKmvxYsnhCokWuamUYqueM20NeDtQ/VvEQSnVcRwge0U3iBlGuMAR+8SHrWgHWquQxFS782G6dAGMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY082PXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY082PXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BC21F000E9;
	Fri, 26 Jun 2026 10:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782470878;
	bh=VYo3Ganq+WzA7X6u0ccLN2QJdHrunNuBmjyvihQ9bgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fY082PXTc0XtaGqK1Hxo1xcbFPGuQTOnC+RsZjw9yja3eyqFAenyPMbvFNEemsn5Z
	 w4gKJn3LogYURADXofWVfPjE+SzX1pyCBgzJEmkoc8aSozQ2j1SEfTFh8c0E0RhEag
	 S/NsbXu+SpGb9H7LHESpq2ypWE5GeJHm6mONXHpXrZHfQEyZhUJLyNbCpZiUDfQMWV
	 BwyueZHKfzhPI/qfKkfCXxm65Cp8zd69hD+Sf71y9NcZQunQzK9BXCDYV+sHXh+BLT
	 WB+Xtgy1DyNTyNYjapjabA5G06SQ6AzSfqc4IDSCfwhh4mFAet8c1DA7SUgSWrcn/q
	 taKGxC0Cj0RCw==
Date: Fri, 26 Jun 2026 12:47:54 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: George Moussalem <george.moussalem@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Saravana Kannan <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH 1/6] dt-bindings: remoteproc: document M0 Bluetooth
 Subsystem secure PIL
Message-ID: <20260626-tiny-warm-jerboa-3ba57a@quoll>
References: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
 <20260625-ipq5018-bluetooth-v1-1-d999be0e04f7@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260625-ipq5018-bluetooth-v1-1-d999be0e04f7@outlook.com>

On Thu, Jun 25, 2026 at 06:10:05PM +0400, George Moussalem wrote:
> Document the M0 Bluetooth Subsystem remote processor core found in the
> Qualcomm IPQ5018 SoC. Firmware loaded is authenticated via TrustZone.
> The firmware running on the M0 core provides bluetooth functionality.
> 
> Signed-off-by: George Moussalem <george.moussalem@outlook.com>
> ---
>  .../bindings/remoteproc/qcom,m0-btss-pil.yaml      | 72 ++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml
> new file mode 100644
> index 000000000000..397bb6815d71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml

Use compatible as filename.

> @@ -0,0 +1,72 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/remoteproc/qcom,m0-btss-pil.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm M0 BTSS Peripheral Image Loader
> +
> +maintainers:
> +  - George Moussalem <george.moussalem@outlook.com>
> +
> +description:
> +  Qualcomm M0 BTSS Peripheral Secure Image Loader loads firmware and powers up
> +  the M0 BTSS remote processor core on the Qualcomm IPQ5018 SoC.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - qcom,ipq5018-btss-pil
> +
> +  firmware-name:
> +    maxItems: 1
> +    description: Firmware name for the M0 Bluetooth Subsystem core

You can drop description, pretty obvious.

> +
> +  clocks:
> +    items:
> +      - description: M0 BTSS low power oscillator clock
> +
> +  clock-names:
> +    items:
> +      - const: btss_lpo_clk

Just "lpo"

> +
> +  memory-region:
> +    items:
> +      - description: M0 BTSS reserved memory carveout
> +
> +  resets:
> +    items:
> +      - description: M0 BTSS reset
> +
> +  reset-names:
> +    items:
> +      - const: btss_reset

Drop names. Using block name as input name is not really useful.

No supplies? no address space? How do you actually trigger remoteproc
startup?

> +
> +required:
> +  - compatible
> +  - firmware-name
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +  - memory-region
> +
> +additionalProperties: false

Best regards,
Krzysztof

