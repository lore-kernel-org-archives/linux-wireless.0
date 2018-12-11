Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E624C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7F920849
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A7F920849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbeLKNEL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 08:04:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36110 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbeLKNEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 08:04:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id a18so2189570wmj.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 05:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WElvKbvZ+DmnTNhtk8AKbtUFpZqOwnZ5Enn/Ge4QlP0=;
        b=t6yeSaAX1ydHHg1DC6RbYuRtblnSXevhTyWa1UvRZ/CQr+jGxwqcT53349MyS9jPuk
         exsH6dOxZ7n+5GP8joevHiUxSrKFDRC0Dqs2mtdOzNvIa0keWSMOZOcb7UYrL+HfyJUv
         7dm04cbo3/1VGWNCM6a/+tnuv5cwpHwu65ZIDrQyEzKSkOmBd8IwO8XDxobzFeOquIro
         olAbtPvejmMot+a9UA9nfVkdm8Fiqi+0lnhvSPgXT3Sgkoti9tks84WKdSWB7T/7q60k
         DawuviZBXwA+LtSYEuYFBryZ+l5sZ/ICSxsU4wHJ9kEq81iBalC2UAZTEeYl4mHzbJY8
         674Q==
X-Gm-Message-State: AA+aEWar6XcvWDKImhMp3s86ntXXNWbC9nbOhs6Zk2YJKvHv82WzkJKz
        OiUPvtU+mc64iYNgwD6+FigTsw==
X-Google-Smtp-Source: AFSGD/V/hGmNgmJNeIp6SgZVZ679O10VGVZBr6ulbr8KBmjUq8hnd1cs7TgSt8+T1UVm0nR96HrClg==
X-Received: by 2002:a1c:541a:: with SMTP id i26mr2259677wmb.128.1544533449195;
        Tue, 11 Dec 2018 05:04:09 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id r12sm11593449wrq.3.2018.12.11.05.04.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 05:04:08 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: fix false-positive -Wmaybe-unintialized warning
To:     Arnd Bergmann <arnd@arndb.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Lyude Paul <lyude@redhat.com>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181210205555.3000038-1-arnd@arndb.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <3e5ec4b3-05fb-1ba1-90c0-81c5657aa0e1@redhat.com>
Date:   Tue, 11 Dec 2018 14:04:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210205555.3000038-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-12-18 21:55, Arnd Bergmann wrote:
> When CONFIG_NO_AUTO_INLINE is set, we get a false-postive warning
> for the brcmf_fw_request_nvram_done() function, after gcc figures
> out that brcmf_fw_nvram_from_efi() might not set the 'data_len'
> variable, but fails to notice that it always returns NULL:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c: In function 'brcmf_fw_request_nvram_done':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:560:11: error: 'data_len' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Mark it 'inline' to force gcc to understand this.
> 
> Fixes: ce2e6db554fa ("brcmfmac: Add support for getting nvram contents from EFI variables")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index dad3c1c79038..14b948917a1a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -512,7 +512,7 @@ static u8 *brcmf_fw_nvram_from_efi(size_t *data_len_ret)
>   	return NULL;
>   }
>   #else
> -static u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
> +static inline u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
>   #endif
>   
>   static void brcmf_fw_free_request(struct brcmf_fw_request *req)
> 
