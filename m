Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F97C36A341
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 07:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582353; cv=none; b=EwPeCBj0+glyhN5cI/YdbXdpkdA/0ZZJGQyOHozW4zP0TfQ3q6tg9cMLGtFBPL5PE+mk5rJjEnIu/gL2nkxoq/5OZPup2Ow9cRDt5o44TB4+HsKrhMF7nKUzuJAYs71qG8CyVB544gk2N4GkLelWMIGwQQmE0cXQ1GPxiyUReqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582353; c=relaxed/simple;
	bh=ED+sBRr3QhMO5/4gS/VqfY8k9EZbHBPa7Fm+KPqc9as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERZzQWGFUi7F4bYPnC9hGLmpkAqNOeZI2z+xkMk1rnadxDOKRc6VYPwm5UpZDvOQA31ZhWkdV6TOdKDE7EcXzdJxzADfitr+QUzOTO2OGsAQLB7Gm0mtmGrq509lqA/ksNB8K2XLpcDZdVExlCJg9lAoH/vEUrGZ2shR0ueU3v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JPihjfMb; arc=none smtp.client-ip=74.125.225.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JPihjfMb"
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-49fe4ca1052so6650505e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 00:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790582349; x=1791187149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XhysCFeCFrK6Hy/AV9kl1/zr3IXUOwo2mfXgBsYx8sE=;
        b=JPihjfMb3WY76x+yDC/RJKaFkXn/ssSQGuprdvgCJ3E76w9JNPtkZc+0KoaVwmKZYT
         qKSwIAyohTIK8g0aukoajF4Wi0acP3C/4JUVISb7LW60+gPc0zJc7cflaDHwLdsZP3+/
         hF/i6tA4Y8ESnzEfFKPwH6eNVu/ghuq6Vg90dkH6yWRForln4mK1aFYPLSoI2ozPaF5X
         XOGQ4bKEkv3LLpq8VeP9Q8RMVs0oRqxm/vMg5xTmNz5S/Tc5LwDS1lbb3UKzItV7X3UN
         OSvUVfXwrCizrL3GJT+ZdssP3Ts9PcJnPcczPqhMuqnZaInLhpqqUhdENvYWkrqer3OT
         NH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790582349; x=1791187149;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XhysCFeCFrK6Hy/AV9kl1/zr3IXUOwo2mfXgBsYx8sE=;
        b=BhShD6y8t6cvknCoIsmaGYCyUL/gTjPG0Q+06CUTr2S0ToRZFo77h0HOfqghmSV7kJ
         G0TWFBxdOZRW4yhHLEWcjJpBQ9nXui4/06zRJSCoWTudoZe/n0NSHiwkKJfs8/YZdjRv
         Ad9LMAEz/ExrtMrViq4m6VM4fWS/Ymq7/8kTlucBzN2Rfv9OqRwpP835OXlsKVkDA9Sy
         r9/ghTttcdysDWzRA9UGP4lUqIPELc2fCY/8xfZxenMWP5unWVqHG2vo6TpN2n0wC31v
         fVJqqGfsM6LzaYsvUtjTtiQav2EYzgrcTEiuBJTntC9LtF6BH96sBxQ5SRBhrGGnPaKM
         nf1A==
X-Gm-Message-State: AFuF++maeBLdQzYfMI4RaxK5tqnUeGPGi8mE0xdeAtT29uKyBRO5oasY
	Rn5G1kEdNqHVPzL6OCw47b4J5n/rkce867XCrTa7HWiKvHt6uqn6Obguf6t5D/fMFh8=
X-Gm-Gg: AYBFou3FffEQGZMVbL9/WW43QpkUx1yM2rOM6d6Jw0sZB/vHMP+4hrJSwYIXTB7zlxA
	rpPA5WQMt7fQpwJTGAiCfcRTv+aZMOGgAHzScyV6xYHCzLEkTkxoRe92Gxn8e7gboJWjbOv4eGG
	TEAbwHQS/QG79vf4sX8sFknEn5EvaibmBd2Q6l+yiGkiMw5X7yXEwQYq/Kl9eGTVz0WpgeyHRKp
	eeY2iY3vKuFs6C0O5AkUC7h5fzwCUqoqXxzrP2+xr2tch20RfyPilCTmD4NjgLEpOUGOUtfAgDR
	JKC6mpgk6pQQkGbTJ7R0nZ7kU5SkEMmgzOBp8hSiQbS1XWWGwvAaYysw8wvDKzF9t9pjCwVGJVS
	u8PCpCsggy0oJkJRi91tI3wnjpkKMJka4FXjyjHV6oI8CZxhzF8cx/5ZOi3C8jras+Os+ppAO69
	snryCDO8rU+pDfoDBLI+XF3czJRYAjBVLFcrwYLyp3Tg0OJABKv0kCuB2B1hwjo0skENrBb9EQw
	driAGLR2PS46dCGy2aa+APCW0BlOAk82VGbsAswXMsjKrt1e+hPsg==
X-Received: by 2002:a05:600c:a4c:b0:49c:fa20:cc08 with SMTP id 5b1f17b1804b1-49fe67060cemr213903135e9.31.1790582349255;
        Mon, 28 Sep 2026 00:59:09 -0700 (PDT)
Received: from [192.168.0.38] (static-246-51-231-77.ipcom.comunitel.net. [77.231.51.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a007be0761sm21702035e9.3.2026.09.28.00.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 00:59:08 -0700 (PDT)
Message-ID: <bafa7204-1025-4db6-974b-1491d3cc48a6@suse.com>
Date: Mon, 28 Sep 2026 09:59:07 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] wifi: brcmfmac: Add clm_blob firmware for
 brcmfmac43456-sdio
To: Benjamin Drung <benjamin.drung@canonical.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260923203739.2560527-1-benjamin.drung@canonical.com>
 <20260923203739.2560527-3-benjamin.drung@canonical.com>
Content-Language: en-US, ca-ES, es-ES
From: Matthias Brugger <mbrugger@suse.com>
Autocrypt: addr=mbrugger@suse.com; keydata=
 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
 PVrr2NoUqi/bxI8fFQJD1jVj8K0=
In-Reply-To: <20260923203739.2560527-3-benjamin.drung@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 23/09/2026 22:37, Benjamin Drung wrote:
> On Ubuntu 26.10 these firmware file are missing inside the initrd when
> including the brcmfmac kernel module:
> 
> ```
> /usr/lib/firmware/brcm/brcmfmac43436-sdio.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob.zst
> ```
> 
> So include the clm_blob firmware file for brcmfmac43456-sdio similar to
> the other firmware files.
> 
> Bug-Ubuntu: https://launchpad.net/bugs/2168109
> Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>

Reviewed-by: Matthias Brugger <mbrugger@suse.com>

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 3cff0f1fe25f..cea52d408817 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -618,7 +618,7 @@ BRCMF_FW_CLM_DEF(43430A1, "brcmfmac43430-sdio");
>   BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
>   BRCMF_FW_CLM_DEF(43439, "brcmfmac43439-sdio");
>   BRCMF_FW_CLM_DEF(43455, "brcmfmac43455-sdio");
> -BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
> +BRCMF_FW_CLM_DEF(43456, "brcmfmac43456-sdio");
>   BRCMF_FW_CLM_DEF(4354, "brcmfmac4354-sdio");
>   BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-sdio");
>   BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");

