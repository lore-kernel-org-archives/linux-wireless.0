Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZKJKV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:21:26 -0500
Subject: Re: [RFC] cfg80211: survey report capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1257848249.7037.30.camel@johannes.local>
References: <m3tyx2u2we.wl%holgerschurig@gmail.com>
	 <1257848249.7037.30.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WPOtwZ4641iuVsTgDB4P"
Date: Tue, 10 Nov 2009 11:20:59 +0100
Message-ID: <1257848459.7037.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WPOtwZ4641iuVsTgDB4P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 11:17 +0100, Johannes Berg wrote:

> Right now you're retrieving a single channel but can't even control
> which one. Maybe that's useful functionality in addition to dump when
> you _can_ ask for information on a specific channel, but that'd have to
> pass in the frequency from userspace.
>=20
> Retrieving all data like you've implemented (though I guess you forgot
> the multiple channels case) should be a dump. Maybe that's sufficient
> since there won't be huge amounts of data and userspace can just pick
> out what it needs from the dump.

And maybe the get_survey() driver call can actually pass in the channel
pointer ... then the drivers/mac80211 don't need to implement both
get_survey() and dump_survey() since cfg80211 knows the valid channel
list anyway. But that means iterating over the channel list all the
time, even if the driver can only return values for a single channel.

johannes

--=-WPOtwZ4641iuVsTgDB4P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+T6HAAoJEODzc/N7+QmaEiwP/RfNTwlQL+O+1xIhf4GMdCfV
leorhH92gbxUVQOwCgOUFUhH3lzdckHw9s8fP3/yDlzoS9XQESZfW6lNvmzroJs8
gRR8OST3DDBhxVyixa/Eh8kMGvzO9JfoTSwFI/J9sXkNaldGTsKFDU7fsBHuTxKM
/QvPYb54iuVlUZ8eJQAvVcfmoTf0RAwshTO5fZUz8aA3jVa5UN50H3tpOgtp1lFT
peIAXJr6l6UgYx2ZEICOw7QhFYwFxIM6PzvQs/bjQF0d+iqaW5uY9j9/nqFtk1yH
DJs3seAhVoXwSiOf4SEkvor4AVMrfwbF/9kzHgZ3YApswl0QDYDVQG/KL0DcVUhP
MH39wh4P5uyck2/Zbx2TEkkAo/42efWWjS9tCEUB1H+q1yFsla/R6eltp/G/+Ew1
Yku6kLV6Jdpd0ExOCiWa7U2IjZOXE4JQacSwHs2lCn6Fktf+dd0WV34R8YEF/i3M
xFdwGmx9W+UgGijWLeMf+h8in9kv+TtGbhpkQQof/vVFAIgpyLDSlD3qiS6XYs4C
ppMl19jr9ejHzCvb8hD/wkWG+0Dz/Bed//9b9PmoZRPDiuucyiFAD+0D2CyDO0pH
LQMORKe3CeTfeKs//V1ZIpK8fRdN7Wd5BuBc20y5GQNUc244TaScBQGojRP+Hgi1
MM9UyaM+uLpUDHcjwKXS
=P8qx
-----END PGP SIGNATURE-----

--=-WPOtwZ4641iuVsTgDB4P--

