Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab0BDIOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 03:14:50 -0500
Subject: Re: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org, kvalo@iki.fi
In-Reply-To: <1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	 <1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D9bb6MbuC/RIdcz+8vCV"
Date: Thu, 04 Feb 2010 09:14:46 +0100
Message-ID: <1265271286.29119.96.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D9bb6MbuC/RIdcz+8vCV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 12:24 +0530, Vivek Natarajan wrote:
> If there is a continuous Rx UDP traffic with power save enabled,
> there is some loss of packets with ath9k as Atheros chipsets
> need to be awake to do Rx, unlike other vendor chipsets.

That sentence doesn't make a whole lot of sense, all chips need to be
awake to RX ;)

IOW, I think the flag is probably useless?

> +	if ((local->hw.flags & IEEE80211_HW_NEEDS_RX_PS_RESET) &&
> +	    ieee80211_is_data(hdr->frame_control) &&
> +	    !is_multicast_ether_addr(hdr->addr1)) {
> +		if (local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {

Why nest two if statements instead of just using a single one?

johannes


--=-D9bb6MbuC/RIdcz+8vCV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLaoHyAAoJEODzc/N7+QmaTxsP/Rbc0MxYkTDu/axouS7lx3uv
plkeTpzrA/M1cu5XsK8Mjjsd7FSTs4eVI507L2kdsn2QusSVfZw6//JHXJ6lfOmh
wrydB5DftTWheXvX15DgcjNfTPTTiP2qjV3/I/cEl5zPirF7ujzSWx1sr1ClQ612
k0uqRZt369DRAbyJxWEn7qPZRhQIwQv4lOwUXbPjDK0OHyXYgdlD69f0S+/J4JTo
jPI9btMDpNSFFLskYS8qNmjgYM/zasybFkZPTjYCZ0+i5V8QLNA/ucFjm8rfK938
cYjFI3mpZo+gcJhlo12UM10O333UOvBM6nEUQGB/5I+Ug15Y+zyJWO307+g6X6fU
66ADL8Y3RiuoSYT8VNZCmh6PQSDPYZL6k9GID/h6iRaNO8NGXjJSBndTOa7aLgbM
mgHSLRkNW0QSi/CWF6yvQyTQsJrlygdX7IqLltXYDRAoIsgEATV4U0TO33+V84AG
PMAIv+qSOrywJvzB38x+BaH4dgGFgz+20+H0zy+PyLWRVsj95rhvfhbwt91+KDUw
UQOjSay08Mz8Nsy9WhPiXgzZQhNO+Do7W4oAmcyyxJ56WI3WMR90YTeEBVWQv1Dd
QpgXIoRapTOUzgpeDLpHJcOGtOMy4EOnIvY3sshFbB7eJKfF54Be4xSIAuUuX6P4
NbrUy2l3uNNJME6banpV
=e+19
-----END PGP SIGNATURE-----

--=-D9bb6MbuC/RIdcz+8vCV--

