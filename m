Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B82BC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BBB620645
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ioY15Bv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbfAOPzJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 10:55:09 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:34597 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729807AbfAOPzI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 10:55:08 -0500
Received: by mail-oi1-f176.google.com with SMTP id r62so2510571oie.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 07:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bUlAhuh4fPWTXUDh7nnHQoEXmWAqc2nYLZ0cpj0RHDY=;
        b=ioY15Bv84WuxYzR0lNOIPUHzJitK9ruQvMXhpe3gmlhGohzc33UfWjBJ26hTRQYo4w
         UPfSFOAEOpZBbiDbD/7M+x9oqqV2zOJHJKNmcnyRVJKq4mzv/IUJOZmHr1tXYY79NcyJ
         V9yLMk+gIU7+5X8NXSgBNQf54DtEinHsuvFhTJLNGkn2oxZAQEDqfsJ9+d1IurIXwusS
         BOlrQzCi019sI0NE18sPL792LNY+jLIlM0D+gKwTi2RHI3lCcWMzPA2SgYyQi4lsh8R4
         4ty0RzTcFwdisrhbbUg3aN8kFXgDucOcV0ktkzOH/UbmzULrehZB7WvZH11VmjEmnW2L
         tZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bUlAhuh4fPWTXUDh7nnHQoEXmWAqc2nYLZ0cpj0RHDY=;
        b=XZR0Jn7XXjtsh4AYZhnMPy44RNFhsKujC0WiIRqTfIci+tv0SsgRHZA4q9SWZOYUuX
         VpwJlc1hH3rQiq8jp8H+Eqo5gEEM1GsJe+sRyZywo+2LZq99Z7YaJukOAJYtvZMw+uwV
         yo1ZYQw7BalEX3AgQr+q/C6BGzxdo32BxEZd0fUhlIKnEziPz5etjI04OrpvR7B8Qvf0
         RdKZKp4T0ogoRQ5Go1SnhtZS8VdNScJvezAI1Mqr6mZeBDRP3MCTA63Dh3IDF+zSm7gJ
         y4jpzZ+UDGfk/PLqwMKincuIndjUtfc6DBEW5OWKVWM0GWWNwbc7v3PO4X0vss7NVxsp
         CSdA==
X-Gm-Message-State: AJcUukdJ6f/t+iG9NykeDXZ9MGUbIoMLbm4qjStLH27MvWoxhqDZVfel
        C5Ay4pYk8TZ6V4b7GptMg/s=
X-Google-Smtp-Source: ALg8bN5ROJ9h7p+j2bb9bSbQrlep3UarMyeHjy40GVcGXMLyiGSH8rRBvsSkYJNUkzYMG6ZhnZ6rEQ==
X-Received: by 2002:aca:dd88:: with SMTP id u130mr2261953oig.204.1547567707531;
        Tue, 15 Jan 2019 07:55:07 -0800 (PST)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id h24sm1790889otm.72.2019.01.15.07.55.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 07:55:06 -0800 (PST)
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
 <206b5ae1-7fcf-9078-8399-2a8f9ff6c211@gmail.com>
 <d5599cf9-5fb4-a68d-dfd9-0d10a6758ae2@broadcom.com>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <3010fb21-f8c4-640d-782c-328ca6c21b2a@gmail.com>
Date:   Tue, 15 Jan 2019 09:55:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <d5599cf9-5fb4-a68d-dfd9-0d10a6758ae2@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

>>>
>>>> - Is RTNL LINK_MODE / OPER_STATE status being (supposed to be?) 
>>>> affected by the driver during a roam?  E.g. if we're in a 802.1X 
>>>> network with userspace authentication, and driver roamed requiring a 
>>>> new 802.1X auth, then in theory the RTNL mode needs to be brought 
>>>> back out of UP state...
>>>
>>> So do you expect the driver/cfg80211 to take care of that or the 
>>> supplicant? I assumed wpa_supplicant would be doing that.
>>>
>>
>> With regular roaming where we trigger a Deassociate/Deathenticate 
>> (either explicitly or implicitly) first, the interface goes into 
>> dormant mode by virtue of the carrier going down.
>>
>> With this it isn't really clear whether the same is happening and who 
>> (kernel/userspace) should be doing what.  I would actually assume the 
>> kernel is/should be turning carrier off for the duration of the roam 
>> operation?
> 
> On what layer do we know 802.1X re-auth is required?
> 

Not sure what you mean by 'layer'?  If re-auth is required, then only 
the supplicant has the proper info and it will handle this via EAPoL frames.

But that is besides the point.  Regardless of whether a roam needs 
re-auth or not, network interface dormant notification is needed.  For 
example: userspace DHCP clients need to know when to renew the address. 
And yes, there are weird networks out there that expect you to 
re-negotiate your DHCP address on a roam.  Such clients are not 
integrated in any way with a supplicant and rely on rtnl.

Regards,
-Denis
