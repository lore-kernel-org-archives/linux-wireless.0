Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752313AbdK1MXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 07:23:04 -0500
Message-ID: <1511871780.4011.426.camel@coelho.fi> (sfid-20171128_132313_550706_47F1383F)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Tue, 28 Nov 2017 14:23:00 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-+vsbtcg0byRo4INFcR0r"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-11-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+vsbtcg0byRo4INFcR0r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my second set of fixes for 4.15.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit ed59b7d53c95548d83d4e7e1bc5edafcdcad09c9=
:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kval=
o/ath.git (2017-11-21 11:52:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-11-28

for you to fetch changes up to 0232d2cd7aa8e1b810fe84fb4059a0bd1eabe2ba:

  iwlwifi: fix access to prph when transport is stopped (2017-11-25 17:12:5=
6 +0200)

----------------------------------------------------------------
Second batch of fixes intended for 4.15.

* One fix in rate-scaling;
* One fix for the TX queue hang detection for AP/GO modes;
* Fix the TX queue hang timeout used in monitor interfaces;
* Fix packet injection;
* Remove a wrong error message when dumping PCI registers;
* Fix race condition with RF-kill;

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: don't use transmit queue hang detection when it is not =
possible
      iwlwifi: mvm: fix the TX queue hang timeout for MONITOR vif type
      iwlwifi: mvm: fix packet injection

Sara Sharon (2):
      iwlwifi: pcie: fix erroneous "Read failed message"
      iwlwifi: fix access to prph when transport is stopped

Shaul Triebitz (1):
      iwlwifi: mvm: set correct chains in Rx status

 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h      |  4 ++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 53 ++++++++++++++++=
++++++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       | 13 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |  6 ++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 10 ++++++++++
--=-+vsbtcg0byRo4INFcR0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlodVSQACgkQoUecoho8
xfrvSg/+NiKrTWL4JTrQkz50B0qvxkKsE/+aMOK9pqTVTim3Rc7NmXdkXfSayq0X
anlB/ShwkhZncLjr1Z2DVsAwPByX8at8IqvC91L8f46ZjUqXrdi+HZXJBL13yIxe
no+4uLpTGR/XwRYmw736Lj0MXJfalC9PnXPEDfeU+2KDrfJNcvUNXVrYH+PPVha7
mmN+qVh7ok5iXAGl7E0ufNw0cqrQmiapPdVYPPfUSxgdcANl5kwxLUZnHTfdkulI
RZGdmD7R92Myl82fWrxjAfso2yR+xNlXevSDwZX0h8xQQrlcHf6tSKJHwVjAuzXH
R8Mc5sqzDLLHkGz9Z+YKp1t16XjSpmnKILbKDOFq6gIWQ7v+/IGB5QqBB0ofGbke
QmdQolBPyN6a/x8OaSuNE2lxkTfEGkLmRuLgaeUyhWDWHMSX0tGtl695UnkoQU75
tCMFOcKtGRAebXitCHLN3CaO7t/ggCBeSVir598gysgZl0TatgEJMzIC11WHu7ce
QPnXEngGIVoxpwJ/aFNZmvwLQ0bmmpn8m5L6XpVXOxgXJAUxM1jlLPx6Gms1mU+v
kVfcI+XFO+5H4ZpJeV8dk+GEMf2PMY2hZHT3xPrmTbIT/FwNXJmpNbFzv6hGMz7b
MZde4VRsof+Xb097ypvz3wFCAwxnEZuGcDq9sa9vrzcHI9GmM9Y=
=JLaO
-----END PGP SIGNATURE-----

--=-+vsbtcg0byRo4INFcR0r--
