Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZGaP41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 11:56:27 -0400
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	 <1249026324.29587.15.camel@johannes.local>
	 <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7lsuVtrSWDTtFm/FdstO"
Date: Fri, 31 Jul 2009 17:56:22 +0200
Message-Id: <1249055782.20312.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7lsuVtrSWDTtFm/FdstO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 08:49 -0700, Luis R. Rodriguez wrote:

> > just set the _flags_ in their reg
> > notifier,
>=20
> So if you mean devices that used custom reg stuff, the answer is no
> because the patch which introduced the regression would prevent the
> setting of the passive scan flag and beaconing restrictions so the
> reg_notifier would never notice the difference.

I did mean those devices. Adding a reg notifier hook for iwlwifi seems a
little odd, given that cfg80211 is supposed to always honour the flags
(which it copies to orig_flags for that purpose).

But I don't see why ath couldn't do this:

 * do _not_ set the passive/no-ibss flags in flags (orig_flags)
 * in the reg notifier, always set the passive/no-ibss flag into 'flags'
   unless a beacon was noticed on that channel.

What am I missing?

johannes

--=-7lsuVtrSWDTtFm/FdstO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcxQjAAoJEODzc/N7+Qma7v0QAMmQ3mr12PoGtol4BzGN1qOo
z/TBfWn7emUPdHl3ofpe5Bh3Icnu9ritqe42Rev9ICLN3+69ZhFO3v6iCntAEkv3
0LD0fDntdIP6GWbUeiZVmINCIuvQVjOY+vIDD2FfsSkVSkpK25PmrjnQQHKCi5qb
cXhALDIaaGGH6LPM6/++5LaLwNvF4DugMYDj1DlThtnxyClKnatHELtqJ7bcAS5H
/0QSA4hNohoqF/b6VAosqCq6N5dEyNSshyEDFEmBnP7fzsoiLtQwV74eE7HNToGL
4N51EQrxhEusMtilMcNKKBYNe6dbesCSYIM2agCuKipDEKk2duJ3ymmTd44ot+16
CKCTW9n5HBy1C0RmRXmEr4puVQIf2RF1AhAlCZ4w7aXsaX80AZVhuvNHcAWa7rCv
u/t6TgCe4+eTQIo8anWiv4KWwLXBOAm37iP3AhDHJV9cvmSfGpez9OeJeL5F8r2K
nwm71Maq/nV3hevHkyz8nH9mDqiVc4pCfzBYBKAEfFiq7uWF5eCdtXg5VeCJkMFJ
zru7ZogWziFT58gH0ELlw5n9p0XOGuq+esQstVHwQ/qvR8okSLK0atHR5w1+wjK9
bH7u92tR3aXf7OFRHfph3I1ul100LfAPI20P1plhvmlh6wN8J2aGxxPGqqOYo8mM
E9UKniLOswNxFKPThnQQ
=Hks8
-----END PGP SIGNATURE-----

--=-7lsuVtrSWDTtFm/FdstO--

