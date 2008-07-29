Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:52390 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbYG2NS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:18:26 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3390467waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 06:18:25 -0700 (PDT)
Message-ID: <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com> (sfid-20080729_151829_984822_AE8AA9D5)
Date: Tue, 29 Jul 2008 16:18:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217336870.10489.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 4:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 16:04 +0300, Tomas Winkler wrote:
>
>> Correct.
>
> Ok. That means it can go away with the stuff I'm doing right now.
>
>> Other thing is you probably not seeing the latest code as well. Yi is
>> not publish new code before John is merging what we've already sent
>> out. I also have something still in the drawer.
>
> Heh ok, then instead of fixing iwlwifi I'll just fix up mac80211 and
> give you the patches to look at aggregation, seeing that Ron is on
> vacation for another week.

iwlwifi-2.6.git master branch (kernel.org)  has most updated visible
code if you want to make same effort.

>
> What I discussed with Ron (and Jouni) is that we should not use extra
> software queues for aggregation, because
>  - doing it requires requeue which is not possible with tx info intact
>  - doing it breaks access semantics in the case where not just hw but
>   also sw queues start filling up

This will require another queueing under what we already have. You
still need ability to stop and start the packet stream.
At that time it seems to be stupid not to reuse queueing.
I'm not familiar enough we the scheduler but hopefully it doesn't mean
to implement it in the driver again.  Do we really putting correct
effort where needed maybe altering scheduler would be better
direction.  I'm really shutting from the waist here....
Tomas
