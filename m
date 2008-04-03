Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYDCKsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:48:08 -0400
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Chr <chunkeey@web.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240804030341v7d1c20ecva35cc169095deb3d@mail.gmail.com> (sfid-20080403_114138_233095_B6BCE670)
References: <200804012145.18294.chunkeey@web.de>
	 <1207128858.10910.19.camel@johannes.berg>
	 <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
	 <1207218083.3636.12.camel@johannes.berg>
	 <1ba2fa240804030341v7d1c20ecva35cc169095deb3d@mail.gmail.com>
	 (sfid-20080403_114138_233095_B6BCE670)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7wOokc44MF7FVsn1VvZU"
Date: Thu, 03 Apr 2008 12:48:01 +0200
Message-Id: <1207219681.3636.38.camel@johannes.berg> (sfid-20080403_114812_828817_C6B11BDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7wOokc44MF7FVsn1VvZU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I see, AP mode is different story and in second thought it think we
> can use this to speed up TX path
> also for iwliwfi, we waste significant time on searching for STA based
> on MAC address.
> So it's ACK from me. Thanks for opening my eyes :)
>=20
> Another question is if there will be more info needed for station in the =
driver.
> Currently in iwlwifi we have STA representation, this is HW
> requirement but some data are kept twice in iwlwifi and mac.
> The question is whether STA mac80211 representation cannot be more
> accessible to the driver?  Not sure how this can be done
> without over complicated station book keeping.

Yeah, that's a bit tough, I'm not sure how to do it.

Maybe we could have a struct ieee80211_sta_info (defined in mac80211.h)
embedded into struct sta_info and pass that along everywhere sort of
like we do with struct key/key_conf?

johannes

--=-7wOokc44MF7FVsn1VvZU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/S14KVg1VMiehFYAQIyYA/9FxKNmgcQepZHNOcR/de4lgNlW4zYdZPD
hPKi6OUQOrqV3SvEqapcf1yFksqS1koGDjG9NK2vuapGlrOuJC/xW8IGsBglGyG5
C5YIcUM4rUDzN2nmevb8iJY/4clR+nqQ507yg4LW28uLF6rrclDr6WTIcYaN7bf8
gC3Vx7/3GAbVpg3kCQZ5yq51zqN4AK0c7IUJaFJUrj8MwAaproLjY0+/qbjFkR6d
HF4WQxr7SOMxxSbz33lxZ8s8H1LI/vNP9ey1QY3NA9clJq13St2x98YPSEmV64TF
EDE5nE/x2hL0hE3z/MFi3aoUXeUoI1pSD9HbXdE1i/rYRwR6cPxCUhURXfW+ltNB
vXdmBZn0L47rB6zslsxymkl+8KJanP/rD9VQMK5yPv8MBSSTlkgqIO2izBYRAwcM
WMW3ukgA5gwA11qwyT+Gu8D5K8qw6IE6m4orni9WaeENDEgfTGmaurmKWOQYDpZa
Sem2X3jhcpOInnTQKwz4Y8UkahhrTYaVW2t/B17EsuOtIZTC+PA85z+zgp5XmX1N
8+R9STaz6DEqUSo40WfLlb1dWz2w43zyzyB+7qMmCrBSeVVcqtmjVzTptF+5+g4x
Limk1eDqJGrRfb9y6id+ZgF8nLY1v62DqCPTBuNLR0WeKfYzt8tRWMzR/jBYtJc5
KjoOb75VXWE=
=IG5e
-----END PGP SIGNATURE-----

--=-7wOokc44MF7FVsn1VvZU--

