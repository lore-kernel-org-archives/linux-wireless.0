Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF89459AD2;
	Mon, 21 Sep 2026 09:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982881; cv=none; b=DTLLpMS0WgIr+/Vg0WRxASAiv3tZxz1UQ8CJMcmvEBm0HDhvwrabpRBPzXpuU+qV56pwfFDGWM0pSVYfvYsekDh44IwZXiqi6ZWkKSVcnZ4mrMfftpVfVFrVabzFDXhf9Rq0D1xq0oDUcTFIEToOu+7KLtkC6F09R0vYsDdruGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982881; c=relaxed/simple;
	bh=mWkBj2vDftGwRUgbR90kZl2tiuVkAriqXm87VBPrK5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSboadbWDOS4dHftxDjhy5ola/pPNGBgaxyaEmxjRPXpDJHLEQRk/Ltdq+9mUbJMX7G6y5pl/sbQBaA/NFCcj9sRskQJlQoXMYqFd/T+aeMkS5Ff9DuV7G2FbUOKtkAPY5R7K7tjepTf4Wd/EmrhdKjhkRnHdROAYUeolZxEb8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUllEETn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUllEETn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351D31F0089A;
	Mon, 21 Sep 2026 09:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982879;
	bh=o76WD5ueuIS8jiqhDq6tTGlPIaeopmRdrnTuiB1O1Jw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FUllEETnTB2JnIVZt3TLVIWq1oKTCl1xomKsGGP0wQYPT+/AE+PrcIA9/ACJjfoGM
	 gJoRrMQ8TVCOFPcf4oj41aXQa/VRfEprHkAbJP9Sc7jzW+Lv57XdulivgW31eMZENp
	 gfhs0x0wnwa4SGs5jdq5/iNTCdy65tdjUx2DEypdchChmERfShYqZ48f0L+nh4Awqr
	 pLFb8p91m+btLZdfx4NsohAz7712TD6VoMXTo4D65p0bSpCRiNgJn7/QW2U5kfshOh
	 EgwcJmXr6mFgYvYkWbzq5h39vRSsCG+k2wkx3mt9j8pqQQlyK9kmAgvi1VOHeZNbhK
	 Z3EWpbU62nWqA==
Message-ID: <94b19730-b08e-4495-8233-71fe21a6d42f@kernel.org>
Date: Mon, 21 Sep 2026 10:27:47 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/10] nvmem: layouts: Support fixed-layout as the
 nvmem device node itself
To: Loic Poulain <loic.poulain@oss.qualcomm.com>,
 Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson
 <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
 Rocky Liao <quic_rjliao@quicinc.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Srinivas Kandagatla <srini@kernel.org>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Saravana Kannan
 <saravanak@kernel.org>, Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
 netdev@vger.kernel.org, daniel@makrotopia.org,
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
 <20260806-block-as-nvmem-v10-4-be598b2a5606@oss.qualcomm.com>
Content-Language: en-US
From: Srinivas Kandagatla <srini@kernel.org>
In-Reply-To: <20260806-block-as-nvmem-v10-4-be598b2a5606@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/6/26 3:38 PM, Loic Poulain wrote:
> of_nvmem_layout_get_container() only looks for a child node named
> "nvmem-layout" to locate the cell definitions. This does not cover
> providers whose device tree node is itself the fixed-layout container,
> such as an eMMC boot partition block device whose fwnode points directly
> at a "fixed-layout" compatible partitions node.
> 
> When no "nvmem-layout" child is present, fall back to returning the nvmem
> device node itself if it is compatible with "fixed-layout", so that its
> cells are parsed by nvmem_add_cells_from_fixed_layout().
> 
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---
>  drivers/nvmem/layouts.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 

This change looks independent, applied to nvmem-next.

--srini
> diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
> index b90584e1b99eab4217cbe7ec48373e18a7caf0dc..efa631ce7283bdd6c8ecda75915911b5e3a33c99 100644
> --- a/drivers/nvmem/layouts.c
> +++ b/drivers/nvmem/layouts.c
> @@ -167,7 +167,18 @@ static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
>  
>  struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem)
>  {
> -	return of_get_child_by_name(nvmem->dev.of_node, "nvmem-layout");
> +	struct device_node *np;
> +
> +	/* Search for nvmem-layout child */
> +	np = of_get_child_by_name(nvmem->dev.of_node, "nvmem-layout");
> +	if (np)
> +		return np;
> +
> +	/* The nvmem of_node is itself a fixed-layout node */
> +	if (of_device_is_compatible(nvmem->dev.of_node, "fixed-layout"))
> +		return of_node_get(nvmem->dev.of_node);
> +
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(of_nvmem_layout_get_container);
>  
> 

