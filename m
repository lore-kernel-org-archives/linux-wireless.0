Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E98C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 12:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702DC20672
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 12:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LSfbttOa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbeLQMhZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 07:37:25 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46094 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732604AbeLQMhY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 07:37:24 -0500
Received: by mail-yw1-f66.google.com with SMTP id t13so5076416ywe.13
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 04:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8oo3XIzYkZafeuhie0WLhW1XKKw90P3tz4hdUKM8Yw=;
        b=LSfbttOa0CL3TmQvlSg1b7XIpPtxe4bpPyMnZPLYOt7OlDZI50/oue0IJi6AxU/ll8
         DwLsL6AIsW/2pHX9FZd2zEqgetCaaY5gKQCxJLYEbs0cV5GqczRX17Z2GfCRLhP+ryN2
         +IMgkhRGJNbYlWxFHLNIKlyWZTSMt241KWj2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8oo3XIzYkZafeuhie0WLhW1XKKw90P3tz4hdUKM8Yw=;
        b=NdeEtU/2jckyf0fy8phO/VHSRKdhHud/1vmZTLIri/KuZLCq8D4FNpFZESAtLy9+sh
         ctQlHbbM3prPjmN/3SCwaDM+Gn5dRJJh5jtwGxvfl8+wIXPBMMIyTikyiGpi57Z8Zbcw
         /8Yh3nx6LTlirzIsYf0jQAah8Zbu76GF3F63+UrNnCD24yQ5tgCUgTMonlkJl5SeK+t4
         V+yEfrkLUpJqLvrMuR9Z9vkkSiFGp0JAeIOfNVuxJ2ggMYqOuERhFom9YuJR37N6VBDc
         LBA1CAp2gyshmYBBd++CzzKm5XWDEUh8NNnqJ4fA1xQSke0TEgb54Xm23uwAXFYf/yak
         sd4w==
X-Gm-Message-State: AA+aEWa+I0lbvBxZK6pUjH5j1HhypibJM+8tvh5lMsM21WsRnz3FiZYQ
        iZBad/+XmusKHRKL71YhPFm1Zw==
X-Google-Smtp-Source: AFSGD/XFiVh8up3DsbBsTryQAmVxPNwWB10OlJWoi0H4lIDWq6Lwg8HvCoCPfYcVw998qZ7AkU/JcA==
X-Received: by 2002:a81:3558:: with SMTP id c85mr12994150ywa.34.1545050243148;
        Mon, 17 Dec 2018 04:37:23 -0800 (PST)
Received: from [10.176.51.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j2sm4629704ywa.73.2018.12.17.04.37.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Dec 2018 04:37:22 -0800 (PST)
Subject: Re: [PATCH] brcm: provide new firmwares for BCM4366 chipset
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Josh Boyer <jwboyer@kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
References: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com>
 <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
 <CACna6rwh9ri2ZfpTjCjZo3mBv0B3tr3Diesw3HJG+5ZVnAZxCQ@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <80b11c53-c630-bce7-d20d-88fef340aff4@broadcom.com>
Date:   Mon, 17 Dec 2018 13:37:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CACna6rwh9ri2ZfpTjCjZo3mBv0B3tr3Diesw3HJG+5ZVnAZxCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/17/2018 11:34 AM, Rafał Miłecki wrote:
> On Sat, 15 Dec 2018 at 12:03, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 12/14/2018 2:02 PM, Josh Boyer wrote:
>>> On Wed, Nov 7, 2018 at 3:45 PM Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> These firmwares are for the BCM4366 3x3 802.11 ac chipsets, which also comprise of BCM4366E or BCM43664 devices. Signed-off-by: Arend van Spriel
>>>
>>> This didn't add brcm/brcmfmac4366c-pcie.bin to WHENCE.  I'm assuming
>>> it's under the same license as the rest of the brcmfmac files?  If so,
>>> I can just amend the patch.
>>
>> Hi Josh,
>>
>> I was not sure this patch ever made it through. It did not appear on
>> linux-wireless list probably due to exceeding a size limit. So I resend
>> it as two patches on December 10th. However, I indeed forgot to update
>> the WHENCE file in that series as well. Indeed there is no license change.
> 
> Unfortunately I have only 1 device with 4366B1 (D-Link DIR-885L) and
> it seems to have dummy NVRAM restored from the bootloader's copy:
> 1:ccode=ALL
> 0:regrev=0
> 0:ccode=ALL
> 1:regrev=0
> 
> 1) Old fw 10.10.69.3309 (r610991) FWID 01-c47a91a4
> 2 GHz: very weak signal (about -79 dBm)
> 5 GHz: good signal & works stable
> (this also matches vendor firmware behavior)
> 
> 2) New fw 10.28.2 (r769115) FWID 01-801fb449
> 2 GHz: very weak signal (about -79 dBm)
> 5 GHz: good signal but huge packet loss
> 
> So the new firmware introduces 5 GHz regression for me, but I guess I
> should not complain since my device seems to come with a missing NVRAM
> regulatory info.
> 
> Is there any chance you know a correct ccode + regrev for D-Link
> DIR-885L for any region?

Hi Rafał,

That is bad news. Is the packet loss in receive or transmit direction? 
How do you obtain the info?

Regards,
Arend

