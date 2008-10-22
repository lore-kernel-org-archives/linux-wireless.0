Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYJVKAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 06:00:19 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.51206.771543.514682@localhost.localdomain> (sfid-20081020_200625_923547_73E95547)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 (sfid-20081020_200625_923547_73E95547)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SXDu/4Dt/NfZE7L1Y7xW"
Date: Wed, 22 Oct 2008 12:00:11 +0200
Message-Id: <1224669612.28639.49.camel@johannes.berg> (sfid-20081022_120035_613813_AA235082)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SXDu/4Dt/NfZE7L1Y7xW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 23:33 +0530, Sujith wrote:

> > Can you explain the way it currently works in ath9k?
> >=20
>=20
> Alright, it goes something like this:

Thanks.

> * mac80211 sends down a frame
>    * Initiate an aggregation session for the <RA,TID> if one isn't alread=
y in progress.

It seems that should be a rate control decision? Possibly taking into
account more than just always doing aggregation sessions. Then again, I
suppose aggregation sessions are cheap. What about latency here?

>    * Pause the TID, i.e, add further frames to the TID's queue.
>       * If ADDBA exchange is successful, resume TID.
>          * Form aggregates from the TID's buffer list, send them out.
>            ( Take care to maintain minimum HW queue depth for aggregation=
 )

"maintain minimum HW queue depth"? In what way? You mean put in enough
frames?

>       * If ADDBA exchange fails, flush TID.
>          * Send TID's pending frames as normal frames (non-ampdu)

Obviously. But why isn't this done in parallel? I mean, why not send out
the frame and do addba and don't aggregate until addba was successful,
that would mean no latency for those frames... addba could even time out
which would add a lot of latency, no?

> Now, assuming we have a successful aggregation session going,
> frame handling looks like this:
>=20
> * mac80211 sends down a frame
>    * Append to TID's buffer list.
>=20
> On TX Completion,
>=20
> * Process all TX queues
>    * Process all complete descriptors.
>       * Complete all sub-frames of an aggregate that were ACKed (send sta=
tus to mac80211).
>       * Re-queue sub-frames that were not ACKed back to the TID's pending=
 queue.
>           * Schedule this TID for processing.

Those have to go in front of the queue, right? So they're sent out next?

>    * Run through all scheduled TIDs
>       * Form aggregates from the pending buffers and send them out.
>         ( Again, maintain minimum HW depth )

Which TIDs are "scheduled"?

> So, aggregation is currently done on a need-to basis, and changing this
> to a flow where mac80211 sends down frames with A-MPDU related control in=
formation
> would mean a complete rewrite of ath9k's TX path. :-)

So what? :) I'm trying to avoid having to do all this again and again in
b43, rt2x00 etc. The hw really behaves very similarly.

> > Also, I'm trying to understand the relation between a block-ack
> > agreement and A-MDPU, I understand that without a block-ack-agreement
> > aggregation isn't very useful, but could we not, for example, implement
> > (regular) delayed block-ack with much the same infrastructure?
> >=20
>=20
> Immediate Block-Ack is mandatory for 11n, delayed BA is optional.
> ath9k currently maintains the BA window state internally too.
> Another candidate that can be moved to mac80211, IMO.

Yeah, I agree. There's information on this in the tx status even I
think.

> > What I could also imagine is that mac80211 simply does pretty much
> > everything and hands a number of skbs to the driver at once with some
> > additional information about how to aggregate them, what sort of spacin=
g
> > to use, etc. It should be able to calculate all the required stuff sinc=
e
> > it knows from the rate control algorithm what's happening there. That
> > might leave Intel out a bit, but I'm starting to think that we want to
> > special-case them a bit anyway.
>=20
> Well, I really don't know how this would affect performance, but
> I think this _might_ be a better model.

Where would you see it have a noticeable effect on performance?

johannes

--=-SXDu/4Dt/NfZE7L1Y7xW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/vmoAAoJEKVg1VMiehFYwAwP/jlWlYg+XcBocw/AI+dQ8DM8
JGjwuPHVV0PX2aq0g1PKMMayS7O3o8LWge6Zt2BoGF4c01vu9zBbZgtVfRaIxFCx
pe4CzFN61W1Ib2+rUGCc+d0D+Dh0f0MUaOmzXUa39qfdwwnvGHuIIdXCPP2EQpyK
Y8wSd+7vrEkYYOfpENC1H4oNtNZYdToUdCMa862nLNXHRAGIj5AWkBJwt9PNXD9h
oXb0Pm9snit0HG3fwRV4Z9HqGMqucdBpQvj0UUCO84aQELTVAAHi7LgvMDylCGKZ
4NFq9kAUCHiydrvqIzLoi1WV2IHXhmmJYiTXJN+2cvYyNmwdvKik6xdt+d4nwOPl
rmRNglL4ujLBsSPi/+FJSJx7KLbP63J6DguKCtL7vnGz7/Fmr+sVvVAZCG6hk5+s
n+wywYMaealg2yOpQxpYxdZHAvLMRVdXuf6xOS3zXn76QdppKXj5EZ9J+EbIHdu4
Y6w1S5xrQg4NCE0eOBNveurbljzNKOuaa/mlwU3HLu02aY6LU8jBH4RNBEIdGm38
JsiWthTuGi1I9nwdeYkWeo8TZAOliOb2mMkSV3V42bBIYhzzcQIc4qLvL7M47jI7
d5Q9txEnze2pAhIlpSAbai4UoFkMcpuh/CLlXxMbIAiLNa51tljTLWXtB3vwf8d7
FuD4bjgWC5FdFlD6opmM
=0ReJ
-----END PGP SIGNATURE-----

--=-SXDu/4Dt/NfZE7L1Y7xW--

