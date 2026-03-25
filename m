Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7EB401A09;
	Wed, 25 Mar 2026 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774458565; cv=none; b=sLzl6MUEbe5wkKfjT8LSa7fJHsJxSas7CZded5TUhz366+Hyl3ExTqa/YZlmxkShqRxPA0AKgp+WbA//TvgQBX9PMOHzxP9LWPfbj7z9aumGqsIU6gdEedGwoL2T5CmoCWeoKMALzY7Oy7TK43z6qRzftySC8wGLX6iqMteXdsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774458565; c=relaxed/simple;
	bh=JRXYE/U8JS2O1cvWaeN5bQL5zUw+3JhAHGNHnw+1HNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xn4nsfDJfRHKWwEFGMIKAbkz4u72s4xqojniGqeg3F3xbY3twkP8grIljdf19TR7T6gsrVjH+YkwKH3OjwtEeHIyXRPiVZXLcVNYxRhbVF/0KAwZgkTh6zLEXbH8LIib556NsBrdu+nBekbympdyNZ8QwxpG1uh47WlrgM248I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAMXUhuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAMXUhuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3420C4CEF7;
	Wed, 25 Mar 2026 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774458564;
	bh=JRXYE/U8JS2O1cvWaeN5bQL5zUw+3JhAHGNHnw+1HNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZAMXUhuNT66mvS0iWK53vTyXWWeQZT7xKEsQ/XK3vAjbzkwr9WbLA6P6x/N3I0EaG
	 skOFZtbj62dBviBdA7KGsK0nW6Gr5c55tGh6L/Q8AWxoAkyxZfZDriY7+2nt51ZMUd
	 HobEbQSyQ/k2jAoMZT60WQEcCZMB08HZbt8YxKPj8pzSsSiFimuLDPpuWS/+R1Eg7c
	 AKWwpggTDn5i6NIqddsyY/L3khFaMYvki0+HIMCyZm4+foHa6IBbwKsUOOqEZILTqo
	 aC99G0vWquyOnPHf/MJlwEtPsYlotnVoC2DtNg4zTECuE0wYG77oVeRJSC+hK3sXio
	 riWqfCxaKPoLw==
Date: Wed, 25 Mar 2026 12:09:22 -0500
From: Rob Herring <robh@kernel.org>
To: Ronald Claveau <linux-kernel-dev@aliel.fr>
Cc: Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 8/9] dt-bindings: net: wireless: brcm: Add compatible
 for bcm43752
Message-ID: <20260325170922.GA3822305-robh@kernel.org>
References: <20260325-add-emmc-t7-vim4-v4-0-44c7b4a5e459@aliel.fr>
 <20260325-add-emmc-t7-vim4-v4-8-44c7b4a5e459@aliel.fr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-add-emmc-t7-vim4-v4-8-44c7b4a5e459@aliel.fr>

On Wed, Mar 25, 2026 at 10:15:26AM +0100, Ronald Claveau wrote:
> Add bcm43752 compatible with its bcm4329 compatible fallback.
> 
> Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>

Missing Conor's ack.

> ---
>  Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index 3be7576787644..81fd3e37452a6 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> @@ -42,6 +42,7 @@ properties:
>                - brcm,bcm4356-fmac
>                - brcm,bcm4359-fmac
>                - brcm,bcm4366-fmac
> +              - brcm,bcm43752-fmac
>                - cypress,cyw4373-fmac
>                - cypress,cyw43012-fmac
>                - infineon,cyw43439-fmac
> 
> -- 
> 2.49.0
> 
