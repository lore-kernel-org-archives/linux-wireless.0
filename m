Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:21496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1BNRGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 12:06:31 -0500
Received: from hpaq14.eem.corp.google.com (hpaq14.eem.corp.google.com [172.25.149.14])
	by smtp-out.google.com with ESMTP id p1EH6S4p027457
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 09:06:28 -0800
Received: from wyb42 (wyb42.prod.google.com [10.241.225.106])
	by hpaq14.eem.corp.google.com with ESMTP id p1EH61Kj028109
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 09:06:27 -0800
Received: by wyb42 with SMTP id 42so4903981wyb.9
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 09:06:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D594BA2.5080905@candelatech.com>
References: <1296862224-19489-1-git-send-email-greearb@candelatech.com>
	<1297685561.3785.36.camel@jlt3.sipsolutions.net>
	<4D594BA2.5080905@candelatech.com>
Date: Mon, 14 Feb 2011 09:06:26 -0800
Message-ID: <AANLkTimnDRORFvJiOZNJA-BbhfU0AP1RXFPV31wJyU6Q@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Make some mlme timers module paramaters.
From: Sam Leffler <sleffler@google.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 7:34 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 02/14/2011 04:12 AM, Johannes Berg wrote:
>>
>> On Fri, 2011-02-04 at 15:30 -0800, greearb@candelatech.com wrote:
>>>
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> This allows users to tune the connection-loss algorithms
>>> to be more or less lenient.  In particular, larger
>>> null-func retries helps when using lots of virtual
>>> stations on a loaded network.
>>
>> I see this has been merged, but I really think it should be reverted. It
>> doesn't really fix anything, and it makes the behaviour less
>> predictable. Also, even on a loaded network the nullfunc frames should
>> be transmitted quickly as they go out on VO. I'm thinking the fact that
>> it doesn't will also affect other things -- like the bufferbloat
>> discussion -- and fixing the problem would be a much better idea.
>
> The defaults stay the same, and allowing the values to be set a bit larger
> lets 128 stations associate, where without this, they constantly fail the
> null-func retries counter.
>
> Imagine 128 stations all trying to associate and auth WPA at the
> same time, and start DHCP and some IPv6 auto-negotiation
> as soon as they are up...  That is quite a lot of packets
> for a bunch of timing-sensitive operations.
>
> I know my particular use is pretty strange, but surely I'm not
> the only one that would like a good way to stress-test APs.
>
> I can also imagine that other users might like their system even more
> trigger happy..perhaps that would speed up roaming in some cases.
> Or users on very poor/congested networks, flakey APs, etc.
>
> The default values seem to be chosen arbitrarily to work for most
> users most of the time.  I think it adds way more benefit to allow
> these easily changed than any harm that comes from giving users
> the option.

We default MAX_NULLFUNC_TRIES to 1.  By the time you disconnect you've
missed at least 7 consecutive beacon frames (nominally 700 TU) and the
1 NullData frame (nominal 7 tx attempts).  I have _rarely_ seen trying
multiple times succeed.  Increasing tries requires spacing them out
which significantly increases roaming time which is user visible.
Also in most cases the event generated may cause wpa_supplicant to
re-join the same AP after a scan (depends on whether your supplicant
code blacklist's the ap and/or you have other options).

Thus having the module parameter means I can set my desired parameters
w/o having local mods.

-Sam
