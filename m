Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51504 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbCKPxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:53:54 -0400
Message-ID: <55006511.6020101@candelatech.com> (sfid-20150311_165357_712243_FCECFBE9)
Date: Wed, 11 Mar 2015 08:53:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] iw: Allow configuring empty legacy and ht ratesets.
References: <1426028412-17438-1-git-send-email-greearb@candelatech.com> <CALhHN=q0C0KWzTrjCztxcjLUjHKN8CXfBJG7o7AyU4gZgBfGRg@mail.gmail.com>
In-Reply-To: <CALhHN=q0C0KWzTrjCztxcjLUjHKN8CXfBJG7o7AyU4gZgBfGRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2015 11:10 PM, Janusz Dziedzic wrote:
> On 11 March 2015 at 00:00,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This allows one to configure exactly one rate for drivers
>> such as ath10k that will only allow a single rate to be
>> configured.
>>
> 
> Hello,
> 
> But iw already support setting single rate with ath10k.
> This is example from ath10k commit log:

Ahh, I see.  I was confused about what syntax to use for 'iw', must have
typo'd something early on and then though the limitation was in the parser.

Thanks,
Ben

> 
>     Example:
>     iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
>     will setup VHT, nss=2, mcs=9
> 
>     iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
>     will setup legacy, 18Mbps
> 
>     iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
>     will setup HT, nss=1, mcs=3
> 
>     iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
>     will setup nss=1
> 
>     iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
>     will setup nss=2
> 
> BR
> Janusz
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

