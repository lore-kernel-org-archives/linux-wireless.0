Received: from mail-oa1-f98.google.com (mail-oa1-f98.google.com [209.85.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4507C4D9F99
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791485423; cv=none; b=hgao7yenQTfroRJLWKI/Q3ocH8B6YDrKnYTEF2m1ZeIq7KHCCUouR/3PI4G+Cxc5Z8L95v8/vozOy8sGvB6tgQDYfa05JJTL7M2vsLHn9U8CEJSa39S1NXIra7K3yPwjq23actXPUO/qKqQoB+2MdUB3KQs5m/Rm6V+hJgqkO7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791485423; c=relaxed/simple;
	bh=blDRYnm+eYgcYCYVIwypwt6R81KRKfjTWhx2Jnw4ho0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ggShvGIuTqKs4oyNsXPRzUhce03lRSJFyCf37IAM1u8KaRVdXsP0uDEx4Il/DIhopM6nbU1c9t9TsRPN+bBq+xOfy+f7xAJjJRm4wKCU///XPyPOUZ2AjrEOpI7K5LzAf6feEIV7S0JBULsIINoY3CIS/HJxZ7JXauNva8cRrMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=A7sRKtXM; arc=none smtp.client-ip=209.85.160.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A7sRKtXM"
Received: by mail-oa1-f98.google.com with SMTP id 586e51a60fabf-49e20441e45so694384fac.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 11:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791485419; x=1792090219;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ArLs8huVVv4YGyFYXEbwrJuK+8e9tYytWAQhJ+uGSg0=;
        b=0+US5CIWn+re/4l8YJp5nsaCORQtxy416s/f3XebQxrRdZljBlbaDap5TUfQkfXOx7
         8z9nYpDrUYJx+24BhcXAC6O0wKNi4OiCZUQZ5DMKR/kOHRxLPfb02hZLtt9ibuMpyWgE
         P2kE/LpBLnmtIbVg7tR2TbtXHj4MnDy8UMaSZSDGLZHLrygLdnOvul9D0ER1gMOR9lT/
         ku7FsRE6WnQ56DBZz1TT3pN/AGSQZzQwZaOn7aFwKJLvR2Erabfh9ebaIp942qwV6CHJ
         hx+wOzTgqEhZgIN0UZqmXuKUqhmQSIF45/WxS+DSEFJz0xNCEHRrKLvROQN4ax/6kenU
         omng==
X-Gm-Message-State: AFq9FYKwSXMiTY51zCUubxJU45ygxa7yNIBZtKAGcsb2hHoey6OWoNtC
	nQxz5ZRJepQYeIUp3SanjEaJGINaHK4miqdHGMv1XDn33l1z3jma0j9Vn6Z14AeL/LvKRyrfnZH
	vJFVr5gaefVJWbOeF0PL0X2qBMcsLP/mTzORhSz2gCb+99Gy32o2qCEu1lIbirbYi4gwWFDCZOn
	HCKcjg6vDccYeaGzGo/xuKhotOrRC5LKdSbFoutZsej151tvZOyi2zVHJxmAGPp6P+lN3PHDnGx
	WCEFla+6WGVHIsOUS7XGnpNtFt2
X-Gm-Gg: AYBFou0V6QmXaOh3Xu77hQxrU7b8hOJw5iYaW6ogfFtngyzs20t8+niJETjZ1SjUPZA
	HCi5qD+A/MzBFAL8DrzreXNfkVggW2JOZZ2hou4kwTfjm98W9/+iSel0+rWPMW7sdA5zJRB4F1N
	9IAuIw5pj7nqIIouc6+K6kjEQd5klCTzy4DuHDPDqVc7/96VgaMqzeiNyk0Yw+JlKnYHjZUZuwd
	NBRbsj85lrWHvy99JsSuqW/1pErYoqmdJt09Fx5Ft6E/a02dSjcshoaAikc3Mneaj7DwGNhYgKY
	ICo+rDhQCB4rSmT2SSCWempRniIuKZZClkkNUouhDlgdR3lUtI6mH9Ynl9U9bujJHe4ywuiZ2Xt
	4P/6bWq9ifJd8ixBN48eoN1kYlgLWpJQk3qC0kRV2v/0/4v0ZATZKp5RcOYPLRthx3jP50sYKov
	am1ZqgPSScS6hFums/aKOaxv9oj+w4RKKbhR+xIOJ4kA==
X-Received: by 2002:a05:6871:6d0e:b0:494:9c6b:7144 with SMTP id 586e51a60fabf-4a2a49e742bmr137854fac.21.1791485418887;
        Thu, 08 Oct 2026 11:50:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4a2a46a101csm11346fac.13.2026.10.08.11.50.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2026 11:50:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2e6affec80so536017866b.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 11:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791485416; x=1792090216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ArLs8huVVv4YGyFYXEbwrJuK+8e9tYytWAQhJ+uGSg0=;
        b=A7sRKtXMmnGbmAc+MQRlt3NsqFrX+5ArbtLyjIVCezg7tzxcRu33F4DxTXZL1RPYJd
         F+sSNv6Ey4nEKtnG2upGB+Guln2Mxhm4wx/5oZbiqhs5ZvulMC4yKynWnJXuTPeXy94k
         xI1ioDWD44OCUT2iS8SLnO+uUr4GyvTWcMEFg=
X-Received: by 2002:a17:907:9714:b0:c2a:ad55:b3fa with SMTP id a640c23a62f3a-c31a6dff0d4mr4825666b.7.1791485416057;
        Thu, 08 Oct 2026 11:50:16 -0700 (PDT)
X-Received: by 2002:a17:907:9714:b0:c2a:ad55:b3fa with SMTP id a640c23a62f3a-c31a6dff0d4mr4822066b.7.1791485415048;
        Thu, 08 Oct 2026 11:50:15 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a4755f97sm6735666b.10.2026.10.08.11.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 11:50:14 -0700 (PDT)
Message-ID: <08bc02e9-77ea-4bcc-b087-de720d2449f7@broadcom.com>
Date: Thu, 8 Oct 2026 20:50:13 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: drop glom superframe on header parse
 failure
To: Shirong Zhao <shxzhaosr@163.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20261008103312.20-1-shxzhaosr@163.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20261008103312.20-1-shxzhaosr@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e



On 08/10/2026 12:33, Shirong Zhao wrote:
> brcmf_sdio_rxglom() uses rd_new.len_nxtfrm and rd_new.dat_offset
> right after the superframe brcmf_sdio_hdparse() without checking
> errcode.  On parse failure those fields are either uninitialized
> (the early -ENODATA/-EIO/-EPROTO returns) or hold a rejected value
> (the -ENXIO bad-offset return), so bus->cur_read.len gets garbage
> and skb_pull() runs with a garbage length.
> 
> Check errcode first and drop the superframe with the same cleanup
> used for a bad subframe below.
> 
> Verified against wireless.git main (9727d1c4e1c9), the current
> wireless fixes tree.

Thanks for the patch.
> Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 381801af3..53ffb8dba 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -1649,6 +1649,18 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
>   		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
>   					     BRCMF_SDIO_FT_SUPER);

I would avoid the extra release/claim host below. I modified your change 
to what I think it should be:

> +		if (errcode) {
> +			/* Superframe header is bad; rd_new fields are not
> +			 * valid here. Drop it like a bad subframe below.
> +			 */
> +			brcmf_sdio_rxfail(bus, true, false);
> +			bus->sdcnt.rxglomfail++;
> +			brcmf_sdio_free_glom(bus);
> +			sdio_release_host(bus->sdiodev->func1);
> +			bus->cur_read.len = 0;
> +			return 0;
> +		}
>   		sdio_release_host(bus->sdiodev->func1);
>   		bus->cur_read.len = rd_new.len_nxtfrm << 4;
>   
>   		/* Remove superframe header, remember offset */

Regards,
Arend
