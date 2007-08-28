Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbXH1Klj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 06:41:39 -0400
Subject: key races in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AYqIdw5dKzQjtVGHEFOo"
Date: Tue, 28 Aug 2007 12:42:56 +0200
Message-Id: <1188297777.7837.94.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AYqIdw5dKzQjtVGHEFOo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Working on the key code made me see a lot clearer and notice various
problems.

For one, during receive processing, we can select the key before using
it and because there's no locking it is possible that we kfree() the key
after having selected it but before using it for crypto operations.

Secondly, during transmit processing, there are two possible races: We
have a similar race between select_key() and using it for encryption,
but we also have a race here between select_key() and hardware
encryption when a key is removed.

The best solution I can come up with so far is to use RCU: when a key is
to be removed, we first remove the pointer from the appropriate places
(sdata->keys, sdata->default_key, sta->key) using rcu_assign_pointer()
and then synchronize_rcu(). Then, we can safely kfree() the key and
remove it from the hardware. There's a window here where the hardware
may still be using it for decryption, but we can't work around that
without having two hardware callbacks, one to disable the key for RX and
one to disable it for TX, and that's not worth the extra complexity.

When we add a key, we first need to upload it to the hardware and then,
using rcu_assign_pointer() again, link it into our structures.

In the code using keys (TX/RX paths) we use rcu_dereference() to get the
key and enclose the whole tx/rx section in a rcu_read_lock() ...
rcu_read_unlock() block. Because we've uploaded the key to hardware
before linking it into internal structures, we can guarantee that it is
valid once get to into tx().

Thoughts?

johannes

--=-AYqIdw5dKzQjtVGHEFOo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0/ww/ETPhpq3jKURArC1AKCSOzx8+sKBpW1Y8SMed4hzhsDoUgCfZ9y4
9JHlYdzmCYJFYBPUni+XP3c=
=lrnJ
-----END PGP SIGNATURE-----

--=-AYqIdw5dKzQjtVGHEFOo--

