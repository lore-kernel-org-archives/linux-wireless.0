Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AC1C64EB4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 05:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345E320863
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 05:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="n3Pf+c1L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 345E320863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeK3Q6U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 11:58:20 -0500
Received: from ozlabs.org ([203.11.71.1]:57433 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbeK3Q6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 11:58:20 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 435k4b2X60z9s9J;
        Fri, 30 Nov 2018 16:50:07 +1100 (AEDT)
Authentication-Results: ozlabs.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1543557009;
        bh=j9PiqYbPq+XlwQJ7xgb8Gbd90qBM4FHaXL7OLqN5rf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n3Pf+c1L4s2eWp6d1UFjxm3M8XLXkCRBR8jyA7kRopZ2Dpv7oodkEqVsEui7tY09t
         2cO6EdpSC4EIpksp1yQWFy96rDrq/bbhoP9FQkXPFxjAn1KgfKxQtqSDs7g7J6NqPq
         //f1B2ZLqbXmkgsHmdlOIKsLqy9ZAEg6oFOndEsJsV9aFQBJdnhUo2DCZZXILvE9Fd
         XFhJjggsxSD344+sEkIK/nU0TenDeezBRtWKNp9kSiX2dbuCp3OeRq7VoJ9v/WKaOH
         sml90gaJvts5qKhUKGFWz3jF0FVlB+S0zo53wqUDjr0B/eS6B/lEzofQlxxeTv8ev3
         EkbGdO0vMp19w==
Date:   Fri, 30 Nov 2018 16:50:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: linux-next: build warnings after merge of the
 wireless-drivers-next tree
Message-ID: <20181130165006.60b2545f@canb.auug.org.au>
In-Reply-To: <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
        <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/a2CF3TbSIR18W7Y1n.ytmZo"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/a2CF3TbSIR18W7Y1n.ytmZo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Fri, 30 Nov 2018 06:33:47 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>
> I take it that -Wimplict-fallthrough is not enabled by default yet? So
> Dave and Linus won't see these warnings?

Correct.

> What I'm planning is to send a pull request to Dave today and fix these
> warnings in the next pull request. Does that sound good?

That sounds fine.

--=20
Cheers,
Stephen Rothwell

--Sig_/a2CF3TbSIR18W7Y1n.ytmZo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlwAz44ACgkQAVBC80lX
0GxIrwf/ZJtOZXL8kuiqTAcbsE005hRgfxjx74aCXNPTTa6ksvWFQowSRbySeLk0
aMLbO4eHn2KKeLwmimkZcRuE1/AzcLXsXLZktCeuqw+EDl9VN5S1OdS1Px5s3uba
EP/vMo70ltzWVMC5y5EI4wnhIVd3MMA9Corw6g0aLsX6ID+yULrKuyp5VPbqMLo8
sUXgHHKCkAtES976YJ7xuJuAe9plaR84fahVkDWjfeZ6PVYM/3njUxs8ty+YiZ+8
0tEaNU9QRHNGNVlyl3PBXyWLHz6PBBeyK5onC7CkoB6b2sE/9gg0S1dS9GZfbEGH
JwwABrV+rqOFmaUhwHA7FS/r/d2OuQ==
=82gj
-----END PGP SIGNATURE-----

--Sig_/a2CF3TbSIR18W7Y1n.ytmZo--
