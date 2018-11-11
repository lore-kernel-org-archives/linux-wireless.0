Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177BBC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 09:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25F120871
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 09:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D25F120871
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbeKKTBB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 14:01:01 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35780 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727334AbeKKTBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 14:01:00 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLlnd-00005E-2f; Sun, 11 Nov 2018 11:12:57 +0200
Message-ID: <fa556d1212cd48befec5fe0ea8a1f9ca2efcae89.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Sun, 11 Nov 2018 11:12:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-aC86pcEA++8yNPDpMpM1"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-11-11
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-aC86pcEA++8yNPDpMpM1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of patches intended for v4.21.  This includes
only the last patchset I sent.  Usual development work, new PCI IDs and
small fixes and cleanups.  More details about the contents in the tag
description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit bb38177cb6c6dc973ad8b88f219742b29f3002f1=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2018-11-09 17:15:25 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-11-11

for you to fetch changes up to 56b657f7f9c07421a4f910b7e2b382184f1ddbc8:

  iwlwifi: fw: use helper to determine whether to dump paging (2018-11-11 1=
1:06:23 +0200)

----------------------------------------------------------------
First set of iwlwifi patches for 4.21

* PCI IDs for some new 9000-series cards;
* Improve antenna usage on connection problems;
* Some improvements in the debugging code;
* Other clean-ups and small fixes;

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Avraham Stern (2):
      iwlwifi: mvm: switch management tx antenna only on tx failure
      iwlwifi: mvm: toggle tx antenna if tx fails during connection establi=
shment

Emmanuel Grumbach (1):
      iwlwifi: mvm: remove unused conversion table

Ihab Zhaika (1):
      iwlwifi: add new cards for 9560, 9462, 9461 and killer series

Johannes Berg (2):
      iwlwifi: mvm: synchronize TID queue removal
      iwlwifi: mvm: remove queue_info_lock

Naftali Goldstein (2):
      iwlwifi: fw: do not set sgi bits for HE connection
      iwlwifi: mvm: add description to a few generic assert numbers

Sara Sharon (4):
      iwlwifi: pcie: don't reset TXQ write pointer
      iwlwifi: dbg: avoid passing trigger around
      iwlwifi: dbg: use helper to check if debug type is set
      iwlwifi: fw: use helper to determine whether to dump paging

Shahar S Matityahu (1):
      iwlwifi: trans: Clear persistence bit when starting the FW

Tova Mussai (1):
      iwlwifi: mvm: enable low latency for soft ap

YueHaibing (1):
      iwlwifi: mvm: remove set but not used variable 'he_phy_data'

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          | 109 +++++++++++++++=
+++++++++++++++++++++++++++++++--------------------------------------------=
--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |  18 +++++++++++++--=
-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h        |   7 ++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |   8 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  14 +++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |   7 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  27 +++++++++++++++=
++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  10 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  17 +++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c       |   4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |   6 ------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c        |   4 +---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 114 +++++++++++++++=
+++++----------------------------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |   4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  83 +++++++++++++++=
++++++++++++++++++++++++++++++++++---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  54 +++++++++++++++=
++++++++++---------------------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  50 +++++++++++++++=
++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  16 ++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   3 +--
 21 files changed, 313 insertions(+), 246 deletions(-)

--=-aC86pcEA++8yNPDpMpM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlvn8pcACgkQoUecoho8
xfoe8w/+J6J/cyDbtvVnqwPw55Mx2fqguLRqm7KL+WppoW8jntRKhw15GPDQZbaG
4CbO6gM3nYALArCuzcRVLzrrm3ygnQJrtWw9K3RMMSz8n8ZUGkYsGXM++8dLoy8e
jqPiDeb5kaiVoOz49Y96GelijzSpvZjbl92rXRrhLJ5ug5EADqYQnhUPVIW+RPMw
8RMQztISOzAsu+jYMEafPvlc1/0q+5AUFA0I6RSP0Qg5/tzb5q4nJUWgSb8R2HMq
c/STB6EYXCDdDbKIJixUXBBzR/E4wNxZEk1zt5xivuzrYr8gE9wahOlhZ3uWWcYf
JZe69gTBJKWRB7YW4NTGzBb56RvYqvrTFFaZnrN8QpaPzF1XfG4shlsbr8DcVhPl
HApI7A4Pt5PhncPZ5OlSHc4YvFy50CknNKtcuA+r/aKX2q+P+crYJ7Aucu/Kl2sY
ufn/yyai7Ld93mO94Kwn+p8oHchq8H27AP0UWdsXeSRpFztttCEsaChF6k3oq6s4
W160nvs/XXktD9y1bkxz+bnS35e9p4d0olp0aa8AsGLtr7v4K3a3uQ8GDAXUPKpu
s/QzW1NKGOmEZdQiT+4QouEV0V2yZA8+NZYaHssyYdHsSPPXkM9ts0oQ/3YBDb3f
DWBSoamljobkqxHwtspgsniVHlQsSmJkgZC903MYi9sN78w0syk=
=o+Yw
-----END PGP SIGNATURE-----

--=-aC86pcEA++8yNPDpMpM1--

