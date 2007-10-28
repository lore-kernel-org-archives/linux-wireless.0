Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:24211 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbXJ1IAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 04:00:50 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: reorder association debug output
Date: Sun, 28 Oct 2007 03:57:07 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org
References: <11934326793639-git-send-email-linville@tuxdriver.com> <20071027125025.GC16222@tuxdriver.com> <1193489935.15686.17.camel@johannes.berg>
In-Reply-To: <1193489935.15686.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3709499.LZN1AjHDuE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710280357.21498.flamingice@sourmilk.net> (sfid-20071028_080054_985448_07DEB5FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3709499.LZN1AjHDuE
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 October 2007 08:58:55 Johannes Berg wrote:
> Oops, I stand corrected. Still I don't think that the message patch is
> worth doing in stable, although the regression potential is pretty much
> nil.
>
According to the stable kernel rules, this fix doesn't look appropriate.=20
(though it is practically zero risk) Also, the sta_bss_list changes do not=
=20
qualify due to "It cannot be bigger than 100 lines, with context". The=20
radiotap get_unaligned patch doesn't qualify - it's not important enough. T=
he=20
IE parsing fix is also too big. I'm not certain that the SSID scanning patc=
h=20
qualifies either.. from the patch's POV, it's adding a feature. So, the way=
=20
I'm reading things, no mac80211 patches seem to qualify according to stable=
=20
kernel rules.

=46WIW, I think=20
[PATCH] mac80211: reorder association debug output
[PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl (plus fix)
[PATCH] mac80211: make ieee802_11_parse_elems return void
do enough good that they should be pushed to stable. The IE parsing fix is =
a=20
little big but it's trivial, reordering the debug output is safe and reduce=
s=20
confusion, and the SSID scanning patch makes it easier to connect to hidden=
=20
APs. In addition, the SSID len match patch should also be pushed to stable=
=20
since I think it's a one line, fairly obvious patch that fixes a problem in=
=20
auto AP selection that can prevent association.

=2DMichael Wu

--nextPart3709499.LZN1AjHDuE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHJEDhT3Oqt9AH4aERAn4ZAJ46Wl3tR+oV3JU/EvNSbqD3KB4n5gCfQsWD
mPhyx7/TfU3oRKB1utNDOHs=
=96E6
-----END PGP SIGNATURE-----

--nextPart3709499.LZN1AjHDuE--
