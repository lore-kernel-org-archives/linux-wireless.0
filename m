Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbYBGKfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:19 -0500
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78212.15588c0a.27b2.61d2@mx.google.com> (sfid-20080204_212233_169667_739F231D)
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 (sfid-20080204_212233_169667_739F231D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nZAcQp/FhR1TKeTVoZaO"
Date: Thu, 07 Feb 2008 01:13:08 +0100
Message-Id: <1202343188.9965.41.camel@johannes.berg> (sfid-20080207_103527_147888_7C38C7A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nZAcQp/FhR1TKeTVoZaO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Cool stuff! Code looks pretty good but there seems to be some
misunderstanding, especially wrt. beaconing.

> - Possible integration between mesh peer link and sta_info structures. Th=
eir
>   purpose is similar and it will make it easier to implement mesh rate co=
ntrol
>   and airtime link metric.

Indeed, I think this should be done. For one, we already look up the TA
sta_info structure for each frame so you don't need to look it up if you
pass it appropriately. Also a second hash table based on TA address just
takes up a lot of space.

> - Beaconing support: the current beacon model is appropriate for the zd12=
11rw
>   driver but might not be for others.

Indeed. You shouldn't set conf->beacon directly, instead you should
change ieee80211_beacon_get() to support getting an IBSS beacon and then
you need to call ieee80211_if_config_beacon() where appropriate. Using
IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE from the stack is simply wrong
too.

> - set_mesh_cfg command to set mesh ID and use of broadcast mesh ID when n=
one is
>   set: Johannes suggested the mesh ID should be specified when creating t=
he mesh
>   interface [1]. However we feel that a "mesh configuration" or "mesh net=
work"
>   object analogous to the "association" object he talks about would be mo=
re
>   appropriate. Such an association object has not yet been implemented. W=
e
>   would appreciate some advice on how to implement our mesh network objec=
t so
>   that it follows the spirit of mac80211.

Is it really useful to change the mesh ID on a running interface? It
seems that would totally throw off things like multicast caching and
peer link establishment. Therefore, it seems that
ieee80211_if_set_mesh_cfg should reject to configure a running
interface.

> - Scan support: we were waiting for scan to be moved to cfg80211 to avoid
>   messing unnecessarily with wext, is there any effort in this direction?

What specifically do you need? Scanning for mesh networks? Wouldn't a
regular scan find them as well? As far as I know nobody is currently
working on scan support in nl80211. Maybe you can simply report the
relevant mesh IEs in a custom element and sort it out in userspace (for
now)?

johannes

--=-nZAcQp/FhR1TKeTVoZaO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pNE6Vg1VMiehFYAQJeIg/8DSc/N5CiDNnSqPetRQ3qj+n9LHJCcQu6
UBp2Kj4PPrIza/dMnnI7V8x0j4BaCiioGZpOGMDZ+EOCsg7TAMHHBhzf+jJw2ATy
Pb9Hk3BxmLyTWa9iWUiJlOmn5jZyWmNg0kYdxIR31zGfPkZSSNFhjE5hLJs42KT7
oN/YDOSiiUWmoVtUkxnC/7AEFUiD6PiKj+gEp46LbcOLoCfWnDXwFxrC0EZIKxAN
Cku5OQSy4+SCQNYEcBs2nKBqW5hr5LeOV57DrnXKHeWC0WKU+kHvyiG7y/99rYxq
BNDT4dNxsp7UFwjjIAXFcmBoorpSun2m2v90jHI0ICJSnbOzwLpfGMkDzvBOfD6l
ORohsYtNY83d1YEzpENcCb6zagkTLhUpchifS0LX7Sh/VfPgTjKB4S2U4axz9DDP
zD2y6DRZn2A6Osk59gTq1EX3mHf3fv4x/6hV+M15D6Mc8g7SNmb1aGWHrUqsOIFl
zptibjUq/rOwokeiHeL7BtHVECFIKdbrrrrqC02G9VCVtob0fxki/zd8AdGd4p3l
NfKAYu1krAu+qvkYTy11QfLZ0IldPOOGYlAts5m77bxJXSMCKiqw+VO+YIMehYSe
e5zFW/EqXEnNGyiAi5DjiOSjUlZlIR7inSYr6lY2+F9QEeO3vl4fA/RgxY/WmEkz
4TtPFRDLjCU=
=sbN5
-----END PGP SIGNATURE-----

--=-nZAcQp/FhR1TKeTVoZaO--

