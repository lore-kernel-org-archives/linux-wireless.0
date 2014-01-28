Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:44928 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaA1NiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 08:38:15 -0500
Message-ID: <52E7B278.9070408@open-mesh.com> (sfid-20140128_143820_016530_4C2911D5)
Date: Tue, 28 Jan 2014 14:36:56 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Subject: Re: [PATCH RESEND mac80211] cfg80211: fix channel configuration in
 IBSS join
References: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>	 <87wqhkgszo.fsf@kamboji.qca.qualcomm.com> <52E7B134.2040404@open-mesh.com> <1390916215.4148.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390916215.4148.5.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OPCKJoxuEpitpOa9ALl6ui2agiA01n5MK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OPCKJoxuEpitpOa9ALl6ui2agiA01n5MK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 28/01/14 14:36, Johannes Berg wrote:
> On Tue, 2014-01-28 at 14:31 +0100, Antonio Quartulli wrote:
>> On 28/01/14 14:01, Kalle Valo wrote:
>>>> - Patch is getting resent because I did not CC'd the linux-wireless =
mailing list in
>>>> my previous attempt. :)
>>>
>>> Oh, I missed that. Anyway, in previous version I  commented about
>>> documenting NULL usage. What do you think about that?
>>
>> Well documentation is always good :) If it is need I will add it.
>>
>> However, I'd rather ask you what ath6kl is trying to do in that case,
>> since it's the only driver invoking cfg80211_ibss_joined() with a zero=

>> BSSID (and now a NULL channel) on IBSS leave.
>>
>> From the cfg80211 prospective, that call is seen like a notification o=
f
>> being connected to a new BSS having zero mac and NULL channel. I don't=

>> see how this can be useful at all, also because after leaving the IBSS=
 I
>> imagine that no other operation will take place on that vif unless it
>> reconnects again.
>=20
> That seems completely pointless and should probably be removed?

I totally agree. But we should do it with another patch targeting
mac80211-next.

Cheers,


--=20
Antonio Quartulli


--OPCKJoxuEpitpOa9ALl6ui2agiA01n5MK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS57J8AAoJEEKTMo6mOh1Vs+sP/Rei1tCXj/zOdoLGbYsAT7su
2i691jnahu0GyPL0gulzVGA0fXqgv0lDKVlKz7SW70NY8ji/U5X4PwnenPS3Lnbi
JldecLaysO2+r9ZIV8m+sjFPk0HZzeWe27UsrRWcuGkRqB5GJKDuyiYtNGlEpTkX
yQ9tYvZmeKi9NzY/t1g2w4cbCV2+L/59bLSXMXTdM/qNZPjmOVMFl4JFkrkKgX5P
81cVWc2aEthmtuotu5rUzZwodqvj9iMd5tPodDrf34KgQM/BpvRuOOeRwNgEQ1SC
qTB+VwtkGX9kMqqM6vKvlDCGBISJfANpjEZMdHXvOzVE5VmwAHN/fm+BmGQD0kZX
6nLkJEaVTnxpYUr4KVVsuFIrN3RL9Y+RqsM94HcPkbATQ0Aq1pzmn7HpHa5beQSy
24/UiXiqA+o7uDEoAtnfgr+K5+cczD6dU+h9uDiwGxxYwmybPVBgyk+UR9Mm/4aK
OSuQZgb4a7ZgLecO9x/FIBJghVdYvWRIXMFjUpMWvjdBKpo6Qzuczq37iTaqT+Ga
KinQHU441+Jy5QpiuPcd93CYbF13U/SqLNNebSwIHeYt1S9ywDssK15SOo36s8W4
THbr1n4nunXpMdsi5y+CI13/KGj2Le2yrr8qlYagniALCjFwg+9W0Lbb3cHQ+jyU
rxqeP/xt+Lj2Gn4iq6y3
=joON
-----END PGP SIGNATURE-----

--OPCKJoxuEpitpOa9ALl6ui2agiA01n5MK--
