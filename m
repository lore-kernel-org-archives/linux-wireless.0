Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYCQNNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 09:13:32 -0400
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request
	a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com> (sfid-20080317_130333_541187_B4B8043F)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 <1205753998.1614.34.camel@johannes.berg>
	 <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com>
	 (sfid-20080317_130333_541187_B4B8043F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BzxVnyBvonxtIU1aH7wj"
Date: Mon, 17 Mar 2008 14:13:19 +0100
Message-Id: <1205759599.1614.69.camel@johannes.berg> (sfid-20080317_131339_164085_57D71961)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BzxVnyBvonxtIU1aH7wj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> >  Good point. But let's not overload set_key() for it this way. This way=
,
> >  the driver needs to look up the key etc. and the semantics get quite
> >  mangled up. Also, your approach doesn't work for Broadcom hardware tha=
t
> >  only needs phase 1 keys for both RX and TX.
>=20
> Can you elaborate why it doesn't cover bcom case?

I don't quite understand the phase 1 key derivation and why it is done
for each DMA queue, but I think this is not too important as
non-matching will just be done in software. However, bcom firmware wants
to have just the phase 1 key, and as far as I can tell the driver can't,
even with your patches, obtain a phase 1 key for TX.

> >  How about instead we add a new "update_tkip_key()" callback that takes
> >  exactly the required parameters? It should also give the
> >  hardware-key-index so that the driver has less work to do.
>=20
> It's viable but I actually prefer not opening too many interfaces.
> Please give me some more detailed sketch how do you see that and we
> sure get to some acceptable solution.

Yes, I would prefer not having that many interfaces as well, but I don't
think shoehorning it into the set_key() callback is a good idea because
 (a) you add fields to the key conf structure that are only used for
     the tkip stuff and only valid in some calls
 (b) the patch breaks the set_key() interface's symmetry

A new callback update_tkip_key could look like this:

void update_tkip_phase1key(hw, keyconf, iv32, p1key)

The =EF=BB=BFIEEE80211_KEY_FLAG_TKIP_PHASE1_VALID flag would go away, and t=
he
new callback would be invoked right from where the phase1 key is
calculated.

I'm not exactly sure whether one needs a phase1 key for RX and one for
TX right now, but if so a direction flag should be added?

johannes

--=-BzxVnyBvonxtIU1aH7wj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR95ubqVg1VMiehFYAQJpeA//eNPWL1BY+DvkU1sTv2J8HGig0P8wOuW4
Kw73EJOFzROJyd8zaLeDdiUepVYgakeie3Bo7AjKY0wRZ7yAxGfLqZoJUb8gbhXp
/MNwnQOfR6o1g4noqe07vvsL2zgavzys3gBCh+7o4Yv1wANQRPppVBcWYVV8HSbx
2A05RwjZxYgzXJ5I+Tmohn+FXmTmPn9d0k9u9iEo/YKAC2IdiYa3pnCPtoumEvkY
m/m5X3vqR0R9/LKiXk+grI2IBFT17BuJeNT1xITpWm8/gC2jqMxxbpPpkJED9mOJ
+5yEBqILJiuau2Q8rOSbxmt0Lz5zHiJ96JLH5pdQaZtCjLSwS8/cl4SkUeY0vHCw
HXcieFdWvmliX7/cfCr04XhtU+BobJym5nTYfpolCIQg2CGw4wfA8ZSbBkfkCfCi
GET8gqSjG9vt7wvNSw99ONfzAPJHptDQxXcXH3+kaGrck5isSZAdfmS6dZUV51pW
DOr67bhneNLSBt4PWROKfJcp9eahMU3i2Qhq28eTDoc3f4M/bnh+AjA9OK8mu0Wj
n5qN7/d0KARoH4EV4c4bKZ91ZC4KxcBSRWYu5kyZ4LMQQLG1vOkFvuGzeXXM2LCK
8mEQ+DIcZjyMJCCvU5QKx3J4xec735RRrNyDrgxoF09Kv7FkcyPNXuxmNRPo9To7
iM4jslknwzM=
=qyXH
-----END PGP SIGNATURE-----

--=-BzxVnyBvonxtIU1aH7wj--

