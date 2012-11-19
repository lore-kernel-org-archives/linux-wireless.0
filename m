Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2KSOvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:51:33 -0500
Message-ID: <1353336722.18299.19.camel@jlt4.sipsolutions.net> (sfid-20121119_155138_849852_8C31147E)
Subject: Re: rework on .flush() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 19 Nov 2012 15:52:02 +0100
In-Reply-To: <50A67308.8020709@broadcom.com>
References: <50A4E458.4090508@broadcom.com>
	 <1353072892.9490.12.camel@jlt4.sipsolutions.net>
	 <50A67308.8020709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 18:08 +0100, Arend van Spriel wrote:
> On 11/16/2012 02:34 PM, Johannes Berg wrote:
> >> The problem here is that in brcmsmac the flush does the
> >> >ieee80211_wake_queues() call, because that could also wakeup the netif
> >> >queues. So doing it in the driver seems a bad idea. Any suggestion on
> >> >how to solve this?
> > Yeah so .. I actually thought about this at some point, it's tricky. For
> > the global queues we check what reasons we had for stopping them, but we
> > don't do that for the netif queues. Maybe we should? I also think flush
> > should at least have the option to be per queue, so that we could do
> > something per sdata in mac80211 if the driver uses different HW queues
> > for different interfaces.
> 
> To me so from driver perspective, it was not clear what 
> ieee80211_stop/wake_queues was operating on. Somehow the knowledge that 
> the netif queues are already stopped upon calling 
> ieee80211_stop_queues() should be retained.

Yes. From the driver perspective, those calls operate on the HW queues
(which you can modify now, using the IEEE80211_HW_QUEUE_CONTROL flag and
associated APIs). But we don't retain the netif queue state separately,
which I agree is a bug.

> Regarding the flush do you mean flush per queue or flush per vif? Per 
> vif could have its perks, I guess.

Not sure. With the IEEE80211_HW_QUEUE_CONTROL per queue might make
sense, and would actually make more sense than per vif in most cases.
However, it'd have to be a bitmap so the flush can happen in parallel.

> > However, I'm not sure I'll have time to work on corner cases with
> > software scanning since we don't use that. I might work on the flush
> > thing though, that could be interesting.
> 
> ok. The drv_flush() call is done in several places so not only scanning. 
> All with the drop flag set to false. Is that just to be prepared or do 
> you foresee an actual use-case?

I think at some point I thought we would use it, but if somebody is
going to change the flush callback (e.g. by passing a hw queue bitmap) I
would suggest to remove the drop flag.

johannes

