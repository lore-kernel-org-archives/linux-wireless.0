Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZEDHrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:47:25 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241422800.2899.5.camel@localhost.localdomain>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
	 <1241422487.6866.8.camel@johannes.local>
	 <1241422800.2899.5.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1DDC37DGUCCNe/s89A3u"
Date: Mon, 04 May 2009 09:47:21 +0200
Message-Id: <1241423241.8683.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1DDC37DGUCCNe/s89A3u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > > +static unsigned char vendor_oui[3] =3D { 0x00, 0x50, 0xf2 };
> > > +static unsigned char cipher_oui[3] =3D { 0x00, 0x0f, 0xac };
> >=20
> > ??
> > 00-50-f2 is "WiFi OUI" (registered to Microsoft), 00-0f-ac is "802.11
> > OUI", registered to 802.11.
>=20
> I can rename them if that helps.

Yes, please do, but also synchronise the things you print out. _All_
cipher specs are effectively vendor-specified, but some use vendor
"WiFi" and some use vendor "802.11" so are standardised in some form. I
don't think printing "Vendor specified: ..." for the WiFi OUI or "Other"
for "real" vendor-specified ones helps.

> > Why are you passing in the OUI?
>=20
> The WPA1 and WPA2 IE are uses a different OUI for basically exactly the
> same thing.

Yeah, I noticed later.

> > > +	if (len < 4) {
> > > +		tab_on_first(&first);
> > > +		printf("\t * Group cipher: TKIP\n");
> > > +		printf("\t * Pairwise ciphers: TKIP\n");
> > > +		return;
> > > +	}
> >=20
> > Huh? I don't quite understand this? Is that some backward compat code?
> > Or is this some WPA1 thing I don't know about?
>=20
> The specification says that the only mandatory field is the version and
> after that everything else is optional and falls back to default
> TKIP/TKIP. At least that is what I read of it.

Ok, makes sense I guess.

> > > +static void print_rsn(unsigned char type, unsigned char len, unsigne=
d char *data)
> > > +{
> > > +	print_wpa("WPA2", cipher_oui, len, data);
> > > +}
> >=20
> > That's "oui_80211" I guess, not "cipher_oui". Ok I see now why you want
> > to pass in the OUI... However, it would be better to just duplicate the
> > code, I think for example 11w won't be announced in WPA1 IEs so we
> > shouldn't parse it there when we add support for parsing it to RSN IEs.
>=20
> Since iw is just printing the actual IE, I don't think we should be
> bothering here with code duplication. We can just print what the element
> actually contains. If for some weird fucked up AP, has 11w inside WPA1,
> then I actually wanna have iw print that :)

No, this is the wrong approach. See, there are two defined cipher suites
for, say, CCMP:
00:50:f2-4 and 00:0f:ac-4

However, it is not necessarily true that 00:50:f2-N is _always_ the same
as 00:0f:ac-N. 11w adds 00:0f:ac-6 (AES-128-CMAC, you could add that to
your patch), but 00:50:f2-6 stays undefined since the WiFi spec defines
that one, not the 802.11 spec. The WiFi spec could very well define
00:50:f2-6 as "quantum cryptography mode reserved for future" if it
wishes.

johannes

--=-1DDC37DGUCCNe/s89A3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/p2HAAoJEKVg1VMiehFYtWIP/jLGOH2hfK85h+cqRh1lnVZJ
AFYnMqfNIj2Y6pY1i0NYRUT8Sh/EdtZwflZvHxtRhY8NuGBapmEN94u7Za/g1M7O
/X5JMsQqSdNtdHdmpiQ2pfjUMCOQXVX+EznLKHlK/4UlHH1xZapC1TxOxn2iQCmF
e+uy50E8orLpGsbBcnzjcjlh4Q9eR6rJHWWp8RgUoFPCYCCQi30FAMw48ZR/M5x6
UV9LvqotcNiSBNpW9NFQMMMeKnB2+X7R1ornLxytHsk3BLnsPpcHYk3ZyM3FSzit
qjFCZ/5HbR4Y/+XG31CeDo3iKoSZjT4846ec2EjV9zTRCqDex+6c1kCD2PBT59t8
63r/8GuyT/hYdblhIymKaxV2FSwY0sq37+aGJmqyn7eHfSd3t1MKel2bAktZqzxC
CwbEqjM8y6Ah/CfqNDs7pisazn9MX9I2nH0swz+yu5kX8beIgT1DGYRkXIfpW0cg
QGdGr9n6idD3WVBpT+ZPAaMv79vaIxiXf6q/Yv4Vd5/c6DPvxpTFmTGZBfknhrxe
RoQJgQ4axnGBynkYseDyX0LLd6oPTOAymDE0CwC1wV3cj63iY7+hRJ9d4hKdI0f8
aNfIvSy90BVHT1VfsXJj3HE0dFfPQmA5b1Z8I2wTam4iLb+9JYJtlZFLWrZvXX2b
DoafP3qzT08ziQ2/kitC
=lchr
-----END PGP SIGNATURE-----

--=-1DDC37DGUCCNe/s89A3u--

