Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYC0My5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:54:57 -0400
Subject: Re: IBSS RTNL assertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240803261624ja282affw88eeab09e5514407@mail.gmail.com> (sfid-20080326_232407_856692_150376A1)
References: <1ba2fa240803240921h44321705s923ecac89427196e@mail.gmail.com>
	 <1206533179.16475.313.camel@johannes.berg>
	 <1ba2fa240803260656vcfd681r4f1599bc31220b87@mail.gmail.com>
	 <1ba2fa240803261624ja282affw88eeab09e5514407@mail.gmail.com>
	 (sfid-20080326_232407_856692_150376A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vuVJ1UyG6Tmpn4nh0kZh"
Date: Thu, 27 Mar 2008 13:54:48 +0100
Message-Id: <1206622488.22530.32.camel@johannes.berg> (sfid-20080327_125500_893817_8CA3F333)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vuVJ1UyG6Tmpn4nh0kZh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Maybe. I scanned it very quickly but I think there are more problems
> >  than this one. I will check it once again.

Thanks!

> ieee80211_add_station - LOCKED by rcu_read_lock

That's actually also locked by rtnl, and shouldn't be locked by rcu, the
two statements have to be reordered.

> ieee80211_del_station - this one is NOT LOCKED by rcu (it's locked by rtn=
l)

That's the way it should be as explained in "STA information lifetime
rules" in sta_info.c

> ieee80211_open - NOT LOCKED

actually locked by rtnl as most netdev callbacks, so fine.

> ieee80211_associated - NOT-LOCKED by rcu

not supposed to be, is under rtnl

> ieee80211_ibss_add_sta - NOT LOCKED (not locked at all)

That's a bit of a corner case, maybe we should allow this, or maybe this
is a bug in that it should lock the rtnl although the STA never went
live. The rtnl locking requirement comes from key management so this
can't actually cause problems (since mac80211's ibss code can't do
encryption) but it should still be fixed.

> sta_info_debugfs_add_work - NOT LOCKED

that probably needs locking.

I'll look at making patches, thanks for the review.

johannes

--=-vuVJ1UyG6Tmpn4nh0kZh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+uZF6Vg1VMiehFYAQKlNxAAtSIeU+R5ebtuGJNGyhwDXkppDS6R38v8
8hBGp6JBjcL7KCHmj5GPaXZ90m5uqM27SZkZ8omO/QYj9BNPyShzzC5mKZB1FyZr
vdv+gmRyN/KGQA8jR8ty5D2yV4b97EpKPc+Ej5UrsvHonOcUfj/NeBHKftULQuam
weRoeUk0H4TL44+BrMiI/2ucXSNHxGLEmWn9cLsz/H7UF4fUfmpG0jIDeip7E0i1
AwVueocuoR7qs9WOR7xZjEmRb7fkLqBdgwGmQFD4Jl9tnVLn0E+rCc70Jdg6kxOz
Sq3jthlAM41NWrdzbY8Th59+ue9yqMLobszAkb/mP98RSyLfvGru8pQVi4e0/N15
qYLdgrmqX00D039gOZaoEbLCOX8ZgMa5o5oDmKEHB3xzJ2IB5Vv+w2v9jKGxq5ZQ
EJFKs200v0Mus+npwhmU+RZDPXuADdPKpZqMMvDcEtoduyYBXIqQo1DH+LHCCwuq
Ji3B3wyyhUk32s8tmDCFMdPHFJ/ViJ+1zwi15g/eVMVvaYImRDBawNDoCn/mNRiq
uFeXjwvgFvP2qMwqGc4CTe+b+FxBZYvzevwjxgYSuFeGiBtc0zPFFSLF5kiVq6YQ
uLunGMRspk615y3R8RShciR+LSg3jeyiPgfWbH1SirPfC5ii4vK5ccUB9SkxK5vC
spVf3QkrTMM=
=szR9
-----END PGP SIGNATURE-----

--=-vuVJ1UyG6Tmpn4nh0kZh--

