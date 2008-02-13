Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYBMMIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:08:25 -0500
Subject: Re: mac80211: net_sched vs. HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240802100830t772b245fgf9e54ae058b384fa@mail.gmail.com> (sfid-20080210_163102_534116_23422D13)
References: <1202489552.24811.10.camel@johannes.berg>
	 <1ba2fa240802100830t772b245fgf9e54ae058b384fa@mail.gmail.com>
	 (sfid-20080210_163102_534116_23422D13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZZVc0HOM4xX/YKfEDOg/"
Date: Wed, 13 Feb 2008 09:01:31 +0100
Message-Id: <1202889691.8931.25.camel@johannes.berg> (sfid-20080213_120828_699726_3B4AE309)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZZVc0HOM4xX/YKfEDOg/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I don't really follow your question. The dummy functions in wme.h for
> wme were there before we added only ht functions.

Yes I know.

> WME i.e. QoS is not defined when NET_SCHED is not defined. This is
> more for code completeness then for anything else, in fact with do not
> compile mac80211 without NET_SCHED support
> Valid QoS STA  is when there is  QoS association and support 4 AC, etc

Yes but we still fill in WMM information elements and announce QoS
support w/o NET_SCHED which seems to be wrong, especially with HT.
That's what I was trying to get at. Should that be dependent on
NET_SCHED? I think it should so that we don't announce QoS/HT support
when we don't have QoS in the kernel.

> AMPDU queues and also 4 AC queues are after all funneled to 4 AC lower
> level queues we called them TX FIFOS, which are configured according
> QoS parameters (not upper queues, but that's transparent). The major
> purpose of AMPDU queue is handling reordering not AC. =20

Right, that's what I thought. I guess the decision on how many frames to
aggregate in a single AMPDU is made by firmware then? Doesn't really
matter anyway.

In any case, I think this confirms my idea of splitting up the "queues"
hardware specific value into "queues" and "ampdu_queues" where "queues"
are the number of FIFOs with QoS parameters and "ampdu_queues" are the
number of helper DMA queues for ampdu support. Broadcom doesn't seem to
use extra DMA queues for this, the aggregation decisions are (afaik
since the hw has no extra queues I can find) all made in the driver. I
suppose b43 will then have to fake a reasonable number of "ampdu_queues"
and handle it in the driver.

> In general for example in AP mode you would need to handle <number of
> associated station>x<#TID=3D8> AMPDU queues which can come to a horrible
> number.
> The limited number of queues is acceptable again due to fact that
> medium is shared and you cannot really utilize too many BA ssessions
> at the same time. Some policy of eviction based on link quality is
> required and still not implemented.

Expected traffic too, I would think, no? If the traffic from/to a
specific station drops below a threshold I would expect to tear down the
BA session.

> > ---
> >  drivers/net/wireless/adm8211.c              |    7 -
> >  drivers/net/wireless/ath5k/base.c           |   10 +-
> >  drivers/net/wireless/ath5k/base.h           |    4
> >  drivers/net/wireless/b43/dma.c              |   15 +--
> >  drivers/net/wireless/b43/main.c             |    3

You really could have snipped the patch out. Please?

johannes

--=-ZZVc0HOM4xX/YKfEDOg/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7Kj2qVg1VMiehFYAQKqfA/+OuBWMCte4J5JWmjYCJU4H22+DU2E4mI/
YmgIPs47dUYY6dGFgwXJicL9UltUUWVMnAgUlR9YrhQrtiaRw+7xHrFGwTKtobcV
sri/8mpV1eJZYWED/uD/cMEmY2wnkrFO2qT3Ntj/o8soBf+pEu5uJ+OkLgnnI1py
cjFZ8mVmZgKJb2jwKu/JP+6dTBcl4FSi1ppBj0D7Dbzkd73cLuWpExwzHBGmboMz
A1jIe2sELv49x0jd5DAylYqn3Pu2HAQZ8Gjjw3N8S0K1gnSOezEN6QG7H5BJiJqD
MuFOGEic1pgILGf7cN0waCLD8OA4Dx+ymZtUZOdoLO3/E4+/po/V68/zQm7a/TfO
+WBA6npkZ+Kab835i1hlZj+9lRqvn7hbb4dzU+fNSed91rv0qzbvY4VnNImnikL1
2meYN1wwl9emVmGaQUi34jVIGAOPIwuCfBclkEbJC5yS5CWDRi3V16vx4XUk8MPm
3bm6mTTVK6BGRBBEI4W53pzjCmQMDXxO4XX/x6kbGrgv6mCI3fc6i6A9pYcv0S5J
z6XzwKQAhlIg70t4a6MyNjQBvkwYnm/uOb6ruzunhOMyFMj/+Ya3RIBltAORtFmz
Vm3fta/ZfpgSjVQvgrZOtCKpzJcVhemegtWSNEI9Ajn4qWqWexGITE9q4X5x5Mdb
lSsThOhN59Q=
=GDVK
-----END PGP SIGNATURE-----

--=-ZZVc0HOM4xX/YKfEDOg/--

