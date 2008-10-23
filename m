Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbYJWOqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 10:46:10 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18688.17545.136327.991699@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sy0VT1Ekk9J3j4656Hmu"
Date: Thu, 23 Oct 2008 16:45:24 +0200
Message-Id: <1224773124.6002.32.camel@johannes.berg> (sfid-20081023_164616_701458_27684CAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sy0VT1Ekk9J3j4656Hmu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 15:01 +0530, Sujith wrote:
> Johannes Berg wrote:
> > It seems that should be a rate control decision? Possibly taking into
> > account more than just always doing aggregation sessions. Then again, I
> > suppose aggregation sessions are cheap. What about latency here?
> >=20
>=20
> Well, that is what Luis seems to think too, but our RC
> doesn't do much now, so we try to setup an aggregation session with any
> associated STA.

If that was done in the RC at least (could easily be moved I suppose)
and you cleaned up the RC, then surely nbd would play with porting
minstrel and making it aware of such things, which probably makes for a
better RC... And since you have to clean up the RC anyway :)

> > "maintain minimum HW queue depth"? In what way? You mean put in enough
> > frames?
>=20
> I was talking about this:
> (txq->axq_depth < ATH_AGGR_MIN_QDEPTH) in ath_tx_sched_aggr()@xmit.c

But what does this invariant mean? ATH_AGGR_MIN_QDEPTH is 2.

> > > Well, I really don't know how this would affect performance, but
> > > I think this _might_ be a better model.
> >=20
> > Where would you see it have a noticeable effect on performance?
>=20
> How would mac80211 buffer frames ?=20

Well I suppose it would just put them on a list in the sta_info struct.

> Would it wait for enough sub-frames
> to fill an A-MPDU ?

It should, no? And if for some reason that doesn't happen fast enough it
can send them out anyway, it'll just be a shorter A-MPDU, no?

>  When does it decide that buffered frames have to
> be pushed down to the driver ?

When the A-MPDU is full, subject to the TX and RX constraints, or when
too much time has passed maybe?

I really don't know. But I'd like to get to a model where we can
implement other drivers without having to keep track of all this like
ath9k does.

johannes

--=-Sy0VT1Ekk9J3j4656Hmu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAI4BAAoJEKVg1VMiehFYV24P/RxVzZhIkAwRMBxOS/fGTvBH
PJ5ZUrkE2TAJzcVfqrMwtnCK3I4Fk/Fz3PjCVQ3SxN0wupgyYrGzm6cVEUKhgbHe
Fh0QjKTWxO4SP7AzzWoE3wRATMAvitSUsJgjiywt1YCaoAOXzJi8yIHRGOO6euVQ
yxyQkCKLj0f+XxSPMCeK4MdOq/iP1RBH+5a0BPTrPkJn+y3qN5t+jBQLZP2+Nkh8
382ps/7ZW4xkIFgraDonEA2mKrbmm0w642yPhO/MpKVgE4VJcCEVS63jp5XeIW6O
FJjOEijArZkaG7eaCgRDIt1Wkfvx3RUUJZrV5eS4UDb49aDWhOMwjs3QYEeoWcuE
THjXjPtl6g/omRrnLlC4PMsiwY0dxIXPp6BXuZ2p/xIVvM9ynS6rjoaot+I29kA7
Hwgq9v+zaP99pRSVfMQoLEing3K7P8zu19yd6oe+Am+l8r55TeaNU8x0Zut+aPQ2
MwhsX8iRBa9ZNsUovTKJPibpqr8pRR8YvImZjB3mC4rwZVSPGWnJkkaaeu/w7ACy
N6VkRlenlcaLJ6uedJKc/OpXE99huDiF/DdiTQDqDi3Us0irXLQPIyfiZlE/sbCz
jaY7AvOy9JZPMg+TnttiCpCkVTUxYI1IEB+kZ9C77YBAtVNOvetIRgbeQq1eyyVR
NpNOuvqyVVqtyn/fXIkb
=G7qc
-----END PGP SIGNATURE-----

--=-Sy0VT1Ekk9J3j4656Hmu--

