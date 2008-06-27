Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYF0Tck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 15:32:40 -0400
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joonwoo Park <joonwpark81@gmail.com>,
	JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1214590219.24579.7.camel@localhost.localdomain>
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
	 <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
	 <1211896423.1746.9.camel@localhost.localdomain>
	 <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64>
	 <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com>
	 <1213605989.3803.24.camel@johannes.berg>
	 <20080627152843.GA16003@tuxdriver.com>
	 <1214582853.10355.28.camel@localhost.localdomain>
	 <1ba2fa240806270922u3975220ehb122f33497a69607@mail.gmail.com>
	 <1214590219.24579.7.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nEGaIYFnpMZ/9xDhIUfc"
Date: Fri, 27 Jun 2008 21:12:15 +0200
Message-Id: <1214593935.5507.0.camel@johannes.berg> (sfid-20080627_213244_204808_EE683C5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nEGaIYFnpMZ/9xDhIUfc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > >> Strawman patch below...
> > >
> > > You need to allow 0 through, since you can just set the transmit key
> > > index via ENCODE without setting the key.  So the legal values are 0,=
 5,
> > > and 13.  Add 'case 0: /* just setting TX index */' or something and I=
'll
> > > definitely ack it.

> > >> +     switch (erq->length) {
> > >> +     case KEY_SIZE_WEP40:
> > >> +     case KEY_SIZE_WEP104:
> > >> +             break;
> > >> +     default:
> > >> +             return -EINVAL;
> > >> +     }
> > >> +
> > >>       sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> > >>
> > >>       idx =3D erq->flags & IW_ENCODE_INDEX;
> > >> --
> > >> 1.5.5.1
> >=20
> > I'm not against this patch just I thought we agreed to support the
> > weird WEP keys in the  software. We fixed this in the driver with
> > similar check so now it falls back to software encryption in mac80211.
>=20
> I thought we agreed to ignore > 104/128-bit WEP keys [1][2] until enough
> people yelled about it (I've heard from 1 or 2 people in the past three
> years about this for NetworkManager).

I agree, who wants to write the support for that in mac80211. I said
that we don't want to catch it in wext itself like an early patch did
because some fullmac drivers might support it.

johannes

--=-nEGaIYFnpMZ/9xDhIUfc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZTuLAAoJEKVg1VMiehFYKawP/1Wbv7J7ZhWUjqrWOYNv1I/i
KBTjFDi+YPT5I/Z1IrK7Gi79QD4Ks0MIMHKq3g93vkmR9eWu6GqoQO1763m+f+Gm
uuxVjUnOvTmRX3wnfNq1QeyzXNZg9lLkZh5G3+8EajDJZbybMm7HrzIZTfr/XH6L
5fL00tGkdMXmY819IhijtlUqJCnXdatQgfJQ1ishGV2XFgmwDf71AuAHgiOQ3YLE
8yMT9254Cjb30QbTqmGR3hijF4rKAxojaRM+ECBifBexajWmAs4ZApIsXxHP2AIB
tFcdXFJqKk4dKcnjUm6ey4+p9/VZ4UR9SnxjEpGmDa+EKFOw1FnSBmvV5TeT6gp2
cYSzyfqp8gIQui6lzs0r1ia9TzEJT9dsCOZXVbRSt0Pr1Uq1RNtkVw2BhQteiA3n
DmMiP8bNXVqqlPsiw9OgLUy3//0t//nKK4tCePvz/H/6Eb9lr4qlqFaln0LIxpmg
Lir9CRZ/O5HRlm3HrIuAKPvayon06zzSYX+ZkvPU6qqi4fAQKMlap1Ruv75v+MzD
bM57whNnwzPA//5jDLutIT5Tdtrskmn2EJxRGxzyCyer+IX/3TWJH9bYFo4PAtnh
NDmGR8BxsEMuTMseMN8FH7tiEeMaieJ1Nmrjoxuor/hXa87FHZrMGt032GwolNQj
cS6b4vS+/FxTjsgX5SnE
=iBqB
-----END PGP SIGNATURE-----

--=-nEGaIYFnpMZ/9xDhIUfc--

