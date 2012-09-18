Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646Ab2IRIfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 04:35:46 -0400
Message-ID: <1347957651.7112.38.camel@sauron.fi.intel.com> (sfid-20120918_103556_387116_D2775770)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eric Dumazet <edumazet@google.com>, linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 11:40:51 +0300
In-Reply-To: <1347952199.6503.3.camel@jlt4.sipsolutions.net>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 (sfid-20120917_163617_677167_0B529F43) <1347952199.6503.3.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fu/Uqsn8SIT5G/hYe8iy"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fu/Uqsn8SIT5G/hYe8iy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-18 at 09:09 +0200, Johannes Berg wrote:
> Hm. This is curious. *How* does AP mode fail? You said earlier stations
> failed to connect, but can they actually get associated? I'm curious
> because while I could see the carrier state thing causing issues (on old
> hostapd versions that we didn't test), I'm not sure I see how the skb
> payload makes a difference since mac80211 will linearize management
> frames (so association should work) and data frames don't matter (so
> authorization should work) ... unless there's a bug somewhere in
> mac80211 where it forgets to pskb_may_pull(), but I don't see any such
> place right now.

I am not sure what happens. In the failure case the high-level symptom
(in NetwokManager or in Windows) is that "failed to set IP address".
I've captured 2 tcpdumps - for the working (those 2 patches reverted)
and non-working cases (vanilla 3.5.4). I'll send them to you privately.=20

--=20
Best Regards,
Artem Bityutskiy

--=-fu/Uqsn8SIT5G/hYe8iy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWDOUAAoJECmIfjd9wqK0w2oP/1WvtHnV3b69S9NhLkm4/ylw
gWUbHzqGO3jMnGSHObhh7A8J27dj2qEntwIJxSZG0A89U2HOTeTGxDGWDqq/Avj9
i1pMDyjbn2Du9akLnLXAcdHjSegGyTnZ/6cwLwcd/4eYgjhcwPquzJVbgFrPgtJP
5zJVc2Wjup9n+kcLEe4r7GUumjI82VeNDtvZbEwKzo6eSGP6a7xf3lmwOusIAY8D
Cr3ItBTOVPOK4V26eRBK9GpVB36FIzuDsbuTtFM/0/oBsXtEB2NgghIjjjrq5nEI
IQ+UgxD2sv94CIN3l1KEXRt8f6aYyQrdvoyk90SNLhw2lkGZUTI5NrFN+Zzhyzeo
RjB6LRncMM/I86ZmK9IqRirTldIyldNyieenKYJNwk1d1CtrX6nMvDIa1g+YCkxw
gi3NxxnhWK+hCPsp+sJarvp6HV0b+1bfrEIzaehFAEzlkJHRmtdsR6SXufdORvyf
wnNygNy0/4WVjyXHhp39b159YbhGF9DpNF3UjaIr3VMiBLKxA8y+cuLmI5LvlAYC
E69y5Aa5qAV5n9pKlzCavHJjqZIdTASguOD0vT9aAaErvr5/jFKQFQHrxW7INuu1
rBXtnWazt0ccd2tAAAzBmlevd+z1sXLY0c3s6XF22Zwrg1vO3vW9Iqz+DsE1Fgss
ugUkwt826+sikB1GYza6
=RJSw
-----END PGP SIGNATURE-----

--=-fu/Uqsn8SIT5G/hYe8iy--

