Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647A1C64EB4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 01:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9282082F
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 01:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="gYPYNN/N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A9282082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbeK3MNn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 07:13:43 -0500
Received: from ozlabs.org ([203.11.71.1]:52031 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbeK3MNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 07:13:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 435bmz72Stz9s55;
        Fri, 30 Nov 2018 12:06:11 +1100 (AEDT)
Authentication-Results: ozlabs.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1543539972;
        bh=DmCSTm4+fE9JJAXIt9BHXbbNkpC/dE5JU+eOHwxwCdk=;
        h=Date:From:To:Cc:Subject:From;
        b=gYPYNN/NmbtS7cVN9k8Y5H/5RD1xP3PVD2F9MmA6flFItebCCAihC8mnVBeyNub7A
         aAZXKsSpvsaiMYZ0vE2sghHnhCxMdBty+UAWAs7TATn0KNjp21LRENk34PJtA2DddZ
         dZiJX7ceR24kfh46+uBdS2QGiP1hJ9Xa82piaxnynrLbvZ0tcXcQsgGfIopbFKqizh
         6hTXBRZd5kTDHfWccq9BWNq5dUNnzZHBbG5d1IPEm/0oDmrsBUGKvLMnLy39RuLJ2e
         vocMolNCvRjNCDXfyReR6UukBt2U2qvm/4XvHEvC3oDINRFA5qD9RJ26ZWMPvCxQy/
         /oFQIN5WZdHlA==
Date:   Fri, 30 Nov 2018 12:05:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: linux-next: build warnings after merge of the wireless-drivers-next
 tree
Message-ID: <20181130120555.1d35eb6b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5vQDyDlwVdeiPE8VRGqP7X8"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/5vQDyDlwVdeiPE8VRGqP7X8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(x86_64 allmodconfig) produced these warnings:

drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_parse_tlv_fi=
rmware':
drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    if (iwlwifi_mod_params.enable_ini)
       ^
drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
   default:
   ^~~~~~~
drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function 'iwl_parse_fw=
_dbg_tlv':
drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this state=
ment may fall through [-Wimplicit-fallthrough=3D]
    iwl_fw_dbg_copy_tlv(trans, tlv, true);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
   default:
   ^~~~~~~

Introduced by commit

  f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")

These are noted because I use -Wimplict-fallthrough

The warnings can be suppressed by adding a comment like
	/* fall through */
at the appropriate place to indicate that the fallthough is intended.

--=20
Cheers,
Stephen Rothwell

--Sig_/5vQDyDlwVdeiPE8VRGqP7X8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlwAjPMACgkQAVBC80lX
0GxD9gf/akxcHvNuNbGQK28xcmepUq9REkgKWl0+BRhByx0rlxak17GwBFxMa/qJ
sOZWsoIz9hItnKmDKVbk/uQX2TTVLV5i1iqNXx6YCwVdnMsosqYZmunWuFJr0WEm
yFgF2O5B/oqKDiT5YprCX9eFSO7TfG0Z8vxfof9F0HycIFSJzQYCC4nkiKH8dgYU
5nWxZK6gsTU4gDBGUjXE+QqQ5oi8Stn9Ldnfv8YIsJElyE7tndYhvyWZOpOgpKm/
6ACdrSPNsy3mn1j1L7ONR/x7ZmdHFo2qN+FFBANzxAerxCgRO7TFxiDJOs1WLkbS
iRstiLQCvXigJNShoInjdgSgHgjIcA==
=cF0/
-----END PGP SIGNATURE-----

--Sig_/5vQDyDlwVdeiPE8VRGqP7X8--
