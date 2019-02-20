Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEFBC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBBEA20C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ML6dOFwk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfBTMt1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:49:27 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39528 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBTMt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:49:27 -0500
Received: by mail-yw1-f65.google.com with SMTP id f192so269534ywh.6
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 04:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+TXKz8O6QL6RZwxWw1yKeBkHgUv19j/wYGIvsW3ohUQ=;
        b=ML6dOFwkeBcpj4EzKClHB9RTMZqVGOnRfkEcKXs3h2JC2mTvL3HHtsx8jLOKAmU4d1
         EcAc3Y5KD/vIyom+3DzvOHaH0p8+ZIaw1Vu7+jSDIjjgW2kPg9Op7ImloyOvWtMgGqzQ
         ErT9775nExFdmKhguEwv3rugVeORxNnoC9F4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TXKz8O6QL6RZwxWw1yKeBkHgUv19j/wYGIvsW3ohUQ=;
        b=acu1ya0yZ8KY01gD/9/uO8T13YgIzmCCak22Ia3yPYG0Mzy45dkMF7RO3gGNNBt0XC
         l8VObi/O2WeskIOFExkDppdq4sMmf6jqKlAu20J52WL7wZnY/Nb9ZYjqzSAvffFW9Sn4
         zh4OgoxiprxSQgIezgd4jRkHtzCeE5xgF1aZ0W6YqRa8hwicjT26Z+DJp1w0hKVeeZgW
         dHH7K7oSkUlZ1q7obOa+5vil4vm+ie4uYeRbVaIOm8sKuCHqXaUBXcL3Ykk5XvYWJibE
         CYuI8RfsiXYwP/LN7yqX5kzy9le4nMYpt4fFejwC22MMmtoD+COUxmkbF+z3lku4sfqv
         4JJg==
X-Gm-Message-State: AHQUAuY7wsttjuA2MMTNBtRdTWxrKrre4XpSyqq2HJ2U1BS+tReFAGVo
        3zyvkIJi9ZcADvqrYlw7aBwh0w==
X-Google-Smtp-Source: AHgI3IbaqvmaOUePpHn1MB9BMFHCH9bk4I8AbrRmrem1QUhL1il7mplC+rhjc+d0fR033G8sqANx/Q==
X-Received: by 2002:a81:5507:: with SMTP id j7mr28025949ywb.491.1550666966642;
        Wed, 20 Feb 2019 04:49:26 -0800 (PST)
Received: from [10.230.33.15] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d70sm6183305ywh.34.2019.02.20.04.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 04:49:26 -0800 (PST)
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190220103047.8960-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1de6ba9e-a100-250e-ca0d-ce63afd3a74d@broadcom.com>
Date:   Wed, 20 Feb 2019 13:49:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220103047.8960-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/20/2019 11:30 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> While experimenting with firmware loading I ended up in a state of
> firmware reporting shared RAM address 0x04000001. It was causing:
> [   94.448015] Unable to handle kernel paging request at virtual address cd680001
> due to reading out of the mapped memory.
> 
> This patch adds some basic validation to avoid kernel crashes due to the
> unexpected firmware behavior.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++++++
>   1 file changed, 6 insertions(+)
