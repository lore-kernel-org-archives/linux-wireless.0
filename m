Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYJPPug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 11:50:36 -0400
Subject: Re: [PATCH] hostap: Fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48F761C1.9000109@lwfinger.net> (sfid-20081016_174625_529721_9312B9FF)
References: <48F761C1.9000109@lwfinger.net>
	 (sfid-20081016_174625_529721_9312B9FF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g82RcSVTXFwDnJ776p4S"
Date: Thu, 16 Oct 2008 17:50:12 +0200
Message-Id: <1224172212.735.79.camel@johannes.berg> (sfid-20081016_175039_618696_6F77806C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g82RcSVTXFwDnJ776p4S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-16 at 08:46 -0700, Larry Finger wrote:

> -	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, &local->pending_info);
> +	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, (ulong *)&local->pending_info);

Shouldn't you just do this instead?


--- hostapd_wlan.h
+++ hostapd_wlan.h
@@ ... @@
-	long pending_info;
+	unsigned long pending_info;

?

johannes

--=-g82RcSVTXFwDnJ776p4S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI92KvAAoJEKVg1VMiehFYZB0QAL6nyFZGTGy17HISkFowDZpL
CBBGPGdDoUuyRiN8gcCkCD31At4rx0DMqgKeKnJuk6FQLFoeVCDbvF4VRbEbD89z
S6+nrRPwg627qfE1p7Eq+OUaXEN2GnFfTXv587R39MSiN3dQk+L6wc2LoEoP2NBt
KCByczy2tw/CEHQR127sYJbpucS/vITR81lNC4kcfoH18olQDQbzl2CKWYwPxVdm
WzuLnrWXGhMMfJV27AaIXP7g1ycFSVgb/u792ZaItHgi27y8bHGhao6rSkYORNZj
RLxuMsOWPbgZEq985xd+irx+79DSK1Q/ww83vtGwYbcsWlFlaHTCMHnwI7TCLTTu
v2TlaXgTfb89U+2kYziZopdEoHCxahjJvVfGulD4Qt+rlNeVYKpu3Nm5NW8pGBuN
CXLCJQi/87NLE71C5LDPeBg4frNYsDNNpy62atPkyGfLRmwsco/o83Zw25L+cCYu
zcQ8pbjBLyoJZuZeS2ejMqYebZlS69J8Wna1zSjfrHkuhNVPFVmD4A3lkCnFWIGK
zSTjr9/dK3/Qp5Fjz0sQHfZhtMRa+3koSVmjiaiVeZ00BFmBFzy74Qx3gy9WEshX
70+M0myK5NiU/Engv0a8Mq9Sq1vyXLsS0DDY2wFxjNaCMjlMfBS6HQW3C0HUdSoe
YGLMgvm+gRyoMSTtr+/v
=hqgJ
-----END PGP SIGNATURE-----

--=-g82RcSVTXFwDnJ776p4S--

