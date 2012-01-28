Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52648 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2A1WOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 17:14:51 -0500
Date: Sat, 28 Jan 2012 23:14:52 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user
 supplied rts setting
Message-ID: <20120128221452.GB22180@pandem0nium> (sfid-20120128_231454_903536_CA3EC4E3)
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de>
 <201201290409.07368.lindner_marek@yahoo.de>
 <CALSq=BbhM6vLOJt9MGi2BhHKO0-NzAm73WohLDy4YC7x9rpDmw@mail.gmail.com>
 <201201290435.14048.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
In-Reply-To: <201201290435.14048.lindner_marek@yahoo.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I agree to Marek here - if I want to disable RTS (for whatever reason), I t=
ype

iw phy0 set rts off

I would expect to see no RTS frames coming from my WiFi card at all. If the
rate control algorithm (whether ath9k or minstrel_ht) wants to be clever, i=
t should
still respect this decision. The oven in my kitchen also has a temperature =
regulator,
but if I turn it off I also don't want my oven to be too clever and burn do=
wn the house. ;)

I know, apples and oranges, but I hope this makes this point understandable=
=2E I also
had quite a debugging night to find the reason for these "wild rts" frames.

Can't we add something two states, like:
 * "RTS really off" and
 * "RTS usually off, but rc's may still use it" ?

Cheers,
        Simon

On Sun, Jan 29, 2012 at 04:35:13AM +0800, Marek Lindner wrote:
> On Sunday, January 29, 2012 04:26:29 Daniel Halperin wrote:
> > >> Can you explain what the low-level behavior of an RTS/CTS "battle" i=
s?
> > >>=20
> > >> Abstractly, the behavior you're describing sounds like a buggy driver
> > >> that doesn't obey overheard RTS or CTS packets.
> > >=20
> > > I certainly can explain it but this is for another thread and unrelat=
ed
> > > to the points raised before.
> >=20
> > Frankly, the correctness of your argument depend on whether there's a
> > bug or not. If the difference is -2% normally and +300% in bad
> > interference conditions, you're going to lose this debate. If the
> > difference is legitimately -99% normally, you might win.
>=20
> I don't quite follow you here. Are you saying it should only be possible =
to=20
> disable rts/cts if I currently have a bug in my rts/cts implementation ?
>=20
> Keep in mind that I am not asking to disable/ban rts/cts for everyone. I'=
d=20
> like minstrel_ht to not override my rts/cts setting if I wish to disable =
it.
>=20
> Regards,
> Marek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8kc1wACgkQrzg/fFk7axYycgCghuhjgD9XrLcwDFR44l1Vsog4
WgwAn2BMRAbjRO06/ZdstoRIZqU4XLnc
=Nx5/
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
