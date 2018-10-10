Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F67AC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D35042064E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:01:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D35042064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJJPWD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:22:03 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37590 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJPWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:22:02 -0400
Received: by mail-wr1-f44.google.com with SMTP id y11-v6so4558007wrd.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 01:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G16M81krlbD8TYV9FzG3teUW+AL0SLKWN//nXj7tSUA=;
        b=VRQW+IgmylTSqXt1TyZ/urTK5LOBWufE2jSVPZHouW8oHbQOX2eOkRz7Rp/W34CKpL
         1/lAmOsdVHuyPgGcB8P++qFMskUGT8fcSVNvbdYlJX5lvWoe+kazACsa9Q3tdSaYVIsA
         vaIwdZCbYuGD60tna+Z+aQQtl9K9JBdAqQfyClqIexK/aobYQWcN2YWnyBj5Wmit6Zqf
         bIudX+SzHOG2g9hQnMCGDodvwZWFSSYeBeJDPGa8OiVoNtIAEfVQFtfo/hSgxMFwcPWe
         eE9IVKmoUI1079/lp0JjVwqpPGLMgQtPZGEr45innUY+GxLXUNlJwgJJLHhUQU0spr47
         ZKGQ==
X-Gm-Message-State: ABuFfoilR10b5+bFzK6jOS2x03Sf4hHsNmrgP55Cnwood82TVVovQPc4
        vhsFZPcvyrqXMJUj8w6Wv/iJZRhDNGM=
X-Google-Smtp-Source: ACcGV6164qvH560cqhpmikNWdEINrZadQPEEX7xMVQHreEprFg49kzR6PsHZ8h8EFO9VFpRzuW4cAQ==
X-Received: by 2002:a5d:4605:: with SMTP id t5-v6mr21170920wrq.52.1539158462484;
        Wed, 10 Oct 2018 01:01:02 -0700 (PDT)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id a18sm16954075wrx.55.2018.10.10.01.01.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 01:01:01 -0700 (PDT)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
 <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
 <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
 <87efcyxmh7.fsf@codeaurora.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <447d2c63-68c9-d3e0-c481-52978a25dade@redhat.com>
Date:   Wed, 10 Oct 2018 10:01:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <87efcyxmh7.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-10-18 09:57, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
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
>>   * Permission to use, copy, modify, and/or distribute this software for any
>>   * purpose with or without fee is hereby granted, provided that the above
>>   * copyright notice and this permission notice appear in all copies.
>>   *
>>   * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>>   * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>>   * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
>> FOR ANY
>>   * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>>   * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
>> AN ACTION
>>   * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>
>> As far as I recall we opted for BSD license and ISC is equivalent.
> 
> Oh, sorry for missing that.
> 
>> However, The BSD license are already in place so why not use that. I
>> would say BSD-2-Clause should cover it. As this is a new file I guess
>> it is up to you although I would prefer to stick with a permissive
>> license.
> 
>  From maintainer's point of view I very much prefer that a driver uses
> the same license in all files. It's very confusing if the license
> changes within different files.

Ack, I will just copy over the header from other brcmfmac files for v2
of the series. Which FWIW is a 1:1 copy of:

https://spdx.org/licenses/ISC

(I checked before setting the SPDX tag)

Regards,

Hans

