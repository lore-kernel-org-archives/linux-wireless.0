Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZFBUxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:53:05 -0400
Subject: Re: [PATCH] mac80211: add missing RCU lock/unlock on
 ieee80211_rx_bss_info()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890906021343v41f69346mc844e8a80daf2314@mail.gmail.com>
References: <1243974537-12774-1-git-send-email-lrodriguez@atheros.com>
	 <1243974886.7176.8.camel@johannes.local>
	 <43e72e890906021343v41f69346mc844e8a80daf2314@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TPXfTu+zCljO5TD1lF59"
Date: Tue, 02 Jun 2009 22:53:02 +0200
Message-Id: <1243975982.7176.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TPXfTu+zCljO5TD1lF59
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 13:43 -0700, Luis R. Rodriguez wrote:

> Hm yeah, I failed to see it doesn't get the sta before allocating it
> and/or adding it. Is that right for this particular case? If the sta
> does exist we wouldn't have set up the things for it that
> ieee80211_ibss_add_sta() is setting.

Yeah, but that's a corner case we can only hit via this function racing
against itself, if that's even possible.

johannes

--=-TPXfTu+zCljO5TD1lF59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJZEqAAoJEODzc/N7+QmaLsQP/jqYVSU26OkD5lllXORTo7KD
ggvmg12uUPHu6ChKDLPI6oSOhyIJAKHgKnRhPA+3CHpzQ2/slifm2kCZY/h7dtgL
kDOjQdCpGeBJ4mqmA59E5Q8shD1FF2jh4+HRsXB6c+Ytzr91n6xANV7e0xRR7KvW
2eIZVOyDzZP860o/sTZfZYjDrkgvBrsfhc01tU1584OC48jAvvbj1ivwJjP3AzKt
a6s+7IviCFpwXL1/phoIDiqlWenw+VQglEKuShP461QKnkTUl41xW1h8N9AuNRQh
EZkEWNNKKMdWqFsovfq/pmvr9NMGm2clsaH4AE1RA+eld77tl0G96cM7nnsDClHq
zLc6oll6bjA67GOLEM9N9U2W7g91VEQfVfBRaSjTH9+jLLz6sMflwCDNLXP3VnwT
vF3uH0LvnaGlK8Impnk9sBvao6fB/FXyxBZ2PWh2qYYjKTZ1cH9w31aa9w/Qw3A+
qRPIeUZQL68bxSGpq+DP8gSsJhNQYyIijgJGR12Uo+tZVY4/k5pJ8Wb8EFQk68TK
xTnxxG/eeTTq0WxWaWaPSbr0xqnAjpX6eZkW+Ht/Mt/JqugethRDEMUa4A5YMkxe
oqUQPLxHptHPDB0iYKuIt3K2Mj15RsTUGhBwmjuGmB5qU2BwWr3mONJlPkDTmRJK
i3/R+TgwxJamQHlM413Z
=pLQO
-----END PGP SIGNATURE-----

--=-TPXfTu+zCljO5TD1lF59--

