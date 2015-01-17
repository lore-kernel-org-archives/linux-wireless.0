Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s4.neomailbox.net ([5.148.176.50]:1415 "EHLO s4.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbbARG3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 01:29:21 -0500
Message-ID: <54BAC569.3040202@meshcoding.com> (sfid-20150118_072925_182285_5434DEA4)
Date: Sat, 17 Jan 2015 21:26:17 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Beat Meier <mbe_ml@swiss-wireless.com.ar>,
	Pat Erley <pat-lkml@erley.org>,
	"linux-wireless@vger.kernel.org >> Linux Wireless List"
	<linux-wireless@vger.kernel.org>
Subject: Re: Cannot use ap and sta mode on same interface with ath9k and kernel
 3.8.13 :-(
References: <54B990BC.1060604@swiss-wireless.com.ar> <54B99BEA.9080103@erley.org> <54B9A225.1080307@swiss-wireless.com.ar>
In-Reply-To: <54B9A225.1080307@swiss-wireless.com.ar>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9vtXH4UcwIfGFnLc3OX8a0tW5Mvwh84Jh"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9vtXH4UcwIfGFnLc3OX8a0tW5Mvwh84Jh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 17/01/15 00:43, Beat Meier wrote:
> On 01/16/2015 08:16 PM, Pat Erley wrote:
>> On 01/16/2015 04:29 PM, Beat Meier wrote:
>>> Hi
>>>
>>> I'm using an WLM200NX card in master mode ath1 and want to do scannin=
g
>>> on the same interface.
>>> I'm using ath9k on 3.8.13 kernel (voyage-linux)
>>>
>>> So I setup an additional  interface in sta mode with
>>>    iw phy phy1 interface add ath2 type managed
>>> This works but the interface is not coming up.
>>> I tried several things like
>>> auto ath2
>>> iface ath2 inet static
>>>          address 10.58.1.1
>>>          netmask 255.255.255.0
>>>          wireless-mode Managed
>>>          wpa-conf /etc/wpa_supplicant.conf.WPA-PSK
>>>
>>> But wpa_spplicant comes with error:
>>>    wpa_supplicant: /sbin/wpa_supplicant daemon failed to start
>>>    run-parts: /etc/network/if-pre-up.d/wpasupplicant exited with retu=
rn
>>> code 1
>>>    RTNETLINK answers: Name not unique on network
>>>    Failed to bring up ath2.
>>>
>>> I can setup monitor mode but I want to scan to see what other equipme=
nt
>>> is on which channel ...
>>>
>>> What's the problem? With ath9k I cannot use ap and sta mode together?=
??
>>>
>>
>> You need to assign a different mac address to the new interface.
>>
>> [Resend, accidentally dropped mailing list]
>>
>=20
> This solved the problem.
> Would be nice to add a comment in
>   http://wireless.kernel.org/en/users/Documentation/iw/vif#station

By the way, you can scan also with a master interface. You just need to
pass the ap-force flag to the scan command.

Cheers,


--=20
Antonio Quartulli


--9vtXH4UcwIfGFnLc3OX8a0tW5Mvwh84Jh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUusVyAAoJEJgn97Bh2u9e63QQAMI1aJQ0XX36R61KnH+8kGPq
2Nq8zUr10T6cb5uTajJfX5ir8SJWGAPaMfQMsYUvnm0FcAzwY3qMYRLbwj+HjnVP
ctpoxjwn2PWlK+C4Z9JES2dCSo4TeMkmSbfEJMDCEslEf6pn6J3t5vj+TiaqF7YR
HfqqtktbFbBUUSpUxV6QFH8PG/Drbe0K4sMBW9uL8fxE6QVCR8hBoG5ooTVY+mMg
r0wtKj7TeAQYWjMVmAUE76Z8At3RPtLF0eH2XZ1SLK1h27pU+KC1d0r6/feSh8Tf
4YOwPX0hoETEZDaZnbJ2Cq8KW3IJxLt+EnILfnUgw74PYmgVnU/FkOZbjyqOCPOd
4SsxoKoJPhTvgy76vR9dCl7/0J+b+/tl04hxqzqy3owR9WFAM9+bcp4KkQKc4dEJ
CHfwLm/1nQnCriyb6xmrnAI/GbJh3LnTC7eyZXcwKP2PNEvg297N117eqDYH/cs5
ZwEesbxFbYHsFCBwHK05GSroBCva8CZu/C2kZ+ZdSGjxvxCdgQwUyLbo6iShF0ZU
cemNLPM+UYNyC25vSsVvyyD8qLcm8kOmuYbBQVapDwtnCuC6m0jU0IKnBcjWX0vm
27cKzS3qCWfbfNFeXfcEE9xEltFB6JL5KOx1n39Cfa5wYYhcaDAADVwaaO4VxfH2
FQVLpVji819vrRM67JhQ
=Dbbq
-----END PGP SIGNATURE-----

--9vtXH4UcwIfGFnLc3OX8a0tW5Mvwh84Jh--
