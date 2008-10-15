Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJOVsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 17:48:15 -0400
Subject: iwlwifi workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LPkHimxe6sPgIycu7m+y"
Date: Wed, 15 Oct 2008 23:47:39 +0200
Message-Id: <1224107259.735.35.camel@johannes.berg> (sfid-20081015_234818_832647_027C42CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LPkHimxe6sPgIycu7m+y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Does it really have to be multi-threaded?

static void iwl_setup_deferred_work(struct iwl_priv *priv)
{
        priv->workqueue =3D create_workqueue(DRV_NAME);


this creates one thread for each CPU, bound to that CPU, which seems
overkill. mac80211 even provides a single-threaded workqueue.

johannes

--=-LPkHimxe6sPgIycu7m+y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9mT3AAoJEKVg1VMiehFYE5UP/A11KWxTAmr8TBT1W4hsl54t
+VfhGVPqWQISL5Lvn9NFp9BAknU2wPEn080EVoA2vaAbNUv4elMSdppmiC/chkZ7
uC9HnziEAvTzAfW4TOOVUjTWcaV6eNfcQelE1YZn1EYbCXd/tNmfmjND9DueWx10
jbXgCnplbrOHfL9beikdsso1XOu8VDkPMbsRvA6FrFuMbS4mDohiy9tHc+Gbu6EG
ZDIQ/hOCIXYiy/0IadKCXLZdP6GJnHSeixwg/FmEXK6+gbH5bs4d/vdSIUZupaZw
5S1imfGxTa4ZB7KtHyt7bz3/J2jwoykDb1kyjwx5aTMCMnkIprlwc/DZys7C3Hxw
WKMZXknw1G2nYsuPJpTI0spN95+XRC6KNedamSZJnVtrilJhNDAi9+mH2cKq/TYH
aLGJMNj4MvyRIxaQE9gvWLO8KesMUEnbfZRwbWWY4tpUtfwxMG/2jF/7IxjZIPvK
WdHOaUaVbG3oa+33ki6YEHyzkEg5p0guGt6bFu9xHUXfYmQTzfJIF6Gb2OCqWsbu
7KpQMU6mqxdQo8Z9urjUhzd+TlBkAOpMbX7mPLkBVp22hpolL11ULUkZSxTtkZYg
yOBBsVTRpT8UC24kdPpFxV0yDAeNuQCWQdu47PGfhe7yJXt6f1/bTDa5N54NHcj1
3jgQmaGrHHxZd2FKdsH3
=T8d3
-----END PGP SIGNATURE-----

--=-LPkHimxe6sPgIycu7m+y--

