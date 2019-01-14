Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DECC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 17:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C277206B7
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547487150;
	bh=zX1+LJJP2/4mdG5x/zp9ZwgHK2ni8a5le/ALKymGqNU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZgbD+6x4SxSaLtgxhvs/hHndpc1klMkzWxtRhvnISJCDPm29iWqnDggwVlAR4IRKz
	 5MmEjmyc1PgUz/8IhvdFPrd75K0GlsS6DTWWdco3I3t+8H1l2fOCiwX7/aJzG93i5m
	 pOpljPr7kuk9x55mbtmJYDoG7UqflriOshVZ1Bjg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfANRc3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 12:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfANRc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 12:32:29 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1EA20883
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547487148;
        bh=zX1+LJJP2/4mdG5x/zp9ZwgHK2ni8a5le/ALKymGqNU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gBlNuBGjOutUdClVOus8/z7zSw66G5sQu31nhnrCIU6nZ5KmkhNdv7daC/b/5ugu0
         nzU6/zv81074GnMTzYYR0j6z1lJPAQ7EdyM00gt9VtGgKkcXcT3ALjpvhvRxkQsjNh
         vTqMiWE0YR+fY4EepEvHzy/uUA5yyWezy1F2bOgc=
Received: by mail-qt1-f182.google.com with SMTP id y20so27407565qtm.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 09:32:28 -0800 (PST)
X-Gm-Message-State: AJcUukeC4U0ms66aDpeJSQiIwg4E4SPbnm9RQwTj4SmOnXuqJAm5eWB6
        eqLuCl6PxcwUvKZDEMiVn5WWRF2xaYEB2o0AdWU=
X-Google-Smtp-Source: ALg8bN4rr7xyga9W7SXRc7dWLR9GkkXs7wPunHNEHGWcmFKf+RdUUzavSsKq4SRMbYILpyekkZbjo5FeeGMBomychVU=
X-Received: by 2002:a0c:d6c2:: with SMTP id l2mr24365159qvi.97.1547487147914;
 Mon, 14 Jan 2019 09:32:27 -0800 (PST)
MIME-Version: 1.0
References: <52ec533a-bd4e-71b4-7bcd-8f2791dec564@suse.com> <CA+5PVA56=0x8r67SP1Z6x4QnSjm=Qz9GXjSXuCv+At9-C4kQWA@mail.gmail.com>
In-Reply-To: <CA+5PVA56=0x8r67SP1Z6x4QnSjm=Qz9GXjSXuCv+At9-C4kQWA@mail.gmail.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 14 Jan 2019 12:32:16 -0500
X-Gmail-Original-Message-ID: <CA+5PVA6T=YLF_5Dk-zm03_SaTwk+1DZVWURzgtJwjCdn0uSgHg@mail.gmail.com>
Message-ID: <CA+5PVA6T=YLF_5Dk-zm03_SaTwk+1DZVWURzgtJwjCdn0uSgHg@mail.gmail.com>
Subject: Re: [GIT PULL] Add NVRAM files for bcm43455 and bcm43430
To:     Matthias Brugger <mbrugger@suse.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        serge@raspberrypi.org, Phil Elwell <phil@raspberrypi.org>,
        Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 14, 2019 at 10:33 AM Josh Boyer <jwboyer@kernel.org> wrote:
>
> On Fri, Jan 11, 2019 at 7:11 AM Matthias Brugger <mbrugger@suse.com> wrote:
> >
> > Hi Josh,
> > Hi all,
> >
> > This pull request add firmware files neede by bcm43430 for Raspberry Pi 3 Model
> > B and bcm43455 for Raspberry Pi 3 Model B+.
> >
> > Please have a look and, if convenient, pull :)
> >
> > Best regards,
> > Matthias
> >
> > ---
> > The following changes since commit 0f22c8527439eaaf5c3fcf87b31c89445b6fa84d:
> >
> >   Revert "amdgpu: update vega10 fw for 18.50 release" (2018-12-18 15:38:53 -0500)
> >
> > are available in the Git repository at:
> >
> >
> > ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/matthias.bgg/linux-firmware.git/
> > tags/add-rpi-fw
> >
> > for you to fetch changes up to 930f276f8f1f2d83e44da6a32f4e0b2513db21a2:
> >
> >   brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B (2019-01-11 13:04:43
> > +0100)
> >
> > ----------------------------------------------------------------
> > - Add NVRAM for BCM43455 used by Raspberry Pi 3 Model B+
> > - Add NVRAM for BCM43430 used by Raspberry Pi 3 Model B
> >
> > ----------------------------------------------------------------
> > Matthias Brugger (2):
> >       brcm: Add BCM43455 NVRAM for Raspberry Pi 3 B+
> >       brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B
> >
> >  WHENCE                                      |   3 +
> >  brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt |  47 ++++++++++++++++
> >  brcm/brcmfmac43455-sdio.clm_blob            | Bin 0 -> 14036 bytes
> >  brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt |  82 ++++++++++++++++++++++++++++
> >  4 files changed, 132 insertions(+)
> >  create mode 100644 brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt
> >  create mode 100644 brcm/brcmfmac43455-sdio.clm_blob
> >  create mode 100644 brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt
>
> Pulled and pushed out.

I reverted commit fca5958287a3e5e0bd1676af0ca4fc2fb9704b42 as there is
some question around the clm_blob file an license applicability.  If
that gets resolved, please submit a new patch to add those files.

josh
