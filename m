Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1819FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 09:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E502F2175B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 09:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfCTJpK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 05:45:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36712 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfCTJpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 05:45:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id y13so1970281wrd.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2019 02:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/5Jq/1A4wnNU45uP0a2SlC5SWn4VZjmGVVWgkyU8b6Q=;
        b=WWiHEWVp5YwiuM/BYWMuwC+IFgzERZu6Qm10t42x5TAt3kbrtSYGZyDOcS7TjU2y+u
         UzjUet0rIKgM2+b56U5LOuXZtOgnVjzQp+T2EGBXV4n+5GllGBygtYBC6a/UShq8rY9s
         lSGYhMEdaDE6BJNLQbR/Su1H7pDaxdc37490KXWRtqjoBhGpqTDEhbOhTaSmD2K9xtFW
         IMYdX0FT6i/oYkPcP0JgdFRXJXplKcQmU3Gx4LJGwMUMTt9+H9PWN64vxrZzKRTqYLwU
         ka+HM6MMMbkFXYRS/0wNyhoMcPqjJCKQKeLr6t+Wl66k7zftCuL4KpNj+1KHh3bvDqsW
         +CUQ==
X-Gm-Message-State: APjAAAUCxekojDp19GrLQ7bWQc1Eb0Tf7I6roWzUwwliN+5wQLIEiiIK
        H52DqGssEURJb8bvp84UcTcw9Q==
X-Google-Smtp-Source: APXvYqzII/fmq2lFyYDmCPW3x4gl3JslO9q1l87eIxW6hq+HHlFlkhJTlM2Tth2VSEq8y9DUCy8RPg==
X-Received: by 2002:adf:90af:: with SMTP id i44mr20781788wri.222.1553075108830;
        Wed, 20 Mar 2019 02:45:08 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o10sm1234925wrx.82.2019.03.20.02.45.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 02:45:08 -0700 (PDT)
Date:   Wed, 20 Mar 2019 10:45:05 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190320094504.GA16193@localhost.localdomain>
References: <20190320081549.7112c33c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20190320081549.7112c33c@canb.auug.org.au>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi all,
>=20
> In commit
>=20
>   13f61dfc5235 ("mt76: fix schedule while atomic in mt76x02_reset_state")
>=20
> Fixes tag
>=20
>   Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on wa=
tchdog reset")
>=20
> has these problem(s):
>=20
>   - Target SHA1 does not exist
>=20
> Did you mean:
>=20
>   004960423fe1 ("mt76: mt76x2: implement full device restart on watchdog =
reset")

Hi Stephen,

yes, the right Fixes tag is:
004960423fe1 ("mt76: mt76x2: implement full device restart on watchdog rese=
t")

Sorry for the mistake.

Regards,
Lorenzo

>=20
> --=20
> Cheers,
> Stephen Rothwell



--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJILnAAKCRA6cBh0uS2t
rLs1APsHBqDbJ8Dnrh33NzyBoydGceQK5C9X0KLG7NNv2zDm+AEA2CUnUhrv+gGQ
4h9qAzCppfRa+tbcAkyvr+pprstOPwE=
=0ehf
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
