Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZK3Rhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:37:36 -0500
Subject: Re: [PATCH 2/2] mac80211: enable spatial multiplexing powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890911300922t49cafcacu3396fe7907b21b6e@mail.gmail.com>
References: <20091130153857.963079149@sipsolutions.net>
	 <20091130154300.647360542@sipsolutions.net>
	 <43e72e890911300854i69ddb18dxcd34d38f0d610004@mail.gmail.com>
	 <1259600677.32171.25.camel@johannes.local>
	 <43e72e890911300922t49cafcacu3396fe7907b21b6e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-822qjQ0Mji0hp8Zmru0g"
Date: Mon, 30 Nov 2009 18:37:38 +0100
Message-ID: <1259602658.32171.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-822qjQ0Mji0hp8Zmru0g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 09:22 -0800, Luis R. Rodriguez wrote:

> >> > +               ieee80211_queue_work(&local->hw, &local->recalc_smps=
);
> >>
> >> OK from what I gather so far we just queue work if we received an ACK
> >> from the action frame we sent. Since we tell the device to
> >> ieee80211_stop_device() the device should have stopped RX'ing and that
> >> *should* mean preventing processing future tx status reports. We'll
> >> find out if that assumption is wrong.
> >
> > It's not about receiving -- only about transmitting.
>=20
> Yes but this is not about a actual transmit but a tx status.

Right.

> > But yeah, we'll
> > find out. I have a patch pending that'll flush queues etc., that would
> > make it completely impossible if implemented by the driver, but I don't
> > think we need to worry about it.
>=20
> What I mean is that technically a driver could have called even this
> new tx flush and yet *after* that was called a tx status for a
> *previously* transmitted frame could have come through hardware, which
> is why I mentioned hw stop. hw stop would seem to be the only thing
> ensuring we don't queue more work if we'd try to pm-suspend between
> the point where we enabled smps and before the AP sent an ACK to us
> for the action frame.

Yeah, I see what you're saying, I just don't think it'll actually
happen. I guess we will find out by the warning if it ever does.

> OK I see. Then the next question is can iwl3945 and iwlagn report tx
> status for a nullfunc sent to an AP?

It doesn't matter for them -- they do it all in the firmware. hw_scan
and complete PS mode offload.

> > Well, it doesn't matter either way. However, it was easier this way for
> > iwlwifi because ultimately we want to turn off all but one chain if
> > non-HT and/or static SMPS. So at least there it made sense to use STATI=
C
> > here to avoid the extra check. But other drivers may or may not want to
> > ignore it completely in the HT case. I've documented that it sets it to
> > STATIC when a non-HT association is used just for more use. It could be
> > anything really, or even an invalid value. Also remember that SMPS_OFF
> > means all chains turned on.
>=20
> Hm -- so hardware would *typically* leave all chains on even for
> legacy mode of operation?

It depends on what you're after. You can leave them all on, and you'll
have better reception. Or you can turn off all but one, and you'll save
power. Better reception doesn't help you _much_ because the AP still
also has to receive your stuff, and if it's a legacy AP it only has one
chain so you receiving it well won't necessarily mean it receives you
well enough for a connection -- we would therefore like to save more
power and use only one chain on a legacy AP. Hence the default here, it
makes it easier the way iwlwifi is done.

I had "Automatic" here as the default in my first iteration of the patch
but it just ended up being a few lines of code more in iwlwifi and no
real difference in mac80211.

johannes

--=-822qjQ0Mji0hp8Zmru0g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFALfAAoJEODzc/N7+QmaGwkP/R/U+2Q3TmqukLzagtbe5L3D
ZzncQbGHzGSz4QKTzaCRh1HMdyUFg4z4Jcj3vtFWD+xyl7Ym14urY4BHzxikkJ1E
TwrV6tBA/nkKNWa+1pFCK96fb/vuFUp9BJxFYKgUgTRmZV1L3LF4rQQw+oJJz2QQ
EKoxOArGGlTQ4QELhzfATk5o8v2Ut3c78uboQwiDw4CS/crohk7pk4pRukMW6R2g
bshTx23xoqu7/msjKJ18RiZJ5cnrrZT0399+lWTiU5/MX01P8drQ0JEL4dVVUE5R
kDw5sG//+plKhAiAVTY00UQInzkLPhGdup5hybYSi/w2qyDNrBMIwiQ1FAWF8rA5
HPkJGjnH7n6iMwIVdyz/EjMeQEmdpUETE6lQRcvyxCq6B+EZj2fxPW4H+HxoQ7qY
cEKrltSJsfHOZLSU9O7IDXKw3HRKC8oz0tVSG4JPyVa9uQA368LOjqSfLcc1AGib
zgV4Ctten7rImxPibCKoFpMy4NCdx8VYRLcisWZ+6+JdiJE6OJGdmhaZeG0xpMiW
4rEVCdUbSnX8m16oaPfIPjabfH/7RQYR+JWJDqjODqxE/c/I990Tyxii7oBxBBhb
/mHvuGyhTHl3eh1+DdU8PvGkXMdWZtUw6KjdkiycDasqHb2NecDKaC8dRavkv5aE
dWSuDRE5YTlghSmZxGXJ
=u0PV
-----END PGP SIGNATURE-----

--=-822qjQ0Mji0hp8Zmru0g--

