Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZAVNAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:00:22 -0500
Subject: Re: [PATCH 1/2 v2.6.29] iwlwifi: fix rs_get_rate WARN_ON()
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <1232564283-18008-2-git-send-email-reinette.chatre@intel.com> (sfid-20090121_195542_734853_62E08E0F)
References: <> <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090121_195542_734853_62E08E0F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xApRP9vtReX5XIGJe+Dx"
Date: Thu, 22 Jan 2009 11:57:33 +0100
Message-Id: <1232621853.30174.19.camel@johannes.local> (sfid-20090122_140024_734199_D7E12784)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xApRP9vtReX5XIGJe+Dx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-21 at 10:58 -0800, Reinette Chatre wrote:
> From: Abbas, Mohamed <mohamed.abbas@intel.com>
>=20
> In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
> this is filled with all support rate from assoc_resp.  If we associate
> with G-band AP only supp_rates of G-band will be set the other band
> supp_rates will be set to 0. If the user type this command
> this will cause mac80211 to set to new channel, mac80211
> does not disassociate in setting new channel, so the active
> band is now A-band. then in handling the new essid mac80211 will
> kick in the assoc steps which involve sending disassociation frame.
> in this mac80211 will WARN_ON sta->supp_rates[A_BAND] =3D=3D 0.

Sounds like we should fix mac80211 to disassociate _before_ switching
the channel? It won't help anyway if we're on another channel?

johannes

--=-xApRP9vtReX5XIGJe+Dx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeFEaAAoJEKVg1VMiehFYavwQALD2feOp+eBE7UR37ggJtJQg
LCMQmgqtJrkvIG/R1yHNZTIzCtCXcaKVsXaOJPvVhlOPdJM4DEukLD+WHT0IZWMT
H7SOQMVIOxrzR9Wk1OWjGzq2eA7AH/AoPILNVsQenH7GgFSfKDXDfSbE0CLPGW/S
DbOlMpW9sVmN5BZbVVM1CYDkdVg2ngWTIwLiO+qN8wHCeXcMnAGrVRb6Y9b05gd9
34Bna0+3LVkX7th4XdVMCRlwhLe9pcNNDVUVdJ8z/VX22KYXZr+ofqCy1wip+z02
9SVrp4JtEGnEu4JbnH6biPHiW7iyPDn2nHIce27rGS/VnVZpRhcUOmPzctcgNg9o
Dd0PH82E3hlbkwZVldlrv98As/vzWd8OozwlEwVgEPr9aB9ODMLCtBKpWtBXI2ZZ
Ws3h+6L2kI42ABg1rPaj+iI9HSIZtXxH592NMEVStBUjwUO+3urvjTlsGHhrLmWT
RPK+2BWGeUXWXCxMuhybZwRtl5F7mXOlKeVshgL8dXY6q+YSQXuIdGTIzeybTxCM
zI6lVic9SZopHKQdhascM2P1PSIMmTpr2rhBJUpw131StK/pppFT050uknLYkOoX
iqJptMJHKp7qH+lgFBBt6G9qSszcFJV0PPuob3WexnqN63NgIRTepzzkNJpyeGW8
YgKDO89b2w11NhXPhdqH
=/aSj
-----END PGP SIGNATURE-----

--=-xApRP9vtReX5XIGJe+Dx--

