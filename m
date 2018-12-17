Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDC3C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 10:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EA242133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 10:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvdQ8JpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbeLQKfN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 05:35:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40772 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbeLQKfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 05:35:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id p4so11691434wrt.7
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+nymttKAS5sdylnY/Ge9wAt+Ga/f7Dwz3Lvq7qHZRt0=;
        b=BvdQ8JpU6CmzHLcmpwxRwZmE/UTV89IutnUXknNdXfJ5vRh0xo2aZWObO/NwR7Hfsc
         P29uqr8XDCUyS7dhO4bfiRCVBEbTWnz1iMLf8EhaIzC2FonwB/Ss8DjBHi79R4d95JHi
         a5BudFq0RWwOy28lB54k7lSRcekIHwsJ5PFypkeUv7ZHLFY/qyX4QZwZpXZGg68qXVDW
         cDyVnatjq+ZaT8ibDYYBJqml/LDZOMphz8q+4r8dVgxPoRqg54QGdJByH2cOU+K011h/
         o04gCPEsWlzhw8Cijs/Do5IOzGARzZh8BlI3YqG0w+OV5AaVmWlu2Pzf/8F72+MK/22/
         q0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+nymttKAS5sdylnY/Ge9wAt+Ga/f7Dwz3Lvq7qHZRt0=;
        b=HSgbnHsMJPavfcnD+SMXb+n9RxJvwPMxmwmUmlCVRTo45ImdFQGrn9IsoU/4y/ZiQI
         s7/UDwRJRIRLYwyrMC4+aDTOdEuT520OD1mTRFO+uVStf49hI/UAX/nD5bAb8x5zWb8N
         ifO8sL5pUH3+n700EM3lLEZ3AktMUiuOlt64h6t1KrDInzcSfbQnJw2L0kNBMmAlSET/
         qeQnMQ1ax2Qp50czeUli2cpg7yh/klsbfBrYt/BVG5g9KjV6D9rvVG7oTqZaK27qkKfI
         R/eooRGbbT5pZG3j8tBJV/zyyw4J2du6QtBOTs+Jfhb0ZkSIjiJ5y6CEcSi6MXm5TDgD
         HCEA==
X-Gm-Message-State: AA+aEWYyowxOWuCE2+ETJYDJlCtFfKFVY4uT1To/c3leHJdfcw3T7MsU
        OtTh+HfZpKQitx5nChbcGYpkrFHDbfoSDkRajac=
X-Google-Smtp-Source: AFSGD/U2H76LZUt6WHfGI9LL5E4aMZ67bzj+Bzd9Kkw+1p/A025gtu+26GDq/mmJTfR+RRsDAYRntPgHmfcV3Vfsw7M=
X-Received: by 2002:adf:94e4:: with SMTP id 91mr10755814wrr.322.1545042910985;
 Mon, 17 Dec 2018 02:35:10 -0800 (PST)
MIME-Version: 1.0
References: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com> <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
In-Reply-To: <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 17 Dec 2018 11:34:59 +0100
Message-ID: <CACna6rwh9ri2ZfpTjCjZo3mBv0B3tr3Diesw3HJG+5ZVnAZxCQ@mail.gmail.com>
Subject: Re: [PATCH] brcm: provide new firmwares for BCM4366 chipset
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Josh Boyer <jwboyer@kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 15 Dec 2018 at 12:03, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 12/14/2018 2:02 PM, Josh Boyer wrote:
> > On Wed, Nov 7, 2018 at 3:45 PM Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >>
> >> These firmwares are for the BCM4366 3x3 802.11 ac chipsets, which also=
 comprise of BCM4366E or BCM43664 devices. Signed-off-by: Arend van Spriel
> >
> > This didn't add brcm/brcmfmac4366c-pcie.bin to WHENCE.  I'm assuming
> > it's under the same license as the rest of the brcmfmac files?  If so,
> > I can just amend the patch.
>
> Hi Josh,
>
> I was not sure this patch ever made it through. It did not appear on
> linux-wireless list probably due to exceeding a size limit. So I resend
> it as two patches on December 10th. However, I indeed forgot to update
> the WHENCE file in that series as well. Indeed there is no license change=
.

Unfortunately I have only 1 device with 4366B1 (D-Link DIR-885L) and
it seems to have dummy NVRAM restored from the bootloader's copy:
1:ccode=3DALL
0:regrev=3D0
0:ccode=3DALL
1:regrev=3D0

1) Old fw 10.10.69.3309 (r610991) FWID 01-c47a91a4
2 GHz: very weak signal (about -79 dBm)
5 GHz: good signal & works stable
(this also matches vendor firmware behavior)

2) New fw 10.28.2 (r769115) FWID 01-801fb449
2 GHz: very weak signal (about -79 dBm)
5 GHz: good signal but huge packet loss

So the new firmware introduces 5 GHz regression for me, but I guess I
should not complain since my device seems to come with a missing NVRAM
regulatory info.

Is there any chance you know a correct ccode + regrev for D-Link
DIR-885L for any region?

--=20
Rafa=C5=82
