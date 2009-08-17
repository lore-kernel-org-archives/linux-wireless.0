Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbZHQPAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:00:08 -0400
Subject: Re: [PATCH] mac80211: allow configure_filter callback to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1250518613.15103.7.camel@johannes.local>
References: <1250518613.15103.7.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9XF1HIJW+EIyaltTX3Gf"
Date: Mon, 17 Aug 2009 17:00:06 +0200
Message-Id: <1250521206.15103.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9XF1HIJW+EIyaltTX3Gf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 16:16 +0200, Johannes Berg wrote:
> Over time, a whole bunch of drivers have come up
> with their own scheme to delay the configure_filter
> operation to a workqueue. To be able to simplify
> things, allow configure_filter to sleep, and add
> a new prepare_multicast callback that drivers that
> need the multicast address list implement. This new
> callback must be atomic, but most drivers either
> don't care or just calculate a hash which can be
> done atomically and then uploaded to the hardware
> non-atomically.

Oh I should probably mention that
 1) I only tested with hwsim, but
 2) I don't think it will break much since it doesn't really change most
    drivers.

johannes

--=-9XF1HIJW+EIyaltTX3Gf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiXByAAoJEODzc/N7+QmauUUQALTynO603QcbPWmFnHEwgw6H
lCZeNyQpLb0yAnXQjFgqlVUOr3a4TbQZ6suAAXsT6NMU9yLLKw0Vxxd9UhO3xDDz
wI4zTMjbNgzUkFC3fWtsGZ7d3GDo3lHtvHkFhg1lBmgsN/Z5xMw23y3tKLWtycmF
5aAe7TkQFBP3VI2vD2kMxlaz/ybgxtM65YDE/qsZxxHT+9xdxyk2KYqnapLhykrx
fVlnCOAuWCdpCYUzxOnCKGKmmfywQXO0SiEtgHhqlGEtqVdjm2ji8t9taHgx4oIm
+SokD0HYaWtChNCP2EGaxKUC51jzIKAU21w1d52bQ4qYJoh1Dd6S1x+9SHuOMKny
hAs1FNIUI0tX1k+ApELYqLOvgNSs+Do3mszS7I1aVg08GWJ+TATGkHAPq8r2l5sl
lk94miqk5gcwux6shpcG7smP4QT9ECWAdZF14xgYtHEeECgEGehPUnDeAbajb6Nc
+VG3DO75wnsMBdKJMZsAyz2b9Yp/SOmuElvbmU0it7wNz4LcWs2aNoZMaZrzM2uA
yBM4vbWdiUFt06diP295Z7gz20M7WSX+0kVjXM/Rzk1/mmG9UvugSMJmD4qo/Wfv
t8xwWFWzzfuQ9jHQCD6qu8KPQztLYxKW8VtmbHfRfMeSDka9uysugUTTlz4+YL/B
A4eHv4zoxeBxyV9NHWJk
=960r
-----END PGP SIGNATURE-----

--=-9XF1HIJW+EIyaltTX3Gf--

