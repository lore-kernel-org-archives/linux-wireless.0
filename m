Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGLHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 06:07:31 -0500
Message-ID: <1360235268.8038.8.camel@jlt4.sipsolutions.net> (sfid-20130207_120738_769676_56A181B9)
Subject: Re: [PATCHv8 1/3] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 07 Feb 2013 12:07:48 +0100
In-Reply-To: <20130207110047.GA26957@pandem0nium>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359982200-2321-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1360171448.7910.43.camel@jlt4.sipsolutions.net>
	 <20130207110047.GA26957@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 12:00 +0100, Simon Wunderlich wrote:

> > > + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
> > > + *	check (CAC) must be performed before using it for AP or IBSS.
> > > + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
> > > + *	is therefore marked as not available.
> > > + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
> > > + */
> > > +
> > > +enum nl80211_dfs_state {
> > > +	NL80211_DFS_USABLE	= 0,
> > 
> > I don't really see a reason for explicit values?
> > 
> 
> You've suggested explicit values yourself last time [1], or did I misunderstand?
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/103278
> "Should UNAVAILABLE be = 0, so that's the default?" (usable should be the default, btw)

Ah, no that was a misunderstanding then. Maybe it would've been clearer
if I'd said "Should UNAVAILABLE be first (=0), so that's the default?"
But if usable should be the default, that should be first. Anyway I
don't care much, we do rely on this enum behaviour a lot though so I
don't think we need explicit values.

> I've just moved this magic function from scan.c to core.h because I need it too.
> It appears another driver (drivers/net/wireless/ipw2x00) also implements this
> privately. We can suggest this patch for include/linux/jiffies.h if you prefer.

Maybe better do it afterwards, unless you don't mind waiting another few
months...? :)

johannes

