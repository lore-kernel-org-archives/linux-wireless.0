Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYCQLkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 07:40:15 -0400
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request
	a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com> (sfid-20080317_000435_916196_E071C229)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 (sfid-20080317_000435_916196_E071C229)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r6N31VHNkqJPuUj7eBkf"
Date: Mon, 17 Mar 2008 12:39:58 +0100
Message-Id: <1205753998.1614.34.camel@johannes.berg> (sfid-20080317_114023_786677_7B6D058B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r6N31VHNkqJPuUj7eBkf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> iwlwifi firmware also derive phase2 in RX path by itself since this is
> not really possible to do in host level.=20

Right. I just wonder why then it needs the host to derive the phase 2
key for TX, that seems pretty strange. Seems to me a bit like a "what
can we do" design decision rather than "what makes sense".

> However in case of non
> matching iv32 such as wraparound it passes packet up unencrypted. =20

That makes sense.

> Therefore HW decryption
> have to be always backed up by SW one.

Obviously, yes.

> Wraparound of Iv32 is reliable only if decryption of a the packet that
> triggers it is correct. If this is not done and phase1 is advanced by
> mistake it  breaks traffic till the next wraparound actually it will
> effectively cause  disconnection.

Good point. But let's not overload set_key() for it this way. This way,
the driver needs to look up the key etc. and the semantics get quite
mangled up. Also, your approach doesn't work for Broadcom hardware that
only needs phase 1 keys for both RX and TX.

How about instead we add a new "update_tkip_key()" callback that takes
exactly the required parameters? It should also give the
hardware-key-index so that the driver has less work to do.

johannes

--=-r6N31VHNkqJPuUj7eBkf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR95YjaVg1VMiehFYAQKVzw//dOagd4m6IO3DueP10u29BPz/tgzgzU0r
MwZxkLkFu3aLvbIY3cZrhSPR4rtgj1LtFjHsEcWlSI9Qk76fcWGnPHON4ce87CvB
RzK50wxXYtP/+UoQ6N/8EQlLTmJjJ4HtHZecjIL6sZ67WnLsr/rg7OlVLJhLt/4f
Z4SeG19tJs+hu3wcuHqXsVmj1cWWsUEx810sZsPyJ7P9NrwVPFvXzYiTk95ZW+E5
yuYzAayQJaD/TJZhdjKeypTvVVGnSDUSij5JGlrywfP2bBHV+YbVH3r/uEB/IJO8
8+HSQMIjzhWXKq6G+XqOKbXCZ7piSu+5sM7UUGk+z7NCMcaPmSzCdfMJFBsgZJ4/
rMvNCNL+d7zrpC0MLI0c4pLItRZFBzhxTUkwLusIYZZc/F8zEneq/6w8efNvHmZN
c56YSLnQ8WAszkOAjdQVFs/bzOvONisFX8+4ArHnkIWO8KudpyRcFmI4VN1P55pe
NWAVGLh0UjyTnJM3wq3VjsPyX7PR1QNmvoud25qGVll1yJMgj8PPzn3fi6WB8Qvo
v/Ty5Zqe3hpxGcwmxOQisuvRLyySgckOd8Y+06i2afgNcFHJKmqQftr3a0SZ2Oc6
mLH/QK34TJWNA/U2YqkI3hbNOyjuPPede4SI6/CqXSNrMX7ErzA6inAk6ow9gKdc
T9W+2plD0eQ=
=RAlQ
-----END PGP SIGNATURE-----

--=-r6N31VHNkqJPuUj7eBkf--

