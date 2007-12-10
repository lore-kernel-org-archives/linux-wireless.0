Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51801 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbXLJV3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 16:29:00 -0500
Date: Mon, 10 Dec 2007 22:22:13 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210222213.0cf8ce0d@morte> (sfid-20071210_212908_479950_3DCF1DDF)
In-Reply-To: <1197319867.7493.4.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210090853.79ea4645@morte>
	<1197319867.7493.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 21:51:07 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> 
> On Mon, 2007-12-10 at 09:08 +0100, Stefano Brivio wrote:
> > On Sun, 09 Dec 2007 23:25:50 +0100
> > Mattias Nissler <mattias.nissler@gmx.de> wrote:
> > 
> > > >  static void *rate_control_pid_alloc(struct ieee80211_local *local)
> > > >  {
> > > >  	struct rc_pid_info *pinfo;
> > > > +	struct rc_pid_rateinfo *rinfo;
> > > > +	struct ieee80211_hw_mode *mode;
> > > > +	int i, j, tmp;
> > > > +	bool s;
> > > >  
> > > >  	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
> > > > +	if (!pinfo)
> > > > +		return NULL;
> > > > +
> > > > +	mode = local->oper_hw_mode;
> > > > +	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
> > > > +	if (!rinfo) {
> > > > +		kfree(pinfo);
> > > > +		return NULL;
> > > > +	}
> > > 
> > > What if the mode is changed? Have you checked the rate control algorithm
> > > gets reinitialized? If not, we're scheduling a crash here, when
> > > mode->num_rates changes.
> > 
> > After a discussion on IRC with Michael (Wu), we came to the conclusion that
> > it doesn't make sense for mode->num_rates to change, because:
> > 1) if the AP drops supported rates, it'll drop the association as well,
> > then everything here will be destroyed and created again;
> > 2) that can be changed in userspace, but we couldn't figure out a scenario
> > where it would make any sense. Johannes, any comments? Wouldn't it make
> > sense to just forbid to change this in userspace?
> 
> I don't agree. For example, what if you have some broken 802.11b only
> hardware that you desperately need to get going, but it freaks out on
> 802.11g encoded frames. Now if your AP is hostapd on a Linux machine,
> you'll want to change the mode. Hence, also the number of available
> rates change.

Yes, but the association gets dropped. I'm not sure about the hostapd
implementation (will check), but APs drop association when they change
supported rates. So the per-sta rate control would obviously get reinitialized.
I didn't find anything clear about this in the 802.11 standard, though.

> Moreover, I think we can do better than just disallowing changes to the
> rate set, don't you think?

Well, I still can't find an example of where this would be needed. Your
scenario looks like this:
1) the AP STA periodically advertises supported rates;
2) the non-AP STA supported rates are the intersection (as in set theory)
of the rates supported by the non-AP STA and the rate advertised by the AP
STA (in this case, assuming that the both the non-AP and the AP STAs
support 802.11b and g, rates supported by the non-AP STA are both CCK and
OFDM rates);
3) let's say that a thunderstorm makes the air CCK-hostile, so we want to
reconfigure our AP STA to work with 802.11b only: the association will need
to be recreated (thus the rc algorithm gets reinitialized), and now rates
supported by the non-AP STA are the CCK rates only -> everything works as
expected and wanted.

Anyway, it's not an issue at all to deal with rates changing in
rc80211-pid - I would just need to reallocate a struct and copy over some
data (but please think about this now: OFDM rates are the same for 802.11a
and 802.11g, but it really doesn't make any sense to assume that behaviour
at 2.4GHz is anywhere near to behaviour at 5GHz - so maybe I would just
reallocate the struct and that's it). But before than doing this, I wanted
to be sure that we aren't just hiding a bug in mac80211.


--
Ciao
Stefano
