Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXJ1Rxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 13:53:34 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <20071028173610.GM4936@jm.kir.nu>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
	 <1193320140.5542.11.camel@localhost.localdomain>
	 <1193320661.14136.10.camel@johannes.berg>
	 <1193548708.7779.10.camel@localhost.localdomain>
	 <1193567294.3966.6.camel@johannes.berg>  <20071028173610.GM4936@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JgvTaNSOKlcrgZZLBbq8"
Date: Sun, 28 Oct 2007 18:54:45 +0100
Message-Id: <1193594085.5197.20.camel@johannes.berg> (sfid-20071028_175340_092971_9D727259)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JgvTaNSOKlcrgZZLBbq8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> While there is indeed a bug in wpa_supplicant 0.5.x, I think that
> another issue here is in mac80211 trying to do something that it was not
> supposed to do, i.e., to figure out whether privacy is enabled or not
> based on keymgmt value. This is decided in the supplicant and the value
> is configured with IW_AUTH_PRIVACY_INVOKED to the kernel. In other
> words, mac80211 should follow this parameter and not IW_AUTH_KEY_MGMT.

Hmm. Is there a good explanation of all these values? I still haven't
understood what all the IW_AUTH_* means. I'm fairly sure though that
this particular instance hasn't changed in terms of behaviour since the
original devicescape code (not that this means it's bug-free, of course)

> I merged the fix into 0.5.x branch, so it should be included in the next
> release. This was fixed as part of a more generic cleanup and it did not
> end up being flagged as a bug fix and consequently, not merged into
> 0.5.x branch.

Thanks.

johannes

--=-JgvTaNSOKlcrgZZLBbq8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyTM46Vg1VMiehFYAQIo7A//QcylUJZHjU5+dbAz/w87j5CaHKLmpWll
H8SnWxGMmvikp4Fqx9rZB8pCwAkPjQHQom2j7/hHt20Zbfpm9pwIE3mN0BvoNYdL
Ow8MTf1fT2s4rsWlKyUIAFJi6RrG5lzqtsMl5IG30qwr38GVPtoCnJbTu5zXJovU
0B8jfX2WNE/71M0YvNHYkdhGOO6JR/S3FfviEjufBaATv3y6D5xvTDxXhcKTZG3G
aoVcOVsmIzUU/mcHuetAamlWf6FvtL/Bg1lluYYGJH1c2UJDrDhYlDKHu4AwE8mp
fnYThIHuGmsAPfxCA7FTBAdAtTdAd7yLufNWo8fDQGFLMyij0A6XfJ5ziOMe8rnn
iANBvdc9UaKKfXEH71da+1kGNMbjoufVlcIBl95L+yuXJiN5PqZqc1SZJkvyLACu
4bvXoYZTzU4YSGq1CISLK2jAIEEhiJ3JaLcJFfkB2X3QcRhPVMd7Ma41dpXdeiFW
tL9g06zGUzqQFnDcMJ6trzhnylnk1jwZjNrTr44KYF8EPJV+yQGwPhiiBmTZwCF2
MkmwajGddm8/bO4j8KJ9Q/VMSbAe2TAjb8y4PWkjr7h5LHjs5WumyxDXbjp/k2Zo
YlnfBR5PCug17QFLQfUz69hEPuHCWKzddP+WdXQKsme3e6TkekS7woqegXA37LTh
i4zFincWcso=
=nlXi
-----END PGP SIGNATURE-----

--=-JgvTaNSOKlcrgZZLBbq8--

