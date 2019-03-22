Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0230DC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 10:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD74D21900
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 10:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfCVK6P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 06:58:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:45970 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726667AbfCVK6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 06:58:15 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=chariottest7)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7HsK-0000X2-Ov; Fri, 22 Mar 2019 12:58:13 +0200
Message-ID: <c1c92313e0ecec1110d60d5624e94c8d75d5e664.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 22 Mar 2019 12:58:10 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-xEkisaUiQyo3ytnKq8b/"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-fixes 2019-03-22
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-xEkisaUiQyo3ytnKq8b/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of fixes for v5.1.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 7dfc45e6282a7662279d168cc1219929456f8750=
:

  mt76x02: do not enable RTS/CTS by default (2019-03-19 17:37:25 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2019-03-22

for you to fetch changes up to 972d8e1377795556024e948357e82532890f2f7d:

  iwlwifi: add new 0x2723/0x2080 card for 22000 (2019-03-22 12:49:05 +0200)

----------------------------------------------------------------
First batch of iwlwifi fixes intended for v5.1

* add some new PCI IDs (plus a struct name change they depend on);
* fix crypto with new devices, namely 22560 and above;
* a bunch of fixes (and a dependency) for the new debugging infra;

----------------------------------------------------------------
Ihab Zhaika (2):
      iwlwifi: rename structs to fit the new names
      iwlwifi: add new 0x2723/0x2080 card for 22000

Johannes Berg (1):
      iwlwifi: mvm: fix TX crypto on 22560+ devices

Shahar S Matityahu (4):
      iwlwifi: add sync_nmi to trans ops
      iwlwifi: dbg_ini: in case of region dump failure set memory to 0
      iwlwifi: dbg_ini: fix bad dump size calculation
      iwlwifi: use sync nmi in case of init flow failure

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 34 ++++++++----------=
----------------
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 64 +++++++++++++++---=
----------------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 41 ++----------------=
-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 13 +++++++------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  7 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  2 +-
 14 files changed, 54 insertions(+), 146 deletions(-)

--=-xEkisaUiQyo3ytnKq8b/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlyUv8IACgkQoUecoho8
xfrhvhAAtjBCZEQj9NmUoiq5vkC3id8R9qvaEF5xUpMQQEKTZOv3ExnEAUZh3rYi
trihGNMqyI6BiyvGlvQE3ib5wahZv6LgYO1HCDAOPAKYmF+xS2YfnNad7frKuDOJ
1C1fqor+SwB4wvHody6CPA2wpe1PP069YyejEUO7r06/quNK1SOzv9yEnRNc9FYx
qtNPPRyTXI7317v1XFN4dAk3znmA6cN4NHVvFTR/5p1tVuiPY0drI7fKKYE40KOc
TV0daTLArVyTxeFYjTIczVkgP10ZMh9K3Esv2R/DyMCR0yBK7QFh0GdH7eRtB85G
3O7qi5gFe6pCpacW4Z4hy93KjCBlhEmpMIKS/fRjnu2IhlOV33936TqzWIuKbpml
RRNl3v3waVwsQgcs0dN7+2lxcS3lfGqPPZ1yhBP2M6UGvIkjgfAixk9hlRp8zymu
o6i3GRyNV/HzltxtX3EF8/ryawAz3KiYSb459ZIs6pecarTIE8YvzwpXxpn0GySG
1bS79xcU9Oj8uMIacFm/ffAkQ9vsLaF+Z3xsH0saQojaN0/bnJAvRLM+5uD48+eq
MzWBr2cBWn1/JhMRjNMwNk+7xdcCPVKBNLHIE1nMiKGhfD1CNrFcwhD1f6Fty9gH
TTjaON64R7JwR8Mhr7vZ7JL2uS6qR/MZr1FxOrq+uI+M86EhKbA=
=dce3
-----END PGP SIGNATURE-----

--=-xEkisaUiQyo3ytnKq8b/--

