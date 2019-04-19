Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4FEC282E2
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 23:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058C12171F
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfDSXYv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 19:24:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54276 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbfDSXYv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 19:24:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hHMsO-00081j-Uw; Fri, 19 Apr 2019 09:19:57 +0300
Message-ID: <31cd1d98775748ed92c32dc6d298f1b2c5dc5e16.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Fri, 19 Apr 2019 09:19:55 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-kKFUbcg4ddULI7j3AD2K"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-fixes 2019-04-19
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-kKFUbcg4ddULI7j3AD2K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the third batch of fixes for v5.1.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 614c70f35cd77a9af8e2ca841dcdb121cec3068f=
:

  bnx2x: fix spelling mistake "dicline" -> "decline" (2019-04-15 17:23:09 -=
0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2019-04-19

for you to fetch changes up to c537e07b000bc00c9a5ac9d119ed2c8456a99b6e:

  iwlwifi: cfg: use family 22560 based_params for AX210 family (2019-04-18 =
15:06:44 +0300)

----------------------------------------------------------------
Third batch of iwlwifi fixes intended for v5.1

* Fix an oops when creating debugfs entries;
* Fix bug when trying to capture debugging info while in rfkill;
* Prevent potential uninitialized memory dumps into debugging logs;
* Fix some initialization parameters for AX210 devices;
* Fix an oops with non-MSIX devices;

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      iwlwifi: mvm: properly check debugfs dentry before using it

Johannes Berg (1):
      iwlwifi: mvm: don't attempt debug collection in rfkill

Shahar S Matityahu (2):
      iwlwifi: don't panic in error path on non-msix systems
      iwlwifi: dbg_ini: check debug TLV type explicitly

Shaul Triebitz (1):
      iwlwifi: cfg: use family 22560 based_params for AX210 family

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h         | 15 +++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 19 +++++++++++++---=
---
 7 files changed, 34 insertions(+), 16 deletions(-)

--=-kKFUbcg4ddULI7j3AD2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAly5aIsACgkQoUecoho8
xfp6NA//QEpO3WEDzh8x319lRI5spk/2s+A01aukqTYW9NqIYb2+gb+5qUFe9rq4
m6zitj5f5U3oQxUIozmMUCTH0e+D+n6uhDL/ygg3j6i+NoVAdiKl7HSqD9wqtd4C
BDY0O1cWKn+ZACL1YXBAiTn7Ta3xYCIj9Y5KKGd3IeYKTumJgdzC0/ohO6iAon0L
ah1X//bfpNbPbscikWGDq+H3KQJiUNm/kZs93QuHpvXYn/BMfBWeqg6Gg1ej/1Qj
7SXViWQY5EAVQi7mTezWvc15Y7PZzQhUTzIToaSsqpp6Cw4wLo8wLufQIAHeQX1P
ZA+cdvItG1yVKLNTvwCbYLMbwUEpEAQgE3A8oeIH8jhQkBcntKxRAggM+igyCcHG
1p4hoEULzYzw0rHfsW8MtZYZHVLXRS297dKTTF+nhelye0HFJGJ3biCBi+FlrOpi
4ct81Wmk6Co5/nCmkSSwd3XS/l2yDUnaa6btznD4bYse5cEaNAk04U0kfEOXGhXW
ZQ529wihdWpb0fz+ekzHKwPzQaeP3wDf6BClUryPmBDezhip+HdhqnKfx39MaFlM
dOSc/vnCE7Nl9sRPHNTRHY90WLuRohyHXGd89kMJ+Cmx/D3nz45uOQiznBuzXJDt
UJaVy74WA7tUn0MAFvZYUSpZT/htVBbJ0aouleWjfRuUD7B/mVU=
=RgOD
-----END PGP SIGNATURE-----

--=-kKFUbcg4ddULI7j3AD2K--

