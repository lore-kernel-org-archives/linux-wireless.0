Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXRYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:24:55 -0400
Message-ID: <1372094678.8439.24.camel@jlt4.sipsolutions.net> (sfid-20130624_192458_630453_0185A07B)
Subject: pull-request: mac80211-next 2013-06-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 19:24:38 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-h4rr0s1kRROlJMADPaDf"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h4rr0s1kRROlJMADPaDf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

As can be expected, I've accumulated a bunch more patches. Much of it is
already trending towards fixes rather than new features, but some of
those are there as well. I've removed the diffstat because git got
confused about it, presumably because I merged mac80211 to resolve a
conflict with the nl80211 fix. Anyway ...

Here we have a few memory leak fixes related to BSS struct handling
mostly from Ben, including a fix for a more theoretical problem
(associating while a BSS struct times out) from myself, a compilation
warning fix from Arend, mesh fixes from Thomas, tracking the beacon
bitrate (Alex), a bandwidth change event fix (Ilan) and some initial
work for 5/10 MHz channels from Simon.

Let me know if there are any issues.

johannes


The following changes since commit 795d855d56c6d172f50a974f603ba923ac93ee76=
:

  mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 6c7c4cbfd5f59c04a40af67ad72d14e19215ef36:

  mac80211: initialize power mode for mesh STAs (2013-06-24 15:59:20 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: track AP's beacon rate and give it to the driver

Antonio Quartulli (1):
      Revert "mac80211: in IBSS use the Auth frame to trigger STA reinserti=
on"

Arend van Spriel (1):
      cfg80211: fix compilation warning for cfg80211_leave_all()

Ben Greear (4):
      mac80211: Ensure tid_start_tx is protected by sta->lock
      wireless: Make sure __cfg80211_connect_result always puts bss
      wireless: add comments about bss refcounting
      wireless: check for dangling wdev->current_bss pointer

Ilan Peer (1):
      mac80211: Fix VHT bandwidth change event

Johannes Berg (6):
      mac80211: fix TX aggregation TID struct leak
      nl80211: fix attrbuf access race by allocating a separate one
      Merge remote-tracking branch 'mac80211/master' into HEAD
      nl80211: use small state buffer for wiphy_dump
      cfg80211: require passing BSS struct back to cfg80211_assoc_timeout
      cfg80211: hold BSS over association process

Simon Wunderlich (5):
      nl80211: use attributes to parse beacons
      nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
      nl80211: add rate flags for 5/10 Mhz channels
      mac80211: fix various components for the new 5 and 10 MHz widths
      mac80211: change IBSS channel state to chandef

Thomas Pedersen (3):
      mac80211: update mesh beacon on workqueue
      mac80211: allow self-protected frame tx without sta
      mac80211: initialize power mode for mesh STAs


--=-h4rr0s1kRROlJMADPaDf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRyIDWAAoJEDBSmw7B7bqreJ8QAJ30sORBYI8VnFqVwe6y0yhp
1mR9F876Q4gkTXSGYoY1vtXWK2MpYQNCZgz8hAmjW8ZD44lsel+YJdp4P3K4rycr
NzAdYf4Oc0vToOmq16pZT0mSfwmy+oxT/+WiWhYOCeLAYf234x1yuW6O3egOM6mB
MjRwsHnv3YtIG5cDt7klwtIvgf1fswVGQ6My+r/iKXabRatrpQJEiv9tFYC72t0K
bPban4vXwc+XB+ORvNPYCQq7FciZKK2ffDJUAWmTTGp6oLKogm73RBafQG6rE62u
HCkdFuSJrOKos9KTi9+xZTspsw6YlJNlIRwKK4b1ovRE+eDihIX6/0sCs2fRowk5
gnzPP7q2cOrLiEAGAUFeEMmPmpcONhvjK+XE2bA2UDhJBz2RFzu7hROb4KFX8s5C
X2OUVciBboUDVEg8CvGA73LSEG1n8iEO3KpbFE/VwDcb5UF08PT3K4t/wZ5fuMCT
ptqyT+ALxVJhsOq+0fYekZ4XDOOWV0uLVQZlP/malGxbNbvnI23LvJHNlZ4vp1Vv
jh0ocILi+szHHK2EJ5IWfsS2L/1q/X8rxgUovmBdWwl+9MxQ1d21SptWZv8jHtEW
w/rogHgmXjdqURGA2BeqFGXi/sMJU5NCEBwUDv7MxwCg1WA5Obbe3aniwNeoa9ZR
TafCYE2eAhwWDOtKEZpZ
=/kF/
-----END PGP SIGNATURE-----

--=-h4rr0s1kRROlJMADPaDf--

