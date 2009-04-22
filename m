Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDVJp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:45:58 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1240391541.10072.2.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
	 <1240391541.10072.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hVScFVmWwKw4ZUfOiTKi"
Date: Wed, 22 Apr 2009 11:45:23 +0200
Message-Id: <1240393523.21978.1.camel@johannes.local> (sfid-20090422_114601_452403_94063116)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hVScFVmWwKw4ZUfOiTKi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > > CTRL-EVENT-SCAN-RESULTS=20
> > > Trying to authenticate with 00:23:ab:xx:xx:xx (SSID=3D'Guest' freq=3D=
2412 MHz)
> > > Trying to associate with 00:23:ab:xx:xx:xx (SSID=3D'Guest' freq=3D241=
2 MHz)
> > > Associated with 00:23:ab:xx:xx:xx
> > > CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (aut=
h) [id=3D2 id_str=3D]
> > > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> > > l2_packet_receive - recvfrom: Network is down
> > > Failed to initiate AP scan.
> > > Failed to initiate AP scan.
> > > ^CCTRL-EVENT-TERMINATING - signal 2 received
> > >=20
> > > So starting wpa_supplicant does its job fine, then running dhclient I
> > > end up in the disconnect and network down and after that scanning fai=
ls.
> >=20
> > ???
> >=20
> > And the below kernel message is all yo uget?
>=20
> Yes, I am as puzzled as you are and can't make any sense out of it. It
> seems that something is going horribly wrong here somewhere. I just
> don't have any clue where.

I just don't see anything in the kernel that would ever set the
interface down, as indicated there.

> > > WARNING: at net/wireless/nl80211.c:205 nl80211_send_wiphy+0x4b/0x988

> > >  [<ffffffffa0055e04>] nl80211_send_wiphy+0x4b/0x988 [cfg80211]
> >=20
> > What tree are you using? This warning totally confuses me -- there's no
> > code to produce it! It was a spurious warning Luis added some time ago,
> > we removed right away again and now it's haunting us.
>=20
> This is the iwlwifi tree based on wireless-testing. It should be
> re-based, but maybe an old patch is still stuck in it. Remember that I
> am using the nl80211 driver of wpa_supplicant.

Indeed:

$ git diff iwlwifi-2.6/master..wireless-testing/master net/wireless
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ebda7c5..97bb5c8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -202,8 +202,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 =
pid, u32 seq, int flags,
        int i;
        u16 ifmodes =3D dev->wiphy.interface_modes;
=20
-       assert_cfg80211_lock();
-
        hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY)=
;
        if (!hdr)
                return -1;


johannes

--=-hVScFVmWwKw4ZUfOiTKi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7ucwAAoJEKVg1VMiehFY3G8QAIo0bY4s2sjhux78Iojcd14K
RiQb3QmISlpTI0e00p46Af1op2epl9Mx6FUdNCdaknUXQBlUL9aOIrObOIb93Ab3
4ndkB9UNwI5bEfBOBBcY9ZRRySE2FLeeixyzVmD5jKfO19oFiv+7+xAgFEGeYMBC
7/HlpiHcu82zazs/kusXqzBgLmSgl9jfEnsXiz7dUL7eql3cNuSYv2BBJlzpXi5U
fnAbWunKhHzoycKjQ/zMG0UAhT/vxm49x7ZPXfkDiPLQf5f8MJm9n/KDVlq3+u3B
d6e6T+AsU+uqj0oUnxY/9S3YGzFpG1d45y6VC2303p1PD4KUzOdx5kWcj/gPzClM
6xgIGQf1nTJT7Avfcztc5KZHEUMDoRyzXzet7AHTvWHDacqvApE/WDpXFUG7xJV1
S3L1djs9XhyDt6eG1+B+RaoG0N3fiZgdzsKrJUzfMGiawQUzyNWWB3GfBGTZMwA8
0tbVfZwOKusmeweeUq+deQD2feq+c8fvbIEqoOjmCl3AbbwrzT3RwtSH01tXUPeL
Zw00yEbwUQS+v3DgZpJXtMAbtKkVYKDCYxujZJtxYZMwXMoT8ilTT4zEyJ2FxTi8
O+adoRvFdW18Pmvv3RbbxrIuAYMsJF93DQK7EOCw4zN9RD0Up91jSERPKVHxiNlO
JE7/Tp2N1TCT4VgcV30B
=CWIp
-----END PGP SIGNATURE-----

--=-hVScFVmWwKw4ZUfOiTKi--

