Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EC9C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 02:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2AD921871
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 02:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="b16DoCVj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbeLSCrm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 21:47:42 -0500
Received: from ozlabs.org ([203.11.71.1]:40175 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbeLSCrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 21:47:42 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 43KK7G4SJtz9s3Z;
        Wed, 19 Dec 2018 13:47:38 +1100 (AEDT)
Authentication-Results: ozlabs.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1545187658;
        bh=IpeRx4gph3CXq7aaM0Eo08yXTCbN8qa0eNNpstZdvWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b16DoCVjeanDQZaGj2QYhSQ+OxC991QaLvNOvNaL0IlH8TH0g8OoBFKQyVrK17wLK
         STgke0Kfz6Mv95/BOwxYnobzuxxMHrU7VQXiH2YIa1e4E7v8FospLSHUoKDIdpdEBQ
         BBb2hDEy3mae7OfKiJTRdvwInPvx6ov3Cmt/OgHDy3HihrQ93TBid1HccMbHIYffyO
         lBa95SCBANk4Rfhwp/zOzSY4qKkb3BPr5WUrKqoB2trgIR2nuWspmgwBTWXNy8JVVP
         gwglG6GNWRZJyGz+fEtKMKRnoHcH0yIWvDALweDl3Noj4BycLQmHSLTlrXR0pNrs7A
         4IyW73oUmPmVw==
Date:   Wed, 19 Dec 2018 13:47:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the
 wireless-drivers-next tree
Message-ID: <20181219134738.4efed34f@canb.auug.org.au>
In-Reply-To: <20181130120555.1d35eb6b@canb.auug.org.au>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.Ln/vvvD5+uehjVwFMF=H+m"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/.Ln/vvvD5+uehjVwFMF=H+m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 30 Nov 2018 12:05:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) produced these warnings:
>=20
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_parse_tlv_=
firmware':
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this statem=
ent may fall through [-Wimplicit-fallthrough=3D]
>     if (iwlwifi_mod_params.enable_ini)
>        ^
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
>    default:
>    ^~~~~~~
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function 'iwl_parse_=
fw_dbg_tlv':
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this sta=
tement may fall through [-Wimplicit-fallthrough=3D]
>     iwl_fw_dbg_copy_tlv(trans, tlv, true);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
>    default:
>    ^~~~~~~
>=20
> Introduced by commit
>=20
>   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
>=20
> These are noted because I use -Wimplict-fallthrough
>=20
> The warnings can be suppressed by adding a comment like
> 	/* fall through */
> at the appropriate place to indicate that the fallthough is intended.

I am still seeing these warnings (but in the net-next tree now) and I
do not see a fix patch in the wireless-drivers-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/.Ln/vvvD5+uehjVwFMF=H+m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlwZsUoACgkQAVBC80lX
0Gy5xgf+I5Szsum5v2pCc9Enp1aQ+dR+lHqCHb5FjWdzJO/YjVLRIAQWc4n/i5dQ
xT1ycuy0n9Qr2ADsWdCqeTpEeTY559Idpp9TLylQWMu+yTf8Y+KFYeMIO+vecTcu
Qb9YC76QRf9HuWCDupWZondywRQwzHaVrByvF4n0tKc8J3WQSDZcMfpjHz6K2Q4T
NeLQFNjF2bL9t1B5x+pVy+w9WxvCfbXdfCTsyFiQ2w1x4++mJRFpOHWoIx4FVCXj
9xcK8QLWJxMElapC8ZWf7NynDAIJ0sjeVK8Di7tn8mVOVYEphlFv0BJecP3A9eTj
2AiTcVM+7FuYEFAN4/CZHXonr9V9JQ==
=asyU
-----END PGP SIGNATURE-----

--Sig_/.Ln/vvvD5+uehjVwFMF=H+m--
