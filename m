Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52BEC43444
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 23:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A7C20659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 23:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iGAV4IVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfANXE2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 18:04:28 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33818 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfANXE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 18:04:28 -0500
Received: by mail-ed1-f66.google.com with SMTP id b3so1076206ede.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 15:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BNmodteYvLkrGWZgDlklg7A84Gv8ScHw/8FcsugVUkY=;
        b=iGAV4IVnWrv7uh4pUu5ck8V7AczKGX7QLwX2Q5p5UHQ02D1UW257p3njxdN8ak9V2A
         VejyRN3BZEJRG/YcG1BO8dXLdi5djlvVKstGGDMtQtQ2xsKK1CjFfA1IXCArlg74sDpX
         g7TZXe9ObS+rxRq025gCZIITdB0AJe389A9/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BNmodteYvLkrGWZgDlklg7A84Gv8ScHw/8FcsugVUkY=;
        b=iWKj7LnCA5ZkkhdZJkG+9S8UjLnhzJQcI3tyfvzoWivuv8mJTXkdZGI1h3Xy5ymMpZ
         ySrdxOfY88Rhs3iq3zC4iJ5Mzr1NVX+ezgq7xFvKY56GWbK4bf9iUj8ng1cK9TWjW5Hw
         6gFfSysieSiQPe5Yn0pezJS5DlhCvjPEZ/s1MNQJKT78mdgDFKnFgP4khma4N94MJFRV
         rn0TxeHDO5ZFZU5RCDxrha9+8Cc+06WRSODOu1TNbMzYwAFKMgqAZfntIvXhvFvCsieZ
         yILARvKzS9u2g0RgpcK/7cmxu4gi+115POzs+0EbfQ0qFM5gbOo63w8Ucb+GEVejXmf7
         wOkw==
X-Gm-Message-State: AJcUukf+9QBfXsBee5YUBUPEUys5ymUQ9Iz/DszPjmukdlhabmqjgzby
        INYGFphtn+lgkn3NUixmOlOc2g==
X-Google-Smtp-Source: ALg8bN4zaE1PsIbEceGwYUiUvAa5xFFimfrZb7okAiZX5UNVbt0AIju3abc53ZpdBXhtihBQQsAvNw==
X-Received: by 2002:a50:b667:: with SMTP id c36mr1115818ede.190.1547507065687;
        Mon, 14 Jan 2019 15:04:25 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id ec19-v6sm2581564ejb.11.2019.01.14.15.04.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 15:04:25 -0800 (PST)
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
To:     Denis Kenzior <denkenz@gmail.com>, Jouni Malinen <j@w1.fi>,
        Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
 <20190103154921.GA25015@w1.fi>
 <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
 <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
 <0490b8fa-bf8c-c76c-1367-70d0f4e3845f@broadcom.com>
 <206b5ae1-7fcf-9078-8399-2a8f9ff6c211@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d5599cf9-5fb4-a68d-dfd9-0d10a6758ae2@broadcom.com>
Date:   Tue, 15 Jan 2019 00:04:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <206b5ae1-7fcf-9078-8399-2a8f9ff6c211@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/14/2019 10:18 PM, Denis Kenzior wrote:
> Hi Arend,
> 
> On 01/14/2019 02:12 PM, Arend Van Spriel wrote:
>> On 1/8/2019 6:44 PM, Denis Kenzior wrote:
>>> Hi Arend,
>>>
>>>> However, there is more to it. When these offloads were introduced, 
>>>> we discussed about having a PORT_AUTHORIZED event or not. It was 
>>>> decided passing an attribute in CONNECT and ROAMED event would 
>>>> suffice and that is what was implemented in brcmfmac. However, it 
>>>> seems time passed and the need for an explicit PORT_AUTHORIZED was 
>>>> there (probably Denis knows), which wpa_supplicant now supports thus 
>>>> ignoring the attribute in the CONNECT and ROAMED events. The 
>>>> brcmfmac driver was not changed accordingly. For this there are 
>>>> patches pending in linux-wireless which are necessary to have a 
>>>> working connection.
>>>>
>>>
>>> Coming in a bit late to this discussion, but it does raise a few 
>>> points I wouldn't mind some clarification on:
>>>
>>> - With commit 503c1fb98ba3, the kernel effectively changed the 
>>> userspace API.  So I take it that breaking userspace APIs are OK 
>>> sometimes? If so, I have lots of suggestions to make ;)
>>
>> I bet you do :-p I think the rule of thumb is that there are no 
>> drivers providing the functionality behind the user-space API and/or 
>> no user-space applications are using that API.
> 
> Maybe this is a question for Johannes as well, but define 'user-space 
> applications'?  If that includes wpa_s, wasn't the rule of thumb broken 
> with that commit?

In my previous reply I wanted to add that it would be hard to proof that 
no user-space applications are using the API. Not sure exactly when 
things were added in wpa_s, but I suspect it was 
post-commit-503c1fb98ba3 so it did not have support for the user-space 
API before the commit.

>>
>>> - Is RTNL LINK_MODE / OPER_STATE status being (supposed to be?) 
>>> affected by the driver during a roam?  E.g. if we're in a 802.1X 
>>> network with userspace authentication, and driver roamed requiring a 
>>> new 802.1X auth, then in theory the RTNL mode needs to be brought 
>>> back out of UP state...
>>
>> So do you expect the driver/cfg80211 to take care of that or the 
>> supplicant? I assumed wpa_supplicant would be doing that.
>>
> 
> With regular roaming where we trigger a Deassociate/Deathenticate 
> (either explicitly or implicitly) first, the interface goes into dormant 
> mode by virtue of the carrier going down.
> 
> With this it isn't really clear whether the same is happening and who 
> (kernel/userspace) should be doing what.  I would actually assume the 
> kernel is/should be turning carrier off for the duration of the roam 
> operation?

On what layer do we know 802.1X re-auth is required?

>>> - The new API leaves a lot to be desired in terms of race conditions. 
>>> For example, how long should userspace wait for EAPoL-EAP packets to 
>>> arrive (before triggering its own EAPoL-Start for example) if a 
>>> CMD_ROAMED event comes?
>>
>> I think that question applies to CMD_CONNECT as well, right? Not sure 
>> if the specs provide any guidance for that. I can dive into that, but 
>> maybe someone like Jouni or Johannes know. If so, let me know ;-)
> 
> With CMD_CONNECT it is a bit more clear because you're most likely not 
> specifying a PMKID for the first time, so you expect the authentication 
> to happen in all cases.  If the AP doesn't respond after some small 
> timeout, the supplicant can send its own EAPoL-Start.
> 
> With CMD_ROAMED it is less clear.
> 
>>
>>> - What happens if userspace does send an EAPoL-Start in the middle of 
>>> an offloaded 4-way handshake?
>>
>> Probably those would be dropped.
>>
> 
> I would love to have something more definitive than 'Probably', and it 
> might be worth mentioning this hint in the documentation somewhere.

I was hesitant to use that word, but decided to do so simply because I 
can not speak for every driver and even for the brcmfmac driver that I 
maintain I will need to look into the firmware to be sure. I agree that 
a remark of that possibility is worth adding.

Regards,
Arend
