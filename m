Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD81C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AFA620B1F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="DnFUTVtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfAaUwR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:52:17 -0500
Received: from ozlabs.org ([203.11.71.1]:35487 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfAaUwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:52:17 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 43rC8q2LSPz9s4Z;
        Fri,  1 Feb 2019 07:52:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1548967934;
        bh=6ojlgWOipSNNpIltekx0oV48vVc446E2fvMonVyXl4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DnFUTVtF6QdHweq+3sXV5DY+yKgsQcIu3Xexj/GFxKtFih1QzQ2gnKfeKbW4ptc1i
         wFyTGGcIMyPZLIpISm82Tw/hmjtlJ24SWG9knlOlbliorgyQhUughp0WeAd/TPWRYk
         VSCyxbTDL8kvG+gtgg0DNpDE1S3o0RSs/ybuoxyZ4HLhPXwiG/8z/AzXJ9FrOBnqiD
         1H9bQt9MTl4s3Q9HTIoP/NpAhtacqdhcG94+7xRXYa/NFsyoz4gvzunCCWj1lnEZBW
         Jg+phXZ+yU6jgumFGC9rkO4UtJnwJuaS+umNKotGREf9NBPsS6YuKEKmmCeq/eKi5Z
         y/XNfZQ5Sm/uw==
Date:   Fri, 1 Feb 2019 07:52:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luca Coelho <luca@coelho.fi>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: build warning after merge of the
 wireless-drivers-next tree
Message-ID: <20190201075209.1a91a472@canb.auug.org.au>
In-Reply-To: <875zu5j5yc.fsf@kamboji.qca.qualcomm.com>
References: <20190131104626.62ff05ce@canb.auug.org.au>
        <9455f1b9e746f2c28d1573ccdce3836ece42cd8a.camel@coelho.fi>
        <875zu5j5yc.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F3jxl5ezEzL=gD4wT7YNFve"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/F3jxl5ezEzL=gD4wT7YNFve
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 31 Jan 2019 15:46:03 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Luca Coelho <luca@coelho.fi> writes:
>=20
> >
> > This was a conflict resolution damage in one of the patches I applied.=
=20
> > We already have a fix for it[1] and Kalle will apply it to wireless-
> > drivers-next soon.
> >
> > Sorry for the trouble, but somehow I didn't see this warning and
> > kbuildbot also reported successful compilation with it. :(
> >
> > [1] https://patchwork.kernel.org/patch/10788503/ =20
>=20
> I applied the fix now:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-ne=
xt.git/commit/?id=3D3864be551405b582ae38fbcdfdbb6e49052f5f6d

Thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/F3jxl5ezEzL=gD4wT7YNFve
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxTX/kACgkQAVBC80lX
0GyaOgf/UALlkaKxtkl5KQ27Sj7t8RCKTcyUuNwIIVKhBogm77UYD99n4FReTBhN
/EP6sGkQhZxgWPhYV3xOq6o+zTkfr7Yc93sQ00T+Ma8jyTOA9H77EUCJwU0E75fU
Bhm5bUa6zbcIwc3xzB2WtXRhbFsuGoipBjuvCT8QP64qBcmVpJknh6+kaiXETSSG
7XOIPpDFU0tPoBxfetGvvVMMoeQBQSgXgVJG64lXVdZtm/77XTCOVF2RofGXg7uk
FU3MBV7+GSXzQWfOaSkoxbhG804tLQ29l4/Gg0YQF99Fc0p/MhPlnTvvYzivs+el
49uycgwCs2uM4HT0G/e68Otm11vOqA==
=jtkV
-----END PGP SIGNATURE-----

--Sig_/F3jxl5ezEzL=gD4wT7YNFve--
