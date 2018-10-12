Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C812BC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B31820868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B31820868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbeJLQMF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:12:05 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57664 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727370AbeJLQMF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:12:05 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gAszx-0007nq-JB; Fri, 12 Oct 2018 11:40:42 +0300
Message-ID: <f39924d6bbc4621137cf70abe4bbfac0e5949f32.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 12 Oct 2018 11:40:40 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-pqFLjq5WRxLbnUtgo71c"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-10-12
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-pqFLjq5WRxLbnUtgo71c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fourth batch of patches intended for v4.20.  This includes
only the last patchset I sent.  Usual development work, mostly queue
handling cleanups.  More details about the contents in the tag
description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit abf1a08ff3237a27188ff8cc2904f2cea893af55=
:

  net: vhost: remove bad code line (2018-10-07 21:31:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-10-12

for you to fetch changes up to 724fe7710ac5f4289886b90060ed67e3a4bdd584:

  iwlwifi: mvm: kill INACTIVE queue state (2018-10-08 10:49:22 +0300)

----------------------------------------------------------------
Fourth set of iwlwifi patches intended for 4.20

* Support for a new scan type;
* Clean-up in the queue handling code;
* A few bug fixes;

----------------------------------------------------------------
Ayala Beker (2):
      iwlwifi: mvm: introduce a new fragmented scan type: fast balance
      iwlwifi: mvm: use fast balance scan in case of DCM mode with P2P GO

Johannes Berg (11):
      iwlwifi: mvm: give TX queue info struct a name
      iwlwifi: mvm: move queue management into sta.c
      iwlwifi: mvm: remove per-queue hw refcount
      iwlwifi: mvm: clean up iteration in iwl_mvm_inactivity_check()
      iwlwifi: mvm: move queue reconfiguration into new function
      iwlwifi: mvm: reconfigure queues during inactivity check
      iwlwifi: mvm: remove RECONFIGURING queue state
      iwlwifi: mvm: make queue TID change more explicit
      iwlwifi: mvm: make iwl_mvm_scd_queue_redirect() static
      iwlwifi: mvm: move iwl_mvm_sta_alloc_queue() down
      iwlwifi: mvm: kill INACTIVE queue state

Sara Sharon (3):
      iwlwifi: mvm: don't send keys when entering D3
      iwlwifi: pcie: don't pad AMSDU packets
      iwlwifi: trace: change trace to trace one TB at a time

Shahar S Matityahu (2):
      iwlwifi: dump debug data before stop device
      iwlwifi: mvm: move rt status check to the start of the resume flow

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c            |  27 +++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h            |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h |  30 +---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c            |  64 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h           |  54 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c          | 115 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           | 837 +++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h           |   8 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            |  34 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c         | 420 +------------=
-----------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |  28 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |  29 ++--
 13 files changed, 825 insertions(+), 831 deletions(-)

--=-pqFLjq5WRxLbnUtgo71c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlvAXggACgkQoUecoho8
xfpksQ//d+W7I8kI0EL0qBrSpT3J8rHJSoEtIBEHP1XgVGspneBBXzDGHbKAaRRW
kgAgpe6KDYI4eHo0wgSOr13jyt9T/qgxUSO3OepFcdc/dGZqHIUkFKMuFmvGN18o
5iBCW0E6Q4gzClU4pOR7DBtVeQUR5LjLHj9nqDRpQmdDVCBvdoKN1KAGIgwKYNMf
JW5zI28oAZ+/vTk0ZVCCjFhQQ1eGwsYlRtTltsRo6C8b1DSVa64yVVcYGbPBS08N
gcFZt+NAL0ssaC2wN4blvkdWcvHJ8x4ZITQwMA1nAhyVtCUC8FRWyy6HX8NiAVUm
t6QU9TTfc4tZAvI/r76vG/dPVO9MKMDqRal3wb4NMwaadMn2ai81dhMNUXMm2eMM
y/LJxf7/AzUbjifd+1bfQBXSWcc/o+0EGpfU7fCHuxgSF4RJhnUIVypUR8mc1b2h
A8/E0TApR2Is+w1tTp9phCyRxAWKjK6TJZk1BD5o8jxlepHE26QTTWz9YW8pkyX8
/lCllXHXyL5Sdr9YVDmKN9yET7GrhJcKnO2QvWyddO7pgzWAS9tiZIY7B5NrCTd2
Dafv3FXY5vW7GUXCBnmq0QXhO1tUkC3kaddEP2MaVM7ymvwCfXZ+ErXheCxuvUGu
jsE5o6BrzyLS+CZiUTwW8CjRLOMEQAPCcpRliSmNv7A3jCduv8k=
=sHY5
-----END PGP SIGNATURE-----

--=-pqFLjq5WRxLbnUtgo71c--

