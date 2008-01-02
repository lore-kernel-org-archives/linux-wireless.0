Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:43754 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYABSCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 13:02:14 -0500
Date: Wed, 2 Jan 2008 19:02:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v2] mac80211: better rate control algorithm selection
Message-ID: <20080102180209.GA10837@uranus.ravnborg.org> (sfid-20080102_180216_778858_909F2C65)
References: <1199283424.4172.88.camel@johannes.berg> <20080102172505.GA9772@uranus.ravnborg.org> <1199295901.4172.111.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1199295901.4172.111.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 02, 2008 at 06:45:01PM +0100, Johannes Berg wrote:
> 
> > > +# objects for PID algorithm
> > > +rc80211_pid-y := rc80211_pid_algo.o
> > > +rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
> 
> > > +# build helper for PID algorithm
> > > +rc-pid-y := $(rc80211_pid-y)
> > 
> > Is this extra indirection ( rc80211_pid-y ) a preparation
> > for future rate algorithms or was it just coped from my proposal?
> > It is not needed and it does not help readability.
> 
> As far as I can tell rc80211_pid-y is needed to build rc80211_pid.o from
> rc80211_pid_algo.o and rc80211_pid_debugfs.o for the modular case, no?

Correct - I just missed that when reading your patch.
And I guess this was one of the things I got wrong in my first proposal too.

Looks good then.

> Hence, I just wanted to keep it symmetric for the non-modular case.
> 
> > A second note - but more as a personal taste..
> > I prefer += assignment in preference of continued lines.
> > So 
> > +mac80211-y := \
> >  	ieee80211.o \
> >   	ieee80211_ioctl.o \
> >  	sta_info.o \
> > 
> > would become:
> > +mac80211-y := ieee80211.o ieee80211_ioctl.o
> > +mac80211-y += sta_info.o
> 
> Yeah, I was hoping the diff would be smaller this way because it was
> already this way before.

Understood.

	Sam
