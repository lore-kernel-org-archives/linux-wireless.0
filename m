Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40920 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756257AbcH2VX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 17:23:58 -0400
Message-ID: <1472505827.27868.41.camel@coelho.fi> (sfid-20160829_232401_766178_9EA32F4C)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 30 Aug 2016 00:23:47 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tECzEhyZhp7IJ9Wl+nHL"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-08-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tECzEhyZhp7IJ9Wl+nHL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Another pull request, this time intended for 4.9. =C2=A0I have a lot of
patches to send, but I'll send smaller batches this time. :)

These patches contain mostly preparation for new HW, but also some
improvements in the dynamic queue allocation code and the
implementation to support GMAC.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 60747ef4d173c2747bf7f0377fb22846cb422195=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2016-08-18=
 01:17:32 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-08-30

for you to fetch changes up to f4bc5caa4aa1cdc04a2e3a5e462f86ff1f502bb3:

  iwlwifi: pcie: remove dead code (2016-08-29 23:55:13 +0300)

----------------------------------------------------------------
* Preparation for new HW continues;
* Some DQA improvements;
* Support for GMAC;

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: mvm: support GMAC protocol

Liad Kaufman (5):
      iwlwifi: mvm: re-aggregate shared queue after unsharing
      iwlwifi: mvm: keep track of tid associated with each queue
      iwlwifi: mvm: re-assign old queues after hw restart in dqa mode
      iwlwifi: mvm: use defines for SCD_CONFIG_CMD enablement
      iwlwifi: mvm: support txq tid owner change

Oren Givon (5):
      iwlwifi: rename and reorder 9000 series configuration structs
      iwlwifi: add a new series 9460 with new PCI ID
      iwlwifi: add new 9460 series PCI IDs
      iwlwifi: add the new 9270 series
      iwlwifi: add the new 9170 series

Sara Sharon (5):
      iwlwifi: mvm: allow same PN for de-aggregated AMSDU
      iwlwifi: mvm: support new paging command format
      iwlwifi: pcie: refrain from SCD accesses
      iwlwifi: pcie: fix ucode load flow for a000 devices
      iwlwifi: pcie: remove dead code

 drivers/net/wireless/intel/iwlwifi/iwl-9000.c       |  83 ++++++++++++----=
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h         |  15 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h       |  19 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |  31 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h  |  12 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c         |  28 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  18 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  26 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        | 338 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h        |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c         |  38 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c      |  24 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c       |  41 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |  45 ++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c        |  13 ++-
 18 files changed, 601 insertions(+), 154 deletions(-)
--=-tECzEhyZhp7IJ9Wl+nHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXxKfkAAoJEKFHnKIaPMX6lGAP/iwnSVg4lsVbp3OnAI8Wn8Al
89/GuNNNd70QP97PBHdYtOlmqkSyV8dptpq5aaA7AQJgG8J++NbcL4wXxoNekiQg
jCp1BrYYI95ldwZ+q4YMHAT0HiMlLRD0KrIGB4Hu/6cJ19Ny2jAhvEYUGqzdp12O
0CxivTMcy/RtD5+RzKcHkZ5/VLTn3FzMWteHa73inwYqJBolWfjh707uK5aa2au4
EcYnTGlExarCGVwPlC2mu7wsB17T1IfUs+rwORSEiTM435V4QUD3r2nbV6DmsiI1
cHTWkoJh57rv1B/RvCA9d1awGbvn9sGQPu6QFs5ZbMdv7Ft95ey3lRzp69RZOBiM
8Ow4bdkzj72a0ZdfXZTc2nivxbL/y5SPx0/HgUYtMQsfm4LyOES3x2S/90Cgvei9
7W3BFrbBbLua+1wQ+Vc7BUpWXncUtJa+TMacy6MwqZFy/7/NxP3kz2UXs6C2ANUw
uQ9TJ+IVdiQbmhYMzlpSeWaSxbF1u3mANAHV8K5LVmfo2QSQdX2DQeKGs3JgSeM9
98JfMLiuFUh3h4rwPZlvjtoEeA/IxFppRdDgvCP+HcIpgDemZ1Z+bOuXKTw4+oyL
6bSHtmO+0vXgbo9TafMsKYFKijzQdRDfaY6P8YmV32ybF7A3p6o0GtArQ28mtinD
LL175tYUXuLL0yJrqM3T
=v5Xb
-----END PGP SIGNATURE-----

--=-tECzEhyZhp7IJ9Wl+nHL--
