Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4440 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3C2LjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 07:39:15 -0400
Message-ID: <51557D4E.10804@broadcom.com> (sfid-20130329_123919_701764_88F3A4A0)
Date: Fri, 29 Mar 2013 12:38:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Dan Williams" <dcbw@redhat.com>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"Felix Fietkau" <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	"Ben Greear" <greearb@candelatech.com>
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication
 from user-space
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
 <1364487476.10397.23.camel@jlt4.sipsolutions.net>
 <5154B347.9080904@broadcom.com>
 <1364506118.10397.29.camel@jlt4.sipsolutions.net>
 <1364510577.3226.7.camel@dcbw.foobar.com>
 <1364510646.10397.81.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364510646.10397.81.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2013 11:44 PM, Johannes Berg wrote:
> On Thu, 2013-03-28 at 17:42 -0500, Dan Williams wrote:
> 
>>> Well, you can do DHCP a second or so, I'd think? And EAPOL much quicker,
>>> of course. I don't really see any reasonable minimum time? We might want
>>> to enforce a max though, maybe.
>>
>> Not quite.  A lot is dependent on the server itself, and I've had users
>> on university and corporate networks report it sometimes takes 30 to 60
>> seconds for the whole DHCP transaction to complete (DISCOVER, REQUEST,
>> OFFER, ACK).  Sometimes there's a NAK in there if the server doesn't
>> like your lease, which means you need another round-trip.  So in many
>> cases, it's a couple round-trips and each of these packets may or may
>> not get lost in noisy environments.
> 
> Oh, yes, of course. However, we're talking about optimising the good
> cases, not the bad ones. Think of it this way: if it goes fast, we
> shouldn't make it slow by putting things like powersave or similar in
> the way. If it's slow, then it'll still work, just slower. But when
> "slower" only means a few hundred milliseconds, it doesn't matter if
> everything takes forever (30-60 secs)

In our android driver, which has a private ioctl for this stuff, it is
used for DHCP and makes WLAN connection more reliable by altering BT
coex parameters. It has its own timeout schedule. Timer T1 is 2.5 sec.
for DCHP transaction to complete. If T1 expires before completion it
increases WLAN priority more with timer T2 for 5 seconds. That is why I
put 2.5 sec as a minimum duration in the patch. Unfortunately I do not
have the data available to back these timeout values. I will ask around.

Gr. AvS


