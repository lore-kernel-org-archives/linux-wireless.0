Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARV7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 16:59:51 -0500
Message-ID: <1358546411.7922.41.camel@jlt4.sipsolutions.net> (sfid-20130118_225954_997971_D4AC65FE)
Subject: Re: [PATCHv6 4/6] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 18 Jan 2013 23:00:11 +0100
In-Reply-To: <20130117135228.GD19552@pandem0nium>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1358377171.15012.45.camel@jlt4.sipsolutions.net>
	 <20130117135228.GD19552@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-17 at 14:52 +0100, Simon Wunderlich wrote:

> > > +	res = drv_start_radar_detection(local, sdata, chandef);
> > 
> > If the vif is assigned the channel, why also pass it to the
> > start_radar_detection command? That seems pointless, they can't be
> > different?
> > 
> In the initial phase, __nl80211_set_channel() should not be able to set
> the channel (no CAC yet), and will fail for IBSS (to be implemented later)
> generally, at least as it's implemented now.
> 
> But what we can do is set the channel from mac80211 and call the driver
> function without the channel argument, as it'll be pointless in this case.
> Is this what you mean?

Hmm. Why are you talking about __nl80211_set_channel() now? We're now
talking about mac80211, which can and does set the channel (chanctx,
which may fall back to drv_config()) before calling
drv_start_radar_detection(), so I think the latter needs no chandef
argument?

> > Actually that raises another question: If we have "external" radar
> > detection, say by a different NIC, then shouldn't we still ask the
> > driver to start radar detection when using the channel? Or is that
> > implicit, does the driver have to check?
> 
> That is a good question, I didn't consider that. In the "simple process"
> we first start radar detection and start the ap on the same channel.
> For external CAC that won't work, of course. What about mac80211 checking
> the channel in start_ap(), and if the channel requires DFS, pass some flag
> to the driver that radar detection should be enabled?

Yes, that makes sense. But then it would also make sense to remove the
start_radar_detection() callback entirely, and encode all that
information in the channel context/drv_config call?

If mac80211 gets to be responsible for it, this should totally be
documented in the cfg80211 API though so if a full-mac driver wants to
implement it they know what to do. I do think this is the reasonable way
of doing it though.

Note that I'm not advocating removing the start_radar_detection() or its
chandef from the *cfg80211* API. That is clearly needed. But in mac80211
it seems "set this chandef with radar detection" is a better API?


> > > +#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\
> > 
> > I'll apply my "mac80211: split out chandef tracing macros" patch
> > instead.
> 
> OK.

Done, though it seems you don't need it if you remove the chandef
argument from start_radar_detection, or even remove the callback
entirely.

johannes

