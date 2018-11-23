Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D0CC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB0A20659
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CB0A20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390850AbeKWWDN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:03:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729651AbeKWWDN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:03:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9UW-0008G3-G0; Fri, 23 Nov 2018 13:19:21 +0200
Message-ID: <f7e2243ec8a8bcc65ee44146d7486b8f7586eea1.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 23 Nov 2018 13:19:18 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-gWjuyKNK/okN2SF580JR"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-11-23
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-gWjuyKNK/okN2SF580JR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of patches intended for v4.21.  This includes
only the last patchset I sent.  Usual development work, mostly in the
debugging infrastructure and small fixes and cleanups.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 12d56175c89c8a8cc41e478775155709274ff733=
:

  Merge tag 'iwlwifi-next-for-kalle-2018-11-11' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-11-15 16:59:01 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-11-23

for you to fetch changes up to 520229e4b02dc4f5241a251a569fe0691a2c2e2c:

  iwlwifi: mvm: set HW capability VHT_EXT_NSS_BW (2018-11-23 13:01:08 +0200=
)

----------------------------------------------------------------
second batch of iwlwifi patches intended for v4.21

* New FW debugging infrastructure;
* Some more work on 802.11ax;
* Improve support for multiple RF modules with 22000 devices;
* Remove an unused FW parameter;
* Other debugging improvements;

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: mvm: remove assignment of the reciprocal
      iwlwifi: mvm: add support for TWT capabilities

Lior Cohen (2):
      iwlwifi: add fw dump upon RT ucode start failure
      iwlwifi: add debugfs file to read fw debug data recording

Luca Coelho (1):
      iwlwifi: fix cfg structs for 22000 with different RF modules

Sara Sharon (8):
      iwlwifi: dbg: don't limit dump decisions to all or monitor
      iwlwifi: dbg: split fifos dump
      iwlwifi: fw: add FW API of new TLV infrastructure
      iwlwifi: trans: parse and store debug ini TLVs
      iwlwifi: trans: support loading ini TLVs from external file
      iwlwifi: dbg: disable triggers for ini
      iwlwifi: dbg: add apply point logic
      iwlwifi: fw: support API change to debug TLVs

Shaul Triebitz (3):
      iwlwifi: mvm: set MAC_FILTER_IN_11AX in AP mode
      iwlwifi: mvm: send the STA_HE_CTXT command in AP mode
      iwlwifi: mvm: set HW capability VHT_EXT_NSS_BW

 drivers/net/wireless/intel/iwlwifi/Makefile         |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c      |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 401 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h     |  39 +++++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c         | 277 ++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h         |  22 ++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h        |   7 ++
 drivers/net/wireless/intel/iwlwifi/fw/img.h         |  26 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h     |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c    | 230 ++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h    |  87 ++++++++++++++++=
++++++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c        |  24 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      |  23 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c         |   5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |  39 ++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |   1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h  |  44 +++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     | 213 ++++++++++++++++=
+++++++++++++++++++++++++++++++-----
 21 files changed, 1374 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h

--=-gWjuyKNK/okN2SF580JR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlv34jcACgkQoUecoho8
xfqj4xAAqhnIEq8KQLwTxTSOLfDb2jw7jJofltT+C1tj6OMGiQ/W0KAOYeRa+abV
qqrxG/5208ivF7MLbFbpfdFOwJTl0a4ruRnylrrfNvbILciFWwsDMAucC8b49xqg
WeqcN6BxoZly/niU+1U8GwJA0onqnTKX4GBtZKxYsPTEOWFHqn9hAtOLT89a9eps
xqdj27gHswTBWmL6xKahxLlNvm2CaiaVV2BGOg3kem7BnHSiHHjPUg1oRgKsOH59
kNluJO14R9IDO3SEgAXjWntQfrlJgLIuIw1RQvpnNyqV3XLFR3J9fGiXNhHcXy6G
JKPn5ahoZRHN2tMuXI1x10bqT6qEbWFxd7BbpsaNHmveTVcHheFK31g0kp2P5tkJ
yx4mZLftN8ta9ZxVDJNssF1qsBlJEUYXJp66HI2HOxgw/9chY2ZpzTwgH/kNZo9Y
dsQPLveh7HDvcFrO+mNMYdXUCh6FQUmryJNOFU33qLF23m1BVpk0P8OEtGiT+uUC
Sx+p3yuPXXUcKWZ1w8gH+VXcN32pjT6PI+/PadRt8KOrCdYOpEIcVsPRh+XAsN5p
3UOjA506Il0v3934FYhqIEokmtZ3vMsXRcpBEKBxYOY/fv2hzT4IDiYA7r2tl/2X
TUy2JIfDUCurLorwG9uceMeGzqtyrr+yzGF2lG611v5hlrlPN5o=
=3MoG
-----END PGP SIGNATURE-----

--=-gWjuyKNK/okN2SF580JR--

