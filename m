Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbYLKRFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:05:41 -0500
Subject: Re: Listing established mesh connections
From: Johannes Berg <johannes@sipsolutions.net>
To: Keir <keirlawson@gmail.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <e27b78a40812110639w212d4b72v3ad5d54246b191cf@mail.gmail.com> (sfid-20081211_153941_779852_BDFEDD1C)
References: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com>
	 <1228922932.15837.4.camel@johannes.berg>
	 <e27b78a40812110314w409a0294w1e73d40d9d34fac5@mail.gmail.com>
	 <1229003711.8081.4.camel@johannes.berg>
	 <e27b78a40812110639w212d4b72v3ad5d54246b191cf@mail.gmail.com>
	 (sfid-20081211_153941_779852_BDFEDD1C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6zKoI75Lrrw7HCMWbYV0"
Date: Thu, 11 Dec 2008 18:05:03 +0100
Message-Id: <1229015103.8081.30.camel@johannes.berg> (sfid-20081211_180545_796837_DD4FA1E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6zKoI75Lrrw7HCMWbYV0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 14:39 +0000, Keir wrote:
> Yea I had that thought, but I wasn't sure how many items there would
> be in that list, or whether there was a less than linear time way to
> do it.  I did look into the IW code, but i found it quite hard to
> follow through that back into libnl and from there back into the
> kernel.

Well, it's pretty much

rcu_read_lock()
list_for_each_entry_rcu(sta, &local->sta_list) {
	if (sta->sdata !=3D mesh_sdata)
		continue;
	do something with sta
}
rcu_read_unlock();

I'd think.

johannes

--=-6zKoI75Lrrw7HCMWbYV0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQUg7AAoJEKVg1VMiehFY4zQP/iSIF1dFSPvaSlD3t3xAhlT8
c/ciMFyGQVXRjdaegS6MRrsmmWOk/MxJsyxVtWRwkVrMJACoB3VjOcdc3lZjGlDP
Q5VGkkM6mM6wcgZgmRQ8R8m53SsjwRyu/QHtdcc8DE++tWke3HBQ1J3VzWu0HcMi
mAqe1dd8Ve1YKHjXGoeovjr1YjzDF+O+KemppBcjVV6HW3i4bTsGODCbhJH5RhpQ
7PkvTO5BBxcGp3NfpOXtTcEjAxzUfF7e2CAeBK8yUKBsKkDR4WQYqAOrywlAMPr+
XI/oeEs+Gv6hU62SS16/kf1wcPF0iEcksDK/eysnwnMflUaqcHXDSrKkiLeq2RGM
bULqLjxmw7ZSW/23B+rllSk+GE2hMi/2Mpm8+9RxsCDfe4cidKfUqw3axODxaGMP
yeD4xNCAILteWN3GSZtPrublLqYxyVO46NrYku0azFn89xQHUkXdyS5M83pmE8v+
15Fmyh2eOhmyoPzoWBVVpKUSbCQi3PBKRcAGJ/I1vxKGBXF7HbghiBkFp4pZ0ltw
dIzP/EHoPYdGEoHx7T+O1unXGZC1AKqlog1I62SQ0c60hNMdFvQzOQHrF51LyI65
R7hGxuIG/HBwkwmdD59oS/RtP+UL6wEPDBxmGYqgQ1IQy6DimjrWRbNEmq9Djxwh
Sm/Nvzzn7vfRMk+1fgYh
=x4Zk
-----END PGP SIGNATURE-----

--=-6zKoI75Lrrw7HCMWbYV0--

