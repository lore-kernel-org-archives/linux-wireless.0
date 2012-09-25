Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2IYHwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 03:52:30 -0400
Message-ID: <1348559583.10041.24.camel@jlt4.sipsolutions.net> (sfid-20120925_095234_140765_52304BE6)
Subject: pull-request: mac80211-next 2012-09-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Sep 2012 09:53:03 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-p264+1dSzun78pwbsQPs"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p264+1dSzun78pwbsQPs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

So I've collected a few more features, cleanups and fixes. Nothing
notable really, except maybe the full-MAC AP mode notification support
and the delBA suppression patches.

Please pull & let me know if there are any issues. If this doesn't make
it, I'll split it up, the only things that need to go into 3.7 still in
that case would the debugfs and maybe the auth message fix.

johannes



The following changes since commit 9385d04f2872057a2029901190391fe192b18693=
:

  mac80211: allow re-open the blocked peer link in mesh (2012-09-14 14:25:1=
6 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 64629b9d412544b0ed744405944fd6edf79d7e0d:

  cfg80211: Fix regulatory check for 60GHz band frequencies (2012-09-25 09:=
41:14 +0200)

----------------------------------------------------------------
Alan Cox (1):
      wireless: remove unreachable code

Arend van Spriel (1):
      cfg80211: remove obsolete comment for .sched_scan_stop() callback

Johannes Berg (5):
      mac80211: make reset debugfs depend on CONFIG_PM
      cfg80211: constify name parameter to add_virtual_intf
      mac80211: don't send delBA before disassoc
      mac80211: don't send delBA when removing stations
      mac80211: don't send delBA on addBA failure

Pandiyarajan Pitchaimuthu (1):
      cfg80211/nl80211: Notify connection request failure in AP mode

Sylvain Roger Rieunier (1):
      mac80211: fix IBSS auth TX debug message

Vitaly Wool (1):
      rfkill: prevent unnecessary event generation

Vladimir Kondratiev (1):
      cfg80211: Fix regulatory check for 60GHz band frequencies

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 +--
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |    2 +-
 drivers/net/wireless/mwifiex/main.h        |    2 +-
 include/linux/nl80211.h                    |   24 +++++++++++++++++
 include/net/cfg80211.h                     |   25 +++++++++++++++---
 net/mac80211/agg-tx.c                      |    2 +-
 net/mac80211/cfg.c                         |    3 ++-
 net/mac80211/debugfs.c                     |    4 +++
 net/mac80211/ibss.c                        |    2 +-
 net/mac80211/mlme.c                        |    2 +-
 net/mac80211/sta_info.c                    |    2 +-
 net/rfkill/core.c                          |    8 +++++-
 net/wireless/mlme.c                        |   11 ++++++++
 net/wireless/nl80211.c                     |   34 ++++++++++++++++++++++++
 net/wireless/nl80211.h                     |    5 ++++
 net/wireless/reg.c                         |   39 +++++++++++-------------=
----
 17 files changed, 132 insertions(+), 39 deletions(-)


--=-p264+1dSzun78pwbsQPs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQYWLfAAoJEDBSmw7B7bqrJMcP/0QNRgIgJSxpPaC2UKr/RbN2
a3lI4ZjNIfg7eW5XXBW5ZLkJOVe5Q6U7uJmYd5OUyWAi7BHZ6wEIZLaiTzCoFqZd
5nkFaT4T4SogA1bPy9LwUIY3zIK9RzZRC2ArAxD64S03Ba6WKf205P8r9b5YojtN
3USVa8vo9RdjSLtBSKafIzE37U+JZcSk9tGHb9kht/6blYNZnBYmk+YriO8FdfoB
DzmPxMYGJ4o6+Gld29Rtelhh/gdTD8ryS9cT6s3VsOB66lXwm77A/IUlJTIEmimP
OkaNG7zABMXd137qvonJrpPzeuKti2z8eE19CeVGV5rqZme8cM5dYDs6O0Cc3ggX
s7BZNVddyB4fzbh0gYzOa0FVJtweRmn36S2MmIaK0xt6eNdxtSk6XHu+mZECjLHw
WltATvEFLkOj8n1iF4TJcuXV3BLZ7V1D35F6oJAAZk2ugsQBJf+X9MOUwhbGbzTS
34GDy+rBsLgHNt7mkxlKsA69brYToK09TWwoe1VEJt/7gm/GBxtHONbKO687qeyy
Sk+4nAKxdM5UM0aiNtNpSPJ3cV54BWxEvALGbhtAW8rH3hqZGyTX4rTXfLRnpUa0
AKw3z9qtJMsGBrn/byoQSyy3qxpB7bdXpkY0ozxBk+RcTtukd7ozfnE+woy3+JMg
VU1AJByL5rfT9Wc2MsNG
=UcNw
-----END PGP SIGNATURE-----

--=-p264+1dSzun78pwbsQPs--

