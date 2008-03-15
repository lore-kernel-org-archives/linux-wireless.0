Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYCPAQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 20:16:58 -0400
Subject: Re: [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CAcR6z96gBIaHHiRsOaC"
Date: Sat, 15 Mar 2008 15:38:26 +0100
Message-Id: <1205591906.15910.44.camel@johannes.berg> (sfid-20080316_001711_875836_4E6A0682)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CAcR6z96gBIaHHiRsOaC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-12 at 17:05 -0700, Reinette Chatre wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch makes the mac80211 able to send a ready phase2 key to the low
> level driver for TKIP encryption. Iwlwifi needs to get a phase2 key to
> encrypt TX packets in HW.

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -287,6 +287,7 @@ struct ieee80211_tx_control {
>  	u8 iv_len;		/* length of the IV field in octets */
>  	u8 queue;		/* hardware queue to use for this frame;
>  				 * 0 =3D highest, hw->queues-1 =3D lowest */
> +	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */

I have to admit that I'm rather uncomfortable with adding this code to
the stack. Not only because that is a rather large field that most other
drivers will not use, but also because it doesn't cover the use case the
Broadcom driver needs (only phase 1 key generated). Also, I don't think
we should take the "push" model to the extreme, that will just
complicate things in the future.

As for the transmit path here, we can trivially export
ieee80211_tkip_gen_rc4key() and, because key_conf is embedded in struct
ieee80211_key, give it a key_conf parameter that the driver knows about
from set_key(). That way, the driver can call that function for each
packet instead of having the stack do that, it only has to keep track of
the keys which it will most likely anyway.

Also, looking at what you do here, I found this comment:
        /* FIXME: need to differenciate between static and dynamic key
         * in the level of mac80211 */
        static_key =3D !iwl4965_is_associated(priv);

I think that is pretty bogus because there isn't really a distinction
between dynamic and static keys, what's the reason for differentiating
in the driver? Also, the driver will do rather odd things when
 * associate
 * set a key
 * disassociate
 * delete the key

johannes

--=-CAcR6z96gBIaHHiRsOaC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9vfYaVg1VMiehFYAQLJKQ//ZOLay5Ry58kWRmGGLcbCGHdnLdDvCqeZ
U4ANj4+wGOKF1o88f82fnpFq/cLop2FCPfxLerEzVN/xDlFp+Yo0udUsz418Ec2H
qI9s+ZGkSCbqMUzpQ0NgMPXQxjWHZ1C1S8YzdgkDQ+1GYp87kdietUp9hTdM7ZPR
SLnbba9LWkI2ECalW5U+CRAApn8ZdGb2aDspoGGoFkLCjM8Te4lyf9FqUTXQTQIV
SGAYsspGDYAxjPCJk806cELZ/xNTuqZlcMdASg6rxzt0Z+Fu09kegcSU5QJGxpWq
kyCnBmePhqtEH/+SZqxZv8ODSIUam5l1cQg5XLlV1xI+sjkbpYEfqTkbbZOz4IOt
4+dqkgUee/9i593rsS0haDUvrvlT+gz4kuzeX6J4Toa0qi4MUHihWme+DL/9bqXQ
E3eLWniQccz2JXvqZ5gmYvxb2cz32y9wZSOFdc45nsKJ1FPTaGbyUY9+tl7oLkzY
tjGAu6uPmIBxFEYaXuRWpYPe4blIStbsVdgTG6N2LCnm74d8aVO08GL9DI7hY6yG
gbRW276unj/CeDRaMvwvJHSSiyl4WgaB1Quj1cUVMZx7osb8e2wuRPeDmVZjtseC
9r8EmsIQEfYwqLARMIWl5nG0VcE3/qC6zW004b3SEABDS9FsAC49/pbzx+KKKddK
N51Lf4gOkCU=
=/Djx
-----END PGP SIGNATURE-----

--=-CAcR6z96gBIaHHiRsOaC--

