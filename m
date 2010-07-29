Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0G2HsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 03:48:20 -0400
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	nbd@openwrt.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
References: <20100729035820.5930.29864.stgit@tt-desk>
	 <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 09:48:14 +0200
Message-ID: <1280389694.3823.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 23:12 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 8:58 PM, Bruno Randolf <br1@einfach.org> wrote:
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index 2c87016..8a88921 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -731,6 +731,28 @@ enum nl80211_commands {
> >  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
> >  *      for non-automatic settings.
> >  *
> > + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
> > + *     This can be used to mask out antennas which are not attached or should
> > + *     not be used for transmitting. If an antenna is not selected in this
> > + *     bitmap the hardware is not allowed to transmit on this antenna.
> > + *
> > + *     Each bit represents one antenna, starting with antenna 1 at the first
> > + *     bit. Depending on which antennas are selected in the bitmap, 802.11n
> > + *     drivers can derive which chainmasks to use (if all antennas belonging to
> > + *     a particular chain are disabled this chain should be disabled) and if
> > + *     a chain has diversity antennas wether diversity should be used or not.
> > + *     HT capabilities (STBC, TX Beamforming, Antenna selection) can be
> > + *     derived from the available chains after applying the antenna mask.
> 
> I don't want to do any work myself on drivers for this, can we have
> cfg80211/mac80211 do this for us?

Also, this is a serious issue when you want to support this call -- it
may not be done while you're associated since you cannot change those
things properly then.

johannes

