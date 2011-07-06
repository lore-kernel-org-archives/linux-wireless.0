Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:55820 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1GFS3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 14:29:38 -0400
Date: Wed, 6 Jul 2011 14:29:38 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110706182937.GE28091@alittletooquiet.net> (sfid-20110706_202942_522106_B97C0E0F)
References: <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
 <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
 <20110705124914.GC26882@alittletooquiet.net>
 <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
 <20110705143029.GA28091@alittletooquiet.net>
 <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
 <20110705172022.GB28091@alittletooquiet.net>
 <20110706023943.GA11178@vmraj-lnx.users.atheros.com>
 <CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
In-Reply-To: <CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi shafi,

On Wed, Jul 06, 2011 at 03:58:13AM -0400, Mohammed Shafi wrote:
> > To avoid multi reg writes please apply the following change
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/wmi.h
> > b/drivers/net/wireless/ath/ath9k/wmi.h
> > index fde6da6..0878add 100644
> > --- a/drivers/net/wireless/ath/ath9k/wmi.h
> > +++ b/drivers/net/wireless/ath/ath9k/wmi.h
> > @@ -124,7 +124,7 @@ enum wmi_event_id {
> > =A0 =A0 =A0 =A0WMI_TXSTATUS_EVENTID,
> > =A0 =A0 =A0 =A0 };
> >
> > =A0 =A0 =A0 =A0 =A0-#define MAX_CMD_NUMBER 62
> > =A0 =A0 =A0 =A0 =A0+#define MAX_CMD_NUMBER 1
> >
> > =A0 =A0 =A0 =A0 =A0 =A0struct register_write {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__be32 reg;
> > --
>=20
> did you try in your system the simple hack Raj had suggested?
> it seems to solve ths issue, but we encountered some soft lock ups due
> to the LED stuff is moved to mac80211 with the recent code base,
> we will take a look at this to fix this, probably requires some backporti=
ng.

Yes, the device seems to initialize properly with this patch.  Like you
expected, I am seeing soft lock-ups when I try to bring the interface up.

> in order to recreate the issue, we installed Ubuntu 8.04- the Hardy
> Heron - released in April 2008.
> as expected the issue is perfectly reproducible. thanks to Raj for his
> help and suggestions.

Thanks for taking the time to test.  I really appreciate everyone's help.

> *please obtain the stable compat-wireless-2.6.36-4
> http://linuxwireless.org/en/users/Download/stable/#compat-wireless_2.6.36=
_stable_releases
> *download the old firmware
> http://git.kernel.org/?p=3Dlinux/kernel/git/dwmw2/linux-firmware.git;a=3D=
blob_plain;f=3Dar9271.fw;hb=3DHEAD
> (history http://git.kernel.org/?p=3Dlinux/kernel/git/dwmw2/linux-firmware=
=2Egit;a=3Dhistory;f=3Dar9271.fw;h=3Dd0ee74a1c8dccb7cc21f5be90f1d4048fa9dbf=
9e;hb=3DHEAD)
> with this your USB card will be up and running, we did some basic testing.
> *I used  usbmodeswitch-0.9.4

Ultimately we'd like to try the experimental AP mode.  I understand this was
introduced in kernel version 2.6.40, so I don't think compat-wireless-2.6.3=
6-4
will work for us.

Can you point me to the LED-related commits that you mentioned above?  We'll
either need to backport the changes required to fix the soft lock-ups or up=
grade
our kernel to include these commits.

> we also recommend you upgrade to latest kernel available for your distrib=
ution,
> because we may still face some other issues as ath9k_htc very much new
> compared to ath9k

A kernel upgrade is something I would like to avoid if possible, but of cou=
rse
it is something we'll consider if we need to.

> please also read
> http://wireless.kernel.org/en/users/Download/compat-wireless-old

I think this kernel is supported by the regular compat-wireless package, ri=
ght?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4UqZEACgkQRO4fQQdv5Ay9jQCbB3lJUTTYM0Vm1o+JNqwG0kyI
BAMAnjiX7VDThAbNYOyasOBTarI5ZqtE
=V/bH
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
