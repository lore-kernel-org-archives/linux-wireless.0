Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbZBLKGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 05:06:14 -0500
Subject: Re: soft-safe -> soft-unsafe lock order detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4991AC67.90104@openwrt.org> (sfid-20090210_173417_726855_7504F887)
References: <4991AC67.90104@openwrt.org>
	 (sfid-20090210_173417_726855_7504F887)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RtfHxQCwtbS4hvCkG/kP"
Date: Thu, 12 Feb 2009 11:05:41 +0100
Message-Id: <1234433141.16004.85.camel@johannes.local> (sfid-20090212_110619_890286_88E79878)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RtfHxQCwtbS4hvCkG/kP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-10 at 17:33 +0100, Gabor Juhos wrote:

> I'm testing the ath9k driver in STA mode on an Atheros AR913x based board=
.

>  (&local->sta_lock){.+..}
> ... which became soft-irq-safe at:
>   [<800b21cc>] __lock_acquire+0x5a8/0x844
>   [<800b24c4>] lock_acquire+0x5c/0x84
>   [<8006b980>] _spin_lock_irqsave+0x50/0x74
>   [<c020570c>] ieee80211_beacon_get+0x14c/0x3a4 [mac80211]
>   [<c0341e08>] ath9k_beacon_tasklet+0x304/0x5c4 [ath9k]

Something is mismatched here. STA mode !=3D beaconing.

johannes

--=-RtfHxQCwtbS4hvCkG/kP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk/RyAAoJEKVg1VMiehFYfOwP/jROdA9qNf82krnXIrpKBV66
IwdkPUmZ/H7ID7FQ+Jn+Cf+uunYwWuQcpDeOyXhA9cuxMkyZB+iSZ8nGJI5FhBwg
XjAD9ls6h2CzSIZtPF7pOuYTySfCYyLKM9ydjDjSAk4BDI0jcfXhE1x1w4/Y50lm
8tK9EnzNk4SBF7wJnhrHD+mTlBAPbJpXMTsSKXDgVDz3sDfPtMoWVdJHrRFBnVYG
gpfUBnWB5afSIKkdtB3N00xEXp5HT1I48ELF8nurNRI+QyooG0YvXYVJZW+v4uKW
WIwsLCtu1JtIKE5CSUMtzyOvjhwjTmGr6PjE8NFHTLtXZkSAZYCJmNHb1dQ+VFKr
YcUSJBfavUjqSgb3dyLrnbyLqnLmcWT6t3smCjSGPHiDSshiePJsKdkCfNdzQ45W
9njwBxkNBOdtsXvZweeZbMEp5RMGzv1zeWQgScozpx105sMEA8M0Px5ZGm1Y/1MX
kPYChqk0DGwKz0by3dVRWWhT11RQNilIoAkbhkCQ/xxjOvP/vS56HdVlmCpjWmvm
KJWKBHB1S+VYpA2ALNa2cOcrKgm2+YXiQ7P4IsX/2wtSb+hi0IeTWiBvmbskMQqH
OTRCOskGc1m0ByVoLWQv/NH2uJXkiXlafFCg5VYabXGBHR8QwQ9W1vhUJQbUSDs2
I2zcFrIFtYsSHudz8hMB
=Wgs2
-----END PGP SIGNATURE-----

--=-RtfHxQCwtbS4hvCkG/kP--

