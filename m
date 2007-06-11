Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081AbXFLHFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 03:05:38 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070611085950.GA5540@mail.intel.com>
References: <20070611085950.GA5540@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jh2VHo/fdIw19KNVKdQC"
Date: Mon, 11 Jun 2007 20:01:47 +0200
Message-Id: <1181584907.29767.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jh2VHo/fdIw19KNVKdQC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Yi,

In sta_process_dls_req, you currently always accept DLS. I'm not sure
how well power save mode works in mac80211 (probably not at all, someone
versed in 802.11 should probably look at it some time soon), but once
DLS is set up power saving must be disabled by the DLS peer. This,
however, possibly leads to battery lifetime diminishing, so always
accepting the direct link might not be desirable. Any thoughts?

Should we have user-space controlled list of DLS possible DLS peers? Or
call out to userspace via nl80211 to make a decision? The list would be
easy by simply adding a sta_info for a possible DLS peer, callout also
shouldn't be too hard by sending a message to some QoS nl80211 multicast
group and possibly not responding to the DLS request at all when our
userspace doesn't accept it (that way it'll just time out on the other
side).

johannes

--=-Jh2VHo/fdIw19KNVKdQC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbY4K/ETPhpq3jKURAro2AKC4UsT7FzMEEXfx42RgrokY6wGpBgCeMIpr
fbOxLXdI994xIlDnXMc7qoc=
=eRLq
-----END PGP SIGNATURE-----

--=-Jh2VHo/fdIw19KNVKdQC--

