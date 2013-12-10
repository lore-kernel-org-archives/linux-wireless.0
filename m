Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.online.nl ([194.134.41.32]:39410 "EHLO smtp02.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3LJRf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 12:35:26 -0500
Message-ID: <52A750B1.8000303@meshcoding.com> (sfid-20131210_183532_816440_3D4D45AD)
Date: Tue, 10 Dec 2013 18:34:41 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>,
	Antonio Quartulli <antonio@open-mesh.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/2] mac80211: iterate over vif using RCU
References: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>	<CAB3XZEfwLk5PUp34hQ_8Uog6T8BHRP6akW4SThjXjgAQRAhC-Q@mail.gmail.com>	<52A74A7F.5000309@open-mesh.com> <CAB3XZEe9ZGvn+1P6-eb-vq2yfkx97QheZ002bYYbN0wtYNqK_g@mail.gmail.com>
In-Reply-To: <CAB3XZEe9ZGvn+1P6-eb-vq2yfkx97QheZ002bYYbN0wtYNqK_g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4mbo6Ja8TAuVPqorKHjd7cRfC7oWcv4oF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4mbo6Ja8TAuVPqorKHjd7cRfC7oWcv4oF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/12/13 18:23, Eliad Peller wrote:
> On Tue, Dec 10, 2013 at 7:08 PM, Antonio Quartulli
> <antonio@open-mesh.com> wrote:
>>>> Moreover, why do we use list_for_each_entry_safe() is ieee80211_iter=
_keys() if
>>>> the list cannot be altered (pointer to key is not passed to iter() s=
o we should
>>>> be sure that nobody is going to invoke list_del())?
>>>
>>> see the documentation of ieee80211_remove_key():
>>
>> This function does not exist anymore
>>
> it does seem to exist here :)
> https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git=
/tree/include/net/mac80211.h
>=20

ops you are right. I got confused because I was discussing about that
function some days ago: it is not used by any driver, so it could be
removed.

Therefore it should not really be a problem here.

--=20
Antonio Quartulli


--4mbo6Ja8TAuVPqorKHjd7cRfC7oWcv4oF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSp1C1AAoJEEKTMo6mOh1VoAsP/0CCu4vdXihfrk83vl6zfOpV
uk55BMuDg/12R+xQ5/3DQq1eyg0vZileZxOUvi7fioVQyUd+YVnCrhswaIR3AFc+
IdsSV8ySzutU0n15hfFhFASE5+eabSl5IeMKHJMZzuZkditHCYZJ3Y+gt5cfVjYy
c23SiC3oLWcSfI0sMHi59RqIHWyDJYQPPK/XwTKdvUeut4SYyBjxxIGVDqV4/MbP
wHM4D0RMggK9rQBjMAvQYPiQw+mQLx4SFBik8xTRqE5h4Y4f4hsyI9+jeNepEirn
bZExDlXSMCpUY1d8xgjFjzCP0o+T9s8KECgpLIibH5Xd78Q/zIYL76WgrbtaKGsM
yUOkz2rIoOOQ6bPwHTk/hgaE7rrPjI4mPTZYd9QEdUsxPSt6NkRZbEqRcXFDx8id
zTQRUBNTKIJ2havaIbt1rMOsGCNi72taWKjNZAQf52v33PEgrbOkcbvilo2SGJJO
q1HGUcIDb4vjR1kWOKblEfBdEUjd3evO+Cb8fxrNdaNOLMNcmHuGNv3iW61YYPUr
WO6D20xrDYvWBqWVxb54oKmfrJSIOb2MiPkcY6ta4UUIcE6RpGBpFxS+XkqJVgp+
+7TZQPEZ4r+AbC1XexK1G7cqi9w3+f90yx+TBnQU7oBbXqrJXtdCDJe50ElISV8x
S/00xkMTfBpI6kEVx4rw
=ijVD
-----END PGP SIGNATURE-----

--4mbo6Ja8TAuVPqorKHjd7cRfC7oWcv4oF--
