Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CF7C43613
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 14:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF33208CD
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 13:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbeLNN7i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 08:59:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41878 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728881AbeLNN7i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 08:59:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXo07-0002Ip-9n; Fri, 14 Dec 2018 15:59:36 +0200
Message-ID: <d17183ee2870be4c61b9d8b80c1e0a34496ca327.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 14 Dec 2018 15:59:33 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Pt0n6jTymXmpPJdWbDVU"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-12-14
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-Pt0n6jTymXmpPJdWbDVU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the third batch of patches intended for v4.21.  This includes
only the last patchset I sent.  Usual development work, continuing with
the new debugging infrastructure, some 802.11ax fixes in radiotap and
other small fixes and cleanups.  More details about the contents in the
tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit e3e454b7047a8bb11c0311ab1708e040481a6044=
:

  rtlwifi: rtl8821ae: remove set but not used variable 'type' in translate_=
rx_signal_stuff (2018-12-13 17:04:09 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-12-14

for you to fetch changes up to 55ed14cdaec503bfe6a94f0524d0d2c9b7226aed:

  iwlwifi: mvm: don't check if a pointer is set if it can't be unset (2018-=
12-14 13:04:49 +0200)

----------------------------------------------------------------
Third batch of iwlwifi patches intended for v4.21

* Some cleanups in the HW configuration structures;
* More work on the debugging infrastructure;
* Fixes related to 802.11ax;
* Other cleanups and small fixes;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: force TCM re-evaluation on TCM resume

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't check if a pointer is set if it can't be unset

Luca Coelho (5):
      iwlwifi: move common 9000 cfg parameters to common macro
      iwlwifi: don't define OTP_LOW_IMAGE_SIZE per family, but per size
      iwlwifi: remove useless NVM_HW_SECTION_NUM_FAMILY_* macros
      iwlwifi: move iwl_nvm_check_version() into dvm
      iwlwifi: remove all unnecessary occurrences of nvm_calib_ver

Sara Sharon (5):
      iwlwifi: dbg: dump data according to the new ini TLVs
      iwlwifi: add support for triggering ini triggers
      iwlwifi: mvm: activate apply points
      iwlwifi: pcie: fix erroneous print
      iwlwifi: pcie: set cmd_len in the correct place

Shaul Triebitz (3):
      iwlwifi: mvm: change PHY data RX for HE radiotap
      iwlwifi: mvm: add L-SIG length to radiotap
      iwlwifi: mvm: radiotap: remove UL_DL bit in HE TRIG_BASED

 drivers/net/wireless/intel/iwlwifi/cfg/1000.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c            |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c           |  10 +--
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c            |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c            |  27 +------
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c            |  11 +--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c            |  85 ++---------=
---------
 drivers/net/wireless/intel/iwlwifi/dvm/main.c            |  17 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h           | 190 +++++++++++=
+++++++++++++++++-----------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c              | 322 +++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h              |  41 +++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h       |  17 ++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h          |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c    |  19 -----
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h            |   6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c              |  20 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c              |  37 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c            | 394 +++++++++++=
+++++++++++++++++++++++++++++++++++++--------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c            |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c           |  14 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |  13 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h       |   5 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c          |  71 +++++++++++=
------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c        |  24 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             |  10 +--
 31 files changed, 872 insertions(+), 498 deletions(-)

--=-Pt0n6jTymXmpPJdWbDVU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlwTt0UACgkQoUecoho8
xfraQg/8CNAM7lNynoghEJGqRDdIpgQ4mtkrgfdM/NTxAcQOt3u6i3GBaP/EG0E4
69iCPaxj3wKVVKMBuPoE0uwh5lGP4RGuByMHr7Lmvm1wlvd+k8iW3VnLCwMAyGnK
+k3UtIeEozyEDPxB52BpQxLvnOyDczjQvRz8AzLlaAGnnJfg9n9l5oFwvzuqJnQb
WhCF44MSiBuTShDP0DGmJVKw3qMnYi1k8FQlHL/z/8mEHoqLpc0iOzzCyWTaHZAj
zQrzJNiqabM9K03MpZJ7qbQRQZbDT6GKJsJfzt0xeWKY6xYGBMqqzsWKT4pSI7Vd
9yrUaKXOOuvQxqPQlJZDXgb068vnPkUj5vgG0bQE+N1BE9+YFg8EWmvD1HfqVVPn
lyuGnL395RFnb9lpxuObz+wdiFaQJchbA7LzQ4etYyStEwyQc/71bPgBmjVJtuOv
EtmP8qmGld9K+SuyABiasdASWkVePuPhMrqlwF2OvCIJ7VFJy8vTGESbdsNKjkAM
2lH+tWNUI+pnMlvMr9qI2eJzX/6PZDPQxv7Gw/QLfZUuiZiyDEC9QhZHaFCJD4rN
iH3wIbc+oQI9XgSGOVpwNPwK2QLHW1ZqCI7iq+sCX51TAGq8f6LfJt1voaURphAx
3xA1x5rDfiH90U3a6b33WivnNUaejaOAV7/3VXee+0Cf1rGmw/4=
=tE2I
-----END PGP SIGNATURE-----

--=-Pt0n6jTymXmpPJdWbDVU--

