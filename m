Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016AbYDDOnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:43:37 -0400
Subject: Re: mac80211: ieee80211_ops.bss_info_changed question
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB08920041CC3C6@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB08920041CC3C6@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Nq8rCGLP3nkmfwhOun9"
Date: Fri, 04 Apr 2008 16:43:25 +0200
Message-Id: <1207320205.19189.25.camel@johannes.berg> (sfid-20080404_154409_934891_129A1631)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Nq8rCGLP3nkmfwhOun9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Reinette,

> In the comments about bss_info_changed it is said that the callback has
> to be atomic. I was looking at it and could only find that it is called
> either from the workqueue or an ioctl. It thus seems that we may be able
> to sleep in there. I likely missed the spot where it needs to be atomic
> ... could you please direct me to it?

I think you may be right, I can't find any spots either. I was likely
mislead when writing that by the fact that much of the code in
ieee80211_sta.c uses GFP_ATOMIC while it actually runs from a workqueue,
which is actually confusing me still.

johannes

--=-+Nq8rCGLP3nkmfwhOun9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Y+jKVg1VMiehFYAQJKuxAArMapINowUhCg1vlMjHRQ8Xb96wBALGEA
54TpV8BY1o/WcXyme7hqh1ZuPee0afNDBiXj3vhi4gVaSWMkzonCpS9YniB4B8Zn
dI6TCOVV8XHdXEFzR8yX3/DKkYJurasezils3E6bwMXOFoL5z+OeVPg2FZh9tM7k
o0StRlFIJVZXLzun0Isz+tC0lBIxhoz7Pw+V0Dz0vQmOpHTH5tV18LnP06gLeewA
46AEzjJoKzONCjgK+pAdaNikMMRAu3VeUM4gsh/2lWmTQHqnltdMGeCaT2dpDtBg
H0+gJ9+ymUGmKcdEhiuK0aYiVQIPs/k5IKrKDSUVjHq9dNDjrZlqA07VFqz4bkKq
CtrK5Fyaa13ccf0tmhD4zfT+6azg/7ytX8vKpQH5aONlyfTBFF4g8G/vlhaGIgPY
3u3TqW/qsQJAuQ0rP+AJNgn+lvDTiLkIyswkQBcml4i8fjH4aV+kIH12blYkEUbs
0xTO/Knr5ULgSzFSIApRqyaCB+BTnabqzhZKCZwZNcUmJGIbtqQC3I7rXhZKb8Ah
GPU0KGtYeGw+EaAF43clWfqVWVNoeLeqOymVvJ1OgZGqlUMFM5X3k6BwR4mgEu4X
etG11xc9yR+zjZQlJXZIJIG3AaUYNQhXRHHfBKg2aO0Ft2/Liv9WxpBCcywgwoEK
iNzCjdVgF2A=
=6DN1
-----END PGP SIGNATURE-----

--=-+Nq8rCGLP3nkmfwhOun9--

