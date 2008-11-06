Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60108 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYKFMUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 07:20:37 -0500
Message-ID: <4912E0FF.8070107@openwrt.org> (sfid-20081106_132049_234085_4817F308)
Date: Thu, 06 Nov 2008 13:20:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Thoughts about mac80211 client PS implementation
References: <87k5bhkjf1.fsf@nokia.com>	 <1225917235.3619.180.camel@johannes.berg> <43e72e890811051243y65f8b51cy2f80279ecbebc8e4@mail.gmail.com>
In-Reply-To: <43e72e890811051243y65f8b51cy2f80279ecbebc8e4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Wed, Nov 5, 2008 at 12:33 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2008-11-05 at 22:27 +0200, Kalle Valo wrote:
> 
> BTW who defines "Dynamic Power Save"? Is there a standard approach or
> more an implementation approach to the concept of doing PS while
> active?
> 
>>> PS should be disabled while associated and running software scan, and
>>> naturally re-enabled after the scan has finished. I assume hardware
>>> scanning implementations are clever enough to disable PS when scanning
>>> and we don't have to worry about that case.
> 
> BTW we need to check if in ath5k/ath9k if the beacon miss interrupt
> will actually be triggered *if* the beacon filter is *off*. Not sure
> about this yet. Also I'm not sure if triggering scanning will enable
> beaconing filter in our hardware if its off and then disable it after
> scanning too.
The beacon miss interrupt is independent of the beacon filter. In fact
that's the whole point of the interrupt itself. I know that this works
in hardware, we only need to check the software side of it ;)

- Felix
