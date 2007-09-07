Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342AbXIGNmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:42:10 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189132130.16788.29.camel@debian.sh.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1188914651.9942.25.camel@johannes.berg>
	 <20070905013804.GA388@mail.intel.com>
	 <1188991726.9942.99.camel@johannes.berg>
	 <1189132130.16788.29.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K0cfcOHOLY9mnlJfKqYJ"
Date: Fri, 07 Sep 2007 15:43:39 +0200
Message-Id: <1189172619.28781.151.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K0cfcOHOLY9mnlJfKqYJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 10:28 +0800, Zhu Yi wrote:

> Where is the WARN_ON? I ran the iwl4965 driver with net-2.6.24 commit-id
> 3259203776dc4c3f99b9fe3b303e3e76b13f934d, tried WEP, CCMP, no problem,
> no WARN_ON.=20

Huh, ok, I looked again, it seems I changed the WARN_ON later to be less
severe, but there's this code in key.c:
        ret =3D key->local->ops->set_key(local_to_hw(key->local), DISABLE_K=
EY,
                                       key->sdata->dev->dev_addr, addr,
                                       &key->conf);

        if (ret)
                printk(KERN_ERR "mac80211-%s: failed to remove key "
                       "(%d, " MAC_FMT ") from hardware (%d)\n",
                       wiphy_name(key->local->hw.wiphy),
                       key->conf.keyidx, MAC_ARG(addr), ret);

which as far as I can tell will trigger with iwlwifi when a key is
removed from the hardware acceleration. Maybe my iwlwifi is not new
enough though.

> Since the mac80211 in net-2.6.24 has some structure change, I modified
> the iwlwifi a little bit. You can find the iwlwifi driver for davem's
> net-2.6.24 from:
> http://intellinuxwireless.org/iwlwifi/v6-iwlwifi-net-2.6.24.patch

Thanks. Since wireless-dev is mostly equivalent, can you post patches
against that? I know it's suboptimal to be essentially maintaining two
drivers..

johannes

--=-K0cfcOHOLY9mnlJfKqYJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4VWL/ETPhpq3jKURAkXAAJ4sGm6S4KPLUxEOMIJ5I8Z56NeRegCguTzU
t1YxceCOhZKYLKG2hDl4b9A=
=Hk0n
-----END PGP SIGNATURE-----

--=-K0cfcOHOLY9mnlJfKqYJ--

