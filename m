Return-Path: <SRS0=D8BG=56=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2779FC38A29
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 22:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4FC2076A
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 22:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="q1+fhQ7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634136AbgDNWIj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Apr 2020 18:08:39 -0400
Received: from ozlabs.org ([203.11.71.1]:37221 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbgDNWIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Apr 2020 18:08:36 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49204H63Clz9sSd;
        Wed, 15 Apr 2020 08:08:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1586902112;
        bh=WKpUgiPoFV6JdQ9oLMsXNxlqFTV0n+/7rq4xiZLMIvI=;
        h=Date:From:To:Cc:Subject:From;
        b=q1+fhQ7mLP/pDfQkFp3FsfppKUNn3J5a3h4xkv5EfkMDi3SIeTWdkN9FLsFjrs4qy
         Varbn/IsROsVI+C/3KjzbXCjJRble93hU9HBIdbRvc44q3oSA2AbG0s8TBBQBxhj5l
         yzwDMzbVGnHQ6a42agpLS02mORYUyB15wQyJX8pi/bom0RpG9v5eBIHG7s8Jeeh/z5
         Xe/aDcpLzgVGjMeDpXfrZ6ImeenuNYQv/IOnEzTWc215G9H9TgVlY7rPyn4kxNjTs1
         yA5NACsVmSdZdqG+QSHuaxLP3juB2jtfnykVpuoVQ1aKTCc1BGzzhktkO8e2lWrenw
         sd/5WiBxAlyBw==
Date:   Wed, 15 Apr 2020 08:08:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: Fixes tag needs some work in the wireless-drivers-next
 tree
Message-ID: <20200415080827.30c2c9c1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9Cgl.5rAq_5Va.lomBnmNSa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/9Cgl.5rAq_5Va.lomBnmNSa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ec4d3e3a0545 ("b43legacy: Fix case where channel status is corrupted")

Fixes tag

  Fixes: 75388acd0cd8 ("add mac80211-based driver for legacy BCM43xx device=
s")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/9Cgl.5rAq_5Va.lomBnmNSa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6WNFsACgkQAVBC80lX
0GwBpwf9GTBWa6briKFg+vjJrtYfiGiCz0b4KJxf4PPeMxdTy8hXYnGPLehOwvPG
2f5wT99wXGk3DktQDM0uMxCY7JnP/RHwMAC6kBwsxCaofAV3CWzACjOFDjUFVd/2
WaSQV98Uq87aEv9T840M4ZQulYi5gfxEqwLLTydbdDkalvGFCNdIMiIWPajo6k30
/nieyC3q2loQtHyvjGErD0px+fZ0tThWH1FucEus97SIhY+47wHndiX6rAT0/zuv
9gCy36TW/B+FW3mAn0sSbiZFlMc6hI/arMTxSMA5ocHkFDEJEJ3MDNbSCr0FEcp7
X7y0UzM86qVQVnG7xDF56Mw+EJxSew==
=m/fh
-----END PGP SIGNATURE-----

--Sig_/9Cgl.5rAq_5Va.lomBnmNSa--
