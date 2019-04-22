Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D50C282E3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 02:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C9A20652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 02:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="bohB9EGc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfDVC7d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Apr 2019 22:59:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37895 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfDVC7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Apr 2019 22:59:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44nWWj1Br4z9s55;
        Mon, 22 Apr 2019 12:59:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555901970;
        bh=FtfZxyrpi6Q+aNCMTw+PugXDFpuP76Mfp11IEYIxrb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bohB9EGcLnX3Hm0s5KCRnSINgeGdPgzGoynR0mI2Yu7JnxjWwuVM9g87GjmoX/e7h
         Jhmkg53QAlRg22d4nyue+cRjyguyU2U+ZMrsNAq+QI8GYpRvn7lPthGUIUU1mAeddl
         ReSFX3V+VLEs0jeQ9cXe/1EYIUhvTQ5HCNHR5ed9serR6XnRqk/21+rkOfauhqUZF7
         7eM+23Iu8SQPzthBOJTh5VUbGO5H45PoofaiwMfeAhKjKZI0J9Ijy3FzJr99zJ7NdC
         jIt9OZUGT1vdtlYM6iOusDbyEv9MGeU7H08NC0FCflCZ6hYroJdeuXApxiNPaqEeGG
         krV861TkzkxFw==
Date:   Mon, 22 Apr 2019 12:59:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        <linux-next@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [linux-next] rtlwifi commit contains a patch reject file
Message-ID: <20190422125926.15862fdd@canb.auug.org.au>
In-Reply-To: <20190420155008.GM23044@windriver.com>
References: <20190420155008.GM23044@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FMG7rIUi7/.5Jw=V3/E=ouY"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/FMG7rIUi7/.5Jw=V3/E=ouY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Sat, 20 Apr 2019 11:50:09 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> I'm kind of surprised sfr doesn't have a bot to complain when it sees
> a foo.c.rej or foo.c.orig in a commit...

You mean like this:

Commit

  ddab2eee7949 ("rtlwifi: Convert the wake_match variable to local")

added this unexpected file:

  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej

I have added that test to my commit checks now.  Thanks for the
suggestion.  So far it only checks for .rej and .orig files - any
others?

--=20
Cheers,
Stephen Rothwell

--Sig_/FMG7rIUi7/.5Jw=V3/E=ouY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAly9Lg4ACgkQAVBC80lX
0GyVgQgAjbJ0frD4A4duxpv724dqn7i5Fox8RooH8Q/TFk5QjjNbgSJJksA5PZGz
Okv0DU/CuxQSV9sJgiKHvm9t/g2fi8Ojbw/Xg0bWmwlgppnr+V24HElOQq0ad7US
iA92QUrDSZxPEXqA3YuGtWRjCta5FHezII5HbU2p255qqficGiEijCFvrd/jJpph
90bwV8OQ/9laxzhjEmv6o3cnDVc2QBlai+FiDo8WQuC7N0g+HtBnuTH3UFx/QX3a
Y0hL+Km6z6TkGmY6BeV9VG8H/epR/gl9zK1GvWCBJ03QDdFtOPxi1eyvHFiucGYi
Sn1p3OBDdM1KuqCqYAda1SzOFHSGHA==
=8+tb
-----END PGP SIGNATURE-----

--Sig_/FMG7rIUi7/.5Jw=V3/E=ouY--
