Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34681 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab1CBJhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:37:54 -0500
Received: by fxm17 with SMTP id 17so5701974fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 01:37:53 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/9] [{mac|nl}80211] Add 2 new radar channel flags
Date: Wed, 2 Mar 2011 10:37:33 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de> <201102281747.06564.bernhard.schmidt@saxnet.de> <20110301215412.GD6835@tux>
In-Reply-To: <20110301215412.GD6835@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103021037.34404.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 01, 2011 22:54:12 Luis R. Rodriguez wrote:
> On Mon, Feb 28, 2011 at 08:47:06AM -0800, Bernhard Schmidt wrote:
> > DFS introduces 2 new flags a channel requiring radar detection
> > might take. The interference flag indicates that interference was
> > detected either during CAC or in-service monitoring and the
> > channel is not to be used for the NOP period. The clear flag
> > indicates that during a full CAC no interference was detected and
> > it is allowed to open a BSS on that channel. The case were both
> > flags are set is used to indicate that interference has been
> > detected and we are in progress of closing on that channel.
> 
> What does closing mean?

Channel closing time is the period between radar interference and the
last transmission on a channel. After detected the interferences there
must be short time frame where you can notify stations about switching
to another channel (CSA).

> > Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
> 
> > ---
> >  include/linux/nl80211.h |    6 ++++++
> >  include/net/cfg80211.h  |   18 ++++++++++++------
> >  net/mac80211/cfg.c      |    6 ++++++
> >  net/mac80211/tx.c       |    6 ++++--
> >  net/wireless/nl80211.c  |    4 ++++
> >  5 files changed, 32 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index e3c9ec7..2282f56 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -1371,6 +1371,10 @@ enum nl80211_band_attr {
> >   *	(100 * dBm).
> >   * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
> >   *	currently defined
> > + * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
> > + *	been detected.
> 
> Why do you need a flag for clear, can you simply count on the
> lack of the flag as the "clear" state?

No. There are 3 states a channel can be in, "usable", "available" and
"unavailable" (as definied in ETSI v1.5.1). On initialization all
channels are "usable", this is indicated by no flag at all. Only after
a full CAC can a channel get "available" (the CLEAR flag) and is now
allowed to be used for beaconing. "unavailable" channels are those
on which interference has been detected, those are marked with
INTERFERENCE, this channel becomes a "usable" (no flag) channel again
after the non-occupancy period.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
