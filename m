Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A40351EE08
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791427; cv=none; b=K7wdshuHrb50uuZwq6i7cVVuDpIlSXhRHMXB7DmHWbQTToEqEvys1XeGB7SwuSuWjFj8d1+R1wDqnx8HfLCXFtjaF0J38xrmxBlcqJVXDCmn+MeQKjG3+dynqwmsKmhJElB0wmJsoSSV/RM+l5kkQD7KrLPsUPHrhqW81kc4ozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791427; c=relaxed/simple;
	bh=YBSleO+qUBV0CGp3vnKdPgJjrEZ+GFiqw10+pvoc42A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pvSf7995kOh5A8iYYltYPsItO5m8LfBuneLIed3hSIVWo2opxh73xC9x394ajA4TQjVUjJg1Z3B+Z1NphElD6fnX6vPd6A8cgJOPx/OmTiCGGMyqakF7DogUGznxWbjuP+8uWrOweL4d81tAA1npQ4m5UbqaDtFMjl1tMVbD6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVUxBIiK; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVUxBIiK"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48882c1f2baso1817731f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790791423; x=1791396223; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0n18LIH1tvBWGAP/420toHKsoVmCmgfsuDIdW5uR/Hg=;
        b=RVUxBIiKzyuq076xm1UXwHb3zhH851Kk/IbBOgshLKzV7bqWFTQfNO1d+4hud0wIXG
         xMVuFXZx7G9ZpNfMKur7Jr9JQJnzEWYG1MfHRrlQ7gg4vZJLcatL5lwXooYV/ZAYv+hA
         GGZtrtzDS5QHHi9Eyhc9BJudwWNvaVsywMsGt+5G5UKOtnP48oRlfqIy/VtzOOnjYkUz
         n+dsugs0CfXOFfBRH/8X/+fYIdVEstlL7YlEEFoWfrz0O6vemqE3z3y4tXIunW3vXoMM
         rKhe4DLO/3tIqJktpm5ucfNh5aY70pJQBuhPqKFXWBkM8ZOuEq9qgZZEWNPlbUd1Vp/g
         bLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790791423; x=1791396223;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0n18LIH1tvBWGAP/420toHKsoVmCmgfsuDIdW5uR/Hg=;
        b=w0Sa9LellsWjTdj7BtbEOKgWQE1R8u3U6UiCa6xzGUw8k4pYwLAnFcS0xGMEXNIy3I
         ewK9Utf5xFw4dFfN0EwyixqIe4njmxxIqufNnkv6IjfdRwkclO55lup8ZS7gOuLRvbfM
         gHgz9PY+r9lVr9rcz8P9B3OFetuEiNoCpDzZAOCoydbdEF7OG4tb5Vdspe6Cju7ZwQ4M
         ksU4Um+26MjcigZYgySmlRCD/nBhFmBbh18ize16Wqjk0xhaJqNhI5C3Q//DEp1w9feF
         KDX/RHcfZM52NxvMwalZgIqEP+Sor8kZg1NjJv9ozeOScxFL0uGUYiaglq6Fmnbld+yX
         ReEQ==
X-Gm-Message-State: AFuF++mrnzDasOf8QgPDz5XDszU3dsyXBqYBIxnJKBJNpG71WQewnttX
	0OzkvIZScE8yJs7clCgZlzHiEfyXOCb4bHi2hnS2aswB7XxpovxHnHbh
X-Gm-Gg: AYBFou3aRF6hlHDN8mqbIAzesojiMrK3fS6SER2u9/XhMKwkA6F3kB0LZ9mtaIOAOF2
	glerqWhHGClR5Dk7kdWQJ2LpAL2QEGYILoOdKcEFpgH2eO6sNvVQJkcOkCCXrp/EEcskeIKBEDx
	+wsmmw7GEJedaSW4H65yRmWSlxrzp807bSbGSc2z0I47Nr8CytlK9VR3YIbfhDputNebkgeQc4S
	vMFwg8Un4znalXqjxZIGkyuZ74t7OplsRj5OlbRLB7H6+PsuJJ0TX3unF4HfPqTretuGMcEu5mt
	4SZ3KKKUG/MLfENGmjCMbEb6nLYYuEXPdxNSm1h4G3alHUSIdrEjTf8h3t9/KLsal0BM/WMzQq7
	c/6jaAtLMt8xTr86GXoSNLTN8858T0iQKnsorSRlu+qHQLWvmKzndcOG+BGhP21w7TBj7PkipiB
	4ckRTaEFUlJI0AE+BvKUX5xgfcUU0FRTWJNwT63Kjsn3GZGLdoOtM8mTj4C8Kk80btqYLiplDqe
	3wb/Q==
X-Received: by 2002:a05:600c:8b88:b0:49f:e8bf:8f9b with SMTP id 5b1f17b1804b1-4a01ad98373mr38023785e9.4.1790791423386;
        Wed, 30 Sep 2026 11:03:43 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f913ecesm165395e9.2.2026.09.30.11.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 11:03:42 -0700 (PDT)
Message-ID: <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
Date: Wed, 30 Sep 2026 21:03:41 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260930091604.52891-3-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2026 12:15, Luka Gejak wrote:
> The receive control word is the same for every chip today. The generic
> default is written in rtw_core_init(), so a chip that needs a different
> value has to overwrite it afterwards, in its own init path, far away
> from where the default is decided.

I still don't understand why RTL8723B(S) would need a different value.

> 
> Add an rcr field to struct rtw_chip_info and assign hal.rcr from it in
> rtw_core_init(). Chips that do not set one keep the generic default, so
> the field is optional and no existing chip changes behaviour.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 10 ++++++----
>  drivers/net/wireless/realtek/rtw88/main.h |  1 +
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 0f23498b5c96..53d8552c0d35 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2191,10 +2191,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  
>  	rtw_stats_init(rtwdev);
>  
> -	/* default rx filter setting */
> -	rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
> -			  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
> -			  BIT_AB | BIT_AM | BIT_APM;
> +	/* default rx filter setting, or the chip's own value if it has one */
> +	rtwdev->hal.rcr = chip->rcr;
> +	if (!chip->rcr)
> +		rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
> +				  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL |
> +				  BIT_APP_PHYSTS | BIT_AB | BIT_AM | BIT_APM;
>  
>  	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
>  	if (ret) {
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index d59f6e323adf..e0f389040089 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -1253,6 +1253,7 @@ struct rtw_chip_info {
>  
>  	/* init values */
>  	u8 sys_func_en;
> +	u32 rcr;
>  	const struct rtw_pwr_seq_cmd * const *pwr_on_seq;
>  	const struct rtw_pwr_seq_cmd * const *pwr_off_seq;
>  	const struct rtw_rqpn *rqpn_table;

