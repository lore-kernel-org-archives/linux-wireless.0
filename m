Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbXICJ1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 05:27:50 -0400
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46DB6C7B.3020001@gentoo.org>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070821161942.938977000@sipsolutions.net>  <46DB6C7B.3020001@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fG0V1eit32nEJAUkCQ6l"
Date: Mon, 03 Sep 2007 11:29:10 +0200
Message-Id: <1188811750.14564.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fG0V1eit32nEJAUkCQ6l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just had another idea related to this patch:

Currently, we pass multi_count >=3D 0 or =3D=3D -1. And then we expect the
driver to call ieee80211_get_mc_list_item() to get the items. However,
the count is bogus because we add up all counts of the virtual
interfaces and don't account for duplicates. Also, however, no driver
cares about the count anyway.

Hence, we could instead of passing multi_count pass the getter function:

-        void (*configure_filter)(struct ieee80211_hw *hw, int multi_count,
-                                 unsigned int changed_flags,  =20
-                                 unsigned int *total_flags);
+	void (*configure_filter)(struct ieee80211_hw *hw,
+				 struct dev_mc_list * (*get_mc_item)(struct ieee80211_hw *hw,
+								     void *cookie),
+				 void *cookie,
+				 unsigned int changed_flags, unsigned int total_flags)

That way,
 (1) we get rid of the export of ieee80211_get_mc_list_item
 (2) get_mc_item gets to have a nicer interface without double pointers
 (3) there's no danger of somebody calling it outside the right place
 (4) we can use a NULL function/cookie ptr to indicate that the
     list hasn't changed.

Thoughts? I think I'll implement this, I like it much better than the
current interface. And I'll also look into getting it non-atomic. We're
not protected against concurrent execution anyway, but I expect drivers
would handle that? Or do we want that here? We can't protect all
callbacks among each other anyway with the tx() callback etc...

johannes

--=-fG0V1eit32nEJAUkCQ6l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG29Pm/ETPhpq3jKURAt4lAKCcmZ9FtNxgF55pLktl6y/OvL2lKQCgmwAA
Exjkv/iNpM8sDaBM7O0VxOE=
=D4U2
-----END PGP SIGNATURE-----

--=-fG0V1eit32nEJAUkCQ6l--

