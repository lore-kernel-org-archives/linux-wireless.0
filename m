Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47964 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753216AbdK2IQD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 03:16:03 -0500
Message-ID: <1511943359.4827.18.camel@coelho.fi> (sfid-20171129_091607_663405_4AEC58C3)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Wed, 29 Nov 2017 10:15:59 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-f/kx17T7SJw/Y2v32yys"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-11-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f/kx17T7SJw/Y2v32yys
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is my first batch of patches intended for v4.16.  As I mentioned
in the patchset thread, I removed patch 08/11 because it was broken.=20
More details about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit fdd0bd88ceaecf729db103ac8836af5805dd2dc1=
:

  brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-11-29

for you to fetch changes up to 2f7a3863191afc2c132854b7ffb1b867b4b9e8be:

  iwlwifi: rename the temporary name of A000 to the official 22000 (2017-11=
-28 16:39:57 +0200)

----------------------------------------------------------------
First batch of iwlwifi updates for v4.16

* Rename the temporary name A000 to 22000;
* Change in the way we print the firmware version;
* Remove some unused code;
* Other small improvements;

----------------------------------------------------------------
Emmanuel Grumbach (4):
      iwlwifi: mvm: rs: don't override the rate history in the search cycle
      iwlwifi: mvm: revert support new Coex firmware API
      iwlwifi: print the version number of the firmware in hex
      iwlwifi: fix the ALIVE notification layout

Johannes Berg (2):
      iwlwifi: mvm: remove TCP wakeup support
      iwlwifi: mvm: remove superfluous flush_work()

Liad Kaufman (2):
      iwlwifi: mvm: support MGMT frames in compressed BA
      iwlwifi: dbg: allow wrt collection before ALIVE

Luca Coelho (1):
      iwlwifi: rename the temporary name of A000 to the official 22000

Sara Sharon (1):
      iwlwifi: mvm: check for short GI only for OFDM

 drivers/net/wireless/intel/iwlwifi/Makefile          |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       | 216 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c        | 216 ---------------=
---------------------------------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h     |  30 -------------
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |  15 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   3 --
 drivers/net/wireless/intel/iwlwifi/fw/smem.c         |   8 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |  20 ++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  11 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h          |  12 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c        |  33 +++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          | 232 +--------------=
---------------------------------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  12 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |   6 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  30 +++----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   8 +---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |  10 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c  |   6 ---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  12 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  36 +++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |   4 +-
 28 files changed, 323 insertions(+), 622 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/22000.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/a000.c
--=-f/kx17T7SJw/Y2v32yys
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAloebL8ACgkQoUecoho8
xfpTog/+M342D6+CB0QJyw2EnuSIrzMS2W26zcv3Pin40KYTIAouqKZL8rr6NL3E
GP8ipA7h1XfPC6CYDSxNCMMGuO9sQ+J1VwDlamz47u+Sucg+n3tuPzbuw9iftCu0
exul+uLq/Ns+1ObiLNXSTOZbB3xu9oSycCdTpNxZiLkCgDQWG3ZFDWoi9aHCLNzt
lRX1CXIIcXCqNOO7cMeYZBS4SxGbwZHf3VDkVb88g6Qm9ghHLlQ79EmlWQVZ/pai
ddItUHNyr7ccZjJVIcUQrKqiKnRk49zYe+mQg36+IbdyIkBmiVgA8603vv/3rHG6
2qaEc5fdFrgVnRXYluGH88fdEagECAcXbLsebkp7Rx/boZ2IuYnlcj7mF3PRnz/Y
cbPDvZOheBspJLY/nJx1gvZZYPTQ3kIyn1vBCgsF0QiqSKGeyr9VCZoOCGsysRkS
o/N1r6DVUuzHRCLBJoUnF/bTk02qcR8xJXJtKMvnaD7unD9ytce7Ox4JG+kwpts6
uK+yRi8dxp60xQT8pxhMQ0D4y31ch4hTaEvSvhREj9qDXmyNgBmCnMqbLx37G588
bsxObXK+JvrZjJUF00Ykp1+paU+HCxBTkDeFmMm17DnFlBwnftV9uGE1OtCPl/iw
NdyvzCUNVI8++a6In/Mc1AoLAyRtWPyEL6fHcmzmM480zYzcTe0=
=phqj
-----END PGP SIGNATURE-----

--=-f/kx17T7SJw/Y2v32yys--
