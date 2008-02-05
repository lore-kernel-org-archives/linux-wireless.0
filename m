Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:52761 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYBEB40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 20:56:26 -0500
Received: by py-out-1112.google.com with SMTP id u52so3547904pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 17:56:25 -0800 (PST)
Message-ID: <43e72e890802041756k2f13e334p909246ca2b99849a@mail.gmail.com> (sfid-20080205_015641_082688_83BD23DC)
Date: Mon, 4 Feb 2008 20:56:23 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200802051050.22187.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <200801251701.59629.bruno@thinktube.com>
	 <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
	 <200802051050.22187.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 8:50 PM, bruno randolf <bruno@thinktube.com> wrote:
> On Sunday 03 February 2008 08:22:12 Luis R. Rodriguez wrote:
> > Sure ACK. Also as was stated, even with IBSS merge functionality
> > working you could up with nodes splitting up due to missing the
> > "leader" beacon due to interference or even strange radio node
> > problems. A solution to this we implemented at Orbit with MadWifi was
> > that instead of generating "random" BSSIDs you'd create one based on
> > the hash of the SSID [1]. This ensures that nodes with identical SSIDs
> > end up with identical BSSIDs, regardless of any strange problems.
> > Technically from what I have gathered this doesn't break the specs but
> > would prevent this split-IBSS problem. I actually like to see this
> > technique added into mac80211 too.
> >
> > [1] http://www.orbit-lab.org/wiki/HowTo/bssidFix
>
> this looks like a good idea to avoid many ibss merge problems, and it could be
> really useful to have that (maybe as an option?) in mac80211. but unless we
> have ibss merge functionality you won't be able to join older networks
> (higher TSF) which don't use that scheme, so we still need that to be able to
> communicate with other ("standard") drivers.
>
> i guess the general question for mac80211 is: do we want and allow more
> liberal interpretations of the standard concerning IBSS mode or do we
> strictly stick with the "book"?
>
> in my opinion these "extensions" are necessary in order to make IBSS mode
> useful at all and therefore we need them! and as long as they are able to
> interoperate with other drivers in IBSS mode i don't see a problem.

I agree 100%.

  Luis
