Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC674C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 01:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BE292145D
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 01:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbeLRBXC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 20:23:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42678 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726276AbeLRBXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 20:23:02 -0500
Received: from 187-26-151-11.3g.claro.net.br ([187.26.151.11] helo=dubbel)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gZ467-0004I3-T0; Tue, 18 Dec 2018 03:23:01 +0200
Message-ID: <39a3a7b5a34332c62468771c57c06a2c6e40b7ab.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Mon, 17 Dec 2018 23:21:24 -0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-at/ZgLHRS4E+GIIKC4kD"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-12-17
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-at/ZgLHRS4E+GIIKC4kD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fourht batch of patches intended for v4.21.  This includes
only the last patchset I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 30ed3c6c0922a1f67c3409b9e81087442614db7b=
:

  Merge tag 'iwlwifi-next-for-kalle-2018-12-14' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-12-14 16:58:00 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-12-17

for you to fetch changes up to 04a70797e208337775c6a1905699e4970ed17f8b:

  iwlwifi: bump the API version to 43 for 9000 and 22000 (2018-12-17 23:07:=
30 -0200)

----------------------------------------------------------------
Fourth batch of iwlwifi patches intended for v4.21

* Support for FW version 43 for 9000 and 22000 series;
* A couple of janitorial fixes from the community;
* More fixes in the 802.11ax code;
* Other cleanups and small fixes;

----------------------------------------------------------------
Colin Ian King (1):
      iwlwifi: mvm: fix spelling mistake "Recieved" -> "Received"

Emmanuel Grumbach (1):
      iwlwifi: mvm: set TWT responder capability bit in 11AX SoftAP mode

Gustavo A. R. Silva (1):
      iwlwifi: mvm: d3: use struct_size() in kzalloc()

Luca Coelho (3):
      [BUGFIXiwlwifi: make MVM and DVM depend on MAC80211
      iwlwifi: remove unused and wrong PHY_CFG_* macros
      iwlwifi: bump the API version to 43 for 9000 and 22000

Naftali Goldstein (1):
      iwlwifi: mvm: fix setting HE ppe FW config

Sara Sharon (8):
      iwlwifi: pcie: use iwl_tx_cmd_gen2 and not iwl_tx_cmd
      iwlwifi: mvm: remove dead code
      iwlwifi: mvm: remove pointless NULL assignment
      iwlwifi: mvm: cleanup iwl_mvm_tx_skb_non_sta
      iwlwifi: mvm: take station lock later in the code
      iwlwifi: pcie: lock txq a bit later in reclaim code
      iwlwifi: mvm: clean up SSN incrementation
      iwlwifi: dbg: add debug data to warning

Shahar S Matityahu (1):
      iwlwifi: wrt: add rt status and num of rx/tx fifos to dump

Shaul Triebitz (2):
      iwlwifi: split HE capabilities between AP and STA
      iwlwifi: mvm: handle RX no data notification

 drivers/net/wireless/intel/iwlwifi/Kconfig           |   4 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h   |  13 ++------
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h |   5 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h       |  49 +++++++++++++++=
+++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |   4 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |   3 ++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   | 290 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++---------------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |   6 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  10 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        | 126 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |  10 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  56 +++++++++++----=
-----------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |   3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   3 +-
 22 files changed, 427 insertions(+), 169 deletions(-)

--=-at/ZgLHRS4E+GIIKC4kD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlwYS5QACgkQoUecoho8
xfrPnBAAmyStrqEas5ehPU3pBP0OHpW4A+yGLrQkgRazK7xA5W4eikJ0uQRbPMbw
f8CA4Isx0UEHW4nUUrKkdDYtQdJXdQ3TK6CVu/bbTY7xIBPEGnLksjzEay5AQSFg
NaQQk9Gi+7tV30HAHQMp9qRFJ7cT8eOZ65vqI4ArNmkLSCwzIgf54SaWmHR2LSMe
HJXX1u451zlz2xct8gnSwJFhn8KVFRUMP+xOHBV2gflKUb5I4+fI8wkiQDmq0/nH
lzut9YkjHmMYqS92OlGxUSJF+iFXQxcAF6DtZd2Ks2OwznynSv4gD8x0ddaEyfvg
+5j1Bw0BU0nWGUc85xCYuQI5hwURC1Pl8xUhFaG8U60EmI1wWpa+RRV22yh9Q7r3
cHau3OSxO95vU9/r/6hyRJp7NO4E1eeLOxdLWLiBkiD8Ytxr8W1SEIhggzYJLIES
8ricNaobeQYRYGLioyCE9GYvvQ+rib7UcVUwpNhylJIth38khJx8kFEPJg/8tCdq
G6CBF6LiGDe1AS9zdHGH+dxZ33frLJ7nHxASYRGVOxxQTYtY8ku/wSt4DerCoM9q
GOdLIB8nGYS9TgV8AkEuXCT/J6kndgIaLMWVswzTkglIMVtbv1DnCYYtJ75eN9ns
lKHtgXyeQT/0Zk2485ta7SqGCC8jzGE1lKn3vM6u6ZVhB/1CVFg=
=akp3
-----END PGP SIGNATURE-----

--=-at/ZgLHRS4E+GIIKC4kD--

