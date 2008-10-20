Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYJTJiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:38:55 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.20459.335157.171344@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uadm/9Ey2nzZ/K2zdYTa"
Date: Mon, 20 Oct 2008 11:38:50 +0200
Message-Id: <1224495531.18024.55.camel@johannes.berg> (sfid-20081020_113904_226184_E86A3512)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Uadm/9Ey2nzZ/K2zdYTa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 15:01 +0530, Sujith wrote:
> Johannes Berg wrote:
> > Can you change your quote string from " > " to "> "? Just asking, if yo=
u
> > can't/don't want to that's fine, it just always confuses me for a
> > second. I really should try to figure out if I can convince my mailer t=
o
> > highlight " > " indented text as quote too.
>=20
> Sure, adding (setq vm-included-text-prefix "> ") in my .emacs did the tri=
ck. :)

Thanks! :)

> > > Well, currently ath9k maintains a buffer list for each tid.
> > > When mac80211 sends down a frame, if the recipient has an aggr. sessi=
on going,
> > > it is appended to the tid's buffer list. Non-HT frames are sent out i=
mmediately.
> >=20
> > Incidentally, why the distinction between HT and non-HT frames?
>=20
> HT frames for aggregation enabled STAs are processed in the TX completion=
 path, so
> they are buffered.

But couldn't non-HT frames be buffered similarly? Maybe I'm missing one
of the finer points of the 11n draft?

> > > On TX completion, we run through all the ACs, STAs and TIDs and send =
out pending
> > > frames as aggregates.
> >=20
> > So basically you can always have one frame or one aggregation
> > "pack" (for lack of a better word) queued to the hw?
> >=20
>=20
> I am not sure, I should check.

Doesn't really matter, I was just trying to make sense out of your
statement of processing it at completion time.

> Makes sense, ath9k currently has a similar set of functions ( pausing/res=
uming TIDs).
> How would the pending frames for each TID be managed ?
> Will the driver be able to pull them as and when needed or would mac80211
> push them down on checking if the TID is awake ?

I guess there's no clear answer here. How about "whichever you want"?
Though I think I prefer pushing them down as that makes the model easier
to understand. It probably also makes the Intel case easier to
implement.

johannes

--=-Uadm/9Ey2nzZ/K2zdYTa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/FGmAAoJEKVg1VMiehFYFJYQAJ1vWZRkuiO39cZiKTdGC4NS
dc7p6mp0fy/TUAg/Gvvq5zrPSLFFO+PGBmqx7Ll+tN6TIgkdU6Ps9YJfEaSdeSMr
cy50s4+IcKJ1f3JasDJ5XhYoowQNbKDJNQIuqaoEf4DpNwLmWCW8uhFmTzrIr7oQ
3CY76x+4Olu42WgXJUINPsE47mzbS24nqtRmojyn0nYTjFJITWYQCe8OdKnNSa0V
lawCsfiRAvjhFY2lsH1pKbu98+eu8EyiwpTkINkkHB+06yiN0kZdHEt+/QeVyHBB
IzUWt+gSS2vVscD3yO2C8qqMtW0jjLSIcOxrGr9LbaoyB4mdXfVlXUENokMRvR0N
gfJIDMjey8/YyP0845/qXwdWFscGQxrjGTPmAOO5v9WE0wRbVrXD/duV3KBVuHko
voN0SQXMYsuO8OT6/F/YZkXwYsCEGMpB8XqMkfdM21roR1HreMuQdfisZmyOIFxb
w4xG+4OWUbK896Hy9dH0M76dueA5W/rAN6SXH7DTDiaEXXMbTXGJAun2xWdaSmti
OE7iBr3EG7YzjodVyZ7BMx/XKsYY9XXirs07hm+7fHolH+G4DPMGkN9pkzbmX7Aw
g6Txb2+QKpuH5Xm8/jBhLKzn4FUfL63WsMpEvl1dc6IXA130KLrgn+prYV56yeC/
K5lcN4WxZazASbfll8l7
=fBJQ
-----END PGP SIGNATURE-----

--=-Uadm/9Ey2nzZ/K2zdYTa--

