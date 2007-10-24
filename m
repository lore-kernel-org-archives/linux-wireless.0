Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.colorado.edu ([128.138.128.141]:57139 "EHLO
	smtp01.Colorado.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXJXEi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 00:38:59 -0400
Message-ID: <471EC944.2010700@colorado.edu> (sfid-20071024_053905_043502_15F53992)
Date: Tue, 23 Oct 2007 22:25:40 -0600
From: Eric W Anderson <Eric.Anderson@Colorado.EDU>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Proc usage (was: Re: [ath5k-devel] [PATCH 3/3] consistently use ath5k
 in printks)
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>	<1192540838-26985-2-git-send-email-bruno@thinktube.com>	<1192540838-26985-3-git-send-email-bruno@thinktube.com>	<1192540838-26985-4-git-send-email-bruno@thinktube.com>	<1192619652.8841.13.camel@johannes.berg>	<1192630172.10567.29.camel@localhost.localdomain>	<43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com> <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com>
In-Reply-To: <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2529AEBFA576CA5DA0869514"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2529AEBFA576CA5DA0869514
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I realize that primary role of the driver is for actual use, rather than =
for
research, but...  It's very useful in experiments to have /proc entries f=
or all
the settings that you don't normally think of as tunable.  (e.g. turning =
off
antenna diversity, or ACKs, or changing the CCA thresholds). I'd really h=
ate for
knobs to go away because someone things they're not "really" needed, or b=
ecause
they're not worth merging into the new configuration framework.

-Eric

Nick Kossifidis wrote:
> 2007/10/17, Luis R. Rodriguez <mcgrof@gmail.com>:
>> On 10/17/07, Dan Williams <dcbw@redhat.com> wrote:
>>> On Wed, 2007-10-17 at 13:14 +0200, Johannes Berg wrote:
>>>> On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
>>>>
>>>>> the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys=
/dev/ath5k/
>>>> Ok, and why exactly is there a proc interface at all?
>>> Yeah, it needs to die, we're not adding new proc interfaces to the
>>> kernel.  Stuff should be evaluated to see whether it's _really_ neede=
d,
>>> and if for some reason it is, merged into mac80211 or cfg80211, and t=
hen
>>> if that doesn't work,
>> Agreed 200%. Die proc usage!
>>
>>> then maybe something in sysfs.
>> Nah, configfs for generic configuration of kernel objects. I already
>> have such module but it just had regdomain support. I plan on adding
>> add/remove iface.
>>
>>   Luis
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-wirele=
ss" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> I've already removed the whole proc stuff along with debug stuff in
> base.c in madwifi-svn, i'll port patch here asap.
>=20

--=20
Eric W. Anderson                                   University of Colorado=

eric.anderson@colorado.edu                      Dept. of Computer Science=

phone: +1-720-984-8864                   Systems Research Lab - ECCR 1B54=


                         PGP key fingerprints:
       personal: 1BD4 CFCE 8B59 8D6E EA3E  EBD5 4DC9 3E61 656C 462B
       academic: D3C5 D6FF EDED 9F1F C36D  53A3 74B7 53A6 3C74 5F12


--------------enig2529AEBFA576CA5DA0869514
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHHslKdLdTpjx0XxIRAjulAJwJivf3Lx702pI3QmA6II7TLu8ZBQCgrW6x
L0H5VVx6ETEH9jOlMhtk6kc=
=/lf4
-----END PGP SIGNATURE-----

--------------enig2529AEBFA576CA5DA0869514--
