Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46332 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdINTi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:38:29 -0400
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
 <1505389462.31630.6.camel@sipsolutions.net>
 <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
 <1505416658.31630.15.camel@sipsolutions.net>
 <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com> (sfid-20170914_213833_256781_FC99E7DD)
Date: Thu, 14 Sep 2017 12:38:29 -0700
MIME-Version: 1.0
In-Reply-To: <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 12:34 PM, Denis Kenzior wrote:
> Hi Johannes,
>
> On 09/14/2017 02:17 PM, Johannes Berg wrote:
>> On Thu, 2017-09-14 at 13:37 -0500, Denis Kenzior wrote:
>>
>>> The question is whether all APs are actually sane after a
>>> roam.  E.g. can the STA assume that the same IP address, DHCP lease,
>>> etc is still valid?  I heard from various people that this might not
>>> be the case, but we haven't had a chance to verify those claims...
>>
>> I think you pretty much have to assume that, otherwise there's no point
>> in roaming at all - you want your connections to stay, possibly voice
>> calls to continue, etc.
>
> I'm all for using this assumption.  I just wonder if real world disagrees? :)

There are different meanings for 'roam'.  Are you just talking about
fast-transition roaming?

I would think that the decision to restart DHCP (at least ipv4) should
be in user-space.  I'm less sure about how IPv6 should deal with this.

I have tested roaming using FT and normal-ish wpa_supplicant without
doing DHCP, and it works fine.  Of course, it also works if you
choose to re-do DHCP.

Thanks,
Ben

>
>> However, I'm not really convinced (any more) that this is actually
>> correct. If I'm reading the supplicant code correctly, then it sets
>> IF_OPER_UP only once the connection is *completed*, so it's already
>> doing what I thought it should be doing and couldn't.
>>
>
> Yes.  For a new connection it does something like:
>
> New Key
> Set Key
> New Key (group)
> Set Station (Authorized) (which fails on some drivers)
> Set OperState to UP
>
> Regards,
> -Denis
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
