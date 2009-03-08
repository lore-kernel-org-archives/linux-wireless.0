Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZCHM2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 08:28:14 -0400
Subject: Re: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090305152346.GA30029@jm.kir.nu>
References: <20090305152346.GA30029@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ToMMk93nz9VFPgxyba0f"
Date: Sun, 08 Mar 2009 13:28:07 +0100
Message-Id: <1236515287.4205.11.camel@johannes.local> (sfid-20090308_132817_341356_81A850E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ToMMk93nz9VFPgxyba0f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-05 at 17:23 +0200, Jouni Malinen wrote:

> @@ -99,10 +99,13 @@ static u16 classify80211(struct ieee8021
>  	/* in case we are a client verify acm is not set for this ac */
>  	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
>  		if (wme_downgrade_ac(skb)) {
> -			/* The old code would drop the packet in this
> -			 * case.
> +			/*
> +			 * This should not really happen. The AP has marked all
> +			 * lower ACs to require admission control which is not
> +			 * a reasonable configuration. Allow the frame to be
> +			 * transmitted using AC_BK as a workaround.
>  			 */
> -			return 0;
> +			break;

It seems to me that return 0 here was incorrect, or wme_downgrade_ac
needs changes?

johannes

--=-ToMMk93nz9VFPgxyba0f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJs7nVAAoJEKVg1VMiehFYtisQAMZbJSdDyBxowPmPTrlsFamo
a8GCeU757yVix9u/iMBHyjOoblDnL5uTEC3bENLBTnCzoX/LLGUU9iDNIqYEGDfh
RVWbvfsl7MiLqQ3fTPb5ZdQK8RR6laMbr5yI04Y4BYhdEJflyNdCzH86G4/nTp7Q
RM0ExCMDGJIRWdGrHPj1AcphIqlmeuckqCb+oWwC1VWDYy15Vxm1yuyhCh25Eb9N
fpxnco4pKbs9QAhd2XZJaTE9QXyVtn0j6obpzR3J7JsL7DNQ4DlTX1U5awZWJBis
E/Wou8PvpQ+VP7eHB1aNRts3oLa5Sods3D0OrAKwujKlbSYvlFmke/O3UEsMVHKu
3U7+4zGjkoHIYdfcVsEBeD+9Hg/nWJv5Tre/a0wW6wynwoxPgaxWRpXluNY4DbQ1
zFvhCUd34frxzd7FhqBPiWAbL7BiTHlMiWYGE+gNlkZgSf9ybJ5v9ObcCBqf40Fb
9XIsSYqbN/zCzjGCSQgWuHHwudtlL9sMD9yRFcYl6votgorn+8187YlrTGetl/el
urukzHGpo+oqpzukaCjzZiSa1k1VOzO7YA5JMMi89u/ZHto9LB9AvjBBTAd0Dwba
EBPye1oicw6ZYOz3+L4fMyKD11fIX9VcWIzVQbs9PsOxTW1QnMOdWQNStr9LE37t
k9/pPJl9GCH0KIWj9mQt
=XrqL
-----END PGP SIGNATURE-----

--=-ToMMk93nz9VFPgxyba0f--

