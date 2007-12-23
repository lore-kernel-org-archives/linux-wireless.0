Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLWNsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 08:48:38 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20071223123517.17ds9zttxc4goo00@imap.suse.de>
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7) <1198401880.4116.6.camel@johannes.berg>
	 <20071223123517.17ds9zttxc4goo00@imap.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jT1g7ynL12AtFsWev5oM"
Date: Sun, 23 Dec 2007 14:48:26 +0100
Message-Id: <1198417706.4000.1.camel@johannes.berg> (sfid-20071223_134844_803148_2A2083E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jT1g7ynL12AtFsWev5oM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> This patch fixes a problem with rx handling on multiple interfaces. =20
> >>  Especially
> >> when using hardware-scanning and a wireless driver (i.e. iwlwifi) whic=
h is
> >> able to receive data while scanning.
> >
> > Can you explain how you even got multiple interfaces with iwlwifi? The
> > patch looks (superficially) correct, but I'm a bit confused.
>=20
> I was only referring to wmaster0 and wlan0 as two interfaces. While a sca=
n
> is in progress the master interface (wmaster0) processes all frames relat=
ed
> to scanning and it happened to me that data-frames got dropped on wmaster=
0
> (which is obviously correct) and due to the frame control being modified
> wlan0 was not able to process the frame correctly anymore.

Ah, that must be because of the stuff Zhu Yi did wrt. hw scanning. Could
you take a look too please? The patch looks pretty much ok to me and I
think it'd be required with say VLAN interfaces as well.

johannes

--=-jT1g7ynL12AtFsWev5oM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR25nKaVg1VMiehFYAQJV5BAAvmOX9fIyDHBfG+Fvlxew3ccmmjEEBd8z
bAwgH6/wSZWg2siV96kNewgOUrtvHuaeGTt8CUhMfqqgm5ljQWIIF7hvZuzQp9+n
GljGq9j+FDwJoZi/ZC6whK+DVdAG65Tg3TceOQShugr3Xeg+7v2KvPLtCHv8Ciiu
/C9FWZMhaCL89z4syS8hNy6QSiJTyoVI8sCpOgz6YAbhwmkQNttViiNSGbLVr57A
fJxTdi/ZfI1IUaGNPx89zOoKoJ1Nn9y/QTB54bQ3JMDoTpS2yERh+6Q1d4N8nlGr
kzderdNTiwVs10zqWRMfnwiN0cHBgYf2hGLXILgcDGsEAkstT2GBlS5mOnqMMcqy
VUC9WzqId7cMxs+9MEjdMFXHLoIXbb+j8XxeHXJHbenS2oH7CuzZN3SeaCn5zUrt
B2Mjfgn4vNE8ztWo+ReMBcIznzYKREsrKmZjiLty8V8+O73ZnwKQnrQ3eqrgIV4G
3gRSetjiWkUIUXyb8xEKPquwkyMpTrezjhzyyPZZvQOapjQatUfX8fKdTF9wMPfR
guVPqjrXa4odJrS/ke/wBomcpfKmRW2wqv1nvPuf47BDNb0DkXr7Gn8RI7CgRSAt
za+2d4FDO29ZDJEl8lUDF75vBrghALpfTw0Xt5ysx78YAK4kK1j4lEfVplJ9OOrM
/eo/mWrIq/4=
=NvBH
-----END PGP SIGNATURE-----

--=-jT1g7ynL12AtFsWev5oM--

