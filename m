Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45454C64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 07:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C98E2087D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 07:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C98E2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbeJFObx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 10:31:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:55840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727580AbeJFObx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 10:31:53 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g8h1r-0002YF-5b; Sat, 06 Oct 2018 10:29:35 +0300
Message-ID: <f5d3582e83112e6fb0c3b5aa1a0cb136bcc12c1e.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Sat, 06 Oct 2018 10:29:33 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-CYL9QIV2PoX6+Ow+uSYH"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-10-06
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-CYL9QIV2PoX6+Ow+uSYH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the third batch of patches intended for v4.20.  This includes
the last 2 patchsets I sent.  Usual development work, including some
improvements in the HE radiotap stuff, a new FW version support and
other small improvements and fixes.  More details about the contents in
the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb=
:

  qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44=
 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-10-06

for you to fetch changes up to ea7cb8293874f8d9cf36c9e5387e2247f15373dc:

  iwlwifi: dbg: make trigger functions type agnostic (2018-10-06 10:25:55 +=
0300)

----------------------------------------------------------------
Third set of iwlwifi patches for 4.20

* Fix for a race condition that caused the FW to crash;
* HE radiotap cleanup and improvements;
* Reorder channel optimization for scans;
* Bumped the FW API version supported after the last API change for
  this release;
* Debugging improvements;
* A few bug fixes;
* Some cleanups in preparation for a new implementation;
* Other small improvements, cleanups and fixes.

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: mvm: allow channel reorder optimization during scan

Emmanuel Grumbach (1):
      iwlwifi: mvm: clear HW_RESTART_REQUESTED when stopping the interface

Haim Dreyfuss (1):
      iwlwifi: mvm Support new MCC update response

Johannes Berg (16):
      iwlwifi: mvm: remove unnecessary overload variable
      iwlwifi: mvm: minor cleanups to HE radiotap code
      iwlwifi: mvm: put HE SIG-B symbols/users data correctly
      iwlwifi: mvm: pull some he_phy_data decoding into a separate function
      iwlwifi: mvm: clean up HE radiotap RU allocation parsing
      iwlwifi: mvm: move HE-MU LTF_NUM parsing to he_phy_data parsing
      iwlwifi: mvm: add TXOP to HE radiotap data
      iwlwifi: mvm: add LDPC-XSYM to HE radiotap data
      iwlwifi: mvm: add more information to HE radiotap
      iwlwifi: mvm: set max TX/RX A-MPDU subframes to HE limit
      iwlwifi: pcie gen2: check iwl_pcie_gen2_set_tb() return value
      iwlwifi: add fall through comment
      iwlwifi: pcie: check iwl_pcie_txq_build_tfd() return value
      iwlwifi: bump firmware API version for 9000 and 22000 series devices
      iwlwifi: mvm: decode HE information for MU (without ext info)
      iwlwifi: mvm: show more HE radiotap data for TB PPDUs

Luca Coelho (1):
      iwlwifi: mvm: check for n_profiles validity in EWRD ACPI

Naftali Goldstein (1):
      iwlwifi: nvm: get num of hw addresses from firmware

Sara Sharon (8):
      iwlwifi: dbg: move debug data to a struct
      iwlwifi: dbg: refactor dump code to improve readability
      iwlwifi: dbg: split iwl_fw_error_dump to two functions
      iwlwifi: dbg: dump memory in a helper function
      iwlwifi: dbg: group trigger condition to helper function
      iwlwifi: dbg: make iwl_fw_dbg_no_trig_window trigger agnostic
      iwlwifi: dbg: decrement occurrences for all triggers
      iwlwifi: dbg: make trigger functions type agnostic

Shahar S Matityahu (3):
      iwlwifi: add dump collection in case alive flow fails
      iwlwifi: runtime: add send host command op to firmware runtime op str=
uct
      iwlwifi: add debugfs to send host command

Shaul Triebitz (1):
      iwlwifi: pcie: avoid empty free RB queue

Yisheng Xie (1):
      iwlwifi: mvm: use match_string() helper

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h |  81 +++++++++-------=
----
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h      |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c         | 411 ++++++++++++++++=
++++++++++++++++++++++++++++++++-------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h         |  45 ++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c     |  64 ++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h        |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h         |  41 ++++++----
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h     |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c        |  77 +++++++++-------=
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c  |  10 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c    |  13 +---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c         |  12 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |  12 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  42 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c        |  25 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |  39 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c         |  29 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       | 373 ++++++++++++++++=
+++++++++++++++++++++++++++++++++----------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |  11 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c         |  15 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c      |  16 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c        |  32 +++++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c   |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c        |   2 +
 31 files changed, 762 insertions(+), 627 deletions(-)

--=-CYL9QIV2PoX6+Ow+uSYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlu4ZF0ACgkQoUecoho8
xfpFGQ//WMbwgDgBI2o8Dm34kUgfUdw1d/vwc8tb3kXxg+wsIkuPAuw48Isnf5yB
ZKKvuf4gltVtztxX3OcaY+VIgMUDsuq/wiWOyWkhH1+hV8TUZ2z+yTy0TmTNHvHY
IQ6545t/KRgXGGC6DCD2Pr6BgLAj+1J+q4cl+jojnVRdUxLxM1i/rR1x0LqYp6jo
farApmcEkrz1v0keyLF9R8/fNE72qhCY2V86N1ZgKatFDshlD2lSY9prSle5/brx
s7XR4b5mfADyQlk+QdSmJLlZ3lzxnHEfDuCfYhJQ0brpLV9ED0HOTecZ4FRBVD2x
VF9AydO5hbBtYK9JUu9wsKMpVpmDluk6ERlc+YmN5Uz5LrvPEFSOrdF6uMt8+C3R
bgCmh9cNoCbm1QSv2frDZhWGZGixofAk6dnvbeHg/mtcVhIVUjsvdoO1OHBqWTuy
j93xYB9GNND56D+GuoTIPCUQnff+IB48b6S9nk1lJKzlBdpPEMPigmicUvflCffI
bL67HOOwTHRluS/0UV4oHsOEDCVLeUtTKF9lluXPgzvLwjNtWHVWrz1AVZ1H2jW0
+R3TnggYvA0+BKeLR7mG+FYmQvA/+/MaxNYt4Mt6lgAuLKQ2aNSG9bFuN4eVHmS+
KWTCSsiiv00zUND78bBfCVpLCZFkLyOCxRihwxjwzgo4cgVMr/U=
=jRNa
-----END PGP SIGNATURE-----

--=-CYL9QIV2PoX6+Ow+uSYH--

