Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2GINUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:20:02 -0400
Message-ID: <1341839999.4455.48.camel@jlt3.sipsolutions.net> (sfid-20120709_152010_441115_5B9EEDA7)
Subject: Re: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 15:19:59 +0200
In-Reply-To: <20120709131813.GD4488@ritirata.org>
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
	 <1341791503-12542-1-git-send-email-ordex@autistici.org>
	 <1341839146.4455.40.camel@jlt3.sipsolutions.net>
	 <20120709131813.GD4488@ritirata.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 15:18 +0200, Antonio Quartulli wrote:

> > So this is kinda broken. In fact, the whole basic rate thing is broken
> > it seems.
> > 
> > The mcast rate is per band, as it should, since you could find the same
> > BSSID on a 5 GHz channel and then jump to that channel if the TSF is
> > higher...
> > 
> > However, the basic rates aren't, which is wrong: the basic rates bitmap
> > could be 1,2,6,9. If the driver is like most drivers, that translates to
> > a bitmap of 0x33. But 0x33, for most drivers, if applied to the 5 GHz
> > rates means 6,9,24,36. See why this is broken? A rate bitmap can't be
> > siwtched around between bands and still make any sense.
> 
> I see, I wrongly thought that nl80211_parse_mcast_rate() was checking if the
> provided mcast_rate belongs to the basic_rate set of the band which we are now.

Well, ok, don't get confused -- there's no basic rate set "of the band",
it's a BSS property.

> But that's wrong! nl80211_parse_mcast_rate() only checks if the provided
> mcast_rate exists somewhere...

It checks that each rate exists in the band that it's for.

> > Oh, also, I'm not sure why you do BIT(... -1), but that's unrelated.
> > What kind of value is the mcast rate? A rate index, or a number?
> > 
> 
> it's an index and actually it's the index +1, as reported in mac80211.h:
> 
>  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)

also in the cfg80211 API?

johannes

