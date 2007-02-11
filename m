Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXBKTl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 14:41:56 -0500
Subject: Re: [PATCH 1/4] create cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
In-Reply-To: <20070209162826.930724000@sipsolutions.net>
References: <20070209162711.375886000@sipsolutions.net>
	 <20070209162826.930724000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MAfZ53dOeBUY6f7ipvgw"
Date: Sun, 11 Feb 2007 20:39:27 +0100
Message-Id: <1171222767.3576.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MAfZ53dOeBUY6f7ipvgw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-09 at 17:27 +0100, johannes@sipsolutions.net wrote:

This

> +void wiphy_free(struct wiphy *wiphy)
> +{
> +	if (wiphy->wiphy_index !=3D -1)
> +		wiphy_sysfs_del(wiphy);
> +	else
> +		cfg80211_drv_free(wiphy_to_drv(wiphy));
> +}

and this

> +static void wiphy_class_dev_release(struct class_device *cdev)
> +{
> +	struct cfg80211_registered_driver *drv =3D cdev_to_drv(cdev);
> +
> +	cfg80211_drv_free(drv);
> +}

needs to be changed. wiphy_free() should wait for
wiphy_class_dev_release (to make sure sysfs is gone) before freeing the
structure (if it has ever been added to sysfs).

I'll respin both patchsets tomorrow. Until then, should you want to test
it and not just review the code, please just comment out the
cfg80211_drv_free(drv) in wiphy_class_dev_release, that'll give you a
memory leak though, but I have to leave and can't write the code
handling it with a completion etc. in under a minute ;)

johannes

--=-MAfZ53dOeBUY6f7ipvgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFz3Dv/ETPhpq3jKURAu0IAKCWG/nFBDJq7h9mR9p6fsxzwCxBXACfQeS4
l30/VO6if5rsDEGHUmy2N5c=
=TLvr
-----END PGP SIGNATURE-----

--=-MAfZ53dOeBUY6f7ipvgw--

