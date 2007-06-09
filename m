Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXFIJIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 05:08:12 -0400
Subject: your nl80211 work
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mJolaNg+8CO09WxUQpBq"
Date: Sat, 09 Jun 2007 11:07:23 +0200
Message-Id: <1181380044.3566.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mJolaNg+8CO09WxUQpBq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Just saw on IRC that you linked to
http://git.spaceboyz.net/nl80211/nl80211-dev.git and took a quick look.

Some comments.

You say that

+ * @NL80211_CMD_GET_INTERFACE: request an interface's configuration.
+ *     either a dump request on a %NL80211_ATTR_WIPHY or a specific get
+ *      on a %NL80211_ATTR_IFINDEX is supported.

unfortunately, it can't be a dump request. The problem is that when you
have a dump request and possibly multiple virtual interfaces, and one of
them is controlled by the userspace MLME, then you need to call out to
the userspace MLME (via netlink too) to get the configuration. That,
however, can't be done while holding locks which would be required for
the dump request.

+       /* %input: wiphy */
+       NL80211_CMD_SET_CHANNEL,

The %... annotations were for my pynl80211 tool, feel free to leave them
off. In this case, it should probably be
 %input: wiphy, channel, phymode
but if you don't want to test it with pynl80211 don't bother.


+       int     (*get_channel)(struct wiphy *wiphy, int *chan, int *freq,
+                              enum nl80211_phymode *phymode);
+       int     (*set_channel)(struct wiphy *wiphy, int chan, int freq, /* =
XXX both?! */
+                              enum nl80211_phymode *phymode);

I don't think both are useful. Somewhere we need a library function to
convert from (chan, phymode) to frequency and back though. Although even
frequency isn't unique when you get to .11N or the atheros turbo foo.


+               case MODE_IEEE80211A:
+               case MODE_ATHEROS_TURBO:
+                       *phymode =3D NL80211_PHYMODE_A;

Are those Atheros Turbo modes actually useful these days in mac80211? If
so we probably should support them in nl80211 too, but I don't really
know, I guess Jouni is the only one who ever used them?

In any case, looks pretty good :)

johannes

--=-mJolaNg+8CO09WxUQpBq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGam3K/ETPhpq3jKURAq7QAKClVQAzgLvzuq4wqt3WvQkt0J86iQCfQSRd
UHe9JUjhgH7slCEzV4RA7DY=
=DNlW
-----END PGP SIGNATURE-----

--=-mJolaNg+8CO09WxUQpBq--

