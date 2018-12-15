Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E39DC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 11:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CD0206BA
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 11:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FKblXqGd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbeLOLCM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 06:02:12 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44201 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbeLOLCM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 06:02:12 -0500
Received: by mail-ed1-f65.google.com with SMTP id y56so6960615edd.11
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2018 03:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/a/8OhzVtZF1ohU0m8ghNYplN/7NQYvmo6xnkKcATFI=;
        b=FKblXqGdNdg9rTtucWjuEr4ghJqgZut9Ftgy02xd9mPNyXLwGbhQn+ITKcUt3ncxJZ
         q6iII8vc5WWVbzCdp7zVni4T+ep5EUxLW5wRckPEsIQJJzcuQ8e0DPbvb1BWN5L67rQN
         9N24Cc5pSdHHAtON3fjFOhALS0x2plirfsK9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/a/8OhzVtZF1ohU0m8ghNYplN/7NQYvmo6xnkKcATFI=;
        b=tQxOQRftAvsXHjrncVdu2PjsCTwhNcbo2xlyKfzkS8loQC7hzpAKsML76eei5NskRY
         KZNjI61UYhC9k2iaP93Ra8UBxZWauSvPZiALGfDDgEBnFogqVnutWRNMjADglXfy/WED
         NUKKw1BxMFbJVx/Pw717lJ3P2MBcBB/ORMtJEeTYePjOUH9ffZ796m38SfHKVDEMSMIa
         YM2zHDUsBuDvxpXkZ/0m1ayCpYoSXAXKuuG4wZImbaF9gugL9OThVb9VY/RN+1YNXx0H
         CohSy/F6IzdCGKrCptNBGwtsrFHYcfL8UShKKvKY4yZ+W8jSL5uvmQUKG+IBKMMzGTJ5
         +TdA==
X-Gm-Message-State: AA+aEWbno0D4HvBxnMjyQ12DiR5r2GJ1wtb8Vv0gDQgQIhvT/uCsxogi
        3FAab3A9xAHjprJtw5ZRC3bmsC8B7hWOAg==
X-Google-Smtp-Source: AFSGD/VkPeNmXXjBHoDzAeyK30Ao1nSE1ppSp1IW4obI1bZOWF+qL58rMpmUbfvVAlLPIpV5/OQ1cw==
X-Received: by 2002:a50:ade7:: with SMTP id b36mr5862269edd.215.1544871730056;
        Sat, 15 Dec 2018 03:02:10 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id r51sm2285620eda.64.2018.12.15.03.02.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Dec 2018 03:02:08 -0800 (PST)
Subject: Re: [PATCH] brcm: provide new firmwares for BCM4366 chipset
To:     Josh Boyer <jwboyer@kernel.org>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
References: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
Date:   Sat, 15 Dec 2018 12:02:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/14/2018 2:02 PM, Josh Boyer wrote:
> On Wed, Nov 7, 2018 at 3:45 PM Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> These firmwares are for the BCM4366 3x3 802.11 ac chipsets, which also comprise of BCM4366E or BCM43664 devices. Signed-off-by: Arend van Spriel
> 
> This didn't add brcm/brcmfmac4366c-pcie.bin to WHENCE.  I'm assuming
> it's under the same license as the rest of the brcmfmac files?  If so,
> I can just amend the patch.

Hi Josh,

I was not sure this patch ever made it through. It did not appear on 
linux-wireless list probably due to exceeding a size limit. So I resend 
it as two patches on December 10th. However, I indeed forgot to update 
the WHENCE file in that series as well. Indeed there is no license change.

Regards,
Arend
