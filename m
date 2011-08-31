Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:34040 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1HaTQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 15:16:46 -0400
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: linux-next-20110831 build failure in iwlwifi when IWLWIFI_DEBUGFS not set
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314818201_5176P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Wed, 31 Aug 2011 15:16:41 -0400
Message-ID: <41822.1314818201@turing-police.cc.vt.edu> (sfid-20110831_211721_243660_8002BAEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1314818201_5176P
Content-Type: text/plain; charset=us-ascii

Build error in linux-next 20110831:

drivers/built-in.o: In function `iwl_irq_handle_error':
iwl-trans-rx-pcie.c:(.text+0x100ee9): undefined reference to `iwl_dump_csr'
iwl-trans-rx-pcie.c:(.text+0x100ef5): undefined reference to `iwl_dump_fh'

Calling site is iwl-trans-rx-pcie.c, function iwl_irq_handle_error.

The functions are in iwl-trans.c, but hidden behind #ifdef
CONFIG_IWLWIFI_DEBUGFS so if that isn't defined, they don't get built.  The
call site already has an IWLWIFI_DEBUG ifdef, looks like iwl_irq_handle_error()
needs some tender loving restructuring.


--==_Exmh_1314818201_5176P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOXoiZcC3lWbTT17ARApwVAJ9zv+QZVHIkw5ChphnjXSsXkJrDzACg400b
YXuCfDOw4/DK2ibvUSUvWXc=
=G3Dw
-----END PGP SIGNATURE-----

--==_Exmh_1314818201_5176P--

