Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759591AbXHWOPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 10:15:52 -0400
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <vbraun@physics.upenn.edu>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1187805455.9845.104.camel@carrot.hep.upenn.edu>
References: <1187406018.30247.17.camel@thinkpad>
	 <20070818034146.GC1415@jm.kir.nu>  <1187787855.4314.6.camel@johannes.berg>
	 <1187805455.9845.104.camel@carrot.hep.upenn.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mC6sii79FEstveNB5hP5"
Date: Thu, 23 Aug 2007 16:16:26 +0200
Message-Id: <1187878586.4314.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mC6sii79FEstveNB5hP5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-22 at 13:57 -0400, Volker Braun wrote:

> Thats PRISM2_PARAM_MIXED_CELL=3D1039, which you removed in your
> 023-remove-unused-ioctls-3.patch. If I revert that then I'm sure your
> iwpriv call would work around my problem.

Oh right, but I dropped that patch now that Jouni complained about it :)

> Note that I'm not in a mixed cell! iee80211_privacy_mismatch checks
> the
> wrong mismatch. In my case, the AP broadcasts privacy, but I do not
> (yet) have a WEP key.

So far I understand, that's exactly what happens with WPA as well.

>  But really mixed cell support is about the AP
> _not_ broadcasting privacy, yet the user _having_ a WEP key
> configured.=20

Ah, so that's mixed cell. Had me wondering anyway :)

> So say we fix iee80211_privacy_mismatch in checking for the right
> mismatch only. Then everybody would be happy, except some poor soul on
> a
> mixed cell network who would probably never figure out how to enable
> mixed cell mode. Why do we hate him so much? ;-) There is no security
> implication in enabling mixed mode by default --- management frames
> stay
> unencrypted and data frames with privacy mismatch continue to be
> dropped.=20

That's true. However, I'm trying to figure out why wpa_supplicant
doesn't tell mac80211 it's doing key management in your case. The first
check in privacy_mismatch() should make it return 0 if wpa_supplicant
sets key management, which works fine with WPA. I'm wondering if there's
actually a bug in wpa_supplicant here.

> ------------------ snip --------------------------------
> Mixed Cells Mode

thanks for that, where did you get that from?

johannes

--=-mC6sii79FEstveNB5hP5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzZa6/ETPhpq3jKURAu5HAJ4rQfGAgNyMYNxjyCVE5cm40IJCowCfe9OW
rmjfzByHc0Dg1/5cmxZWcZg=
=Y2o3
-----END PGP SIGNATURE-----

--=-mC6sii79FEstveNB5hP5--

