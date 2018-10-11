Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147FEC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 00:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1FE2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 00:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="QSHTpyEy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD1FE2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbeJKHiV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 03:38:21 -0400
Received: from ozlabs.org ([203.11.71.1]:33477 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbeJKHiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 03:38:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 42VrzX6hNnz9s89;
        Thu, 11 Oct 2018 11:13:44 +1100 (AEDT)
Authentication-Results: ozlabs.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1539216825;
        bh=+Kj3PyVpda87BUz5UeV51sF7qi5ZTt/2ellN9+1eCMg=;
        h=Date:From:To:Cc:Subject:From;
        b=QSHTpyEykuGY9TN/7xzkWyOVJoXPKh3/iIgTq8mL1D4hzh56RssloGFJQdMHCg4kR
         yfMvnQcGTrG9wiw5DMYqP6xxpBqWhqyjz5QGjBjMuJd5aHciWCsWZ8SanmUB1DZs0E
         K4hTI3VHJXxbjkLY8I/slQBHGp5GHKFMoX0UjiS4Wtant0yr/pmeeb7znXc3QjOelR
         uyYBv8kDCxp1FgR8E8NjLL+uuBIAL7bUUEyAnuABL2YKc8n41Xre7iDHKPzkdiIXzK
         cZPm1K6ucvPFF6OO7JyGAj5DdwEWoU9qZtUrpsxRKADlDqzxVLjCziEHhPn9pWWQiR
         ALYnL3mtVJb9Q==
Date:   Thu, 11 Oct 2018 11:13:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the crypto tree with the mac80211-next
 tree
Message-ID: <20181011111329.253f0689@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1fU=n.jS28rW_6ieTXIoUMm"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/1fU=n.jS28rW_6ieTXIoUMm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got conflicts in:

  net/wireless/lib80211_crypt_tkip.c
  net/wireless/lib80211_crypt_wep.c

between commit:

  b802a5d6f345 ("lib80211: don't use skcipher")

from the mac80211-next tree and commit:

  db20f570e17a ("lib80211: Remove VLA usage of skcipher")

from the crypto tree.

I fixed it up (I just used the mac80211-next versions of these 2 files
for now) and can carry the fix as necessary. This is now fixed as far as
linux-next is concerned, but any non trivial conflicts should be mentioned
to your upstream maintainer when your tree is submitted for merging.
You may also want to consider cooperating with the maintainer of the
conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/1fU=n.jS28rW_6ieTXIoUMm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlu+lakACgkQAVBC80lX
0GxdJQgAlKiwi2EZ37gu6hi9VDDMikpTOz/6GmWDkhFBa9RfHzAwfjBCFu26VKDS
pXF+/6rS9Hfmqi9HOMC58yuFbyZLzdhptUkjsutWIjK6mv8P9WPCvqAv8ykDaX8n
sORcqsB9NMJ/dmkjm47T8KDt/MuEbc6qEZeyyb2rGYGmDZcDajfrNJfpvxJpIUP1
NVFcMpSaa9lFftLzbBp/ljMRnMKXiV2vQLUoIo+mqCgnWWvkOgXQRKNRjLZV/wVN
1d9bIds3uNrOYUbm6hYr//38dPuY1iGCSz/U3cbWSV6pWvEDpJnMLIulA8MTwkFt
JzAUxhC5lLhVwRjytf9gIDLE/UpxMQ==
=cOtu
-----END PGP SIGNATURE-----

--Sig_/1fU=n.jS28rW_6ieTXIoUMm--
