Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083A0C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4482223B0
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YdgNlnwt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4482223B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbeKLUJY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:09:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53850 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbeKLUJY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:09:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id f10-v6so7853694wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=cqD+IDqM1Km38qxAN0Gkw7dRd4orenDfK2QuVqECUs4=;
        b=YdgNlnwtP/mahb+ik4/ZkSK2baQtkkRX/yhXsj1rfkb2Jw437ObC4de+QW3Y9qh3sV
         DfucT9dKbVmCcGInH5kB6xZ7Qb3DiHGsnw/ImSX1ukD9EZyU47ZjmEgHcDwuYGT33EG4
         c8AStFUFlDpc043jFqwLTf56dNKPwSV6cWekg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=cqD+IDqM1Km38qxAN0Gkw7dRd4orenDfK2QuVqECUs4=;
        b=buogj+WsnIIo+qnXahc2aw18jAzRAiuGmRNx1Ll3FXig4hsWViyU+gsP+tMgHiGXyf
         xD5R0W5MhBgBR5y3OtCYFwLgq4FC/Jms3YsRJn/CVYysVugv7TCQCsp+LQQm/jq5Aiqd
         OLdfUGG/7gWS7C1Z05wlVMGaN48WGvVX4oqq4SUjWrnPF1+Pv/K/8I1acNm69EgeZv3C
         FSp1fsIjJ3tk64pnVbXiWfFcqzmc0t8eQQEU+wjmQOuGP7G1DOYxLIxXtazuXNteyopn
         cs8Ikpe1ASkfqX8LcTTLPUS3xkNvBcHRpijORxpzyiBzLPywHKIMrTpq5rakGluEt0Js
         1XPg==
X-Gm-Message-State: AGRZ1gJEFDWy6CYtnyTf2cKxKYFvkG31mdQ+dBRTnEQWQiXPsKQnhavV
        IOcw3IXufCxMHZRjAxvxoOqOFw==
X-Google-Smtp-Source: AJdET5c6tw8wHt+GSUdUUb7QlYtER3/1FxbxFSdGNGOmn3X1pLbjiLUgGblivittnrQO0+5bT3PEOw==
X-Received: by 2002:a1c:95c4:: with SMTP id x187mr787849wmd.95.1542017809133;
        Mon, 12 Nov 2018 02:16:49 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id c8-v6sm18211174wrv.64.2018.11.12.02.16.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:16:48 -0800 (PST)
Subject: Re: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e3dba747-2baa-e36a-dd66-1c788dc32288@broadcom.com>
Date:   Mon, 12 Nov 2018 11:16:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> GCI core is needed for ULP operation. Allow GCI core enumuration with
> below changes:
>  - Allow GCI to be added to core list even when it doesn't have a wrapper.
>  - Allow 8K address space size.
>  - Don't overwrite the address value when an additional size descriptor
>    is in place.

One question. This only assures the GCI core is listed. So does the 
driver need to access it for ULP operation?

Regards,
Arend

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index a3c857721446..a8d3b96b727f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -786,7 +786,7 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
>  				      u32 *regbase, u32 *wrapbase)
>  {
>  	u8 desc;
> -	u32 val;
> +	u32 val, szdesc;
>  	u8 mpnum = 0;
>  	u8 stype, sztype, wraptype;
>
> @@ -832,14 +832,15 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
>
>  		/* next size descriptor can be skipped */
>  		if (sztype == DMP_SLAVE_SIZE_DESC) {
> -			val = brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
> +			szdesc = brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
>  			/* skip upper size descriptor if present */
> -			if (val & DMP_DESC_ADDRSIZE_GT32)
> +			if (szdesc & DMP_DESC_ADDRSIZE_GT32)
>  				brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
>  		}
>
> -		/* only look for 4K register regions */
> -		if (sztype != DMP_SLAVE_SIZE_4K)
> +		/* look for 4K or 8K register regions */
> +		if (sztype != DMP_SLAVE_SIZE_4K &&
> +		    sztype != DMP_SLAVE_SIZE_8K)
>  			continue;
>
>  		stype = (val & DMP_SLAVE_TYPE) >> DMP_SLAVE_TYPE_S;
> @@ -896,7 +897,8 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
>
>  		/* need core with ports */
>  		if (nmw + nsw == 0 &&
> -		    id != BCMA_CORE_PMU)
> +		    id != BCMA_CORE_PMU &&
> +		    id != BCMA_CORE_GCI)
>  			continue;
>
>  		/* try to obtain register address info */
>

