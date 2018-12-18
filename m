Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74312C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 09:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4820B20672
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 09:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbeLRJre (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 04:47:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42746 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbeLRJre (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 04:47:34 -0500
Received: from 201-0-74-183.dsl.telesp.net.br ([201.0.74.183] helo=dubbel)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gZByM-0004XB-8w; Tue, 18 Dec 2018 11:47:31 +0200
Message-ID: <1308b769a03aab069c43161d66047274ef8b6fc7.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Tue, 18 Dec 2018 07:47:06 -0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-NcJNWXo2TDMGkhr6sS/d"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-12-17
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-NcJNWXo2TDMGkhr6sS/d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fourth batch of patches intended for v4.21.  This includes
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

--=-NcJNWXo2TDMGkhr6sS/d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlwYwhoACgkQoUecoho8
xfoHPQ/8DcME3ULW0jzJ1isaX5fUesVaAGA2XmJbQ4ofy6T/4GOfCAKMUPfhmKL/
DGBzSEyOOlF4//nLA3KboLNnyzHqI08YGFBQZPHdrW5BZAHrNbELQLUV6Blfu+if
OJsy5XEZCZB3f0f5f7Wga2kDKOhcaB4CdRs1wlCzwaEvQSQ4WRIl1hDZj+ajwFT/
s1eB9DibXwjHwRPhaKYo0fUzN5hY94Zt0Z4xn9LWYtSLZ47Ok5gNqZ1f6IOEo4y/
38vDEDvGDzQeDrPPWdTq8fceRLKo+dxD6n3MvG9eDdwAVyb5D2zOiMGWQVwTFCrW
AIZRkjg+XKq8WueT7JqTrGDltrxjCPwmCwEUjdp6pywFef/9dMzG/fX14GfdJ7II
K5dwfs+qRiafhff7A0V2R81zbtEmzJex2en0u2uljnyRXlEaR5ZwQwnYsgHOywb8
eTPMR1E9TQT3nBEn1Mscx1cknpm0m6XPsc/1u7tbbmPlIosO0LrgMfL3VSJUMyjK
Dkoaf0uHAeiEWJ8xj6oRhkB4mLkDk4U5YRzEFnt8VTCNkcM1egu4kR0WItLbKu5o
2Mmn1DPRBNTLmb6MzXyHLCSEFURCEUz44FbMNGTH6si7aHRCtCrdWznjsQYvLagZ
KJlLMr4qQHiV/ZabpSqXnaiFAK8EQolXN1Ox6XOFLzpew2Ja7L8=
=Q2ff
-----END PGP SIGNATURE-----

--=-NcJNWXo2TDMGkhr6sS/d--

