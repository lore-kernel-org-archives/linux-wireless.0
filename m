Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39527 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaLCHsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 02:48:33 -0500
Message-ID: <1417592902.2640.1.camel@sipsolutions.net> (sfid-20141203_084838_040850_BB512F1C)
Subject: pull-request: mac80211-next 2014-12-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 Dec 2014 08:48:22 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JE9C5gYSyOyUXx+BUjXA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JE9C5gYSyOyUXx+BUjXA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Yes, you were right - I must have missed that you merged my other pull
request. I hope you can still pull this in time for the next merge
window.

Unfortunately I can't send a signed tag because I forgot my yubikey at
home and thus can't upload anything to kernel.org. I hope you can accept
signed pgp email instead.

This time I have Felix's no-status rate control work, which will allow
drivers to work better with rate control even if they don't have perfect
status reporting. In addition to this, a small hwsim fix from Patrik,
one of the regulatory patches from Arik, and a number of cleanups and
fixes I did myself.

Of note is a patch where I disable CFG80211_WEXT so that compatibility
is no longer selectable - this is intended as a wake-up call for anyone
who's still using it, and is still easily worked around (it's a one-line
patch) before we fully remove the code as well in the future.

Let me know if there's any problem.

johannes



The following changes since commit 75769c80e381653994293b5aa5a8cfec50088f9f=
:

  mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check (2=
014-11-19 19:31:07 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git=20

for you to fetch changes up to f027c2aca0cf43e0f15fc8de8841f7b566163d94:

  mac80211: add ieee80211_tx_status_noskb (2014-11-28 15:01:51 +0100)

----------------------------------------------------------------
Arik Nemtsov (1):
      cfg80211: leave invalid channels on regdomain change

Felix Fietkau (9):
      mac80211: copy chandef from AP vif to VLANs
      mac80211: add more missing checks for VHT tx rates
      mac80211: minstrel_ht: move aggregation check to .get_rate()
      mac80211: add tx_status_noskb to rate_control_ops
      mac80211: minstrel: switch to .tx_status_noskb
      mac80211: minstrel_ht: switch to .tx_status_noskb
      mac80211: pass tx info to ieee80211_lost_packet instead of an skb
      mac0211: add a helper function for fixing up tx status rates
      mac80211: add ieee80211_tx_status_noskb

Johannes Berg (9):
      Revert "mac80211_hwsim: VHT add 160MHz width support"
      mac80211: disable 80+80/160 in VHT correctly
      cfg80211: remove pointless channel lookup in survey code
      mac80211: check if channels allow 80 MHz for VHT probe requests
      cfg80211: refactor the various CQM event sending code
      cfg80211: clean up beacon loss CQM event
      nl80211: don't crash sending invalid chandef
      cfg80211: make WEXT compatibility unselectable
      cfg80211: remove unneeded initialisations in nl80211_set_reg

Patrik Flykt (1):
      mac80211_hwsim: Send alpha2 only if non-zero

 drivers/net/wireless/mac80211_hwsim.c  |   5 +-
 drivers/net/wireless/ti/wlcore/event.c |   5 +-
 include/net/cfg80211.h                 |  63 ++++----
 include/net/mac80211.h                 |  32 ++++
 include/net/regulatory.h               |  12 ++
 include/uapi/linux/nl80211.h           |   7 +-
 net/mac80211/chan.c                    |  23 ++-
 net/mac80211/iface.c                   |   1 +
 net/mac80211/mlme.c                    |  24 ++-
 net/mac80211/rate.c                    |   3 +-
 net/mac80211/rate.h                    |  24 ++-
 net/mac80211/rc80211_minstrel.c        |   5 +-
 net/mac80211/rc80211_minstrel_ht.c     |  15 +-
 net/mac80211/status.c                  | 113 +++++++++++---
 net/mac80211/trace.h                   |   6 +
 net/mac80211/tx.c                      |   2 +-
 net/mac80211/util.c                    |  11 +-
 net/wireless/Kconfig                   |   2 +-
 net/wireless/core.c                    |  14 ++
 net/wireless/nl80211.c                 | 260 ++++++++++++++++-------------=
----
 net/wireless/reg.c                     | 107 +++++++++++++-
 21 files changed, 517 insertions(+), 217 deletions(-)


--=-JE9C5gYSyOyUXx+BUjXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJUfsBJAAoJEDBSmw7B7bqrp7AP+QGyeuJzmWeUTuaGBvOktg85
HYxlatgexml5+mgXhKhb4F2dbxWaIUD3CopsjKm63fgLpYXDny/VckiTfFYvmX+i
1jqLFOiNikk119zzwltr5c/qQWBvHz/99yFwbuwpSNJytZDt8CCSOTvPKyIx9fB8
GMxqD1u3frcyXFdF+jdQ1fpT2KPfCkHwkLFt7EURKvEekZB8RtY6cQJjG2rtydug
Z1qKAdBZu8kIHpQvMSJEqRm8IpSRSqPBM+hQNYYVIUXLNz0Uc8SAQy5otN5ijvbu
EBhhefsxSjUqbFH9HIKOtWHtPubDvFsLL+xk5SDPwXibje9ZhqI33pfkAQdcGwct
R9ncZFTVhJuKqy/GrduooO0GI2iT19LZXDrz+MDU0OTUMLXjJuw65Q+83fNxLTFg
GGHB7QW2ROl/6yHSw6WUk6tBOV8yA0iAZzGhF9O5rSG+lEtJBQF+u1M36zShD0WE
QIWWud+DLUdJ3NmxirnLBSrk0H5NIQ6QVDOOKJyu2fINnE3p4n2IKFl29ZD911BR
lOKq331Dz7UxMPc3V5rgjZaIVuag+93oS2IGXGxAVuce25f08IC7LhAnaZ0wnQ3w
DSHsbztp3DZCjbppC7v8rTroOMnT88b5Y/7AlDEbfimtm2toeZXQs0znHKn2Yj9x
UH+sriDnoX1afxWKZmlf
=7bVE
-----END PGP SIGNATURE-----

--=-JE9C5gYSyOyUXx+BUjXA--

