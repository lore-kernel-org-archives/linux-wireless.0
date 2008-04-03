Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYDCNOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:14:38 -0400
Subject: Re: [PATCH/RFC v3] mac80211: proper STA info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1207067026.5143.120.camel@johannes.berg> (sfid-20080402_100543_479722_BE0B648C)
References: <1206569781.22530.18.camel@johannes.berg>
	 (sfid-20080327_125027_868420_4C276109)  <1207056452.5143.95.camel@johannes.berg>
	 (sfid-20080401_142746_785699_29242688)  <1207067026.5143.120.camel@johannes.berg>
	 (sfid-20080402_100543_479722_BE0B648C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LYsh8DALBxKbnoW6ZJXg"
Date: Thu, 03 Apr 2008 15:14:32 +0200
Message-Id: <1207228472.3636.69.camel@johannes.berg> (sfid-20080403_141447_386429_22F6296C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LYsh8DALBxKbnoW6ZJXg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-04-01 at 18:23 +0200, Johannes Berg wrote:
> As discussed earlier, we can unify locking in struct sta_info
> and use just a single spinlock protecting all members of the
> structure that need protection. Many don't, but one of the
> especially bad ones is the 'flags' member that can currently
> be clobbered when RX and TX is being processed on different
> CPUs at the same time.

No objections? I remember Tomas wasn't entirely happy with the
suggestion that RX/TX aggregation don't need separate spinlocks.

johannes

--=-LYsh8DALBxKbnoW6ZJXg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TYN6Vg1VMiehFYAQJGrA/9Ev9kyG34etgUT6VPrjj4hMxsOBm7rkQR
0ocI/p8TKAMZh4LUwESrTftncoKEnjgRaLQoo/Z9fpCwFoN7L8VZdzcy7DtTZ+Si
ABsjLDdUWkwENCJtRYYn90Xs5LVXFvFRqd/SLeqpC3gS0sG3sjc2V0Zlz46kHvlw
pWm35RIbV9LbI63sqGVHBFK9YrWIaYBbn7oXwBNCXXTX3mpAX+SQfDVBq8eKRePE
6KMBhFEyxJp85Nxf4lx6dM7RfP5HSJ/rHnvvre2o4i9Lo/dBpbA8HtQoAPCpsar4
mLZ6MvS5mWX/GOPc7pqPbYVR3AGEYTRKqFzxrxfsjmDJXW1zNre/5tw9EeLowgxY
O4xv/jM3ONGc8gOxJ6YVDxfcqIwuiD+N/jecuX5iJAriFnoQ7FNhEfnjhr1UmByP
qBIt0HFS8YnBPGsZB9SHLCxxmI9/caqUn5Skw+5qtZpp9XRGrdHj7Flv3SmcC6Fp
K23OtDz1Bm5MjvxLOhsBtfLq7H46eUOs3GygY3VzKlhEf90B2jSK8r4OAEWFFFsy
Rk+wwf4URYRKMFvW5cTUQyULD9csjzgVo8SfGQMixJ2q0/VLnplOfMR5nZWMkIA3
R8qRmfQUzijeDU4fXE9nAh/uEg5Z2x1h5HeK8B9BAEoLVyYigfJTQmxz1b/Fbgks
5HrBYgmNMJ4=
=CGis
-----END PGP SIGNATURE-----

--=-LYsh8DALBxKbnoW6ZJXg--

