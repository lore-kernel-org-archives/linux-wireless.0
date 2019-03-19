Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D546CC10F03
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9899A20850
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="eekPoUhm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfCSVQF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:16:05 -0400
Received: from ozlabs.org ([203.11.71.1]:51437 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbfCSVQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 17:16:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44P5Sf17DLz9s55;
        Wed, 20 Mar 2019 08:16:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1553030162;
        bh=E2wnzAReI1ubftwHCLcpe6Rlm+ZuHN9i1cLy4wUZBe8=;
        h=Date:From:To:Cc:Subject:From;
        b=eekPoUhmOSbZLE9DPk+jIfIZzcDuioPxjt6QEov2y9joSgpgBF9uYl+k+ktniMZE0
         tiNKpzm1LA2jibUgc1AYjHrPd4rPLigS4Xla/wkRMN+TZONpmd8NNDOoIFcqwBh+3/
         h1huPlPESdYUgZ941iWoaeoqDli1KqCyReL7O4F5VA+q2BHYZKZSwGiMtKjwymf9JS
         YfHxZ78h6JJsar1qZvMwoKDCSvxiHPi3HRlK71gQfxsobbvY/y2xWwFQdhNSqJje+S
         wkhXVY06bIsENwS4yMUl7rauuFbk4MM6Z/97TMXzLVI/KB8b4lSOJjGKZPOZKYWfp3
         EffD57ld1wMfw==
Date:   Wed, 20 Mar 2019 08:15:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190320081549.7112c33c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/618FRZgG7M0vaLQeL9_GrKU"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/618FRZgG7M0vaLQeL9_GrKU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  13f61dfc5235 ("mt76: fix schedule while atomic in mt76x02_reset_state")

Fixes tag

  Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on watc=
hdog reset")

has these problem(s):

  - Target SHA1 does not exist

Did you mean:

  004960423fe1 ("mt76: mt76x2: implement full device restart on watchdog re=
set")

--=20
Cheers,
Stephen Rothwell

--Sig_/618FRZgG7M0vaLQeL9_GrKU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyRXAUACgkQAVBC80lX
0Gxf9wf+JlXe6uuNvIIy847vnW2S26JD8fXZxuO8/hiNsfGjqH9q4OMjSjbT0V0U
meColBd+i51f0QTX7PBiaaRVx80/VZ8y3C2NhvDJ28ZFuyNFsf9lS8GL7HvArGYa
VfF5cEgcjR7ehJjO1hgfgKOGpBMvzhoWouxJFv1GQ5EAJxUAKZp/66E0uD9XR4dE
dJMpqdaCAVt+M8wqDdQyr4ArV0L14zoAxupOmpR9DvwcOu4TtHsKbIGYIlaXs4Ax
UvpyTMtJhwc56Pfq+q7gvWJ+AWqe6IJKgGip5Q7rdeXrNayDzfot8qIqFWJ1v3+N
tnD+KNDDbc+1+iYCSnom4K1wQ5K4KQ==
=GNw9
-----END PGP SIGNATURE-----

--Sig_/618FRZgG7M0vaLQeL9_GrKU--
