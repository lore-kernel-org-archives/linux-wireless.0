Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C4FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 17:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E11218A2
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 17:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="mPv2fRN9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfCTRZ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 13:25:59 -0400
Received: from narfation.org ([79.140.41.39]:34132 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfCTRZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 13:25:59 -0400
Received: from bentobox.localnet (unknown [IPv6:2001:16b8:5523:5cf2:11e7:332b:14eb:c67a])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 881011100E9;
        Wed, 20 Mar 2019 18:25:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1553102756;
        bh=oHzKjOM8F8KMTckj/Z8/+vWnvIyYFWxN2xzBMtiJxPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPv2fRN9pcooZStMWqD156YG+w/SGGZSM6bFvy1ZO+MB5YVFrDk/6k25UFsvsDfOS
         YijklamzZipbRhFEXqBgnd0MhGf71eBWEap3cpSXPde5kZEe2uABTbifNDg0cQjdKo
         JuPvq38aK8lUKSvX45Y6TQKDvtdVtxbQMUxU+GIw=
From:   Sven Eckelmann <sven@narfation.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Differentiate between max combined and per chain power
Date:   Wed, 20 Mar 2019 18:25:43 +0100
Message-ID: <1693082.M5RyE5W9Oo@bentobox>
In-Reply-To: <CAKR_QV+eHK4FN6V5aduS9vc8Zd2kbK5Ry3NO35Q1BwY58arZug@mail.gmail.com>
References: <20190320103723.27228-1-sven@narfation.org> <CAKR_QV+eHK4FN6V5aduS9vc8Zd2kbK5Ry3NO35Q1BwY58arZug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2242750.p2HVIC31lz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart2242750.p2HVIC31lz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, 20 March 2019 14:49:57 CET Tom Psyborg wrote:
> On 20/03/2019, Sven Eckelmann <sven@narfation.org> wrote:
> 
> > This also means that a device with multiple tx chains is even limited
> > further:
> >
> > * 1 chain:  31 dBm per chain
> > * 2 chains: 28 dBm per chain
> > * 3 chains: 26 dBm per chain
> >
> 
> This is flawed theory and should be reverted instead of making further
> complications. Simplest way would be to remove
> POWER_CORRECTION_FOR_TWO_CHAIN and POWER_CORRECTION_FOR_THREE_CHAIN;
> from driver

You can of course propose a patch for that. But I will not participate in the 
discussion how EIRP should be measured (per antenna/per system, on max point/
via integral over all positions, ...).

And you should also discuss it with QCA to find out whether they will also 
remove the power correction from their closed source firmware. At least it 
would also affect ath10k... maybe even their other drivers with closed source 
components.

And your change would also not completely supersede my change. You forget that 
the antennagain reduction is also done by scaled ath9k_hw_get_scaled_power.

Kind regards,
	Sven
--nextPart2242750.p2HVIC31lz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlySd5cACgkQXYcKB8Em
e0Y8FhAA1dP+Tj72QHRSaJgmQbDxAljz6n+ArmlBFTIfaXq+sxeq5egL+MHxxAoK
5bzEj1F5WfjnueVLWoq+V9SAIW8B8ABmlfjxNUHbHtb+n4mVTmX/aZe9JFXSOhER
bh8c83CSYKnQQtuPqZk/dkjfJHJbRrNysLIKDXBZvXVYGqSfgyXt+WLLRdRVKgwl
BaCoAO0qyIm2NiThAIkDzaD5+zAaGa0uYfPyLFXSZYZNcnxxSsE3AvMdHcxkZY/7
ZL8eeiUZPsPBIrBYtS7jRMMw/cSH1NIlZXpL+EoZoPTjia5kEFkf5sIfc+RvW+EY
CoS/qiXSfSlS/Bx40e1+0rubVVUSuNoWsDY2GISHU1LW0HLQxj0Gj/oM3aBQio4G
AZm4bys9u6SDmJRyYQ7MZq7mg1JMs4o+KN15Js82oscx1kXy0/iCJQ/XOivV75Z4
Sq9aPFSUbkjRv5iy7ZDuAc0W2Mv8XB3e65BtCMNbMxBDfb/0F0pdrSUJHsXsEIya
NYAKxFiAEbWUwGGmWat946qPB5OSjVgNGbz/qOHowOV8ePe+o9gdYX1eorHDmWsr
ALV2o7kw/ms+z6s2/dW1RA0p/Jn2tR93l4vUqDfZ1R2UN0+O36X26B5xMTRhbbwM
fNvXfPJftpT9diu3fFDyY1N0mTgb80ahKiKLqyS5lMFcawllpL4=
=GQU8
-----END PGP SIGNATURE-----

--nextPart2242750.p2HVIC31lz--



