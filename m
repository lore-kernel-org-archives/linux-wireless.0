Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYKQR2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 12:28:43 -0500
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com> (sfid-20081117_161447_403583_F9BC9E33)
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 (sfid-20081117_161447_403583_F9BC9E33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R0D3Z09jsXFplC0/Amct"
Date: Mon, 17 Nov 2008 18:28:07 +0100
Message-Id: <1226942887.3902.30.camel@johannes.berg> (sfid-20081117_182846_914831_D0AE3397)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R0D3Z09jsXFplC0/Amct
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 17:14 +0200, Tomas Winkler wrote:

> > The point is that the whole thing about disassociation is already the
> > wrong assumption. As I've outlined, it only works in STA mode, and thus
> > the function is generally not very useful.
> >
> >> I agree that resume/suspend shell be handled properly in the mac80211
> >> regardless of this issue.
> >
> > And it will handle the "firmware crashed" case perfectly too.
>=20
> You may have a case, anyhow, please show us some RFC before you remove
> of mac notify.

I don't have any, but given the current deficiencies, I don't think the
notify callback is worth keeping especially in light of the locking
nightmare it's creating. What does it fix anyway? No user ever
complained about slow re-association at resume time that I've heard, and
no driver but iwlwifi tries to speed it up.

johannes

--=-R0D3Z09jsXFplC0/Amct
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIamjAAoJEKVg1VMiehFYMKgP/1DkUCDd56qFTawtJEdYSITe
QJSGXF3lrKpcLDbOr8XDtoMli/aGAdFrRB7fWtlhNmH2vQjNY9z6KCurzCABDaJO
SlLisZfNfzz44Aukrp4sYnf436jZ5faJyhTTla7z8T2OotZZ7ROLg3eizvXmmCe1
V6XqT/MFynUFC1xxpDVSzspeYpkZoGXEMwpYX341iHn4/+gxW0s56uwFaCBQAN+8
SNQ9fKX4wMMYdYklUgzY4KkxU6RlDmvTKKkCVQGo5Ud/MN3HaBpjnHDPcE4/RbEf
iX0YkcUEbgTGz6tr0Wd0yOoBUdQNyHCnkpEE6Y/jsfuT7jkdDVqaKCObr5ro9qRF
PF1wh/2tnCug5KEuJCeMARYjnJ5IxFDCXI2G8WyCJpG3ADVvB+jmjXOxXt/7s4uI
/wzj0rmOJHc+F9lb3CoAD0Uf6Gv9aTDctHLq9XTFKNz/ThD1mGYkT4nyl9Klx5oH
3dwPezsoBi+1HxWk+tUbKfcXmQ5BV82gDNv3+rIpMy0Yzud2r40HBw81FDH4IXbL
0/p7i0RFp54sBoJTc9VUYimN9SDa+HFZR+RGEd3uaGLvpx5Z2cm3tCpQ2GG7xXYy
FSow4ZrG31KtZXUBYF3jUK3/N9OKSclGZcD4kUn4hH1xnZ9Li7IxAMLrPQDB/J0t
VhBNDOGhoM55piFjJb1m
=9V3L
-----END PGP SIGNATURE-----

--=-R0D3Z09jsXFplC0/Amct--

