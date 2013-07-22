Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3GVMBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:01:16 -0400
Message-ID: <1374494473.14517.8.camel@jlt4.sipsolutions.net> (sfid-20130722_140119_234957_9D1B97F3)
Subject: pull-request: iwlwifi-fixes 2013-07-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Jul 2013 14:01:13 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BZbtl5oS9w4NzBloDOmS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BZbtl5oS9w4NzBloDOmS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another one for iwlwifi.

Here I have a fix for debugfs directory creation (causing a spurious
error message), two scanning fixes from David Spinadel, an LED fix and
two patches related to a BA session problem that eventually caused
firmware crashes from Emmanuel and a small BT fix for older devices as
well as a workaround for a firmware problem with APs with very small
beacon intervals from myself.

Let me know if there's any problem.

johannes

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092=
:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to a590ad411891de551e6de1b51ea635c0484148d6:

  iwlwifi: mvm: remove extra SSID from probe request (2013-07-16 13:55:15 +=
0300)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Fix VIF specific debugfs directory creation

David Spinadel (2):
      iwlwifi: mvm: fix bug in scan ssid
      iwlwifi: mvm: remove extra SSID from probe request

Emmanuel Grumbach (3):
      iwlwifi: mvm: unregister leds when registration failed
      iwlwifi: mvm: fix L2P BA ressources leak
      iwlwifi: mvm: track the number of Rx BA sessions

Johannes Berg (2):
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth
      iwlwifi: mvm: refuse connection to APs with BI < 16

 drivers/net/wireless/iwlwifi/dvm/main.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |  6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 23 ++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 10 ++++++----
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 23 +++++++++++++++++++++--
 6 files changed, 56 insertions(+), 9 deletions(-)


--=-BZbtl5oS9w4NzBloDOmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR7R8JAAoJEDBSmw7B7bqrPJ0P/35dN0zrxFQ48qKo/OhCMSPQ
PES9TizJdCk76pHF3Grzb3b+8KWgNOFEJcvkFuJYNUEVsFbQ+ftksKTW9pT9Jq4o
lad84ee42iewtFsTJa3f+8720E5EeYDnwmOm5Zs2oPpeLsZSmGZtLoeka+IirvGt
Eg2BMHgBgIpL1vMMNKJsVN9V1NW3dVzTNqu+2Siq4FiQRLTENW9KFJkpWQKE6hn8
BFTXIdV80iou8UYVcIN3nyO1qESwMo3m9yT+63Pdu+WjB88Jlm0/pfeNQ4ihTJ0b
Qp04coWN+GcrxAj7kASbSbxh4HABBG2ceA7XJvoQeLv8JKNvis4+LeYHFCDjOWyS
a1dirO/i1YXnH0aSZ/TCSuazsNyF4betOl/hFDZhvj3UwXGcOmEKWd+oZGVEVjdn
b8XO07gIVjwnRLjnBNM4LmO4EJ6CSKauVx19q4AMLggQFSukjmxfz0bMLUEzV/Y+
eZWHP1qGBDGUmofbny6Jlm0QUz4vsAyFyCSHBdZjAR/gFi0trLrU7oVh6EaStoNJ
N3X1Ft1Gn2iarOcWaZgDCDNz8rYWgcoh+vZ5/5YZVYrOHG8tgsWX6LuofweZ7YSL
8c4Zfj/SNwDPLWM0bvSBQ6Zg+upZHNSP+ImjX0QKXH2IdjVaBHOo1KSj+F0pnZkM
7ZOuJ51pOcmM/N2n4X5X
=MmTq
-----END PGP SIGNATURE-----

--=-BZbtl5oS9w4NzBloDOmS--

