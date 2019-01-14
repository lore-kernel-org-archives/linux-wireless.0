Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3054C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 21:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B072420656
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 21:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGa3Wc5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfANVS7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 16:18:59 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37041 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfANVS7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 16:18:59 -0500
Received: by mail-oi1-f195.google.com with SMTP id y23so446418oia.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 13:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tQl8Hpp2kmJgS5EnCdGvw2T46brZQ9oCXA8LPEjNaek=;
        b=CGa3Wc5xUKmJ4KbROTYw5tGDtTwcA0/NuxQV4pFxynfHlZFPon/WMzeWv/G2yybesY
         q3VyRaAzk+perfVyAB2SDW0VZImGZ4FSFTsj/ZERwNoHHvQOCBgHfmw9BY60VYTfSddM
         y4hxK0gF7TTRf0Hzc6qRaC9xVxEr/134DBBz2XCqt3di7yA6wg3EhRYLDjQQ6vqL4jUv
         r74RVfOWc4UnhXZGmz0lQpXJ6LyymIHVhpO5CkZub4nkOSRiRKYgiFmRcwoL+969VicA
         25AePoJpILemstUGA+pSnLfFvOvqRY+Td8Ca5CHXUHfe+oP9GwZjfdNRWUCTsyYHZy0f
         1OMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQl8Hpp2kmJgS5EnCdGvw2T46brZQ9oCXA8LPEjNaek=;
        b=r0IOFALvTm0ouuqYDaLNPGuXrMQDmyg0F59N7mUDWSi2pYYwfpR8o8OkYPr+yn6ctk
         fTlUxjbrjIK7ciw9FeH/dMlfFzBSmoYSRZHuTurzIJiMaBuU6Joq/ItLQAN6w72Q47LE
         RiMo9bqT7kn4Byiko/S9SOft/+Vj72O2QFASbjI5aSss9JQ9WZJcchzd+E1XlgpvM/2z
         eky3+vLsyCTI8m33XGuYoDtGit++BsA9Z95OabbRxiv5jmibk14nBRV+QqyWigrLn308
         nZWIP1vpCtCqTu3fy0ugxaUhz80WIENITrt0aCYK7BclvtfPYvgFBUAcHMNGOXgYXu9o
         DI7g==
X-Gm-Message-State: AJcUukfLselAay3fQoTVx5Ew2T04BblNy11ZE82lnxmxJBGsOMu9DEtj
        rMYwDUoPKMe9sDPFBjt9/JI=
X-Google-Smtp-Source: ALg8bN4m0nPFf9SzLz2i7MLVqLxdTZdQ4wIUdGirVv+mX+kbVyMjCRhk6QSrkn8oTLqsXIdzoJ01PQ==
X-Received: by 2002:aca:3f42:: with SMTP id m63mr221832oia.270.1547500738377;
        Mon, 14 Jan 2019 13:18:58 -0800 (PST)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id v1sm608375otq.80.2019.01.14.13.18.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 13:18:57 -0800 (PST)
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>, Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
 <20190103154921.GA25015@w1.fi>
 <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
 <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
 <0490b8fa-bf8c-c76c-1367-70d0f4e3845f@broadcom.com>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <206b5ae1-7fcf-9078-8399-2a8f9ff6c211@gmail.com>
Date:   Mon, 14 Jan 2019 15:18:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <0490b8fa-bf8c-c76c-1367-70d0f4e3845f@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

On 01/14/2019 02:12 PM, Arend Van Spriel wrote:
> On 1/8/2019 6:44 PM, Denis Kenzior wrote:
>> Hi Arend,
>>
>>> However, there is more to it. When these offloads were introduced, we 
>>> discussed about having a PORT_AUTHORIZED event or not. It was decided 
>>> passing an attribute in CONNECT and ROAMED event would suffice and 
>>> that is what was implemented in brcmfmac. However, it seems time 
>>> passed and the need for an explicit PORT_AUTHORIZED was there 
>>> (probably Denis knows), which wpa_supplicant now supports thus 
>>> ignoring the attribute in the CONNECT and ROAMED events. The brcmfmac 
>>> driver was not changed accordingly. For this there are patches 
>>> pending in linux-wireless which are necessary to have a working 
>>> connection.
>>>
>>
>> Coming in a bit late to this discussion, but it does raise a few 
>> points I wouldn't mind some clarification on:
>>
>> - With commit 503c1fb98ba3, the kernel effectively changed the 
>> userspace API.  So I take it that breaking userspace APIs are OK 
>> sometimes? If so, I have lots of suggestions to make ;)
> 
> I bet you do :-p I think the rule of thumb is that there are no drivers 
> providing the functionality behind the user-space API and/or no 
> user-space applications are using that API.

Maybe this is a question for Johannes as well, but define 'user-space 
applications'?  If that includes wpa_s, wasn't the rule of thumb broken 
with that commit?

> 
>> - Is RTNL LINK_MODE / OPER_STATE status being (supposed to be?) 
>> affected by the driver during a roam?  E.g. if we're in a 802.1X 
>> network with userspace authentication, and driver roamed requiring a 
>> new 802.1X auth, then in theory the RTNL mode needs to be brought back 
>> out of UP state...
> 
> So do you expect the driver/cfg80211 to take care of that or the 
> supplicant? I assumed wpa_supplicant would be doing that.
> 

With regular roaming where we trigger a Deassociate/Deathenticate 
(either explicitly or implicitly) first, the interface goes into dormant 
mode by virtue of the carrier going down.

With this it isn't really clear whether the same is happening and who 
(kernel/userspace) should be doing what.  I would actually assume the 
kernel is/should be turning carrier off for the duration of the roam 
operation?

>> - The new API leaves a lot to be desired in terms of race conditions. 
>> For example, how long should userspace wait for EAPoL-EAP packets to 
>> arrive (before triggering its own EAPoL-Start for example) if a 
>> CMD_ROAMED event comes?
> 
> I think that question applies to CMD_CONNECT as well, right? Not sure if 
> the specs provide any guidance for that. I can dive into that, but maybe 
> someone like Jouni or Johannes know. If so, let me know ;-)

With CMD_CONNECT it is a bit more clear because you're most likely not 
specifying a PMKID for the first time, so you expect the authentication 
to happen in all cases.  If the AP doesn't respond after some small 
timeout, the supplicant can send its own EAPoL-Start.

With CMD_ROAMED it is less clear.

> 
>> - What happens if userspace does send an EAPoL-Start in the middle of 
>> an offloaded 4-way handshake?
> 
> Probably those would be dropped.
> 

I would love to have something more definitive than 'Probably', and it 
might be worth mentioning this hint in the documentation somewhere.

Regards,
-Denis
