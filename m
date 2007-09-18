Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32179 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbXIRWnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 18:43:22 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull mac80211-misc
Cc: Jiri Benc <jbenc@suse.cz>, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Date: Tue, 18 Sep 2007 18:42:43 -0400
Content-Type: multipart/signed;
  boundary="nextPart3906972.KxZq3BVO8e";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709181842.47419.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3906972.KxZq3BVO8e
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(sorry, resend, forgot to CC linux-wireless..)

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-misc.git
for these patches:

Johannes Berg (19):
      mac80211: allow drivers to indicate failed FCS/PLCP checksum
      mac80211: revamp interface and filter configuration
      mac80211: validate VLAN interfaces better
      mac80211: remove key threshold stuff
      mac80211: remove IEEE80211_CONF_SSID_HIDDEN
      mac80211: renumber and document the hardware flags
      mac80211: document a lot more
      wireless networking: move frame inline functions to generic header
      mac80211: yet more documentation
      mac80211: fix warnings introduced by the doc patches
      mac80211: remove tx info sw_retry_attempt member
      mac80211: print out wiphy name instead of master device
      mac80211: rename ieee80211_cfg.c to cfg.c
      mac80211: fix initialisation when built-in
      mac80211: remove crypto algorithm typedef
      mac80211: kill IE parse typedef
      mac80211: kill vlan_id
      mac80211: fix virtual interface locking
      mac80211: fix sparse warning

Michael Wu (3):
      mac80211: rename ieee80211_cfg.h to cfg.h
      rtl8187: Adapt to filter configuration API
      adm8211: Adapt to filter configuration API

As you can see, most of the updates this time are from Johannes and fix a=20
number of issues. Some of them are locking issues. One is an update to the=
=20
driver API which breaks every mac80211 driver. I have fixed the drivers whi=
ch=20
were in net-2.6.24 when I pulled a few days ago, but it appears that b43 an=
d=20
iwlwifi are going in too.. which is somewhat unfortunate timing. Johannes h=
as=20
an update for b43 but there isn't an api update for b43legacy or iwlwifi ye=
t.

I did not include the initialization when built-in fix for cfg80211 since I=
 do=20
not maintain that code, but that patch should be merged along with the=20
patches here.

I also did not include Johannes' patch adding himself to the maintainers li=
st,=20
but it seems like a good idea. However, I don't think that directing the=20
mac80211 git repo to wireless-dev is what we want to do. (so I'll post a=20
patch just adding Johannes later) Jiri Benc has been very busy so he has be=
en=20
unable to merge patches to his mac80211 tree, but I do think there's value =
in=20
having a separate mac80211 development tree (with both patches ready to go=
=20
upstream and patches that aren't). The mac80211-misc tree which I'm using=20
right now is just temporary for me to push some patches, however. I'll put=
=20
together a real mac80211 tree later.

Thanks,
=2DMichael Wu

--nextPart3906972.KxZq3BVO8e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG8FRnT3Oqt9AH4aERAhBvAKC+lsqmTRgxLc2Yurkwzk/o8+UXGwCfZOcK
WbE0+bBDi9FLgOprlFK/mwA=
=GmNL
-----END PGP SIGNATURE-----

--nextPart3906972.KxZq3BVO8e--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
