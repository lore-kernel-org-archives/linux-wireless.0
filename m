Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42322 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab2F0JIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 05:08:24 -0400
Received: by lbok6 with SMTP id k6so1644685lbo.32
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 02:08:20 -0700 (PDT)
Message-ID: <1340788097.1631.589.camel@cumari.coelho.fi> (sfid-20120627_110830_309465_AD0AD9CC)
Subject: pull request: TI wireless drivers 2012-06-27 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Wed, 27 Jun 2012 12:08:17 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5OcYaOhCBtaLloLM23QS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5OcYaOhCBtaLloLM23QS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This pull request replaces the one from 2012-06-24.  There were a couple
of bugs in our SDIO changes that were fixed by Eyal.  I also added two
of my own patches, one to deprecate unsupported (sample) HW and one to
fix a couple of bugs in the exit path of our probe function.

Here's what I wrote to the original pull request:

----8<----
One more pull request intended for 3.6.  Mostly about SDIO error
handling (by Ido) and correct handling and recovery during
suspend/resume.  Plus one new debugfs entry that allows easier FW
debugging, by Arkady.
----8<----

Please pull or let me know if there's any problem.

The following changes since commit 6bcfe67f9865fb51ec78fc9b09887375db7e08b5=
:

  ath9k_htc: Fix IDLE power save (2012-06-26 14:28:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to a572ac1a3d37440dc9daf69f9ad63243bef6893f:

  Merge branch 'wl12xx-next' into for-linville (2012-06-26 22:43:29 +0300)

----------------------------------------------------------------

Arik Nemtsov (6):
      wlcore: cancel suspend when recovery is pending
      wlcore: don't allow SDIO read/writes after failure
      wlcore: force recovery on resume if suspended without recovering
      wlcore: check Rx-filter functions in the suspend path
      wlcore: refactor threaded IRQ routine
      wlcore: prevent recovery in the middle of resume

Arkady Miasnikov (1):
      wlcore: access the firmware memory via debugfs

Eyal Shapira (3):
      wlcore: fix broken TX due to wrong queuing of recovery
      wlcore: queue recovery in case of bus errors during cmd_remove_peer
      wlcore: print stack trace in every recovery

Ido Yariv (11):
      wlcore: Fix sdio out-of-sync power state
      wlcore: Disable interrupts while recovering
      wlcore: Change read/write ops to return errors
      wlcore: Change raw io functions to return errors
      wlcore: Propagate errors from wlcore_raw_*_data functions
      wlcore: Propagate errors from wl1271_read
      wlcore: Propagate errors from wl1271_write
      wlcore: Propagate errors from wl1271_raw_read32
      wlcore: Propagate errors from wl1271_raw_write32
      wlcore: Propagate errors from wl1271_read_hwaddr
      wlcore: Force checking of io functions' return values

Luciano Coelho (3):
      wl18xx: deprecate PG1 support
      wlcore: fix some failure cases in wlcore_probe()
      Merge branch 'wl12xx-next' into for-linville

 drivers/net/wireless/ti/wl12xx/main.c     |  343 +++++++++++++++++++++++++=
+++++++++++++++++++----------------
 drivers/net/wireless/ti/wl18xx/acx.h      |   34 +++---
 drivers/net/wireless/ti/wl18xx/io.c       |   39 ++++---
 drivers/net/wireless/ti/wl18xx/io.h       |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  260 +++++++++++++++++++++++++=
+++-----------------
 drivers/net/wireless/ti/wlcore/boot.c     |   84 ++++++++++-----
 drivers/net/wireless/ti/wlcore/cmd.c      |   77 ++++++++++----
 drivers/net/wireless/ti/wlcore/debugfs.c  |  192 +++++++++++++++++++++++++=
+++++++++
 drivers/net/wireless/ti/wlcore/event.c    |   15 ++-
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   12 ++-
 drivers/net/wireless/ti/wlcore/io.c       |   55 +++++++---
 drivers/net/wireless/ti/wlcore/io.h       |  144 ++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/main.c     |  251 +++++++++++++++++++++++++=
++++++++-----------
 drivers/net/wireless/ti/wlcore/ps.c       |   14 ++-
 drivers/net/wireless/ti/wlcore/rx.c       |   37 +++++--
 drivers/net/wireless/ti/wlcore/rx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |   50 +++++----
 drivers/net/wireless/ti/wlcore/spi.c      |   14 ++-
 drivers/net/wireless/ti/wlcore/tx.c       |   76 ++++++++++----
 drivers/net/wireless/ti/wlcore/tx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   14 +--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 +-
 22 files changed, 1257 insertions(+), 475 deletions(-)


--=20
Cheers,
Luca.



--=-5OcYaOhCBtaLloLM23QS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP6s2CAAoJEKFHnKIaPMX6PbgQALzbMJ0+6ZRvvMQYU/ZkMkqE
kPj2hdDb0BdxdkkyM1mOownXIvC9iBnKBFowuFh4bRhrmqycIQ0YoUqqfwkTFnUp
Eoeb3kStS3hT9CPqgOA5fKuGgsaRggTjwzLnu63fuhxZd2IkqlepWFm7UPErOJOb
ZHsUbLB19TjF+AVfCvhJxaY7o4D7G7bSdlCwyAk2Ck4WLRSpS/9U3bqZ6fYBgp54
vPUU19D0d7RJSMYrimwImo4SEfv4KYQydpZX59FO3n5Tu7SPlubHkezFc25pRQjv
XlUG8eEgFQSPoIuZ/HloCFB/+r8nbHzlquvUJyAugBxQ1MrHdT/oXlY+K3BK+SPs
P4kQarUh6DvaR4Kz54Unz0v/lnbhwY3GHyZdqNJKnYVsxxE1LHLIdMIjDpsKhlAK
yf4awPHdWLgA0bOUSSwr3ThLNYv0RUE86tYI9Kd1LTpQxIKzVlWhabpcevKQZzjo
rWIVhMTMJF+ILctKU/vXBQAVWonHXOYQlvhQiEA7GvVCdUd5orvlKdqNOLQlXLS8
kj7+ZWV7h1bkwY5GD+Lzxss1CDoad5QJgWAVjfBgrMnFRzRlJ3wZme1akRxzK1+x
IoHFIjnlREIcqZ+NGyjZ4cZDjiMFOJjOcqIrC+T8fB+KY3c1ja9Ohdibh1rIdGsc
wDMf9XW0839nHOYbOesn
=nsWR
-----END PGP SIGNATURE-----

--=-5OcYaOhCBtaLloLM23QS--

