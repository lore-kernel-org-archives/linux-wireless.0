Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57338 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753597AbYIOR5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 13:57:04 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200809151911.32834.IvDoorn@gmail.com>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 15 Sep 2008 19:56:57 +0200
Message-Id: <1221501417.4511.49.camel@localhost> (sfid-20080915_195709_305734_C1180D7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ I've added Johannes to the CC, I hope he can provide us with some mor=
e
informed comments regarding mac80211 architecture ]

On Mon, 2008-09-15 at 19:11 +0200, Ivo van Doorn wrote:
> On Monday 15 September 2008, Mikko Virkkil=E4 wrote:
> > Modeled after the waiting-for-ack queue in the zd1211rw
> > driver, this patch adds a similar queue to the rt2x00. If
> > the tx state of a packet is unknown and a tx ack or
> > tx fail is needed, then the packet is pushed to a
> > waiting-for-ack queue. Each time an ack is received the
> > queue is checked and a possible match is reported to
> > mac80211 as a tx ack.
> >=20
> > If the queue gets filled up the oldest waiting packet
> > will be discarded and a tx fail will be reported.
>=20
> I believe it was mentioned it earlier as well, but this code belongs
> to mac80211 rather than being copied in all individual drivers.
>=20
> I think the best solution would be:
>  - Drivers set *unknown TX status* flag for mac80211
>  - Mac80211 sets the FIF_CONTROL flag for the RX filter (or adds a ne=
w
>    more specific flag FIF_ACK for hardware that allows this specific =
filtering (rt2800))
>  - Driver will set a *unknown TX status* flag per send out frame
>  - Mac80211 keeps track of ACK responses, and decides what to do when
>    no ACK has been received for the frame.

I've also spent some time thinking about this. IMHO, he difficult part
is to come up with an interface between mac80211 and the driver which i=
s
convenient to use for driver writers and integrates well with mac80211.
The following ideas came to my mind:

1. Add another callback to struct ieee80211_ops that would be used for
TX frame housekeeping. The standard implementation would just pass the
frame on the regular tx handler, but we could provide an alternate
implementation that keeps track of the packets we are expecting ACKs fo=
r
before handing the packet to the hardware. Similarly, the RX path would
provide new functions in addition to the existing ieee80211_rx[_irqsafe=
]
handlers that would do the matching ACK matching and pass the packet on
to ieee80211_rx() afterwards.

2. Make the ACK queue approach generic and wrap it in some library
functions that become part of mac80211 and are called from the driver's
tx and rx handlers, respectively. This has the advantage that it is les=
s
invasive than 1. It is essentially what Ivo has described above. Driver
writers would be free to use this framework, but are not required to do
so.

3. Make mac80211 unconditionally keep track about the packets it has
passed down to the driver and do TX status matching on all ACKs that ar=
e
received in the mac80211 rx path. (Note that this has the tendency of
duplicating the ring buffers that most drivers probably already have fo=
r
their TX queues. Maybe introduce a generic ring buffer framework and
allow the drivers to store private data in data and that?) The advantag=
e
of this approach is that mac80211 has information about all packets tha=
t
are still in processing (don't know if that actually helps) and it's
more convenient for driver writers.

>=20
> Note that rt61 might be tricky since that does support TX status repo=
rting,
> but it fails in only 1% of the cases to do this, which means enabling=
 this for rt61
> would be far too much overhead.

I'd opt for the overhead. We have seen that the hardware/firmware
doesn't behave as expected, so I'd rather see a clean approach in
software.

>=20
> > This doesn't use timers so a message might in theory be
> > stuck in the queue indefinitely.
>=20
> Well you wouldn't need timers actually, if you have a list of packets
> waiting to be acked you can expect the frames to be acked in the orde=
r
> of which they were send (when using the same queue).

Agreed.

Mattias

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
