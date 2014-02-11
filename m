Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaBKNew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 08:34:52 -0500
Message-ID: <1392125688.4128.23.camel@jlt4.sipsolutions.net> (sfid-20140211_143455_775346_F8C7FDAA)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Feb 2014 14:34:48 +0100
In-Reply-To: <1391602306.16723.57.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
	 <1391585999.16723.7.camel@porter.coelho.fi>
	 <CA+BoTQkXjAYR0H4nHxagYz3Kn5atWJ048UUY1=gPrW77Gvqp+Q@mail.gmail.com>
	 <1391602306.16723.57.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 14:11 +0200, Luca Coelho wrote:

> It's the same if the STA CSA would be "started" in the userspace.  If
> the remote AP sets a too short count, the userspace won't have the
> chance to react.  In either case, we would have to send a notification
> to the userspace and it would have to tell us what to do.  If we wait
> for the userspace to react on our STA CSA, we will be too late on both
> interfaces.  If mac80211 does the STA CSA directly, at least the STA CSA
> will be done on time and the GO can move a bit later (or get
> disconnected if we were short on chanctx's).

I don't think the GO would get disconnected, rather the STA would, no?

> > The purpose of ch_switch_finalize() is to perform the final switch
> > atomically and make sure non-complying interfaces are disconnected
> > before channel is actually switched (this could include Ilan's GO case
> > in a clean way).
> 
> I was thinking about eventual drivers that offload the whole channel
> switch process to the firmware.  The driver just sends the count, the
> new channel and everything and the firmware takes care of it all.  It
> will beacon for count TBTTs and perform the actual channel switch at the
> right time.  In this case, all the decision making about what needs to
> be disconnected or switched must be made at the beginning.
> 
> But I'll let Johannes comment more. ;)

Yes, I'm pretty sure that this kind of situation will happen sooner or
later, so preventing it in the APIs right now seems like a bad idea.

johannes

