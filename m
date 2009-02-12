Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbZBLKRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 05:17:20 -0500
Subject: Re: soft-safe -> soft-unsafe lock order detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4991AC67.90104@openwrt.org> (sfid-20090210_173417_726855_7504F887)
References: <4991AC67.90104@openwrt.org>
	 (sfid-20090210_173417_726855_7504F887)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ae1+ViFhUaOj7gS/aHzJ"
Date: Thu, 12 Feb 2009 11:16:47 +0100
Message-Id: <1234433807.16004.88.camel@johannes.local> (sfid-20090212_111736_123131_223B74EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ae1+ViFhUaOj7gS/aHzJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> to a soft-irq-unsafe lock:
>  (todo_lock){--..}
> ... which became soft-irq-unsafe at:
> ...  [<800b2248>] __lock_acquire+0x624/0x844
>   [<800b24c4>] lock_acquire+0x5c/0x84
>   [<8006b8c4>] _spin_lock+0x34/0x48
>   [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]

That seems to be incorrect. ieee80211_set_default_key will have
_irqsave-locked the key lock, so the todo lock is here always locked in
an irq-excluded section.

The lock is, however, possibly used that way in ieee80211_key_link,
which can be fixed easily and we can remove the todo lock too.

johannes

--=-Ae1+ViFhUaOj7gS/aHzJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk/cMAAoJEKVg1VMiehFYMQQQAJzMUlxlxMN7rtg4Roe+TzH0
hmGFpB1PE+dUfdrXPjOxjHCAgCLoIpHs29ZD0H7AMMWbAJ9+TOTbu7hM2eKkE4Vr
jYu7jqwbeuGm88qmD1SJ/q6tLcaZYyHpLZC12uJ84uxxe+TEjEmDggC/BmW4kB8y
yaEMMq5Zg2pWvL//eoq1ZETipKoY702/ppetZaVJjueO0DQySRfMdufeIxcF9GWt
5cwuUOQwkRnFC3xnKBgsn6shbDpIGagyXebqIAW+nrGbsPHxif4z9O7WmhBzZd/k
JJQy8rQ/frfsSvCDgklEyRUISLsMn/KPQvj2Rb9KtTb3WxO0r3QN3lsOabAcagFQ
Qb5YugwdIr/EEVZ59H1oZNdsosVC/3EpYM7t4woTnG7v2vKl/vye3QYUGVIEwncu
vi/ZgAkPHyNURtFtU+6HGWsSAwBhuyE5hVmQpitaxknAcbkKodmfK1P86usMtCvA
gbMcG5u8Ek8Uji1A4XIH1rCOAjxEEZliH3GJ8Jx8idIh9ZHp9vcARI6fBtk2lpaE
m27O3+HQ6xEgYrHQQvtsOlDVhZ6fq1aPlIdKduI2cFa4bH2rqrOLWjO4N5xvFPlt
BBut4t66NnjC/q7fM5OG/iQ7AGBbUy1MfQtfSxQ+OhauefiTGxoYUiZhF9ogYLsT
SY6i8E8AMIv8ZeLYLPB9
=SA8Y
-----END PGP SIGNATURE-----

--=-Ae1+ViFhUaOj7gS/aHzJ--

