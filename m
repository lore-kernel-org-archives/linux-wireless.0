Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D18C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B1D21479
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfDRM6N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:58:13 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53968 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbfDRM6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 08:58:13 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hH6cF-0007ZD-8c; Thu, 18 Apr 2019 15:58:11 +0300
Message-ID: <53070f180e2ae093d0daccc664b09837beb8b549.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Thu, 18 Apr 2019 15:58:10 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-mvqaWl5w52XZS7RH+Pw5"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-04-18
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-mvqaWl5w52XZS7RH+Pw5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the third batch of patches intended for v5.2.  This includes
the last patchset I sent.  Usual development work.  More details about
the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit bdfc4027de15ef0a396b7fc49a9f9c094378e9f4=
:

  rtlwifi: rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask static (2=
019-04-13 14:17:52 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git iw=
lwifi-next-for-kalle-2019-04-18

for you to fetch changes up to 61404c6e6a9fd2f02e18b2ff9defe1b3b98e25a3:

  iwlwifi: dbg_ini: set dump bit only when trigger collection is certain (2=
019-04-18 15:25:20 +0300)

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

--=-mvqaWl5w52XZS7RH+Pw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAly4dGIACgkQoUecoho8
xfpMxxAAgcetdvgrvM7+gzPqu/GdccP96bJvt/kUqUOR+nOvQt4pVPa5A6zCJiST
9aaEccm8otAZOM5tANKXdPYs36ziTGyN+mqs8VDHuQX/Rz0k5RPQQv/HLa7R0zcK
Za5BX0LSWyEn0OmB8/HyMQTtEZdRGKgskttyoY+coqdZZY3opAAKwGfBxR9CJAug
0csocgNXESTogEyAq6qbOCwveVCqWnIC/31rYb+zELvBhWLaKbLHaGulhsOH8V85
e8nowwAfSCehknLxGYZdhcBLV0/ZYnfTuWMAVJAmpgqlmd6h0rH9QeJa0sf4oRYA
kBP/dZP8t7BbtnLXvhd62WDOrDKncUUEacSJGIpuBUJvkjKoRJt9dx2E99d4OheQ
cddBhMzRhYv5aLjHOYqXfmfqp8TzbIz+bZC+vfKUn0xxe1QsCTVrU1urYV0Ht+ys
61eiGdivHCIPVAODhphdbxD5Q4Lr1cWh4c3c6D3cXWHPyNXvbFtIDgEnnBl1NI97
7F+SuuQGOqrJOzWORL0bIjgW6N0QA+JqKRkY5KTr+N6t+zh/djZuFdWxkiNoRPU/
PNLe9s5dDiyzsRjzP5CUx0z4aIw4zI3kPu+1n/Pz2Ym94coWAPT27TJr93CtdcKe
nL3/MCK/L4O1jQKuSniSpGwUoDUjTDJ8kJW5QDDb+1SublQ8zgw=
=ebNV
-----END PGP SIGNATURE-----

--=-mvqaWl5w52XZS7RH+Pw5--

