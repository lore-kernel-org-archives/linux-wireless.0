Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42824 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3A1QLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:11:08 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <ordex@autistici.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Ray Gibson <rgibson@futurec.net>
Subject: [RFC 0/3] WPA_NONE support in mac80211/ath9k
Date: Mon, 28 Jan 2013 17:11:02 +0100
Message-ID: <30210911.93HAZKKtRJ@bentobox> (sfid-20130128_171115_045416_E4E556B0)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5642877.2SbJoUPlnN"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart5642877.2SbJoUPlnN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I've tried to use WPA_NONE together with ath9k (other people reported
problems, but said it would be batman-adv related [1]). I ran into three
smaller problems and worked around them. I am not sure what kind of support
mac80211 should have for WPA_NONE, but maybe also someone else is trying
it and could use this as a reference. Nevertheless, IBSS/RSN should be
preferred.

I've used a wpa_supplicant with fixed-ibss support [2,3] on an vif configured
as adhoc device.

ap_scan=2
fast_reauth=1
	network={
	ssid="ESSID"
	mode=1
	proto=WPA
	frequency=2422
	key_mgmt=WPA-NONE
	pairwise=NONE
	group=CCMP
	psk="abcd1234"
	bssid=02:00:de:ad:be:fe
}

First problem was related in the way the decryption is done. No unicast frames
could be decrypted because the group key (the only one set for WPA_NONE)
wasn't allowed to be used for unicast decryption.

The second problem was the replay detection. Replay detection doesn't work
with WPA_NONE and therefore has to be disabled.

The third problem was the inability to set the key when no link was
established. This lead to unencrypted broadcast packets sent over the air...
not really nice. Therefore, I've just disabled the check [4] for now.

I was informed by Antonio Quartulli about the controversy to use
 !sta->sdata->u.ibss.control_port to check for for non-IBSS/RSN mode. Just
think about it is a placeholder for the imaginary function
"ieee80211_ibss_is_wpanone(...)".

Is the inability to use WPA_NONE with ath9k/mac80211 intended or just a
regression nobody noticed? In the latter case, any things which should
be changed to make the patches upstream ready?

Kind regards,
	Sven

[1] https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2013-January/008895.html
[2] http://hostap.epitest.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=913e3cf794cccf19d551d936a16c7d91acb5e834
[3] http://hostap.epitest.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=9e2af29f9bf065099b9a2abceaf40ac0e1bf86fa
[4] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=fffd0934b9390f34bec45762192b7edd3b12b4b5
--nextPart5642877.2SbJoUPlnN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJRBqMWAAoJEF2HCgfBJntGkO4P/AreWqtIBtCb3qJoTas44Mf6
8OzJ8WY4W3U0eK5FHXTlcqKtkg87OyAb+LRzi9iaiFsMKVO747yYH1gocf32aDVH
uwiUorbuoS/rQMwjvPt2NY93MlpSZ6wGcy8HkLMi4830ZGP+5Y/pwnwOChEebfG7
ZgfFblZxmtTUqriob8xxf7Ad/VXyGK6IHP79Lg+YKd6FtjXPDls4y7o3LE1BK2zY
NB/+XuHH8rKDCSDnvqk52MZ+Cl/AK1mXQeZd0G42x5rTm0hPvmm2RcppzVYwu5Ys
gFbkTvCcLaqeASt8kYTIz4TgaCMA5qQYVvuOobPGQPdemE2qN4KGkglqmOChfRZB
3Psh+gMjvfWPdxu7BbpKFGYXGohMJVQfLwGTDISSSkYoTj+wChJmlhO2m5ZnJ9Ob
Xx0qms4bNISqqCKCrSlO1kWAjv3CUwyL/w2EesRv/SSE0bGSubtSm23u7VVq7k+W
xEXS/psBMlLTqfRUzYl8rNnAH+6gR19z5KoYm37CuDFhwSKHdadlKMeJvL0ZnVT8
xb7Es4Cfu7omW2rH/3/qCKNmHvEux76NHPYD/Stbm4+TcWYZEIPe226jIM25hqCi
9omlAtj2YQd0feHw0RxRTFkb4UaH27JtTCiFBR7jwP0eBidLjxCv6NCdgoXd3Ic2
LU0T6OzzyptS4Akuc2Ox
=wyZ4
-----END PGP SIGNATURE-----

--nextPart5642877.2SbJoUPlnN--

