Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZJWNf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:35:28 -0400
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20091023040623.GA8786@jm.kir.nu>
References: <1256018933.4475.6.camel@johannes.local>
	 <20091023040623.GA8786@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DPwYNhE8vRC1Fax5lW53"
Date: Fri, 23 Oct 2009 15:35:07 +0200
Message-Id: <1256304907.12174.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DPwYNhE8vRC1Fax5lW53
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 21:07 -0700, Jouni Malinen wrote:
> On Tue, Oct 20, 2009 at 03:08:53PM +0900, Johannes Berg wrote:
> > When the in-kernel SME gets an association failure from
> > the AP we don't deauthenticate, and thus get into a very
> > confused state which will lead to warnings later on. Fix
> > this by actually deauthenticating when the AP indicates
> > an association failure.
>=20
> While this may be a reasonable change to resolve an issue now, this may
> not be the best long term solution. There are some association failure
> cases which should really be handled by trying association again instead
> of deauthenticating. The main example would be the association comeback
> time use in IEEE 802.11w. In general, association failure should not
> result in deauthentication in every case.

I'm pretty sure the issue should be fixed with the other two patches
Luis and I cooked up at KS.

johannes

--=-DPwYNhE8vRC1Fax5lW53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4bEIAAoJEODzc/N7+QmaQPAQAL05NlYucD6lHZ6vTz0/U396
njkuNDn4yF5vzMBCU54siNslxVP3Y8+wabShq58eHAT4F33mEivv52bQ4LYj/UYV
V8QevWCXyIWiNK/qB5GJOMq4ShJL9A5x7+rfeyB7OrBhT6COBF57mTOr03PuWehB
U9qmCH4B+f4uGAmuLLJcc4VR2w4ZqXetH83iJ2P4/kMMR/xuGybPTHeSsvUgdWOr
8+BJKigMoOeVgh/KYh+uDhMSZrVcWgLQn03rGp/hM0H6bm/tFRDM963nbnjT4fJn
cRMzDhGtC6uTRfgm+TSFGM1GeMdPmI7YwNR8CEpVm+BqUzZKV7F4stR2wCx+uZYO
Ful64LxdTUx4EgLJqIxB4JzPtocb5SY4lLIke6PnJFI1de68Xqd1GWHe/7eM0UAr
j8xHHfygmYeTbX7MH3Iqx7J8RlYUSckYMyFPqdrrLFgQ346kC4UDlsuZjHfaJHqU
blnl0iPHLQI9WttukG2/G1L3IL6diDsOD15UJmpCN1DyGn4602FhCOrlGsDgqpXB
Pvxc77qK4hsdfXVkct19sXydbay12IkCMa0gowzwFG55r0fT6TnWBkJUFYNPENEH
bFXQdHl3asnFYJwCHaBtcSPQ2IdUYsmHDZ3zCcw5hykMhmvWipQ7zsvyaF+9UGcO
IiVbRHgKvO1ARAuqmu72
=0FDq
-----END PGP SIGNATURE-----

--=-DPwYNhE8vRC1Fax5lW53--

