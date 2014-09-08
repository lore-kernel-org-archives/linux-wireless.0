Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56946 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaIHQyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:54:24 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so3027197wib.6
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:54:22 -0700 (PDT)
Message-ID: <540DDF37.5030801@gmail.com> (sfid-20140908_185427_696959_0DDEA5A3)
Date: Mon, 08 Sep 2014 19:54:15 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi 2014-09-08
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EkJ6OMaCnfEHe2OC7m9LecQuOas4usu5j"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EkJ6OMaCnfEHe2OC7m9LecQuOas4usu5j
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi John,

I think I have caught up completely now - and because I had quite a bit t=
o cover this pull request is rather big for an -rc5. Sorry about that.

I re-enable scheduled scan on firmware that contain the fix for the bug t=
hat Linus reported.
A few trivial fixes: endianity issues, the same DTIM period fix that I di=
d in mac80211.
Eyal fixes a few issues we identified with EAPOL, we now send them just a=
s if they were management frames, this solves interrop issues.
Johannes has another set of trivial fixes, while Luca fixes the way we co=
nfigure the filters in the firmware. Last but not least, a new device is =
added by Oren.

The following changes since commit d88c8958dc13b4e4eb7fc57e3f06dc1c4abc7b=
1f:

  iwlwifi: bump firmware API version to 10 for 7000 and 8000 (2014-09-01 =
09:50:14 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to 2cddddc56a1179aa71b460ad616176c237d4a243:

  iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength (2014-09-0=
8 19:47:22 +0300)

----------------------------------------------------------------
Eliad Peller (1):
      iwlwifi: increase DEFAULT_MAX_TX_POWER

Emmanuel Grumbach (4):
      iwlwifi: mvm: enable scheduled scan on newest firmware
      iwlwifi: mvm: fix endianity issues with Smart Fifo commands
      iwlwiwi: mvm: use bss_conf->dtim_period instead of conf.ps_dtim_per=
iod
      iwlwifi: dvm: disable power save by default

Eyal Shapira (2):
      iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
      iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength

Johannes Berg (3):
      iwlwifi: mvm: BT Coex - remove shadowing variable
      iwlwifi: mvm: correctly handle PM/QoS changes from mac80211
      iwlwifi: mvm: BT Coex - always initialize smps_mode

Luciano Coelho (1):
      iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client=


Oren Givon (1):
      iwlwifi: add PCI IDs and add then new 3165 series

 drivers/net/wireless/iwlwifi/dvm/power.c       |  2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c        | 16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h      |  3 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c   |  4 +---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  9 +++------
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  3 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    | 10 +++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 25 ++++++++++++++------=
-----
 drivers/net/wireless/iwlwifi/mvm/power.c       |  5 ++---
 drivers/net/wireless/iwlwifi/mvm/rx.c          |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/sf.c          |  2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c          |  8 ++++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c        |  7 +++++++
 14 files changed, 65 insertions(+), 39 deletions(-)


--EkJ6OMaCnfEHe2OC7m9LecQuOas4usu5j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDd88AAoJEC0Llv5uNjIBib0P/0OAf5YAPslOdSs/T+iTmL3R
gNaZmZk/Y2sAV0FUTqwoa1GWFFWEbEqAK5lbuYVWsuyNZXKh6xRzOfNDInMdQOoa
JozHG65a5Tf4uuT+9oDCX8x4x/JvtTEHgXF/mrdVD9KTbQVk7EaRD+lnjSs6r91t
z1UpO4gywcFboJlL+OM3pRD/ywr/ayXtKiOW4CMxBtarw8zevC0Qvtvj+0G5luwD
pboWxXP/nT8UCrCa18koTKgcBUUOuGHx2/tQ+fbb+7249sEWkGo83+e6OUj+3kYW
eb/zJ3cWCHplYR63rl6ev23uS+ttsvB7oVtJ9vTWkGXdbOuahNt8j9lRVlLPPwma
b1y+UMX79gUxQfPFjjRZelZXDLu4vsV4369c4dJKpSbgcWmD0f+GXdENeVquDKOy
VV3J5UtpcWNaWJLdfVDfgVsiZAkpyebFpy/p8rjRFXvfKo16k1GMKTBMLubUSRuj
QbBcbabpgavLCx5sqO/1v42jfsEgNoWOS6ReBkYnwQ4DSq4MiJOZjvJTo5nDPLf6
zv16etUYr5Frywfny1MeJx3xsnrZEogIXYAj0bBSaL12kZM6qXlP3fTCUWSkHjNc
yCpZFk/zO+RZI8oZQszp0mJAtvlD4HESVYXtA7RQ62oZMYrSfO73kPWWpBRnMKo9
6UvOQbKgzuODE4AoHW+2
=Oxzk
-----END PGP SIGNATURE-----

--EkJ6OMaCnfEHe2OC7m9LecQuOas4usu5j--
