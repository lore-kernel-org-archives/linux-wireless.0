Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYBNP57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 10:57:59 -0500
Subject: Re: mac80211: net_sched vs. HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240802131531u46634558o46d4ff4f8b8c3d4a@mail.gmail.com> (sfid-20080213_233128_584262_CFD0ABE3)
References: <1202489552.24811.10.camel@johannes.berg>
	 <1ba2fa240802100830t772b245fgf9e54ae058b384fa@mail.gmail.com>
	 <1202889691.8931.25.camel@johannes.berg>
	 <1ba2fa240802131531u46634558o46d4ff4f8b8c3d4a@mail.gmail.com>
	 (sfid-20080213_233128_584262_CFD0ABE3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hNk7sp4fLIbE34TSDcID"
Date: Thu, 14 Feb 2008 16:57:46 +0100
Message-Id: <1203004666.8931.145.camel@johannes.berg> (sfid-20080214_155804_390541_28DEC40E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hNk7sp4fLIbE34TSDcID
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> There is no use of QoS and HT without NET_SCHD so we should not
> announce support for HT or QoS in that configuration

Ok. Ron, can you maybe make a patch? You're more familiar with where the
HT hooks are and where stuff would have to be optional. Unless of course
[see below]

>  but I'm not sure
> if it's worth the effort to compile mac80211 without NET_SCHED.

Maybe we just want to make mac80211 depend on NET_SCHED then? I
personally think that is a good thing since otherwise drivers will also
have to have code that depends on NET_SCHED for QoS features etc.

> The number or aggregated frames in AMPDU is determined by handshake
> maximum is 64
> IIRC but also dynamically but how many frames fits into TXOP and this
> is also function of how fast are packets brought the HW

Right.

> > In any case, I think this confirms my idea of splitting up the "queues"
> > hardware specific value into "queues" and "ampdu_queues" where "queues"
> > are the number of FIFOs with QoS parameters and "ampdu_queues" are the
> > number of helper DMA queues for ampdu support.
>=20
> That would fit perfectly

Ok, let's do that then as in the WIP patch I had posted.

> Broadcom doesn't seem to
> > use extra DMA queues for this, the aggregation decisions are (afaik
> > since the hw has no extra queues I can find) all made in the driver. I
> > suppose b43 will then have to fake a reasonable number of "ampdu_queues=
"
> > and handle it in the driver.
>=20
> Not sure how retransmission is handled. Where a  packet sits when it
> fails transmission in the single aggregation... that would be a major
> concern.

TBH, I don't know yet.

> > > The limited number of queues is acceptable again due to fact that
> > > medium is shared and you cannot really utilize too many BA ssessions
> > > at the same time. Some policy of eviction based on link quality is
> > > required and still not implemented.
> >
> > Expected traffic too, I would think, no? If the traffic from/to a
> > specific station drops below a threshold I would expect to tear down th=
e
> > BA session.
>=20
> That's what we would do part of rate scaling... currently only the
> establishment is done not tear down.

Right, it should be part of rate control. Just trying to understand what
should happen.

> Hope we soon free our schedule to push this little.

:)

johannes

--=-hNk7sp4fLIbE34TSDcID
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7Rk+KVg1VMiehFYAQI2fBAAl5ljZZzO9Ts0dwVvT7bZ3z5bIQzXcPI4
+Txwo7b1IiZXjIhJghEmaPOXS5EFeEn1pRwbIDdkbuvpslBnbvFlGhZnPqz1dvBj
XXCjqmBIeeqA3i87cJOcsIuKhEThnKPtpDKuFTAZ2pvQXaVJW5gt13aoaS3SKnT8
LeIFV0B8N31srAxm5Ht/Il4Qo7HrRQoyeTibfPasZAke5OnhgiLYz8rSLF7Fnzmt
ROT2aa2r339cY/dEyuIAVNvd58TgNEPRBn+mF6O3VwOvFUQ1yvwbHnJIrSS8DdUr
CXc+h0f/TQYHGJIoS8vhUycmLX0dJFtYqVIT6IscjbARd+E5GPTaC8bESTr8/nEf
8pGnii9GJcHeXpqMr8yG8hpbULwNN389PJlWkKT24CESOx/rNunnvsbTjXGAql+O
MvlFfKT7mfWSMBJ1oRm6obrvNBrw2kq7rspvVaJtAPbarzYRrvBelHS1pALZH1xw
CgshvD593xSjdRe5GQ//MB4bzigThQxkXw4wBXE8JFgA4I+9iIPDejrfXHNMUZiZ
gdDSuTD7T0XWhKCumiIcw1U3rff3PJQX1idgku/+ujh6G8t6E1yPVXAWWKtCw9ei
nIh2oyHYEg3/EC+HLDOSOSeTle5lEQvbWZPxy/qfbh+bVYWnFP5OL8e0zs+EQ8/V
OncbBaEnrgI=
=Qhd3
-----END PGP SIGNATURE-----

--=-hNk7sp4fLIbE34TSDcID--

