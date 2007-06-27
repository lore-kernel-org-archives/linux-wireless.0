Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58957
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXF0OiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 10:38:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Wed, 27 Jun 2007 16:37:05 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <200706271508.29188.mb@bu3sch.de> <1182954627.4769.30.camel@johannes.berg>
In-Reply-To: <1182954627.4769.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706271637.05587.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 June 2007 16:30:27 Johannes Berg wrote:
> On Wed, 2007-06-27 at 15:08 +0200, Michael Buesch wrote:
> > On Wednesday 27 June 2007 10:55:00 Johannes Berg wrote:
> > > On Mon, 2007-06-25 at 16:28 +0200, Michael Buesch wrote:
> > > 
> > > >  	case PRISM2_PARAM_PREAMBLE:
> > > > -		local->short_preamble = value;
> > > > +		if (value)
> > > > +			local_to_hw(local)->conf.flags |= IEEE80211_CONF_SHORT_PREAMBLE;
> > > > +		else
> > > > +			local_to_hw(local)->conf.flags &= ~IEEE80211_CONF_SHORT_PREAMBLE;
> > > > +		if (ieee80211_hw_config(local))
> > > > +			ret = -EINVAL;
> > > 
> > > any reason not to return the actual error code from hw_config here? Not
> > > that it'll be any different from -EINVAL I expect...
> > 
> > The reason is copy&paste from other PRISM2 IOCTLs ;)
> > I'm OK with the real error code, too.
> 
> I don't really care either way.
> 
> > Though, the error code of hw_config is usually not useful _at all_.
> > As it might not be the SHORT_PRMBL flag that produced it, but some of the
> > other config settings.
> > I would probably vote for any code in mac80211 to ignore that return value,
> > except the places where a failure of hw_config would be fatal (init or
> > places like that).
> 
> Yeah, there's a todo item saying that we need a way to just commit the
> changed settings.

Well, sane drivers should basically already do that, as most information
is saved redundantly in the driver's structs. Especially for operations
that can fail.
So it's basically a TODO for drivers, rather than mac80211.

-- 
Greetings Michael.
