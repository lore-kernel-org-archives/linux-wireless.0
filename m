Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16397 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753250Ab0ETCV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 22:21:59 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0831132115
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 11:21:57 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Thu, 20 May 2010 11:21:49 +0900
References: <20100519012528.22206.77550.stgit@tt-desk> <201005201012.12045.br1@einfach.org> <AANLkTimso6hoef9IG2VtRQsHQiOVTQF-dwNZEooZTb3Y@mail.gmail.com>
In-Reply-To: <AANLkTimso6hoef9IG2VtRQsHQiOVTQF-dwNZEooZTb3Y@mail.gmail.com>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005201121.49846.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 May 2010 10:26:29 you wrote:
> >> > > > + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for
> >> > > > transmitting. + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to
> >> > > > use for receiving.
> >> > > 
> >> > > This gets the job done, but that's it. The API defined allows for a
> >> > > hugely loose implementation on each driver.
> >> > 
> >> > i tried to define it like this, in the commit log:
> >> >     The antenna configuration is defined as a bitmap of allowed
> >> > antennas. This bitmap is 8 bit at the moment, each bit representing
> >> > one antenna. If multiple antennas are selected, the driver may use
> >> > diversity for receive and transmit.
> >> > 
> >> > is this not precise enough?
> >> 
> >> No, the commit log is just a placeholder of information, if you want to
> >> define API you do it through the kdoc so you can slap people when then
> >> submit patches that do not follow it. The kdoc above allows the
> >> flexibility you were looking for but that I do not think we should have
> >> since it will confuse the users who want to tune antenna settings on
> >> different drivers.
> > 
> > you are talking about the place where to put the definition, not about
> > the definition itself. i agree, the definition should be in the kdoc,
> > and i'll update the patch. what's wrong with the definition itself?
> 
> Why are you using a bitmask for only 3 possibly different settings?

because there are more than 3 different settings, like i mentioned at the end 
of my last mail.

so, just talking about ath5k, right now we support only the 3 different 
settings, you mentioned (fixed a, fixed b, default: diversity), true. other 
drivers might support a different number of settings though, so just assuming 
everyone follows these 3 definitions would be not enough, imho.

and it's very easy to add to ath5k:
 - "RX on A, TX on B" or "RX on B, TX on A" (this makes sense if you want to 
use a "big" (high dB) antenna for listening, but use a "small" (low dB) 
antenna for sending within the regulatory limits).
 - TX on a fixed antenna, while using RX diversity

that's why i decided for a bitmap.

> >> > > And yet for another driver it could be something completely
> >> > > different in usersepace.
> >> > 
> >> > what do you think that could be, realistically, given the above
> >> > definition?
> >> 
> >> Well, anything that has to do with tx / rx antennas.
> > 
> > that's not very clear. can you give me an example?
> 
> iw dev wlan0 set_tx_antenna 4

so you want to transmit on antenna 3. if the card has 3 antennas - 
why not?

> > what if there is a 'legacy' hardware with 3 or more antennas?
> 
> Like what?

i can't find an actual real world example for that, but it thought it might be 
possible, from what i know from the atheros eeprom which seems to be prepared 
for up to 6 antennas.

> > what if we want to configure RX on antenna 1, TX on antenna 2?
> 
> Are you not using a value for TX and RX? Would that now allow for this?

there are different values for TX and RX, so it would allow for that.

> > i don't see how "my" API is too complicated, and i think it allows for a
> > clear configuration of these cases as well.
> > 
> > your criticism seems to be based on the fact that it's not clear how to
> > handle 802.11n chainmask + antenna configuration, but this is not what
> > my patch is concerned about. let's go step by step...
> 
> No no, that is my fault, I brought that up, I was hoping we could
> address it but it seems that we can't as I don't have time to think
> about this further in a unified clean API. But if its just going to be
> legacy then I don't see why we would use a large bitmap.

i wanted it to be easily extensibe for 802.11n and possibly 'legacy' with more 
antennas in the future. if there really are not any pre-N cards with more than 
2 antennas out there, and we are sure we don't want to support more than 2 
antennas - well, we could save 6 bits... is it really worth it?

bruno
