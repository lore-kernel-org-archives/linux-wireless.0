Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A39C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C7621746
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50C7621746
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbeI1NPk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:15:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728811AbeI1NPk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:15:40 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5meQ-0004pt-NK; Fri, 28 Sep 2018 09:53:23 +0300
Message-ID: <42ab6bb469c859dda2b185b6b2c9ec032ed8d556.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 28 Sep 2018 09:53:21 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-BsuZcq3e/0FqI1XEm/mT"
User-Agent: Evolution 3.30.0-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-09-28
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-BsuZcq3e/0FqI1XEm/mT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of patches intended for v4.20.  This includes
the last 2 patchsets I sent.  Usual development work, with some
improvements on HE, HW support, bugfixes, and some other small
improvements.  More details about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 93ed990e3a6e722b7b1e1d59b3ceb8d91e36e682=
:

  qtnfmac: remove set but not used variable 'vif' (2018-09-20 15:12:13 +030=
0)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-09-28

for you to fetch changes up to 6f3df8c1192c873a6ad9a76328920f6f85af90a8:

  iwlwifi: mvm: Allow TKIP for AP mode (2018-09-28 08:57:30 +0300)

----------------------------------------------------------------
Second set of iwlwifi patches for 4.20

* TKIP implementation in new devices;
* Fix for the shared antenna setting in 22000 series;
* Report that we set the RU offset in HE code;
* Fix some register addresses in 22000 series;
* Fix one FW feature TLV that had a conflict with another value;
* A couple of fixes for SoftAP mode;
* Work continues for new 22560 hardware;
* Some fixes in the datapath;
* Some debugging and other general fixes;
* Some cleanups, small improvements and other general fixes;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: set wep key for all stations in soft ap mode

David Spinadel (1):
      iwlwifi: mvm: Support TKIP on gen2 data path

Dreyfuss, Haim (1):
      iwlwifi: mvm: cleanup dead code on resume flow for non unified image.

Emmanuel Grumbach (3):
      iwlwifi: mvm: fix a comment about the SP length
      iwlwifi: dbg: don't crash if the firmware crashes in the middle of a =
debug dump
      iwlwifi: mvm: remove support for adjacent channel compensation

Erel Geron (2):
      iwlwifi: fix non_shared_ant for 22000 devices
      iwlwifi: mvm: TLC support for Coex Schema 2

Golan Ben Ami (2):
      iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
      iwlwifi: configure power scheme to balanced for 22560 devices

Ilan Peer (1):
      iwlwifi: mvm: Allow TKIP for AP mode

Johannes Berg (10):
      iwlwifi: RX API: remove unnecessary anonymous struct
      iwlwifi: mvm: report RU offset is known
      iwlwifi: remove ucode error tracepoint
      iwlwifi: api: annotate compressed BA notif array sizes
      iwlwifi: pcie: gen2: pull adding frags to helper routine
      iwlwifi: pcie: gen2: build A-MSDU only for GSO
      iwlwifi: pcie: tx: unify TFD unmapping
      iwlwifi: pcie: tx: pull tracing out of iwl_fill_data_tbs()
      iwlwifi: pcie: support transmitting SKBs with fraglist
      iwlwifi: fix LED command capability bit

Rajat Jain (1):
      iwlwifi: pcie: Fail fast if HW is inaccessible at probe

Sara Sharon (5):
      iwlwifi: fw: add a restart FW debug function
      iwlwifi: fw: stop and start debugging using host command
      iwlwifi: pcie: read correct prph address for newer devices
      iwlwifi: mvm: use correct FIFO length
      iwlwifi: pcie: add infrastructure for multiple debug buffers

Shahar S Matityahu (1):
      iwlwifi: debug flow cleanup

Shaul Triebitz (4):
      iwlwifi: iwlmvm: fix typo when checking for TX Beamforming
      iwlwifi: mvm: enable sending HE_AIR_SNIFFER command via debugfs
      iwlwifi: mvm: do not override amsdu size user settings
      iwlwifi: pcie: set RB size according to user settings

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h      |   5 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h         |  32 ++++++++++=
++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h           |  14 ++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h            |  28 +++++-----=
-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h           |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h            |   6 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c               | 251 ++++++++++=
+++++++++++++++++++++++++++++++++++----------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h               |  80 ++++++++++=
++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h              |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-context-info.h     |  25 +++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |  55 ----------=
----------
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c         |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            |  17 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c             |   9 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c               |  23 +++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |  32 ++++++++++=
++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c         |   4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |  42 ++++++++++=
+-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |  20 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             |  14 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |  25 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |  47 ++++++++++=
++------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |   1 -
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c       |  28 +++++++++-=
-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        |  19 -------
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           | 203 ++++++++++=
++++++++++++++++++++++++++++++++--------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c         |  58 ++++++++++=
++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c            |  77 ++++++++++++=
++--------------
 34 files changed, 691 insertions(+), 450 deletions(-)

--=-BsuZcq3e/0FqI1XEm/mT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlutz+EACgkQoUecoho8
xfoo1Q//ZsaiTxf9kpqLaNzrBCTu2a2waABmTnvIH8BfesTQpRP56xIIuOGjiKMA
z2enESZ0doa81v4s/RER/dhRWBIUyH2s1PZwlPVLJF1J2cXPSAfnX4CHD2rsbgqz
Ph4erSVgRvLsyL2Dj/2gM+papkEaei46+Fvn+RAAjY3YnyQiPNjhLg7+dTWffDBc
xxOc5FivuDptjSrz2hC6nibnHfQ7PtyFVCIQ3jka0y3OK/THzcbtS83gPZUPTx/X
yM0xvN00KvVa6s4w58ZFoFeRlffkIsOo802rRN1RcXSZvKBPPmBoldwNMcLydBmV
NOao0MGV5PjIISzOKzJBE5+4rwiErte2M9JuTIYrTGiPg5wI9NfH6RkNZtu24KOO
VOz1RpB4LPQdGq5RadJSJJlPKJPaoHK1EXtyttxwVvzftS+yjawkihsOWdXjCRp9
rp+XJNu4nTTDvxBxx1csmKQ1l1VCbSbXP2IA0etb8SGVcoVa8ZjcH2GnVMwYkMDE
c9oCwhOGQ35g9Mmubr4SkhZMIz5QmvsHCgMKQN/eGvNDb0ll19XV6Oq8b2gP1xfn
vHjn8vqCK45YLbCQgrTFzVFyS0sXFmD3nPl4+t0G1u6W40H3U/Ek+3g1Q57tmndp
IgCVdY3bZEg/NRCkaCS6lMbqqAIq0ea2Ij5NUDXkLq1UXIxSTFE=
=Cd/m
-----END PGP SIGNATURE-----

--=-BsuZcq3e/0FqI1XEm/mT--

