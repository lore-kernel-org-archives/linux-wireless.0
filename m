Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbZGOL6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 07:58:12 -0400
Subject: Re: [PATCH 4/5] mac80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1247617320-20163-5-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
	 <1247617320-20163-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dOuhhhVIfjL6MdJzHR0h"
Date: Wed, 15 Jul 2009 13:57:35 +0200
Message-Id: <1247659055.2477.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dOuhhhVIfjL6MdJzHR0h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 20:21 -0400, Luis R. Rodriguez wrote:
> If we're associated and have not already gone into PS mode
> we ensure send a nullfunc frame before going to suspend. Upon
> resume we ensure we restore PS mode if it was enabled and inform
> the driver accordingly, also notify the AP we're awake.
>=20
> WoW requires the radio to be left on during suspend, to do this
> we inform drivers of the requested wow triggers on the mac80211
> stop callback.

I don't think this patch would work if ath9k unprogrammed the hardware
correctly in ->remove_interface(), since you don't seem to skip that
call.

johannes

--=-dOuhhhVIfjL6MdJzHR0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXcQsAAoJEODzc/N7+QmaXIQQAIebiGPVmNFCOzei22a3Dwwf
RlsQssVqu83HexaefkaBmi9gTnN/ioztJLHduplsNhp1y6QHwTt9yJ+3MO93p5Ee
MDC14ErpnaiDJdaNbp9zhcPobpJRg299EQDJzfFo/NjIli4j8lxs0IvzZbxA7HBA
19oCag+kZ/22rc5njt7qYk46SFnEIKhvUXERaGh7x/ze2AdsRL9pbQK3kbw9Mi6M
JmsBfYLuQRwkkomP2/HIN2utudD4xaI/zhzweHA9BFibFBjtggNKgGZvBJVub35b
EAmeMyAp2nF6Uy6TtTxC+VnQ5BQozOj3TI0k2fEx/cgpNMx5MrhpnUdEBNTPZ2/s
nl1L+k11cepTA/2Mp0Ei04rF86rLLIwQA926WxxMbAYZZZjs+HezG1Ug+pecvOrm
UrSLmYPkOBAsim2FNUOQzLyUcmbmENEQ2BYhS7fkwfUIV+ePUVK7C2gEQmlIXnsE
ZQHSYnly7m3ggstYGOM/pj3hdh28KobzPBoEej0tYonoUAnESLtHPWFgKybFEZxd
mxqKi/24XEcQzZQSTAANpVkFvMJMQID6uOEOKhBtlWA1cnYc4HdbK/1jBPBv4S1f
xGhVIIUn64XIJIHjs8Vtd84Jern0cwSZxNTV5MqzmXNPfJdJh39f071MnaMeFBqL
znZDaXIRnYkR+mknbDoq
=CiG4
-----END PGP SIGNATURE-----

--=-dOuhhhVIfjL6MdJzHR0h--

