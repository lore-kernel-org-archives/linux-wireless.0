Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZFGRZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:25:09 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A2BF5D6.3060704@tuffmail.co.uk>
References: <1243858256.5299.14.camel@johannes.local>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <1244389617.23850.102.camel@localhost.localdomain>
	 <4A2BE520.6080207@tuffmail.co.uk>
	 <1244392536.23850.109.camel@localhost.localdomain>
	 <4A2BF5D6.3060704@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HV59T4YMzHYxi9dbjFv5"
Date: Sun, 07 Jun 2009 19:25:04 +0200
Message-Id: <1244395504.12956.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HV59T4YMzHYxi9dbjFv5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 18:16 +0100, Alan Jenkins wrote:

> Hmm, this looks more like a core feature than an rfkill-input bug:
>=20
> "
>  v4: set default global state from userspace for rfkill hotplug
>     (pointed out by Marcel)
>=20
> ...
>=20
> +	if (ev.op =3D=3D RFKILL_OP_CHANGE_ALL) {
> +		if (ev.type =3D=3D RFKILL_TYPE_ALL) {
> +			enum rfkill_type i;
> +			for (i =3D 0; i < NUM_RFKILL_TYPES; i++)
> +				rfkill_global_states[i].cur =3D ev.soft;
> +		} else {
> +			rfkill_global_states[ev.type].cur =3D ev.soft;
> +		}
> +	}
>=20
>=20
> It still looks like this global state will apply even if rfkill-input is
> disabled and userspace has not requested OP_CHANGE_ALL; the default
> state will be enforced on hotplug.  If you want to keep this, I think we
> still need my full scheme.

Your text and code quoting are in disconnect -- you're quoting code from
the /dev/rfkill handler. That confuses me. But anyway, yes, we should
probably simply not enforce the global state _iff_ the device set its
own state before registration.

> Eek!  On a related note, what are we doing on resume?  Johannes added it
> in a response to one of my annoying eeepc-laptop scenarios, but I didn't
> look at the code, only the results.  It seems the individual devices are
> forced into the _global_ states (indexed by device type) on resume.  I
> thought you were trying to neuter these global states so userspace had
> full discretion?  Shouldn't we just restore the individual device state?

Yes, that seems like a bug.

johannes

--=-HV59T4YMzHYxi9dbjFv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK/frAAoJEODzc/N7+QmaGAcQALUtHNvngwM2Xn8HE2wxC/+R
6K8GQKaFv9eHDcmLykbVnsQiAK1okGLfl8/7nAenb63aZun1abcGyuESzGUjoadV
JC3L8y2ld5kndk1q+ZUHgTlsskXKaLNFLdIyRDX6NeNY4yzrmXzCG68PbfaiYyF9
cPbn30qv7gs+tfkHqZdqNETm4u8s6/3jGlVuTP1Q7pbfELhUC8oTQa1FxWh/lXbb
fXbsZS44K31Euce1JYsbUO2/hbMnpUest1WlvuCFI/yPSAwH8dfq6ZN5jXpYzcod
vv5df1zfXDhr6k6TJdsPuvzYaPtoTKxVZUKyER8q8QcBKgH6JTSO8ZilQTJJ89dN
m5ZHcxzYtCNjuzy0ulNB4C+MXngLFHpqmezVDz7c4KBtvM8NFG+PZytKrKSswAQu
gQ29/D4M+nxT5GIphXpiuXXuPvik/EN092pdfUvQlRmFndA5kTY7MdD8nAe0GBIL
6+R+Ud8Q406IRRa0LTm042EKFgN067IXcFHblX6uPwZZZSsf+e2PCjlcAjFuUh4F
GBgKjHpgqDjVNLBUHw9cesvvMI9ohSX6y3PJ6oPEU0pm3PiEx31DOE2tXN268mO+
WFXiCMaTnRfEuPNRQI/U5rzyqv1I4trSq2+vgkMuZRO/pQXaLgIvPWm3DVh0izRS
kfa+aWlQhnfv+dk0EP7c
=axiZ
-----END PGP SIGNATURE-----

--=-HV59T4YMzHYxi9dbjFv5--

