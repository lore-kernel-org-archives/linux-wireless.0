Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:11097 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYISSbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 14:31:06 -0400
Received: by ey-out-2122.google.com with SMTP id 6so183272eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 11:31:02 -0700 (PDT)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: ACK matching [was: TX status reporting with help of an ack queue]
Date: Fri, 19 Sep 2008 20:30:58 +0200
Cc: Mikko =?iso-8859-1?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
References: <1221494693.14102.22.camel@virkkmi-linux> <1221815294.19539.15.camel@virkkmi-linux> <1221817584.4491.29.camel@localhost>
In-Reply-To: <1221817584.4491.29.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200809192030.58550.IvDoorn@gmail.com> (sfid-20080919_203110_135925_A25B6C22)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 September 2008, Mattias Nissler wrote:
> On Fri, 2008-09-19 at 12:08 +0300, Mikko Virkkil=E4 wrote:
> > On Thu, 2008-09-18 at 22:29 +0000, Mattias Nissler wrote:
> > > [I've added the zd1211rw maintainers to the CC, I hope they can s=
hed
> > > some light on the question whether the ack queue mechanism that d=
river
> > > has is actually correct]
> > >=20
> > > I've had a closer look at the idea of deciding whether a frame ha=
s
> > > been
> > > transmitted succesfully by monitoring incoming ACK frames and I'v=
e hit
> > > a
> > > fundamental problem: How do you correlate incoming ACK frames to =
the
> > > frames that were actually transmitted? The ACK frame only carries=
 the
> > > address of the station that transmitted the frame being acked, no
> > > further information. Now this means if you have the hardware TX t=
wo
> > > frames and receive one ACK frame in the RX path, you cannot know =
which
> > > TX frame the ACK belongs to, because they will be identical, righ=
t?
> > >=20
> > > The hardware, however, knows, because the ACKs are required to be
> > > transmitted directly after the corresponding frame is received, b=
ut we
> > > don't know in the driver about this timing information, at least =
not for
> > > rt2x00.
> > >=20
> > > I wonder whether the ack queue idea Mikko found in the zd1211rw d=
river
> > > is actually working correctly for that driver? I've only had a sh=
ort
> > > look, but found that incoming ACKs are only matched against trans=
mitted
> > > frames by means of the address carried within the ACK. So I'd thi=
nk in
> > > the situation I outlined above, the zd1211rw driver will also be =
unable
> > > to match the ACK to the correct frame. Any comments on this?
> > >=20
> > > Mattiass
> > >=20
> >=20
> > AFAIK your analysis is correct and I think this is somewhat of a kn=
own
> > problem with the implementation in zd1211rw driver. I haven't come
> > across a way of getting around the problem. I read some suggestions
> > about stopping all transmission to a certain address until we get a
> > status update for the previous packet sent to that address, but iir=
c
> > this was deemed impractical. On the other hand the current
> > implementation in zd1211rw (and hopefully soon in rt2x00) doesn't r=
eally
> > break anything that works without it and on rt2x00 it gets AP-mode =
in a
> > somewhat more usable state.=20
>=20
> Well, as long as nothing vitally depends on the transmissions status
> (i.e. MAC layer acknowledgements in 802.11 lingo), you are right that=
 it
> won't break anything. Nevertheless, it is code that is known to be
> working incorrectly and non-fixable, so I'd vote against it (I'd rath=
er
> live with the approach of always reporting successful tx status as yo=
u
> have proposed earlier if I had to choose from the two of them). Maybe=
 we
> just have to accept that there is hardware that cannot report MAC lay=
er
> acknowledgements back to the driver. Unless somebody comes up with a
> feasible idea how to do it. Ivo, do we have a contact at Ralink to as=
k
> about this?

The Legacy USB drivers don't care about the TX status, if it wants to k=
now
the TX statistics it reads the register which contains the ACK/RTS coun=
ters
and determine with those values if the link is good or not.

Seeing that the PCI drivers also don't really care about the TX status =
(other
then setting some statistics) I think we can assume the TX status isn't=
 important
for the Ralink people.

But I'll send a mail to Ralink to see if they actually do have some ide=
as about it.

> This brings up the question whether we can do without tx status
> reporting. Does anyone know why hostapd requires the tx status? As fa=
r
> as I understand, mac80211 only uses the tx status reporting only for =
the
> tx rate control. Rate control algos that don't use tx status are
> definitely feasible (and in fact we'll need one for rt73).
>=20
> I'll look into hostapd to figure out whether the tx status reporting =
is
> really required when I find some time. However, I've just received
> rt2800 hardware, so getting the rt2800 driver going is my top priorit=
y
> for the next weeks.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
