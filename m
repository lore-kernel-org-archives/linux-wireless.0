Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F138C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58FC920868
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bQDUI4jP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfDPHeF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:34:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41176 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbfDPHeF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 03:34:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id f6so9890548pgs.8
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 00:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PS1X0G2OdMF4oZfqvVfHEM2wZlkTitVOneaOsl1od20=;
        b=bQDUI4jPDs8uF+x+8lmPfGVIbbbXpjAJcMzcnmiqFnNclYROzDRZpYGVbv5VEXZ+TG
         nuQcV8uTPiJ/pJ+yAP1x6XPbR2lVFizRaMKdVlvs5luOQwEBkxWK0CCW4mKe56l0LnDh
         hmi6VNmDpMWIeG+m6/CB7/Bbn+1zNtIB002Zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PS1X0G2OdMF4oZfqvVfHEM2wZlkTitVOneaOsl1od20=;
        b=srmDavBx6Izikrb5FdUNIjcQVPkK3TzSbiClmalL6Op3gxb3Lff+bv+wsluwP8d5vM
         Y8CdZMMUqOJFvUSp3ZhlIhjtMO4lT6I4PEoY0CdQnjloN0j4wWgtM1UFYnsgZHL1xsoi
         R7kEa8YSmyMb8XRJDkLq/XtUi/qJyrlYzp6L4zwmrgy7EkROH+zihgZZ+X8a3wlO1RMG
         FRfI+PhTFjCG6pYRNjFtq9zqKqbhtdlGL+yS2v5mXDIOmFnuIcX8yFj8Vxr1vFRngXff
         vjP0u8kXH/FJkPAPIYWuzjz1iN5qDW8C1klwWOaxd9wTfxNvJwGjuLvFlKcuhVh7tMrw
         xnpg==
X-Gm-Message-State: APjAAAXDB1dhLt6Wc3UEUVtvFC2FQaUppbRmYRs2SHGjH6LweKkC4cmv
        gtKaTtoXWdpbpKpkKW4PKXFnvg==
X-Google-Smtp-Source: APXvYqxDuUQpL2CZJuPDVh25uarOVEFfZNSNo82IwxHS/wp4B0hoQzFhE+DJEUXwEuP7ItUTlhtfQg==
X-Received: by 2002:a65:500d:: with SMTP id f13mr75732114pgo.250.1555400044313;
        Tue, 16 Apr 2019 00:34:04 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z21sm71924529pfn.139.2019.04.16.00.34.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 00:34:03 -0700 (PDT)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <e912d736-a3ad-1e21-0cdd-6a065df96fbb@nbd.name>
 <16a1bd77c20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Message-ID: <2e440cc1-d085-ff35-819c-d639cda3d894@broadcom.com>
Date:   Tue, 16 Apr 2019 09:34:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <16a1bd77c20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/14/2019 2:34 PM, Arend Van Spriel wrote:
> On April 14, 2019 1:19:49 PM Felix Fietkau <nbd@nbd.name> wrote:
> 
>> On 2019-04-14 11:44, Arend Van Spriel wrote:
>>> + Herbert
>>>
>>> On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>>
>>>>> When using iTXQ, tx sequence number allocation and statistics are 
>>>>> run at
>>>>> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, 
>>>>> which
>>>>> allows tx handlers to run on multiple CPUs in parallel.
>>>>
>>>> Cool, didn't know about that flag.
>>>
>>> It is water under the bridge as this patch got applied already, but I
>>> stumbled upon it just recently and didn't know about that flag either.
>>> So I looked for more information about it and found the definition [1],
>>> but the comment seemed important enough to send this reply.
>>>
>>>     NETIF_F_LLTX_BIT,    /* LockLess TX - deprecated. Please */
>>>                 /* do not use LLTX in new drivers */
>>>
>>> Here is the commit that marked it deprecated:
>>>
>>> commit e24eb521fbf2a350ce879dfc1d8e56d4ffa2aa22
>>> Author: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Date:   Tue Sep 25 19:42:02 2007 -0700
>>>
>>>      [NET]: note that NETIF_F_LLTX is deprecated
>>>
>>> So I am not sure we should really do this in mac80211. Maybe Herbert can
>>> comment although it has been over a decade ago.
>> There is a lot of comparable code that also uses this flag, e.g.
>> batman-adv, bridge, vlan, various tunnel implementations. I think
>> mac80211 fits well with those kinds of use cases.
> 
> Ok. As said I was not sure so I can/will not argue.
> 
>> If I remember correctly, the deprecation was added to avoid quirky
>> custom locking schemes in ethernet drivers.
> 
> What do you mean by "quirky custom locking schemes"? You mean that TX 
> path would use driver data that should actually be accessed under some 
> lock?
> 
> When seeing the deprecated comment I wanted to know the why and was 
> hoping the commit message would divulge. It just mentions it is not 
> needed. So now I am curious as to why it wouldn't be needed especially 
> as you say there are (valid) use-cases in the kernel today.

Getting back to this in an attempt to clarify my question. So from what 
Felix is saying the NETIF_F_LLTX flag is not deprecated, but restricted. 
What I would like to know is what exactly is required from a driver to 
allow the use of this flag.

Regards,
Arend
