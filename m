Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6479146A66
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 08:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787991667; cv=none; b=hnyCV+PdUk3/jJor9G/Myaz11+fErEOZHL8RwPMLu1vvxgXRjisOWCpgEME8K+GpkM/0VLFVTilv75vE52UF1zcpt7WWszz0CEOkZWPP8gku7S04A5AzGdt3gwaZnnHulxLZCzSDJAg7lfTPm/MsyyejyGkezaUyCYZ/ndjfGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787991667; c=relaxed/simple;
	bh=vGemPxKDNj/wjYZfMuagHyEPucRqUdfWCMsNPqSi4iE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OzFAySl6gyaz8txOEcSxDJ1OiM1aQI+7e5W0gkkeoCfg77t30HGdSGv2CMd61k/d+QVcOmrxm/bVoLrbWMo2AYTjmGd5GjBQfZWR8IvSvKTXb83cO3BxO3t/a7PM2JS9EovC7EdohjSgYM6TkQVW+HQ69xPhuWWK8EbwxaNkdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6caTQ0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6caTQ0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B18D1F000E9;
	Sat, 29 Aug 2026 08:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787991666;
	bh=MjqsRucL+ZlgfIXuQ7jtPEXCiwTpSV53H3GDO+WKlRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z6caTQ0stGPA6Yo8AFfyZ8sRLcTFyyJsa6DlUEHCD0XMu7idmfDlFXa5GnTcR4pua
	 7nsgN9Z5sFnHiwc1Tyco9fau8iklX9jQr08aVCTyAvEEWGHwfzsgcasbE9r4JFb9f5
	 WndQh8NK7osh0RV+teLyjNwcn/zrLwM0UP9OTNbMqXeKsgZ/0dUgJ/A3S8YE6UOJij
	 kacGK64CZDFqT1EQq3/FKDfHruRDCKsNQaqqYrxeM+4Qf58mlaW1hX+gamW8i08pYb
	 aYN5le0a3JqJtrw49TanWMI//AhRp1owV5HJLOzs24ls4GtWBnT2KUBDnmfJu1dIPL
	 LaYexNkDBezsQ==
Message-ID: <229f5d99-4aae-4f51-baee-37794c2236dc@kernel.org>
Date: Sat, 29 Aug 2026 10:21:00 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH wireless-next v3 3/4] wifi: aic: add FullMAC WLAN
 driver
To: Yanli Yang <yanli.yang@bedmex.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Zhirun Liu <zhirunliu@aicsemi.com>,
 Dijia Xu <dijiaxu@aicsemi.com>, Chunqiu Liu <chunqiuliu@aicsemi.com>,
 Liheng Wei <liheng.wei@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
 <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
 <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
 <cover.1787903339.git.yanli.yang@bedmex.com>
 <f22a875eefa398eea9fc80bff1468dfacc47c683.1787903339.git.yanli.yang@bedmex.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <f22a875eefa398eea9fc80bff1468dfacc47c683.1787903339.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/08/2026 14:11, Yanli Yang wrote:
> +
> +#ifndef CONFIG_PLATFORM_EXTERNAL
> +#ifdef CONFIG_GPIO_WAKEUP
> +static int wakeup_enable;
> +static u32 hostwake_irq_num;
> +#endif
> +#endif
> +

What?

> +/* debug trace */
> +// static struct wakeup_source *ws_rx_sdio;
> +// static struct wakeup_source *ws_sdio_pwrctrl;
> +// static struct wakeup_source *ws_tx_sdio;
> +#ifdef CONFIG_GPIO_WAKEUP
> +// static struct wakeup_source *ws;
> +#endif
> +
> +#ifdef CONFIG_PLATFORM_EXTERNAL

NAK, there is no such CONFIG symbol.

> +
> +#define ENTER() (pr_info("AICWF enter %s\n", __func__))
> +#define LEAVE() (pr_info("AICWF exit %s\n", __func__))


No. You cannot re-implement tracing. Drop this from EVERYWHERE.

> +
> +int regist_wakeup_irq(struct aic_sdio_dev *sdiodev)
> +{
> +	int ret = -EINVAL;
> +	struct device *dev = sdiodev->dev;
> +	struct device_node *node;
> +
> +	ENTER();
> +
> +	node = of_find_compatible_node(NULL, NULL, "aic,wifi-wake-host");

Undocumented ABI. Would not be accepted anyway.



> +	if (!node)
> +		goto err_exit;
> 
This driver does not look like upstream code at all. You should clean it
up before you post next v4.

Best regards,
Krzysztof
