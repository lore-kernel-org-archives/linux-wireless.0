Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13458C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 08:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5AC20656
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 08:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MDPxvHu2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfAOIs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:48:27 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45163 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfAOIs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 03:48:27 -0500
Received: by mail-ed1-f65.google.com with SMTP id d39so1842130edb.12
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 00:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fjtfi1qokU+uqW2N+VEnhzHIBpz5L73fvCixq7pAOp4=;
        b=MDPxvHu2QriTgPJ4AQ7nX4E/KQTm/tbUrylzBXvEJdeHvGv+LfjrWSLvcilYZTas0z
         FwH8N0+RY2inv6OY3/4ocetPmT7FOmH76uuYDuaSg0XReIMI/jcRb183KD9CpfNGm0mw
         LnCOpiQwXiAcBirWURvVcw5L273X6iBVzvQgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjtfi1qokU+uqW2N+VEnhzHIBpz5L73fvCixq7pAOp4=;
        b=IvtKd63SkUBjvAamzTidHLX7TzKRqeeQP2G8IhGR5bbqMswZJOLX9iSE+DKw7vNnd9
         Q+BxJ595dlX8z6T9z17lWTb7vi4zjlUOBkj5Sh+s/4ar+CkGlCkvx5hKyNDoDIeDv8pj
         oUumM6cd0730S3kAxbocYWToQHxrZwhnrX7iJ6QIX97dAUfQsJlkHTOJ07rIvBMnz6MI
         yBziRx1ZQqMQM8Dk6aHKGcidIOFRymcF94K/MwHT9C7lHL5SBi+/4vRecRK4nwiHFNeo
         dQIhNZuEk6yQcy5C88T2WUK06SHUhfvHHEP/GK2aQr4sqfSxxRXx1V/BNQzi/qgUAN+g
         7h5Q==
X-Gm-Message-State: AJcUuke9HJ8K5slJnxxGt6g960vM4Ig5jYmCSnlsRPATc2VzhBl30u5k
        Dr8Yl0pr3TGoDH3qJlW8nMKXfg==
X-Google-Smtp-Source: ALg8bN6IBLdW1sy7LYZfqi6MzRMZVWy6oRN/+eFDWT82lhIiAAm/74pq3SUAedK9UEf+AOI9hXeshw==
X-Received: by 2002:a17:906:4ad7:: with SMTP id u23-v6mr2290235ejt.202.1547542104486;
        Tue, 15 Jan 2019 00:48:24 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y53sm4832592edd.84.2019.01.15.00.48.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 00:48:23 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: modify __brcmf_err() to take bus as a
 parameter
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190115061949.27260-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <daa97557-03fb-c266-239e-f5f1723bcef7@broadcom.com>
Date:   Tue, 15 Jan 2019 09:48:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115061949.27260-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/15/2019 7:19 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far __brcmf_err() was using pr_err() which didn't allow identifying
> device that was affected by an error. It's crucial for systems with more
> than 1 device supported by brcmfmac (a common case for home routers).
> 
> This change allows passing struct brcmf_bus to the __brcmf_err(). That
> struct has been agreed to be the most common one. It allows accessing
> struct device easily & using dev_err() printing helper.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> This is my another try on improving brcmf_err after the failure from 2
> years ago:
> [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the __brcmf_err
> https://patchwork.kernel.org/patch/9553255/
> 
> Back then my change has been rejected due to miscommunication and late
> realisation that struct brcmf_pub (a previous choice instead of struct
> brcmf_bus) was a bad idea. Back then Arend wrote:
>> So I would think using struct brcmf_bus in brcmf_err() would be best
>> fit.
> 
> So this patch follows that suggestion & updates __brcmf_err()
> accordingly.

Thanks, Rafał

Little less than two years ago I played with your idea and using GCC 
builtin __builtin_types_compatible_p(t1,t2). Anyway, it looks good. So 
you want to limit it to brcmf_err() or brcmf_dbg() as well?

Regards,
Arend
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 7 +++++--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 8 +++++---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 7 +++++--
>   3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 0ce1d8174e6d..c62009a06617 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -350,7 +350,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>   }
>   
>   #ifndef CONFIG_BRCM_TRACING
> -void __brcmf_err(const char *func, const char *fmt, ...)
> +void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
>   {
>   	struct va_format vaf;
>   	va_list args;
> @@ -359,7 +359,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
>   
>   	vaf.fmt = fmt;
>   	vaf.va = &args;
> -	pr_err("%s: %pV", func, &vaf);
> +	if (bus)
> +		dev_err(bus->dev, "%s: %pV", func, &vaf);
> +	else
> +		pr_err("%s: %pV", func, &vaf);
>   
>   	va_end(args);
>   }
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index cfed0626bf5a..b499f90d94f6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -45,8 +45,10 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>   
> -__printf(2, 3)
> -void __brcmf_err(const char *func, const char *fmt, ...);
> +struct brcmf_bus;
> +
> +__printf(3, 4)
> +void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
>   /* Macro for error messages. When debugging / tracing the driver all error
>    * messages are important to us.
>    */
> @@ -55,7 +57,7 @@ void __brcmf_err(const char *func, const char *fmt, ...);
>   		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
>   		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
>   		    net_ratelimit())					\
> -			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
> +			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
>   	} while (0)
>   
>   #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> index fe6755944b7b..f9359ea9cb13 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
> @@ -21,7 +21,7 @@
>   #include "tracepoint.h"
>   #include "debug.h"
>   
> -void __brcmf_err(const char *func, const char *fmt, ...)
> +void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
>   {
>   	struct va_format vaf = {
>   		.fmt = fmt,
> @@ -30,7 +30,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
>   
>   	va_start(args, fmt);
>   	vaf.va = &args;
> -	pr_err("%s: %pV", func, &vaf);
> +	if (bus)
> +		dev_err(bus->dev, "%s: %pV", func, &vaf);
> +	else
> +		pr_err("%s: %pV", func, &vaf);
>   	trace_brcmf_err(func, &vaf);
>   	va_end(args);
>   }
> 
