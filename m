Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:34913 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXFMNSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 09:18:21 -0400
Date: Wed, 13 Jun 2007 15:18:13 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lamparter <lists@diac24.net>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] {cfg,nl}80211 API - 802.11j
Message-ID: <20070613131812.GA5493@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net> <1181730155.29767.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181730155.29767.77.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > - struct ieee80211_channel:
> >   use (phymode, channel, 80211n-mode) as "key"; kill off frequency
> >   (which will move to some get_channel_foobar function)
>=20
> Hmm. Maybe we should've kept frequency. How do we want to handle
> dot11ChannelStartingFactor (see 17.3.8.3.2 Channel numbering in
> 802.11j), I quote:
>=20
> Change the text of 17.3.8.3.2 as follows:
> Channel center frequencies are defined at every integral multiple of =
5 MHz above Channel starting
> frequency. The relationship between center frequency and channel numb=
er is given by Equation (27):
>=20
>    Channel center frequency =3D Channel starting frequency + (nch =C3=
=97 5) (MHz)                      (27)
>=20

(nl80211 part:)

Well, I would handle it exactly like that. Keep channel numbers, add
channel starting frequency as configurable (regulatory?) parameter for =
the
device.

The mapping between channel numbers an frequencies, while for most case=
s
fixed, can't be assumed to be so under all circumstances. Applications
should use CMD_GET_CHANLIST to get a list of stuff supported. If the de=
vice
is configured to use 11j 4.9GHz band, that list might for example conta=
in:

 mode=3D80211A   channel=3D184  # frequency=3D4920
 mode=3D80211A10 channel=3D184  # frequency=3D4920
 mode=3D80211A10 channel=3D186  # frequency=3D4930

(no idea whether that channel exists, example pulled from hot air using
channel start =3D 4000M)

(cfg80211 part:)

Now the real question is how to handle that inside the kernel... you're
right, unless we introduce a channel_to_freq function which takes both
the channel structure *and* the base frequency as parameters, we need t=
o
have the frequency in struct ieee80211_channel.

Anyone feel like elaborating (dis)advantages of those two? Drivers migh=
t
actually be setting their RF using the channel value, having a non-matc=
hing
freq might confuse things... OTOH, having the final frequency is nice
too... this requires some thought :/.

=2E.. since for most devices there is a fixed (phymode)->(channel_start=
)
mapping, I'm tempted to say "have channel_start be a mode parameter" fo=
r
now.

Anyway, 802.11j needs configurable channel *width* too (10M/20M). I'd a=
dd
it as "80211A10" phymode; that wouldn't require any new API or stuff. A=
nd
for setting the channel starting frequency, the regulatory API might bo=
th
make sense and be the closest thing related.


(btw, I think we should multicast NL80211_CMD_NEW_CHANLIST notification=
s
on regulatory updates).


-David

P.S.: Just for fun, we could actually have the set_channel part work on
802.16 (WiMAX) devices too :) - we only need to return an appropriate
channel list, define a phymode value and *poof* universal channel switc=
her
:)
P.P.S.: Just joking.

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
