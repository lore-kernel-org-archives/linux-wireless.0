Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39334 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab2CPWJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 18:09:58 -0400
Message-ID: <4F63BA31.1080608@etit.tu-chemnitz.de> (sfid-20120316_231032_428812_D09A3850)
Date: Fri, 16 Mar 2012 23:09:53 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Subject: Re: [ath9k] mesh powersave hardware sleep + wakeup
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux>
In-Reply-To: <20120316204547.GG18861@tux>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/12 21:45, Luis R. Rodriguez wrote:
> On Fri, Mar 16, 2012 at 10:42:02AM +0100, Marco Porsch wrote:
>> Hi,
>>
>> I am trying to implement the IEEE 802.11s power save schemes in mac80211.
>> In 11s it is defined that power save STA doze AND send beacons AND
>> wake up periodically for multiple neighbors beacons.
>>
>> Is this actually possible with current hardware/drivers (especially ath9k)?

[ ... ]

> I don't have time to review this but it sounds correct that the part
> you want to focus on is introducing a wake up mechanism when you
> need to initiate radiation for your own beacons.  I think right now
> we simply disable PS in mac80211 completely if we have a mode of
> operation that require beconing.

Actually the whole power save code is only written specifically for 
managed mode.
E.g. for ad-hoc, you wouldn't suspend the radio, since the MAC schemes 
that must deal with the resulting deafness issues are not implemented in 
mac80211. (That would be frame buffering + release in ATIM window, ...)

Concerning mesh, I already have a hackish - but mostly working - PS 
frame buffering and release.
But, what is power save without actually saving power?

Problem: I don't have a reference how to suspend/wake the radio between 
sending beacons.
That's why I hoped you can tell me, if - at least in theory - the 
hardware/ath9k even allows this.

 > Your challenge is to lift that and
> deal with the issues there and all the possible combinations. You
> can help with this
>
> This should help you:
>
> http://wireless.kernel.org/en/users/Documentation/Power-consumption

Thanks, the numbers are nice I can use them for analytical estimation or 
simulation.

> For now you can focus on only allowing through Mesh devices and
> the combinations of it but I suspect that some of the work you do
> may also help with addressing P2P powersave.

Correct. When this is implemented, it is easy to port this to ad-hoc. 
Because mesh is definitively more complex, but similar.

Regards,
Marco
