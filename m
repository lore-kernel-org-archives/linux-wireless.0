Return-Path: <SRS0=lllw=RN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E85BC4360F
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 19:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564992084D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 19:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wizzup.org header.i=@wizzup.org header.b="svjzZd1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfCJTUs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:20:48 -0400
Received: from nala.villavu.com ([188.165.243.101]:50304 "EHLO
        nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfCJTUr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Mar 2019 15:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizzup.org;
         s=mail; h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:
        References:Cc:To:Subject:Sender:Reply-To:Content-Transfer-Encoding:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=KgsJQM+U1u3RzhVTkHvQX4KPVXh3TLeOWUiTJEjb6b0=; b=svjzZd1wHejU3NthmaVeholnAn
        DfH9M5F/P6mMRXPQFkD4CfPHr8D+ZGSvD7/ijMLTvXrs3YuyFPF4xdgNNYjgilSqRuSaU7tvgWsYs
        NTy/8GGyJHRa6iM2Anc/ShkL9UiTMIOdm5KN/sNaADACHcwhvpbsSyFuqQi4/pkt46bsP+BBvP8Ar
        EFwSi7/TdoSCRXnix4FIOk8fw6ckb/SvhP2PuVzVlzPoFHd0lghUXg3ci+X+Wgf8XaQk03Yrwg/nB
        NLWBDpSDASNeNPyWQFeqcqZomSC/jrBwILpbpa8B1mkKjELkIa+2mNwaUMzBTGTy9ZtRYcZvzIsjX
        008p+p3A==;
Received: from a82-161-36-93.adsl.xs4all.nl ([82.161.36.93] helo=[0.0.0.0])
        by nala.villavu.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <merlijn@wizzup.org>)
        id 1h3403-0001lT-Fv; Sun, 10 Mar 2019 20:20:43 +0100
Subject: Re: Nokia N900: wl1251 spi3.0: EOW timed out on
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc:     linux-omap <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
References: <3819003e-2ab3-0325-de0d-9fa07b51ee9f@wizzup.org>
 <436a9a35-539a-3fe8-2225-36b45c7e5412@wizzup.org>
 <165d492e-435b-40a8-f784-5f2d08803514@ti.com>
From:   Merlijn Wajer <merlijn@wizzup.org>
Openpgp: preference=signencrypt
Message-ID: <1b2918b4-1765-5aba-4752-1d04bdfea925@wizzup.org>
Date:   Sun, 10 Mar 2019 20:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <165d492e-435b-40a8-f784-5f2d08803514@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4An5W0rzu4eZ1JGXKN0lH2xxU2O359vYZ"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4An5W0rzu4eZ1JGXKN0lH2xxU2O359vYZ
Content-Type: multipart/mixed; boundary="2ZZSGR0B291btdmnZREGnbu4O8UcrdOY1";
 protected-headers="v1"
From: Merlijn Wajer <merlijn@wizzup.org>
To: Vignesh Raghavendra <vigneshr@ti.com>,
 "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc: linux-omap <linux-omap@vger.kernel.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@kernel.org>,
 Pavel Machek <pavel@ucw.cz>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "broonie@kernel.org" <broonie@kernel.org>
Message-ID: <1b2918b4-1765-5aba-4752-1d04bdfea925@wizzup.org>
Subject: Re: Nokia N900: wl1251 spi3.0: EOW timed out on
References: <3819003e-2ab3-0325-de0d-9fa07b51ee9f@wizzup.org>
 <436a9a35-539a-3fe8-2225-36b45c7e5412@wizzup.org>
 <165d492e-435b-40a8-f784-5f2d08803514@ti.com>
In-Reply-To: <165d492e-435b-40a8-f784-5f2d08803514@ti.com>

--2ZZSGR0B291btdmnZREGnbu4O8UcrdOY1
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/03/2019 05:16, Vignesh Raghavendra wrote:
> Hi.
>=20
> On 10-Mar-19 6:23 AM, Merlijn Wajer wrote:
>>
>> Hi,
>>
>> On 10/03/2019 00:22, Merlijn Wajer wrote:
>>> Hi,
>>>
>>> I just migrated to Linux 5.0  (from 4.15) on my Nokia N900, and I'm
>>> getting a lot of messages like this:
>>>
>>>> wl1251 spi3.0: EOW timed out
>=20
>=20
> Could you try if this patch fixes the issue? This is part of latest mai=
nline tree but not part of 5.0:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dbaf8b9f8d260c55a86405f70a384c29cda888476

This seems to fix the issue. Would it make sense to queue this for an
upcoming fixes release for 5.0?

Cheers,
Merlijn


--2ZZSGR0B291btdmnZREGnbu4O8UcrdOY1--

--4An5W0rzu4eZ1JGXKN0lH2xxU2O359vYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQRM5LT7NbLF9yb6a/UGN09rynK8WgUCXIVkIAAKCRAGN09rynK8
WnkAAQCQ5LxFtM6fUlPxlz97ruW7Bmn6wgtOaXP15aWuNyBlSwEAw78y5s0Ap8mb
UlcR3FQ9iaPKvji170PUkYQgXOeCLAU=
=48NK
-----END PGP SIGNATURE-----

--4An5W0rzu4eZ1JGXKN0lH2xxU2O359vYZ--
