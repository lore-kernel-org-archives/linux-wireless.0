Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2D5C43219
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 21:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895072064A
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 21:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OW2VcpS5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfD1VGq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 17:06:46 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35083 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfD1VGq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 17:06:46 -0400
Received: by mail-ed1-f68.google.com with SMTP id y67so7481481ede.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2019 14:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D4FD8Gjv+E7UZy1yRomlDu0w+33s1PoI7PWQgS6CMZQ=;
        b=OW2VcpS574qznZE5nPvcGIrDvHaysNs3YKzsdI21lcMV7i3vkrT1uEg9ls/4G5KAN0
         06cOJlsw24Xcf94KYtcFKZ8/HOZgLIoazEUH2lnv4tpqOwLGGcEXSMePkgf2lsn1bDEC
         yKBd+lipZksvJoL83Zdww2IXSLe+XaBcCuDY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D4FD8Gjv+E7UZy1yRomlDu0w+33s1PoI7PWQgS6CMZQ=;
        b=I3wH/+HXuAcsiGc2Ak9OqgETNpmxlEtXaFGJo5+WSwwwPCDFvGi76vB86mmQZXoXR4
         GPJ+RnpHGMbFjOYGl0c6NoBPcd6wLUnwgRf5GyidTTEyyXiadZFTvXrtE0cOk0afOnBq
         M8KNCdkwCGrjNJScqi/Lis59XLc9gy/CbaugZtuV75xgtQp6/+EFFcMQWpSxjxeREBUB
         kzfhwfhuCA0TGljZCQaqwka9B6w8oRlh7r5bFD4X4adQOxPbIcbKnkzMDt4j4raY4d6s
         /S58fMrAUS8bPSVCTTCg1nGGhgYVXkxswDY6RIn6t3HvxaMZckgte5UEcMiLUDQ/rbqm
         BW8w==
X-Gm-Message-State: APjAAAWVHxKzzCCrXxvfB3gqCOF7EyiGwjI74rrQEkaJnyM2XU1oNsNi
        EFsabKUzJoy2G297udQuOt+EEwxrYoHWJg==
X-Google-Smtp-Source: APXvYqwOkswxHvhsGyGQtwKJqv6rQyyz/Lx6WBKbnrgWVJwYeCC0GDBt7k16DxoWW55EJY8bobV9LQ==
X-Received: by 2002:a17:906:2f13:: with SMTP id v19mr3538519eji.17.1556485604455;
        Sun, 28 Apr 2019 14:06:44 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id t9sm5337796ejg.54.2019.04.28.14.06.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 14:06:43 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: print firmware messages after a firmware crash
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190427183008.27111-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2ccb4482-7561-0812-92dc-5de3d639cc3e@broadcom.com>
Date:   Sun, 28 Apr 2019 23:06:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190427183008.27111-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/27/2019 8:30 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Normally firmware messages are printed with debugging enabled only. It's
> a good idea as firmware may print a lot of messages that normal users
> don't need to care about.
> 
> However, on firmware crash, it may be very helpful to log all recent
> messages. There is almost always a backtrace available as well as rought
> info on the latest actions/state.

nice... there is one minor nit below, but other than that...

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../broadcom/brcm80211/brcmfmac/pcie.c        | 24 ++++++++++++++-----
>   1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 637973fe8928..f519b050aff3 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -764,15 +764,22 @@ static void brcmf_pcie_bus_console_init(struct brcmf_pciedev_info *devinfo)
>   		  console->base_addr, console->buf_addr, console->bufsize);
>   }
>   
> -
> -static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
> +/**
> + * brcmf_pcie_bus_console_read - reads firmware messages
> + *
> + * @error: specifies if error has occurred (prints messages unconditionally)
> + */
> +static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
> +					int error)

Given how it is called I would say 'bool error' makes a bit more sense.

Gr. AvS
