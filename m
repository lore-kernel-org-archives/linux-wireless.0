Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:24679 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751267Ab0G2JMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 05:12:14 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0488404731
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 18:12:13 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
Date: Thu, 29 Jul 2010 18:12:28 +0900
References: <20100729035820.5930.29864.stgit@tt-desk> <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
In-Reply-To: <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007291812.28639.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu July 29 2010 15:12:29 you wrote:
> On Wed, Jul 28, 2010 at 8:58 PM, Bruno Randolf <br1@einfach.org> wrote:
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index 2c87016..8a88921 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -731,6 +731,28 @@ enum nl80211_commands {
> >  *      This is used in association with
> > @NL80211_ATTR_WIPHY_TX_POWER_SETTING *      for non-automatic settings.
> >  *
> > + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for
> > transmitting. + *     This can be used to mask out antennas which are
> > not attached or should + *     not be used for transmitting. If an
> > antenna is not selected in this + *     bitmap the hardware is not
> > allowed to transmit on this antenna. + *
> > + *     Each bit represents one antenna, starting with antenna 1 at the
> > first + *     bit. Depending on which antennas are selected in the
> > bitmap, 802.11n + *     drivers can derive which chainmasks to use (if
> > all antennas belonging to + *     a particular chain are disabled this
> > chain should be disabled) and if + *     a chain has diversity antennas
> > wether diversity should be used or not. + *     HT capabilities (STBC,
> > TX Beamforming, Antenna selection) can be + *     derived from the
> > available chains after applying the antenna mask.
> 
> I don't want to do any work myself on drivers for this, can we have
> cfg80211/mac80211 do this for us?

is this not a separate issue from defining the API? you could have it do this 
for you even now, with or without the antenna API, no?

i think this should be dealt with seperately. for now let's just define an API 
for an antenna mask.

bruno
