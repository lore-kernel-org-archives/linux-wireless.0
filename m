Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54468 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaBSQDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:03:12 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so572397pab.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 08:03:11 -0800 (PST)
Date: Wed, 19 Feb 2014 08:03:06 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor
 channels
Message-ID: <20140219160301.GH14296@garbanzo.do-not-panic.com> (sfid-20140219_170330_810158_B39AEA19)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com>
 <20140219001458.GF14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 03:28:29PM +0000, Peer, Ilan wrote:
> I'll abandon this change ...=20

Wait lets talk about this.

> > -----Original Message-----
> > From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> > Rodriguez
> > Sent: Wednesday, February 19, 2014 02:15
> > To: Peer, Ilan
> > Cc: linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> > Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on in=
door
> > channels
> >=20
> > On Mon, Jan 27, 2014 at 12:21:58PM +0200, Ilan Peer wrote:
> > > Allow active scanning and frame injection on channels marked with
> > > IEEE80211_CHAN_NO_IR iff the channel is also marked with
> > > IEEE80211_CHAN_INDOOR_ONLY and the wireless core thinks that it
> > > operates in an indoor environment.
> > >
> > > Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> >=20
> > I don't see why being indoor should allow to override the NO-IR flag. I=
 do see
> > however why being indoor should enable to IR if you are IR if you have =
the
> > indoor flag. Enabling to IR if you are indoor for all NO-IR channels is=
=2E.. pretty
> > permissive I do not see the correlation.
> >=20
>=20
> Make sense. I did not have such relaxations defined, just thought that
> similar relaxations could also be used in cases of scanning etc. but I
> guess this is not always true.=20

The original beacon hint mechanism is very expansive
to all beacons on non 5 GHz DFS channels and non 2.4 channel
12 or 13. If a vendor can possibly not like that beacon hint
implementation as its too permissive (and I don't think it is)
but they do want to trust beacon hints from APs in the case you
are describing then you can enable a new feature flag to
distinguish this. The beacon infrastructure code would then
ignore the regular beacon hints on devices that don't have the
old flag, but would trust this new form of beacon hint. If
a device supported the old all inclusive flag they'd trust
both. You'd have to update the kdocs for the old one, and
likely add a new routine similar to
regulatory_hint_found_beacon().

I'm not sure its worth it though, I'd rather push vendors to
consider first using the regular becaon hint mechanism and
trusting it. Maybe devices that want this new functionality
you are trusting should implicate revising trusting beacon
hint mechanism ?

  Luis

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTBNW1AAoJEKwtdpJg+MHGThYP/A0adj+DcGy3UovWorosLy7W
ipy0DwnzNPmNLvt2/2cIZSQ+aUbk9DynNJ3H/5EUCyE8X/eTcm9VG6D0uuF4xwW6
DI1iia8tMBqjkqWCY9U0nJXO4qearG5RimJQMQ1CDkA0TVkvV1jJ9rZPRBPhY1FS
9UOf1wY2xzvk2M6injFkIUFKOFUJFxNfrjXOi6bWL9qriF5P+ppi+2vtUAqkKVAU
anYo3Adidh/gO1NSq4PrHyNuyjf6bnEt+XjSHn7wzdmbVKU6ud5MqrGpdG1BnTZU
bi2iCTpiSn77Gvs6KF0atY2Z91mYrtpvB6ioEJVIlGdWAqdDl2HUbD2n+2BJOZfH
kybat8WHp09shJ4lJALemjY4iSt4c6rDrP+s1rvasP7TD1NMNPA00wa497wRhbSv
EPpSuTghM3bQHW1HdfX1e3rz7O6pY/OdOYa4p0iAihgf0kAtnHtJLXF+Y/z1e9dR
EdMmJtW4kGCa/tW61FVB1+/AaPfzmPxHD1FMbVyGupaa2yzs4GvP8Ys/sXVkNlTk
s6Ib7GfAZXBnXwj5Rl/3Viy6PpzHwF6rGtbYRGCXF9GT25Tocbl1ADcwOW/W6imY
eIpjOwShm9AvyJaSgZNZUWgp7rfxQRLMa9pbWyqSL1SEYDqCZSElVabTspEZoXpg
uFwj2XQ77RE8rfIfPrN1
=ss23
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
