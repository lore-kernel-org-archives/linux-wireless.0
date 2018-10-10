Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9156C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 842172085B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aS3s1HN+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 842172085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbeJJPhB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:37:01 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54948 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJPhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:37:01 -0400
Received: by mail-wm1-f45.google.com with SMTP id r63-v6so4437145wma.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 01:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=/Hn8Uqn4Vfxfa4gPYkCZP6Jb4qa1EUDYZiTO20gjmgY=;
        b=aS3s1HN+HeLdqvFQKJsjHwx6ismvjfW9LIUWo8gUc2X4P9G6I410MGuZbmr3AUrO4L
         qZUhu8dACHrkOJcEyPIm8uTJhOVF52ezwPHoLU9MqKY6a/Pe0q/kh85Eq4Kj4qkSOR/d
         DSBO/J53U9Nwzf1oPvcHG1oqjl07o7oy6f7CY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=/Hn8Uqn4Vfxfa4gPYkCZP6Jb4qa1EUDYZiTO20gjmgY=;
        b=HVcXs0z37KxKLj4gfpwmIguoOcZgVawnrAzo4FJZYxt/k7R0jwtIa74TPTJrb3ubBd
         s9Ahn3Q1w/8C9dIOaQhYrmzZ9/yB7mVRu92nQDFKnvxXH/WEBcLzI/5IBOMWh7HujXm7
         qm7N0Oi9/kuIIzDaXV4B5oPX16ZsnjaQ17fRXjod88UkJR3YDH+qfPRYMVpMa9Wq704r
         3w95swN9LrNOvNiGxcsgCwnl7o7fMBWDD187gIvfMMDCPs5MRtbDz+BVjb7cBN4Hi62w
         NbbuepZW8bH1Gc7IykKEH4lBLAoGlbvWmEexyD5rHpuQvRqJyocGU3YX7P21eOoCgPfb
         3a0w==
X-Gm-Message-State: ABuFfoieBt/mDFUpWVHUVBO9BqvbIjHV1dBm8jF4kP0nhZMvVzXTLqE2
        7jCjVlJ2H72EYjVMSaLfi3r4SQ==
X-Google-Smtp-Source: ACcGV60vHXhQnYcR/wRHzRqOCJPAPGAHxoqop/K6SGOkWXAdNBpf0rj7+cQlGPVVwVfSRKJf9/QAxA==
X-Received: by 2002:a1c:d04e:: with SMTP id h75-v6mr4740744wmg.92.1539159358249;
        Wed, 10 Oct 2018 01:15:58 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id q200-v6sm17789822wmd.2.2018.10.10.01.15.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 01:15:57 -0700 (PDT)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
 <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
 <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
 <d714db41-f885-7724-6a2d-982a969bb4ab@redhat.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b2490334-b27b-aedb-dbb3-5cd746d93183@broadcom.com>
Date:   Wed, 10 Oct 2018 10:15:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <d714db41-f885-7724-6a2d-982a969bb4ab@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/10/2018 9:59 AM, Hans de Goede wrote:
> Hi Arend,
>
> On 10-10-18 09:52, Arend van Spriel wrote:
>> On 10/10/2018 9:28 AM, Hans de Goede wrote:
>>> So how do you want to proceed with this, do you want me to just
>>> put the full ISC text in the header for now as the rest of brcmfmac
>>> does?
>>
>> This is not entirely true as far as I know. I assume you are referring
>> to this:
>>
>> /*
>>   * Copyright (c) 2010 Broadcom Corporation
>>   *
>>   * Permission to use, copy, modify, and/or distribute this software
>> for any
>>   * purpose with or without fee is hereby granted, provided that the
>> above
>>   * copyright notice and this permission notice appear in all copies.
>>   *
>>   * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
>> WARRANTIES
>>   * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>>   * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE
>> LIABLE FOR ANY
>>   * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>>   * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
>> AN ACTION
>>   * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
>> OR IN
>>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>
>> As far as I recall we opted for BSD license and ISC is equivalent.
>
> I believe it is the other way around, you opted for the ISC license
> which is more or less equivalent to the 2 clause BSD, see:
>
> https://spdx.org/licenses/BSD-2-Clause.html
> https://spdx.org/licenses/ISC
>
> The ISC text is a 1:1 match to the license used in brcmfmac, and it seems
> sensible to me to be consistent and use the same license for all
> brcmfmac files even if the 2 are more or less equivalent.

Looking at the ISC text you are probably right. My recollection was from 
a verbal notification and the person telling probably was mistaken. So I 
am fine with a follow-up patch to change all files to use ISC SPDX tag 
once the ISC license is listed under LICENSES.

>
> Hans
>
> p.s.
>
> Any chance you could do a patch-review of this series?

Yup and test for regressions with some of the chipsets I have here.

Regards,
Arend
