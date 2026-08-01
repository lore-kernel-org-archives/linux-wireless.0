Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006902F3614;
	Sat,  1 Aug 2026 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785618946; cv=none; b=m+bQ2qT2bNrt/wtdcsrRsYXwJOMZKQN+/wwUV4ul/UmIkjsIrZjxSe+LJcd/NSoU4LrWuNLiUzBQj19SrKBkWdmrTdPWgOfTpEEudSfQ+xhH4utaIeIEKQDxzg/pzn+qj4Eujh5tVWdB27SJOiGnaOW7ms1BXy0lddvveGio8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785618946; c=relaxed/simple;
	bh=yw+MLqi6kPElwJpEjcpjKLSULkrOxxXPtHNEfOiqU90=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aDdUGcwU73c6xUwTAEk0ZHP0RkC/8990AoYSmFBu0aTx2jJUntQKyPPg4GxQkacfe2F7W9OtaPqT6lsn/YiY8ouYqZr2dtGAtIrSWCK2D2EKEwK0a+VGol3v00mLhJEBEi17/TZVY5km8uvdDfr8EKARfqyS+dcFcVxqSVof5CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iu2suDeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iu2suDeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1621F00AC4;
	Sat,  1 Aug 2026 21:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785618944;
	bh=ALbadrPlzW4YdLs9fKrKevLx7dPEsNFJd83WcTvC4co=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=iu2suDeRu/dT8WnlAiU+FK9hRedcQZ3iPHg2hYKJN80fk09m4XzYI9nVyPNEaqZxa
	 REtFtLP5uBVTM+EjII/Pq2mthEdWYqGKeYz9v18FgcbvdJOyzkV3dO7ahaaJsaneZo
	 Nj/lmFrmw2GUo3yDwd4GcPvXOPAIaYWm1+JE387Q1t17HQeh+thY7ma+gtsatcMRSW
	 fxImTGZJ9SmQAxQNHKBBgGEZfmaq1RkbFe6VWm2eskesrtnAAqVi8GKAMpnMrGrin3
	 HZmaSHy271wjIwRn71y/FeeZXnOA3FtU2qpJbZpU43UWLquFFKChIveXiKBHXb9WCD
	 nOCOrht2bkZ2g==
Message-ID: <4b763098-a91e-46f0-88c9-d08670d31328@kernel.org>
Date: Sat, 1 Aug 2026 14:15:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: Correct white-space style
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@arm.com>,
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Jyri Sarha <jyri.sarha@iki.fi>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
 Patrice Chotard <patrice.chotard@foss.st.com>,
 Andi Shyti <andi.shyti@kernel.org>, Jassi Brar <jassisinghbrar@gmail.com>,
 Lee Jones <lee@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Jeff Johnson <jjohnson@kernel.org>, Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
 Yangbo Lu <yangbo.lu@nxp.com>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <ukleinek@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Jens Wiklander <jenswi@kernel.org>,
 Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>,
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
References: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
From: Jeff Johnson <jjohnson@kernel.org>
Content-Language: en-US
In-Reply-To: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/2026 12:56 PM, Krzysztof Kozlowski wrote:
> Correct a few white-space issues, like double space after '=' or before
> bracket '{' characters, which will be flagged by dt-check-style.  No
> functional changes.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> ---
>  .../bindings/net/wireless/qcom,ath10k.yaml    | 34 +++----

Acked-by: Jeff Johnson <jjohnson@kernel.org> # qcom,ath10k.yaml


