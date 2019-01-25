Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81335C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50EB4218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfAYTJr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 14:09:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50726 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYTJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 14:09:47 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn6rI-0000vS-Ro; Fri, 25 Jan 2019 21:09:45 +0200
Message-ID: <77072ceb9ce4171311f67edb51aa5713b8e4cee9.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 25 Jan 2019 21:09:43 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-LMwX/z9EYWCttAvD1N9O"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-01-25
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-LMwX/z9EYWCttAvD1N9O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of patches intended for v5.1.  This includes
the last two patchsets I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 4ad0be160544ffbdafb7cec39bb8e6dd0a97317a=
:

  brcmfmac: Use firmware_request_nowarn for the clm_blob (2019-01-10 13:41:=
03 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-01-25

for you to fetch changes up to ec95b2701d244501068690ad2c43d184413ffc85:

  iwlwifi: fw api: document WoWLAN patterns command (2019-01-25 20:57:22 +0=
200)

----------------------------------------------------------------
First batch of iwlwifi patches intended for v5.1

* Support for Target Wakeup Time (TWT) -- a feature that allows the AP
  to specify when individual stations can access the medium;
* Support for mac80211 AMSDU handling;
* Debugging infrastructure work;
* Preparations for improvements in the device selection code;
* Some new PCI IDs;
* Some updates in the documentation;
* A bunch of fixes for issues found with static analyzers;
* A couple of janitorial fixes from the community;
* Some fixes in P2P;
* Other cleanups and small fixes;

----------------------------------------------------------------
Colin Ian King (2):
      iwlwifi: pcie: make array 'prop' static, shrinks object size
      iwlwifi: fix spelling mistake "registrating" -> "registering"

Emmanuel Grumbach (3):
      iwlwifi: mvm: advertise support for TWT in the Extended Capability IE
      iwlwifi: mvm: rely on mac80211 to configure TWT support
      iwlwifi: mvm: fix firmware statistics usage

Ihab Zhaika (2):
      iwlwifi: correct one of the PCI struct names
      iwlwifi: add new cards for 22560, 9260 and killer series

Ilan Peer (3):
      iwlwifi: mvm: Flush transmit queues on P2P Device ROC done
      iwlwifi: mvm: Set Tx rate and flags when there is not station
      iwlwifi: mvm: Do not set RTS/CTS protection for P2P Device MAC

Johannes Berg (3):
      iwlwifi: mvm: make NVM access actually fail on failures
      iwlwifi: fw api: remove unused/deprecated filter status
      iwlwifi: fw api: document WoWLAN patterns command

Liad Kaufman (4):
      iwlwifi: update hcmds documentation
      iwlwifi: mvm: make num_active_macs unsigned
      iwlwifi: tighten boundary checks
      iwlwifi: memcpy from dev_cmd and not dev_cmd->hdr

Luca Coelho (6):
      iwlwifi: add PCI IDs for the 22260 device series
      iwlwifi: pcie: recognize NICs with hw_rev 0x364 correctly
      iwlwifi: remove support for 9000 A-step devices
      iwlwifi: pcie: remove unnecessary iwl_pcie_enable_rx_wake() function
      iwlwifi: pcie: remove suspend/resume workaround for 9000A devices
      iwlwifi: mvm: fix values in the table example

Mordechay Goodstein (2):
      iwlwifi: mvm: avoid possible access out of array.
      iwlwifi: avoid access out of memory allocated

Sara Sharon (3):
      iwlwifi: mvm: support mac80211 TXQs model
      iwlwifi: mvm: support mac80211 AMSDU
      iwlwifi: mvm: bring back mvm GSO code

Shahar S Matityahu (2):
      iwlwifi: wrt: add to dump number of lmacs, lmac1 and umac error id
      iwlwifi: wrt: add 22000 device familiy prph dump support

Shaul Triebitz (1):
      iwlwifi: mvm: fix wrong DCM TLC config

YueHaibing (1):
      iwlwifi: use kmemdup in iwl_parse_nvm_mcc_info()

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |  68 +++++++++++++++=
++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        | 110 +++++++++------=
-------------
 drivers/net/wireless/intel/iwlwifi/dvm/main.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |   8 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h       |  10 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h       |   4 --
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h    |  15 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          | 184 +++++++++++++++=
++++++++++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |  11 ++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |  12 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h         |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  27 +++----
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |   8 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  96 +--------------=
----------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    | 167 +++++++++++++++=
+++++++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  57 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         |  10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  87 +++++++++++++--=
--------
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c       |  21 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          |  26 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          |  10 +--
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 379 +++++++++++++++=
++++++++++++++++++++++++---------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |   4 --
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          | 161 +++++++++++++++=
+++-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  13 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  86 +++++++++++++++=
++-----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   2 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         |  26 -------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  25 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |  10 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   3 +-
 37 files changed, 900 insertions(+), 768 deletions(-)

--=-LMwX/z9EYWCttAvD1N9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlxLXvcACgkQoUecoho8
xfpBKA//TH+flvB8pvx0D4x8ui3bGidoqqN3Om76TfQV11gBqkkbTnbJ9g7HAmBq
u/kPCnGbG9/k8ncQ7eKfpm1yslypmYBAgKUpLKN5FZCTQry9qG/RN2yD6keYljvX
89uoMEZm0YPwhpIDYU44VGn7eIhfK2RpP9WQpvoegldHm4bTEtqXoY8lzHSO735V
phBtWXwsDK2DTt1Au3mPTh7XamhS6StT2/9kwCvgw0r76ypRrZEGdZSFhdHViXDM
Hzucpp1kZZnRubcBleY2tc6UszpNMF5YFTIbXtBxfohXcsiZQY75NRmz7HU8fMPQ
SsZSBFfrZ+dfuR4H/Vm3aDGHtZPuE3LxoYgOusxntC7rVD9VplogyGZVgjQv/6Q0
0tli8oz1kbVsMIEs/Y2q+DY1vSy9B4OTLF64rqk6Ax1yYDJEad2+wSf0iyrzTlrI
oRqkQMYPIWRjaeG4peP4WJV7RDrXSHW9004BgTJfU1Y6a3WYvIVTfhWOI6AZJDKl
FPhVlo/xDNgejR0c5lMJDDialn+7oCLNpqGshNtvdr7SRHuDCoxr57nf2e8fWCc4
LB8nimhRLFRpUdtQB+x1XE4KPtdmVBBLkHDGpp13lGZpCcOj14iVdltOrb1WbCfh
YIKaEW0a6isFw9eeeTFvFS5RQF2luRRX4oaYdeNtoZRKocZHrJA=
=ceB6
-----END PGP SIGNATURE-----

--=-LMwX/z9EYWCttAvD1N9O--

