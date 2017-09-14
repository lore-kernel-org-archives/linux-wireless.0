Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51050 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdINWPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 18:15:31 -0400
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
 <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
 <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com>
 <5436d106-0b4a-9158-58bf-ff84b231cd19@candelatech.com>
 <c97ecdb4-fe7a-e79a-d73e-32166beb1e11@gmail.com>
 <8a26a838-adde-08f1-5f64-c98e1d947675@candelatech.com>
 <756be45c-fd13-56a7-b8d4-129c4fd07dc8@gmail.com>
 <c33e5aed-be5a-890d-cc50-b5ac87b40d9a@candelatech.com>
 <5ec7a05e-dfa4-37e0-b108-51ca0885b9a7@gmail.com>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <038474b0-4d37-9bb7-ebf0-b92564abf5af@candelatech.com> (sfid-20170915_001535_963254_8D0B77A0)
Date: Thu, 14 Sep 2017 15:15:29 -0700
MIME-Version: 1.0
In-Reply-To: <5ec7a05e-dfa4-37e0-b108-51ca0885b9a7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 02:35 PM, Denis Kenzior wrote:
> Hi Ben,
>
>>> I think it is sane to assume that the IP address _should_ be the same. The 802.11 spec expects this even.  This is to handle bizarre networks that don't do this
>>> properly.
>>
>> Can you point me to the section in the spec about this?
>>
>
> Lets see, 802.11-2012, Section 4.3.4.2:
> "The key concept is that the ESS network appears the same to an LLC layer as an IBSS network. STAs within an ESS may communicate and mobile STAs may move from
> one BSS to another (within the same ESS) transparently to LLC."
>
> Section 4.5.3.2,

Thanks for the pointer.

It looks to me like having same SSID/auth is a requirement to be in the same ESS, but
just having the same ESSID/auth does not mean it is definitely in the same ESS.

> etc.
>
>>>> If not, how is this different from just re-doing DHCP like normal?
>>>>
>>>
>>> You get to use your old IP address.  So e.g. your VoIP call doesn't disappear if you decide to switch access points.
>>>
>>>> And if so, you will in some cases be allowing duplicate IP addresses on
>>>> a network?
>>>>
>>>
>>> Life is never perfect ;)
>>
>> If you are breaking networks while trying to optimize something, then I think you
>> are going about it wrong.
>>
>> Seems like we would need some way for the DHCP server and/or AP to proactively
>> notify the station that they can skip DHCP, and default to not skipping.
>
> Not unless you're planning to extend the spec?  802.11 doesn't even mention DHCP in any real manner.

So, it could be given out by the DHCP server then.  There are ways to add custom
options to it, right?

User-space can remember the option and use that to decide whether to re-do DHCP
when a station roams to another AP in (the probable) same ESS.  Since this is
a new option, you should not have backwards-compatibility issues.

>> I vaguely recall that FT had some way to verify you were roaming to the same dhcp-domain
>> or not, but honestly, it has been a long time since I read through that...
>>
>
> Do you mean a mobility domain?  This has nothing to do with DHCP...

It seems to be a very convenient way to identify a group of APs that share
common infrastructure, more so that just having the same SSID/auth...

Do you think there would ever be a mobility domain that did not share
a common DHCP server pool?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
