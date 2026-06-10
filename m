Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A329BDBF;
	Wed, 10 Jun 2026 07:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075794; cv=none; b=Z5uR95V4zeM7uxKifoeHL2ZwxcyLAbGnq5JW4mmZfVgGoNUVJog6elSxZdhjxI5rnaIhPRut5QgIzTuuOCYVKPdKTQH6y9uglasWAeAnSYiLuTD7NxF2DehxCzs7EMNJBl0phJmODMGIPm+X7d/SCczfvmKS8HCRHnZX/jMuzo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075794; c=relaxed/simple;
	bh=IKSvTWxUBmjeVnmCYv6+YZYdwIrH5X0fWcQqB93TaLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l74r0pDxocGYUH4yEG0+qFsHemgDu/qje9L5oVc6rWCVO6gu2KocX+YpENy62wXA3B0iFTRG3y4chl5IiGFgVVTIQUnVeDcPCTRcHzWz+hhIRI3Wm8sc3c3pMNvgGt0ZR3LkYPaeS6uQzlwBpgJi8jecVwg5rtAsHZ+ZMGx5mvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEh5J4MY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEh5J4MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4511F00893;
	Wed, 10 Jun 2026 07:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781075793;
	bh=f3pyLsJp/Pig7PJGNaXCWFzykMjoyznELiFBpvDKD50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kEh5J4MYt6AOcTW92yTfwHs7vsfXTGiCqD9ezn/PNbI3JWrXg4/8tr03WT6qdTNpS
	 PAtYXXZDgPka9aZwUbI+DBa6wtCiTAIsQGRmXXaBPgcpzA28huYukZQXWGyz0yvVIW
	 MJU9oHaPP9viU8aSsW6rlLH6xGNGZACpXj7MiV0FtCcymsGKjvyVqZD18HVrh5Eb9c
	 H0by8hO8bDMIkvcQuscIdnJgzExUBtpjrNV0ge9SvQmhZMxLrkH1RoKe2C0aYinjXB
	 BQpQmxWyxvNkGUNbqj0qSQ3R2MiTBOBLx5T2FPGE5kaSM8Ii3Iz+GHR5Vp3Kh5qxah
	 rslGwKgr5JbDw==
Date: Wed, 10 Jun 2026 09:16:29 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Saravana Kannan <saravanak@kernel.org>, linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
	netdev@vger.kernel.org, daniel@makrotopia.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/8] dt-bindings: net: wireless: qcom,ath10k: Document
 NVMEM cells
Message-ID: <20260610-funny-paper-warthog-25fa0a@quoll>
References: <20260609-block-as-nvmem-v4-0-45712e6b22c6@oss.qualcomm.com>
 <20260609-block-as-nvmem-v4-2-45712e6b22c6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260609-block-as-nvmem-v4-2-45712e6b22c6@oss.qualcomm.com>

On Tue, Jun 09, 2026 at 09:52:27AM +0200, Loic Poulain wrote:
> Document the NVMEM cells supported by the ath10k driver, the
> mac-address, pre-calibration data, and calibration data.
> 
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.yaml    | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> index c21d66c7cd558ab792524be9afec8b79272d1c87..7391df5e7071e626af4c64b9919d48c41ac09f1e 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> @@ -92,6 +92,22 @@ properties:
>  
>    ieee80211-freq-limit: true
>  
> +  nvmem-cells:
> +    minItems: 1
> +    maxItems: 3
> +    description: |

If there is going to be resend:
Do not need '|' unless you need to preserve formatting.

> +      References to nvmem cells for MAC address and/or calibration data.
> +      Supported cell names are mac-address, calibration, and pre-calibration.
> +
> +  nvmem-cell-names:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      enum:
> +        - mac-address
> +        - calibration
> +        - pre-calibration

This means you expect random order with variable number of items. Is
that intentional? If yes, please provide short explanation in the commit
msg.

Best regards,
Krzysztof

