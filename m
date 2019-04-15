Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8632BC10F13
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 02:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A1220645
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 02:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="EWY1iGKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfDOCI6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:08:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42415 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfDOCI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 22:08:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jBkZ3phtz9s55;
        Mon, 15 Apr 2019 12:08:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555294134;
        bh=Xzpnz0G5SbJIIery03VxJPBxt+OqGMtwpRc7d7Km5dM=;
        h=Date:From:To:Cc:Subject:From;
        b=EWY1iGKZwfY334ZQWBe00QclVhQyXJap377WuQP8I4rIwHe2MgohJves8jQKHKkbf
         8nIB5goW6LElPqfrCpBQi3LEqgRRouNwMfhlOqtykG/623c5EBzHhbks6qy9JHgczs
         d2gpBkouZPZNBZ+lAUPFPOHhDEb9GqqHmHZD0y/jN5FXvpCksKnnTDqSBb3RHTLWyK
         xPeNRH2p9g4Blu/URaL0HVkLLMyIwuxaRAc9Qwygs0AeN5pRNaAB6cS/0qDNWo+x3r
         yp8oTdVFvkOawYTPvNQxhbL1MbkAGo5IBjQ3evwlxNFVmxGOJI/poCCnIHU7Wpa2HJ
         Q3HuAjYEsIzKQ==
Date:   Mon, 15 Apr 2019 12:08:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20190415120853.39e0e46a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NXPNfRBIc4_Zh=Iruc5coyI"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/NXPNfRBIc4_Zh=Iruc5coyI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/pcie/drv.c

between commits:

  0d5bad14226a ("iwlwifi: rename structs to fit the new names")
  972d8e137779 ("iwlwifi: add new 0x2723/0x2080 card for 22000")

from the wireless-drivers tree and commit:

  ef8a913766cd ("iwlwifi: remove misconfigured pci ids from 22260 series")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 9f1af8da9dc1,0329b626ada6..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@@ -953,19 -953,15 +953,15 @@@ static const struct pci_device_id iwl_h
  	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
  	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 =20
 -	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl22260_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl22260_2ax_cfg)},
 +	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl_ax200_cfg_cc)},
 +	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl_ax200_cfg_cc)},
 +	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl_ax200_cfg_cc)},
 +	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl_ax200_cfg_cc)},
  	{IWL_PCI_DEVICE(0x2723, 0x1653, killer1650w_2ax_cfg)},
  	{IWL_PCI_DEVICE(0x2723, 0x1654, killer1650x_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x2080, iwl22260_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl22260_2ax_cfg)},
 -	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl22260_2ax_cfg)},
 +	{IWL_PCI_DEVICE(0x2723, 0x2080, iwl_ax200_cfg_cc)},
 +	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl_ax200_cfg_cc)},
 +	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl_ax200_cfg_cc)},
-=20
- 	{IWL_PCI_DEVICE(0x1a56, 0x1653, killer1650w_2ax_cfg)},
- 	{IWL_PCI_DEVICE(0x1a56, 0x1654, killer1650x_2ax_cfg)},
-=20
  	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
  	{IWL_PCI_DEVICE(0x7A70, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
  	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},

--Sig_/NXPNfRBIc4_Zh=Iruc5coyI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyz57UACgkQAVBC80lX
0GycRwf/TJ5j6jINo+rxZJmG/3J9ND8BMB4ej/SDCYiVCVv+7Og3CY1XcKRw8t5C
NPD9CwpFbPdIEiaxSVkml5UQyDOH7xdspodUyBxz8602E/0kGU/hmU4bFfqf5sa3
y3NNcSBeVd8tQcfcswhbtmT4aH5NKa2B277wpCCE31AmcSVNuArSGcjE0vpnZGvI
sPmz/Gc202aXdmJ3k3Q8i2hgwZ6J6ZF76dkJQskRhGua7oZTsBEpzmeTtmkg/1eL
pKuyn+d9wiwpX8kvhUXxVBvNXxvSQ3QF2hfJxCfHoaRI3aLD+E2TgCENLWIdw4H3
OLvHpCAHDkBRxPcy4783PjmaqyacGw==
=99KX
-----END PGP SIGNATURE-----

--Sig_/NXPNfRBIc4_Zh=Iruc5coyI--
