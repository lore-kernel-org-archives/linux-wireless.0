Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJVRXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:23:00 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Sujith <m.sujith@gmail.com>, Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com> (sfid-20081022_135935_328975_B533AAA0)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 (sfid-20081022_135935_328975_B533AAA0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L9OPx86pMiCReUa5YP69"
Date: Wed, 22 Oct 2008 19:22:50 +0200
Message-Id: <1224696170.30459.12.camel@johannes.berg> (sfid-20081022_192306_524654_0B06F41E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L9OPx86pMiCReUa5YP69
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 13:59 +0200, Tomas Winkler wrote:

> It answers BA i n RX path and interpret BA in TX Scheduling
> retransmission of not acked frames is done in HW (not firmware) no
> need to requeue them. In corner case when retries are exhausted  BA
> request is issued from mac80211 to advance RX side window.

Ok, but if we do both of that in mac80211, it wouldn't really matter
since we never see the relevant frames, right? Or we can add a flag to
ignore them.

> > Like I said, from what I can tell bcom is really similar, and I'd like
> > to not have to re-implement all this first. mac80211 used to have a mor=
e
> > push-model, which we've deviated from with the HT stuff you did, but fo=
r
> > most hardware the push-model is still appropriate, so imho we should tr=
y
> > to go to one even with HT and then see.
>=20
> Works for me. What I stumble upon is retransmission from within TX
> response  path
> how this go together with context of regular TX path. Even in iwlwifi
> we need to be able to kick/start the internal aggregation queue?

Yeah, this is something we definitely need to work out. We haven't even
managed to decide yet how aggregated packets are given to the driver :)
I think for atheros and bcom a model where mac80211 decides pretty much
everything and hands the driver a list of skbs to aggregate would work
best, but then I think that wouldn't work with your hw at all.

> > We've since reworked rate
> > control to be able to cope with HT too, so mac80211 can have much more
> > information about what's going on and should be able to make many of th=
e
> > necessary decisions.
>=20
> What to remind that iwl-agn-rs update rates scale out of band meaning
> TX packet doesn't bear the rate scale information. The reasoning
> behind is that appropriate rate is picked up when packet is ready to
> go on the air and not when it's somewhere deep in the queue.
> Otherwise it's regular multiretry algorithm.

Well, yeah, but the best thing we can do if we don't do it in firmware
is actually determining it at the point we stick the packet into the
queue. I wouldn't mind moving all iwl-agn rate scaling into the driver
and telling mac80211 that it doesn't need rate scaling, but I'm not
quite sure how this affects aggregation?

johannes

--=-L9OPx86pMiCReUa5YP69
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/2FlAAoJEKVg1VMiehFYXIcP/jscw6EfFau/JHMn72Q13WMp
3b4Vi7ynZN9h5iWcI37it4i0gstFYjH3L4cct8ljJuaO27DXUDtNkvoohnBmVWS5
I4E3dTPzVtytePUWhK4uKtag9AAmtpPZe/HHmC1c+VROFkqBDNDOhYJCRv75tSPB
BESpevtu8voESrhOY3BW8EFvZsBxPJYPsYnEMm0aLA/fnfZ3Tmp4vDbO7aANPy5+
9MzLtC81T9/KQCe8J6KRaeKM4b4zpt3Lz2/i3k7E8k+CdT8UXD+ouPUc9h5y3YoH
0sNaaUxoLkGXNHvSvnTr1Q8+2cT7W4nGO++mZPXUOjhAnCczB2hddYikd03UTTvA
WFZLATIaYNpm+oy4ReUsK4LFLVy7v+JAE7ACVVgFOCbJXACrSMgzvYC3kIw9tQGN
udJ8pSqTkXPRQuV+KTTrbxsbfLY2ag8o0jsT17Qqmvt6eXyz7k/oj7r7c+/M6KVD
Saxjog0lTbQFFwWCdfSja2mZ5z4duUWc5GL8QMyHMAbHAr+QeiQfjYXFiHTzo8/x
78JQjAjss7eUj8ZUbzKdRI1pvfLZ6mallLDyrssa6Pces3xINSe5Xs5i8ILgXU60
/++zPwEvonpon996Cwe69tjgY7yssSi6xNyety1mvLbO8kEVHJ7QUA9vBa0TO/79
ruiviEmzDWrDknWdymoC
=Rl/Q
-----END PGP SIGNATURE-----

--=-L9OPx86pMiCReUa5YP69--

