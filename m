Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D415C10F13
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 02:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B01206B6
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 02:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="T+p3m0JX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfDOCBi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:01:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40969 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfDOCBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 22:01:38 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jBZ66NG7z9s4V;
        Mon, 15 Apr 2019 12:01:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555293695;
        bh=8Uog2E3phY7eafl4Ib9Z8JYHzBDsbSpBGlSUvNTpWLY=;
        h=Date:From:To:Cc:Subject:From;
        b=T+p3m0JXAUa1VV8iwdQlr9J+AHbiHamxQtx2g9JvtCcM4Q1a/hhewATXa1Mnsk4VV
         0lzFiAcy1SSQd8bLESp8aH206Lslb7baFtKFUB/F+sUM4fYDrzbUJBJu5wSLGGqAVi
         EGOVuNZ6/3YsnkmlPWO/lpA0lSVrYgAZlHvHclURsVrrNiB1CFEGCtVF/QT7Ek81B+
         e9SSkCzhCpoRFz/LukZESxU0TgTASAvxC/hn00qiqgrC2UGYZXWUqs+HODgL2QDPQ0
         m+U9TeJF71Dsdri8Q7QBMXKFw4I06J7AUcRdpFX9oIKctorXLTE/S54E9Tw4EvHCSW
         FFoHT15ArltTg==
Date:   Mon, 15 Apr 2019 12:01:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20190415120133.40c0f343@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9dAKwPxUqEQEiYVHcHeRlGL"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/9dAKwPxUqEQEiYVHcHeRlGL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a conflict
in:

  drivers/net/wireless/intel/iwlwifi/iwl-trans.h

between commit:

  07d35b4270ef ("iwlwifi: use sync nmi in case of init flow failure")

from the wireless-drivers tree and commit:

  4b1831e48974 ("iwlwifi: dbg_ini: support HW error trigger")

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

diff --cc drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index d8690acee40c,2235978adf70..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@@ -830,6 -831,8 +830,7 @@@ struct iwl_trans=20
  	u32 lmac_error_event_table[2];
  	u32 umac_error_event_table;
  	unsigned int error_event_table_tlv_status;
 -	wait_queue_head_t fw_halt_waitq;
+ 	bool hw_error;
 =20
  	/* pointer to trans specific struct */
  	/*Ensure that this pointer will always be aligned to sizeof pointer */

--Sig_/9dAKwPxUqEQEiYVHcHeRlGL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyz5f0ACgkQAVBC80lX
0Gxj3QgAnyucsFp+xPAm2x2mpt5NXUExZvGL0TlsNnT1pLaD3sxGZz2XBhzCRmi3
yu3JuhmhSZzCr9mJO+rXHeTNmzK2mC2xWnxF9baWrKKlfEnYZ322v4UtT5reb08R
s0wRllXtuh9+VKVn88HNGg/6Ku9+PEccWl+D6EksoqB+iKQOkBKymu31cbntwIs5
GRZVvuVTD0Mo0HBBZX9i29iEdqQ8viioKZTJVFki3E4RZJJThwuKwqPglYZ3ChTs
2/5vbBnF5RCxh/WuDKEE/Rd7PASTVl/eMvraaJlCyPykw/T3JmHY5j+c6LSIWOm+
t/FC6zpzgvbB/0+kjJ46vvnCW1Fb+Q==
=exFE
-----END PGP SIGNATURE-----

--Sig_/9dAKwPxUqEQEiYVHcHeRlGL--
