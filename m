Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:40122 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3LJROx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 12:14:53 -0500
Message-ID: <52A74A7F.5000309@open-mesh.com> (sfid-20131210_181500_320786_9332E5D9)
Date: Tue, 10 Dec 2013 18:08:15 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/2] mac80211: iterate over vif using RCU
References: <1386693598-3934-1-git-send-email-antonio@meshcoding.com> <CAB3XZEfwLk5PUp34hQ_8Uog6T8BHRP6akW4SThjXjgAQRAhC-Q@mail.gmail.com>
In-Reply-To: <CAB3XZEfwLk5PUp34hQ_8Uog6T8BHRP6akW4SThjXjgAQRAhC-Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uUiqckdBNn9ExKSEUVu9tkBCdflMeN90x"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uUiqckdBNn9ExKSEUVu9tkBCdflMeN90x
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/12/13 18:05, Eliad Peller wrote:
> hi,
>=20
> On Tue, Dec 10, 2013 at 6:39 PM, Antonio Quartulli
> <antonio@meshcoding.com> wrote:
>> I need to invoke ieee80211_iter_keys() from a periodic worker in a dri=
ver and
>> therefore I would prefer to get rid of any of locks to avoid problems.=

>> These two patches try to use rcu lock to protect the iteration, but I'=
d like to
>> get a feedback before sending this stuff as a patch :-)
>>
> at least iwlwifi might sleep inside the iterator, so you can't just
> convert it to rcu (atomic).
>=20

mh, this "might sleep" could be an issue, ok.

>> Moreover, why do we use list_for_each_entry_safe() is ieee80211_iter_k=
eys() if
>> the list cannot be altered (pointer to key is not passed to iter() so =
we should
>> be sure that nobody is going to invoke list_del())?
>=20
> see the documentation of ieee80211_remove_key():

This function does not exist anymore


--=20
Antonio Quartulli


--uUiqckdBNn9ExKSEUVu9tkBCdflMeN90x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSp0qDAAoJEEKTMo6mOh1VxggQAII+xhK92X1VFCJoNyhTQB14
98Y1685gbRxhi66/9gOQe/o4joirH7ew5rTjV1U6pULIoqznyBmbJ4zhrl7+4Slv
6yDamXX+I+SQWcLx/V6E0dMjS1qlTQrdZzQjjsU4VudhyEaqUUBQY9qjRSHbxybT
xlEey0HbgPFPRuIA8r2pVmkLEU0nx1uRHFwUzjRIGwFNSe8LU2y4TqgHDSWA/o0Y
+kRe/uDWoXiuonaFwlAhadSO5AU+6zoLIfMQv6lyEHf6n0EPQgM2fqxmLdMYJJfT
U+cO1voDqRUe0Rv39pRa9nj/0ybbOHzBOHzPEe2Wa/pAhBm5IC+rOIrIyNaiwQPz
9MrbMtAhZVQoUqp68Nr/c75hmK1rFu+Jn6Z8ut259f0LHUxzMR+QEsSdNvNl1mfr
zvWrMv0BQ21wNOMSxYtfp5DOtQE03jt7gSuVL3e4C0Y7US5utIDHaFlI4gToFtC+
AfUTQ/xXDvx+u5XNMDC68UR91pDFalhdYVa9cFel7b71SnZG7AtAWJCS1EYlySt8
BAIUYthtoluTtaZUJ0X5qyDeJPNmiB6CzFFuBYMtY5uxOweZDDTugjzSqaS4SgSn
3ALMQTgW9eOEoDjTzudX/fUCXlGPamTs5/V8CD0T+XXmA9Or/OKQF2tYGntMufIk
D8t7T2e3b927l9ScP0cb
=uus2
-----END PGP SIGNATURE-----

--uUiqckdBNn9ExKSEUVu9tkBCdflMeN90x--
