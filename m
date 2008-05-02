Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764515AbYEBVDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 17:03:09 -0400
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805022259.20118.IvDoorn@gmail.com> (sfid-20080502_225342_248676_C435DBF1)
References: <200805022141.28351.IvDoorn@gmail.com>
	 <200805022238.21066.IvDoorn@gmail.com>
	 <1209760939.3608.20.camel@johannes.berg>
	 <200805022259.20118.IvDoorn@gmail.com>
	 (sfid-20080502_225342_248676_C435DBF1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Byp0BoPGxakB2Rz79F/u"
Date: Fri, 02 May 2008 23:02:58 +0200
Message-Id: <1209762178.3608.21.camel@johannes.berg> (sfid-20080502_230247_133278_149BD639)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Byp0BoPGxakB2Rz79F/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-02 at 22:59 +0200, Ivo van Doorn wrote:
> On Friday 02 May 2008, Johannes Berg wrote:
> >=20
> > > Now there you mention something. Looking at the Legacy driver, they o=
nly mention
> > > ICV during the TX, but never during RX. I did find that the MMIC is a=
ppended at the
> > > end of the frame, which is good, but they never do anything that look=
s like the
> > > stripping of the ICV data...
> > > So I assume it is stripped in the hardware, but no descriptor definit=
ion indicates
> > > a ICV field like there is for IV and EIV. Unless.... they do have a 3=
2bits "reserved" field
> > > located directly after the IV/EIV fields.. makes one curious if that =
accidently contains ICV data. ;)
> >=20
> > Heh. Maybe the hardware actually does replay protection so it doesn't
> > matter?
>=20
> The comments in the legacy driver indicates the IV/EIV data was provided =
for replay attack checking,
> and I do see a lot of ReplayCounters being memcpy'ed and memcmp() in the =
driver.
> What is missing is the intialization of those counters to anything other =
then 0, and
> the actual usage of the IV/EIV data in the Rx descriptor. ;)

Heh. Actually, yes, if the device does ICV checking then replay
detection can be easily done in software w/o the ICV, but mac80211
doesn't support that. You could probably just implement it in the driver
though.

johannes

--=-Byp0BoPGxakB2Rz79F/u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBuBgaVg1VMiehFYAQLUZxAAgMSh/3BPImQLBQ00uyESPY8cwrsjnUNH
OBDKFEya3rqur6l9guqBo6+xFeuPY14eGqD3rEefEaS0mntrfQJxpmUZq/bT6Rv9
8Z3tFnAbYg2HeRVPyRq/fWWU2pR1uLYfftViESgAhRfPV0FAzyUJ6tRa5KZfJvV/
f6A3CR+fcetpzx8CAWaz1BrgALdJ3zCYtNzpWntkgb4WqDXilc1FRJHsH0macsvz
WUsuhW2yyX/84jnywW9ii+6hWNPF2k68Y1wtMpQCcNSN6s3/s4ST14UmSF7al3f4
jgzSeNDD93CnJnSWYnq4Syq0WaYkAzteNVUw785d0GAWzoxeBSw05UeosO7wyVRh
FrRVWMU71TfUkzktkeUyyg3somVYWU3zqWuaZawnV1P1JBwh7obuqkZHa10qEOR7
/2zrT5qC4TnGkl+mpVrMsOBlwXC/Cex5Eo0qAPWRcf0zamOAcy+jBxPFJN7Yovdh
T6juZWbGYfZS2TurAaq6rF9OnKiv+gESdetUoh6jsDahXwQe4DWi3NOiuIJt4/dH
rQAd9tKWGMjqRK7EiGEmzcXLBC97VKqwdBR+eERcKCBuc5yFWkt7/vI/reoz7iN0
l6RxKj/v2pH0Eet4J/7qOMjJxBrRYIwtxkm/CHHTemP2OTLtGrAvH6FdFs9FBZIX
dMwvE2rcHY0=
=WdaJ
-----END PGP SIGNATURE-----

--=-Byp0BoPGxakB2Rz79F/u--

