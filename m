Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52063 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab3A3RVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 12:21:48 -0500
Message-ID: <1359566410.14894.57.camel@cumari.coelho.fi> (sfid-20130130_182152_114440_F0BD66B8)
Subject: Re: [PATCHv6 2/6] cfg80211: check radar interface combinations
From: Luciano Coelho <coelho@ti.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<victorg@ti.com>, <linville@tuxdriver.com>,
	<kgiori@qca.qualcomm.com>, <zefir.kurtisi@neratec.com>,
	<adrian@freebsd.org>, <j@w1.fi>, <igalc@ti.com>, <nbd@nbd.name>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 30 Jan 2013 19:20:10 +0200
In-Reply-To: <20130130165636.GA27636@pandem0nium>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359563688.14894.54.camel@cumari.coelho.fi>
	 <20130130165636.GA27636@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 17:56 +0100, Simon Wunderlich wrote:
> On Wed, Jan 30, 2013 at 06:34:48PM +0200, Luciano Coelho wrote:
> > > +	switch (iftype) {
> > > +	case NL80211_IFTYPE_ADHOC:
> > > +	case NL80211_IFTYPE_AP:
> > > +	case NL80211_IFTYPE_AP_VLAN:
> > > +	case NL80211_IFTYPE_MESH_POINT:
> > > +	case NL80211_IFTYPE_P2P_GO:
> > > +		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
> > > +		break;
> > 
> > This code is causing an oops with the wl18xx driver in AP mode.  The
> > problem is that cfg80211_can_change_interface() calls
> > cfg80211_can_use_iftype_chan() with chan == NULL.  This code doesn't
> > check if chan is NULL, so this dereference causes the oops.
> 
> Sorry about that - I believe you've found the same bug I've posted a patch
> for a few days ago. Johannes already has this in mac80211-next, but it is
> not yet in wireless-testing:
> 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/102836/match=simon
> http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=commit;h=683d41ae6755e6ae297ec09603c229795ab9566e

Ah, thanks.  I should have read the list more carefully. :)


> > I don't have the time right now to fix this, but I'll look into it
> > tomorrow (unless someone comes with a fix before that :P).
> 
> Please have a look at the patch posted above (both links for the same patch).

I'll apply that and try it out.  Thanks for pointing it out so promptly!

--
Cheers,
Luca.

