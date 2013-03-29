Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4363 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab3C2NzT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 09:55:19 -0400
Message-ID: <51559A4A.6050308@broadcom.com> (sfid-20130329_145523_291811_529FA36A)
Date: Fri, 29 Mar 2013 14:42:34 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Greear" <greearb@candelatech.com>
cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"Felix Fietkau" <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication
 from user-space
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
 <1364487476.10397.23.camel@jlt4.sipsolutions.net>
 <5154B347.9080904@broadcom.com>
 <1364506118.10397.29.camel@jlt4.sipsolutions.net>
 <1364510577.3226.7.camel@dcbw.foobar.com>
 <1364510646.10397.81.camel@jlt4.sipsolutions.net>
 <1364511671.3226.22.camel@dcbw.foobar.com>
 <5154D286.4040001@candelatech.com>
In-Reply-To: <5154D286.4040001@candelatech.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2013 12:30 AM, Ben Greear wrote:
> On 03/28/2013 04:01 PM, Dan Williams wrote:
>> On Thu, 2013-03-28 at 23:44 +0100, Johannes Berg wrote:
>>> On Thu, 2013-03-28 at 17:42 -0500, Dan Williams wrote:
>>>
>>>>> Well, you can do DHCP a second or so, I'd think? And EAPOL much
>>>>> quicker,
>>>>> of course. I don't really see any reasonable minimum time? We might
>>>>> want
>>>>> to enforce a max though, maybe.
>>>>
>>>> Not quite.  A lot is dependent on the server itself, and I've had users
>>>> on university and corporate networks report it sometimes takes 30 to 60
>>>> seconds for the whole DHCP transaction to complete (DISCOVER, REQUEST,
>>>> OFFER, ACK).  Sometimes there's a NAK in there if the server doesn't
>>>> like your lease, which means you need another round-trip.  So in many
>>>> cases, it's a couple round-trips and each of these packets may or may
>>>> not get lost in noisy environments.
>>>
>>> Oh, yes, of course. However, we're talking about optimising the good
>>> cases, not the bad ones. Think of it this way: if it goes fast, we
>>> shouldn't make it slow by putting things like powersave or similar in
>>> the way. If it's slow, then it'll still work, just slower. But when
>>> "slower" only means a few hundred milliseconds, it doesn't matter if
>>> everything takes forever (30-60 secs)
>>
>> True, but at least 4 or 5 seconds is the minimum time I'd recommend here
>> for DHCP.
> 
> Couldn't dhcp just turn off the critical protection as soon as it is done?

That is the idea. It just seemed sane to have some minimum specified,
but I guess its value depends on the protocol that needs protection as
this API is not limited to DHCP. I will remove the minimum.

Also I think DHCP should not use the API to protect the whole
transaction, but only when there is a message exchange being initiated.

> Then, you only need to worry about the max time allowed.

True, but I think that also depends on the protocol and possibly also on
the solution in the driver to increase a more reliable connection. Some
solution may have a negative effect on other functions (eg. bluetooth)
which require another maximum timeout opposed to suppressing a scanning.
With DHCP in mind I would say somewhere between 5-10 sec. is (more than)
enough.

> Also, you would probably need to enforce in the kernel that only
> x out of y time in any given period can be locked, otherwise lots
> of different dhclient processes (perhaps erroneously spawned..or
> running on lots of different VIFs) could basically disable scanning
> or channel changes...

True. Will try to come up with some sane solution for this.

Gr. AvS

