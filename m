Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2KZOwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:52:46 -0500
Message-ID: <1353941587.9488.37.camel@jlt4.sipsolutions.net> (sfid-20121126_155254_304828_66C19566)
Subject: pull-request: mac80211-next 2012-11-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 15:53:07 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ids6+la6YvfcFDeueS7h"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ids6+la6YvfcFDeueS7h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

After deliberating on it for a bit I decided to pull the initial VHT
support patches into the tree now so we don't have to deal with two
different mac80211 channel context APIs.

Please pull (see below) to get the following changes:
 * a fix & a debug aid in IBSS from Antonio,
 * mesh cleanups from Marco,
 * a few bugfixes for some of my previous patches from Arend and myself,
 * and the big initial VHT support patchset

johannes



The following changes since commit 77d2ece6fde80631193054edc9c9a3edad519565=
:

  mac80211: Add debugfs callbacks for station addition/removal (2012-11-21 =
11:46:25 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to ec816087e8978b74c1bd5fae0e335dd97d964e9f:

  cfg80211: fix some tracing output issues (2012-11-26 12:48:17 +0100)

----------------------------------------------------------------
Antonio Quartulli (2):
      mac80211: in ADHOC don't update last_rx if sta is not authorized
      mac80211: in ADHOC print debug message for every Auth message

Arend van Spriel (1):
      cfg80211: change function signature of cfg80211_get_p2p_attr()

Johannes Berg (18):
      mac80211: fix radiotap vendor area skipping
      mac80211: fix RX chains configuration
      mac80211: rename IEEE80211_STA_DISABLE_11N to HT
      mac80211: disable HT advertising unless AP supports it
      cfg80211: use DS or HT operation IEs to determine BSS channel
      mac80211: fix managed mode channel flags handling
      cfg80211: remove remain-on-channel channel type
      nl80211: add documentation for channel type
      cfg80211: pass a channel definition struct
      nl80211/cfg80211: support VHT channel configuration
      mac80211: convert to channel definition struct
      nl80211/cfg80211: add VHT MCS support
      mac80211: support drivers reporting VHT RX
      mac80211: support VHT rates in TX info
      wireless: add definitions for VHT MCS support
      mac80211_hwsim: advertise VHT support
      mac80211_hwsim: remove printing scan config
      cfg80211: fix some tracing output issues

Marco Porsch (3):
      mac80211: move Mesh Capability field definition to ieee80211.h
      mac80211: refactor ieee80211_set_qos_hdr
      mac80211: remove mesh config macros from mesh_plink.c

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  27 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   5 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  11 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h             |   1 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   2 -
 drivers/net/wireless/libertas/cfg.c                |  24 +-
 drivers/net/wireless/mac80211_hwsim.c              |  68 ++--
 drivers/net/wireless/mwifiex/cfg80211.c            |  46 +--
 drivers/net/wireless/mwifiex/main.h                |   2 -
 drivers/net/wireless/mwifiex/sta_event.c           |   1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   3 +-
 drivers/net/wireless/orinoco/cfg.c                 |  11 +-
 drivers/net/wireless/rndis_wlan.c                  |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   9 +-
 include/linux/ieee80211.h                          |  38 ++
 include/net/cfg80211.h                             | 170 ++++++---
 include/net/mac80211.h                             |  66 +++-
 include/uapi/linux/nl80211.h                       |  96 ++++-
 net/mac80211/cfg.c                                 | 137 +++----
 net/mac80211/chan.c                                | 128 ++-----
 net/mac80211/debugfs_netdev.c                      |   2 -
 net/mac80211/driver-ops.h                          |   5 +-
 net/mac80211/ibss.c                                |  46 ++-
 net/mac80211/ieee80211_i.h                         |  22 +-
 net/mac80211/iface.c                               |   5 +-
 net/mac80211/main.c                                |  23 +-
 net/mac80211/mesh.c                                |  36 +-
 net/mac80211/mesh.h                                |  14 -
 net/mac80211/mesh_plink.c                          |  47 +--
 net/mac80211/mesh_sync.c                           |   2 +-
 net/mac80211/mlme.c                                |  94 ++---
 net/mac80211/offchannel.c                          |   8 +-
 net/mac80211/rate.c                                |   5 +-
 net/mac80211/rate.h                                |   2 +-
 net/mac80211/rx.c                                  |  41 +-
 net/mac80211/scan.c                                |   9 +-
 net/mac80211/sta_info.c                            |   2 +-
 net/mac80211/sta_info.h                            |   8 +-
 net/mac80211/trace.h                               |  29 +-
 net/mac80211/tx.c                                  |  20 +-
 net/mac80211/util.c                                |  59 ++-
 net/mac80211/wme.c                                 |  40 +-
 net/wireless/chan.c                                | 280 +++++++++++---
 net/wireless/core.h                                |  23 +-
 net/wireless/ibss.c                                |  27 +-
 net/wireless/mesh.c                                |  49 +--
 net/wireless/mlme.c                                |  36 +-
 net/wireless/nl80211.c                             | 415 ++++++++++++-----=
----
 net/wireless/nl80211.h                             |   8 +-
 net/wireless/rdev-ops.h                            |  42 +--
 net/wireless/scan.c                                |  45 ++-
 net/wireless/trace.h                               | 295 +++++++--------
 net/wireless/util.c                                |  79 +++-
 net/wireless/wext-compat.c                         |  28 +-
 net/wireless/wext-sme.c                            |  11 +-
 55 files changed, 1642 insertions(+), 1062 deletions(-)


--=-ids6+la6YvfcFDeueS7h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQs4JTAAoJEDBSmw7B7bqr1icP+wWfjWe5Byf/ZeuATcG8ibs8
0X7N1azXCfkQBbgunYuwKYWBTPiCsDrr2lcd7MyO+B5cR3uv9CR4w4F8K1liBWBT
qrDBSEyNZ8fDcaXxHDEbw0pz6fhyOFSevooU944cbKxcgpPVtzk4hjJnFywJ61ib
HZFbDJnyV0+FTmmF3vc4oAv0RO5TUMy19SNiGzw20pfAhDVRZZbkKHiKYCeQEKl9
RojIx7ZC7jrx4r5LAbKt6mnMuPrX3skdIJyXAOpeowWirVzK0ueV6aoKB5/NPcA4
y8TkdVx19Cav3yX/HS/+2Gl3v8H3zAXbYBXaOlTxP2xoHCaylK1zT8kqhk/OK7wg
sz2DRiUmIGhH/dQsVGqwKKw5sJ9iJ83ffiFbC2aCv7s8zGaMyKH/KEPiyyuIFPai
s5JZ0IvoPL4W9mmtw2t2pjoMK2bN2DQMjbeoXqgsw6X2NdHMxdLXmOCt5Phl3Gvw
ivjRLnruysyNFeN8QyCGjYsye6EHV4tGVHOdRv3jWypdxGsNuEK0s0AyS/i3P4Pd
N1vQxcxlqQsR+Xv/YzUYJTmVuF6WHYhc70q84h3wHF1DWfaOtmqm2NY8KXWRCxMW
hfxoRJRhPH36hOCbTt7DKX62YMkwSQRRJTTei0vXb0JLjMbCElHF7BYH+U/KNZMd
VIPjBtLKkwaYrpiMqDSj
=4kcd
-----END PGP SIGNATURE-----

--=-ids6+la6YvfcFDeueS7h--

