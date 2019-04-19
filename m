Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BC6C282E0
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 23:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013B82171F
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 23:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfDSXYu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 19:24:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54276 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbfDSXYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 19:24:49 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hHO5I-00083t-Ew; Fri, 19 Apr 2019 10:37:21 +0300
Message-ID: <560ba2b6a20ac9842fd6a5a5d786def1077811f4.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 19 Apr 2019 10:37:18 +0300
In-Reply-To: <53070f180e2ae093d0daccc664b09837beb8b549.camel@coelho.fi>
References: <53070f180e2ae093d0daccc664b09837beb8b549.camel@coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-d8BJgzVkVdBMJLEyVhIf"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-04-18-2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-d8BJgzVkVdBMJLEyVhIf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is a new version of my pull request on top of your tree after you
fast-forwarded to net-next, to avoid a small conflict.

This is the third batch of patches intended for v5.2.  This includes
the last patchset I sent.  Usual development work.  More details about
the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 5c2e6e14a0ad24a35d9d2b318204c8c012d9d618=
:

  Merge branch 'net-add-reset-controller-driven-PHY-reset' (2019-04-18 17:4=
3:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-04-18-2

for you to fetch changes up to 69166f7a37dc0bde5a3c26945e3cdbfc740b0562:

  iwlwifi: dbg_ini: set dump bit only when trigger collection is certain (2=
019-04-19 10:27:34 +0300)

----------------------------------------------------------------
Third batch of patches intended for v5.2

* Bump the 20000-series FW API version supported;
* Work on the new debugging infra continues;
* One clean-up to prevent a bogus warning with clang;
* A small cleanup in the PCI ID list;
* Work on new hardware continues;
* RTT confidence indication support for FTM;
* An improvement in HE rate-scaling;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: support rtt confidence indication

Gregory Greenman (1):
      iwlwifi: rs: consider LDPC capability in case of HE

Luca Coelho (2):
      iwlwifi: bump FW API to 47 for 22000 series
      iwlwifi: remove unused 0x40C0 PCI device IDs

Nathan Chancellor (1):
      iwlwifi: mvm: Change an 'else if' into an 'else' in iwl_mvm_send_add_=
bcast_sta

Shahar S Matityahu (6):
      iwlwifi: dbg_ini: support notification and dhc regions type parsing
      iwlwifi: add FW_INFO debug level
      iwlwifi: dbg_ini: add debug prints to the ini flows
      iwlwifi: dbg: add periphery memory dumping support to ax210 device fa=
mily
      iwlwifi: dbg: add lmac and umac PC registers to periphery dump
      iwlwifi: dbg_ini: set dump bit only when trigger collection is certai=
n

Shaul Triebitz (2):
      iwlwifi: mvm: set 512 TX queue slots for AX210 devices
      iwlwifi: unite macros with same meaning

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c           |  19 +----------=
----
 drivers/net/wireless/intel/iwlwifi/fw/api/location.h     |  77 +++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h          |   3 +++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c              | 123 +++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/file.h             |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h          |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h           |   2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c             |   8 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c   |  13 +++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c           |  16 ++++++++---=
-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c             |  11 ++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c      |   6 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c            |   5 ----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h       |   4 ---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c     |   7 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c          |   2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             |   8 +++---
 19 files changed, 230 insertions(+), 81 deletions(-)

--=-d8BJgzVkVdBMJLEyVhIf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAly5eq4ACgkQoUecoho8
xfoxxg/9FhvC77ZmbNZkfLovzPC/9RE07R36S9qtmm+qgGEK7Ia+QOdUV6lLzxre
D/d2hbqQxAp5bBr17w6HiPXgeDoibsJiMuPikoom6iXaFjsZzxJxMuDD7jaTKy9p
wAMtUUqBPKiMNK+YrJ1okfamgTdun7PzpPfz+xIWFlNHGYH4h2N17D0dqzul0q6k
ZIUjzaQlzWp0exarnNoRBx08rGafHdHoQxsioeuqtsDzJPE/LmFFVsEMtGkifkKs
V5Lxfc4BQ0/vecZE33vRuNrX5eSWGA045JpgOxLuQFXMZ4lxVPZ56nWZcOF47r7w
1ukrofLGZ+1ZNFKLeDdQ/XJdkSQne9FVn9i46SAFGkHahfg2QTYz559lTohc6OIj
9hGyDGEJJ3tXMNe0j724+Sscwg/C2B26Tu6U1fta+TqJ6teJzMM5faCY7qVFlR6i
od14Y5RN4V3KWo15/XFe+8mZhSsNTnwRZlt6DNcGrjyESZxLiqcpbA5ALm9aPhIW
EgYqt9lWQTA+TeqDFSCabq5xZyooc3hYFFAPw5psrfGvhzISc3ikvhTqui353Q7R
0QeAJZUwGy3TAB6nmbeQOPsQ61C3uIFczD+LWFsBLb6F0BgNjq+ldW+eOncNtd6k
g9CVLs7MLoSd80eXVx1I1p155hJyJQm3yVJDoeFsECowmGvmnj4=
=MLjR
-----END PGP SIGNATURE-----

--=-d8BJgzVkVdBMJLEyVhIf--

