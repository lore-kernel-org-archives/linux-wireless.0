Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2GIJbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:31:52 -0400
Message-ID: <1341826309.4455.19.camel@jlt3.sipsolutions.net> (sfid-20120709_113155_614836_A8AB1443)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 11:31:49 +0200
In-Reply-To: <CA+XVXfcRWY+DT8RVfMdC8gzfKY+_2W5msp65ba0xaAZLYA09Fw@mail.gmail.com> (sfid-20120706_094134_352404_50BE7EFA)
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
	 <1341417530-9062-3-git-send-email-arik@wizery.com>
	 <1341473996.4455.2.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com>
	 <1341557988.4462.6.camel@jlt3.sipsolutions.net>
	 <CA+XVXff3_ugusQ=HPVeg3YSp3OBjWwpCVHTxd+Tnxg5Rf_5W3w@mail.gmail.com>
	 <1341560078.4462.11.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcRWY+DT8RVfMdC8gzfKY+_2W5msp65ba0xaAZLYA09Fw@mail.gmail.com>
	 (sfid-20120706_094134_352404_50BE7EFA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 10:41 +0300, Arik Nemtsov wrote:

> >> You mean move out ht_supported?
> >
> > Yeah, I think that'd make more sense? Have it in the sband directly.
> 
> It does make more sense. But I was thinking there might be code
> setting this dynamically in some drivers, so the changes would be
> non-trivial. The union was sort of a compromise.

Well the thing is ... it'll always stay that way if we don't fix it now.
I don't think it's a huge deal to change all the drivers, though I'll
admit that it might be a little tricky in some drivers.


> Maybe move it out for vht_cap for now? :)

Here's to hoping you fix the chips in the future instead! ;-)

> > I think the function should restrict to NO_HT in case it doesn't have
> > caps, otherwise it can't properly restrict. I suppose that means you
> > won't be able to do HT monitoring with your device, but I can live with
> > that.
> 
> Actually the ht_supported flag is still global, so HT monitoring is
> possible, just not HT40 monitoring I think. We'll fix that if the need
> arises (or just boot the driver with fixed caps via a module param).

Yeah I guess that's true.

johannes

