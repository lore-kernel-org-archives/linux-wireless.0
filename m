Return-Path: <SRS0=TQ1a=2J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5FAC43603
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 20:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EA92467B
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 20:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="HDTi1jgP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLSUxo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:53:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:45803 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSUxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Dec 2019 15:53:44 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47f3xt71Npz9sPT;
        Fri, 20 Dec 2019 07:53:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576788822;
        bh=thEZ8+TIq/4CkTgwJRlNhuHKBZauyuVJG10sUq3nz3k=;
        h=Date:From:To:Cc:Subject:From;
        b=HDTi1jgPCJ6jhqPiSbGQoDt30KQd1NZ/8aAARkKIki0inQLgrkrOJhoaPD4plKmnZ
         9/Et0pJIqmglJdKT5/JZDpIjMG3upC7wjEdsVZ64Lc3Qv+PtLsl9cvlWDYW2HGaO5E
         Bz0sR2wzH434tK5Q+qm+ZcJgH6qwTt2DvrfJG/XSshcoq2HxcAAb8BEJx7ovQ9Q/9u
         qdAos4xsXOShLA8i9P/Q3HpViTI2Kj7Azn4GR8sOPMd1PSTNm0aekFBCWwM4Fhr7tD
         84zlHFVJwDKfXGHvnnmE75RZJwDhZyeeh7Lr2b53Mn0YhY7sZ9hABR3tx0aBuSzmpk
         wxOBRqDndZIsQ==
Date:   Fri, 20 Dec 2019 07:53:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        John Crispin <john@phrozen.org>
Subject: linux-next: Fixes tag needs some work in the wireless-drivers tree
Message-ID: <20191220075337.789971fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AUvgvsJBs9DVsQaxnHrwGYO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/AUvgvsJBs9DVsQaxnHrwGYO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  485add35771b ("ath11k: fix pdev when invoking ath11k_wmi_send_twt_enable_=
cmd()")

Fixes tag

  Fixes: e65a616f4e74 ("ath11k: add TWT support")

has these problem(s):

  - Target SHA1 does not exist

Did you mean

Fixes: 6d293d447670 ("ath11k: add TWT support")

--=20
Cheers,
Stephen Rothwell

--Sig_/AUvgvsJBs9DVsQaxnHrwGYO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3741EACgkQAVBC80lX
0GzipAf/dCAk2mG8RLsRH1OgmBrt3V59pJRa/7zFoCuVbOzmAgK2ac37axg1rcTb
RTLyIRaPuHK0FiaUSfLIe0yRxH/U2DBzzzp0GZjzwqlO5SiJ3oFK/GVDcFSn6FtF
weYq9YxrRWIvptCqT1JPz46sg3nGD/j9wQWiQZ+pO3bFam1NO+UpIbBFmBIjXdBg
aoQ1FXRuKyD7kCwt4nvSOPRZxxbeYCwRxk6yt16ZgpyVTCKom657FSRAUBrUdw+8
Wq9AHo6qaFjtcUE6dDb2NDtBDlCP6j8E6X/GMcLv6ibS5qQmzAP5Sj5SiWV8+HUS
y0QystK4Hd0jFSeKKfUqjMBs00fKrQ==
=p2gf
-----END PGP SIGNATURE-----

--Sig_/AUvgvsJBs9DVsQaxnHrwGYO--
