Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E08C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12CB92064E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12CB92064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbeJJPU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:20:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55863 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJPU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:20:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id 206-v6so4373461wmb.5
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 00:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCLVxJpR0EjXaSGLfmaeF8kD1I3qO93ftJiNC9eUmIs=;
        b=qAJi1siwzIYliknl+QNe7nojv7DyimCVGhsNgbF+y9f1pmkr3uQGFW3ogFURuFvtpG
         drj20tRyky2EbztSUpT9y950e21h2qfRVUx9olchgdnxMNyOhAE8laVVfspq0Tku1F9l
         2iUVqDw+Kn5N4z4nh6P9dqQTsPrNgzJyCrSyHCGvGJK0SmrSQNciOHJqK700oi6G4rG9
         AN6MMNGiyErFbTY8nu9BxxAXEmH2ya1rdAqGVVJPORH9zPv+17zGdGme+MVuMqRSOBw7
         lB2hJqx6gwPoUAguDUJx1MWyiy/WY0zHtrDUdpstT4lhEr5Pur8Lc0ndIQXh2ZAG9ZfN
         aTjw==
X-Gm-Message-State: ABuFfohilOZqXXQw1Yd8KSVI0QQooOJN0EVEuuxH1wHEHLPkAo857mlm
        7WnCE5YEFUdmrzKi30VssvoB1RAHovE=
X-Google-Smtp-Source: ACcGV61qvsVkrFw4C8B4g8dAl+GG6iKL8z2mSFmUv7/R0joBeCISbIGoURBvQVBcmwUdsRXRWEBNdw==
X-Received: by 2002:a1c:6:: with SMTP id 6-v6mr4383222wma.126.1539158366948;
        Wed, 10 Oct 2018 00:59:26 -0700 (PDT)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id 64-v6sm24206340wrr.64.2018.10.10.00.59.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 00:59:26 -0700 (PDT)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
 <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
 <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <d714db41-f885-7724-6a2d-982a969bb4ab@redhat.com>
Date:   Wed, 10 Oct 2018 09:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

On 10-10-18 09:52, Arend van Spriel wrote:
> On 10/10/2018 9:28 AM, Hans de Goede wrote:
>> So how do you want to proceed with this, do you want me to just
>> put the full ISC text in the header for now as the rest of brcmfmac
>> does?
> 
> This is not entirely true as far as I know. I assume you are referring to this:
> 
> /*
>   * Copyright (c) 2010 Broadcom Corporation
>   *
>   * Permission to use, copy, modify, and/or distribute this software for any
>   * purpose with or without fee is hereby granted, provided that the above
>   * copyright notice and this permission notice appear in all copies.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>   * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>   * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
>   * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>   * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
>   * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
> 
> As far as I recall we opted for BSD license and ISC is equivalent.

I believe it is the other way around, you opted for the ISC license
which is more or less equivalent to the 2 clause BSD, see:

https://spdx.org/licenses/BSD-2-Clause.html
https://spdx.org/licenses/ISC

The ISC text is a 1:1 match to the license used in brcmfmac, and it seems
sensible to me to be consistent and use the same license for all
brcmfmac files even if the 2 are more or less equivalent.

> However, The BSD license are already in place so why not use that. I would say BSD-2-Clause should cover it. As this is a new file I guess it is up to you although I would prefer to stick with a permissive license.

I've no problem with a permissive license, I will just stick with
the ISC / same header as the rest of brcmfmac for consistency.

Regards,

Hans

p.s.

Any chance you could do a patch-review of this series?

