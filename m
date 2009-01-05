Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZAEVBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 16:01:25 -0500
Subject: Re: Problem with rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <496273D4.6020600@lwfinger.net>
References: <496273D4.6020600@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hQieMoX56AxxnI2Fm3q3"
Date: Mon, 05 Jan 2009 22:01:42 +0100
Message-Id: <1231189302.3697.25.camel@johannes> (sfid-20090105_220129_435539_2095F862)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hQieMoX56AxxnI2Fm3q3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> I'm chasing a problem with suspend/resume on rtl8187; however, in my test=
ing, I
> found that a simple "modprobe -r/modprobe" sequence fails, even though
> unplugging/replugging the stick with or without a "modprobe -r" works jus=
t fine.

Strange, since modprobe -r/rmmod should unregister the driver just as
though it was unplugged, afaik.

> I'm running into the WARN-ON at net/mac80211/tx.c:1184. The start of the
> traceback is as follows:
>=20
>  [<ffffffff8023afce>] warn_on_slowpath+0x58/0x7d
>  [<ffffffff803c8c3c>] ? pskb_expand_head+0xe6/0x156
>  [<ffffffffa029dbff>] ? __ieee80211_tx+0x40/0x12a [mac80211]
>  [<ffffffffa029e98b>] ieee80211_master_start_xmit+0x41c/0x50d [mac80211]
>  [<ffffffffa029e8c5>] ? ieee80211_master_start_xmit+0x356/0x50d [mac80211=
]
>  [<ffffffff803cf0a4>] dev_hard_start_xmit+0x214/0x28f
>  [<ffffffff803dfb9b>] __qdisc_run+0xf3/0x1fe
>  [<ffffffff803cf584>] dev_queue_xmit+0x357/0x48f
>=20
> The last rtl8187 routine that was started was rtl8187_add_interface. From=
 a
> debugging message, I see that info->flags =3D 0x6B6B6B6B - the SLUB debug=
ging
> poison value.=20

The WARN_ON then triggers because IEEE80211_TX_CTL_AMPDU is 0x40 which
is set in 0x6b. The question is ... why are we trying to send a freed
skb??

>  If I interpret the traceback correctly, a workqueue has been
> restarted without being properly initialized.

Does the backtrace continue beyond what you pasted?

> Is there any routine that needs to be called when shutting down that has =
been
> missed?

Just unregister_hw/free_hw ought to be fine, very strange.

johannes

--=-hQieMoX56AxxnI2Fm3q3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYnUsAAoJEKVg1VMiehFYSo4QAJ6u7YcjgO1EgROPgTLlLu6Y
kN+mFYf0hLQdU1X+lvozdHX01AtXXvYZ8JyMTVFX0Ik4LzQskk9AD6Oclg2li3MK
uFvsxStqc1t0En1ZTxrpRj9OivOC5FNPfB5XhfFeCZm71nqdp9yyMx6A8TSlNnOt
GuG8Npx6ei208EZjgGzqZvFNWqFiOgTUcf6I1oCpKrzGS3xeKRD/GzJj1Gn09YDW
p2Jh8yLauwAHqmKboWOlWzUoqly1E1KfnMRxn4QSRuY9XZjKSrqYQwYUzdYV7ppa
dB4bpnWC6tZI1npUuiY/VZHLAG+xQQjtuRVV7WUJAjAltHsjVI7XH9yyUBtIBO/l
Rw61EtK2NdVh0sjMlwDi5G7fQ7UqMZQzXpHYb3sYDI6SBNyI7TRrPjqPuAn0D4Wj
Rm2GSyQ72YtoGgdFW1v4QQQp/odUZY4qK2A6WW8QMdTblHNtIF0aGFAIg8OQzhrF
HH6ocj0phxrqmtn+XQh/7y217BSX/PyGA94ACQCZruAG3YiDLDxKCmVSAKvKVZ7d
s9+fu7BpcIfG7zqWDn0yjDVheemgOY9/LbK7efKbYrQwxSZoV4nSCXUJU7UWRkKh
s9i82uIrvknOOU1yySLvSl87Bi1UzU2p/6gOuma73Kzt3n6TGEoNuK/b2gyjbwSK
qXEdgj8nEHzZhWjeeklP
=tdiQ
-----END PGP SIGNATURE-----

--=-hQieMoX56AxxnI2Fm3q3--

