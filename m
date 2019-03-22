Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD78BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD5C2054F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390178AbfCVMQO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:16:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:45992 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390169AbfCVMQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:16:13 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=chariottest7)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7J5m-0000YW-9H; Fri, 22 Mar 2019 14:16:11 +0200
Message-ID: <8dc374567ff4a1138b5c9605ecc2dc0aeb9bc4bc.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 22 Mar 2019 14:16:08 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-/oADuekUYoFFcsAx+SEC"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-02-22
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-/oADuekUYoFFcsAx+SEC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of patches intended for v5.2.  This includes
the last two patchsets I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 501faf710230b67e470b314868110357cf3a554d=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2019-02-28 11:50:40 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-03-22

for you to fetch changes up to fe63f21b20df1adaab90c1839d36ee7c6e4b6ac0:

  iwlwifi: dbg_ini: align to FW api version 1 (2019-03-22 12:59:42 +0200)

----------------------------------------------------------------
First batch of patches intended for v5.2

* Send NO_DATA events so they can be captured in radiotap;
* Some channel-switch changes;
* Support for multiple BSSID;
* Continued work and bugfixes for the new debugging infra;
* Support for some new FW API versions;
* Some work to support new hardware;
* General bugfixes;
* Other cleanups;

----------------------------------------------------------------
Ilan Peer (1):
      iwlwifi: mvm: Support new format of SCAN_OFFLOAD_PROFILES_QUERY_RSP

Johannes Berg (3):
      iwlwifi: mvm: report all NO_DATA events to mac80211
      iwlwifi: mvm: enable HT/VHT IBSS
      iwlwifi: pcie: switch to correct RBD/CD layout for 22560

Luca Coelho (1):
      iwlwifi: remove unnecessary goto out in iwl_parse_nvm_mcc_info()

Mordechay Goodstein (1):
      iwlwifi: mvm: set max amsdu for TLC offload

Sara Sharon (7):
      iwlwifi: mvm: report delayed beacon count to FW
      iwlwifi: mvm: implement CSA abort
      iwlwifi: mvm: track CSA beacons
      iwlwifi: mvm: notify FW on quiet mode in CSA
      iwlwifi: mvm: disconnect in case of bad channel switch parameters
      iwlwifi: mvm: track changes in beacon count during channel switch
      iwlwifi: mvm: support multiple BSSID

Shahar S Matityahu (5):
      iwlwifi: dbg: use dump mask for tx command dumping length
      iwlwifi: mvm: use dump worker during restart instead of sync dump
      iwlwifi: dbg: add DRAM monitor support for AX210 device family
      iwlwifi: dbg_ini: separate between ini and legacy dump flows
      iwlwifi: dbg_ini: align to FW api version 1

Shaul Triebitz (4):
      iwlwifi: mvm: be more forgiving if num of channels is too big
      iwlwifi: add support for 6-7 GHz channels
      iwlwifi: support new NVM response API
      iwlwifi: for AX210 device support radio GF4

YueHaibing (1):
      iwlwifi: Use struct_size() in kzalloc

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c      |   9 +++++
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 177 ++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h |  39 ++++++++++++++++=
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h      |  67 +---------------=
-----------------
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h    |  54 ++++++++++++++++=
++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c         | 189 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++--------------------------------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h         |  17 ++++-----
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h  |   6 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h        |   9 +++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h     |   5 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h        |   5 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c    |  10 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c  | 139 ++++++++++++++++=
+++++++++++++++++++++++----------------------------
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h       |   6 +++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c         |  90 ++++++++++++++++=
++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |   7 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 202 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  24 ++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |   8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c      |  44 ++++++++++++++++=
++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |  31 +++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c       |  25 ++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |   5 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h  |  30 ++++-----------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c        |  13 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |  38 +++++++++++++---=
---
 29 files changed, 807 insertions(+), 446 deletions(-)

--=-/oADuekUYoFFcsAx+SEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlyU0ggACgkQoUecoho8
xfrZ9RAAu6rD5S+opcpCs+i9qBaI31yRgybuqc4rgFFGupWIYToEnBTUNqdg7+gr
TsVZbPL/gPQEhKyRcWg0G4FTJc6Yl55gw7BgzsGydZ+FCkmYSBQY4CPFyf39IcPe
BozJ9tcAmydSwv20Z7w6H74XuMuoxEbx/8XL4LlSqyJH+FVjQxc6aiO1sOR/j51v
HUmwx/snn+H0Y/ukyxmH40Qwc3gVDZOGFj6WVwYMsyV36sNo1kVnGwZN4ztfnsVC
xO3jSO5GHYHqsbBkxEr2H5awnUn7FXiC6Lw7vvUQA0f+CfHf8KYWkUtpHnG6WHP6
xedRbsomFXltA1qQ3x8drf2P7FsES/YwHd51/XdNNw2tsK+44ng4Li2ZVorE1RD6
fExExVjciaqe5xPmMIGJgl+J4ZWmQa9xIICyVLqjgkn8PsFDHZ8gN38Z9RoAKgZq
Dz1Ww/gb57CpjwYUJLOLLsZCyZe/cO1LcA1u8HbtXZaRmBWnKIhGnb2jFj43nGha
gSFOIp38mryoaOyxZEYbZPVKhunEJehScJY5p/bup7GZi68RWCM6ECjBuhMWLwtF
sDYx6MN3cyGv0qGLKkN6/X3luO+jORgEzUGdcIqJ0fGjWug3aaCkzeE6aOMyx6W9
Icbi1dL4++MTg5hJnLVgEXmHdxNy5RCAzK2EjQ84bWTY/0uBfB0=
=TSQh
-----END PGP SIGNATURE-----

--=-/oADuekUYoFFcsAx+SEC--

