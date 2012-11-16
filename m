Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2KPNeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 08:34:20 -0500
Message-ID: <1353072892.9490.12.camel@jlt4.sipsolutions.net> (sfid-20121116_143423_337820_3C81090A)
Subject: Re: rework on .flush() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 16 Nov 2012 14:34:52 +0100
In-Reply-To: <50A4E458.4090508@broadcom.com>
References: <50A4E458.4090508@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> The brcmsmac driver still faces a lot of bug reports related to the 
> .flush() callback (see [1] from Dave Jones).
> 
> Previously I had looked into this and found that during the flush the 
> .tx callback still gets new frames. So I put ieee80211_stop_queues() in 
> the flush and upon exit call ieee80211_wake_queues(). Due to issues 
> still persisting we went a bit deeper in mac80211.
> 
> It turns out that mac80211 stops the netif queues for each interface 
> (except monitor iftype) and not the internal queues during a scan. So it 
> stops the netif queues, calls the flush(), and upon returning to the 
> associated channel it wakes up the netif queues.

Hmm, interesting. Yeah this is for scanning, that software scan stuff is
a bit buggy in this area, I agree. This only really works if there's
nothing on the internal queues, otherwise during flush the driver will
wake the queues and get more packets etc...

> The problem here is that in brcmsmac the flush does the 
> ieee80211_wake_queues() call, because that could also wakeup the netif 
> queues. So doing it in the driver seems a bad idea. Any suggestion on 
> how to solve this?

Yeah so .. I actually thought about this at some point, it's tricky. For
the global queues we check what reasons we had for stopping them, but we
don't do that for the netif queues. Maybe we should? I also think flush
should at least have the option to be per queue, so that we could do
something per sdata in mac80211 if the driver uses different HW queues
for different interfaces.

However, I'm not sure I'll have time to work on corner cases with
software scanning since we don't use that. I might work on the flush
thing though, that could be interesting.

johannes

