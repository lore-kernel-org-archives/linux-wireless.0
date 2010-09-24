Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0IXVtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:49:51 -0400
Received: by iwn5 with SMTP id 5so2694953iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 14:49:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9CEB3F.5090804@candelatech.com>
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com>
	<AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
	<4C9CEB3F.5090804@candelatech.com>
Date: Sat, 25 Sep 2010 00:49:50 +0300
Message-ID: <AANLkTi=B2-jqsempyBVM8MRud0P5zgHeN__CGJ+qjf99@mail.gmail.com>
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
From: Nick Kossifidis <mickflemm@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/24 Ben Greear <greearb@candelatech.com>:
> On 09/24/2010 10:46 AM, Nick Kossifidis wrote:
>>
>> 2010/9/23<greearb@candelatech.com>:
>>>
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> +#define ATH5K_VIF_MAX  2048
>>
>> This is too much !!! 2048 interfaces with a total of 4 beacon buffers
>> 40 rx buffers and 200 tx buffers ? Has anyone tested this ?
>>
>> Also think about embedded devices, we don't want to waste memory like
>> this...
>>
>>> +       struct ieee80211_vif *vifs[ATH5K_VIF_MAX];
>
> It only costs 4 or 8 bytes per pointer as long as no one actually
> adds the vifs.
>

If no one uses more than lets say 512 why have 1500+ pointers ?

> We've tested at least 128 on an old 1Ghz VIA system, and I'd hope for more
> on more modern hardware.  I didn't think the driver should make the decision
> to limit un-necessarily.
>

Have you tested it with multiple queues ? Bruno just added wme support
on ath5k. Also how about rx/tx/beacon buffers ? Are they enough to
support more vifs ? Note that we still have the "stuck queues" problem
and putting more pressure on the card might make things worse. All I'm
saying is that when we add a feature we have to be sure it works as
expected, if we claim to support 2048 vifs then we must test it first
and ensure it can work without issues.

> If you still think this is too much, then tell me the biggest number
> you wouldn't complain about :)
>
> Thanks,
> Ben
>

lets go for 512 and see how it goes...



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
