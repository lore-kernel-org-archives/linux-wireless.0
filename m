Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DFA4E36D6
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562591; cv=none; b=XVQI3L+AHnbPC+gpcq9i31HhMHfcbMZYZrbBZzN9TGd6sij2hLQDtgJm2s/nMkU8gbQTQzcQownJV85Kg7Jbo9esIfnHqyI6tgX0iXIfk9D2LJ3ggmSLvWQx/z+VJ1OgL2jI4q6i6e1d+BYoipJ/R+RcDb+Yct293oz3eA5ZQEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562591; c=relaxed/simple;
	bh=NryF7lIUwcg/DPgBfvmYUAGwQvkFa64lHR7jSLWIz4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUIUfNnaRjjBSCh8CrvA+qeNn1bwsKUJ3QkkZFNxlS0TBSZnPADm5Sc+lXZUHmf0EXPd1D/3wfK8mpnqnKAfYG+Cb0UFQOlgW9kI8OEIshWILnBZSSzUuKImBA7X4y44u/x7ZWhuprJzyrfIpX+zpA9jd8Fh7wZq5klgRgWmtlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPG9B7/b; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPG9B7/b"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so283665e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791562588; x=1792167388; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sxWelmSlH2JHhp90EwkFGP9vd1R+MewtWKi268DULMk=;
        b=kPG9B7/bvubrhi5iE1OyqeQnm6eoFlyq0Li4+bMXzzfEstDPuo9lECnTOJ4Movs2ux
         coC9vI32S8EvN2OZ59AfB2IMl6jPfc30SZcIYLoky52BAUvaJrcb1BW+AZBR+Xxv2Aek
         dmsi6HODDTOxuudDNwD6rbG6yqdvbkyzMREtRgHkumrCea2Po2AZVrNO/LNWP218DKFO
         fLvxX4XL8gogdjJ+vkXQn2egVe7VlEyFgiRAxFijWb/zZxfWG8BYmdyIJAvuer/JlNj5
         nmyrhC+67Iwxebo6qhJZCxqo5L8YbXUBKphA0tYzZIzqHCBNPg7qyeBsM8geckokNxsy
         xJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791562588; x=1792167388;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sxWelmSlH2JHhp90EwkFGP9vd1R+MewtWKi268DULMk=;
        b=kwHZeUAGk0nxoaygO8AFFsXsFiynCbfdE4ox0RU/8sIgZhRMP8BZvnA0yoQRHUCASJ
         Y+d1tGvdoXGfgJyaCVS2mnhYenO8HE4VXUwbWINhl2Dh4GKo88CDE5WxXa/3lAF36/xF
         BD5kcfv7E/gWdcvfGAffXpioSj0gCB72Hly+J6iYWeamrYeshxxkUZNGDk+cL9dYBTn6
         LdqouaBcHIduV2pad45zlLR0N/T06f/m5ez9jpT/8hyUwk2filQGVwry4uIzl7DUZ7aG
         D7psR3itAy9KcU8ioGXqNJT2Q0R2yFRdEbnY556Ei+suMZgQpb9D6f1oevG7ubLKRail
         3MwQ==
X-Forwarded-Encrypted: i=1; AKwUvByj2a+ZUnlhs0S/sNDvKF7uAbSQ4YBT1XF0t12CyrwEbmx7Gj8CWo0UTp0EbPaRAzL2hVygn174Og4f9BKz8A==@vger.kernel.org
X-Gm-Message-State: AFuF++mS1m3Jr/M5OZt8qxYHsje/EUrL1oWkcASb4I2798a4aFw4UPsx
	84mNktRoAcp088pPr7ACbNicZchGye9aHAvJYPUqp2GXaDYXJ7REHIBU
X-Gm-Gg: AYBFou0+tXh5wX6x2KasYnzk0AB2fpbsR9JstIkesiESpnIvueqP+D7YvwT0OYCLo/G
	IKYjAxempdocWKvAsnShqFj81YtW4DZjIc5O69xeFZgvBPGd5QKLhq3LFeBt0LQ7mQxX23hyPiN
	H+Hhf+7kYfPVgiTbf650NrKwG7bf/m7qoxZmqqne/w1H5ko0SaYNlNUE9iHqrpt3D5ZNt/lfw0s
	R5x6Km24ipN4oiWhls0b5SZsm61rFaTEx3GRq1zP7xtZ6vNDdH4lcIF+z+HaqgjEttonNwzMR8A
	tMJm0IdnG28pRj8c1pipCf9qRjI++Yhzd/HnPjZOahVOGo5Ccg7VHjRf/t3pWjWTCGuOF6S0FTS
	L6keWytPRYYm+WdtAogBeIZpOKsrxs+y4WRPpiKAI25sXv9jyFRbUBGr+xH5PVxedlzFy81cPxP
	ZdSSYgbhHrYeMax71Zb4rz6rTwEy+tWEUlweFIMntkAwnKuchJWaq7TxhJYac2+C6EhbdeZt2wh
	b7qGa7VkhjIM84NXIwVBo806i+xjQ==
X-Received: by 2002:a05:600c:3510:b0:4a1:7703:e549 with SMTP id 5b1f17b1804b1-4a18e4c3fe4mr53443415e9.26.1791562586570;
        Fri, 09 Oct 2026 09:16:26 -0700 (PDT)
Received: from [10.147.33.44] ([135.136.51.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18e481993sm52116525e9.2.2026.10.09.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 09:16:25 -0700 (PDT)
Message-ID: <aea18e6a-b831-4336-a647-e87228fc46b1@gmail.com>
Date: Fri, 9 Oct 2026 17:16:18 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: skip hardware rfkill setup on Microsoft
 Surface devices
To: =?UTF-8?Q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>,
 Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Konrad Dybcio
 <konradybcio@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 =?UTF-8?Q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>,
 ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006062728.45007-1-franzelfranzel@gmail.com>
Content-Language: en-US
From: Dale Whinham <daleyo@gmail.com>
In-Reply-To: <20261006062728.45007-1-franzelfranzel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 07:27, François Roux wrote:
> On the Microsoft Surface Pro 11 and Surface Laptop 7 (X1E80100), the
> WCN7850 hardware rfkill input reads as "radio off" and the OS has no
> way to control it. ath12k enables hardware rfkill handling, so Wi-Fi
> stays hard-blocked:
> 
>    iwd: Error bringing interface 4 up: Operation not possible due to RF-kill
> 
> ACPI platforms can opt out through ath12k_acpi_get_disable_rfkill(),
> but DT platforms cannot. A DT property was proposed for this and
> rejected, because it describes what the OS should do rather than the
> hardware. The suggested alternative was to handle these machines in
> the driver until a connector binding can describe a broken rfkill line.
> 
> Add a table of board compatibles and hardware revisions on which
> hardware rfkill is known to be unusable, and skip the rfkill setup
> there. Other affected machines then only need a new table entry.
> 
> Tested on a Surface Pro 11 (microsoft,denali) with next-20260929,
> booted with the unmodified mainline DTB: the interface is no longer
> blocked and connects. The Surface Laptop 7 entries (microsoft,romulus13
> and microsoft,romulus15) are based on reports from Jérôme de Bretagne
> and Dale Whinham. I have not tested them.
> 
> Link: https://lore.kernel.org/all/2ixwny6hzumlqmok5cjwutvtk7nzmx4t3dhxc44ao4l2u755pj@n6m7jyxf2o62/
> Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
> Assisted-by: LLM
> Signed-off-by: François Roux <franzelfranzel@gmail.com>
> ---
> Changes in v2:
> - Use a table of board compatibles and hardware revisions, as suggested
>    by Jeff, so that other affected machines only need a new entry.
> - Add the Surface Laptop 7 (microsoft,romulus13/15), which Dale and
>    Jérôme report as affected too. These entries are untested by me;
>    a Tested-by from someone with that machine would be welcome.
> - Retested on the Surface Pro 11.
> 
> v1: https://lore.kernel.org/all/20261004165132.4313-1-franzelfranzel@gmail.com/
> 
>   drivers/net/wireless/ath/ath12k/core.c | 32 ++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index 0c72948f3..67d4c98fb 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -72,6 +72,35 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
>   	},
>   };
>   
> +/*
> + * On these machines the OS cannot control the WCN7850 hardware rfkill
> + * input, which reads as "radio off", so hardware rfkill must stay
> + * disabled. Ideally this would come from the connector node of the board
> + * DT, but that binding does not exist yet.
> + */
> +static const struct ath12k_core_broken_rfkill_table {
> +	enum ath12k_hw_rev hw_rev;
> +	const char *compatible;
> +} ath12k_core_broken_rfkill_table[] = {
> +	{ ATH12K_HW_WCN7850_HW20, "microsoft,denali" },
> +	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus13" },
> +	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus15" },
> +	{ /* Sentinel */ }
> +};
> +
> +static bool ath12k_core_rfkill_is_broken(struct ath12k_base *ab)
> +{
> +	const struct ath12k_core_broken_rfkill_table *entry;
> +
> +	for (entry = ath12k_core_broken_rfkill_table; entry->compatible; entry++) {
> +		if (ab->hw_rev == entry->hw_rev &&
> +		    of_machine_is_compatible(entry->compatible))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>   static int ath12k_core_rfkill_config(struct ath12k_base *ab)
>   {
>   	struct ath12k *ar;
> @@ -83,6 +112,9 @@ static int ath12k_core_rfkill_config(struct ath12k_base *ab)
>   	if (ath12k_acpi_get_disable_rfkill(ab))
>   		return 0;
>   
> +	if (ath12k_core_rfkill_is_broken(ab))
> +		return 0;
> +
>   	for (i = 0; i < ab->num_radios; i++) {
>   		ar = ab->pdevs[i].ar;
>   
> 
> base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
> prerequisite-patch-id: aafe3fac38f4020441979665509928f8cc832095

Tested successfully on Surface Pro 11 X1E/OLED/WiFi model.

Tested-by: Dale Whinham <daleyo@gmail.com>

