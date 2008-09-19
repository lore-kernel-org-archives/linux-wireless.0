Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56720 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750876AbYISJq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 05:46:28 -0400
Subject: Re: ACK matching [was: TX status reporting with help of an ack
	queue]
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <1221815294.19539.15.camel@virkkmi-linux>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 19 Sep 2008 11:46:24 +0200
Message-Id: <1221817584.4491.29.camel@localhost> (sfid-20080919_114636_227625_740F4185)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-19 at 12:08 +0300, Mikko Virkkil=E4 wrote:
> On Thu, 2008-09-18 at 22:29 +0000, Mattias Nissler wrote:
> > [I've added the zd1211rw maintainers to the CC, I hope they can she=
d
> > some light on the question whether the ack queue mechanism that dri=
ver
> > has is actually correct]
> >=20
> > I've had a closer look at the idea of deciding whether a frame has
> > been
> > transmitted succesfully by monitoring incoming ACK frames and I've =
hit
> > a
> > fundamental problem: How do you correlate incoming ACK frames to th=
e
> > frames that were actually transmitted? The ACK frame only carries t=
he
> > address of the station that transmitted the frame being acked, no
> > further information. Now this means if you have the hardware TX two
> > frames and receive one ACK frame in the RX path, you cannot know wh=
ich
> > TX frame the ACK belongs to, because they will be identical, right?
> >=20
> > The hardware, however, knows, because the ACKs are required to be
> > transmitted directly after the corresponding frame is received, but=
 we
> > don't know in the driver about this timing information, at least no=
t for
> > rt2x00.
> >=20
> > I wonder whether the ack queue idea Mikko found in the zd1211rw dri=
ver
> > is actually working correctly for that driver? I've only had a shor=
t
> > look, but found that incoming ACKs are only matched against transmi=
tted
> > frames by means of the address carried within the ACK. So I'd think=
 in
> > the situation I outlined above, the zd1211rw driver will also be un=
able
> > to match the ACK to the correct frame. Any comments on this?
> >=20
> > Mattiass
> >=20
>=20
> AFAIK your analysis is correct and I think this is somewhat of a know=
n
> problem with the implementation in zd1211rw driver. I haven't come
> across a way of getting around the problem. I read some suggestions
> about stopping all transmission to a certain address until we get a
> status update for the previous packet sent to that address, but iirc
> this was deemed impractical. On the other hand the current
> implementation in zd1211rw (and hopefully soon in rt2x00) doesn't rea=
lly
> break anything that works without it and on rt2x00 it gets AP-mode in=
 a
> somewhat more usable state.=20

Well, as long as nothing vitally depends on the transmissions status
(i.e. MAC layer acknowledgements in 802.11 lingo), you are right that i=
t
won't break anything. Nevertheless, it is code that is known to be
working incorrectly and non-fixable, so I'd vote against it (I'd rather
live with the approach of always reporting successful tx status as you
have proposed earlier if I had to choose from the two of them). Maybe w=
e
just have to accept that there is hardware that cannot report MAC layer
acknowledgements back to the driver. Unless somebody comes up with a
feasible idea how to do it. Ivo, do we have a contact at Ralink to ask
about this?

This brings up the question whether we can do without tx status
reporting. Does anyone know why hostapd requires the tx status? As far
as I understand, mac80211 only uses the tx status reporting only for th=
e
tx rate control. Rate control algos that don't use tx status are
definitely feasible (and in fact we'll need one for rt73).

I'll look into hostapd to figure out whether the tx status reporting is
really required when I find some time. However, I've just received
rt2800 hardware, so getting the rt2800 driver going is my top priority
for the next weeks.

Mattias

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
