Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZEDSew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:34:52 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49FF3453.7020802@gmail.com>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
	 <49FF2FE8.8010004@gmail.com> <1241460944.8683.92.camel@johannes.local>
	 <49FF3453.7020802@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-90htkvM9tIpLQ149Iq5D"
Date: Mon, 04 May 2009 20:34:20 +0200
Message-Id: <1241462060.8683.95.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-90htkvM9tIpLQ149Iq5D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 14:30 -0400, Richard Farina wrote:

> And if the card claims to be associated but ends up stuck on another=20
> channel?

Then your network breaks anyway? And you see messages in the log that it
failed to switch channel? We're talking about mac80211 devices :)

> I can't see a good reason for this at all but if no one agrees=20
> with me then it is well without your power to simply overrule me.
>=20
> I think it is an awful idea, and intel being broken isn't an excuse to=20
> break everything else.  If the card isn't on the right channel because=20
> of some random failure this patch ensures there is no way to=20
> troubleshoot.  If you want to display current channel that is the=20
> hardware channel, if you want to display "Channel the AP I'm associated=20
> to is on" then call it something other than "Current Channel"

It's not just Intel... All fullmac devices, ie. everything not using
mac80211, shows the same behaviour.

And trying to say "current channel" is "hardware channel" runs into the
nice pitfall that, unfortunately, wext is so undefined that you can't
really say either. I think the channel it's trying to use makes a whole
lot more sense because otherwise a user who just randomly does
"iwconfig" will be mightily confused if for example wpa_supplicant had
just requested a scan.

johannes

--=-90htkvM9tIpLQ149Iq5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/zUpAAoJEKVg1VMiehFYnMYQAKb2rxD1Gq2z9gFf5Z3tzCTC
AsCf7O/odJPdPNVeIMXMUo363I8OoDW/OUhTYQTboGMk/cLsKJGBx1XPA8Jqll3B
00sVt563kOoJcefQ/3PumLiYaV9TJkMhxee5Us9nWYjl0dsUGCZO+4/m1aEke5eY
FXD5cCDe0EpvB54Zmw/0QoLQPyMpaw2udsifhCoRZUe49WjHQ5P1e+K+HaKwQZJm
j1GejBXl/9wOnSa5l1W+oHde9QsFafjAuj/WJDuMVlw0fbA9ByuAcD/VNqSJXH98
udKQiSnxUeJhGtCdw7r8NrQyJBcRz5kMF/4O3+hNGRIhN1Byv6lL8pwvvgDnLUFi
7nE3YyITmPs9URs1tV79DeRfZkpZtSDwaoBoCIqdgW3umXJ2sB7z602v92unC97h
xupp75JGQw0c18eMk/nDPVGgBUce4OhLcSn+jANw1QdrxJuFoxnkmzKLtWSLI/b0
W1sEDYwwA2IFkPFz+7I7tOVJv1Xze30EH4Ts0o5S3RlnmYVzCe4xChgfyJ7w17uT
cg84xq3IAUccV/dxlw5j/6dFW8GgHHCxpnEW+mL0ewqTQ0vb2DyEvMDiFoObkuIj
DKMpphfIr0yv4PfInT4M+n+mrEDJTpuqjpLCBapJItU2vkUiKjNAPttfQbAGZpXw
ISKe96yeDDDHcl+Fcm1Q
=AENy
-----END PGP SIGNATURE-----

--=-90htkvM9tIpLQ149Iq5D--

